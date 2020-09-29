// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Helpers;

namespace Microsoft.AzureIntegrationMigration.Core.Entities
{
    /// <summary>
    /// Represents a deserialized Envelope instance.
    /// </summary>
    public class Envelope
    {
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
        /// Defines the envelope.
        /// </summary>
        private JObject _envelope = null;

        /// <summary>
        /// Initializes a new instance of the <see cref="Envelope"/> class.
        /// </summary>
        /// <param name="jsonObject"><see cref="JObject"/> instance containing the envelope.</param>
        public Envelope(JObject jsonObject)
        {
            Argument.AssertNotNull(jsonObject, nameof(jsonObject));

            _envelope = jsonObject;

            // Validate the envelope
            ValidateEnvelope();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Envelope"/> class.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance containing the request.</param>
        public Envelope(RequestDetails requestDetails)
        {
            Argument.AssertNotNull(requestDetails, nameof(requestDetails));

            _envelope = requestDetails.RequestBodyAsJson as JObject;

            // Update the RequestDetails TrackingId if we have one in the envelope but don't have one in the request
            if (string.IsNullOrEmpty(requestDetails.TrackingId) || !string.IsNullOrEmpty(TrackingId))
            {
                requestDetails.TrackingId = TrackingId;
            }

            // Validate the envelope
            ValidateEnvelope();
        }

        /// <summary>
        /// Gets the envelope header.
        /// </summary>
        public JObject Header
        {
            get
            {
                return _envelope?["header"] as JObject;
            }
        }

        /// <summary>
        /// Gets the envelope body.
        /// </summary>
        public JArray Body
        {
            get
            {
                return _envelope?["body"] as JArray;
            }
        }

        /// <summary>
        /// Gets the RoutingSlip.
        /// </summary>
        public JObject RoutingSlip
        {
            get
            {
                return Header?["routingSlip"] as JObject;
            }
        }

        /// <summary>
        /// Gets the Scenario Name.
        /// </summary>
        public string Scenario
        {
            get
            {
                return RoutingSlip?["scenario"]?.Value<string>();
            }
        }

        /// <summary>
        /// Gets the next Route index.
        /// </summary>
        public int? RouteIndex
        {
            get
            {
                return RoutingSlip?["nextRoute"]?.Value<int>();
            }
        }

        /// <summary>
        /// Gets the Routes.
        /// </summary>
        public JArray Routes
        {
            get
            {
                return RoutingSlip?["routes"] as JArray;
            }
        }

        /// <summary>
        /// Gets the count of Routes.
        /// </summary>
        public int RoutesCount
        {
            get
            {
                if (Routes == null) return 0;
                return Routes.Count;
            }
        }

        /// <summary>
        /// Gets the next route.
        /// </summary>
        public JObject NextRoute
        {
            get
            {
                if ((RoutesCount == 0) || (RouteIndex == null) || (RouteIndex < 0) || (RouteIndex >= RoutesCount)) return null;
                return Routes[RouteIndex] as JObject;
            }
        }

        /// <summary>
        /// Gets the root part index.
        /// </summary>
        public int? RootPartIndex
        {
            get
            {
                return GetProperty<int?>("rootPart");
            }
        }

        /// <summary>
        /// Gets the root body part.
        /// </summary>
        public JObject RootBodyPart
        {
            get
            {
                return Body.Where(p => p?["$part"]?.Value<int>() == RootPartIndex).FirstOrDefault() as JObject;
            }
        }

        /// <summary>
        /// Gets the contentType for the root body part.
        /// </summary>
        public string RootBodyPartContentType
        {
            get
            {
                return RootBodyPart?[ContentTypePropertyName].Value<string>();
            }
        }

        /// <summary>
        /// Gets the Routing object.
        /// </summary>
        public JObject Routing
        {
            get
            {
                return Header?["routing"] as JObject;
            }
        }

        /// <summary>
        /// Gets the state object.
        /// </summary>
        public JObject State
        {
            get
            {
                return Header?["state"] as JObject;
            }
        }

        /// <summary>
        /// Gets the local state object.
        /// </summary>
        public JObject LocalState
        {
            get
            {
                if (State == null) return null;
                if (State?["local"] == null)
                {
                    State["local"] = new JObject();
                }

                return State["local"] as JObject;
            }
        }

        /// <summary>
        /// Gets the global state object.
        /// </summary>
        public JObject GlobalState
        {
            get
            {
                if (State == null) return null;
                if (State?["global"] == null)
                {
                    State["global"] = new JObject();
                }

                return State["global"] as JObject;
            }
        }

        /// <summary>
        /// Gets the MessageType property.
        /// </summary>
        public string MessageType
        {
            get
            {
                return GetRoutingProperty<string>("MessageType");
            }
        }

        /// <summary>
        /// Gets or sets the TrackingId property.
        /// </summary>
        public string TrackingId
        {
            get
            {
                return GetProperty<string>("trackingId");
            }
            set
            {
                if (Properties != null)
                {
                    Properties["trackingId"] = value;
                }
            }
        }

        /// <summary>
        /// Gets or sets the Properties property.
        /// </summary>
        public JObject Properties
        {
            get
            {
                return Header?["properties"] as JObject;
            }
        }

        /// <summary>
        /// Increments the existing RouteIndex and stores back in the envelope.
        /// </summary>
        public void IncrementRouteIndex()
        {
            if (RoutingSlip != null)
            {
                RoutingSlip["nextRoute"] = RouteIndex + 1;
            }
        }

        /// <summary>
        /// Gets the root part message content, optionally decoding it.
        /// </summary>
        /// <returns><see cref="JObject"> or <see cref="XmlDocument"> instance</returns>
        public object GetDecodedRootPartContent()
        {
            // If no root part is set, and there is no body, then return null
            if (RootPartIndex == null && (Body == null || Body.Count == 0))
            {
                return null;
            }

            // If a root part is not set, but we have at least one body, then throw an exception
            if (RootPartIndex == null && (Body != null && Body.Count > 0))
            {
                throw new ApplicationException($"No rootPart property is set, but there are {Body?.Count} body parts defined");
            }

            JObject bodyPart = RootBodyPart;

            // Check if we have a body part
            if (bodyPart == null)
            {
                throw new ApplicationException($"Unable to find a body part with index {RootPartIndex}");
            }

            string contentEncoding = bodyPart?[ContentEncodingPropertyName]?.ToString() ?? "none";
            string contentType = bodyPart?[ContentTypePropertyName]?.ToString() ?? "none";
            JToken content = bodyPart?[ContentPropertyName];

            // If we have no body, then return null
            if (content == null)
            {
                return null;
            }

            string decodedContent;

            // If we're base64 encoded, then decode it
            if (string.Compare(contentEncoding, "base64", true) == 0)
            {
                // Decode the content - assume UTF8
                try
                {
                    //TODO: The ContentType might indicate the encoding used (e.g. text/csv; charset=utf-7) - use this and Encoding.GetEncoding() to determine which encoding to use
                    decodedContent = Encoding.UTF8.GetString(Convert.FromBase64String(content.ToString()));
                }
                catch (Exception ex)
                {
                    throw new ApplicationException($"An error occurred trying to decode the root part content using {contentEncoding}: {ex.Message}", ex);
                }
            }
            else if (content is JObject)
            {
                return content as JObject;
            }
            else
            {
                // Assume we have unencoded text
                decodedContent = content.Value<string>();
            }

            // Check if we have XML - if we do, attempt to load it into an XmlDocument
            //TODO: look if we can use an XmlReader with XPath
            //TODO: expand this list to include XML-based content types e.g. application/rss+xml
            if (contentType.StartsWith("text/xml", StringComparison.InvariantCultureIgnoreCase) || contentType.StartsWith("application/xml", StringComparison.InvariantCultureIgnoreCase))
            {
                try
                {
                    using (MemoryStream stream = new MemoryStream())
                    {
                        byte[] data = Encoding.UTF8.GetBytes(decodedContent);
                        stream.Write(data, 0, data.Length);
                        stream.Seek(0, SeekOrigin.Begin);
                        XmlTextReader reader = new XmlTextReader(stream);

                        XmlDocument xmlDocument = new XmlDocument();
                        xmlDocument.Load(reader);
                        return xmlDocument;
                    }
                }
                catch (Exception ex)
                {
                    throw new ApplicationException($"ContentType indicates XML ({contentType}) but unable to parse the root part content as XML: {ex.Message}", ex);
                }
            }

            // Check if we have JSON - if we do, attempt to load it into a JToken
            //TODO: expand this list to include JSON-based content types e.g. application/ld+json
            if (contentType.StartsWith("text/json", StringComparison.InvariantCultureIgnoreCase) || contentType.StartsWith("application/json", StringComparison.InvariantCultureIgnoreCase))
            {
                try
                {
                    return JToken.Parse(decodedContent);
                }
                catch (Exception ex)
                {
                    throw new ApplicationException($"ContentType indicates JSON ({contentType}) but unable to parse the root part content as JSON: {ex.Message}", ex);
                }
            }

            return decodedContent;
        }

        /// <summary>
        /// Updates the root body part with the supplied <see cref="JToken"/> content.
        /// </summary>
        /// <param name="bodyContent"><see cref="JToken"/> instance containing the body content.</param>
        public void UpdateRootBodyContent(JToken bodyContent)
        {
            UpdateBodyContent(RootPartIndex, bodyContent);
        }

        /// <summary>
        /// Updates the root body part with the supplied <see cref="XmlDocument"/> content.
        /// </summary>
        /// <param name="bodyContent"><see cref="XmlDocument"/> instance containing the body content.</param>
        public void UpdateRootBodyContent(XmlDocument bodyContent)
        {
            UpdateBodyContent(RootPartIndex, bodyContent);
        }

        /// <summary>
        /// Updates the root body part with the supplied text content, optionally encoding it.
        /// </summary>
        /// <param name="bodyContent">Body content as a text value.</param>
        /// <param name="contentType">Type of content supplied.</param>
        public void UpdateRootBodyContent(string bodyContent, string contentType = "text/plain")
        {
            UpdateBodyContent(RootPartIndex, bodyContent);
        }

        /// <summary>
        /// Updates the body part with the given index with the supplied <see cref="JToken"/> content.
        /// </summary>
        /// <param name="partIndex">Index of the part to update.</param>
        /// <param name="bodyContent"><see cref="JToken"/> instance containing the body content.</param>
        public void UpdateBodyContent(int? partIndex, JToken bodyContent)
        {
            JObject bodyObject = Body.Where(p => p?["$part"]?.Value<int>() == partIndex).FirstOrDefault() as JObject;
            if (bodyObject != null)
            {
                bodyObject[ContentPropertyName] = bodyContent;
                bodyObject[ContentTypePropertyName] = "text/json";
                bodyObject[ContentEncodingPropertyName] = "none";
            }
        }

        /// <summary>
        /// Updates the body part with the given index with the supplied <see cref="XmlDocument"/> content.
        /// </summary>
        /// <param name="partIndex">Index of the part to update.</param>
        /// <param name="bodyContent"><see cref="XmlDocument"/> instance containing the body content.</param>
        public void UpdateBodyContent(int? partIndex, XmlDocument bodyContent)
        {
            JObject bodyObject = Body.Where(p => p?["$part"]?.Value<int>() == partIndex).FirstOrDefault() as JObject;
            if (bodyObject != null)
            {
                bodyObject[ContentPropertyName] = Convert.ToBase64String(Encoding.UTF8.GetBytes(bodyContent.DocumentElement.OuterXml));
                bodyObject[ContentTypePropertyName] = "application/xml";
                bodyObject[ContentEncodingPropertyName] = "base64";
            }
        }

        /// <summary>
        /// Updates the body part with the given index with the supplied text content.
        /// </summary>
        /// <param name="partIndex">Index of the part to update.</param>
        /// <param name="bodyContent">Body content as a text value.</param>
        /// <param name="contentType">Type of content supplied.</param>
        public void UpdateBodyContent(int? partIndex, string bodyContent, string contentType = "text/plain")
        {
            JObject bodyObject = Body.Where(p => p?["$part"]?.Value<int>() == partIndex).FirstOrDefault() as JObject;
            if (bodyObject != null)
            {
                // Attempt to determine if we should encode the content
                // TODO: determine other content types we can allow through without encoding - at the moment we only support plain text and CSV files.
                if (string.Compare(contentType, "text/plain", StringComparison.InvariantCultureIgnoreCase) != 0 && string.Compare(contentType, "text/csv", StringComparison.InvariantCultureIgnoreCase) != 0)
                {
                    bodyObject[ContentPropertyName] = Convert.ToBase64String(Encoding.UTF8.GetBytes(bodyContent));
                    bodyObject[ContentTypePropertyName] = contentType;
                    bodyObject[ContentEncodingPropertyName] = "base64";
                }
                else
                {
                    bodyObject[ContentPropertyName] = bodyContent;
                    bodyObject[ContentTypePropertyName] = contentType;
                    bodyObject[ContentEncodingPropertyName] = "none";
                }
            }
        }

        /// <summary>
        /// Gets the root part message content as an encoded content object.
        /// </summary>
        /// <returns><see cref="JObject"> with encoded content</returns>
        public JObject GetEncodedRootPartContent()
        {
            // If no root part is set, and there is no body, then return null
            if (RootPartIndex == null && (Body == null || Body.Count == 0))
            {
                return null;
            }

            // If a root part is not set, but we have at least one body, then throw an exception
            if (RootPartIndex == null && (Body != null && Body.Count > 0))
            {
                throw new ApplicationException($"No rootPart property is set, but there are {Body?.Count} body parts defined");
            }

            JObject bodyPart = RootBodyPart;

            // Check if we have a body part
            if (bodyPart == null)
            {
                throw new ApplicationException($"Unable to find a body part with index {RootPartIndex}");
            }

            string contentEncoding = bodyPart?[ContentEncodingPropertyName]?.ToString() ?? "none";
            string contentType = bodyPart?[ContentTypePropertyName]?.ToString() ?? "none";
            JToken content = bodyPart?[ContentPropertyName];

            // If we have no body, then return null
            if (content == null)
            {
                return null;
            }

            string encodedContent;

            // If we're not base64 encoded, then encode it
            if (string.Compare(contentEncoding, "base64", true) != 0)
            {
                // Encode the content - assume UTF8
                try
                {
                    //TODO: The ContentType might indicate the encoding used (e.g. text/csv; charset=utf-7) - use this and Encoding.GetEncoding() to determine which encoding to use
                    encodedContent = Convert.ToBase64String(Encoding.UTF8.GetBytes(content.ToString()));
                }
                catch (Exception ex)
                {
                    throw new ApplicationException($"An error occurred trying to encode the root part content using {contentEncoding}: {ex.Message}", ex);
                }
            }
            else
            {
                // Assume we have encoded text
                encodedContent = content.Value<string>();
            }

            return new JObject(
                    new JProperty(ContentTypePropertyName, contentType),
                    new JProperty(ContentPropertyName, encodedContent)
                );
        }


        /// <summary>
        /// Gets a property with the specified name from the header property bag.
        /// </summary>
        /// <typeparam name="T">Type of property to return.</typeparam>
        /// <param name="propertyName">name of the property to get.</param>
        /// <returns>Property value.</returns>
        public T GetProperty<T>(string propertyName)
        {
            Argument.AssertNotNullOrEmpty(propertyName, nameof(propertyName));

            JToken property = Properties?[propertyName];

            if (property == null)
            {
                return default;
            }

            T value;

            try
            {
                value = property.Value<T>();
            }
            catch (Exception ex)
            {
                throw new ApplicationException($"Unable to get the property {propertyName} as type {typeof(T)} because of this error: {ex.Message}", ex);
            }

            return value;
        }

        /// <summary>
        /// Gets a routing property with the specified name from the header property bag.
        /// </summary>
        /// <typeparam name="T">Type of routing property to return.</typeparam>
        /// <param name="propertyName">name of the routing property to get.</param>
        /// <returns>Routing property value.</returns>
        public T GetRoutingProperty<T>(string propertyName)
        {
            Argument.AssertNotNullOrEmpty(propertyName, nameof(propertyName));

            JToken property = Routing?[propertyName];

            if (property == null)
            {
                return default;
            }

            return property.Value<T>();
        }

        /// <summary>
        /// Returns the envelope as a <see cref="JObject"/> instance.
        /// </summary>
        /// <returns>A <see cref="JObject"/> instance.</returns>
        public JObject ToJObject()
        {
            return _envelope;
        }

        /// <summary>
        /// Returns the internal JSON for the envelope.
        /// </summary>
        /// <returns>Internal JSON as a string.</returns>
        public override string ToString()
        {
            return _envelope?.ToString();
        }

        /// <summary>
        /// Validates that the <see cref="JObject"/> instance we have contains a valid envelope.
        /// </summary>
        private void ValidateEnvelope()
        {
            // Check if we have a null instance
            if (_envelope is null)
            {
                throw new ApplicationException($"The envelope instance is null");
            }

            // Check that we have a header
            if (_envelope?["header"] == null || !(_envelope?["header"] is JObject))
            {
                throw new ApplicationException($"Envelope is missing a header object");
            }
        }
    }
}
