using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Hangfire;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.View;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Logic relating to entity deletion, moved out of BusinessProcess.
    /// Currently this is just used by DataController.
    /// </summary>
    public static class DeleteDataApplication
    {
        public static async Task<(bool Succeess, string Message)> DeleteData(ChangeDataRequest request)
        {
            var model = await MetadataToModelConverter.GetEntityModelByFormAsync(request.Name,
                new BuildModelOptions(ignoreNameCase: true, requestingControl: request.RequestingControl));

            if (!string.IsNullOrEmpty(model.DataUrl)) return await DataSource.DeleteDataForUrlAsync(request, model);

            var data = JsonConvert.DeserializeObject<List<object>>(request.Data);

            if (!string.IsNullOrEmpty(request.RequestingControl))
            {
                var targetModel = model.Collections.FirstOrDefault()?.Model;
                return await DeleteData(targetModel, data);
            }
            else
            {
                await model.DeleteAsync(data.Select(c =>
                    model.PrimaryKeyAttribute.Type.ParseToCLRType(c)
                ));
            }
            return (true, null);
        }

        private static async Task<(bool Succeess, string Message)> DeleteData(EntityModel targetModel, List<object> data)
        {
            if (targetModel != null && data != null)
            {
                var auditOnSetting = (await AppSettings.SelectAsync(Filter.And.Equal("AuditOn", "Name"))).FirstOrDefault();
                var auditOn = auditOnSetting?.Value.Equals("True", StringComparison.InvariantCultureIgnoreCase) ?? false;
                var ids = data.Select(c =>
                    targetModel.PrimaryKeyAttribute.Type.ParseToCLRType(c)
                ).ToList();
                if (!ids.Any()) return (true, null);

                var tableName = GetTableName(targetModel.Name);

                var spParams = new Dictionary<string, object>
                    {
                        {"Ids", string.Join(",", ids)},
                        {"TableName", tableName},
                        {"UserId", CloverRuntime.Security.CurrentUser.Id},
                        {"StructDivisionId", CloverRuntime.Security.CurrentUser.StructDivisionId},
                        {"EventBatch", Guid.NewGuid()},
                        {"EventDate", DateTime.Now},
                        {"AuditOn", auditOn}
                    };

                //nb: this procedure has 'if else' branching for each entity type, so if you create a new entity you would need to add it
                //    here for this DeleteData method to work for it. (TODO - refactor it for the common behaviour).
                var spResult = await CloverRuntime.DbProvider.ExecuteStoredProcedureExAsync(Constants.StoredProcedure.spSP_DeleteByTableNameAndIds,
                    spParams, new Dictionary<string, object>());

                //spSP_DeleteByTableNameAndIds is only returning one row record, spResult.FirstOrDefault() is referring to the first row data.
                await DeleteHangFireJob(spResult.FirstOrDefault()).ConfigureAwait(false);
                await DeleteUploadedFiles(spResult.FirstOrDefault()).ConfigureAwait(false);
            }

            return (true, null);
        }

        /// <summary>
        /// Default use "HangFireJobID" to look into the spResult Dictionary
        /// </summary>
        /// <param name="spResult"></param>
        /// <returns></returns>
        private static async Task DeleteHangFireJob(Dictionary<string, object> spResult)
        {
            await DeleteHangFireJob(spResult, "HangFireJobID").ConfigureAwait(false);
        }

        /// <summary>
        /// Entry point to delete Hangfire Job after trigger a StoreProcedure with the return of JobID.
        /// </summary>
        /// <param name="spResult">The object that contain the HangFire JobID</param>
        /// <param name="hangfireJobIDkey">The key to lookup in the spResult Dictionary, should be same as the return Column name in StoreProcedure</param>
        private static async Task DeleteHangFireJob(Dictionary<string, object> spResult, string dictionaryLookupKey)
        {
            if (!string.IsNullOrEmpty(dictionaryLookupKey) && spResult != null && spResult.ContainsKey(dictionaryLookupKey) && spResult[dictionaryLookupKey] != null)
            {
                foreach (string Id in spResult[dictionaryLookupKey].ToString().Split(",").ToList())
                {
                    if (!string.IsNullOrEmpty(Id))
                    {
                        BackgroundJob.Delete(Id.Trim());
                    }
                }
            }
        }

        /// <summary>
        /// Default use "UploadedFilesToken" to look into the spResult Dictionary
        /// </summary>
        /// <param name="spResult"></param>
        /// <returns></returns>
        public static async Task DeleteUploadedFiles(Dictionary<string, object> spResult)
        {
            await DeleteUploadedFiles(spResult, "UploadedFilesToken").ConfigureAwait(false);
        }

        /// <summary>
        /// Entry point to delete uploaded files after trigger a StoreProcedure with the return of Token.
        /// </summary>
        /// <param name="spResult">The object that contain the HangFire JobID</param>
        /// <param name="hangfireJobIDkey">The key to lookup in the spResult Dictionary, should be same as the return Column name in StoreProcedure</param>
        private static async Task DeleteUploadedFiles(Dictionary<string, object> spResult, string dictionaryLookupKey)
        {
            if (!string.IsNullOrEmpty(dictionaryLookupKey) && spResult != null && spResult.ContainsKey(dictionaryLookupKey) && spResult[dictionaryLookupKey] != null)
            {
                foreach (string Id in spResult[dictionaryLookupKey].ToString().Split(",").ToList())
                {
                    if (!string.IsNullOrEmpty(Id))
                    {
                        await CloverRuntime.ContentProvider.RemoveAsync(Id.Trim());
                    }
                }
            }
        }

        private static string GetTableName(string targetModelName)
        {
            //Model to table mapping; for delete method
            if (targetModelName == Constants.ModelName.vSP_DeploymentWithRespCount)
                targetModelName = Constants.ModelName.QNN_DPLY;
            else if (targetModelName == Constants.ModelName.vSP_Category)
                targetModelName = Constants.ModelName.QNN_CATEGORY;
            else if (targetModelName == Constants.ModelName.vSP_List)
                targetModelName = Constants.ModelName.QNN_LIST;
            else if (targetModelName == Constants.ModelName.vSP_Qnn)
                targetModelName = Constants.ModelName.QNN_QNN;
            else if (targetModelName == Constants.ModelName.vSP_ListWithCount)
                targetModelName = Constants.ModelName.QNN_LIST;
            else if (targetModelName == Constants.ModelName.vSP_QnnSampleActiveForGrid)
                targetModelName = Constants.ModelName.QNN_SAMPLE;
            return targetModelName;
        }
    }
}
