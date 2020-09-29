// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
using System;
using System.Net;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

using Newtonsoft.Json.Linq;

using Microsoft.AzureIntegrationMigration.Core.Entities;
using Microsoft.AzureIntegrationMigration.Core.Enums;
using Microsoft.AzureIntegrationMigration.Core.Exceptions;

namespace Microsoft.AzureIntegrationMigration.Core.Helpers
{
    /// <summary>
    /// Helper class for AzureResponse instances.
    /// </summary>
    public static class AzureResponseHelper
    {
        /// <summary>
        /// Sets custom response headers from headers in the supplied <see cref="AzureResponseException"/> instance.
        /// </summary>
        /// <param name="req"><see cref="HttpRequest"/> instance containing the response.</param>
        /// <param name="arex"><see cref="AzureResponseException"/> instance to get headers from.</param>
        public static void SetCustomResponseHeaders(HttpRequest req, AzureResponseException arex)
        {
            Argument.AssertNotNull(req, nameof(req));
            Argument.AssertNotNull(arex, nameof(arex));

            // Set AIM TracingUrl header
            if (arex.Response != null && arex.Response.Headers.ContainsKey(HeaderConstants.AimTracingUrl))
            {
                req?.HttpContext?.Response?.Headers?.Add(HeaderConstants.AimTracingUrl, arex.Response.Headers[HeaderConstants.AimTracingUrl]);
            }
        }

        /// <summary>
        /// Creates a new <see cref="ContentResult"/> instance from the supplied message.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance with details about the received request.</param>
        /// <param name="message">Fault message to use.</param>
        /// <param name="logPrefix">Logging prefix to use.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use.</param>
        /// <returns><see cref="ContentResult"/> instance.</returns>
        public static ContentResult CreateFaultObjectResult(RequestDetails requestDetails, string message, string logPrefix, ILogger log)
        {
            Argument.AssertNotNull(requestDetails, nameof(requestDetails));
            Argument.AssertNotNullOrEmpty(message, nameof(message));
            Argument.AssertNotNullOrEmpty(logPrefix, nameof(logPrefix));
            Argument.AssertNotNull(log, nameof(log));

            string errorMessage = $"{message}";
            log.LogError($"{logPrefix}{errorMessage}");

            return new ContentResult()
            {
                Content = BuildFaultMessage(message, null, null, requestDetails.Source).ToString(),
                ContentType = "application/json",
                StatusCode = 500
            };
        }

        /// <summary>
        /// Creates a new <see cref="ContentResult"/> instance from the supplied message.
        /// </summary>
        /// <param name="message">Message to use in the result.</param>
        /// <param name="response"><see cref="AzureResponse"/> instance to use.</param>
        /// <param name="logPrefix">Logging prefix to use.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use.</param>
        /// <returns><see cref="ContentResult"/> instance.</returns>
        public static ContentResult CreateFaultObjectResult(string message, AzureResponse response, string logPrefix, ILogger log)
        {
            Argument.AssertNotNullOrEmpty(message, nameof(message));
            Argument.AssertNotNull(response, nameof(response));
            Argument.AssertNotNullOrEmpty(logPrefix, nameof(logPrefix));
            Argument.AssertNotNull(log, nameof(log));

            string errorMessage = $"{message}: {response}";
            log.LogError($"{logPrefix}{errorMessage}");

            return new ContentResult()
            {
                Content = BuildFaultMessage(message, response).ToString(),
                ContentType = "application/json",
                StatusCode = 500
            };
        }

        /// <summary>
        /// Creates a new <see cref="ContentResult"/> instance from the supplied message and <see cref="AzureResponseException"/> instance.
        /// </summary>
        /// <param name="message">Message to use in the result.</param>
        /// <param name="arex"><see cref="AzureResponseException"/> instance to use in the result.</param>
        /// <param name="logPrefix">Logging prefix to use.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use.</param>
        /// <returns><see cref="ContentResult"/> instance.</returns>
        public static ContentResult CreateFaultObjectResult(string message, AzureResponseException arex, string logPrefix, ILogger log)
        {
            Argument.AssertNotNullOrEmpty(message, nameof(message));
            Argument.AssertNotNull(arex, nameof(arex));
            Argument.AssertNotNullOrEmpty(logPrefix, nameof(logPrefix));
            Argument.AssertNotNull(log, nameof(log));

            string errorMessage = $"{message}: {arex.Message}";
            log.LogError($"{logPrefix}{errorMessage}. Stack Trace: {arex.StackTrace}");

            JObject fault;
            // Check if the exception contains a Fault already
            if (arex.Fault != null)
            {
                // We already have a Fault message - just return this
                fault = arex.Fault;
            }
            else
            {
                fault = BuildFaultMessage(message, arex?.Response?.StatusCode.ToString(), arex?.Response?.Reason, arex?.Response?.RequestUri.ToString());
            }

            return new ContentResult()
            {
                Content = fault.ToString(),
                ContentType = "application/json",
                StatusCode = 500
            };
        }

