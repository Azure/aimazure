// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Clients;
using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Exceptions;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.FunctionApp.RoutingManager
{
   /// <summary>
   /// Azure Function that demotes property values from the envelope into the body of the message, as specified via the current routing properties.
   /// </summary>
   public static class DemoteMessageProperties
   {
      /// <summary>
      /// Default prefix to add to log messages.
      /// </summary>
      private const string LogId = "DemoteMessageProperties";

      /// <summary>
      /// Entry point for the function.
      /// </summary>
      /// <param name="req"><see cref="HttpRequest"/> instance containing the received request.</param>
      /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
      /// <returns><see cref="IActionResult"/> instance with results.</returns>
      [FunctionName("DemoteMessageProperties")]
      public static async Task<IActionResult> Run(
          [HttpTrigger(AuthorizationLevel.Function, "post", Route = "demotemessageproperties")]
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

         log.LogDebug($"{logPrefix}called with parameters messageContentType: {requestDetails.RequestContentType}, messageContentEncoding: {requestDetails.RequestContentEncoding}, messageTransferEncoding: {requestDetails.RequestTransferEncoding}, headerTrackingId: {requestDetails.TrackingId}, clearCache: {requestDetails.ClearCache}, enableTrace: {requestDetails.EnableTrace}");

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
            if (!string.IsNullOrEmpty(requestDetails.TrackingId) && req?.HttpContext?.Response?.Headers?.ContainsKey(HeaderConstants.AimTrackingId) == false)
            {
               req?.HttpContext?.Response?.Headers?.Add(HeaderConstants.AimTrackingId, requestDetails.TrackingId);
            }
         }
         catch (Exception ex)
         {
            return AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to parse the received envelope message", ex, logPrefix, log);
         }

         // Check if we have a ScenarioName
         if (string.IsNullOrWhiteSpace(envelope.Scenario))
         {
            // Missing ScenarioName
            return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "ScenarioName cannot be found in the request body", logPrefix, log);
         }

         // Get the RoutingProperties from config
         JObject routingProperties;
         try
         {
            log.LogDebug($"{logPrefix}Getting full RoutingSlip from config");
            routingProperties = await new ApimRestClient(requestDetails).GetRoutingPropertiesAsync(envelope.Scenario);
         }
         catch (AzureResponseException arex)
         {
            // Exception occurred
            AzureResponseHelper.SetCustomResponseHeaders(req, arex);
            return AzureResponseHelper.CreateFaultObjectResult("An AzureResponseException error occurred calling APIM", arex, logPrefix, log);
         }
         catch (Exception ex)
         {
            // Exception occurred
            return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "An error occurred calling APIM", ex, logPrefix, log);
         }

         try
         {
            RoutingPropertyHelper.DemoteMessageProperties(routingProperties, envelope);
         }
         catch (Exception ex)
         {
            // Exception occurred
            return AzureResponseHelper.CreateFaultObjectResult(requestDetails, "An error occurred demoting message properties", ex, logPrefix, log);
         }

         log.LogDebug($"{logPrefix}Finished demoting routing properties - returning response");

         return new OkObjectResult(envelope.ToJObject());
      }

      /// <summary>
      /// Validates that the request is valid.
      /// </summary>
      /// <param name="requestDetails"><see cref="RequestDetails"/> instance containing additional request details.</param>
      /// <param name="logPrefix">Logging prefix to use</param>
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

         return null;
      }
   }
}
