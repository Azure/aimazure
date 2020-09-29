// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System;
using System.Linq;

using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs.Extensions.Http;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Enums;

namespace Microsoft.AzureIntegrationMigration.Core.Helpers
{
    /// <summary>
    /// Stores detail about the request and environment.
    /// </summary>
    public struct RequestDetails
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="RequestDetails"/> class.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance.</param>
        public RequestDetails(RequestDetails requestDetails)
        {
            Source = requestDetails.Source;
            ClearCache = requestDetails.ClearCache;
            EnableTrace = requestDetails.EnableTrace;
            EncodeBody = requestDetails.EncodeBody;
            RequestBody = requestDetails.RequestBody;
            RequestBodyAsJson = requestDetails.RequestBodyAsJson;
            IsFault = requestDetails.IsFault;
            RequestContentType = requestDetails.RequestContentType;
            RequestContentEncoding = requestDetails.RequestContentEncoding;
            RequestTransferEncoding = requestDetails.RequestTransferEncoding;
            TrackingId = requestDetails.TrackingId;
            ApimInstanceName = requestDetails.ApimInstanceName;
            ApimSubscriptionKey = requestDetails.ApimSubscriptionKey;
            EnableOAuthForApim = requestDetails.EnableOAuthForApim;
            EnableOAuthForLogicApps = requestDetails.EnableOAuthForLogicApps;
            EnableOAuthForManagementApi = requestDetails.EnableOAuthForManagementApi;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="RequestDetails"/> class.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance.</param>
        /// <param name="source">SOurce name for this request.</param>
        public RequestDetails(HttpRequest req, string source)
        {
            Source = source ?? "(Unknown)";

            bool clearCache;
            bool.TryParse(req.Query["clearCache"], out clearCache);
            ClearCache = clearCache;

            // Get enableTrace QueryString value
            bool enableTrace;
            bool.TryParse(req.Query["enableTrace"], out enableTrace);
            EnableTrace = enableTrace;

            bool encodeBody = true;
            bool.TryParse(req.Query["encodeBody"], out encodeBody);
            EncodeBody = encodeBody;

            // Get MessageBody
            RequestBody = null;

            try
            {
                RequestBody = req.ReadAsStringAsync().GetAwaiter().GetResult();
            }
            catch { }

            // Get Request ContentType
            RequestContentType = req.ContentType;

            // Get the Request body as a JSON object
            RequestBodyAsJson = null;
            IsFault = false;
            if ((RequestContentType?.ToLower()?.Contains("/json") == true) || (RequestContentType?.ToLower()?.Contains("+json") == true))
            {
                // Attempt to parse the content as JSON
                try
                {
                    RequestBodyAsJson = JToken.Parse(RequestBody);

                    // if th e body is a JSON Object, check if it's a fault
                    if (RequestBodyAsJson is JObject)
                    {
                        // Get the IsFault value
                        IsFault = RequestBodyAsJson?["fault"]?["faultMessage"] != null;
                    }
                }
                catch { }
            }

            // Get Request TransferEncoding
            RequestTransferEncoding = req.Headers.ContainsKey(HeaderConstants.TransferEncoding) ? req.Headers[HeaderConstants.TransferEncoding].ToString() : "none";

            // Get Request ContentEncoding
            RequestContentEncoding = req.Headers.ContainsKey(HeaderConstants.ContentEncoding) ? req.Headers[HeaderConstants.ContentEncoding].ToString() : "none";

            // Get Tracking Id - use the value from the envelope, else the value from the header, else create a new value
            string headerTrackingId = req.Headers.ContainsKey(HeaderConstants.AimTrackingId) ? req.Headers[HeaderConstants.AimTrackingId].ToString() : null;
            string envelopeTrackingId = (RequestBodyAsJson is JObject) ? RequestBodyAsJson?["header"]?["properties"]?["trackingId"]?.Value<string>() : null;
            TrackingId = new string[] { envelopeTrackingId, headerTrackingId, Guid.NewGuid().ToString() }.FirstOrDefault(s => !string.IsNullOrEmpty(s));

            ApimInstanceName = Environment.GetEnvironmentVariable("ApimInstanceName");
            ApimSubscriptionKey = Environment.GetEnvironmentVariable("ApimSubscriptionKey");
            EnableOAuthForApim = (!string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("EnableOAuthForAPIM")) && Environment.GetEnvironmentVariable("EnableOAuthForAPIM").ToLower() == "true");
            EnableOAuthForLogicApps = (!string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("EnableOAuthForLogicApps")) && Environment.GetEnvironmentVariable("EnableOAuthForLogicApps").ToLower() == "true");
            EnableOAuthForManagementApi = (!string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("EnableOAuthForManagementApi")) && Environment.GetEnvironmentVariable("EnableOAuthForManagementApi").ToLower() == "true");
        }

        /// <summary>
        /// Gets the source name for this request.
        /// </summary>
        public string Source { get; internal set; }

        /// <summary>
        /// Gets the name of the APIM Instance.
        /// </summary>
        public string ApimInstanceName { get; internal set; }

        /// <summary>
        /// Gets the SubscriptionKey for APIM.
        /// </summary>
        public string ApimSubscriptionKey { get; internal set; }

        /// <summary>
        /// Gets a flag that indicates if we use OAuth for APIM.
        /// </summary>
        public bool EnableOAuthForApim { get; set; }

        /// <summary>
        /// Gets a flag that indicates if we use OAuth for LogicApps.
        /// </summary>
        public bool EnableOAuthForLogicApps { get; set; }

        /// <summary>
        /// Gets a flag that indicates if we use OAuth for the Azure Management API.
        /// </summary>
        public bool EnableOAuthForManagementApi { get; set; }

        /// <summary>
        /// Gets a flag that indicates if Tracing is enabled.
        /// </summary>
        public bool EnableTrace { get; internal set; }

        /// <summary>
        /// Gets a flag that indicates body content should always be encoded.
        /// </summary>
        public bool EncodeBody { get; internal set; }

        /// <summary>
        /// Gets the TrackingId for this request.
        /// </summary>
        public string TrackingId { get; internal set; }

        /// <summary>
        /// Gets a flag that indicates if we should clear the cache.
        /// </summary>
        public bool ClearCache { get; internal set; }

        /// <summary>
        /// Gets the Request body as a string.
        /// </summary>
        public string RequestBody { get; internal set; }

        /// <summary>
        /// Gets the Request body as a JSON object.
        /// </summary>
        public JToken RequestBodyAsJson { get; internal set; }

        /// <summary>
        /// Gets a flag that indicates if the request body is a Fault object.
        /// </summary>
        public bool IsFault { get; internal set; }

        /// <summary>
        /// Gets the ContentType of the request body.
        /// </summary>
        public string RequestContentType { get; internal set; }

        /// <summary>
        /// Gets the ContentEncoding for the Request body.
        /// </summary>
        public string RequestContentEncoding { get; internal set; }

        /// <summary>
        /// Gets the TransferEncoding for the Request body.
        /// </summary>
        public string RequestTransferEncoding { get; internal set; }

        /// <summary>
        /// Gets a flag that indicates if OAuth is enabled for the given Azure endpoint type.
        /// </summary>
        /// <param name="authEndpoint"><see cref="AzureAuthenticationEndpoints"/> value that indicates the endpoint type to check.</param>
        /// <returns>A flag that indicates if OAuth is enabled for this endpoint type.</returns>
        public bool OAuthEnabled(AzureAuthenticationEndpoints authEndpoint)
        {
            if (authEndpoint == AzureAuthenticationEndpoints.ManagementApi)
            {
                return EnableOAuthForManagementApi;
            }
            if (authEndpoint == AzureAuthenticationEndpoints.Apim)
            {
                return EnableOAuthForApim;
            }
            if (authEndpoint == AzureAuthenticationEndpoints.LogicApps)
            {
                return EnableOAuthForLogicApps;
            }

            return false;
        }

        /// <summary>
        /// Updates the request TrackingId if it is not set.
        /// </summary>
        /// <param name="trackingId">TrackingId to set.</param>
        public void UpdateTrackingId(string trackingId)
        {
            if (string.IsNullOrWhiteSpace(TrackingId) && !string.IsNullOrWhiteSpace(trackingId))
            {
                TrackingId = trackingId;
            }
        }
    }
}
