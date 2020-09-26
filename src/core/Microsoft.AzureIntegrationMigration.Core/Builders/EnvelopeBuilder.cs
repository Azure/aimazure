using System;
using System.Text;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Exceptions;
using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.Core.Builders
{
    /// <summary>
    /// Provides a Builder class for Envelopes.
    /// </summary>
    public class EnvelopeBuilder
    {
        /// <summary>
        /// The Default ResponseCode to use for NACKs.
        /// </summary>
        private const string DefaultNackResponseCode = "500";

        /// <summary>
        /// The Default ResponseCode to use for ACKs.
        /// </summary>
        private const string DefaultAckResponseCode = "200";

        /// <summary>
        /// The Default ResponseMessage to use for ACKs.
        /// </summary>
        private const string DefaultAckResponseMessage = "OK";

        /// <summary>
        /// The default PartType for ACK messages.
        /// </summary>
        private const string AckPartType = "http://schemas.microsoft.com/aim#ack";

        /// <summary>
        /// The default PartType for Content messages.
        /// </summary>
        private const string ContentPartType = "http://schemas.myorg.com/part1#root";

        /// <summary>
        /// The default PartType for NACK messages.
        /// </summary>
        private const string NackPartType = "http://schemas.microsoft.com/aim#nack";

        /// <summary>
        /// Defines the name of the property that holds the content in a body part
        /// </summary>
        private const string ContentPropertyName = "$content";

        /// <summary>
        /// Defines the name of the property that holds the content encoding in a body part
        /// </summary>
        private const string ContentEncodingPropertyName = "$contentTransferEncoding";

        /// <summary>
        /// Defines the name of the property that holds the content type in a body part
        /// </summary>
        private const string ContentTypePropertyName = "$contentType";

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance with details about the request.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(RequestDetails requestDetails)
        {
            Argument.AssertNotNull(requestDetails, nameof(requestDetails));

            if (requestDetails.IsFault)
            {
                // Use the Fault as the NACK body
                return BuildNackEnvelope("(Unknown error)", null, requestDetails.RequestBodyAsJson as JObject, requestDetails.TrackingId);
            }

            // Use the request body as the NACK message
            return BuildNackEnvelope(requestDetails.RequestBody, requestDetails.TrackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="message">Fault message.</param>
        /// <param name="trackingId">Tracking ID to use for this envelope.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(string message, string trackingId = null)
        {
            return BuildNackEnvelope(message, null, (JObject)null, trackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="ex"><see cref="Exception"/> instance containing details about an error.</param>
        /// <param name="trackingId">Tracking ID to use for this envelope.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(Exception ex, string trackingId = null)
        {
            return BuildNackEnvelope(ex?.Message ?? "(Unknown error)", null, AzureResponseHelper.BuildFaultMessage(ex), trackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="message">Fault message.</param>
        /// <param name="ex"><see cref="Exception"/> instance containing details about an error.</param>
        /// <param name="trackingId">Tracking ID to use for this envelope.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(string message, Exception ex, string trackingId = null)
        {
            return BuildNackEnvelope(message, null, AzureResponseHelper.BuildFaultMessage(ex), trackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="message">Fault message.</param>
        /// <param name="code">Fault code.</param>
        /// <param name="ex"><see cref="Exception"/> instance containing details about an error.</param>
        /// <param name="trackingId">Tracking ID to use for this envelope.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(string message, string code, Exception ex, string trackingId = null)
        {
            return BuildNackEnvelope(message, code, AzureResponseHelper.BuildFaultMessage(ex), trackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="arex"><see cref="AzureResponseException"/> instance containing details about an error.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(AzureResponseException arex)
        {
            return BuildNackEnvelope(arex?.Message ?? "(Unknown error)", (arex?.Response == null) ? "(Unknown)" : arex.Response?.StatusCode.ToString(), AzureResponseHelper.BuildFaultMessage(arex), arex.Response.TrackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="message">Fault message.</param>
        /// <param name="arex"><see cref="AzureResponseException"/> instance containing details about an error.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(string message, AzureResponseException arex)
        {
            return BuildNackEnvelope(message, (arex?.Response == null) ? "(Unknown)" : arex.Response?.StatusCode.ToString(), AzureResponseHelper.BuildFaultMessage(arex), arex.Response.TrackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="message">Fault message.</param>
        /// <param name="code">Fault code.</param>
        /// <param name="arex"><see cref="AzureResponseException"/> instance containing details about an error.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(string message, string code, AzureResponseException arex)
        {
            return BuildNackEnvelope(message, code, AzureResponseHelper.BuildFaultMessage(arex), arex.Response.TrackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="message">Fault message.</param>
        /// <param name="code">Fault code.</param>
        /// <param name="reason">Fault reason.</param>
        /// <param name="actor">Fault actor.</param>
        /// <param name="trackingId">Tracking ID to use for this envelope.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(string message, string code, string reason = null, string actor = null, string trackingId = null)
        {
            return BuildNackEnvelope(message, code, AzureResponseHelper.BuildFaultMessage(message, code, reason, actor), trackingId);
        }

        /// <summary>
        /// Builds a new NACK message envelope.
        /// </summary>
        /// <param name="message">Fault message.</param>
        /// <param name="code">Fault code.</param>
        /// <param name="fault"><see cref="JObject"/> instance containing a fault message.</param>
        /// <param name="trackingId">Tracking ID to use for this envelope.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildNackEnvelope(string message, string code, JObject fault = null, string trackingId = null)
        {
            Argument.AssertNotNullOrEmpty(message, nameof(message));

            JObject envelope = BuildBaseEnvelope();

            // Create a new body
            JObject body = new JObject(
                    new JProperty("$part", 1),
                    new JProperty("$partType", NackPartType),
                    new JProperty(ContentTypePropertyName, "text/json"),
                    new JProperty(ContentPropertyName,
                        new JObject(
                                new JProperty("code", code ?? DefaultNackResponseCode),
                                new JProperty("message", message),
                                (fault == null) ? new JProperty("fault", new JObject()) : fault.First
                            )
                    )
                );

            // Add the body to the envelope
            ((JArray)envelope["body"]).Add(body);

            // Set the rootPart and envelopeType properties
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("rootPart", 1));
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("envelopeType", "nack"));

            // Add the TrackingId
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("trackingId", trackingId ?? Guid.NewGuid().ToString()));

            // Set the MessageType routing property
            ((JObject)envelope["header"]?["routing"])?.Add(new JProperty("MessageType", NackPartType));

            return envelope;
        }

        /// <summary>
        /// Builds a new ACK message envelope.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance with details about the request.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildAckEnvelope(RequestDetails requestDetails)
        {
            return BuildAckEnvelope(requestDetails.RequestBody, null, requestDetails.TrackingId);
        }

        /// <summary>
        /// Builds a new ACK message envelope.
        /// </summary>
        /// <param name="message">Success message.</param>
        /// <param name="code">Success code.</param>
        /// <param name="trackingId">Tracking ID to use for this envelope.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildAckEnvelope(string message = null, string code = null, string trackingId = null)
        {
            JObject envelope = BuildBaseEnvelope();

            // Create a new body
            JObject body = new JObject(
                    new JProperty("$part", 1),
                    new JProperty("$partType", AckPartType),
                    new JProperty(ContentTypePropertyName, "text/json"),
                    new JProperty(ContentPropertyName,
                        new JObject(
                                new JProperty("code", code ?? DefaultAckResponseCode),
                                new JProperty("message", message ?? DefaultAckResponseMessage)
                            )
                    )
                );

            // Add the body to the envelope
            ((JArray)envelope["body"]).Add(body);

            // Set the rootPart and envelopeType properties
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("rootPart", 1));
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("envelopeType", "ack"));

            // Add the TrackingId
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("trackingId", trackingId ?? Guid.NewGuid().ToString()));

            // Set the MessageType routing property
            ((JObject)envelope["header"]?["routing"])?.Add(new JProperty("MessageType", AckPartType));

            return envelope;
        }

        /// <summary>
        /// Builds a new Document envelope message. Looks at the messageContentType and messageContentTransferEncoding values to see if
        /// the message is already encoded, or if it needs to be encoded, before adding it to the body.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance containing details about the request.</param>
        /// <returns><see cref="JObject"/> instance representing the envelope.</returns>
        public static JObject BuildDocumentEnvelope(RequestDetails requestDetails)
        {
            Argument.AssertNotNull(requestDetails, nameof(requestDetails));

            JObject envelope = BuildBaseEnvelope();

            string encodingType = requestDetails.RequestContentEncoding ?? "none";
            string encodedBody = requestDetails.RequestBody;

            // Check if we need to encode the content
            if (encodingType.ToLower() == "none")
            {
                // TODO: Expand this to include a more robust check if the content needs to be encoded
                // TODO: Look at ContentType encoding to see if we should use something other than UTF-8
                if (requestDetails.EncodeBody || (string.Compare(requestDetails.RequestContentType, "text/plain", StringComparison.InvariantCultureIgnoreCase) != 0 && string.Compare(requestDetails.RequestContentType, "text/csv", StringComparison.InvariantCultureIgnoreCase) != 0))
                {
                    // Body needs to be encoded
                    encodingType = "base64";
                    encodedBody = Convert.ToBase64String(Encoding.UTF8.GetBytes(encodedBody));
                }
            }

            // Create a new body
            JObject body = new JObject(
                        new JProperty("$part", 1),
                        new JProperty("$partType", ContentPartType),
                        new JProperty(ContentTypePropertyName, requestDetails.RequestContentType),
                        new JProperty(ContentEncodingPropertyName, encodingType),
                        new JProperty(ContentPropertyName, encodedBody)
                    );

            // Add the body to the envelope
            ((JArray)envelope["body"]).Add(body);

            // Set the rootPart and envelopeType properties
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("rootPart", 1));
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("envelopeType", "content"));

            // Add a trackingId - use the value from the request if supplied
            string trackingId = (!string.IsNullOrWhiteSpace(requestDetails.TrackingId)) ? requestDetails.TrackingId : Guid.NewGuid().ToString();
            ((JObject)envelope["header"]?["properties"])?.Add(new JProperty("trackingId", trackingId));

            return envelope;
        }

        /// <summary>
        /// Builds a base envelope message.
        /// </summary>
        /// <returns><see cref="JObject"/> instance containing the base message.</returns>
        private static JObject BuildBaseEnvelope()
        {
            Guid messageId = Guid.NewGuid();
            DateTime messageCreateDate = DateTime.Now;

            return new JObject(
                        new JProperty("header",
                            new JObject(
                                new JProperty("properties",
                                    new JObject(
                                        new JProperty("createDate", messageCreateDate.ToString("o")),
                                        new JProperty("messageId", messageId)
                                    )
                                ),
                                new JProperty("state",
                                    new JObject(
                                    )
                                ),
                                new JProperty("routing",
                                    new JObject(
                                    )
                                ),
                                new JProperty("routingSlip",
                                    new JObject(
                                    )
                                )
                            )
                        ),
                        new JProperty("body",
                            new JArray(
                            )
                        )
                    );
        }
    }
}