using CsvHelper;
using CsvHelper.TypeConversion;
using Microsoft.Extensions.Logging;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using swz.SurveyPlus.IntranetApplication.Utilities;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// DplyId goes in, responses CSV comes out
    /// </summary>
    public class SurveyResponseExporter
    {
        /// <summary>
        /// ExporterContext bundles together in an externally immutable object, the
        /// information about the deployment, list, and questionnaire fields that 
        /// the exporter needs.
        /// </summary>
        public class ExporterContext
        {
            //KEEP THE ExporterContext EXTERNALLY IMMUTABLE PLEASE!

            /// <summary>
            /// Encapsulates some information about a List Sample Property
            /// </summary>
            public class PropInfo
            {
                //DO NOT MAKE ANY OF THESE MUTABLE!

                public bool IsExportable { get => ColumnOrder != null; }

                public readonly Guid ListSamplePropId;
                public readonly string Alias;
                public readonly bool AliasConflictsWithFieldName;                
                public readonly int? ColumnOrder;

                public PropInfo(Guid listSamplePropId, string alias, int? columnOrder, bool aliasConflictsWithFieldName)
                {
                    this.ListSamplePropId = listSamplePropId;
                    this.Alias = alias ?? throw new ArgumentNullException(nameof(alias));
                    if (string.IsNullOrEmpty(alias)) throw new ArgumentException(nameof(alias));
                    this.ColumnOrder = columnOrder;
                    this.AliasConflictsWithFieldName = aliasConflictsWithFieldName;
                }
            }

            /// <summary>
            /// Encapsulates some information about an answer field in the survey
            /// </summary>
            public class FieldInfo
            {
                //DO NOT MAKE ANY OF THESE MUTABLE!

                public bool IsExportable { get => ColumnOrder != null; }

                public readonly Guid QnnFieldId;
                public readonly string Name;
                public readonly bool NameConflictsWithPropAlias;
                public int? ColumnOrder;
                
                public FieldInfo(Guid qnnFieldId, string name, int? columnOrder, bool nameConflictsWithPropAlias)
                {
                    this.QnnFieldId = qnnFieldId;
                    this.Name = name ?? throw new ArgumentNullException(nameof(name));
                    if (string.IsNullOrEmpty(name)) throw new ArgumentException(nameof(name));
                    this.ColumnOrder = columnOrder;
                    this.NameConflictsWithPropAlias = nameConflictsWithPropAlias;
                }
            }

            /// <summary>
            /// Factory method to create an instance for the specified deployment
            /// </summary>
            public static async Task<ExporterContext> ForDplyId(Guid dplyId)
            {
                return await new ExporterContext().Init(dplyId);
            }

            public Guid DplyId { get; private set; }

            public string DeploymentName { get; private set; }
            public string FormPropertiesName { get; private set; }
            public string ListName { get; private set; }

            public ImmutableList<PropInfo> Props;
            public int PropCount { get => Props.Count; }
            public int ExportablePropCount { get; private set; } //will be called often so dont calculate each time
            public bool HasExportableProps { get => ExportablePropCount > 0; }
            public ImmutableDictionary<Guid, PropInfo> PropsByPropId;
            public ImmutableDictionary<string, PropInfo> PropsByAlias;

            public ImmutableList<FieldInfo> Fields;
            public int FieldCount { get => Fields.Count; }
            public int ExportableFieldCount { get; private set; } //will be called often so dont calculate each time
            public ImmutableDictionary<Guid, FieldInfo> FieldsByFieldId;
            public ImmutableDictionary<string, FieldInfo> FieldsByName;

            public enum AliasConflictResolution { ByKeepingField, ByKeepingProp };
            public AliasConflictResolution ResolveAliasConflicts { get; private set; }

            public ImmutableDictionary<QnnStatusId, string> StatusTitleById;

            /// <summary>
            /// Constructer is private, use the static factory method to create an instance
            /// </summary>
            private ExporterContext()
            {
                ;
            }

            private async Task<ExporterContext> Init(Guid dplyId)
            {
                try
                {
                    EntityModel qnnDplyModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.FetchJoins);
                    EntityModel qnnStatusModel
                        = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_STATUS, Constants.Level.NoJoins);

                    this.DplyId = dplyId;
                    
                    DynamicEntity qnnDply = await DeploymentApplication.GetQnnDplyById(dplyId, qnnDplyModel);
                    if (qnnDply == null) throw NotFoundException.ForModelName(qnnDplyModel.Name, dplyId);
                    DeploymentName = (string)qnnDply[Constants.FieldName.Name];
                    FormPropertiesName = (string)qnnDply[Constants.FieldName.QnnId + '_' + Constants.FieldName.Title];
                    ListName = (string)qnnDply[Constants.FieldName.ListId + '_' + Constants.FieldName.Name];
                    Guid listId = (Guid)qnnDply[Constants.FieldName.ListId];
                    Guid qnnId = (Guid)qnnDply[Constants.FieldName.QnnId];

                    //A rare edge case occurs when we have a Field Alias and a List Sample Property with the same name.
                    //We don't want to export duplicate columns so must pick which to keep. Since the introduction of
                    //the ExposeListProperties feature we make this decision based on that setting for the deployment.
                    bool isExposeListProperties = (bool)qnnDply[Constants.FieldName.IsExposeListProperties];
                    if (isExposeListProperties)
                    {
                        //Special behaviour:
                        //If they use the option to expose list sample properties to the form
                        //favour their response over original list sample property value
                        //(i.e. if there is a value for list sample property and a control
                        //with the same name, we shall export the value from the control as per the QNN_RESP)
                        ResolveAliasConflicts = AliasConflictResolution.ByKeepingField;
                    }
                    else
                    {
                        //Standard behaviour:
                        //Favour the value in the list sample property instead of control with that alias
                        //If a control tries to override the list sample property we shall export the original list
                        //sample property for that column in the CSV (this is the existing behaviour before adding
                        //IsExposeListProperties feature)
                        ResolveAliasConflicts = AliasConflictResolution.ByKeepingProp;
                    }

                    List<DynamicEntity> qnnListProps = await SampleListApplication.GetQnnListPropsByListIdAsync(listId);
                    List<DynamicEntity> qnnQnnFields = await FormPropertiesApplication.GetQnnQnnFieldsByQnnIdAsync(qnnId);
                    IImmutableSet<string> aliasVsNameConflicts =
                        qnnListProps
                            .Select(qnnListProp => (string)qnnListProp[Constants.FieldName.Alias])
                            .Intersect(
                                qnnQnnFields
                                .Select(qnnQnnField => (string)qnnQnnField[Constants.FieldName.Name])
                                .ToList())
                            .ToImmutableSortedSet();

                    {   //List Sample Properties
                        List<PropInfo> props = new List<PropInfo>(qnnListProps.Count);
                        int i = 0;
                        foreach (DynamicEntity qnnListProp in qnnListProps)
                        {
                            Guid listPropId = (Guid)qnnListProp[Constants.FieldName.Id];
                            string alias = (string)qnnListProp[Constants.FieldName.Alias];
                            bool isConflicting = aliasVsNameConflicts.Contains(alias);
                            bool isToBeExported = !isConflicting || ResolveAliasConflicts == AliasConflictResolution.ByKeepingProp;
                            int? columnIndex = isToBeExported ? i++ : null;
                            props.Add(new PropInfo(listPropId, alias, columnIndex, isConflicting));
                        }
                        ExportablePropCount = i;
                        Props = props.ToImmutableList();
                        PropsByPropId = props.ToImmutableDictionary(prop => prop.ListSamplePropId, prop => prop);
                        PropsByAlias = props.ToImmutableDictionary(prop => prop.Alias, prop => prop);
                    }

                    {   //Survey Qnn Fields
                        List<FieldInfo> fields = new List<FieldInfo>(qnnQnnFields.Count);
                        int i = 0;
                        foreach(DynamicEntity qnnQnnField in qnnQnnFields)
                        {
                            Guid qnnFieldId = (Guid)qnnQnnField[Constants.FieldName.Id];
                            string name = (string)qnnQnnField[Constants.FieldName.Name];
                            bool isConflicting = aliasVsNameConflicts.Contains(name);
                            bool isToBeExported = !isConflicting || ResolveAliasConflicts == AliasConflictResolution.ByKeepingField;
                            int? columnIndex = isToBeExported ? i++ : null;
                            fields.Add(new FieldInfo(qnnFieldId, name, columnIndex, isConflicting));
                        }
                        ExportableFieldCount = i;
                        Fields = fields.ToImmutableList();
                        FieldsByFieldId = fields.ToImmutableDictionary(field => field.QnnFieldId, field => field);
                        FieldsByName = fields.ToImmutableDictionary(field => field.Name, field => field);

                        //Note:
                        //Previous exporter code had logic to exclude "swzPdfFormIdentifier" and "btnSubmit" fields.
                        //These were related to the legacy PDF form feature. There are no more live prod instances with
                        //surveys that used that feature anymore, so we can omit this special case now. 
                    }

                    //Build a lookup table of status ids to title
                    //(Yes, we could trivially have joined these in the stored procedure, but we do it in code instead to
                    //avoid streaming all that stuff back from the db for every response row)
                    StatusTitleById = (await qnnStatusModel.GetAsync(Filter.Empty))
                        .ToImmutableDictionary(
                            qnnStatus => QnnStatusId.FromGuid((Guid)qnnStatus[Constants.FieldName.Id]), 
                            qnnStatus => (string)qnnStatus[Constants.FieldName.Title]);

                    return this;
                }
                catch(Exception e)
                {
                    throw new InternalException($"Failed to create an exporter context for dplyId {dplyId}", e);
                }
            }
        } //end of class ExporterContext

        /// <summary>
        /// Returned by the exporter to provide the caller with some metrics on the export
        /// </summary>
        public class Result
        {
            public int ExportCount { get; private set; }
            public bool IsNoRecordsExported { get => (ExportCount == 0); }

            public Result(int recordCount)
            {
                this.ExportCount = recordCount;
                if (recordCount < 0) throw new ArgumentException(nameof(recordCount));
            }
        }

        /// <summary>
        /// Names of some related settings in dwAppSettings table
        /// </summary>
        private static class SettingNames
        {
            public const string Group = "Response Export";
            public const string SETTING_SCOPE = "ResponseExport.CSV.Scope";
            public const string SETTING_BOM = "ResponseExport.CSV.Bom";
            public static readonly ImmutableList<String> Names = new List<string> {
                SETTING_SCOPE,
                SETTING_BOM,
            }.ToImmutableList(); //no, Im not making this mutable just because Filter.In wants it to be a List
        }
        
        /// <summary>
        /// Factory method to create an instance of the exporter for the specified deployment
        /// based on configured settings for the application.
        /// </summary>
        public static async Task<SurveyResponseExporter> NewInstanceUsingAppSettingsAsync(Guid dplyId)
        {
            ILogger<SurveyResponseExporter> logger
                = (ILogger<SurveyResponseExporter>)DefaultApplicationLogging.CreateLogger<SurveyResponseExporter>();
            ExporterContext context = await ExporterContext.ForDplyId(dplyId);
            spSP_GetResponseSampleInfo getResponseSampleInfo = await spSP_GetResponseSampleInfo.GetInstanceUsingAppSettingsAsync();
            spSP_GetSingleResponseData getSingleResponseData = await spSP_GetSingleResponseData.GetInstanceUsingAppSettingsAsync();
            spSP_GetListSampleProps getListSampleProps = await spSP_GetListSampleProps.GetInstanceUsingAppSettingsAsync(); //TODO - not rqd if no props in survey

            SettingsWrapper settings = await SettingsHelper.GetSettingsWrapperAsync(SettingNames.Names);
            if (!settings.TryGetString(SettingNames.SETTING_SCOPE, out string scopeString))
                scopeString = ExportScope.WithResponsesOrRemarks.ToString();
            if (!Enum.TryParse(scopeString.Trim(), out ExportScope scope))
                throw new InvalidOperationException($"appsetting {SettingNames.SETTING_SCOPE} is not properly configured");

            if(!settings.TryGetBool(SettingNames.SETTING_BOM, out bool bom))
                throw new InvalidOperationException($"appsetting {SettingNames.SETTING_BOM} is not properly configured");

            SurveyResponseExporter instance = new SurveyResponseExporter(
                logger, 
                context,
                getResponseSampleInfo,
                getSingleResponseData,
                getListSampleProps);
            instance.IncludeSamples = scope;
            instance.IncludeUtf8Bom = bom;
            return instance;
        }

        private static readonly string[] emptyStringArray = new string[0];

        // // // // // // // // // // // // // // // // // // // // // // // //

        public enum ExportScope { WithResponsesOnly, WithResponsesOrRemarks, AllSamples }
        public const int ApplyHeuristics = -1;
        
        /// <summary>
        /// Defines which records to export
        /// </summary>
        public ExportScope IncludeSamples { get; set; } = ExportScope.WithResponsesOrRemarks;

        /// <summary>
        /// The exporter uses UTF-8 encoding. 
        /// By default it does not include a byte order mark, but will do so if this is set to true.
        /// Note that Excel opens files differently when they have a BOM.
        /// </summary>
        public bool IncludeUtf8Bom { get; set; } = false;

        /// <summary>
        /// Buffer size to use for the StreamWriter. 
        /// </summary>
        public int WriteBufferSize { get; set; } = ApplyHeuristics;

        private readonly ILogger<SurveyResponseExporter> logger;
        private readonly bool isDebugLoggingEnabled;
        private readonly bool isTraceLoggingEnabled;
        private readonly ExporterContext context;
        
        private readonly spSP_GetResponseSampleInfo getResponseSampleInfo;
        private readonly spSP_GetSingleResponseData getSingleResponseData;
        private readonly spSP_GetListSampleProps getListSampleProps;

        /// <summary>
        /// Private Constructor, use the factory method to get an instance instead
        /// </summary>
        private SurveyResponseExporter(
            ILogger<SurveyResponseExporter> logger, 
            ExporterContext context,
            spSP_GetResponseSampleInfo getResponseSampleInfo,
            spSP_GetSingleResponseData getSingleResponseData,
            spSP_GetListSampleProps getListSampleProps)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));            
            this.context = context ?? throw new ArgumentNullException(nameof(context));
            this.getResponseSampleInfo = getResponseSampleInfo ?? throw new ArgumentNullException(nameof(getResponseSampleInfo));
            this.getSingleResponseData = getSingleResponseData ?? throw new ArgumentNullException(nameof(getSingleResponseData));
            this.getListSampleProps = getListSampleProps ?? throw new ArgumentNullException(nameof(getListSampleProps));

            this.isDebugLoggingEnabled = logger.IsEnabled(LogLevel.Debug);
            this.isTraceLoggingEnabled = logger.IsEnabled(LogLevel.Trace);
        }

        /// <summary>
        /// Caller is responsible for opening and closing the stream unto which the CSV shall be written.
        /// </summary>
        public async Task<Result> Csv(Stream outputStream)
        {
            try
            {
                long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                List<ResponseSampleInfo> responseSamples = await ResponseSamples();
                int recordCount = responseSamples.Count;
                if (isDebugLoggingEnabled)
                {
                    logger.LogDebug(nameof(Csv) + " - exporting {0} records, dplyId={1}, field count={2}, prop count={3}, scope={4}", recordCount, context.DplyId, context.FieldCount, context.PropCount, IncludeSamples);
                }

                int writeBufferSize = DetermineBufferSize(recordCount, context.FieldCount, context.PropCount);
                if (isTraceLoggingEnabled) logger.LogTrace(nameof(Csv) + " - using writeBufferSize={0}", writeBufferSize);

                int exportCount = 0;
                Encoding encoding = new UTF8Encoding(encoderShouldEmitUTF8Identifier: IncludeUtf8Bom); 
                using (StreamWriter writer = new StreamWriter(outputStream, encoding, bufferSize: writeBufferSize, leaveOpen:true ))
                {
                    using (CsvWriter csv = new CsvWriter(writer, CultureInfo.InvariantCulture, leaveOpen: true))
                    {
                        //Standardise our date format for the metadata columns (note that this won't affect dates in
                        //the answer columns because they are stored as string and not recognised as dates here.)
                        TypeConverterOptions options 
                            = new TypeConverterOptions { Formats = new[] { Constants.QnnDatetimeFormat } };
                        csv.Context.TypeConverterOptionsCache.AddOptions<DateTime>(options);
                        csv.Context.TypeConverterOptionsCache.AddOptions<DateTime?>(options);

                        WriteHeaderColumnNames(csv);
                        csv.NextRecord();

                        foreach(ResponseSampleInfo responseSample in responseSamples)
                        {
                            string[] propValues = await PropValues(responseSample);
                            string[] answerValues = await AnswerValues(responseSample);

                            //TODO - is it necessary to still use IsExposeListSampleProperties to handle collisions between prop and alias names?
                            //       if so then do so, if not then document the behaviour change

                            WriteSurveyInformationColumns(csv);
                            WriteSampleIdentityColumns(csv, responseSample);
                            WriteListSamplePropColumns(csv, propValues);
                            WriteResponseMetricsColumns(csv, responseSample);
                            WriteAnswerValuesColumns(csv, answerValues);

                            exportCount++;
                            if(isDebugLoggingEnabled && (exportCount==recordCount || exportCount%1024==0) )
                            {
                                long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                                logger.LogDebug(nameof(Csv) + " - exported {0} of {1} responses, duration={2} ms ( < {3} minutes)", exportCount, recordCount, duration, ConversionUtils.ToMinutesRoundedUp(duration));
                            }

                            csv.NextRecord();
                        } //end looping records
                        csv.Flush();                        
                    }//end using CsvWriter
                    writer.Flush();
                }//end using writer
                
                if (isDebugLoggingEnabled)
                {
                    long duration = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond) - start);
                    logger.LogDebug(nameof(Csv) + " - complete for {0} responses, duration < {1} minutes ({2} ms), dplyId={3}", recordCount, ConversionUtils.ToMinutesRoundedUp(duration), duration, context.DplyId);
                }

                return new Result(exportCount);
            }
            catch (Exception e)
            {
                if(isDebugLoggingEnabled)
                {
                    logger.LogDebug(e, nameof(Csv) + " - caught exception. dplyId={0}", context.DplyId);
                }
                throw;
            }
        }

        private void WriteSurveyInformationColumns(CsvWriter csv)
        {
            csv.WriteField(context.DeploymentName);
            csv.WriteField(context.FormPropertiesName);
            csv.WriteField(context.ListName);
        }

        private void WriteSampleIdentityColumns(CsvWriter csv, ResponseSampleInfo responseSample)
        {   
            csv.WriteField(responseSample.UID);
            csv.WriteField(responseSample.ToEmails);
            csv.WriteField(responseSample.CcEmails);
            csv.WriteField(responseSample.AddressLine1);
            csv.WriteField(responseSample.AddressLine2);
            csv.WriteField(responseSample.AddressLine3);
            csv.WriteField(responseSample.SampleName);
            csv.WriteField(responseSample.UserName);
        }

        private void WriteListSamplePropColumns(CsvWriter csv, string[] propValues)
        {
            foreach (string value in propValues)
            {
                csv.WriteField(value);
            }
        }

        private void WriteResponseMetricsColumns(CsvWriter csv, ResponseSampleInfo responseSample)
        {
            csv.WriteField(responseSample.DateStart);
            csv.WriteField(responseSample.DateComplete);
            csv.WriteField(responseSample.UpdatedDate);
            csv.WriteField(responseSample.IpAddress);
            csv.WriteField(context.StatusTitleById[responseSample.Status]); 
            csv.WriteField(responseSample.Remarks);
            csv.WriteField(responseSample.InitialResponseAs);
            csv.WriteField(responseSample.InitialResponseBy);
            csv.WriteField(responseSample.InitialResponseVia);
            csv.WriteField(responseSample.InitialResponder);
            csv.WriteField(responseSample.CompletedResponseAs);
            csv.WriteField(responseSample.CompletedResponseBy);
            csv.WriteField(responseSample.CompletedResponseVia);
            csv.WriteField(responseSample.CompletedResponder);
            csv.WriteField(responseSample.LastResponseAs);
            csv.WriteField(responseSample.LastResponseBy);
            csv.WriteField(responseSample.LastResponseVia);
            csv.WriteField(responseSample.LastResponder);
        }

        private void WriteAnswerValuesColumns(CsvWriter csv, string[] answerValues)
        {
            foreach (string value in answerValues)
            {
                csv.WriteField(value);
            }
        }

        private void WriteHeaderColumnNames(CsvWriter csv)
        {
            //Columns about the deployment and the sample
            csv.WriteField(" Deployment");
            csv.WriteField(" Questionnaire");
            csv.WriteField(" List");
            csv.WriteField(" UID");
            csv.WriteField(" To Emails");
            csv.WriteField(" Cc Emails");
            csv.WriteField(" AddressLine1"); //lack of spaces is consistent with sample list csv, but sample list csv uses ALLCAPS and no leading space
            csv.WriteField(" AddressLine2");
            csv.WriteField(" AddressLine3");
            csv.WriteField(" Name");
            csv.WriteField(" Username");

            //Custom sample list properties
            foreach (string propAlias in context.Props.Where(p=>p.IsExportable).Select(p => p.Alias).ToList())
            {
                csv.WriteField(propAlias);
            }

            //Columns about the response status
            csv.WriteField(" Date Start");
            csv.WriteField(" Date Complete");
            csv.WriteField(" Date Updated");
            csv.WriteField(" IP Address");
            csv.WriteField(" Status");
            csv.WriteField(" Remarks");

            //Origin Indicators
            //v8 gives the origin indicator columns a preceeding space to make them consistent with the
            //other non-data columns
            csv.WriteField(" InitialResponseAs");
            csv.WriteField(" InitialResponseBy");
            csv.WriteField(" InitialResponseVia");
            csv.WriteField(" InitialResponder");
            csv.WriteField(" CompletedResponseAs");
            csv.WriteField(" CompletedResponseBy");
            csv.WriteField(" CompletedResponseVia");
            csv.WriteField(" CompletedResponder");
            csv.WriteField(" LastResponseAs");
            csv.WriteField(" LastResponseBy");
            csv.WriteField(" LastResponseVia");
            csv.WriteField(" LastResponder");

            //Alias columns
            foreach (string fieldName in context.Fields.Where(f=>f.IsExportable).Select(f=>f.Name).ToList())
            {
                csv.WriteField(fieldName);
            }
        }

        /// <summary>
        /// Info about all the respondents and their responses.
        /// </summary>
        private async Task<List<ResponseSampleInfo>> ResponseSamples()
        {
            List<ResponseSampleInfo> responseSamples
                = (await getResponseSampleInfo.ForDeployment(context.DplyId))
                .Where(responseSample => {
                    switch (IncludeSamples)
                    {
                        case ExportScope.WithResponsesOnly: 
                            return responseSample.HasResponse;

                        case ExportScope.WithResponsesOrRemarks:
                            return responseSample.HasResponse || responseSample.HasRemarks;

                        case ExportScope.AllSamples:                   
                            return true;

                        default:                                
                            throw new NotImplementedException(IncludeSamples.ToString());
                    }
                }) 
                .ToList();

            //I've chosen to do an in-place sort here, rather than using the db (which seems to have a habit of overestimating
            //how much memory it must grant for it), or the linq above (whose orderby is reputed to be slower than List.Sort, maybe)
            responseSamples.Sort( (x, y) => x.UID.CompareTo(y.UID) );

            return responseSamples;
        }

        /// <summary>
        /// Answer data for the specified response.
        /// This returns a list of raw string values (items may be null) in the appropriate column order
        /// </summary>
        private async Task<string[]> AnswerValues(ResponseSampleInfo responseSample)
        {
            if (context.FieldCount == 0) return emptyStringArray; //Unlikely edge case, don't want to think about it below

            List<Dictionary<string, object>> items = responseSample.HasResponse
                ? await getSingleResponseData.ForResponse(responseSample.RespId.Value)
                : null;
            int count = items?.Count ?? 0;
            if (count != context.FieldCount)
            {
                if(!responseSample.HasResponse)
                {
                    if(count==0)
                    {   //No row in QNN_RESP means response hasn't started or been PrePopulated yet.
                        //We'll export blank answer columns for it.
                        return new string[context.FieldCount];
                    }
                    else
                    {
                        //This case shouldn't be possible because rows in QNN_RESP_ANS need a RespId and for HasResponse
                        //to be false the row in QNN_RESP should not exist, so this case likely indicates a coding bug.
                        throw new InternalException($"Expected NO answer rows for RespId={responseSample.RespId} because HasResponse=false, yet found {count}");
                    }                    
                }
                else
                {
                    //If we have a row in QNN_RESP then we should have the right number of rows in QNN_RESP_ANS
                    //One cause is Issue #104 (fix should be to ensure the necessary rows there rather that allowing it here)
                    throw new InternalException($"Expected {context.FieldCount} answer rows for RespId={responseSample.RespId} but found {count}. UID={responseSample.UID}, ListSampleId={responseSample.ListSampleId}, Dlsi={responseSample.Dlsi}");
                }
            }
            else
            {
                //Normal scenario, one answer row is expected for each field. 
                string[] values = new string[context.ExportableFieldCount];
                foreach (Dictionary<string, object> item in items)
                {
                    //note that we do not expect same qnnFieldId twice in the same response
                    //nor do we expect to find reference to a field that isn't in this qnn.
                    Guid qnnFieldId = (Guid)item[Constants.FieldName.QnnFieldId];
                    ExporterContext.FieldInfo field = context.FieldsByFieldId[qnnFieldId];
                    if(field.IsExportable)
                    {
                        int index = field.ColumnOrder.Value;
                        values[index] = (string)DbHelper.DBNullToNull(item[Constants.FieldName.AnsVal]);
                    }
                }
                return values;
            }
        }

        /// <summary>
        /// Returns the list sample property values for the list sample in the appropriate column order.
        /// </summary>
        private async Task<string[]> PropValues(ResponseSampleInfo responseSample)
        {
            if(context.HasExportableProps)
            {
                //Get all the prop values for this list sample (including non-exportable ones)
                List<Dictionary<string, object>> items
                    = await getListSampleProps.ForListSample(responseSample.ListSampleId);
                if (items.Count != context.PropCount)
                    throw new InternalException($"Expected {context.PropCount} rows but found {items.Count} for listSampleId={responseSample.ListSampleId}");

                //And build an array of the exportable ones only in the appropriate column order
                string[] values = new string[context.ExportablePropCount];
                foreach (Dictionary<string, object> item in items)
                {   
                    Guid listPropId = (Guid)item[Constants.FieldName.ListPropId]; //will only occur once per lsi (in theory)
                    ExporterContext.PropInfo prop = context.PropsByPropId[listPropId];
                    if(prop.IsExportable)
                    {
                        int index = prop.ColumnOrder.Value;
                        values[index] = (string)DbHelper.DBNullToNull(item[Constants.FieldName.PropValue]);
                    }
                }
                return values;
            }
            else
            {
                return emptyStringArray;
            }
        }

        private int DetermineBufferSize(int recordCount, int fieldCount, int propCount)
        {
            if(ApplyHeuristics == WriteBufferSize)
            {
                const int minSize = 4 * 1024; //Don't go below 4KiB
                const int maxSize = 128 * 1024; //128KiB is good enough for large files
                const int estBytesPerAnswer = 6;
                long estFileSize = (recordCount * (fieldCount + propCount)) * estBytesPerAnswer;
                long unroundedBufferSize = estFileSize / 3;
                if (unroundedBufferSize < minSize) return minSize; 
                if (unroundedBufferSize > maxSize) return maxSize; 
                return (int)Math.Ceiling((double)unroundedBufferSize / 4096) * 4096; //round to multiples of 4KiB
            } 
            else
            {
                if (WriteBufferSize < 0) throw new InvalidOperationException($"Invalid buffer size {WriteBufferSize}");
                return WriteBufferSize;
            }
        }

    }
}
