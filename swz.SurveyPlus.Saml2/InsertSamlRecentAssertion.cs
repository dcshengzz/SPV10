using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.Saml2
{
    /// <summary>
    /// Stored procedure invocation class for InsertSamlRecentAssertion which attempts to
    /// insert the unique Assertion ID and indicates if it was successful or not.
    /// This check is done as an INSERT with a catch for unique violations to avoid race
    /// conditions if more than one attempt is concurrently made to use the same Assertion ID.
    /// </summary>
    public class InsertSamlRecentAssertion
    {
        private static readonly ILogger logger
            = DefaultApplicationLogging.CreateLogger(typeof(InsertSamlRecentAssertion));

        public static async Task<bool> NewAssertion(string assertionID, DateTime expiration)
        {
            try
            {
                Dictionary<string, object> outParams = new Dictionary<string, object>();
                outParams["Success"] = false;  //ExecuteStoredProcedureExAsync will fail for DbNull here :-(
                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.InsertSamlRecentAssertion,
                    new Dictionary<string, object>
                    {
                        {"AssertionID",assertionID},
                        {"Expiration", expiration}
                    },
                    outParams);
                bool success = (bool)outParams["Success"];
                return success;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(NewAssertion) + " - caught unexpected exception, assertionID={0}, expiration={1}", assertionID, expiration);
                }
                throw;
            }
        }
    }
}
