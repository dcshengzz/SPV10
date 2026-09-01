using Newtonsoft.Json.Linq;
using swz.Clover.Core.Metadata;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

namespace swz.SurveyPlus.Application
{
    /// <summary>
    /// There are many place just to parse the same info at ConfigAPIUserAdminController.
    /// Use this to parse necessary info into a better structure, easier to identify what is the trigger.
    /// </summary>
    public class MetadataIdentifier
    {
        public const string KEY_OPERATION = "operation";
        public const string KEY_ITEMS = "items";

        public const string DUPLICATE_FORM = "duplicate-form";

        /// <summary>
        /// MetadataOperations
        /// </summary>
        public string operation { get; private set; } = string.Empty;

        public List<MetadataIdentifierItem> itemList { get; set; } = new List<MetadataIdentifierItem>();

        public MetadataIdentifier(NameValueCollection pars)
        {
            if (pars == null) throw new ArgumentNullException(nameof(pars));
            if (!string.IsNullOrEmpty(pars[KEY_OPERATION]))
            {
                operation = pars[KEY_OPERATION].ToLower();

                if (operation == MetadataOperations.Change)
                {
                    if (!string.IsNullOrEmpty(pars[KEY_ITEMS]))
                    {
                        JArray changes = JArray.Parse(pars[KEY_ITEMS]);
                        if (changes != null)
                        {
                            foreach (JToken item in changes)
                            {
                                if (item == null) continue;
                                MetadataIdentifierItem newItem = new MetadataIdentifierItem(item);
                                itemList.Add(newItem);
                            }
                        }

                    }

                }
            }
        }

        public bool isDeletingSurvey()
        {
            bool result = false;
            if (itemList != null && itemList.Any())
            {
                foreach (MetadataIdentifierItem item in itemList)
                {
                    if (item.isDeletingSurvey(operation))
                    {
                        result = true;
                        break;
                    }
                }
            }
            return result;
        }

        public List<string> getDeletingFormNameList()
        {
            List<string> result = new List<string>();

            if(itemList != null && itemList.Any())
            {
                foreach(MetadataIdentifierItem item in itemList)
                {
                    if(item != null && !string.IsNullOrEmpty(item.surveyName) && item.state == MetadataObjectState.Deleted && item.type == MetadataSections.Form && item.isSurvey)
                    {
                        result.Add(item.surveyName);
                    }
                }
            }

            return result;
        }

        public bool isDuplicateForm()
        {
            return operation == DUPLICATE_FORM;
        }

    }

    public class MetadataIdentifierItem
    {
        public const string KEY_TYPE = "__type";
        public const string KEY_STATE = "__state";
        public const string KEY_IS_SURVEY = "isSurvey";
        public const string KEY_SURVEY_NAME = "name";

        /// <summary>
        /// MetadataSections
        /// </summary>
        public string type { get; private set; } = string.Empty;

        public MetadataObjectState state { get; private set; }

        public bool isSurvey { get; private set; } = false;

        public string surveyName { get; private set; } = string.Empty;

        public MetadataIdentifierItem(JToken attr)
        {
            if (attr == null) throw new ArgumentNullException(nameof(attr));
            if (attr[KEY_TYPE] != null) type = attr[KEY_TYPE].ToObject<string>();
            if (attr[KEY_STATE] != null) state = attr[KEY_STATE].ToObject<MetadataObjectState>();
            if (attr[KEY_IS_SURVEY] != null) isSurvey = attr[KEY_IS_SURVEY].ToObject<bool>();
            if (attr[KEY_SURVEY_NAME] != null) surveyName = attr[KEY_SURVEY_NAME].ToObject<string>();
        }

        public bool isDeletingSurvey(string operation)
        {
            bool result = operation == MetadataOperations.Change && type == MetadataSections.Form && state == MetadataObjectState.Deleted && isSurvey;

            return result;
        }

    }
}
