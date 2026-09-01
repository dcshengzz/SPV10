using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication.Import
{
    /// <summary>
    /// Marshalls various information about the deployment to make it readily available to the importer.
    /// </summary>
    public class ImportContext
    {
        /// <summary>
        /// Factory method, use this to get an initialised instance of the context for use with a specific deployment.
        /// </summary>
        public static async Task<ImportContext> ForDeployment(Guid dplyId)
        {
            ImportContext instance = new ImportContext(dplyId);
            await instance.InitialiseAsync();
            return instance;
        }

        public Guid DplyId { get; private set; }
        public string DplyName { get { return (string)qnnDply[Constants.FieldName.Name]; } }
        public Guid QnnId { get { return (Guid)qnnDply[Constants.FieldName.QnnId]; } }
        public Guid ListId { get { return (Guid)qnnDply[Constants.FieldName.ListId]; } }
        public Guid DplyStructDivisionId {  get { return (Guid)qnnDply[Constants.FieldName.StructDivisionId]; } }
        public int SampleCount {  get { return dlsiByListSampleId.Count; } }
        public ImmutableSortedSet<string> FieldNames { get; private set; }
        public string StrataSource {  get { return (string)qnnDply[Constants.FieldName.StrataSource]; } } //todo cache to save lookups
        public bool IsStrataEnabled { get { return !string.IsNullOrEmpty(StrataSource); } }

        private DynamicEntity qnnDply;
        private Dictionary<string, Guid> fieldIdByName;
        private Dictionary<string, Guid> listSampleIdByUid;
        private Dictionary<string, QnnStatusId> statusByTitle;
        private Dictionary<Guid, Guid> dlsiByListSampleId;
        private Dictionary<string, Guid> userByName;

        private ImportContext(Guid dplyId)
        {
            this.DplyId = dplyId;
        }

        private async Task InitialiseAsync()
        {
            statusByTitle = await MapStatusTitleToId();

            qnnDply = await DeploymentApplication.GetQnnDplyById(DplyId);
            if (qnnDply == null)
                throw NotFoundException.ForModelName(Constants.ModelName.QNN_DPLY, DplyId);

            Guid qnnId = (Guid)qnnDply[Constants.FieldName.QnnId];
            fieldIdByName = await MapAliasToFieldId(qnnId);
            FieldNames = fieldIdByName.Keys.ToImmutableSortedSet();

            Guid listId = (Guid)qnnDply[Constants.FieldName.ListId];
            listSampleIdByUid = await spSP_GetListSampleUids.MapListSampleIdsByUidAsync(listId);

            dlsiByListSampleId = await spSP_GetDplySampleInfoIdForDply.MapDplySampleInfoIdsByListSampleId(DplyId);

            userByName = await MapUserToId();
        }

        public Guid FieldIdFor(string name)
        {
            if (string.IsNullOrEmpty(name))
                throw new ArgumentException($"required by {nameof(FieldIdFor)}", nameof(name));

            if (fieldIdByName.TryGetValue(name, out Guid fieldId))
                return fieldId;
            else
                throw new NotFoundException($"There is no field named \"{name}\" in the context for QnnId {QnnId}", name);
        }

        public Guid ListSampleIdFor(string uid)
        {
            if (string.IsNullOrEmpty(uid))
                throw new ArgumentException($"required by {nameof(ListSampleIdFor)}", nameof(uid));

            if (listSampleIdByUid.TryGetValue(uid, out Guid listSampleId))
                return listSampleId;
            else
                throw new NotFoundException($"There is no list sample for uid \"{uid}\" in the context for ListId {ListId}", uid);
        }

        public QnnStatusId StatusFor(string title)
        {
            if (string.IsNullOrEmpty(title))
                throw new ArgumentException($"required by {nameof(StatusFor)}", nameof(title));

            if (statusByTitle.TryGetValue(title, out QnnStatusId status))
                return status;
            else
                throw new NotFoundException($"There is no status in the context with title \"{title}\"", title);
        }

        /// <summary>
        /// Returns the Id in QNN_DPLY_SAMPLE_INFO for the specified QNN_LIST_SAMPLE.Id in the context's QNN_DPLY
        /// </summary>
        public Guid DlsiFor(Guid listSampleId)
        {
            if (dlsiByListSampleId.TryGetValue(listSampleId, out Guid dlsi))
                return dlsi;
            else
                throw new NotFoundException($"There is no QNN_DPLY_SAMPLE_INFO Id for listSampleId \"{listSampleId}\" in the context for DplyId \"{DplyId}\"", listSampleId);
        }

        /// <summary>
        /// Returns the UserId for the named user if known, or null if unknown.
        /// (Does NOT throw NotFoundException unlike most of the other lookup methods here)
        /// </summary>
        public Guid? UserIdFor(string name)
        {
            //This used to throw an exception if the user was not found, however it turns out this alone adds something like
            //an hour to the import operation when there are 200k+ rows that call this (!)
            //I suspect this was from the actual throwing and catching, as my test data was 50% unknown users, but based on 
            //SO answers try/catch isn't very expensive when no exception is thrown.
            //see: https://stackoverflow.com/questions/1308432/do-try-catch-blocks-hurt-performance-when-exceptions-are-not-thrown
            //in particular: https://stackoverflow.com/a/1308628/8243046
            if (string.IsNullOrEmpty(name))
                throw new ArgumentException($"required by {nameof(UserIdFor)}", nameof(name));
            if (userByName.TryGetValue(name, out Guid userId))
                return userId;
            else
                return null;
        }

        private async Task<Dictionary<string, Guid>> MapAliasToFieldId(Guid qnnId)
        {
            EntityModel qnnQnnFieldModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FIELD, Constants.Level.NoJoins);
            Filter byQnnId = Filter.And.Equal(qnnId, Constants.FieldName.QnnId);
            Dictionary<string, Guid> idByName = (await qnnQnnFieldModel.GetAsync(byQnnId)).ToDictionary(
                f => (string)f[Constants.FieldName.Name],
                f => (Guid)f[Constants.FieldName.Id]);
            return idByName;
        }

        private async Task<Dictionary<string, QnnStatusId>> MapStatusTitleToId()
        {
            EntityModel qnnStatusModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_STATUS, Constants.Level.NoJoins);
            Dictionary<string, QnnStatusId> idByTitle = (await qnnStatusModel.GetAsync(Filter.Empty)).ToDictionary(
                s => (string)s[Constants.FieldName.Title],
                s => QnnStatusId.FromGuid( (Guid)s[Constants.FieldName.Id]) );
            return idByTitle;
        }

        private async Task<Dictionary<string, Guid>> MapUserToId()
        {
            EntityModel dwSecurityUserModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.dwSecurityUser, Constants.Level.NoJoins);
            Dictionary<string,Guid> idByName = (await dwSecurityUserModel.GetAsync(Filter.Empty)).ToDictionary(
                u => (string)u[Constants.FieldName.Name],
                u => (Guid)u[Constants.FieldName.Id]);
            return idByName;
        }

    }
}
