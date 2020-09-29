// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Enums;
using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Exceptions;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.Core.Clients
{
    /// <summary>
    /// Custom REST client for making APIM requests
    /// </summary>
    public class ApimRestClient : AzureRestClient
    {
        /// <summary>
        /// Stores the default domain for APIM.
        /// </summary>
        private const string DefaultAPIMDomain = "azure-api.net";

        /// <summary>
        /// Initializes an instance of the <see cref="ApimRestClient"/> class.
        /// </summary>
        /// <param name="apimInstanceName">Name of the APIM instance to use.</param>
        /// <param name="apimSubscriptionKey">APIM subscription key.</param>
        /// <param name="enableOAuth">Flag that indicates if we use OAuth for connections.</param>
        public ApimRestClient(RequestDetails requestDetails) : base(requestDetails, AzureAuthenticationEndpoints.Apim, $"https://{requestDetails.ApimInstanceName}.{DefaultAPIMDomain}/")
        {
            Argument.AssertNotNullOrEmpty(requestDetails.ApimInstanceName, nameof(requestDetails.ApimInstanceName));
            Argument.AssertNotNullOrEmpty(requestDetails.ApimSubscriptionKey, nameof(requestDetails.ApimSubscriptionKey));

            ApimInstanceName = requestDetails.ApimInstanceName;
            ApimSubscriptionKey = requestDetails.ApimSubscriptionKey;
        }

        /// <summary>
        /// Gets the name of the APIM instance to use.
        /// </summary>
        public string ApimInstanceName { get; internal set; }

        /// <summary>
        /// Gets the subscription key for the APIM instance to use.
        /// </summary>
        public string ApimSubscriptionKey { get; internal set; }

        /// <summary>
        /// Gets a <see cref="JObject"/> instance containing a RoutingSlip for the given ScenarioName from APIM.
        /// </summary>
        /// <param name="scenarioName">Name of the scenario to get a RoutingSlip for.</param>
        /// <returns><see cref="Task{JObject}"/> instance containing a RoutingSlip.</returns>
        public async Task<JObject> GetRoutingSlipAsync(string scenarioName)
        {
            Argument.AssertNotNullOrEmpty(scenarioName, nameof(scenarioName));

            // Make a call to APIM to get RoutingSlip
            Uri apimUri = new Uri($"{AuthenticationScope}aimroutingstore/routingslip/{scenarioName}?clearCache={_requestDetails.ClearCache}");

            AzureResponse response = await GetFromAPIM(apimUri, "RoutingSlip");

            return response.BodyContentAsJson as JObject;
        }

        /// <summary>
        /// Gets a <see cref="JObject"/> instance containing the RoutingProperties for the given ScenarioName from APIM.
        /// </summary>
        /// <param name="scenarioName">Name of the scenario to get the RoutingProperties for.</param>
        /// <returns><see cref="Task{JObject}"/> instance containing the RoutingProperties.</returns>
        public async Task<JObject> GetRoutingPropertiesAsync(string scenarioName)
        {
            Argument.AssertNotNullOrEmpty(scenarioName, nameof(scenarioName));

            // Make a call to APIM to get RoutingSlip
            HttpClient httpClient = new HttpClient();
            Uri apimUri = new Uri($"{AuthenticationScope}aimroutingstore/routingproperties/{scenarioName}?clearCache={_requestDetails.ClearCache}");
            AzureResponse response = await GetFromAPIM(apimUri, "RoutingProperties");

            return response.BodyContentAsJson as JObject;
        }

        /// <summary>
        /// Gets the content of a given Schema in the ArtifactStore from APIM.
        /// </summary>
        /// <param name="schemaName">Name of the scenario to get the content for.</param>
        /// <returns>Schema content as a string.</returns>
        public async Task<string> GetSchemaContentByNameAsync(string schemaName)
        {
            Argument.AssertNotNullOrEmpty(schemaName, nameof(schemaName));

            // Make a call to APIM to get Schema Content
            HttpClient httpClient = new HttpClient();
            Uri apimUri = new Uri($"{AuthenticationScope}aimconfigurationmanager/schemacontentbyname/{schemaName}?clearCache={_requestDetails.ClearCache}");
            AzureResponse response = await GetFromAPIM(apimUri, "SchemaContent", false);

            return response.BodyContent;
        }

        /// <summary>
        /// Gets a <see cref="Uri"/> instance containing a CallbackUrl for the given LogicApp from APIM.
        /// </summary>
        /// <param name="resourceGroupName">Name of the ResourceGroup the LogicApp is in.</param>
        /// <param name="logicAppName">Name of the LogicApp.</param>
        /// <returns><see cref="Task{Uri}"/> instance containing a CallbackUrl.</returns>
        public async Task<Uri> GetLogicAppCallbackUrlAsync(string resourceGroupName, string logicAppName)
        {
            Argument.AssertNotNullOrEmpty(ApimInstanceName, nameof(ApimInstanceName));
            Argument.AssertNotNullOrEmpty(resourceGroupName, nameof(resourceGroupName));
            Argument.AssertNotNullOrEmpty(logicAppName, nameof(logicAppName));

            // Make a call to APIM to get LogicApp CallbackUrl
            Uri apimUri = new Uri($"{AuthenticationScope}aimroutingmanager/logicappcallbackurl/{resourceGroupName}/{logicAppName}?clearCache={_requestDetails.ClearCache}");
            AzureResponse response = await GetFromAPIM(apimUri, "LogicApp CallbackUrl");

            // Get and return the CallbackUrl as a Uri instance
            string logicAppUrl = ((JObject)response.BodyContentAsJson)?["logicAppUrl"]?.ToString();
            if (string.IsNullOrWhiteSpace(logicAppUrl))
            {
                // No Url
                throw new AzureResponseException(response, $"No valid Url in the JSON returned from APIM trying to get a LogicApp CallbackUrl");
            }

            return new Uri(logicAppUrl);
        }

        /// <summary>
        /// Performs a Get operation on APIM, returning an <see cref="AzureResponse"/> instance.
        /// </summary>
        /// <param name="apimUri"><see cref="Uri"/> instance with the APIM URI to call.</param>
        /// <param name="objectName">Name of the object we're getting.</param>
        /// <param name="expectJsonResponse">Flag indicating if we're expecting a JSON response.</param>
        /// <returns><see cref="AzureResponse"/> instance with the APIM response.</returns>
        private async Task<AzureResponse> GetFromAPIM(Uri apimUri, string objectName, bool expectJsonResponse = true)
        {
            Dictionary<string, string> headers = new Dictionary<string, string>();
            headers.Add("Ocp-Apim-Subscription-Key", ApimSubscriptionKey);
            headers.Add("Ocp-Apim-Trace", _requestDetails.EnableTrace.ToString());

            AzureResponse response;

            try
            {
                response = await SendAsync(HttpMethod.Get, apimUri, headers);
            }
            catch (AzureResponseException)
            {
                throw;
            }
            catch (Exception ex)
            {
                // Exception occurred
                throw new AzureResponseException($"An error occurred calling APIM to get a {objectName}: {ex.Message}");
            }

            if (response == null)
            {
                // No response
                throw new AzureResponseException($"APIM HttpResponseMessage is null trying to get a {objectName}");
            }

            // Add the AIM Tracing Header, if tracing enabled
            if (_requestDetails.EnableTrace)
            {
                if (response.Headers.ContainsKey(HeaderConstants.ApimTraceUrl))
                {
                    response.Headers.Add(HeaderConstants.AimTracingUrl, response.Headers[HeaderConstants.ApimTraceUrl]);
                }
            }

            // Check the response code
            if (!response.IsSuccess)
            {
                throw new AzureResponseException(response, $"APIM returned a failure response trying to get a {objectName}: {response}");
            }

            // Check we have returned content
            if (response.BodyContentLength == 0)
            {
                // Exception occurred
                throw new AzureResponseException(response, $"APIM returned no content from the call to get a {objectName}");
            }

            if (expectJsonResponse && (response.BodyContentAsJson == null || response.BodyContentAsJson.Type != JTokenType.Object))
            {
                // Exception occurred
                throw new AzureResponseException(response, $"APIM returned a {objectName} which can't be parsed as a JSON Object");
            }

            return response;
        }
    }
}
