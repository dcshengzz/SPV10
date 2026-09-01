using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Models.StoredProcedures
{
    public static class spSP_GetRespAnsWithDetailsDataCollection
    {
        public class GetRespAnsWithDetailsDataCollectionException : Exception
        {
            public GetRespAnsWithDetailsDataCollectionException(Guid dplyId, Guid qnnId, bool getProps, string commaDelimitedStatusIds, Exception innerException)
                : base($"{Constants.StoredProcedure.spSP_GetRespAnsWithDetailsDataCollection} encountered an error for dplyId={dplyId}, qnnId={qnnId}, getProps={getProps}, commaDelimitedStatusIds={commaDelimitedStatusIds}", innerException) { }
        }

        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(spSP_GetRespAnsWithDetailsDataCollection));

        public static async Task<(int, List<Dictionary<string, object>>)> GetRespAnsWithDetailsDataCollectionAsync(
            Guid dplyId, 
            Guid qnnId, 
            bool getProps,
            int skip = 0,
            int take = 200,
            string commaDelimitedStatusIds = "")
        {
            if (Guid.Empty.Equals(dplyId)) throw new ArgumentException(nameof(dplyId));
            if (Guid.Empty.Equals(qnnId)) throw new ArgumentException(nameof(qnnId));
            try
            {
                if (commaDelimitedStatusIds == null) commaDelimitedStatusIds = "";
                Dictionary<string, object> spParams = new Dictionary<string, object>
                {
                    {"DplyId", dplyId},
                    {"QnnId", qnnId},
                    {"GetProps", getProps ? 1 : 0},
                    {"Skip", skip },
                    {"Take", take },
                    {"StatusList",commaDelimitedStatusIds}  //comma delimited QNN_STATUS.Id 
                };

                int colCount = 0;
                Dictionary<string, object> spOutParams = new Dictionary<string, object>
                {
                    {"ColCount", colCount}
                };

                //Response User Info
                List<Dictionary<string, object>> items = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(Constants.StoredProcedure.spSP_GetRespAnsWithDetailsDataCollection,
                    spParams, spOutParams);

                colCount = (int)spOutParams["ColCount"];

                return (colCount, items);
            }
            catch(Exception e)
            {
                logger.LogDebug(e, nameof(GetRespAnsWithDetailsDataCollectionAsync) + " - caught unexpected exception, dplyId={0}, qnnId={1}, getProps={2}, skip={3}, take={4}", dplyId, qnnId, getProps, skip, take);
                throw new GetRespAnsWithDetailsDataCollectionException(dplyId, qnnId, getProps, commaDelimitedStatusIds, e);
            }
        }
    }
}
