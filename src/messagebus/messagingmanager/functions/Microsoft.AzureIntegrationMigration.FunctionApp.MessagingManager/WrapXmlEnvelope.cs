// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

using Microsoft.AzureIntegrationMigration.Core.Clients;
using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Exceptions;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.FunctionApp.MessagingManager
{
    /// <summary>
    /// Azure Function that wraps XML content in an XML Envelope.
    /// </summary>
    public static class WrapXmlEnvelope
    {
        /// <summary>
        /// Default prefix to add to log messages.
        /// </summary>
        private const string LogId = "WrapXmlEnvelope";

        /// <summary>
        /// Wraps the supplied XML content in an XML envelope and returns it.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance containing the received request.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
        /// <returns><see cref="IActionResult"/> instance with results.</returns>
        [FunctionName("WrapXmlEnvelope")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "wrapxmlenvelope")]
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

            bool emitXmlDeclaration = ((string)req.Query["emitXmlDeclaration"] ?? "false") == "true";
            string envelopeSpecNames = req.Query["envelopeSpecNames"];

            // Validate the request
            IActionResult result = ValidateRequest(requestDetails, logPrefix, log);
            if (result != null)
            {
                return await Task.FromResult<IActionResult>(result);
            }

            if (string.IsNullOrWhiteSpace(envelopeSpecNames))
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"The envelopeSpecNames query string parameter is blank - this needs to be supplied and populated with a least one envelope SpecName", logPrefix, log));
            }

            log.LogDebug($"{logPrefix}Request parameters are valid");

            // Check that BodyContent is XML
            if ((string.Compare(requestDetails.RequestContentType, "text/xml", true) != 0) && (string.Compare(requestDetails.RequestContentType, "application/xml", true) != 0))
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"Expected an XML content type, but instead have been supplied a ContentType of {(string.IsNullOrWhiteSpace(requestDetails.RequestContentType) ? "text" : requestDetails.RequestContentType)}", logPrefix, log));
            }

            // Attempt to load the content into an XDocument
            XDocument bodyDocument;

            try
            {
                log.LogDebug($"{logPrefix}Parsing the request body as an XDocument");
                bodyDocument = XDocument.Parse(requestDetails.RequestBody);

                // Add TrackingId header
                if (!string.IsNullOrEmpty(requestDetails.TrackingId) && req?.HttpContext?.Response?.Headers?.ContainsKey(HeaderConstants.AimTrackingId) == false)
                {
                    req?.HttpContext?.Response?.Headers?.Add(HeaderConstants.AimTrackingId, requestDetails.TrackingId);
                }
            }
            catch (Exception ex)
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to parse the received XML body into an XDocument", ex, logPrefix, log));
            }

            // Attempt to get the first EnvelopeSchema
            string envelopeSchemaName = envelopeSpecNames.Split(",")[0];
            string envelopeSchemaContent;
            try
            {
                log.LogDebug($"{logPrefix}Getting schema content from IntegrationAccount");
                envelopeSchemaContent = await new ApimRestClient(requestDetails).GetSchemaContentByNameAsync(envelopeSchemaName);
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

            // TODO: Load the XSD into an XmlSchema class
            // TODO: Check the BizTalk IsEnvelope property is set
            // TODO: Check the Body XPath value is set
            // TODO: Generate an instance of the envelope
            // TODO: Select the body node using the Body xPath
            // TODO: Support the emitXmlDeclarationProperty
            // TODO: Insert body content
            // TODO: Return this content

            XDocument xmlEnvelope = bodyDocument;
            
            log.LogDebug($"{logPrefix}Finished wrapping content - returning response");

            // Special hack for XML content - OkObjectResult doesn't support XmlDocument in Functions at this time 
            // without adding the XmlSerializerFormmatter to the list of services
            // See here: https://github.com/Azure/azure-functions-host/issues/2896 
            return await Task.FromResult<IActionResult>(new ContentResult()
            {
                Content = xmlEnvelope.ToString(),
                ContentType = "application/xml",
                StatusCode = 200
            });
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
