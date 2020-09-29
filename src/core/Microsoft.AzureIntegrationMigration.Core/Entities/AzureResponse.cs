// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Enums;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.Core.Entities
{
    /// <summary>
    /// Represents the response returned by an AzureRestClient operation.
    /// </summary>
    public class AzureResponse
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponse"/> class.
        /// </summary>
        protected AzureResponse()
        {
            IsSuccess = false;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="AzureResponse"/> class
        /// using a <see cref="HttpResponseMessage"/> instance.
        /// </summary>
        /// <param name="response"><see cref="HttpResponseMessage"/> instance containing the HttpResponse.</param>
        public AzureResponse(HttpResponseMessage response)
        {
            Argument.AssertNotNull(response, nameof(response));

            StatusCode = response.StatusCode;
            Reason = response.ReasonPhrase;
            IsSuccess = response.IsSuccessStatusCode;
            RequestUri = response.RequestMessage?.RequestUri;

            Headers = new Dictionary<string, string>();

            // Store Response Headers
            foreach (var header in response.Headers)
            {
                Headers[header.Key] = header.Value.FirstOrDefault();
            }

            // Store Response Content Headers
            foreach (var header in response?.Content?.Headers)
            {
                Headers[header.Key] = header.Value.FirstOrDefault();
            }

            // Get and store any content
            try
            {
                BodyContent = response?.Content?.ReadAsStringAsync().GetAwaiter().GetResult();
                BodyContentType = Headers.ContainsKey("Content-Type") ? Headers["Content-Type"] : null;

                // Get Body TransferEncoding
                BodyTransferEncoding = Headers.ContainsKey(HeaderConstants.TransferEncoding) ? Headers[HeaderConstants.TransferEncoding].ToString() : "none";

                // Get Body ContentEncoding
                BodyContentEncoding = Headers.ContainsKey(HeaderConstants.ContentEncoding) ? Headers[HeaderConstants.ContentEncoding].ToString() : "none";
            }
            catch { }

            try
            {
                // Attempt to get the BodyContent as a JToken
                if (!string.IsNullOrWhiteSpace(BodyContent))
                {
                    BodyContentAsJson = JToken.Parse(BodyContent);
                }
            }
            catch { }

            // Get the TrackingId
            TrackingId = Headers.ContainsKey(HeaderConstants.AimTrackingId) ? Headers[HeaderConstants.AimTrackingId] : null;

            // Get the EnvelopeType
            BodyEnvelopeType = GetEnvelopeType();

            // Get the IsFault value
            IsFault = GetIsFault();
        }

        /// <summary>
        /// Gets the StatusCode for this response.
        /// </summary>
        public HttpStatusCode StatusCode { get; internal set; }

        /// <summary>
        /// Gets a flag that indicates if this is a successful response.
        /// </summary>
        public bool IsSuccess { get; internal set; }

        /// <summary>
        /// Gets a flag that indicates if this represents a Fault message.
        /// </summary>
        public bool IsFault { get; internal set; }

        /// <summary>
        /// Gets the Uri used for the request.
        /// </summary>
        public Uri RequestUri { get; internal set; }

        /// <summary>
        /// Gets the Reason message for this response.
        /// </summary>
        public string Reason { get; internal set; }

        /// <summary>
        /// Gets the BodyContent for this response.
        /// </summary>
        public string BodyContent { get; internal set; }

        /// <summary>
        /// Gets the BodyContent for this response as a JToken.
        /// </summary>
        public JToken BodyContentAsJson { get; internal set; }

        /// <summary>
        /// Gets the TransferEncoding for the Response body.
        /// </summary>
        public string BodyTransferEncoding { get; internal set; }

        /// <summary>
        /// Gets the ContentEncoding for the Response body.
        /// </summary>
        public string BodyContentEncoding { get; internal set; }

        /// <summary>
        /// Gets the TrackingId for this response.
        /// </summary>
        public string TrackingId { get; internal set; }

        /// <summary>
        /// Gets the length of the Body Content.
        /// </summary>
        public int BodyContentLength
        { 
            get
            {
                return (BodyContent == null) ? 0 : BodyContent.Length;
            }
        }

        /// <summary>
        /// Gets the BodyContentType for this exception.
        /// </summary>
        public string BodyContentType { get; internal set; }

        /// <summary>
        /// Get the type of envelope present in the body content (if any).
        /// </summary>
        public EnvelopeType BodyEnvelopeType { get; internal set; }

        /// <summary>
        /// Gets the collection of Headers for this exception.
        /// </summary>
        public IDictionary<string, string> Headers { get; internal set; }

        /// <summary>
        /// Gets a string representation of this instance.
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return $"StatusCode: {(int)StatusCode} ({StatusCode}), Reason: {Reason}, Content-Type: {BodyContentType ?? "(Unknown)"}, Content-Length: {BodyContentLength} bytes";
        }

        /// <summary>
        /// Gets an <see cref="EnvelopeType"/> enum value by checking the response content.
        /// </summary>
        /// <returns><see cref="EnvelopeType"/> enum value.</returns>
        private EnvelopeType GetEnvelopeType()
        {
            EnvelopeType envelopeType = EnvelopeType.None;

            // Check if the content we have is a known envelope type
            if (BodyContentAsJson != null)
            {
                // Check if we have a MessageType routing property
                JToken messageType = BodyContentAsJson?["header"]?["routing"]?["MessageType"];
                if (messageType != null && messageType is JToken)
                {
                    if (messageType.ToString() == "http://schemas.microsoft.com/aim#nack")
                    {
                        envelopeType = EnvelopeType.Nack;
                    }
                    else if (messageType.ToString() == "http://schemas.microsoft.com/aim#ack")
                    {
                        envelopeType = EnvelopeType.Ack;
                    }
                    else
                    {
                        // If we have a header and routing section, then this must be a valid envelope - so we assume it is a Content envelope
                        envelopeType = EnvelopeType.Content;
                    }
                }
            }

            return envelopeType;
        }

        /// <summary>
        /// Checks if the Body Content contains a Fault message, and returns True if it does.
        /// </summary>
        /// <returns>True if the BodyContent contains a Fault, else false.</returns>
        private bool GetIsFault()
        {
            bool isFault = false;

            // Check if the content we have is a Fault object
            if (BodyContentAsJson != null)
            {
                // Check if we have a faultMessage property
                isFault = BodyContentAsJson?["fault"]?["faultMessage"] != null;
            }

            return isFault;
        }
    }
}
