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
using Newtonsoft.Json.Linq;
using System.Linq;

namespace Microsoft.AzureIntegrationMigration.FunctionApp.MessagingManager
{
    /// <summary>
    /// Azure Function that converts the supplied XML body to JSON and returns it.
    /// </summary>
    public static class ConvertXmlToJson
    {
        /// <summary>
        /// Default prefix to add to log messages.
        /// </summary>
        private const string LogId = "ConvertXmlToJson";

        /// <summary>
        /// Converts XML to JSON and returns it.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance containing the received request.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use for logging.</param>
        /// <returns><see cref="IActionResult"/> instance with results.</returns>
        [FunctionName("ConvertXmlToJson")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = "convertxmltojson")]
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

            bool removeOuterEnvelope = ((string)req.Query["removeOuterEnvelope"] ?? "false") == "true";

            // Load the body into an XDocument
            XDocument xDocument;

            try
            {
                xDocument = XDocument.Parse(requestDetails.RequestBody);
            }
            catch (Exception ex)
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to parse the supplied XML body - check that valid XML has been supplied", ex, logPrefix, log));
            }

            // Remove all namespaces and prefixes from the XML (as not supported by JSON and we don't want to emit them)
            try
            {
                // Remove namespace (and prefix) from all elements and attributes
                foreach (XElement xElement in xDocument.Root.DescendantsAndSelf())
                {
                    xElement.Name = xElement.Name.LocalName;
                    var query = from xAttribute in xElement.Attributes()
                                where !xAttribute.IsNamespaceDeclaration
                                select new XAttribute(xAttribute.Name.LocalName, xAttribute.Value);
                    xElement.ReplaceAttributes(query.ToList());
                }
            }
            catch (Exception ex)
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to remove namespaces and prefixes from the supplied XML", ex, logPrefix, log));
            }

            try 
            {                
                JToken json = JToken.Parse(JsonConvert.SerializeXmlNode(XmlHelper.ToXmlDocument(xDocument), Newtonsoft.Json.Formatting.Indented, removeOuterEnvelope));
                return await Task.FromResult<IActionResult>(new OkObjectResult(json));
            }
            catch (Exception ex)
            {
                return await Task.FromResult<IActionResult>(AzureResponseHelper.CreateFaultObjectResult(requestDetails, $"An exception occurred trying to convert XML to JSON", ex, logPrefix, log));
            }
        }
    }
}
