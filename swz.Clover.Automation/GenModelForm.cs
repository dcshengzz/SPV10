using System;
using System.Collections.Specialized;
using System.Threading.Tasks;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.View;
using swz.Clover.Core.Metadata;
using System.Text;
using System.Linq;
using Microsoft.AspNetCore.Hosting;
using System.Collections.Generic;

namespace swz.Clover.Automation
{
    public class GenModelForm
    {

        private static string[] systemTables = {
            "dwAppSettings",
            "dwSecurityCredential",
            "dwSecurityGroup",
            "dwSecurityGroupToSecurityRole",
            "dwSecurityGroupToSecurityUser",
            "dwSecurityPermission",
            "dwSecurityPermissionGroup",
            "dwSecurityRole",
            "dwSecurityRoleToSecurityPermission",
            "dwSecurityUser",
            "dwSecurityUserImpersonation",
            "dwSecurityUserState",
            "dwSecurityUserToSecurityRole",
            "dwUploadedFiles",
            "dwV_Security_CheckPermissionGroup",
            "dwV_Security_CheckPermissionUser",
            "WorkflowGlobalParameter",
            "WorkflowInbox",
            "WorkflowProcessInstance",
            "WorkflowProcessInstancePersistence",
            "WorkflowProcessInstanceStatus",
            "WorkflowProcessScheme",
            "WorkflowProcessTimer",
            "WorkflowProcessTransitionHistory",
            "WorkflowScheme",
        };

        public GenModelForm(IWebHostEnvironment env)
        {
            CloverRuntime.Metadata.SetRootPath(env.ContentRootPath);
        }

        public async Task Do() {
            await Do(string.Empty);
        }

