using System;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

using Microsoft.AzureIntegrationMigration.Core.Helpers;

using Newtonsoft.Json;

namespace Microsoft.AzureIntegrationMigration.FunctionApp.MessagingManager
{
    /// <summary>
    /// Azure Function that converts the supplied JSON body to XML and returns it.
    /// </summary>
    public static class ConvertJsonToXml
    {
        /// <summary>
        /// Default prefix to add to log messages.
        /// </summary>
        private const string LogId = "ConvertJsonToXml";

        /// <summary>
        /// Converts JSON to XML and returns it.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance containing the received request.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
        /// <returns><see cref="IActionResult"/> instance with results.</returns>
        [FunctionName("ConvertJsonToXml")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "convertjsontoxml")]
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

            string rootNode = req.Query["rootNode"];
            string rootNodeNamespace = req.Query["rootNodeNamespace"];
            bool writeArrayAttribute = ((string)req.Query["writeArrayAttribute"] ?? "true") == "true";
            bool encodeSpecialCharacters = req.Query["encodeSpecialCharacters"] == "true";
            bool addMessageBodyForEmptyMessage = req.Query["addMessageBodyForEmptyMessage"] == "true";

            string xmlBody = requestDetails.RequestBody;
            if (addMessageBodyForEmptyMessage && string.IsNullOrWhiteSpace(xmlBody))
            {
                xmlBody = "{}";
            }

            try
            {
                // Convert to XML
                XDocument xDocument = XmlHelper.ToXDocument(JsonConvert.DeserializeXmlNode(xmlBody, rootNode, writeArrayAttribute, encodeSpecialCharacters));
                if (!string.IsNullOrEmpty(rootNodeNamespace))
                {
                    xDocument = XmlHelper.AddNamespace(xDocument, "ns0", rootNodeNamespace);
                    xDocument = XmlHelper.UpdateRootQualifiedName(xDocument, "ns0");
                }

                // Special hack for XML content - OkObjectResult doesn't support XmlDocument in Functions at this time 
                // without adding the XmlSerializerFormmatter to the list of services
                // See here: https://github.com/Azure/azure-functions-host/issues/2896 
                return await Task.FromResult<IActionResult>(new ContentResult()
                {
                    Content = xDocument.ToString(),
                    ContentType = "application/xml",
                    StatusCode = 200
                });
            }
            catch (Exception ex)
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to convert JSON to XML", ex, logPrefix, log));
            }
        }
    }
}
