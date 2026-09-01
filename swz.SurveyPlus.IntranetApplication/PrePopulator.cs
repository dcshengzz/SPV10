using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Dynamic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Class to pre-populate responses in a deployment (used for the manual pre-population in advance of starting a
    /// response, but currently not for the on-demand pre-population that can be configured for a recurring deployment)
    /// Warning: Trace level logging for this object is very verbose
    /// </summary>
    public class PrePopulator
    {
        public class Result
        {
            public ImmutableHashSet<string> DuplicateUids { get; private set; }
            public ImmutableHashSet<string> IgnoredUids { get; private set; }
            public ImmutableHashSet<string> ProcessedUids { get; private set; }

            public Result(ImmutableHashSet<string> duplicateUids, ImmutableHashSet<string> ignoredUids, ImmutableHashSet<string> processedUids)
            {
                this.DuplicateUids = duplicateUids ?? throw new ArgumentNullException(nameof(duplicateUids));
                this.IgnoredUids = ignoredUids ?? throw new ArgumentNullException(nameof(ignoredUids));
                this.ProcessedUids = processedUids ?? throw new ArgumentNullException(nameof(processedUids));
            }

            public override string ToString()
            {
                return $"[{nameof(Result)} : DuplicateUids.Count={DuplicateUids.Count}, IgnoredUids.Count={IgnoredUids.Count}, ProcessedUids.Count={ProcessedUids.Count}]";
            }
        }

        /// <summary>
        /// Interface to abstract the source of the pre-population data. 
        /// The datasource drives the pre-population by iterating a set of records (eg from deployment or csv etc)
        /// and presenting the UID to the pre-opulator and providing answer values on demand.
        /// </summary>
        public interface IDataSource : IDisposable
        {
            /// <summary>
            /// Move to next record
            /// </summary>
            /// <returns>false if there are no more records</returns>
            public Task<bool> Next();

            /// <summary>
            /// Returns the sample Uid for the current record
            /// </summary>
            /// <returns></returns>
            public string GetUid();

            //TODO - can probably remove this from interace as PrePopulater doesn't need it
            public bool HasAlias(string alias);

            /// <summary>
            /// Returns the answer value for the specified alias if available.
            /// (Would return null for alias that are not available)
            /// </summary>
            /// <param name="alias">alias, this is case-insensitive</param>
            public string GetAnsVal(string alias);
        }

        /// <summary>
        /// Used by the pre-populator to get information about the target deployment, whichs responses to pre-populate,
        /// and which fields are to be pre-populated. 
        /// TODO - currently this only supports full pre-population of target dply
        ///        (i.e. all unstarted responses in the deployment)
        ///        but with some refactoring it could be made to support targetting a limited set of responses. 
        /// </summary>
        public class TargetContext
        {
            public class Field
            {
                public Guid Id { get; private set; }
                public string Alias { get; private set; }

                public Field(Guid id, string alias)
                {
                    this.Id = id;
                    this.Alias = alias ?? throw new ArgumentNullException(nameof(alias));
                }
            }

            public class Sample
            {
                public string Uid { get; private set; }
                public Guid ListSampleId { get; private set; }
                public Guid? ExistingRespId { get; private set; }

                public Sample(string uid, Guid listSampleId, Guid? existingRespId)
                {
                    this.Uid = uid ?? throw new ArgumentNullException(nameof(uid));
                    this.ListSampleId = listSampleId;
                    this.ExistingRespId = existingRespId;
                }
            }

            public static async Task<TargetContext> NewInstanceTargetingAllAlias(Guid targetDplyId)
            {
                TargetContext instance = new TargetContext(targetDplyId, targetAliases: null);
                await instance.Initialise(fieldNames: null);
                return instance;
            }

            public static async Task<TargetContext> NewInstanceTargetingSpecificAlias(Guid targetDplyId, IEnumerable<string> targetAliases)
            {
                if (targetAliases == null) 
                    throw new ArgumentNullException(nameof(targetAliases), $"May not be null here. To target all alias use the {NewInstanceTargetingAllAlias} factory method instead");
                if(!targetAliases.Any()) 
                    throw new ArgumentException(nameof(targetAliases), $"May not be empty, at least one alias must be provided");
                TargetContext instance = new TargetContext(targetDplyId, targetAliases);
                await instance.Initialise(targetAliases);
                return instance;
            }

            public string StrataSource { get; private set; }

            public bool IsStrataEnabled { get => !string.IsNullOrEmpty(StrataSource); }

            //

            private readonly Guid targetDplyId;

            private EntityModel qnnRespModel = null;

            //To lookup sample info by UID (case-insensitive)
            IDictionary<string, Sample> samplesByUid = null;

            private DynamicEntity targetDply = null;

            //List of all fields in target deployment, ordered by NumberId
            private IList<Field> allFields = null;

            //Case-insensitive lookup table of all fields in target deployment
            private IDictionary<string, Field> allFieldsByAlias = null;

            //List of the alias that are to be pre-populated
            private ImmutableList<string> targetAliases = null;

            /// <summary>
            /// Private constructor, please use the factory method to ensure full initialisation
            /// </summary>
            private TargetContext(Guid targetDplyId, IEnumerable<string> targetAliases)
            {
                this.targetDplyId = targetDplyId;
            }

            private async Task Initialise(IEnumerable<string> fieldNames)
            {
                try
                {
                    qnnRespModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_RESP, Constants.Level.NoJoins);

                    targetDply = await DeploymentApplication.GetQnnDplyById(targetDplyId);
                    if (targetDply == null)
                        throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, targetDplyId);
                    StrataSource = (string)targetDply[Constants.FieldName.StrataSource];

                    Guid qnnId = (Guid)targetDply[Constants.FieldName.QnnId];
                    allFields = (await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(qnnId))
                        .Select(qnnField => new Field((Guid)qnnField[Constants.FieldName.Id], (string)qnnField[Constants.FieldName.Name]))
                        .ToImmutableList();

                    allFieldsByAlias
                        = allFields
                        .ToImmutableDictionary(
                            field => field.Alias,
                            field => field,
                            Constants.Comparers.AliasCaseInsensitive);

                    if (fieldNames == null)
                    {   //Try to pre-populate all the fields
                        targetAliases = allFields
                            .Select(field => field.Alias)
                            .ToImmutableList();
                    }
                    else
                    {   //Remove invalid target alias, and normalise case to what is defined in QNN_QNN_FIELDS
                        targetAliases = fieldNames
                            .Where(alias => allFieldsByAlias.ContainsKey(alias))
                            .Select(alias => allFieldsByAlias[alias].Alias)
                            .ToImmutableList();
                    }

                    samplesByUid
                        = (await ResponseApplication.GetNoRespByDplyId(targetDplyId))
                        .Select(lsir => new Sample(
                            (string)lsir[Constants.FieldName.UID],
                            (Guid)lsir[Constants.FieldName.ListSampleId],
                            (Guid?)lsir[Constants.FieldName.RespId]))
                        .ToImmutableDictionary(
                            sample => sample.Uid,
                            sample => sample,
                            Constants.Comparers.UidCaseInsensitive);
                }
                catch (Exception e)
                {
                    throw new InternalException("Initialisation error", e);
                }
            }

            public IList<string> GetTargetAliases()
            {
                return targetAliases;
            }

            public bool HasSample(string uid)
            {
                if (string.IsNullOrEmpty(uid)) throw new ArgumentNullException(nameof(uid));
                return samplesByUid.ContainsKey(uid);
            }

            /// <summary>
            /// Uses the ORM to fetch the existing QNN_RESP entity from the database for the specified Uid in the
            /// target deployment
            /// TODO - Assumes zero or one responses, but what happens for multiple-response surveys????
            /// </summary>
            public async Task<DynamicEntity> GetQnnResp(string uid)
            {
                Sample sample = GetSample(uid);
                //TODO - we will have problems if the response is started after we've got the list of ListSampleInfoResp
                //TODO - still following old logic, but how does all this work for mult-response deployments????
                return (sample.ExistingRespId == null)
                    ? null
                    : await ResponseApplication.GetQnnRespById(sample.ExistingRespId.Value, qnnRespModel);
            }

            /// <summary>
            /// Returns information (i.e. alias, field id) about all the fields in the target deployment 
            /// (i.e. all of them, not just the subset of fields that are targeted for pre-population)
            /// </summary>
            public IList<Field> GetAllFieldsInTargetDeployment()
            {
                return allFields;
            }

            /// <summary>
            /// Return info about the sample if this target has that sample, or null otherwise
            /// </summary>
            public Sample GetSample(string uid)
            {
                if (string.IsNullOrEmpty(uid)) throw new ArgumentException("may not be null or empty", nameof(uid));
                if (samplesByUid.TryGetValue(uid, out Sample sample))
                    return sample;
                else
                    return null;
            }

            public Guid GetQnnId()
            {
                return (Guid)targetDply[Constants.FieldName.QnnId];
            }

            public Guid GetDplyId()
            {
                return targetDplyId;
            }
        } //end of TargetContext


        /// <summary>
        /// Create a new instance with an initialised logger using the specified datasource 
        /// </summary>
        /// <param name="dataSource">it is CALLER's responsibility to dispose the datasource</param>
        /// <returns>instance</returns>
        public static PrePopulator NewInstance(IDataSource dataSource)
        {
            ILogger<PrePopulator> logger = (ILogger<PrePopulator>)DefaultApplicationLogging.CreateLogger<PrePopulator>();
            return new PrePopulator(logger, dataSource);
        }

        // // // // // // // // // // // // // // // // // // // // // // //

        private ILogger<PrePopulator> logger;
        private readonly IDataSource dataSource;

        private HashSet<string> duplicateUids = new HashSet<string>();
        private HashSet<string> ignoredUids = new HashSet<string>();

        private PrePopulator(
            ILogger<PrePopulator> logger,
            IDataSource dataSource)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.dataSource = dataSource ?? throw new ArgumentNullException(nameof(dataSource));
        }

        public async Task<Result> PrePopulate(
            TargetContext target,
            AuditBatch auditBatch,
            Guid auditStructDivisionId)
        {
            bool isTraceLoggingEnabled = logger.IsEnabled(LogLevel.Trace);
            bool isDebugLoggingEnabled = logger.IsEnabled(LogLevel.Debug);

            spSP_InsertResp spSP_InsertResp 
                = await spSP_InsertResp.GetInstanceUsingAppSettingsAsync();
            spSP_UpdateResp spSP_UpdateResp
                = await spSP_UpdateResp.GetInstanceUsingAppSettingsAsync();
            spSP_DeleteAllRespAnsByRespId spSP_DeleteAllRespAnsByRespId
                = await spSP_DeleteAllRespAnsByRespId.GetInstanceUsingAppSettingsAsync();

            HashSet<string> processedUids = new HashSet<string>();
            ImmutableSortedSet<string> targetAliases 
                = target.GetTargetAliases().ToImmutableSortedSet(Constants.Comparers.AliasCaseInsensitive);
            if (logger.IsEnabled(LogLevel.Trace))
                logger.LogTrace(nameof(PrePopulate) + " - targetAliases={0}", string.Join(", ", targetAliases));

            System.Data.DataTable qnnRespAnsTable = ResponseApplication.DataTableForQnnRespAns();

            Guid targetDplyId = target.GetDplyId();
            Guid qnnId = target.GetQnnId();
            IList<TargetContext.Field> allFieldsInTargetDeployment = target.GetAllFieldsInTargetDeployment();

            //Loop through all the records made available to us by the datasource, and pre-populate the response
            //in the target deployment if that UID exists and is in a suitable state to pre-populate
            int i = 0;
            while (await dataSource.Next())
            {
                string uid = dataSource.GetUid();
                if(!processedUids.Contains(uid))
                {
                    if(target.HasSample(uid))
                    {
                        TargetContext.Sample sample = target.GetSample(uid);
                        DynamicEntity qnnResp = await target.GetQnnResp(uid);
                        bool isNewResponse = (qnnResp == null);
                        Guid respId = isNewResponse ? Guid.NewGuid() : (Guid)qnnResp[Constants.FieldName.Id];

                        if (isTraceLoggingEnabled)
                        {
                            logger.LogTrace(nameof(PrePopulate) + " - pre-populating uid {0}, listSampleId={1}, isNewResponse={2}, respId={3}", uid, sample.ListSampleId, isNewResponse, respId);
                        }

                        //Have moved building the table to before qnn_resp insertion to make it easier to get the strata value
                        //(datatable will be written to db after the qnn_resp is updated or inserted.
                        //note that we do have respId known in advance already
                        qnnRespAnsTable.Clear();

                        //Note that we need to populate a row in QNN_RESP_ANS for all the fields in the target
                        //deployment, not just those that are being pre-populated. So for those where the source
                        //doesn't supply a value we shall populate with an empty string and leave the IsPrePopulated
                        //flag unset so they aren't highlighted in the UI.
                        //We also need to record it in the audit table, but we shall record as a single row for all
                        //the rows (using JSON)                        
                        bool isStrataEnabled = target.IsStrataEnabled;
                        string strata = null;
                        foreach (TargetContext.Field field in allFieldsInTargetDeployment)
                        {
                            string ansVal
                                = targetAliases.Contains(field.Alias)
                                ? dataSource.GetAnsVal(field.Alias) ?? ""
                                : "";
                            bool isFieldPrePopulated = !string.IsNullOrEmpty(ansVal);
                            qnnRespAnsTable.Rows.Add(respId, field.Id, ansVal, isFieldPrePopulated);

                            if (isStrataEnabled)
                            {
                                //If we happen to be pre-populating the field that determines the strata then we can
                                //initialise it in the qnn_resp too
                                if (Constants.Comparers.AliasCaseInsensitive.Equals(field.Alias, target.StrataSource))
                                {
                                    strata = ansVal;
                                }
                            }

                            if (isTraceLoggingEnabled)
                            {
                                logger.LogTrace(nameof(PrePopulate) + " - add answer - respId={0}, fieldId={1}, ansVal={2}, isFieldPrePopulated={3}, for uid={4}, alias={5}", respId, field.Id, ansVal, isFieldPrePopulated, uid, field.Alias);
                            }
                        }

                        if (isNewResponse)
                        {
                            await spSP_InsertResp.PrePopulate(
                                auditBatch: auditBatch,
                                auditStructDivisionId: auditStructDivisionId,
                                updatedDate: DateTime.Now,
                                newRespId: respId,
                                dplyId: targetDplyId,
                                qnnId: qnnId,
                                listSampleId: sample.ListSampleId,
                                strata: strata);
                        }
                        else
                        {
                            bool isPrePopulated = (bool)qnnResp[Constants.FieldName.IsPrePopulated];
                            if (!isPrePopulated)
                            {
                                //TODO - we might see this if a response was sarted after the pre-population job began
                                //       because it looks up all the eligble responses at the start of the process
                                //       Maybe we could just move this up above and then ignore this Uid if the value is false now?
                                throw new InternalException($"Failed assertion: isPrePopulated is false for respId {respId}");
                            }
                                
                            await spSP_DeleteAllRespAnsByRespId.DeleteResp(
                                qnnRespId: respId,
                                structDivisionId: auditStructDivisionId,
                                auditBatch: auditBatch);

                            await spSP_UpdateResp.PrePopulate(
                                auditBatch: auditBatch,
                                auditStructDivisionId: auditStructDivisionId,
                                existingRespId: respId,
                                strata: strata);
                        }


                        //TODO - I'm considering putting back a tx around each individual response, but the issue
                        //       with this is that timeouts/deadlocks + retries for the stored procedures mean that
                        //       even a single response's pre-population has the potential to take minutes when server
                        //       is loaded and having all that tx locking will exacerbate the problem

                        using (SharedTransaction forConnection = new SharedTransaction())
                        {
                            //Not starting a tx here, just using SharedTransaction to get a connection
                            //TODO -  consider putting a tx aroud each individual response's work
                            await forConnection.OpenConnectionAsync();
                            DbHelper.BulkCopyDataTable(qnnRespAnsTable, forConnection, timeoutSeconds: 120);
                        }

                        if (auditBatch.AuditOn)
                        {
                            string newValue = SurveyPlusAuditHelper.SerialiseDataTableToJson(qnnRespAnsTable);
                            await SurveyPlusAuditHelper.BatchImport(
                                Constants.ModelName.QNN_RESP_ANS,
                                auditBatch,
                                auditStructDivisionId,
                                newValue);
                        }
                    } //end if target has this sample
                    else
                    {   //Target does not have this sample, so we ignore it
                        ignoredUids.Add(uid);

                        if (isTraceLoggingEnabled)
                        {
                            logger.LogTrace(nameof(PrePopulate) + " - ignoring uid {0} not present in target", uid);
                        }
                    }
                } //end if processedUids already contains this sample
                else
                {
                    duplicateUids.Add(uid);

                    if (isTraceLoggingEnabled)
                    {
                        logger.LogTrace(nameof(PrePopulate) + " - duplicate uid {0} in source", uid);
                    }
                }

                processedUids.Add(uid);
                i++;

                if(isDebugLoggingEnabled && (i%500==0))
                {
                    logger.LogDebug(nameof(PrePopulate) + " - i={0}, processedUids.Count={1}, duplicateUids.Count={2}, ignoredUids.Count={3}", i, processedUids.Count, duplicateUids.Count, ignoredUids.Count);
                }

            } //end loop over datasource Next

            Result result = new Result(
                duplicateUids.ToImmutableHashSet(),
                ignoredUids.ToImmutableHashSet(),
                processedUids.ToImmutableHashSet());
            if (isDebugLoggingEnabled)
            {
                logger.LogDebug(nameof(PrePopulate) + " - finished iterating {0} records, result={1}", i, result);
            }
            return result;
        }
    }
}
