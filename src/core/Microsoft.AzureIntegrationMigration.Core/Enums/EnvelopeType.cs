namespace Microsoft.AzureIntegrationMigration.Core.Enums
{
    /// <summary>
    /// Defines the types of envelope.
    /// </summary>
    public enum EnvelopeType
    {
        /// <summary>
        /// Default value of none for an envelope type that isn't specified.
        /// </summary>
        None = 0,

        /// <summary>
        /// Specifies an envelope with arbitrary message content.
        /// </summary>
        Content,

        /// <summary>
        /// Specifies an envelope that contains an ack.
        /// </summary>
        Ack,

        /// <summary>
        /// Specifies an envelope that contains a nack.
        /// </summary>
        Nack
    }
}
