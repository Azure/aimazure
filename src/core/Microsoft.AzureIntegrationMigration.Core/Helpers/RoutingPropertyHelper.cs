using System;
using System.Xml;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Entities;

namespace Microsoft.AzureIntegrationMigration.Core.Helpers
{
    /// <summary>
    /// Helper class for RoutingProperty logic.
    /// </summary>
    public static class RoutingPropertyHelper
    {
        /// <summary>
        /// Defines the value for the literal property type.
        /// </summary>
        public const string PropertyTypeLiteral = "literal";

        /// <summary>
        /// Defines the value for the XPath property type.
        /// </summary>
        public const string PropertyTypeXPath = "xpath";

        /// <summary>
        /// Defines the value for the Property property type.
        /// </summary>
        public const string PropertyTypeProperty = "property";

        /// <summary>
        /// Calculates the routing properties for the given envelope.
        /// </summary>
        /// <param name="routingProperties"><see cref="JObject"/> instance containing the routing properties.</param>
        /// <param name="envelope"><see cref="Envelope"/> instance containing the envelope message.</param>
        public static void CalculateRoutingProperties(JObject routingProperties, Envelope envelope)
        {
            // The routing properties are an array of XPath values.
            // We can only use them if the body of the message is XML, OR if they are a hard-coded value i.e. no XPath.
            JArray propertiesArray = routingProperties?["routingProperties"] as JArray;

            // Get the decoded root part content
            var bodyContent = envelope.GetDecodedRootPartContent();

            // Loop through the properties
            if (propertiesArray != null)
            {
                foreach (JObject property in propertiesArray)
                {
                    // Format for a property is:
                    // {
                    //      "propertyName": "sample",
                    //      "propertyType": "xpath|literal|property"
                    //      "propertyValue: "{string}"
                    // }
                    if (CalculateRoutingProperty(property, envelope, bodyContent, out string propertyName, out string propertyValue))
                    {
                        envelope.Routing[propertyName] = propertyValue;
                    }
                }
            }
        }

        /// <summary>
        /// Demotes message properties for the given envelope. Values specified in the properties for the envelope are updated
        /// into the body, using the XPath or JPath specified in the routingProperties.
        /// </summary>
        /// <param name="routingProperties"><see cref="JObject"/> instance containing the routing properties.</param>
        /// <param name="envelope"><see cref="Envelope"/> instance containing the envelope message.</param>
        public static void DemoteMessageProperties(JObject routingProperties, Envelope envelope)
        {
            // The routing properties are an array of XPath values.
            // We can only use them if the body of the message is XML.
            JArray propertiesArray = routingProperties?["routingProperties"] as JArray;

            // Get the decoded root part content
            var bodyContent = envelope.GetDecodedRootPartContent();
            bool updateBody = false;

            // Loop through the properties
            if (propertiesArray != null)
            {
                foreach (JObject property in propertiesArray)
                {
                    // Format for a property is:
                    // {
                    //      "propertyName": "sample",
                    //      "propertyType": "xpath|literal|property"
                    //      "propertyValue: "{string}"
                    // }

                    if (DemoteMessageProperty(property, envelope, bodyContent))
                    {
                        updateBody = true;
                    }
                }
            }

            if (updateBody)
            {
                if (bodyContent is JToken)
                {
                    envelope.UpdateRootBodyContent(bodyContent as JToken);
                }
                else if (bodyContent is XmlDocument)
                {
                    envelope.UpdateRootBodyContent(bodyContent as XmlDocument);
                }
                else
                {
                    envelope.UpdateRootBodyContent(bodyContent.ToString(), envelope.RootBodyPartContentType);
                }
            }
        }

