using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public class spSP_GetStatusResponseDetails
    {
        private static readonly ILogger logger
           = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetStatusResponseDetails));

        /// <summary>
        /// Represents a row in the results
        /// </summary>
        public class Item
        {
            /// <summary>
            /// Factory method to create instance of Item from one of the results Dictionary returned from
            /// executing the stored procedure
            /// </summary>
            /// <param name="data"></param>
            /// <returns></returns>
            public static Item FromResultsDictionary(Dictionary<string, object> data)
            {
                if (data == null) throw new ArgumentNullException(nameof(data));
                return new Item(
                    uid: (string)data[Constants.FieldName.UID], //wont be null
                    statusCode: (string)data["StatusCode"], //wont be null
                    statusTitle: (string)data[Constants.FieldName.StatusTitle], //wont be null
                    remarks: data[Constants.FieldName.Remarks].ToString() //may be DBNull whose ToString is ""
                );
            }

            public string UID { get; private set; }
            public string StatusCode { get; private set; }
            public string StatusTitle { get; private set; }
            public string Remarks { get; private set; }

            public Item(string uid, string statusCode, string statusTitle, string remarks)
            {
                this.UID = uid ?? throw new ArgumentNullException(nameof(uid));
                this.StatusCode = statusCode ?? throw new ArgumentNullException(nameof(statusCode));
                this.StatusTitle = statusTitle ?? throw new ArgumentNullException(nameof(statusTitle));
                this.Remarks = remarks ?? throw new ArgumentNullException(nameof(remarks));
            }
        }

        public static async Task<List<Item>> ExecuteAsync(
            Guid dplyId, 
            IEnumerable<QnnStatusId> statusIds, 
            bool isExcludeExempted)
        {
            try
            {
                //Concat the status guids to pass to the procedure
                string statusString = (statusIds == null) ? "" : string.Join( ',', statusIds.Select(sid => sid.Value.ToString()).ToList());

                Dictionary<string, object> spParams
                        = new Dictionary<string, object>
                        {
                            {"DplyId",dplyId},
                            {"StatusIds", statusString } 
                        };
                List<Dictionary<string, object>> result
                    = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(
                        Constants.StoredProcedure.spSP_GetStatusResponseDetails,
                        spParams,
                        new Dictionary<string, object>());
                List<Item> items = result
                    .Where(row => isExcludeExempted ? !Constants.StatusCodesForExempted.Contains(row["StatusCode"]) : true) //nasty hardcoded kludge
                    .Select(row => Item.FromResultsDictionary(row))
                    .ToList();
                return items;
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(ExecuteAsync) + " - caught unexpected exception, dplyId={0}", dplyId);
                }
                throw;
            }

        }
    }
}
