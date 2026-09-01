using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Class to invoke the CleanupRecentSamlAssertion stored procedure which deletes the expired rows
    /// </summary>
    public class CleanupRecentSamlAssertion
    {
        private static readonly ILogger logger
            = DefaultApplicationLogging.CreateLogger(typeof(CleanupRecentSamlAssertion));

        public static async Task Execute()
        {
            try
            {
                Dictionary<string, object> outParams = new Dictionary<string, object>();
                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.CleanupSamlRecentAssertion,
                    new Dictionary<string, object>(),
                    new Dictionary<string, object>());
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(Execute) + " - caught unexpected exception");
                }
                throw;
            }
        }
    }
}