        /// <summary>
        /// Attempts to calculate a routing property value from the supplied <see cref="JObject"/> property instance and <see cref="XmlDocument"/> root part content instance.
        /// </summary>
        /// <param name="property"><see cref="JObject"/> property instance.</param>
        /// <param name="envelope"><see cref="Envelope"/> instance containing the envelope message.</param>
        /// <param name="bodyContent">An object instance representing the root part content (e.g null, XmlDocument, or JToken/JProperty/JObject).</param>
        /// <param name="propertyName">Output property name.</param>
        /// <param name="calculatedPropertyValue">Output calculated property value.</param>
        /// <returns>True if we have a Property value to set.</returns>
        public static bool CalculateRoutingProperty(JObject property, Envelope envelope, object bodyContent, out string propertyName, out string calculatedPropertyValue)
        {
            Argument.AssertNotNull(property, nameof(property));

            // Get the values from the property
            string propertyType = property?["propertyType"]?.Value<string>()?.ToLower();
            propertyName = property?["propertyName"]?.Value<string>();
            string propertyValue = property?["propertyValue"]?.Value<string>();

            // Check we have a property name
            if (string.IsNullOrWhiteSpace(propertyName))
            {
                throw new ApplicationException($"RoutingProperty has a blank propertyName value");
            }

            // Check we have a property type
            if (string.IsNullOrWhiteSpace(propertyType))
            {
                throw new ApplicationException($"RoutingProperty {propertyName} has a blank propertyType value");
            }

            // Switch by PropertyType
            switch (propertyType)
            {
                case PropertyTypeLiteral:
                    {
                        // Just use the value set in the property as the calculated value
                        calculatedPropertyValue = propertyValue;
                        return true;
                    }
                case PropertyTypeXPath:
                    {
                        // Lookup a value using XPath against an XmlDocument
                        // We need an XmlDocument instance
                        if (bodyContent == null || !(bodyContent is XmlDocument))
                        {
                            // Unable to process this routing property
                            // We don't throw an exception, we just return false
                            calculatedPropertyValue = null;
                            return false;
                        }

                        // Attempt to run the XPath over the XmlDocument
                        try
                        {
                            XmlNode node = ((XmlDocument)bodyContent).SelectSingleNode(propertyValue);
                            if (node != null)
                            {
                                // Use the node value (or inner text if value is null) as the calculated value
                                calculatedPropertyValue = node.Value ?? node.InnerText;
                            }
                            else
                            {
                                // XPath didn't select a node
                                calculatedPropertyValue = null;
                            }
                            return true;
                        }
                        catch (Exception ex)
                        {
                            throw new ApplicationException($"Unable to set RoutingProperty {propertyName} using xpath '{propertyValue}': {ex.Message}", ex);
                        }
                    }
                case PropertyTypeProperty:
                    {
                        // Use a given property value from the Properties property bag
                        try
                        {
                            calculatedPropertyValue = envelope.GetProperty<string>(propertyValue);
                            return true;
                        }
                        catch (Exception ex)
                        {
                            throw new ApplicationException($"Unable to set RoutingProperty {propertyName} using property '{propertyValue}': {ex.Message}", ex);
                        }
                    }
                default:
                    {
                        // Unsupported PropertyType value
                        throw new ApplicationException($"RoutingProperty {propertyName} has an unsupported type value of {propertyType}");
                    }
            }
        }

        /// <summary>
        /// Attempts to calculate a routing property value from the supplied <see cref="JObject"/> property instance and <see cref="XmlDocument"/> root part content instance.
        /// </summary>
        /// <param name="property"><see cref="JObject"/> property instance.</param>
        /// <param name="envelope"><see cref="Envelope"/> instance containing the envelope message.</param>
        /// <param name="bodyContent">An object instance representing the root part content (e.g null, XmlDocument, or JToken/JProperty/JObject).</param>
        /// <param name="propertyName">Output property name.</param>
        /// <param name="calculatedPropertyValue">Output calculated property value.</param>
        /// <returns>True if we have a Property value to set.</returns>
        public static bool DemoteMessageProperty(JObject property, Envelope envelope, object bodyContent)
        {
            Argument.AssertNotNull(property, nameof(property));

            // Get the values from the property
            string propertyType = property?["propertyType"]?.Value<string>()?.ToLower();
            string propertyName = property?["propertyName"]?.Value<string>();
            string propertyValue = property?["propertyValue"]?.Value<string>();

            // Check we have a property name
            if (string.IsNullOrWhiteSpace(propertyName))
            {
                throw new ApplicationException($"RoutingProperty has a blank propertyName value");
            }

            // Check we have a property type
            if (string.IsNullOrWhiteSpace(propertyType))
            {
                throw new ApplicationException($"RoutingProperty {propertyName} has a blank propertyType value");
            }

            // Switch by PropertyType
            switch (propertyType)
            {
                case PropertyTypeXPath:
                    {
                        // Lookup a value using XPath against an XmlDocument
                        // We need an XmlDocument instance
                        if (bodyContent == null || !(bodyContent is XmlDocument))
                        {
                            // Unable to process this routing property
                            // We don't throw an exception, we just return false
                            return false;
                        }

                        // Attempt to run the XPath over the XmlDocument
                        try
                        {
                            XmlNode node = ((XmlDocument)bodyContent).SelectSingleNode(propertyValue);
                            if (node != null)
                            {
                                // Select the corresponding property from the envelope
                                string envelopePropertyValue = envelope.GetProperty<string>(propertyName);
                                if (envelopePropertyValue != null)
                                {
                                    // Attempt to update the node value to the property value
                                    if (node is XmlElement)
                                    {
                                        node.InnerText = envelopePropertyValue;
                                    }
                                    else if (node is XmlAttribute)
                                    {
                                        node.Value = envelopePropertyValue;
                                    }
                                    else
                                    {
                                        node.Value = envelopePropertyValue;
                                    }
                                    return true;
                                }
                                return false;
                            }
                            else
                            {
                                // XPath didn't select a node
                                return false;
                            }
                        }
                        catch (Exception ex)
                        {
                            throw new ApplicationException($"Unable to set RoutingProperty {propertyName} using xpath '{propertyValue}': {ex.Message}", ex);
                        }
                    }
                default:
                    {
                        // Unsupported PropertyType value
                        throw new ApplicationException($"RoutingProperty {propertyName} has a type value of {propertyType} which is unsupported for property demotion");
                    }
            }
        }
    }
}
