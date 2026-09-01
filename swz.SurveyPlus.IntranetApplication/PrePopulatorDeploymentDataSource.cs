using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    public class PrePopulatorDeploymentDataSource : PrePopulator.IDataSource
    {
        private class Sample
        {
            public string Uid { get; private set; }
            public Guid RespId { get; private set; }

            public Sample(string uid, Guid respId)
            {
                this.Uid = uid ?? throw new ArgumentNullException(nameof(uid));
                this.RespId = respId;
            }
        }

        public static async Task<PrePopulatorDeploymentDataSource> NewInstance(Guid sourceDplyId)
        {
            ILogger<PrePopulatorDeploymentDataSource> logger = (ILogger<PrePopulatorDeploymentDataSource>)DefaultApplicationLogging.CreateLogger<PrePopulatorDeploymentDataSource>();
            PrePopulatorDeploymentDataSource instance = new PrePopulatorDeploymentDataSource(logger, sourceDplyId);
            await instance.Initialise();
            return instance;
        }

        private readonly ILogger<PrePopulatorDeploymentDataSource> logger;
        private readonly Guid sourceDplyId;

        private Guid sourceQnnId;
        private DynamicEntity sourceDply;
        private IList<Sample> samples;
        private bool hasMoreRecords;
        private int index = -1;
        private bool disposedValue;
        private IDictionary<string, object> response;
        private IDictionary<string, string> fieldNameByAlias; //Case-insensitive and maps any case to the official case

        private bool IsOnRecord { get => (hasMoreRecords && index >= 0); }

        private spSP_GetRespAnsRows spSP_GetRespAnsRows;

        /// <summary>
        /// Constructor is private, you must use the factory method to get an initialised instance
        /// </summary>
        private PrePopulatorDeploymentDataSource(
            ILogger<PrePopulatorDeploymentDataSource> logger,
            Guid sourceDplyId)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.sourceDplyId = sourceDplyId;
        }

        public bool HasAlias(string alias)
        {
            return fieldNameByAlias.ContainsKey(alias);
        }

        public string GetAnsVal(string alias)
        {
            if (IsOnRecord)
            {
                if(fieldNameByAlias.TryGetValue(alias, out string fieldName))
                {   //We do have this alias, so we expect it in the response
                    if (response.TryGetValue(alias, out object ansVal))
                    {
                        return Convert.ToString(ansVal);
                    }
                    else
                    {
                        throw new InternalException($"No value in response for {fieldName}");
                    }
                }
                else
                {   //We don't have this alias
                    return null;
                }
            }
            else
            {
                throw new InvalidOperationException("Not on a record");
            }
        }

        public string GetUid()
        {
            return IsOnRecord ? samples[index].Uid : null;
        }

        public async Task<bool> Next()
        {

            //TODO - we should skip duplicate UID (this could happen if the source is multi-response
            //       but then we need to address the multi-response issue properly first anyway

            if (disposedValue) throw new InvalidOperationException("This instance has been disposed");
            if (hasMoreRecords)
            {
                index++;
                hasMoreRecords = index < samples.Count;
                
            }
            response = hasMoreRecords ? await ReadCurrentResponse() : null;
            return hasMoreRecords;
        }

        public void Dispose()
        {
            // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
            Dispose(disposing: true);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    ; //This implementation has nothing needing explicit disposal
                }
                disposedValue = true;
            }
        }

        private async Task Initialise()
        {
            sourceDply = await DeploymentApplication.GetQnnDplyById(sourceDplyId);
            if (sourceDply == null)
                throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, sourceDplyId);

            bool unsupportedSourceDeploymentType
                    = (bool)sourceDply[Constants.FieldName.IsMultipleResponse]
                    || (bool)sourceDply[Constants.FieldName.IsAnonymous];
            if (unsupportedSourceDeploymentType)
            {
                throw new NotImplementedException("Source deployment may not be a multiple-response or anonymous survey.");
            }

            sourceQnnId = (Guid)sourceDply[Constants.FieldName.QnnId];

            fieldNameByAlias
                = (await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(sourceQnnId))
                .ToImmutableDictionary(
                    f => (string)f[Constants.FieldName.Name],
                    f => (string)f[Constants.FieldName.Name],
                    Constants.Comparers.AliasCaseInsensitive);

            //Currently following the old logic that used vSP_DeploymentSampleAndPeerSample, but does this make
            //sense as its "MergedUID"? And how does this work for multiple responses? (hint: it probably doesn't)
            EntityModel vSP_DeploymentSampleAndPeerSampleModel =
                    await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_DeploymentSampleAndPeerSample, Constants.Level.NoJoins);

            Filter byDplyIdWithResponse
                = Filter.And
                .Equal(sourceDplyId, Constants.FieldName.DplyId)
                .NotEqual(Null.Value, Constants.FieldName.RespId);

            List<DynamicEntity> sourceSampleAndPeerSampleEntity =
                await vSP_DeploymentSampleAndPeerSampleModel.GetAsync(byDplyIdWithResponse);

            //TODO - why do we not care about the isPrePopulated here?
            //TODO - for a multiple response source this can give us multiple rows for the same uid
            samples = sourceSampleAndPeerSampleEntity
                .Select(s => new Sample(
                    (string)s[Constants.FieldName.MergedUID],
                    (Guid)s[Constants.FieldName.RespId]))
                .ToImmutableList();

            hasMoreRecords = samples.Any();

            spSP_GetRespAnsRows = await spSP_GetRespAnsRows.GetInstanceUsingAppSettingsAsync();

            if (logger.IsEnabled(LogLevel.Debug))
            {
                logger.LogDebug(nameof(Initialise) + " - sourceDplyId={0} ({1}), samples.Count={2}, alias count={3}, hasMoreRecords={4}", sourceDplyId, (string)sourceDply[Constants.FieldName.Name], samples.Count, fieldNameByAlias.Count, hasMoreRecords);
            }
            if(logger.IsEnabled(LogLevel.Trace))
            {
                logger.LogTrace(nameof(Initialise) + " - fieldNames={0}", string.Join(", ", fieldNameByAlias.Values));
            }
        }

        private async Task<Dictionary<string, object>> ReadCurrentResponse()
        {
            Guid respId = samples[index].RespId;
            Dictionary<string, object> answers = (await spSP_GetRespAnsRows.ExecuteAsync(respId, spSP_GetRespAnsRows.Include.ResponseDataOnly)).Answers;
            if (answers == null)
                throw new NotFoundException("No answers found for respId={respId}");

            if (!answers.Any())
                throw new NotFoundException("Empty answers dictionary returned for respId={respId}");
            return answers; //Dictionary is case-sensitive
        }
    }
}
