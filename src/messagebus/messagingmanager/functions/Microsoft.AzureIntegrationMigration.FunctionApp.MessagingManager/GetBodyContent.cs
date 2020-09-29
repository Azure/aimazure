// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System;
using System.Threading.Tasks;
using System.Xml;

using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

using Newtonsoft.Json.Linq;

namespace Microsoft.AzureIntegrationMigration.FunctionApp.MessagingManager
{
    /// <summary>
    /// Azure Function that gets encoded content from the root part of a content envelope.
    /// </summary>
    public static class GetBodyContent
    {
        /// <summary>
        /// Default prefix to add to log messages.
        /// </summary>
        private const string LogId = "GetBodyContent";

        /// <summary>
        /// Get encoded body content from an envelope message and returns it.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance containing the received request.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
        /// <returns><see cref="IActionResult"/> instance with results.</returns>
        [FunctionName("GetBodyContent")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "getbodycontent")]
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

            log.LogDebug($"{logPrefix}Called with parameters messageContentType: {requestDetails.RequestContentType}, messageContentEncoding: {requestDetails.RequestContentEncoding}, messageTransferEncoding: {requestDetails.RequestTransferEncoding}, headerTrackingId: {requestDetails.TrackingId}, clearCache: {requestDetails.ClearCache}, enableTrace: {requestDetails.EnableTrace}");

            // Validate the request
            IActionResult result = ValidateRequest(requestDetails, logPrefix, log);
            if (result != null)
            {
                return await Task.FromResult<IActionResult>(result);
            }

            log.LogDebug($"{logPrefix}Request parameters are valid");

            // Attempt to parse the envelope
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
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to parse the received envelope message", ex, logPrefix, log));
            }

            // Attempt to get the encoded root part content
            JObject decodedContent;

            try
            {
                decodedContent = envelope.GetEncodedRootPartContent();
            }
            catch (Exception ex)
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An error occurred trying to encode the root part content", ex, logPrefix, log));
            }

            log.LogDebug($"{logPrefix}Finished getting content - returning response");

            return await Task.FromResult<IActionResult>(new OkObjectResult(decodedContent));
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

            return null;
        }
    }
}
