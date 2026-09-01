using swz.Clover.Core;
using swz.Clover.Core.Metadata.DbObjects;
using swz.SurveyPlus.Application;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Structure to hold settings in dwAppSettings under the "Mail Merge" group.
    /// Includes a static factory method to read an instance from the dwAppSettings.
    /// </summary>
    public class MailMergeSettings
    {
        public const string MAILMERGE_INCLUDE_PROPS = "MailMergeIncludeProps";
        public const string MAILMERGE_FILE_TYPE = "MailMergeFileType";

        private static readonly List<String> settingNames = new List<string> {
            MAILMERGE_INCLUDE_PROPS,
            MAILMERGE_FILE_TYPE,
        };

        /// <summary>
        /// Read the settings from the dwAppSettings. 
        /// </summary>
        public static async Task<MailMergeSettings> GetFromAppSettingsAsync()
        {
            ILookup<string, string> settings = (await AppSettings
                .SelectAsync(Filter.And.In(settingNames, Constants.FieldName.Name)))
                .ToLookup(s => s.Name, s => s.Value);

            string includePropsString = settings[MAILMERGE_INCLUDE_PROPS].FirstOrDefault();
            if (string.IsNullOrWhiteSpace(includePropsString))
                throw new InvalidOperationException($"No value found in dwAppSettings for {MAILMERGE_INCLUDE_PROPS}");
            if (!bool.TryParse(includePropsString, out bool includeProps))
                throw new FormatException($"Value for {MAILMERGE_INCLUDE_PROPS} cannot be parsed as a bool");

            string fileTypeString = settings[MAILMERGE_FILE_TYPE].FirstOrDefault();
            if (string.IsNullOrWhiteSpace(fileTypeString))
                throw new InvalidOperationException($"No value found in dwAppSettings for {MAILMERGE_FILE_TYPE}");
            if (!Enum.TryParse(fileTypeString, out ProfileMailMerger.MergeFileType fileType))
                throw new FormatException($"Value for {MAILMERGE_FILE_TYPE} cannot be parsed");

            MailMergeSettings instance = new MailMergeSettings(includeProps, fileType);
            return instance;
        }

        // // // // // // // // // // // // // // // // // // // // // // // // // //
        //NOTE: this object is intended to be immutable. Do not add public setters.//
        // // // // // // // // // // // // // // // // // // // // // // // // // //

        /// <summary>
        /// This setting indicates that (by default) we want to expose list sample properties as substitution tokens
        /// (So it corresponds with ExposeListSampleProps in the ProfileMailMerger class)
        /// </summary>
        public bool MailMergeIncludeProps { get; }

        public ProfileMailMerger.MergeFileType MailMergeFileType { get; }

        public MailMergeSettings(
            bool includeProps,
            ProfileMailMerger.MergeFileType fileType)
        {
            this.MailMergeIncludeProps = includeProps;
            this.MailMergeFileType = fileType;
        }

        public void ApplyTo(ProfileMailMerger profileMailMerger)
        {
            profileMailMerger.ExposeListSampleProps = MailMergeIncludeProps;
            profileMailMerger.MailMergeType = MailMergeFileType;
        }

    }
}