        /// <summary>
        /// Creates a new <see cref="ContentResult"/> instance from the supplied message and <see cref="Exception"/> instance.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> instance with details about the received request.</param>
        /// <param name="message">Message to use in the result.</param>
        /// <param name="ex"><see cref="Exception"/> instance to use in the result.</param>
        /// <param name="logPrefix">Logging prefix to use.</param>
        /// <param name="log"><see cref="ILogger"/> instance to use.</param>
        /// <returns><see cref="ContentResult"/> instance.</returns>
        public static ContentResult CreateFaultObjectResult(RequestDetails requestDetails, string message, Exception ex, string logPrefix, ILogger log)
        {
            Argument.AssertNotNull(requestDetails, nameof(requestDetails));
            Argument.AssertNotNullOrEmpty(message, nameof(message));
            Argument.AssertNotNull(ex, nameof(ex));
            Argument.AssertNotNullOrEmpty(logPrefix, nameof(logPrefix));
            Argument.AssertNotNull(log, nameof(log));

            string errorMessage = $"{message}: {ex.Message}";
            log.LogError($"{logPrefix}{errorMessage}. Stack Trace: {ex.StackTrace}");

            return new ContentResult()
            {
                Content = BuildFaultMessage(message, null, ex.Message, requestDetails.Source).ToString(),
                ContentType = "application/json",
                StatusCode = 500
            };
        }

        /// <summary>
        /// Builds a new <see cref="JObject"/> instance representing a fault.
        /// </summary>
        /// <param name="arex"><see cref="AzureResponseException"/> instance containing details about an error.</param>
        /// <returns><see cref="JObject"/> instance representing a fault.</returns>
        public static JObject BuildFaultMessage(AzureResponseException arex)
        {
            Argument.AssertNotNull(arex, nameof(arex));

            if (arex?.Fault?["fault"] != null)
            {
                return BuildFaultMessage(arex?.Fault?["fault"]?["faultMessage"]?.ToString(), arex?.Fault?["fault"]?["faultCode"]?.ToString(), arex?.Fault?["fault"]?["faultReason"]?.ToString(), arex?.Response?.RequestUri.ToString());
            }
            else
            {
                return BuildFaultMessage(arex?.Response?.BodyContent, arex?.Response?.StatusCode.ToString(), arex?.Response?.Reason, arex?.Response?.RequestUri.ToString());
            }
        }

        /// <summary>
        /// Builds a new <see cref="JObject"/> instance representing a fault.
        /// </summary>
        /// <param name="message"><see cref="Exception"/> instance containing exception information.</param>
        /// <returns><see cref="JObject"/> instance representing a fault.</returns>
        public static JObject BuildFaultMessage(Exception ex)
        {
            Argument.AssertNotNull(ex, nameof(ex));

            return BuildFaultMessage(ex.Message);
        }

        /// <summary>
        /// Builds a new <see cref="JObject"/> instance representing a fault.
        /// </summary>
        /// <returns><see cref="AzureResponse"/> instance returned by Azure, which may or may not contain a fault object.</returns>
        public static JObject BuildFaultMessage(AzureResponse response)
        {
            return BuildFaultMessage(null, response);
        }  

        /// <summary>
        /// Builds a new <see cref="JObject"/> instance representing a fault.
        /// </summary>
        /// <param name="message">Error message for this fault.</param>
        /// <returns><see cref="AzureResponse"/> instance returned by Azure, which may or may not contain a fault object.</returns>
        public static JObject BuildFaultMessage(string message, AzureResponse response)
        {
            Argument.AssertNotNullOrEmpty(message, nameof(message));
            Argument.AssertNotNull(response, nameof(response));

            // Check if the response already contains a fault
            if (response.IsFault)
            {
                // Return the BodyContent as a JSON fault object
                return response.BodyContentAsJson as JObject;
            }

            // Build a new Fault object from the response
            return BuildFaultMessage($"{message}: {response.BodyContent}", ((int)response.StatusCode).ToString(), response.Reason, response.RequestUri.ToString());
        }        

