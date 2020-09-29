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

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Helpers;
using System.Linq;

namespace Microsoft.AzureIntegrationMigration.FunctionApp.MessagingManager
{
    /// <summary>
    /// Azure Function that merges two property bags together.
    /// </summary>
    public static class MergeProperties
    {
        /// <summary>
        /// Default prefix to add to log messages.
        /// </summary>
        private const string LogId = "MergeProperties";

        /// <summary>
        /// Merges multiple property bags together and returns a single instance of a property bag.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance containing the received request.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
        /// <returns><see cref="IActionResult"/> instance with results.</returns>
        [FunctionName("MergeProperties")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "mergeproperties")]
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

            // We expect the body to be an array of property bags
            // e.g.
            // [
            //    {
            //       "properties":
            //        {
            //            "property1": "value1"
            //        }
            //    },
            //    {
            //       "properties":
            //        {
            //            "property2": "value2"
            //        }
            //    }
            // ]

            // Check we have a JSON array in the body content
            if (!(requestDetails.RequestBodyAsJson is JArray))
            {
                // We need an array to be supplied
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, "The supplied request body is not a JSON array", logPrefix, log));
            }

            JArray propertiesArray = requestDetails.RequestBodyAsJson as JArray;
            // Check we have at least one element in the array
            if (propertiesArray.Count == 0)
            {
                // We need at least one element in the supplied array
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, "The supplied request body contains an empty JSON array", logPrefix, log));
            }

            // Check that all the array elements are JSON Objects
            if (!propertiesArray.All(j => j is JObject))
            {
                // All elements in the array must be JSON Objects
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, "All elements in the supplied JSON Array must be JSON Objects", logPrefix, log));
            }

            JObject firstElement = propertiesArray[0] as JObject;
            log.LogDebug($"{logPrefix}Merging property objects");

            try
            {
                // Merge every subsequent element in the array (other than the first) with the first array element
                for (int arrayIndex = 1; arrayIndex < propertiesArray.Count; arrayIndex++)
                {
                    firstElement.Merge(propertiesArray[arrayIndex] as JObject, new JsonMergeSettings
                    {
                        // Union array values together to avoid duplicates
                        MergeArrayHandling = MergeArrayHandling.Union
                    });
                }
            }
            catch (Exception ex)
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to merge the property bags", ex, logPrefix, log));
            }

            return await Task.FromResult<IActionResult>(new OkObjectResult(firstElement));
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
