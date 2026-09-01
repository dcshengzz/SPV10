using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Security;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    public interface IDevToolsService
    {
        public Task GenerateResponseData(User user, Guid dplyId, int count);
    }

    public class DevtoolsService : IDevToolsService
    {
        private ILogger<DevtoolsService> logger;

        public DevtoolsService(ILogger<DevtoolsService> logger)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task GenerateResponseData(User user, Guid dplyId, int count)
        {
            EntityModel qnnDplySampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);
            List<Guid> dlsis 
                = (await qnnDplySampleInfoModel.GetAsync(Filter.And.Equal(dplyId, Constants.FieldName.DplyId)))
                .Select(dm => (Guid)dm[Constants.FieldName.Id])
                .ToList();

            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            for (int i=0; i<count; i++)
            {
                Guid dlsi = dlsis[Random.Shared.Next(dlsis.Count)]; //just pick a random dlsi to update their response
                SurveyResponseUpdater updater = new SurveyResponseUpdater(dlsi);
                updater.IsEnableResponseVersionCheck = false; //disable check as I don't have the UpdatedDate handy
                updater.DataEditor = user;
                updater.CurrentTimeStamp = DateTime.Now.ToString(Constants.QnnDatetimeFormat); //<--- it doesnt validate this one!
                Dictionary<string, string> data = GenerateDataForBigTestFormV1();
                data["surveyResponseVersion"] = SurveyResponseVersionToken.FromQnnResp((DynamicEntity)null).Value; 
                string json = JsonConvert.SerializeObject(data);
                SurveyResponseUpdater.UpdateResult result = await updater.Update(SurveyResponseUpdater.Action.Save, json);
                if(!result.IsSuccess)
                {
                    throw new InternalException(result.Message);
                }
                if(logger.IsEnabled(LogLevel.Debug))
                {
                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    logger.LogDebug(nameof(GenerateResponseData) + " - generated {0} of {1} for dplyId={2}, dlsis.Count={3}, user={4} ({5}), elapsed minutes={6}", (i+1), count, dplyId, dlsis.Count, user?.Id, user?.Name, Math.Ceiling((double)duration/1000/60));
                }
            }
        }

        //for our first cut of this tool we'll just generate random values specific to BigTestForm_v1
        //later I hope to inespect form design and be able to generate data specific to a given form, though 
        //generating data compliant with its validation would be much harder
        private Dictionary<string, string> GenerateDataForBigTestFormV1()
        {
            Dictionary<string, string> data = new Dictionary<string, string>();
            //todo - BASIC_DATE_FIELD,DATE_TIME_FIELD,NOTES

            data.Add("BASIC_TEXT_FIELD", new AccessCode().ToString());

            //P01_A_01 .. P20_E_20
            Random rnd = Random.Shared;
            for (int page = 1; page <= 20; page++)
            {
                for (int row = 1; row <= 20; row++)
                {
                    for (char column = 'A'; column <= 'E'; column++)
                    {
                        string key = $"P{page:D2}_{column}_{row:D2}";
                        int value = rnd.Next(1000000);
                        data.Add(key, value.ToString());
                    }
                }
            }

            data.Add("LastSavedPage", "CoverPage");

            return data;
        }
    }

}