        /// <summary>
        /// Builds a new <see cref="JObject"/> instance representing a fault.
        /// </summary>
        /// <param name="message">Fault message.</param>
        /// <param name="code">Fault code.</param>
        /// <param name="reason">Fault reason.</param>
        /// <param name="actor">Fault actor.</param>
        /// <returns><see cref="JObject"/> instance representing a fault.</returns>
        public static JObject BuildFaultMessage(string message, string code = null, string reason = null, string actor = null)
        {
            Argument.AssertNotNullOrEmpty(message, nameof(message));

            return new JObject(
                    new JProperty("fault",
                        new JObject(
                            new JProperty("faultActor", actor ?? "(Unknown)"),
                            new JProperty("faultCode", code ?? "500"),
                            new JProperty("faultReason", reason ?? "Unknown error"),
                            new JProperty("faultCategory", "Error"),
                            new JProperty("faultMessage", message ?? "Unknown error")
                        )
                    )
                );
        }

        /// <summary>
        /// Looks at the response from the called route, and works out what to return back to the last caller.
        /// For example, if the route returned an ACK message, we return this.
        /// If the route returns a Fault, we create a new NACK message and return this.
        /// </summary>
        /// <param name="requestDetails"><see cref="RequestDetails"/> containing information about the original request.</param>
        /// <param name="routeResponse"><see cref="AzureResponse"/> instance returned from the call to the current route.</param>
        /// <param name="routeType">Type of route (used in logging).</param>
        /// <param name="routeName">Name of route (used in logging).</param>
        /// <param name="logPrefix">Log prefix.</param>
        /// <param name="log"><see cref="ILogger"/> instance used for logging.</param>
        /// <returns><see cref="IActionResult"/> instance with the result.</returns>
        public static IActionResult GenerateRouteResponse(RequestDetails requestDetails, AzureResponse routeResponse, string routeType, string routeName, string logPrefix, ILogger log)
        {
            Argument.AssertNotNull(requestDetails, nameof(requestDetails));
            Argument.AssertNotNull(routeResponse, nameof(routeResponse));
            Argument.AssertNotNullOrEmpty(routeType, nameof(routeType));
            Argument.AssertNotNullOrEmpty(routeName, nameof(routeName));
            Argument.AssertNotNullOrEmpty(logPrefix, nameof(logPrefix));
            Argument.AssertNotNull(log, nameof(log));

            // Check if we have a 200 response
            if (routeResponse.StatusCode == HttpStatusCode.OK)
            {
                // We should have an ACK envelope
                if (routeResponse.BodyEnvelopeType == EnvelopeType.Ack)
                {
                    // Return the ACK with a 200 code
                    log.LogDebug($"{logPrefix}Finished calling the next route {routeType} and received an ACK - returning result");
                    return new OkObjectResult(routeResponse.BodyContentAsJson);
                }
                else if (routeResponse.BodyEnvelopeType == EnvelopeType.Nack)
                {
                    // Return the NACK with a 200 code
                    log.LogDebug($"{logPrefix}Finished calling the next route {routeType} and received a NACK - returning result");
                    return new OkObjectResult(routeResponse.BodyContentAsJson);
                }
                else
                {
                    // Invalid envelope type
                    return CreateFaultObjectResult(requestDetails, $"{routeType} {routeName} returned an HTTP 200 but didn't return an ACK or NACK envelope - instead the envelope type is {routeResponse.BodyEnvelopeType}", logPrefix, log);
                }
            }

            // We have something other than a 200 response
            // Check if we have a Fault
            if (routeResponse.IsFault)
            {
                return CreateFaultObjectResult($"{routeType} {routeName} returned a Fault", routeResponse, logPrefix, log);
            }

            // Check we have returned content
            if (routeResponse.BodyContentLength == 0)
            {
                return CreateFaultObjectResult(requestDetails, $"No response content was returned after calling {routeType} {routeName}", logPrefix, log);
            }

            // Check that we have a JSON response from the route
            if (routeResponse.BodyContentAsJson == null || !(routeResponse.BodyContentAsJson is JObject))
            {
                return CreateFaultObjectResult($"Unable to parse the response from the {routeType} {routeName} as a JSON Object", routeResponse, logPrefix, log);
            }

            // We have content but it's not JSON - wrap the content in a Fault
            return CreateFaultObjectResult($"{routeType} {routeName} did not succeed and returned a non-JSON response", routeResponse, logPrefix, log);
        }
    }
}
