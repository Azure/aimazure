namespace Microsoft.AzureIntegrationMigration.Core.Enums
{
    /// <summary>
    /// Defines the allowed authentication endpoints.
    /// </summary>
    public enum AzureAuthenticationEndpoints
    {
        /// <summary>
        /// Defines the Azure Resource Manager API endpoint.
        /// </summary>
        ManagementApi,

        /// <summary>
        /// Defines an Azure API Management endpoint.
        /// </summary>
        Apim,

        /// <summary>
        /// Defines an Azure Logic Apps endpoint.
        /// </summary>
        LogicApps
    }
}
