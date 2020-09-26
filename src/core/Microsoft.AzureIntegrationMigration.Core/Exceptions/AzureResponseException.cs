using System;
using System.Net.Http;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.Core.Exceptions
{
    /// <summary>
    /// Custom exception for AzureRestClient response errors.
    /// </summary>
    public class AzureResponseException : ApplicationException
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponseException"/> class.
        /// </summary>
        protected AzureResponseException()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponseException"/> class
        /// using a <see cref="HttpResponseMessage"/> instance.
        /// </summary>
        /// <param name="response"><see cref="HttpResponseMessage"/> instance containing the HttpResponse.</param>
        public AzureResponseException(HttpResponseMessage response) : this(response, "An error occurred during an Http Request")
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponseException"/> class
        /// using a <see cref="HttpResponseMessage"/> instance.
        /// </summary>
        /// <param name="response"><see cref="HttpResponseMessage"/> instance containing the HttpResponse.</param>
        /// <param name="errorMessage">Message describing the error.</param>
        public AzureResponseException(HttpResponseMessage response, string errorMessage) : this(new AzureResponse(response), errorMessage)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponseException"/> class
        /// using a <see cref="AzureResponse"/> instance.
        /// </summary>
        /// <param name="response"><see cref="AzureResponse"/> instance containing the response.</param>
        public AzureResponseException(AzureResponse response) : this(response, "An error occurred during an Http Request")
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponseException"/> class
        /// using a <see cref="AzureResponse"/> instance.
        /// </summary>
        /// <param name="response"><see cref="AzureResponse"/> instance containing the response.</param>
        /// <param name="errorMessage">Message describing the error.</param>
        public AzureResponseException(AzureResponse response, string errorMessage) : this(errorMessage)
        {
            Response = response;

            // Build a new fault object
            Fault = AzureResponseHelper.BuildFaultMessage(ErrorMessage, response);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponseException"/> class.
        /// </summary>
        /// <param name="errorMessage">Message describing the error.</param>
        /// <param name="ex">Inner exception.</param>
        public AzureResponseException(string errorMessage, Exception ex) : base(errorMessage, ex)
        {
            ErrorMessage = errorMessage;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponseException"/> class.
        /// </summary>
        /// <param name="errorMessage">Message describing the error.</param>
        public AzureResponseException(string errorMessage) : base(errorMessage)
        {
            ErrorMessage = errorMessage;
        }

        /// <summary>
        /// Gets the <see cref="AzureResponse"/> instance for this exception.
        /// </summary>
        public AzureResponse Response { get; internal set; }

        /// <summary>
        /// Gets the ErrorMessage for this exception.
        /// </summary>
        public string ErrorMessage { get; internal set; }

        /// <summary>
        /// Gets the Fault for this exception.
        /// </summary>
        public JObject Fault { get; internal set; }

        /// <summary>
        /// Gets the Message for this exception.
        /// </summary>
        public override string Message
        {
            get
            {
                return $"{ErrorMessage}";
            }
        }
    }
}
