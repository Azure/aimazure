namespace Microsoft.AzureIntegrationMigration.Core.Helpers
{
    /// <summary>
    /// List of known HTTP Header names.
    /// </summary>
    public class HeaderConstants
    {
        /// <summary>
        /// The name of the header used to indicate the Transfer Encoding.
        /// </summary>
        public const string TransferEncoding = "Transfer-Encoding";

        /// <summary>
        /// The name of the header used to indicate the Content Encoding.
        /// </summary>
        public const string ContentEncoding = "Content-Encoding";

        /// <summary>
        /// The name of the header used to indicate the AIM TrackingId.
        /// </summary>
        public const string ContentType = "Content-Type";

        /// <summary>
        /// Name of the header used for the APIM TraceUrl.
        /// </summary>
        public const string ApimTraceUrl = "Ocp-Apim-Trace-Location";

        /// <summary>
        /// The name of the header used to indicate the AIM TrackingId.
        /// </summary>
        public const string AimTrackingId = "Aim-Tracking-Id";

        /// <summary>
        /// The name of the header used to indicate the AIM TraceUrl.
        /// </summary>
        public const string AimTracingUrl = "Aim-Tracing-Url";

        /// <summary>
        /// The name of the header used to clear the AIM cache.
        /// </summary>
        public const string AimClearCache = "Aim-Clear-Cache";

        /// <summary>
        /// The name of the header used to indicate if tracing is enabled for AIM.
        /// </summary>
        public const string AimEnableTracing = "Aim-Enable-Tracing";                
    }
}
