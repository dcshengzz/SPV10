using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;

namespace swz.SurveyPlus.Application
{
    public class FormFieldAnalyzer
    {
        /// <summary>
        /// Analyzes a form design and returns information about required and non-required fields
        /// </summary>
        /// <param name="formSource">The JSON source from Form.Source property</param>
        /// <returns>Dictionary with field key and whether it's required</returns>
        public Dictionary<string, FormField> GetFieldRequirements(string formSource)
        {
            Dictionary<string, FormField> fieldInfo = new Dictionary<string, FormField>();

            if (string.IsNullOrEmpty(formSource))
                return fieldInfo;

            try
            {
                JToken controls = JToken.Parse(formSource);
                AnalyzeControls(controls, fieldInfo);
            }
            catch (Exception ex)
            {
                throw new Exception($"Failed to parse form source: {ex.Message}", ex);
            }

            return fieldInfo;
        }

        private void AnalyzeControls(JToken controls, Dictionary<string, FormField> fieldInfo)
        {
            if (controls == null) return;

            foreach (JToken control in controls)
            {
                var key = control["key"]?.ToString();
                var builderType = control["data-buildertype"]?.ToString();

                if (string.IsNullOrEmpty(key))
                    continue;

                // Check if this is an input field type
                if (IsInputField(builderType))
                {
                    var info = new FormField
                        (key,control["label"]?.ToString() ?? key,
                        builderType,control["other-required"]?.Value<bool>() ?? false,
                        control["validation"] != null
                        );

                    fieldInfo[key] = info;
                }

                // Recursively check children
                if (control["children"] != null)
                {
                    AnalyzeControls(control["children"], fieldInfo);
                }
            }
        }

        private bool IsInputField(string builderType)
        {
            if (string.IsNullOrEmpty(builderType))
                return false;

            string[] inputTypes = new[]
            {
            "input", "textarea", "dropdown", "checkbox",
            "dictionary", "radiogroup", "datepicker"
        };

            return Array.Exists(inputTypes, t => t.Equals(builderType, StringComparison.OrdinalIgnoreCase));
        }

        /// <summary>
        /// Get only required fields
        /// </summary>
        public List<FormField> GetRequiredFields(string formSource)
        {
            Dictionary<string, FormField> allFields = GetFieldRequirements(formSource);
            List<FormField> requiredFields = new List<FormField>();

            foreach (FormField field in allFields.Values)
            {
                if (field.IsRequired)
                    requiredFields.Add(field);
            }

            return requiredFields;
        }
    }

    public class FormField
    {
        public string Key { get; }
        public string Label { get; }
        public string FieldType { get; }
        public bool IsRequired { get; }
        public bool HasValidation { get; }

        public FormField(string key, string label, string fieldType, bool isRequired, bool hasValidation)
        {
            Key = key;
            Label = label;
            FieldType = fieldType;
            IsRequired = isRequired;
            HasValidation = hasValidation;
        }
    }
}