        public async Task Do(string targetTableName)
        {

            var pars = new NameValueCollection {{"operation", "analysedb"}};


            var res1 = await CloverRuntime.Metadata.ConfigAPI(pars);
            var dbObject = (ListSuccessResponse<SyncMetadata>)res1;

            //pars.Clear();
            //pars.Add("operation", "load");
            //var res2 = await CloverRuntime.Metadata.ConfigAPI(pars, null);
            //ItemSuccessResponse<swz.Clover.Core.Metadata.Metadata> loadData = (swz.Clover.Core.View.ItemSuccessResponse<swz.Clover.Core.Metadata.Metadata>)res2;
            
            var wraperStart = @"[{\""key\"":\""container_1\"",\""data-buildertype\"":\""container\"",\""children\"":[{\""key\"":\""form_1\"",\""data-buildertype\"":\""form\"",\""children\"":[";
            var wrapperEnd = @"{\""key\"":\""btnSave\"",\""data-buildertype\"":\""button\"",\""content\"":\""Save\"",\""events\"":{\""onClick\"":{\""actions\"":[\""validate\"",\""save\"",\""exit\""],\""active\"":true,\""targets\"":[],\""parameters\"":[]}}},{\""key\"":\""btnExit\"",\""data-buildertype\"":\""button\"",\""content\"":\""Cancel\"",\""events\"":{\""onClick\"":{\""actions\"":[\""exit\""],\""active\"":true,\""targets\"":[],\""parameters\"":[]}}}]}]}]""";

            pars.Clear();
            pars.Add("operation", "change");
            var sbChanges = new StringBuilder("[");
            var sbModels = new StringBuilder();
            var sbForms = new StringBuilder();
            var sbSource = new StringBuilder(wraperStart);
            var sbMapping = new StringBuilder();
            var formNames = new List<string>();

            var tempItems = dbObject.Items;

            if (!string.IsNullOrEmpty(targetTableName))
                tempItems.RemoveAll(item => item.Name != targetTableName);

            foreach (var item in tempItems)
            {


                //check new table
                if (item.ChangedType == "new" && !IsSystemTable(item.Name, systemTables))
                {
                    //generate new model
                    sbModels.Append(JsonConvert.SerializeObject(item).TrimEnd('}') + "},\"__select\":true,\"__type\":\"datasync\",\"__state\":\"inserted\"},");


                    sbChanges.Append(sbModels);
                    //if form not existed
                    if (!FormExisted(item.Name))
                    {
                        //store new form names for mapping latter
                        formNames.Add(item.Name);
                        sbForms.Append($"{{ \"name\":\"{item.Name}\",\"__state\":\"inserted\",\"__type\":\"form\",\"source\":\"");
                        //add new form for this model
                        foreach (var column in item.Table.Columns)
                        {
                            if (column.IsPrimaryKey) continue;
                            var formControlString = GenFormControlString(column.ColumnName, column.DataType);
                            //sbForms.Append($"{formControlString},");
                            sbSource.Append($"{formControlString},");
                        }
                        sbSource.Append(wrapperEnd);
                        sbForms.Append(sbSource).Append("},");
                        sbChanges.Append(sbForms);
                    }

                    sbSource.Clear().Append(wraperStart);
                    sbForms.Clear();
                    sbModels.Clear();

                }


            }


            //In the end, sbChanges format would be: [{Model 1},{Form 1},...{Model n},{Form n}]

            sbChanges.Append("]");

            pars.Add("items", sbChanges.ToString());

            await CloverRuntime.Metadata.ConfigAPI(pars);
            pars.Clear();

            if (formNames.Count == 0) return;
            sbMapping.Append("[");
            var query = new List<MetadataSectionQuery> {
                        new MetadataSectionQuery("datamodel")
                    };
            var metadata = await CloverRuntime.Metadata.PartialMetadata(query);

            foreach (var formName in formNames)
            {
                var source = CloverRuntime.Metadata.GetFormSource(formName).Replace(@"""", @"\""");
                var dm = metadata.DataModel.FirstOrDefault(d => d.Name == formName);
                if (dm == null) continue;
                sbMapping.Append(
                    $"{{ \"lastUpdate\":\"{DateTime.Now:u}\",\"name\":\"{formName}\", \"entityId\": \"{dm.Id}\",\"__error\": {{}},\"mapping\": null,\"permissions\": null,\"javaScriptCode\": null,\"securityGroup\": null,\"schemes\": null,\"triggers\": [],\"isTemplate\": false, \"isArchived\": false,\"dataSourceType\": null,\"dataUrl\": null,\"dataColl\": [],\"__type\": \"formmapping\",\"__state\": \"updated\", \"source\":\"{source}\",\"dataMap\": [");
                //add new form for this model
                foreach (var attribute in dm.Attributes)
                {
                    var controlName = attribute.Name;
                    if (attribute.Name == dm.PrimaryKeyAttribute) controlName="";
                    var formMappingString =
                        GenFormMappingString(attribute.Name, controlName, attribute.Id.ToString());
                    sbMapping.Append($"{formMappingString},");
                }

                sbMapping.Length--;
                sbMapping.Append($"]}},");
            }

            sbMapping.Length--;
            sbMapping.Append("]");

            pars.Add("operation", "change");
            pars.Add("items", sbMapping.ToString());


            await CloverRuntime.Metadata.ConfigAPI(pars);
            pars.Clear();
        }

        private static string GenFormControlString(string columnName, string dataType)
        {
            switch (dataType.ToLower())
            {
                case "bit":
                    return $"{{\\\"key\\\":\\\"{columnName}\\\",\\\"data-buildertype\\\":\\\"checkbox\\\",\\\"label\\\":\\\"{columnName}\\\"}}";
                case "date":
                    return $"{{\\\"key\\\":\\\"{columnName}\\\",\\\"data-buildertype\\\":\\\"input\\\",\\\"label\\\":\\\"{columnName}\\\",\\\"fluid\\\":true,\\\"onChangeTimeout\\\":200,\\\"type\\\":\\\"date\\\"}}";
                case "time":
                    return $"{{\\\"key\\\":\\\"{columnName}\\\",\\\"data-buildertype\\\":\\\"input\\\",\\\"label\\\":\\\"{columnName}\\\",\\\"fluid\\\":true,\\\"onChangeTimeout\\\":200,\\\"type\\\":\\\"time\\\"}}";
                case "datetime":
                    return $"{{\\\"key\\\":\\\"{columnName}\\\",\\\"data-buildertype\\\":\\\"input\\\",\\\"label\\\":\\\"{columnName}\\\",\\\"fluid\\\":true,\\\"onChangeTimeout\\\":200,\\\"type\\\":\\\"datetime\\\"}}";
                case "int":
                    return $"{{\\\"key\\\":\\\"{columnName}\\\",\\\"data-buildertype\\\":\\\"input\\\",\\\"label\\\":\\\"{columnName}\\\",\\\"fluid\\\":true,\\\"onChangeTimeout\\\":200,\\\"type\\\":\\\"number\\\"}}";
                case "tinyint":
                    return $"{{\\\"key\\\":\\\"{columnName}\\\",\\\"data-buildertype\\\":\\\"input\\\",\\\"label\\\":\\\"{columnName}\\\",\\\"fluid\\\":true,\\\"onChangeTimeout\\\":200,\\\"type\\\":\\\"number\\\"}}";
                default:
                    return $"{{\\\"key\\\":\\\"{columnName}\\\",\\\"data-buildertype\\\":\\\"input\\\",\\\"label\\\":\\\"{columnName}\\\",\\\"fluid\\\":true,\\\"onChangeTimeout\\\":200}}";
            }

        }

        private static string GenFormMappingString(string attributeName, string controlName, string attributeId)
        {
            var guid = Guid.NewGuid();
            return $"{{\"Id\":\"{guid}\", \"parentId\":null, \"isLoadable\": true, \"isEditable\": true, \"attributeId\": \"{attributeId}\", \"attributeName\": \"{attributeName}\", \"referenceEntityId\": null, \"control\": \"{controlName}\"}}";

        }


        private static bool IsSystemTable(string tableName, string[] systemTables)
        {
            return systemTables.Contains(tableName);
        }

        private static bool FormExisted(string formName)
        {
            var formSource = CloverRuntime.Metadata.GetFormSource(formName);
            return formSource != null;

        }




    }


}
