using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_GetDueDate
    {
        private static readonly ILogger logger
            = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetDueDate));

        /// <summary>
        /// Returns the sample-specific DueDate based on either QNN_DPLY_SAMPLE_DUEDATE or the DateEnd in QNN_DPLY.
        /// Note that this is the due-date before applying DaysUpdate (which is left to caller's business logic). 
        /// </summary>
        public static async Task<DateTime> DueDateFor(QNN_DPLY_SAMPLE_INFO dlsi)
        {
            return await DueDateFor(dlsi.DplyId, dlsi.ListSampleId);
        }

        /// <summary>
        /// Returns the sample-specific DueDate based on either QNN_DPLY_SAMPLE_DUEDATE or the DateEnd in QNN_DPLY.
        /// Note that this is the due-date before applying DaysUpdate (which is left to caller's business logic). 
        /// </summary>
        public static async Task<DateTime> DueDateFor(Guid dplyId, Guid listSampleId)
        {
            try
            {
                Dictionary<string, object> outParams = new Dictionary<string, object>();
                outParams["DueDate"] = DateTime.MinValue;  //ExecuteStoredProcedureExAsync will fail for DbNull here :-(
                await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                    Constants.StoredProcedure.spSP_GetDueDate,
                    new Dictionary<string, object>
                    {
                        {"DplyId",dplyId},
                        {"ListSampleId", listSampleId}
                    },
                    outParams);
                DateTime? dueDate = (DateTime?)outParams["DueDate"];
                if (dueDate == null) throw new NullReferenceException("Unexpected null returned for DueDate");
                return dueDate.Value;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(DueDateFor) + " - caught unexpected exception, dplyId={0}, listSampleId={1}", dplyId, listSampleId);
                }
                throw;
            }
        }
    }
}
