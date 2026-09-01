using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using swz.Clover.Core.Metadata.DbObjects;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.Metadata
{
    public class Form : IMetadataItem
    {
        public bool IsSurvey;
        public Guid? StructDivisionId;
        public string Name;
        public DateTime? LastUpdate;
        public Guid? EntityId;
        public string DataUrl;
        public string DataSourceType;
        public bool IsTemplate;
        public List<CodeActionTriggers> Triggers;
        public List<string> Schemes;
        public List<FormDataMap> DataMap;
        public List<FormDataColl> DataColl;
        public string SecurityGroup;
        public string Source;
        public string CssCode;
        public string JavaScriptCode;
        public List<FormPermissions> Permissions;
        public FormDataMapping Mapping;
        public string CreatedBy;
        public string UpdatedBy;
        public string CreatedByUsername;
        public string UpdatedByUsername;
        public DateTime? UpdatedDate;
        public bool isArchived;

        private static readonly ILogger _logger = DefaultApplicationLogging.CreateLogger<Form>();
        public int FindInCollectionByKey<T>(List<T> coll) where T : IMetadataItem
            => coll.FindIndex(c => (c as Form)?.Name == Name);

        public void ClearEmptyDataMap()
        {

          if(DataMap!=null && DataMap.Any())
                ClearEmptyDataMap(DataMap);
            if (DataColl != null && DataColl.Any())
                DataColl.ForEach(c => ClearEmptyDataMap(c.DataMap));
        }

        private void ClearEmptyDataMap(List<FormDataMap> mapColl)
        {
            for (var i = 0; i < mapColl.Count; i++)
            {
                var dm = mapColl[i];
                if (dm.ParentId.HasValue && IsEmptyDataMap(dm, mapColl))
                {
                    mapColl.Remove(dm);
                    i--;
                }
            }
        }
        

        private bool IsEmptyDataMap(FormDataMap map, List<FormDataMap> mapColl)
        {
            if (map.IsEditable == false && map.IsLoadable == false && string.IsNullOrWhiteSpace(map.Control))
            {
                return mapColl.Count(c => c.ParentId == map.Id && !IsEmptyDataMap(c, mapColl)) == 0;
            }
            return false;
        }

        public async Task FillPermissionsAsync(Guid userId)
        {
            if (string.IsNullOrEmpty(SecurityGroup))
            {
                Permissions = null;
                return;
            }

            var filter = Filter.And.Equal(userId, "UserId")
                .Merge(Filter.And.Equal(SecurityGroup, "PermissionGroupCode"));

            var items = await V_Security_CheckPermissionUser.SelectAsync(filter);
            Permissions = items.Select(c => new FormPermissions()
            {
                Id = c.PermissionId,
                Code = c.PermissionCode,
                Name = c.PermissionName,
                AccessType = c.AccessType
            }).ToList();
        }

        public async Task FillMappingAsync()
        {
            Mapping = await MetadataToModelConverter.GetMappingByForm(Name, ignoreNameCase: true);
        }



        public async Task FillCustomBlockFormsAndLocalizateAsync(string lang)
        {
            JToken json = null;
            try
            {
                json = JToken.Parse(Source);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(FillCustomBlockFormsAndLocalizateAsync) + " - failed to parse Source");
            }

            if (json == null)
                return;

            FillCustomBlockForms(json);

            JToken locale = CloverRuntime.Metadata.GetLocalizationForForm(Name, lang);
            if (locale != null)
            {
                LocalizateConrols(json, locale);
            }

            Source = json.ToString();
        }


        public async Task FillCustomBlockFormsAsync()
        {
            JToken json = null;
            try
            {
                json = JToken.Parse(Source);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(FillCustomBlockFormsAsync) + " - failed to parse Source");
            }

            if (json == null)
                return;

            FillCustomBlockForms(json);

            Source = json.ToString();
        }

        public async Task LocalizateAsync(string lang)
        {
            JToken json = null;
            try
            {
                json = JToken.Parse(Source);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(LocalizateAsync) + " - failed to parse Source");
            }

            if (json == null)
                return;

            JToken locale = CloverRuntime.Metadata.GetLocalizationForForm(Name, lang);
            if (locale != null)
            {
                LocalizateConrols(json, locale);
            }

            Source = json.ToString();
        }

        private void LocalizateConrols(JToken controls, JToken local)
        {
            foreach (var control in controls)
            {
                var key = control["key"].ToString();

                if (string.IsNullOrWhiteSpace(key))
                    continue;

                var attributes = GetAttributesForLocalization(control);
                if (attributes != null)
                {
                    foreach (var att in attributes)
                    {
                        var name = string.Format("{0}_{1}", key, att.Key);
                        if (local[name] != null && att.Value != null)
                        {
                            ((JValue)att.Value).Value = local[name].ToString();
                        }
                    }
                }

                if (control["children"] != null)
                {
                    LocalizateConrols(control["children"], local);
                }

                if (control["placeholders"] != null)
                {
                    foreach (var ph in control["placeholders"])
                    {
                        var first = ph.FirstOrDefault();
                        if (first != null)
                            LocalizateConrols(first, local);
                    }
                }
            }
        }

        private void FillCustomBlockForms(JToken controls)
        {
            foreach (var control in controls)
            {
                var buildertype = control["data-buildertype"]?.ToString();
                var sourceType = control["sourceType"]?.ToString();

                if (buildertype != "customblock" && sourceType != "form")
                    continue;

                var formName = control["formname"]?.ToString();
                if (string.IsNullOrEmpty(formName))
                    continue;

                var form = CloverRuntime.Metadata.GetForm(formName); //20260701 - was CR.M
                if (form == null)
                    throw new Exception(string.Format("{0} form is not found!", formName));

                control["children"] = JToken.Parse(form.Source);
                if (control["children"] != null)
                {
                    FillCustomBlockForms(control["children"]);
                }

                if (control["placeholders"] != null)
                {
                    foreach (var ph in control["placeholders"])
                    {
                        var first = ph.FirstOrDefault();
                        if (first != null)
                            FillCustomBlockForms(first);
                    }
                }
            }
        }

        private static Dictionary<string, JToken> getAttributesFromArray(JToken items)
        {
            var attributes = new Dictionary<string, JToken>();
            if (items != null)
            {
                foreach (var item in items)
                {
                    attributes.Add(item["target"].ToString(), item["title"]);
                    if (item["children"] != null && item["children"] is JArray)
                    {
                        foreach (var att in getAttributesFromArray(item["children"]))
                            attributes.Add(att.Key, att.Value);
                    }
                }
            }
            return attributes;
        }

        public static Dictionary<string, JToken> GetAttributesForLocalization(JToken control)
        {
            var buildertype = control["data-buildertype"].ToString();
            var attributes = new Dictionary<string, JToken>();
            switch (buildertype)
            {
                case "menu":
                case "dropdowntrigger":
                    foreach (var att in getAttributesFromArray(control["items"]))
                        attributes.Add(att.Key, att.Value);
                    break;
                case "workflowbar":
                    attributes.Add("setStateButton", control["setStateButton"]);
                    break;
                case "gridview":
                    if (control["columns"] != null)
                    {
                        foreach (var item in control["columns"])
                        {
                            attributes.Add(item["key"].ToString(), item["name"]);
                        }
                    }
                    break;
                case "collectioneditor":
                    if (control["columns"] != null)
                    {
                        foreach (var item in control["columns"])
                        {
                            attributes.Add(item["key"].ToString(), item["name"]);
                        }
                    }
                    break;
                case "header":
                    attributes.Add("content", control["content"]);
                    attributes.Add("subheader", control["subheader"]);
                    break;
                case "input":
                case "textarea":
                case "dictionary":
                case "dropdown":
                case "checkbox":
                    attributes.Add("label", control["label"]);
                    break;
                case "button":
                case "label":
                case "staticcontent":
                    attributes.Add("content", control["content"]);
                    break;
                case "radiogroup":
                    if (control["columns"] != null)
                    {
                        foreach (var item in control["columns"])
                        {
                            attributes.Add(item["key"].ToString(), item["text"]);
                        }
                    }
                    break;
                case "statistic":
                    if (control["data-elements"] != null)
                    {
                        foreach (var item in control["data-elements"])
                        {
                            attributes.Add(item["label"].ToString(), item["label"]);
                        }
                    }
                    break;
                case "barchart":
                case "linechart":
                case "scatterchart":
                case "doughnutchart":
                case "piechart":
                case "radarchart":
                    attributes.Add("title", control["title"]);
                    attributes.Add("dataLabels", control["dataLabels"]);
                    break;
                case "breadcrumb":
                    if (control["items"] != null)
                    {
                        int bcIndex = 1;
                        foreach (var item in control["items"])
                        {
                            attributes.Add(bcIndex.ToString(), item["text"]);
                            bcIndex++;
                        }
                    }
                    break;
            }
            return attributes;
        }

        public List<string> GetTemplates()
        {
            JToken json = null;
            try
            {
                json = JToken.Parse(Source);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(GetTemplates) + " - failed to parse Source");
            }

            if (json == null)
                return null;

            
            return GetTemplates(json).Distinct().ToList();
        }

        private List<string> GetTemplates(JToken controls)
        {
            var templates = new List<string>();
            foreach (var control in controls)
            {
                var buildertype = control["data-buildertype"]?.ToString();
                var sourceType = control["sourceType"]?.ToString();

                if (buildertype != "customblock" && sourceType != "form")
                    continue;

                var formName = control["formname"]?.ToString();
                if (string.IsNullOrEmpty(formName))
                    continue;

                templates.Add(formName);

                var form = CloverRuntime.Metadata.GetForm(formName); //20260701 - was CR.M
                if (form == null)
                    throw new Exception(string.Format("{0} form is not found!", formName));

                control["children"] = JToken.Parse(form.Source);
                if (control["children"] != null)
                {
                    templates.AddRange(GetTemplates(control["children"]));
                }

                if (control["placeholders"] != null)
                {
                    foreach (var ph in control["placeholders"])
                    {
                        var first = ph.FirstOrDefault();
                        if (first != null)
                            templates.AddRange(GetTemplates(first));
                    }
                }
            }
            return templates;
        }

        public Dictionary<string, JToken> GetControls(List<string> controls)
        {
            JToken json = null;
            try
            {
                json = JToken.Parse(Source);
            }
            catch (Exception e)
            {
                _logger.LogError(e, nameof(GetControls) + " - failed to parse Source");
            }

            Dictionary<string, JToken> res = new Dictionary<string, JToken>();
            if (json == null)
                return res;

            foreach(var item in json)
            {
                var key = item["key"].ToString();
                if (controls.Contains(key))
                    res.Add(key, item);
            }

            return res;
        }
    }

    public class FormDataMap
    {
        public Guid Id;
        public Guid AttributeId;
        public string Control;
        public Guid? ParentId;
        public bool IsEditable;
        public bool IsLoadable;
    }

    public class FormDataColl
    {
        public Guid Id;
        public Guid EntityId;
        public string Filter;
        public string Parameter;
        public string Control;
        public List<FormDataMap> DataMap;
        public bool ReadOnly;
        public string TotalCountPropertyName => $"__{Control}_totalcount";
    }

    public sealed class FormItem
    {
        internal FormItem()
        {}

        public string Key { get; set; }
        public string Type { get; set; }
        public Dictionary<string,object> Properties { get; internal set; }
        public List<FormItem> Children { get; internal set; }
    }

    public class FormPermissions
    {
        public Guid Id;
        public string Code;
        public string Name;
        public byte AccessType;
    } 

    public static class FormSerializer
    {
        public static List<FormItem> Deserialize(string source)
        {
            var result = new List<FormItem>();
            if (string.IsNullOrEmpty(source))
                return result;
            var items = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(source);
            foreach (var item in items)
            {
                var resultItem = new FormItem()
                {
                    Key = item["key"].ToString(),
                    Type = item["data-buildertype"].ToString(),
                    Properties = item.Where(kvp => !kvp.Key.Equals("key", StringComparison.Ordinal) && !kvp.Key.Equals("data-buildertype", StringComparison.Ordinal)
                                                   && !kvp.Key.Equals("children", StringComparison.Ordinal)).ToDictionary(kvp => kvp.Key.ToLower(), kvp => kvp.Value),
                    Children = item.ContainsKey("children") ? Deserialize(item["children"].ToString()) : new List<FormItem>(0)
                };
             
                result.Add(resultItem);
            }

            return result;
        }
    }

}