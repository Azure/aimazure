using System;
using System.Linq;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Builders;
using Microsoft.AzureIntegrationMigration.Core.Clients;
using Microsoft.AzureIntegrationMigration.Core.Exceptions;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.FunctionApp.MessagingManager
{
    /// <summary>
    /// Azure Function that builds a new envelope message.
    /// </summary>
    public static class BuildEnvelope
    {
        /// <summary>
        /// Defines the ACK EnvelopeType.
        /// </summary>
        private const string EnvelopeTypeAck = "ack";

        /// <summary>
        /// Defines the NACK EnvelopeType.
        /// </summary>
        private const string EnvelopeTypeNack = "nack";

        /// <summary>
        /// Defines the Document EnvelopeType.
        /// </summary>
        private const string EnvelopeTypeDocument = "document";

        /// <summary>
        /// Array of supported envelope types.
        /// </summary>
        private static string[] s_allowedEnvelopeTypes = new string[] { EnvelopeTypeAck, EnvelopeTypeNack, EnvelopeTypeDocument };

        /// <summary>
        /// Default prefix to add to log messages.
        /// </summary>
        private const string LogId = "BuildEnvelope";

        /// <summary>
        /// Builds a new Envelope message.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance containing the received request.</param>
        /// <param name="envelopeType">Type of envelope to build.</param>
        /// <param name="scenario">(Optional) Name of the scenario we're building an envelope for.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
        /// <returns><see cref="IActionResult"/> instance with results.</returns>
        [FunctionName("BuildEnvelope")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "buildenvelope/{envelopeType}/{scenario}")]
            HttpRequest req, string envelopeType, string scenario, ILogger log)
        {
            // Get Request Details
            RequestDetails requestDetails = new RequestDetails(req, LogId);

            string logPrefix = $"{LogId}:{requestDetails.TrackingId}: ";

            // Add the tracking ID to the Response Headers
            if (!string.IsNullOrWhiteSpace(requestDetails.TrackingId))
            {
                req.HttpContext.Response.Headers[HeaderConstants.AimTrackingId] = requestDetails.TrackingId;
            }

            log.LogDebug($"{logPrefix}Called with parameters envelopeType: {envelopeType}, scenario: {scenario}, messageContentType: {requestDetails.RequestContentType}, messageContentEncoding: {requestDetails.RequestContentEncoding}, messageTransferEncoding: {requestDetails.RequestTransferEncoding}, headerTrackingId: {requestDetails.TrackingId}, clearCache: {requestDetails.ClearCache}, enableTrace: {requestDetails.EnableTrace}");

            envelopeType = envelopeType.ToLower();

            // Validate the request
            IActionResult result = ValidateRequest(envelopeType, scenario, requestDetails, logPrefix, log);
            if (result != null)
            {
                return result;
            }

            log.LogDebug($"{logPrefix}Request parameters are valid");

            JObject envelope;

            // Switch by envelopeType
            switch (envelopeType)
            {
                case EnvelopeTypeAck:
                    {
                        log.LogDebug($"{logPrefix}Building an ACK envelope");
                        envelope = EnvelopeBuilder.BuildAckEnvelope(requestDetails);
                        break;
                    }
                case EnvelopeTypeNack:
                    {
                        log.LogDebug($"{logPrefix}Building a NACK envelope");
                        envelope = EnvelopeBuilder.BuildNackEnvelope(requestDetails);
                        break;
                    }
                case EnvelopeTypeDocument:
                    {
                        try
                        {
                            log.LogDebug($"{logPrefix}Building a Content envelope");
                            envelope = await BuildDocumentEnvelopeAsync(scenario, requestDetails, logPrefix, log);

                            // Update the request TrackingId if need be
                            requestDetails.UpdateTrackingId(envelope?["header"]?["properties"]?["trackingId"]?.Value<string>());
                        }
                        catch (AzureResponseException arex)
                        {
                            // Exception occurred
                            AzureResponseHelper.SetCustomResponseHeaders(req, arex);
                            return AzureResponseHelper.CreateFaultObjectResult("An AzureResponseException error occurred building a Document envelope", arex, logPrefix, log);
                        }
                        catch (Exception ex)
                        {
                            // Exception occurred
                            return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "An error occurred building a Document envelope", ex, logPrefix, log);
                        }
                        break;
                    }
                default:
                    {
                        // Invalid EnvelopeType
                        return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"Invalid envelopeType parameter supplied - must be one of {string.Join(", ", s_allowedEnvelopeTypes)}", logPrefix, log);
                    }
            }

            // Add TrackingId header
            if (!string.IsNullOrEmpty(requestDetails.TrackingId) && req?.HttpContext?.Response?.Headers?.ContainsKey(HeaderConstants.AimTrackingId) == false)
            {
                req?.HttpContext?.Response?.Headers?.Add(HeaderConstants.AimTrackingId, requestDetails.TrackingId);
            }

            log.LogDebug($"{logPrefix}Finished building envelope - returning response");

            return new OkObjectResult(envelope);
        }

        /// <summary>
        /// Validates that the request is valid.
        /// </summary>
        /// <param name="envelopeType">Type of envelope to build.</param>
        /// <param name="scenario">(Optional) Name of the scenario we're building an envelope for.</param>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance containing additional request details.</param>
        /// <param name="logPrefix">Logging prefix to use.</param>
        /// <param name="log"><see cref="ILogger"/> instance used for logging.</param>
        /// <returns><see cref="IActionResult"/> instance or null if request is valid.</returns>
        private static IActionResult ValidateRequest(string envelopeType, string scenario, RequestDetails requestDetails, string logPrefix, ILogger log)
        {
            // Check we have a valid envelopeType
            if (!s_allowedEnvelopeTypes.Contains(envelopeType))
            {
                // Invalid EnvelopeType
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"Invalid envelopeType parameter supplied - must be one of {string.Join(", ", s_allowedEnvelopeTypes)}", logPrefix, log);
            }

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

            // We need a Scenario if we have a Document envelopeType
            if (string.Compare(envelopeType, EnvelopeTypeDocument, true) == 0 && string.IsNullOrWhiteSpace(scenario))
            {
                // Missing Scenario
                return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "Scenario must be supplied if envelopeType is Document", logPrefix, log);
            }

            return null;
        }

        /// <summary>
        /// Builds a new document envelope from the supplied <see cref="RequestDetails"/> instance.
        /// </summary>
        /// <param name="scenario">Name of the scenario we're building a document envelope for.</param>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance containing additional request details.</param>
        /// <param name="logPrefix">Logging prefix to use.</param>
        /// <param name="log"><see cref="ILogger"/> instance used for logging.</param>
        /// <returns><see cref="JObject"/> instance containing the document envelope.</returns>
        private static async Task<JObject> BuildDocumentEnvelopeAsync(string scenario, RequestDetails requestDetails, string logPrefix, ILogger log)
        {
            // Build the base envelope
            log.LogDebug($"{logPrefix}Building the base envelope");
            JObject envelope = EnvelopeBuilder.BuildDocumentEnvelope(requestDetails);

            // Get the RoutingSlip from config
            log.LogDebug($"{logPrefix}Getting full RoutingSlip from config");
            JObject routingSlip = await new ApimRestClient(requestDetails).GetRoutingSlipAsync(scenario);

            // Select the routes array
            JArray routes = (JArray)routingSlip?.First?.First;

            // Check if we have any routes
            if (routes != null)
            {
                log.LogDebug($"{logPrefix}Removing RoutingParameters from RoutingSlip");

                // Remove the routing parameters
                foreach (JObject item in routes)
                {
                    item.Properties().Where(key => key.Name.Equals("routingParameters")).ToList().ForEach(attr => attr.Remove());
                }
            }

            log.LogDebug($"{logPrefix}Adding RoutingSlip to base Envelope");

            // Update the routing slip section
            JObject routingSlipSection = (JObject)envelope?["header"]?["routingSlip"];
            routingSlipSection.Add(new JProperty("scenario", scenario));
            routingSlipSection.Add(new JProperty("nextRoute", 0));
            routingSlipSection.Add(routingSlip.First);

            return envelope;
        }
    }
}
