using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

using Microsoft.Rest;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;

using Microsoft.Azure.Services.AppAuthentication;

using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Enums;
using Microsoft.AzureIntegrationMigration.Core.Exceptions;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.Core.Clients
{
    /// <summary>
    /// Custom RestClient for making REST requests to Azure, optionally using OAuth.
    /// </summary>
    public class AzureRestClient
    {
        /// <summary>
        /// Stores the current RestClient.
        /// </summary>
        private RestClient _client;

        /// <summary>
        /// Store the Id of the Tenant to use for requests.
        /// </summary>
        private readonly string _tenantId;

        /// <summary>
        /// Stores the Azure environment to use.
        /// </summary>
        private readonly AzureEnvironment _environment;

        /// <summary>
        /// Stores the logging level to use.
        /// </summary>
        private readonly HttpLoggingDelegatingHandler.Level _loggingLevel;

        /// <summary>
        /// Indicates if we've been initialized.
        /// </summary>
        private bool _initialized = false;

        /// <summary>
        /// The default AuthenticationScope to use, if none is supplied.
        /// </summary>
        private const string DefaultAuthenticationScope = "https://management.azure.com/";

        /// <summary>
        /// The default ConentType to use for request messages.
        /// </summary>
        private const string DefaultContentType = "application/json";

        /// <summary>
        /// Stores the current AuthenticationScope we're using.
        /// </summary>
        private string _authenticationScope = DefaultAuthenticationScope;

        /// <summary>
        /// Stores the current AuthenticationEndpoint we're using.
        /// </summary>
        private AzureAuthenticationEndpoints _authenticationEndpoint = AzureAuthenticationEndpoints.ManagementApi;

        /// <summary>
        /// Stores details about the request.
        /// </summary>
        protected RequestDetails _requestDetails;

        /// <summary>
        /// Initializes a new instance of the <see cref="ApimRestClient"/> class.
        /// </summary>
        public AzureRestClient() : this(null, AzureEnvironment.AzureGlobalCloud, HttpLoggingDelegatingHandler.Level.Basic)
        {
        }

        /// <summary>
        /// Initializes an instance of the <see cref="ApimRestClient"/> class.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance containing details about the request.</param>
        /// <param name="authEndpoint"><see cref="AzureAuthenticationEndpoints"/> value indicating the type of endpoint we're authenticating against.</param>
        /// <param name="authenticationScope">Authentication scope to use.</param>
        public AzureRestClient(RequestDetails requestDetails, AzureAuthenticationEndpoints authEndpoint, string authenticationScope = DefaultAuthenticationScope) : this()
        {
            _requestDetails = requestDetails;
            _authenticationScope = authenticationScope;
            _authenticationEndpoint = authEndpoint;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ApimRestClient"/> class.
        /// </summary>
        /// <param name="tenantId">Id of the Tenant to use for authentication - use null for the default tenant.</param>
        /// <param name="environment">Azure environment to use.</param>
        /// <param name="loggingLevel">Logging level to use.</param>
        public AzureRestClient(string tenantId, AzureEnvironment environment, HttpLoggingDelegatingHandler.Level loggingLevel)
        {
            _tenantId = tenantId;
            _environment = environment;
            _loggingLevel = loggingLevel;
        }

        /// <summary>
        /// Gets or sets a the scope that we need an OAuth token for.
        /// </summary>
        public string AuthenticationScope
        {
            get
            {
                return _authenticationScope;
            }
            set
            {
                // Check if the value has changed
                if (string.Compare(_authenticationScope, value, true) != 0)
                {
                    _authenticationScope = value;

                    // If we're initialized, then reset ourselves
                    if (_initialized) Reset();
                }
            }
        }

        /// <summary>
        /// Gets or sets a the endpoint type that we need an OAuth token for.
        /// </summary>
        public AzureAuthenticationEndpoints AuthenticationEndpoint
        {
            get
            {
                return _authenticationEndpoint;
            }
            set
            {
                // Check if the value has changed
                if (_authenticationEndpoint!= value)
                {
                    _authenticationEndpoint = value;

                    // If we're initialized, then reset ourselves
                    if (_initialized) Reset();
                }
            }
        }

        /// <summary>
        /// Initializes the Api Client.
        /// </summary>
        public virtual void Initialize()
        {
            Argument.AssertNotNullOrEmpty(AuthenticationScope, nameof(AuthenticationScope));

            // Don't initialize of we're already initialized
            if (_initialized) return;

            // Only get an OAuthToken if OAuth is enabled
            if (_requestDetails.OAuthEnabled(AuthenticationEndpoint))
            {
                // Get a token for the current identity
                var azureServiceTokenProvider = new AzureServiceTokenProvider();
                string accessToken = azureServiceTokenProvider.GetAccessTokenAsync(AuthenticationScope).GetAwaiter().GetResult();
                var tokenCredentials = new TokenCredentials(accessToken);

                // Build an AzureCredentials object
                var azureCredentials = new AzureCredentials(
                tokenCredentials,
                tokenCredentials,
                _tenantId,
                _environment);

                // Create a new internal RestClient
                _client = RestClient
                .Configure()
                .WithEnvironment(_environment)
                .WithLogLevel(_loggingLevel)
                .WithCredentials(azureCredentials)
                .Build();
            }

            _initialized = true;
        }

        /// <summary>
        /// Resets this instance so that it needs to be initialized again.
        /// </summary>
        public virtual void Reset()
        {
            _initialized = false;
            _client = null;
        }

        /// <summary>
        /// Sends a REST request to the given API, optionally using OAuth.
        /// </summary>
        /// <param name="method"><see cref="HttpMethod"/> instance indicating the HTTP method to use.</param>
        /// <param name="destinationUri"><see cref="Uri"/> instance with the Uri to use.</param>
        /// <param name="headers">Optional <see cref="IDictionary{string, string}"/> instance with any headers to set.</param>
        /// <param name="bodyContent">Optional body content to send.</param>
        /// <param name="bodyContentType">Optional content type of the body.</param>
        /// <param name="cancellationToken">Optional sync <see cref="CancellationToken"/> instance.</param>
        /// <returns><see cref="AzureResponse"/> instance.</returns>
        public virtual async Task<AzureResponse> SendAsync(HttpMethod method, Uri destinationUri, IDictionary<string, string> headers = null, string bodyContent = null, string bodyContentType = DefaultContentType, CancellationToken cancellationToken = default)
        {
            HttpClient httpClient = new HttpClient();
            HttpResponseMessage httpResponse;
            AzureResponse azureResponse;

            try
            {
                // Initialize if not initialized
                if (!_initialized) Initialize();

                // Create the request message
                HttpRequestMessage requestMessage = new HttpRequestMessage(method, destinationUri);

                // Set headers
                if (headers != null && headers.Count > 0)
                {
                    foreach (var item in headers)
                    {
                        if (requestMessage.Headers.Contains(item.Key))
                        {
                            requestMessage.Headers.Remove(item.Key);
                        }
                        requestMessage.Headers.Add(item.Key, item.Value);
                    }
                }

                // Set body content
                if (bodyContent != null)
                {
                    //TODO: allow different encodings?
                    requestMessage.Content = new StringContent(bodyContent, Encoding.UTF8, bodyContentType);
                }

                //Check if we need to authenticate
                if (_requestDetails.OAuthEnabled(AuthenticationEndpoint))
                {
                    // Authenticate the request
                    _client.Credentials.ProcessHttpRequestAsync(requestMessage, cancellationToken).GetAwaiter().GetResult();
                }

                // Make the call and get a response
                httpResponse = await httpClient.SendAsync(requestMessage, HttpCompletionOption.ResponseHeadersRead, cancellationToken).ConfigureAwait(false);

                // Create a new AzureResponse
                azureResponse = new AzureResponse(httpResponse);
            }
            catch (Exception ex)
            {
                // Exception occurred
                throw new AzureResponseException($"An error occurred making a REST call: {ex.Message}", ex);
            }

            return azureResponse;
        }
    }
}
