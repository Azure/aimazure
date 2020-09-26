using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Builders;
using Microsoft.AzureIntegrationMigration.Core.Clients;
using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Enums;
using Microsoft.AzureIntegrationMigration.Core.Exceptions;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.FunctionApp.RoutingManager
{
    /// <summary>
    /// Azure Function that works out the next route from a Routing slip, and sends the current message to that route, returning any response.
    /// </summary>
    public static class SendToNextRoute
    {
        /// <summary>
        /// Default prefix to add to log messages.
        /// </summary>
        private const string LogId = "SendToNextRoute";

        /// <summary>
        /// Entry point for the function.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance containing the received request.</param>
        /// <param name="scenarioName">Name of the scenario we're routing for.</param>
        /// <param name="routeIndex">Current route index.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
        /// <returns><see cref="IActionResult"/> instance with results.</returns>
        [FunctionName("SendToNextRoute")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "sendtonextroute")]
            HttpRequest req, ILogger log)
        {
            // Get Request Details
            RequestDetails requestDetails = new RequestDetails(req, LogId);

            string logPrefix = $"{LogId}:{requestDetails.TrackingId}: ";

            // Add the tracking ID to the Response Headers
            if (!string.IsNullOrWhiteSpace(requestDetails.TrackingId))
            {
                req.HttpContext.Response.Headers[HeaderConstants.AimTrackingId] = requestDetails.TrackingId;
            }

            log.LogDebug($"{logPrefix}Called with parameters messageContentType: {requestDetails.RequestContentType}, messageContentEncoding: {requestDetails.RequestContentEncoding}, messageTransferEncoding: {requestDetails.RequestTransferEncoding}, headerTrackingId: {logPrefix}, clearCache: {requestDetails.ClearCache}, enableTrace: {requestDetails.EnableTrace}");

            // Validate the request
            IActionResult result = ValidateRequest(requestDetails, logPrefix, log);
            if (result != null)
            {
                return result;
            }

            log.LogDebug($"{logPrefix}Request parameters are valid");

            // Attempt to load the envelope
            Envelope envelope;

            try
            {
                log.LogDebug($"{logPrefix}Parsing the request body as an envelope");
                envelope = new Envelope(requestDetails);
                requestDetails.UpdateTrackingId(envelope.TrackingId);

                // Add TrackingId header
                if (!string.IsNullOrEmpty(logPrefix) && req?.HttpContext?.Response?.Headers?.ContainsKey(HeaderConstants.AimTrackingId) == false)
                {
                    req?.HttpContext?.Response?.Headers?.Add(HeaderConstants.AimTrackingId, logPrefix);
                }
            }
            catch (Exception ex)
            {
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to parse the received envelope message", ex, logPrefix, log);
            }

            // We need a ScenarioName
            if (string.IsNullOrWhiteSpace(envelope.Scenario))
            {
                // Missing ScenarioName
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "ScenarioName cannot be found in the request body", logPrefix, log);
            }

            // Check we have a routeIndex
            if (envelope.RouteIndex == null)
            {
                // Invalid RouteIndex
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "RouteIndex is blank or not a number", logPrefix, log);
            }

            // RouteIndex must not be a negative number
            if (envelope.RouteIndex < 0)
            {
                // Invalid RouteIndex
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "RouteIndex must be 0 or greater", logPrefix, log);
            }

            // Check if we have any routes
            if (envelope.Routes == null)
            {
                // No routes to process - return an ACK
                log.LogDebug($"{logPrefix}No routes to process - returning an ACK");
                return new OkObjectResult(EnvelopeBuilder.BuildAckEnvelope("No routes to process", null, logPrefix));
            }

            // Check if we're past the last route
            if (envelope.NextRoute == null)
            {
                // No more routes - return an ACK
                log.LogDebug($"{logPrefix}Have processed all routes - returning an ACK");
                return new OkObjectResult(EnvelopeBuilder.BuildAckEnvelope("Finished processing all routes", null, logPrefix));
            }

            // Get the full RoutingSlip (including the routing parameters) from App Configuration
            JObject routingSlip;

            try
            {
                log.LogDebug($"{logPrefix}Getting the full RoutingSlip from config");
                routingSlip = await new ApimRestClient(requestDetails).GetRoutingSlipAsync(envelope.Scenario);
            }
            catch (AzureResponseException arex)
            {
                // Exception occurred
                return AzureResponseHelper.CreateFaultObjectResult($"An AzureResponseException occurred calling APIM to get a RoutingSlip for scenario {envelope.Scenario}", arex, logPrefix, log);
            }
            catch (Exception ex)
            {
                // Exception occurred
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred calling APIM to get a RoutingSlip for scenario {envelope.Scenario}", ex, logPrefix, log);
            }

            // Get the array of routes
            JArray routes = (JArray)routingSlip?.First?.First;           

            // Get the current route
            JObject currentRoute = routes[envelope.RouteIndex] as JObject;
            if (currentRoute == null)
            {
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"Unable to find the current route, with routeIndex {envelope.RouteIndex}", logPrefix, log);
            }

            // Get the route parameters
            JObject routingParameters = currentRoute["routingParameters"] as JObject;
            if (routingParameters == null)
            {
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"Unable to find any parameters for the route with index {envelope.RouteIndex}", logPrefix, log);
            }

            // Get the message receiver type
            string messageReceiverType = routingParameters?["messageReceiverType"]?.ToString();
            if (string.IsNullOrWhiteSpace(messageReceiverType))
            {
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"No MessageReceiverType is set for the route with index {envelope.RouteIndex}", logPrefix, log);
            }
            log.LogDebug($"{logPrefix}Next route MessageReceiverType is {messageReceiverType}");

            JObject routeParameters = routingParameters?["parameters"] as JObject;

            // Increment the routeIndex
            envelope.IncrementRouteIndex();

            // Switch by messageReceiverType
            switch (messageReceiverType.ToLower())
            {
                case "microsoft.workflows.azurelogicapp":
                    {
                        log.LogDebug($"{logPrefix}Calling the next route LogicApp");
                        return await RouteToLogicApp(envelope, routeParameters, requestDetails, logPrefix, log);
                    }
                default:
                    {
                        return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"Unsupported MessageReceiverType value of {messageReceiverType}", logPrefix, log);
                    }
            }
        }

        /// <summary>
        /// Validates that the request is valid.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance containing additional request details.</param>
        /// <param name="logPrefix">Logging prefix to use.</param>
        /// <param name="log"><see cref="ILogger"/> instance used for logging.</param>
        /// <returns><see cref="IActionResult"/> instance or null if request is valid.</returns>
        private static IActionResult ValidateRequest(RequestDetails requestDetails, string logPrefix, ILogger log)
        {
            // Check that ApimInstanceName is set
            if (string.IsNullOrWhiteSpace(requestDetails.ApimInstanceName))
            {
                // No ApimInstanceName set in config
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "No ApimInstanceName is set in config", logPrefix, log);
            }

            // Check that ApimSubscriptionKey is set
            if (string.IsNullOrWhiteSpace(requestDetails.ApimSubscriptionKey))
            {
                // No ApimSubscriptionKey set in config
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "No ApimSubscriptionKey is set in config", logPrefix, log);
            }

            // We need a Body
            if (requestDetails.RequestBody.Length == 0)
            {
                // Invalid body
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "A request body must be supplied", logPrefix, log);
            }

            // Request ContentType header must be supplied
            if (string.IsNullOrWhiteSpace(requestDetails.RequestContentType))
            {
                // Missing ContentType
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "Content-Type header must be supplied", logPrefix, log);
            }

            // Request ContentType must be JSON
            if (!requestDetails.RequestContentType.ToLower().StartsWith("text/json") && !requestDetails.RequestContentType.ToLower().StartsWith("application/json"))
            {
                // Invalid ContentType
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"Content-Type header must be text/json or application/json - instead it has an unsupported value of {requestDetails.RequestContentType}", logPrefix, log);
            }

            return null;
        }

        /// <summary>
        /// Sends the envelope to a LogicApp and returns the response, as an <see cref="IActionResult"/> instance.
        /// </summary>
        /// <param name="envelope"><see cref="Envelope"/> instance containing the envelope.</param>
        /// <param name="routeParameters"><see cref="JObject"/> instance containing the route parameters.</param>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance containing details about the request.</param>
        /// <param name="logPrefix">Logging prefix to use.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
        /// <returns><see cref="Task{IActionResult}"/> instance.</returns>
        private static async Task<IActionResult> RouteToLogicApp(Envelope envelope, JObject routeParameters, RequestDetails requestDetails, string logPrefix, ILogger log)
        {
            // Get the ResourceId
            string resourceId = routeParameters["resourceId"]?.ToString();
            if (string.IsNullOrWhiteSpace(resourceId))
            {
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"No resourceId is set in the parameters section for the route with index {envelope.RouteIndex}", logPrefix, log);
            }

            string[] resourceIdParts = resourceId.Split('/');
            if (resourceIdParts.Length != 3)
            {
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"The resourceId that is set in the parameters section for the route with index {envelope.RouteIndex} is malformed - expected 3 parts, but received only {resourceIdParts.Length} parts", logPrefix, log);
            }

            string resourceGroupName = resourceIdParts[1];
            string logicAppName = resourceIdParts[2];

            Uri logicAppCallbackUri;

            // Get the logicApps callback URL
            try
            {
                logicAppCallbackUri = await new ApimRestClient(requestDetails).GetLogicAppCallbackUrlAsync(resourceGroupName, logicAppName);
                log.LogDebug($"{logPrefix}Retrieved CallbackUrl for LogicApp {logicAppName}");
            }
            catch (AzureResponseException arex)
            {
                // Exception occurred
                return AzureResponseHelper.CreateFaultObjectResult($"An AzureResponseException error occurred calling APIM to get a LogicApp URL for the route with index {envelope.RouteIndex}", arex, logPrefix, log);
            }
            catch (Exception ex)
            {
                // Exception occurred
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An error occurred calling APIM to get a LogicApp URL for the route with index {envelope.RouteIndex}", ex, logPrefix, log);
            }

            // Build headers
            IDictionary<string, string> headers = new Dictionary<string, string>();
            headers[HeaderConstants.AimClearCache] = requestDetails.ClearCache.ToString();
            headers[HeaderConstants.AimEnableTracing] = requestDetails.EnableTrace.ToString();

            AzureResponse response;

            try
            {
                // Call the LogicApp
                log.LogDebug($"{logPrefix}Calling LogicApp {logicAppName} using Url {logicAppCallbackUri}");
                response = await new AzureRestClient(requestDetails, AzureAuthenticationEndpoints.LogicApps).SendAsync(HttpMethod.Post, logicAppCallbackUri, headers, envelope.ToString());
                log.LogDebug($"{logPrefix}Finished calling LogicApp {logicAppName} - return StatusCode is {response?.StatusCode}");
            }
            catch (AzureResponseException arex)
            {
                // Exception occurred
                return AzureResponseHelper.CreateFaultObjectResult($"An AzureResponseException error occurred calling the LogicApp {logicAppName}", arex, logPrefix, log);
            }
            catch (Exception ex)
            {
                // Exception occurred
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An error occurred calling the LogicApp {logicAppName}", ex, logPrefix, log);
            }

            // The response from the LogicApp should be 200 (ACK or NACK).
            // If it's anything else (e.g. a 500) then it's a fault, and an envelope will need to be created.
            // Look at the StatusCode and the ResponseContent and work out what to return
            return AzureResponseHelper.GenerateRouteResponse(requestDetails, response, "LogicApp", logicAppName, logPrefix, log);
        }
    }
}
