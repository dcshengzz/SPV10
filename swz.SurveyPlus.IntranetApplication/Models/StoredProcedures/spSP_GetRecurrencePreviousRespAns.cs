using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models
{
    public static class spSP_GetRecurrencePreviousRespAns
    {
        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetRecurrencePreviousRespAns));

        /// <summary>
        /// Returns values for pre-populated fields based on the 'previous' response in the 'previous' survey.
        /// This method never returns null. If it doesn't find any data then an empty dictionary is returned.
        /// </summary>
        public static async Task<Dictionary<string, object>> GetRecurrencePreviousRespAns(Guid previousDplyId, Guid qnnId, Guid previousRespId)
        {
            if (Guid.Empty.Equals(previousDplyId))
            {
                throw new ArgumentException("previousDplyId may not be empty", "previousDplyId");
            }
            if (Guid.Empty.Equals(qnnId))
            {
                throw new ArgumentException("qnnId may not be empty", "qnnId");
            }
            if (Guid.Empty.Equals(previousRespId))
            {
                throw new ArgumentException("previousRespId may not be empty", "previousRespId");
            }

            try
            {
                var param = new Dictionary<string, object>
                {
                    {"DplyId", previousDplyId},
                    {"QnnId", qnnId},
                    {"RespId", previousRespId}
                };

                List<Dictionary<string, object>> result = await Execute(param);
                if(!result.Any())
                {
                    _logger.LogWarning(nameof(GetRecurrencePreviousRespAns) + " - unexpected empty response data for previousDplyid={0}, qnnId={1}, previousRespId={2}", previousDplyId, qnnId, previousRespId);
                    return new Dictionary<string, object>(Constants.Comparers.AliasCaseInsensitive);
                }
                else
                {
                    return new Dictionary<string, object>(result[0], Constants.Comparers.AliasCaseInsensitive);
                }
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(GetRecurrencePreviousRespAns) + " -  caught unexpected exception, previousDplyid={0}, qnnId={1}, previousRespId={2}", previousDplyId, qnnId, previousRespId);
                throw;
            }
        }

        private static async Task<List<Dictionary<string, object>>> Execute(Dictionary<string, object> param)
        {
            if (param == null || param.Count == 0)
            {
                throw new ArgumentException("param may not be null", "param");
            }

            return await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetRecurrencePreviousRespAns,
                    param,
                    new Dictionary<string, object>());
        }
    }
}
