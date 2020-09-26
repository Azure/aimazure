using System;

namespace Microsoft.AzureIntegrationMigration.Core
{
    /// <summary>
    /// Provides Argument validation methods.
    /// </summary>
    public static class Argument
    {
        /// <summary>
        /// Checks that the given argument is not null.
        /// </summary>
        /// <param name="value">Argument value to check.</param>
        /// <param name="argumentName">Name of argument to check.</param>
        public static void AssertNotNull(object value, string argumentName)
        {
            if (value == null)
            {
                throw new ArgumentNullException($"Argument {argumentName} must not be null");
            }
        }

        /// <summary>
        /// Checks that the given argument is not null.
        /// </summary>
        /// <param name="value">Argument value to check.</param>
        /// <param name="argumentName">Name of argument to check.</param>
        public static void AssertNotNullOrEmpty(string value, string argumentName)
        {
            if (string.IsNullOrEmpty(value))
            {
                throw new ArgumentNullException($"Argument {argumentName} must not be null or empty");
            }
        }
    }
}
