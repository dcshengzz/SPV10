using CsvHelper;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using swz.Clover.Core;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;
using swz.SurveyPlus.Application;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Winnovative;
using Constants = swz.SurveyPlus.Application.Constants;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Class that performs the email sending, mail merging, and generation of sample profile.
    /// Instances should be obtained via the provided factory method, configure the properties as desired and
    /// then call one of the Execute methods.
    /// </summary>
    public class ProfileMailMerger
    {
        private static readonly ILogger logger = DefaultApplicationLogging.CreateLogger(typeof(ProfileMailMerger));

        /// <summary>
        /// The standard substitution tokens made available to mail merges
        /// </summary>
        public static class Tokens
        {
            public const string DplySampleInfoId = "DplySampleInfoId";
            public const string DplyName = "DplyName";
            public const string DplyQnn = "DplyQnn";
            public const string DplyList = "DplyList";
            public const string Name = "Name";
            public const string Legacy_Email = "Email";
            public const string UID = "UID";
            public const string UIDPeer = "UIDPeer";
            public const string ActiveYN = "ActiveYN";
            public const string Password = "Password";
            public const string Date = "Date";
            public const string DueDate = "DueDate";
            public const string DueDateNumeric = "DueDateNumeric";
            public const string DueDateISO = "DueDateISO";
            public const string DueDateChinese = "DueDateChinese";
            public const string DueDateMalay = "DueDateMalay";
            public const string DueDateTamil = "DueDateTamil";
            public const string PAGEBREAK = "PAGEBREAK";
            public const string SurveyUrl = "SurveyUrl";
            public const string DelegationCode = "DelegationCode";
            public const string SurveyName = "SurveyName";
            public const string InvitationUrl = "InvitationUrl";
            public const string InvitationLink = "InvitationLink";
            public const string ToEmails = "ToEmails";
            public const string CcEmails = "CcEmails";
            public const string AddressLine1 = "AddressLine1";
            public const string AddressLine2 = "AddressLine2";
            public const string AddressLine3 = "AddressLine3";

            //the token for a QR code and url text is this appended with the exact form or language name
            public const string SurveyQRLocation_PREFIX = "SurveyQRLocation_";

            //the token for a url text is this appended with the exact form or language name
            public const string SurveyURLLocation_PREFIX = "SurveyURLLocation_";   //raw url 
            public const string SurveyLinkLocation_PREFIX = "SurveyLinkLocation_"; //html link
        }

        /// <summary>
        /// Used internally when an error condition is detected by logic checks
        /// </summary>
        private class InternalError : ApplicationException
        {
            public InternalError(string message) : base(message) { }
        }

        /// <summary>
        /// Specifies file type generated for the PDF mail merge
        /// </summary>
        public enum MergeFileType
        {
            //Warning - we store strings for these in dwAppSettings now, so if changed, need to update existing rows there

            /// <summary>
            /// Write individual PDF files to a folder then archive using an external tool (i.e 7zip)
            /// </summary>
            ArchivedFolder,

            /// <summary>
            /// Generate a Zip file with individual PDF file for each sample named by UID
            /// </summary>
            ZippedPdfs,

            /// <summary>
            /// Generate a single PDF file containing the mail for all samples
            /// </summary>
            SinglePdf,

            /// <summary>
            /// Will try to decide whether to use a zip or a single pdf based on business logic
            /// </summary>
            Auto,
        };

        /// <summary>
        /// Factory method to return an instance of the mail merger.
        /// Will obtain the required mail settings and the internet domain authority from the ap settings.
        /// Will perform post-construction asynchronous initialisation.
        /// Callers must also call ApplyOptionsFromTemplate after setting their defaults so any template specific
        /// options from the options block can be set (overwriting details). Execute will check for this and fail if it
        /// has not been called yet.
        /// </summary>
        /// <param name="userId">Id of the Clover user (ie a survey admin) that initiated the job</param>
        /// <param name="qnnDplyId">Id in QNN_DPLY, must not be empty</param>
        /// <param name="template">HTML template to be filled for mail merge</param>
        /// <returns>a new initialised ProfileMailMerger instance</returns>
        public static async Task<ProfileMailMerger> NewInstanceAsync(Guid userId, Guid qnnDplyId, string template)
        {
            MailSettings mailSettings = await MailSettings.GetFromAppSettingsAsync();
            string appName = await SettingsHelper.Common.GetApplicationName();
            string internetDomainAuthority = await SettingsHelper.Common.GetInternetDomainAuthority();
            ProfileMailMerger instance = new ProfileMailMerger(
                mailSettings, 
                appName, 
                internetDomainAuthority, 
                userId, 
                qnnDplyId, 
                template??"");
            await instance.InitialiseAsync();
            return instance;
        }

        /// <summary>
        /// Generate the profile PDF (with passwords etc).
        /// Default is false
        /// </summary>
        public bool GenerateProfile { get; set; } = false;

        /// <summary>
        /// Generate a pdf mail merge. This will be stored as either a single pdf file or a zip file containing
        /// individual pdfs depending on the vaue of MailMergeType.
        /// Default is false
        /// </summary>
        public bool GenerateMailMerge { get; set; } = false;

        /// <summary>
        /// Send emails to samples (ignore those without an email address).
        /// If set to true you will need to also set EmailFrom and EmailSubject.
        /// Default is false
        /// </summary>
        public bool GenerateEmail { get; set; } = false;

        /// <summary>
        /// Set the sender address to appear in email messages.
        /// If this is uspecified will use the default sender.
        /// The optional Display Name part may also now be specified here (e.g. "Conglomo Research Unit" &gt;conglomo@example.com&lt;)
        /// </summary>
        public string EmailFrom { get; set; } = Email.UseDefaultEmailFrom;

        /// <summary>
        /// Set the subject line for email messages. Tokens may be used here.
        /// Default is null but you should set a value if GenerateEmail is true
        /// </summary>
        public string EmailSubject { get; set; } = null;

        /// <summary>
        /// Should the list sample props be made available as tokens for filling the template?
        /// Default is true
        /// </summary>
        public bool ExposeListSampleProps { get; set; } = true;

        /// <summary>
        /// Should the template be wrapped with html and body tags and a doctype provided istead of used as-is?
        /// Default is true (false will support the case where we want to provide a verbatim template. 
        /// Old hosted surveyplus has support for this, new surveyplus (oss2, misp, etc) currently do not
        /// although it is planned to port it in at some point.
        /// </summary>
        public bool WrapTemplateWithBody { get; set; } = true;

        /// <summary>
        /// Specifies the type of file to be generated when GenerateMailMerge is true.
        /// Default is MergeFileType.ZippedPdfs
        /// </summary>
        public MergeFileType MailMergeType { get; set; } = MergeFileType.ZippedPdfs;

        /// <summary>
        /// Used by pdf component in mail merge as base for relative urls when pulling external resources.
        /// Default is null
        /// </summary>
        public string UrlBase { get; set; } = null;

        /// <summary>
        /// Used by pdf component in mail merge as url for internal doc links. Default is null.
        /// </summary>
        public string InternalDocLinksUrl { get; set; } = null;

        public string MailMergeFolderPath { get; set; } = null;

        public bool IsUsingMailMergeFolder { get => !string.IsNullOrEmpty(MailMergeFolderPath);  }

        public string MailMergeArchivedFolderCommand { get; set; }

        public string MailMergeArchivedFolderCommandArguments { get; set; }

        public string MailMergeArchivedFolderExtension { get; set; }

        //Winnovative PDF configurations for Mail Merge (defaults below aim to minimise file size and memory usage)
        //TODO - consider making a sub-object for the winnovate specific settings
        public PdfCompressionLevel Winnovative_CompressionLevel { get; set; } = PdfCompressionLevel.Best;
        public int Winnovative_ConversionDelay { get; set; } = 0; //dont allow a delay for js to reformat the pages (winnovate default is 2 seconds)
        public bool Winnovative_EmbedFonts { get; set; } = false; //embedding fonts adds >100kb to each pdf file
        public bool Winnovative_ImageScalingEnabled { get; set; } = true;
        public bool Winnovative_JpegCompressionEnabled { get; set; } = true;
        public int Winnovative_JpegCompressionLevel { get; set; } = 40; //0..100, default was 10, lets crank it up eh?
        public bool Winnovative_CompressCrossReference { get; set; } = true;

        public int QRPixelsPerModule { get; set; } = 1; //default to only 1ppm to reduce file size

        public string QRImageStyle { get; set; }
                = "width: 6cm; height: 6cm; page-break-inside:avoid;";

        public string QRTextDivStyle { get; set; }
                = " padding: 0.5cm; max-width: 6.5cm; word-break: break-all; overflow-wrap: break-word; "
                + " margin-top: 0.5cm; margin-bottom: 0.5cm; margin-left: auto; margin-right: auto; "
                + "background-color:  #F2F2F2;";

        public string QRTextStyle { get; set; }
            = "font-family: monospace; font-size: 13pt; color: black; text-decoration: none;";

        public bool QRTextEnabled { get; set; } = true;

        private readonly Guid qnnDplyId;
        private Guid userId;
        private readonly string template;
        private readonly bool populateSurveyQrLocationForLanguages;
        private readonly bool populateOtherSurveyLocationForLanguages;
        private readonly bool populateInvitation;
        private readonly Regex validPdfFilenameRegex = new Regex("^[a-zA-Z0-9_]*$", RegexOptions.None, TimeSpan.FromSeconds(1));
        private readonly bool populateSurveyUrl;

        private readonly MailSettings mailSettings;
        private readonly string appName;
        private string internetDomainAuthority;
        private bool templateOptionsApplied = false;

        private EntityModel qnnDplyModel;
        private EntityModel qnnDplyMessageSampleModel;
        private EntityModel qnnDplySampleInfoModel;
        private EntityModel qnnListSampleModel;
        private EntityModel vSpListSampleInfoModel;
        private EntityModel qnnListSamplePropModel;
        private EntityModel qnnDplyMsgModel;
        private EntityModel qnnListPropModel;
        private EntityModel qnnQnnFormModel;
        private EntityModel qnnSampleAddressModel;

        private const string PAGE_BREAK_DIV = "<div style=\"page-break-after: always; width: 100%; height: 1px; \"></div>";

        private const string BODY_WRAP_BEGIN = "<!DOCTYPE html><html><head><meta charset=\"UTF-8\" /></head><body>";
        private const string BODY_WRAP_END = "</body></html>";

        //Date style to use in token replacements for dates 
        private const string TOKEN_DATE_FORMAT = "dd MMMM yyyy"; //(eg: 02 March 2023)
        private const string TOKEN_DATE_FORMAT_NUMERIC = "dd/MM/yyyy"; //eg 02/03/2023
        private const string TOKEN_DATE_FORMAT_ISO = "yyyy-MM-dd"; //eg 2023-03-02
        private const string TOKEN_DATE_FORMAT_CHINESE = "yyyy年M月d日"; //eg 2023年3月2日 (no leading zeroes)
        private const string TOKEN_DATE_FORMAT_MALAY = "d\\h\\b MMMM yyyy";
        private const string TOKEN_DATE_FORMAT_TAMIL = TOKEN_DATE_FORMAT_NUMERIC; //for now we will use the numeric format (TODO)

        private readonly DateTimeFormatInfo invariantFormat = DateTimeFormatInfo.InvariantInfo;
        private readonly DateTimeFormatInfo malayFormat = new CultureInfo("ms-SG", false).DateTimeFormat;
        private readonly DateTimeFormatInfo tamilFormat = new CultureInfo("ta-SG", false).DateTimeFormat; 
        private readonly DateTimeFormatInfo chineseFormat = new CultureInfo("zh-SG", false).DateTimeFormat; 
        
        /// <summary>
        /// Performance tuning option for Mail Merge, sets length of a pause that will
        /// occur every MailMergePauseCount samples. If set to zero then no pause will
        /// be inserted.
        /// </summary>
        private const int mailMergePauseMillisconds = 3000;

        /// <summary>
        /// Number of samples to process between each pause.
        /// nb: the last pause will be skipped if the count remaining is less than this number
        /// </summary>
        private const int mailMergePauseSampleCount = 64;

        /// <summary>
        /// Constructor is private and intended to be called by a static factory method which must also
        /// call Initialise() before releasing the object into the wild.
        /// </summary>
        /// <param name="mailSettings">Email server config, required</param>
        /// <param name="appName">ApplicationName, required</param>
        /// <param name="internetDomainAuthority">public domain of the internet application (for use in links), required</param>
        /// <param name="userId">Id of the Clover user (ie a survey admin) that initiated the job</param>
        /// <param name="qnnDplyId">Id in QNN_DPLY, must not be empty</param>
        /// <param name="template">HTML template to be filled for mail merge</param>
        private ProfileMailMerger(
            MailSettings mailSettings,
            string appName,
            string internetDomainAuthority,
            Guid userId,
            Guid qnnDplyId,
            string template)
        {
            if (Guid.Empty.Equals(qnnDplyId)) throw new ArgumentException("may not be empty", nameof(qnnDplyId));
            if (String.IsNullOrWhiteSpace(appName)) throw new ArgumentException(nameof(appName));
            if (template == null) throw new ArgumentNullException(nameof(template));
            this.mailSettings = mailSettings ?? throw new ArgumentException(nameof(mailSettings));
            this.appName = appName;
            if (string.IsNullOrWhiteSpace(internetDomainAuthority)) throw new ArgumentException(nameof(internetDomainAuthority));
            //We now add the https here in the constructor instead of adding it when generating links. The reason for this is so
            //when using the template options block we can if needs be override its inclusion or use http. (But note that it is 
            //not recommended to omit the https:// )
            this.internetDomainAuthority 
                = !internetDomainAuthority.StartsWith("https://", StringComparison.InvariantCultureIgnoreCase)
                ? Constants.MailLinksProtocol + internetDomainAuthority
                : internetDomainAuthority;
            this.userId = userId;
            this.qnnDplyId = qnnDplyId;
            if(template.Contains(Tokens.SurveyUrl))
            {
                populateSurveyUrl = true;
            }
            populateSurveyQrLocationForLanguages = template.Contains("{" + Tokens.SurveyQRLocation_PREFIX); //don't care ending '}'
            populateOtherSurveyLocationForLanguages
                = template.Contains("{" + Tokens.SurveyURLLocation_PREFIX)
                || template.Contains("{" + Tokens.SurveyLinkLocation_PREFIX); //don't care ending '}'
            populateInvitation 
                = template.Contains("{" + Tokens.InvitationLink + "}") 
                || template.Contains("{" + Tokens.InvitationUrl + "}");
            this.template = template;
        }

        /// <summary>
        /// Some post-constructor internal initialisation
        /// </summary>
        /// <returns></returns>
        private async Task InitialiseAsync()
        {
            //Cause I'm a model, you know what I mean...
            qnnDplyModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY, Constants.Level.FetchJoins);

            qnnDplySampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_SAMPLE_INFO, Constants.Level.NoJoins);

            qnnDplyMessageSampleModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG_SAMPLE, Constants.Level.NoJoins);

            qnnListSampleModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE, Constants.Level.FetchJoins);

            vSpListSampleInfoModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.vSP_ListSampleInfo, Constants.Level.FetchJoins);

            qnnListSamplePropModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_SAMPLE_PROP, Constants.Level.NoJoins);

            qnnDplyMsgModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_DPLY_MSG, Constants.Level.NoJoins);

            qnnListPropModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_LIST_PROP, Constants.Level.NoJoins);

            qnnQnnFormModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_QNN_FORM, Constants.Level.NoJoins);

            qnnSampleAddressModel
                = await MetadataToModelConverter.GetEntityModelByModelAsync(Constants.ModelName.QNN_SAMPLE_ADDRESS, Constants.Level.NoJoins);
        }

        /// <summary>
        /// Perform the mail merge / mail blast / profile (as per configured properties) for the
        /// specified samples.
        /// NOTE: this call expects the the QNN_DPLY_MESSAGE_SAMPLE records have _already_ been prepared
        /// for these samples and does not create them itself.
        /// Warning: this method is sync over async
        /// </summary>
        /// <param name="dplyMsgId"></param>
        /// <param name="listSampleIds"></param>
        /// <returns>true on success</returns>
        public bool ExecuteBySamples(Guid dplyMsgId, List<Guid> listSampleIds)
        {
            return ExecuteBySamplesAsync(dplyMsgId, listSampleIds).Result;
        }

        /// <summary>
        /// Excecute for the samples with the given status and filter with tags.
        /// Nb: This call will also prepare QNN_DPLY_MESSAGE_SAMPLE for the records found.
        /// Warning: this method is sync over async
        /// </summary>
        /// <param name="qnnDplyMsgId">deployment message id</param>
        /// <param name="qnnStatusIds">list of status id</param>
        /// <param name="tagsFilter">tagsFilter control</param>
        /// <param name="listTags">list of tags in string</param>
        /// <returns></returns>
        public bool ExecuteByStatus(Guid qnnDplyMsgId, List<Guid> qnnStatusIds)
        {
            return ExecuteByStatusAsync(qnnDplyMsgId, qnnStatusIds).Result;
        }

        private async Task<bool> ExecuteByStatusAsync(Guid qnnDplyMsgId, List<Guid> listQnnStatusId)
        {
            List<Guid> listSampleIds = await PrepareQnnDplyMessageSamplesAsync(qnnDplyMsgId, listQnnStatusId);
            if (listSampleIds == null || listSampleIds.Count == 0) return true; //No samples found in all status, no need to proceed
            return ExecuteBySamplesAsync(qnnDplyMsgId, listSampleIds).Result;
        }

        private bool IsUsingFormSpecificTokens()
        {
            return populateSurveyQrLocationForLanguages || populateOtherSurveyLocationForLanguages;
        }

        private async Task<bool> ExecuteBySamplesAsync(Guid qnnDplyMsgId, List<Guid> listSampleIds)
        {
            bool isDebugLoggingEnabled = logger.IsEnabled(LogLevel.Debug);
            bool isTraceLoggingEnabled = logger.IsEnabled(LogLevel.Trace);
            long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;

            if (isTraceLoggingEnabled)
            {
                logger.LogTrace("Preparing to start run for qnnDplyMsgId={0}, GenerateMailMerge={1}, GenerateEmail={2}, GenerateProfile={3}, MailMergeType={4}", qnnDplyMsgId, GenerateMailMerge, GenerateEmail, GenerateProfile, MailMergeType);
            }

            if (!templateOptionsApplied)
                throw new InternalError(nameof(ApplyOptionsFromTemplate) + " has not been called");

            if (Guid.Empty.Equals(qnnDplyMsgId))
            {
                throw new ArgumentException("dplyMsgId may not be empty");
            }
            if (listSampleIds == null)
            {
                throw new ArgumentNullException("listSampleIds");
            }
            if (!GenerateMailMerge && !GenerateEmail && !GenerateProfile)
            {
                return false; //no work to do, but returns failure
            }
            int sampleCount = listSampleIds.Count;

            try //try block for overall exception catching
            {
                DynamicEntity qnnDply 
                    = await DeploymentApplication.GetQnnDplyById(qnnDplyId, qnnDplyModel);
                if (qnnDply == null)
                    throw NotFoundException.ForModelName(qnnDplyModel.Name, qnnDplyId);

                Dictionary<Guid, string> aliasByQnnListPropId
                    = (ExposeListSampleProps) ? await PreparePropAliasLookup((Guid)qnnDply[Constants.FieldName.ListId]) : null;

                bool directAccessEnabled = (bool)qnnDply[Constants.FieldName.IsDirectAccessEnabled];

                List<DynamicEntity> sortedQnnQnnFormList = null;
                if (IsUsingFormSpecificTokens())
                {
                    Guid qnnId = (Guid)qnnDply[Constants.FieldName.QnnId];
                    Filter filterByQnnId = Filter.And.Equal(qnnId, Constants.FieldName.QnnId);
                    Order orderByNumberId = Order.StartAsc(Constants.FieldName.NumberId);
                    sortedQnnQnnFormList = await qnnQnnFormModel.GetAsync(filterByQnnId, orderByNumberId, null);
                }

                //Used for mail merge zipped pdfs (may need to dispose in finally)
                Stream mailMergeZipStream = null;
                ZipArchive mailMergeZipArchive = null;
                PdfConverter htmlToPdfConverter = null;
                string archiveFolderPath = null;

                //Used for mail merge single pdf (may need to close in finally)
                Document pdfDocument = null;

                //Used for email blast (may need to dispose in finally)
                Email.IMailer mailer = null;

                MergeFileType mergeTypeInUse = MailMergeType;
                if (mergeTypeInUse == MergeFileType.Auto)
                {
                    //20221012 - Ported in the old surveyplus behaviour of using Zip for Trackable Anonymous (now called Direct Access)
                    if (directAccessEnabled)
                    {
                        mergeTypeInUse = MergeFileType.ZippedPdfs;
                    }
                    else if( (sampleCount * (template.Length*10)) > (64*1024*1024))
                    { //20230301 - Heuristic to use zippedPdfs if the output will be a lot
                      //Nb: the actual pdf output will usually considerably exceed template length (so can't estimate exactly, guessing 10x here)
                        mergeTypeInUse = MergeFileType.ZippedPdfs;
                    }
                    else
                    {
                        mergeTypeInUse = MergeFileType.SinglePdf;
                    }
                }

                try //streams try block for disposing the above streams
                {
                    if (GenerateMailMerge)
                    {
                        switch (mergeTypeInUse)
                        {
                            case MergeFileType.ArchivedFolder:
                                if (!IsUsingMailMergeFolder)
                                    throw new InvalidOperationException($"A Mail Merge Folder is required to use {MergeFileType.ArchivedFolder.ToString()} merge type");
                                archiveFolderPath = Path.Combine(MailMergeFolderPath, $"{qnnDplyMsgId}");
                                if (isDebugLoggingEnabled)
                                    logger.LogDebug("Run for dplyMsgId={0} is creating folder {1} for the archive", qnnDplyMsgId, archiveFolderPath);
                                Directory.CreateDirectory(archiveFolderPath);
                                htmlToPdfConverter = CreatePdfConverter();
                                break;

                            case MergeFileType.ZippedPdfs:
                                if(IsUsingMailMergeFolder)
                                {
                                    string path = Path.Combine(MailMergeFolderPath, $"{qnnDplyMsgId}.zip");
                                    if (isDebugLoggingEnabled)
                                        logger.LogDebug("Run for dplyMsgId={0} is creating {1} for the zip archive", qnnDplyMsgId, path);
                                    mailMergeZipStream = new FileStream(path, FileMode.CreateNew);
                                }
                                else
                                {
                                    if (isDebugLoggingEnabled)
                                        logger.LogDebug("Run for dplyMsgId={0} is using a MemoryStream for the zip archive", qnnDplyMsgId);
                                    mailMergeZipStream = new MemoryStream();
                                }
                                mailMergeZipArchive = new ZipArchive(mailMergeZipStream, ZipArchiveMode.Create, leaveOpen: true);
                                htmlToPdfConverter = CreatePdfConverter();
                                break;

                            case MergeFileType.SinglePdf:
                                pdfDocument = CreatePdfDocument();
                                break;

                            default:
                                throw new NotImplementedException();
                        }
                    }

                    if (GenerateEmail || GenerateMailMerge)
                    {
                        if(GenerateEmail)
                        {
                            mailer = await Email.CreateMailer(
                                mailSettings: mailSettings,
                                senderDisplayName: appName,
                                emailFrom: EmailFrom);
                        }

                        //We may need to update dlsi to add DirectAccessCode (etc) so we will add such
                        //modified QNN_DPLY_SAMPLE_INFO to this list for for batch updating
                        List<dynamic> qnnDplySampleInfoToBeUpdated = new List<dynamic>();

                        byte[] dacKey = EncryptionHelper.Bytes(Constants.LoginKey);
                        int count = 0;
                        //string[] sampleEmail = new String[1];



                        //
                        // Main loop starts here - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        //
                        if (logger.IsEnabled(LogLevel.Information))
                        {
                            logger.LogInformation("Starting run for qnnDplyMsgId={0}, GenerateMailMerge={1}, GenerateEmail={2}, GenerateProfile={3}, sampleCount={4}, mergeTypeInUse={5}", qnnDplyMsgId, GenerateMailMerge, GenerateEmail, GenerateProfile, sampleCount, mergeTypeInUse);
                        }
                        foreach (Guid listSampleId in listSampleIds)
                        {
                            try //try block for non-fatal exception catching for each sample (TODO but should it be non-fatal???)
                            {
                                count += 1;
                                int countRemaining = (sampleCount - count);

                                //Get the info about this sample
                                SampleEntityInformation sinfo = await RetrieveSampleEntitiesAsync(qnnDplyId, listSampleId);
                                DynamicEntity qnnListSample = sinfo.ListSample;
                                DynamicEntity vSpListSampleInfo = sinfo.ListSampleInfo;
                                DynamicEntity qnnDplySampleInfo = sinfo.DplySampleInfo;

                                bool needToAssignAccessCode
                                    = populateSurveyQrLocationForLanguages
                                    || populateOtherSurveyLocationForLanguages
                                    || populateInvitation;
                                if (needToAssignAccessCode)
                                {
                                    bool lacksAccessCode = string.IsNullOrEmpty((string)qnnDplySampleInfo[Constants.FieldName.DirectAccessCode]);

                                    //Assign this deployment sample a DirectAccessCode if they don't have one already
                                    //and they will need one for a QR code or direct access or invitation URL (etc) in this template
                                    //Note, in old SurveyPlus the column was "AccessCode" but that's used with delegation here
                                    //so we now use "DirectAccessCode" column in the QNN_DPLY_SAMPLE_INFO for this one
                                    if (lacksAccessCode)
                                    {
                                        byte[] dacIv = ((Guid)qnnDplySampleInfo[Constants.FieldName.Id]).ToByteArray();
                                        qnnDplySampleInfo[Constants.FieldName.DirectAccessCode] = new AccessCode().ToEncryptedString(dacKey, dacIv);
                                        qnnDplySampleInfoToBeUpdated.Add(qnnDplySampleInfo); //will be bulk updated later
                                    }
                                }

                                //Retrieve the token values for this sample
                                Dictionary<string, string> parameters = await PopulateParameters(
                                    qnnDply: qnnDply,
                                    sampleInfo: sinfo,
                                    vSpListSampleInfo: vSpListSampleInfo,
                                    aliasByQnnListPropId: aliasByQnnListPropId,
                                    sortedQnnQnnFormList: sortedQnnQnnFormList);

                                //Fill the subject line and template using token values specific to this sample
                                (string subject, string bodyHtml) = FillTemplate(parameters);
                                string documentHtml = WrapTemplateWithBody ? BODY_WRAP_BEGIN + bodyHtml + BODY_WRAP_END : bodyHtml;

                                if (GenerateMailMerge)
                                {
                                    //Generate PDF content for this sample and add to the zip or single-pdf we are building
                                    switch (mergeTypeInUse)
                                    {
                                        case MergeFileType.ArchivedFolder:
                                            string filename = GetZippedPdfFileName(vSpListSampleInfo);
                                            string filepath = Path.Combine(archiveFolderPath, filename);
                                            using (FileStream pdfFile = File.Create(filepath))
                                            {
                                                byte[] pdf = htmlToPdfConverter.GetPdfBytesFromHtmlString(documentHtml, UrlBase, InternalDocLinksUrl);
                                                pdfFile.Write(pdf);
                                            }
                                            break;

                                        case MergeFileType.ZippedPdfs:
                                            string entryName = GetZippedPdfFileName(vSpListSampleInfo);
                                            ZipArchiveEntry zipEntry = mailMergeZipArchive.CreateEntry(entryName);
                                            using (Stream entryStream = zipEntry.Open())
                                            {
                                                byte[] pdf = htmlToPdfConverter.GetPdfBytesFromHtmlString(documentHtml, UrlBase, InternalDocLinksUrl);
                                                entryStream.Write(pdf);
                                            }
                                            break;

                                        case MergeFileType.SinglePdf:
                                            HtmlToPdfElement element = CreateHtmlToPdfElement(documentHtml);
                                            pdfDocument.AddPage().AddElement(element);
                                            break;

                                        default:
                                            throw new NotImplementedException();
                                    }

                                    //Winnovate is rather heavy and somewhat of a memory hog so every so often lets just take
                                    //a short break and show the garbage collector and other stuff on the server a little mercy!
                                    if ((mailMergePauseMillisconds > 0)
                                        && (count % mailMergePauseSampleCount == 0)
                                        && (countRemaining >= mailMergePauseSampleCount))
                                    {
                                        await Task.Delay(mailMergePauseMillisconds);
                                    }
                                } //end if GenerateMailMerge

                                if (GenerateEmail)
                                {
                                    try
                                    {
                                        string commaDelimitedToEmails = (string)sinfo.SampleAddress?[Constants.FieldName.ToEmails] ?? "";
                                        List<string> toEmails = Email.SplitAddresses(commaDelimitedToEmails); //throws FormatException if invalid format, which we would catch below
                                        bool hasPrimaryEmail = toEmails.Any();

                                        //nb: we only send if there is at least one primary email address
                                        //    (so any 'cc' would be ignored if there is no 'to' address)
                                        if (hasPrimaryEmail)
                                        {
                                            string commaDelimitedCcEmails = (string)sinfo.SampleAddress[Constants.FieldName.CcEmails];

                                            if (logger.IsEnabled(LogLevel.Trace))
                                                logger.LogTrace("Sending email to={0}, cc={1}", commaDelimitedToEmails, commaDelimitedCcEmails);

                                            List<string> ccEmails = Email.SplitAddresses(commaDelimitedCcEmails); //throws FormatException if invalid format, which we would catch below

                                            //TODO - need to refactor to facilitate putting images as attachments (with cid).
                                            //Currently base64 img src gets sent but most email clients block or ignore such images.
                                            //However at this point we have a big string and we dont know what images are in it. We could
                                            //do a quick parse and extract out each base64 image and convert to an attachment , but a lot
                                            //images are repeated (eg Logos) so its a lot of unnecessary work multiplied by sample count.
                                            //Would be better to reify the template string into a template class and have it extract them
                                            //upfront and coveniently present them to us as an Email.Item or byte[]
                                            bool success = await mailer.SendAsync(
                                                mailTo: toEmails,
                                                mailCc: ccEmails,
                                                mailBcc: null,
                                                subject: subject ?? "",
                                                body: bodyHtml);

                                            if (!success && isDebugLoggingEnabled)
                                            {
                                                logger.LogDebug("Run for qnnDplyMsgId={0}, email failed for sample {1}, toEmails={2}, ccEmails={3}",
                                                    qnnDplyMsgId, (Guid)qnnListSample[Constants.FieldName.Id], toEmails, ccEmails);
                                            }

                                            //TODO - the email is always using the unwrapped body content but I think it should use documentHtml instead.
                                            //(Using bodyCopy was the existing behaviour before refactoring into ProfileMailMerger so I preserved it)

                                            //TODO - existing logic ignores success flag and always records a sent date even on fail, should we change it
                                            //       to only do that if success is true? (SendAysnc does log its exceptions before returning false)

                                            //update sending email status in QNN_DPLY_MESSAGE_SAMPLE
                                            Filter byListSampleIdAndDplyMsgId = Filter.And
                                                .Equal(listSampleId, Constants.FieldName.ListSampleId)
                                                .Equal(qnnDplyMsgId, Constants.FieldName.DplyMsgId);
                                            DynamicEntity dplyMsgSample
                                                = (await qnnDplyMessageSampleModel.GetAsync(byListSampleIdAndDplyMsgId)).FirstOrDefault();
                                            if (dplyMsgSample != null)
                                            {
                                                dplyMsgSample[Constants.FieldName.EmailSentDate] = DateTime.Now;
                                                dplyMsgSample[Constants.FieldName.ToEmails] = commaDelimitedToEmails;
                                                dplyMsgSample[Constants.FieldName.CcEmails] = commaDelimitedCcEmails;
                                                await qnnDplyMessageSampleModel.UpdateSingleAsync(dplyMsgSample);
                                            }
                                        }
                                    }
                                    catch(Exception e)
                                    {
                                        logger.LogError(e, "Unexpected exception generating email in run for qnnDplyMsgId={0}, listSampleId={1}, sampleAddress={2}", qnnDplyMsgId, listSampleId, sinfo.SampleAddress?[Constants.FieldName.Id]);
                                    }                                    
                                } //end if GenerateEmail
                            }
                            catch (Exception e)
                            {
                                //Log the error and skip to next sample
                                //This catch block also catches errors in pdf generation etc at a sample level
                                logger.LogError(e, "Unexpected exception in run for qnnDplyMsgId={0}, listSampleId={1}", qnnDplyMsgId, listSampleId);
                            }
                            finally
                            {
                                //Do this in a finally block for the iteration
                                //so it isnt skipped if a bad sample threw an exception
                                const int saveEveryNSamples = 100;
                                if (qnnDplySampleInfoToBeUpdated.Count > 0
                                    && (qnnDplySampleInfoToBeUpdated.Count % saveEveryNSamples == 0))
                                {
                                    //We save changes to the dlsi as we go through the loop
                                    //but not one row at a time as thats inefficient, instead we update a batch every so often
                                    await qnnDplySampleInfoModel.UpdateAsync(qnnDplySampleInfoToBeUpdated);
                                    qnnDplySampleInfoToBeUpdated.Clear();
                                }
                            }

                            if (isDebugLoggingEnabled && count % 100 == 0)
                            {
                                string zipLength = "NA";
                                if(MergeFileType.ZippedPdfs==mergeTypeInUse)
                                {
                                    try 
                                        { zipLength = mailMergeZipStream.Length.ToString(); }
                                    catch (Exception) 
                                        { zipLength = "Unknown"; }
                                }
                                
                                logger.LogDebug("Run for qnnDplyMsgId={0} is in progress, count={1}, zip length={2}", qnnDplyMsgId, count, zipLength);
                            }

                        } //end foreach listSampleId
                        //
                        //End of main loop - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        //



                        if (qnnDplySampleInfoToBeUpdated.Count > 0)
                        {
                            //Save any remaining updated dlsi that weren't already saved during the loop
                            await qnnDplySampleInfoModel.UpdateAsync(qnnDplySampleInfoToBeUpdated);
                            qnnDplySampleInfoToBeUpdated = null;
                        }

                        if (isDebugLoggingEnabled)
                        {
                            logger.LogDebug("Completing run for qnnDplyMsgId={0}, final count={1}", qnnDplyMsgId, count);
                        }

                        //Finish up the zip or pdf and store it in the database
                        if (GenerateMailMerge)
                        {
                            var properties = new Dictionary<string, string>();
                            string token; //to identify the file in dwUploadedFiles
                            switch (mergeTypeInUse)
                            {
                                case MergeFileType.ArchivedFolder:
                                    htmlToPdfConverter = null;
                                    if (isDebugLoggingEnabled)
                                        logger.LogDebug("Archiving folder {0} for qnnDplyMsgId={1}", archiveFolderPath, qnnDplyMsgId);
                                    //TODO - is is possible to not block the thread and somehow await this?
                                    string archiveFolderNameWithoutPath = $"{qnnDplyMsgId}";
                                    string archivePath = ArchiveWithExternalTool(archiveFolderNameWithoutPath);
                                    using (FileStream archiveStream = File.OpenRead(archivePath))
                                    {
                                        string dbFileName = $"{qnnDplyMsgId}.{MailMergeArchivedFolderExtension}";
                                        string contentType = FileUtils.GuessContentType(dbFileName);
                                        token = await SaveFileToDatabase(dbFileName, archiveStream, contentType);
                                    }
                                    File.Delete(archivePath); //20231018 - new behaviour, cleanup temp file immediately
                                    break;

                                case MergeFileType.ZippedPdfs:
                                    htmlToPdfConverter = null; //Can be garbage collected already. Thank you for your service!
                                    
                                    //We must Dispose() the zip now to finish up writing the archive to our memory stream
                                    mailMergeZipArchive.Dispose();
                                    mailMergeZipArchive = null;
                                    //Copy zip file into the db (dwUploadedFiles)
                                    if (isDebugLoggingEnabled)
                                        logger.LogDebug("Writing completed zip stream to db for qnnDplyMsgId={0}, size={1}", qnnDplyMsgId, mailMergeZipStream.Length);
                                    mailMergeZipStream.Position = 0;
                                    token = await SaveFileToDatabase($"{qnnDplyMsgId}.zip", mailMergeZipStream, Constants.ContentTypes.ZipFileType);
                                    mailMergeZipStream.Dispose();
                                    mailMergeZipStream = null;
                                    break;

                                case MergeFileType.SinglePdf:
                                    using (MemoryStream savedPdfStream = new MemoryStream())
                                    {
                                        //Write the pdf to the stream, need to save and close it first
                                        byte[] pdf = pdfDocument.Save();
                                        pdfDocument.Close();
                                        savedPdfStream.Write(pdf);
                                        pdfDocument = null; //can GC already

                                        if (isDebugLoggingEnabled)
                                            logger.LogDebug("Writing completed pdf stream to db for qnnDplyMsgId={0}", qnnDplyMsgId);
                                        savedPdfStream.Position = 0;
                                        token = await SaveFileToDatabase($"{qnnDplyMsgId}.pdf", savedPdfStream, Constants.ContentTypes.PdfFileType);
                                    }
                                    break;

                                default:
                                    throw new NotImplementedException();
                            }//end switch MailMergeType

                            //Update the deployment message entity to link the newly persisted file
                            DynamicEntity qnnDplyMsg = await RetrieveQnnDplyMsgAsync(qnnDplyMsgId);
                            qnnDplyMsg[Constants.FieldName.MergeOutputToken] = token;
                            qnnDplyMsg[Constants.FieldName.MergeDone] = true;
                            qnnDplyMsg[Constants.FieldName.UpdatedBy] = userId;
                            qnnDplyMsg[Constants.FieldName.UpdatedDate] = DateTime.Now;
                            if (isDebugLoggingEnabled)
                                logger.LogDebug("Updating QNN_DPLY_MSG for qnnDplyMsgId={0}", qnnDplyMsgId);
                            await qnnDplyMsgModel.UpdateSingleAsync(qnnDplyMsg);
                        } //end if GenerateMailMerge (for finalising the mail merge document or file)
                    } //end if GenerateEmail or GenerateMailMerge

                    if (GenerateProfile && listSampleIds.Count > 0)
                    {
                        await GenerateProfileCsv(listSampleIds, qnnDply, qnnDplyMsgId);
                    }
                } //end of streams try block
                finally
                {
                    //Finally block to close disposables in case of unexpected termination.
                    //In normal case most will already be closed by logic. We didn't use 'using' because these
                    //objects are only created if the GenerateMailMerge option is in use.
                    //Not all of these refereces will be non-null but DisposeAndContinue will check that. 
                    DisposeWithCatch(mailMergeZipArchive);
                    DisposeWithCatch(mailMergeZipStream);
                    DisposeWithCatch(mailer);
                    if (pdfDocument != null) pdfDocument.Close();
                }

                long end = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
                long durationMilliseconds = end - start;
                long averagePerSample = durationMilliseconds / listSampleIds.Count;
                long durationMinutes = ConversionUtils.ToMinutesRoundedUp(durationMilliseconds);
                if(isTraceLoggingEnabled)
                {
                    logger.LogTrace("Duration of run for qnnDplyMsgId={0} was {1} milliseconds", qnnDplyMsgId, durationMilliseconds);
                }
                if(logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation("Successful run for qnnDplyMsgId={0} in approximately {1} minutes, sampleCount={2}, average time per sample={3} milliseconds", qnnDplyMsgId, durationMinutes, sampleCount, averagePerSample);
                }
                
                return true; //success!
            }
            catch (InternalError error)
            {   
                logger.LogError("Internal error in mail merge for for qnnDplyMsgId={0}, message={1}", qnnDplyMsgId,error.Message);
                return false;
            }
            catch (Exception e)
            {
                logger.LogError(e, "Unexpected exception in mail merge for for qnnDplyMsgId={0}", qnnDplyMsgId);
                return false;
            }
        }

        /// <summary>
        /// Try to dispose the disposable but always return even if it fails.
        /// Will try to log any exceptions it catches and returns even if that logging itself throws an exception.
        /// </summary>
        /// <param name="disposable">the thing to dispose (if null then is a no-op and true is returned)</param>
        /// <returns>true if dispose no exception caught</returns>
        private bool DisposeWithCatch(IDisposable disposable)
        {
            try
            {
                if(disposable != null) disposable.Dispose();
                return true;
            }
            catch(Exception e)
            {
                try
                {
                    logger.LogError(e, "Caught exception disposing a disposable");
                }
                catch(Exception) { } //If we can't even log it then we've done all we can here. Move on already
                return false;
            }
        }

        /// <summary>
        /// Try to determine a filename based on UID but fallback to using the dlsi if it looks like the
        /// UID might not be valid as a filename. This is for use determining the filename of individual
        /// pdfs in a zipped mail merge.
        /// </summary>
        /// <param name="vSpListSampleInfo"></param>
        /// <returns>filename</returns>
        private string GetZippedPdfFileName(DynamicEntity vSpListSampleInfo)
        {
            string filename = (string)vSpListSampleInfo[Constants.FieldName.UID];
            if (validPdfFilenameRegex.IsMatch(filename))
            {
                return filename + ".pdf";
            }
            else
            {
                return vSpListSampleInfo.GetId().ToString() + ".pdf";
            }
        }

        private async Task<DynamicEntity> RetrieveQnnDplyMsgAsync(Guid dplyMsgId)
        {
            Filter byDplyMsgId = Filter.And.Equal(dplyMsgId, Constants.FieldName.Id);
            var qnnDplyMsg = (await qnnDplyMsgModel.GetAsync(byDplyMsgId)).FirstOrDefault();
            if (qnnDplyMsg == null)
            {
                throw new InternalError($"QNN_DPLY_MSG '{dplyMsgId}' does not exist");
            }
            return qnnDplyMsg;
        }

        /// <summary>
        /// Create a QNN_DPLY_MESSAGE_SAMPLE for each sample in the deployment that has the specified status
        /// and filter with tags.
        /// Return their Id values.
        /// </summary>
        /// <param name="dplyMsgId">Guid of the dplyMsgId</param>
        /// <param name="listQnnStatusId">Guid of the Status to find</param>
        /// <param name="tagsFilter">Tags filter control</param>
        /// <param name="listTags">List of tags to filter</param>
        /// <returns>List of Sample Ids</returns>
        private async Task<List<Guid>> PrepareQnnDplyMessageSamplesAsync(Guid dplyMsgId, List<Guid> listQnnStatusId)
        {
            try
            {
                if (listQnnStatusId == null || listQnnStatusId.Count == 0) throw new ArgumentException("listQnnStatusId may not be empty");
                if (Guid.Empty.Equals(dplyMsgId)) throw new ArgumentException("dplyMsgId may not be empty");

                //Find all the samples in the deployment that have the specified status
                Filter byStatusAndDplyId = Filter.And
                    .Equal(qnnDplyId, Constants.FieldName.DplyId)
                    .In(listQnnStatusId, Constants.FieldName.Status);

                List<DynamicEntity> dplySampleInfoEntities = await qnnDplySampleInfoModel.GetAsync(byStatusAndDplyId);
                if (dplySampleInfoEntities.Count == 0) return null;
                List<Guid> listSampleIds = dplySampleInfoEntities.Select(e => (Guid)e[Constants.FieldName.ListSampleId]).Distinct().ToList();

                //Only prepare whoever is Active at ListSampleRecord
                //Fetch the active list samples in batchs to avoid excessively large IN statements (SQL2017 limits to 2100)
                List<DynamicEntity> activeListSampleRecord = new List<DynamicEntity>(listSampleIds.Count);
                const int takeIdQty = 1000; //number to query in one go, I'll use 1k for now because a 2k long query just seems kinda heavy, can reconsider later
                for (int i = 0; i < listSampleIds.Count; i = i + takeIdQty)
                {
                    List<Guid> idBatch = listSampleIds.Skip(i).Take(takeIdQty).ToList();
                    if(idBatch.Any())
                    {
                        Filter byActiveInIdBatch = Filter.And.Equal(true, Constants.FieldName.ActiveYN).In(idBatch, Constants.FieldName.Id);
                        List<DynamicEntity> activeSampleBatch = await qnnListSampleModel.GetAsync(byActiveInIdBatch);
                        activeListSampleRecord.AddRange(activeSampleBatch);
                    }
                }
                if (!activeListSampleRecord.Any()) return null;

                List<Guid> activeListSampleIds = activeListSampleRecord.Select(e => (Guid)e[Constants.FieldName.Id]).Distinct().ToList();

                //Create a new QNN_DPLY_MESSAGE_SAMPLE for each sample (add to list first, we will update in bulk)
                List<DynamicEntity> dplyMessageSampleList = new List<DynamicEntity>();
                foreach (DynamicEntity qnnDplySampleInfo in dplySampleInfoEntities)
                {
                    //TODO - shouldnt new instance be created from ** qnnDplyMessageSampleModel ** ????
                    //nb: I have checked and it was already (incorrectly?) using QNN_DPLY model before the ProfileMailMerger refactorings
                    //    (Doesn't seem to hurt though)
                    Guid listSampleId = (Guid)qnnDplySampleInfo[Constants.FieldName.ListSampleId];
                    //Only prepare whoever is Active at ListSampleRecord
                    if (activeListSampleIds.Contains(listSampleId))
                    {
                        DynamicEntity qnnDplyMessageSample = await qnnDplyModel.NewAsync();
                        qnnDplyMessageSample[Constants.FieldName.Id] = Guid.NewGuid();
                        qnnDplyMessageSample[Constants.FieldName.DplyMsgId] = dplyMsgId;
                        qnnDplyMessageSample[Constants.FieldName.CreatedDate] = DateTime.Now;
                        qnnDplyMessageSample[Constants.FieldName.ListSampleId] = listSampleId;
                        dplyMessageSampleList.Add(qnnDplyMessageSample);
                    }
                }

                //Save the newly created QNN_DPLY_MESSAGE_SAMPLE entities
                const int takeSampleQty = 500; //number to process in one go
                if (dplyMessageSampleList.Count > int.MaxValue - takeSampleQty) throw new Exception("");
                for (int i = 0; i < dplyMessageSampleList.Count; i = i + takeSampleQty)
                {
                    var entities = dplyMessageSampleList.Skip(i).Take(takeSampleQty).Cast<dynamic>().ToList();
                    await qnnDplyMessageSampleModel.UpdateAsync(entities);
                }

                return activeListSampleIds;
            }
            catch(Exception e)
            {
                throw new Exception("Unable to prepare QNN_DPLY_MESSAGE_SAMPLE records", e);
            }
        }

        /// <summary>
        /// Create the token lookup table that will be used for token substitution in the message for a specific sample.
        /// The tokens include the standard mail merge tokens, and depending on configuration of the mail merger
        /// may also include the values from list sample properties.
        /// </summary>
        /// <param name="qnnDply">the QNN_DPLY entity</param>
        /// <param name="qnnDplySampleInfo">the QNN_DPLY_SAMPLE_INFO entity</param>
        /// <param name="vSpListSampleInfo">the vSpListSampleInfo view entity</param>
        /// <param name="qnnListSample">the QNN_LIST_SAMPLE entity</param>
        /// <param name="aliasByQnnListPropId">lookup table of QNN_LIST_PROP Id to Alias</param>
        /// <param name="sortedQnnQnnFormList">sorted list of QNN_QNN_FORM entities for this deployment</param>
        /// <returns></returns>
        /// <exception cref="ArgumentException"></exception>
        /// <exception cref="InternalError"></exception>
        private async Task<Dictionary<string, string>> PopulateParameters(
            DynamicEntity qnnDply,
            SampleEntityInformation sampleInfo,
            DynamicEntity vSpListSampleInfo,
            Dictionary<Guid, string> aliasByQnnListPropId,
            List<DynamicEntity> sortedQnnQnnFormList)
        {
            DynamicEntity qnnListSample = sampleInfo.ListSample;
            DynamicEntity qnnDplySampleInfo = sampleInfo.DplySampleInfo;
            DynamicEntity qnnSampleAddress = sampleInfo.SampleAddress;

            Guid listSampleId = (Guid)qnnListSample[Constants.FieldName.Id];
            Dictionary<string, string> parameters = new Dictionary<string, string>();

            string dlsi = vSpListSampleInfo.GetId().ToString();

            DateTime? dueDate = (DateTime?)vSpListSampleInfo[Constants.FieldName.DueDate];

            string surveyUrl = null;
            if(populateSurveyUrl)
            {
                string formNames = (string)vSpListSampleInfo[Constants.FieldName.FormNames];
                string languages = (string)vSpListSampleInfo[Constants.FieldName.Languages];
                surveyUrl = GenSurveyUrl(internetDomainAuthority, dlsi, formNames, languages);
                parameters.Add(Tokens.SurveyUrl, surveyUrl);
            }

            parameters.Add(Tokens.DplySampleInfoId, dlsi);
            parameters.Add(Tokens.DplyName, (string)qnnDply[Constants.FieldName.Name]);
            parameters.Add(Tokens.DplyQnn, (string)qnnDply[Constants.FieldName.QnnId+'_'+Constants.FieldName.Title]); //"QnnId_Title"
            parameters.Add(Tokens.DplyList, (string)qnnDply[Constants.FieldName.ListId+'_'+Constants.FieldName.Name]); //"ListId_Name"
            parameters.Add(Tokens.Name, (string)qnnListSample[Constants.FieldName.SampleId+'_'+Constants.FieldName.Name]); //"SampleId_Name"
            //parameters.Add(Tokens.Email, (string)qnnListSample[Constants.FieldName.SampleId+'_'+Constants.FieldName.Email]); //"SampleId_Email"
            parameters.Add(Tokens.UID, (string)qnnListSample[Constants.FieldName.SampleId+'_'+Constants.FieldName.UID]); //"SampleId_UID"
            parameters.Add(Tokens.UIDPeer, (string)qnnListSample[Constants.FieldName.SamplePeerId+'_'+Constants.FieldName.UID]); //"SamplePeerId_UID"
            parameters.Add(Tokens.ActiveYN, (bool)qnnListSample[Constants.FieldName.ActiveYN] ? "Active" : "Disabled");
            string plaintextPassword = EncryptionHelper.DecryptStr((string)qnnListSample[Constants.FieldName.SampleId + '_' + Constants.FieldName.Pwd], Constants.LoginKey, Constants.LoginIv);
            parameters.Add(Tokens.Password,plaintextPassword); //"SampleId_Pwd"
            parameters.Add(Tokens.Date, DateTime.Now.ToString(TOKEN_DATE_FORMAT)); //TODO add support for other formats
            if (dueDate != null)
            {
                //TODO - check which are actually in use and only populate those each run
                parameters.Add(Tokens.DueDate, ((DateTime)dueDate).ToString(TOKEN_DATE_FORMAT, invariantFormat));
                parameters.Add(Tokens.DueDateNumeric, ((DateTime)dueDate).ToString(TOKEN_DATE_FORMAT_NUMERIC, invariantFormat));
                parameters.Add(Tokens.DueDateISO, ((DateTime)dueDate).ToString(TOKEN_DATE_FORMAT_ISO, invariantFormat));
                parameters.Add(Tokens.DueDateChinese, ((DateTime)dueDate).ToString(TOKEN_DATE_FORMAT_CHINESE, chineseFormat));
                parameters.Add(Tokens.DueDateMalay, ((DateTime)dueDate).ToString(TOKEN_DATE_FORMAT_MALAY, malayFormat));
                parameters.Add(Tokens.DueDateTamil, ((DateTime)dueDate).ToString(TOKEN_DATE_FORMAT_TAMIL, tamilFormat));
            }
            parameters.Add(Tokens.PAGEBREAK, PAGE_BREAK_DIV);
            parameters.Add(Tokens.SurveyName, (string)qnnDply[Constants.FieldName.SurveyName]);

            if(qnnSampleAddress==null)
            {
                //In certain cases it might be that the QNN_SAMPLE_ADDRESS is missing (due to error etc) in which case we will
                //use blanks for these core address properties in the mail merges
                parameters.Add(Tokens.Legacy_Email, "");
                parameters.Add(Tokens.ToEmails, "");
                parameters.Add(Tokens.CcEmails, "");
                parameters.Add(Tokens.AddressLine1, "");
                parameters.Add(Tokens.AddressLine2, "");
                parameters.Add(Tokens.AddressLine3, "");
            }
            else
            {
                //TODO - should we normalise the emails? (but means using Email.SplitAddresses, catching any ex, and then Joining again)
                //       for now we will just use the raw values
                string commaDelimitedToEmails = (string)qnnSampleAddress[Constants.FieldName.ToEmails];
                string commaDelimitedCcEmails = (string)qnnSampleAddress[Constants.FieldName.CcEmails];
                parameters.Add(Tokens.Legacy_Email, commaDelimitedToEmails);
                parameters.Add(Tokens.ToEmails, commaDelimitedToEmails);
                parameters.Add(Tokens.CcEmails, commaDelimitedCcEmails);
                parameters.Add(Tokens.AddressLine1, (string)qnnSampleAddress[Constants.FieldName.AddressLine1]);
                parameters.Add(Tokens.AddressLine2, (string)qnnSampleAddress[Constants.FieldName.AddressLine2]);
                parameters.Add(Tokens.AddressLine3, (string)qnnSampleAddress[Constants.FieldName.AddressLine3]);
            }

            bool provideDirectAccessUrlTokens 
                = (populateSurveyQrLocationForLanguages 
                || populateOtherSurveyLocationForLanguages
                || populateInvitation);
            if (provideDirectAccessUrlTokens)
            {
                byte[] dacKey = EncryptionHelper.Bytes(Constants.LoginKey);
                byte[] dacIv = ((Guid)qnnDplySampleInfo[Constants.FieldName.Id]).ToByteArray();
                AccessCode directAccessCode 
                    = AccessCode.FromEncryptedString((string)qnnDplySampleInfo[Constants.FieldName.DirectAccessCode], dacKey, dacIv);
                
                int dlsiNumberId = (int)qnnDplySampleInfo[Constants.FieldName.NumberId];
                //Add a token for qr code + location or url for each individual form/language
                if(IsUsingFormSpecificTokens())
                {
                    for (short formIndex = 0; formIndex < sortedQnnQnnFormList.Count; formIndex++)
                    {
                        DynamicEntity qnnQnnForm = sortedQnnQnnFormList[formIndex];
                        string formName = (string)qnnQnnForm[Constants.FieldName.Name];
                        string language = (string)qnnQnnForm[Constants.FieldName.Language];
                        int qnnQnnFormNumberId = (int)qnnQnnForm[Constants.FieldName.NumberId];
                        string url = InvitationOrDirectAccessUrl(
                            internetDomainAuthority,
                            dlsiNumberId,
                            directAccessCode,
                            qnnQnnFormNumberId);

                        if (populateSurveyQrLocationForLanguages)
                        {
                            string surveyQRLinkHtml = string.IsNullOrWhiteSpace(url) ? "" : GenQRCodeAndUrlText(url);
                            parameters[Tokens.SurveyQRLocation_PREFIX + language] = surveyQRLinkHtml;
                            parameters[Tokens.SurveyQRLocation_PREFIX + formName] = surveyQRLinkHtml;
                        }

                        if (populateOtherSurveyLocationForLanguages)
                        {
                            //SurveyURLLocation_xxx just renders the url itself. More useful if using the raw html body option 
                            //and user is doing their own html
                            string rawUrl = string.IsNullOrWhiteSpace(url) ? "" : url;
                            parameters[Tokens.SurveyURLLocation_PREFIX + language] = rawUrl;
                            parameters[Tokens.SurveyURLLocation_PREFIX + formName] = rawUrl;

                            //SurveyLinkLocation_xxx renders html hyperlink. Will just use the url as the text of the link as well.
                            //Useful in basic emails to get a direct link to survey
                            string surveySimpleLinkHtml = string.IsNullOrWhiteSpace(url) ? "" : GenSimpleAnchor(url: url, linkText: url);
                            parameters[Tokens.SurveyLinkLocation_PREFIX + language] = surveySimpleLinkHtml;
                            parameters[Tokens.SurveyLinkLocation_PREFIX + formName] = surveySimpleLinkHtml;
                        }
                    } // end form loop
                }
                
                if(populateInvitation)
                {
                    string invitationUrl = InvitationOrDirectAccessUrl(internetDomainAuthority, dlsiNumberId, directAccessCode);
                    parameters.Add(Tokens.InvitationUrl, invitationUrl);
                    string invitationLink = string.IsNullOrWhiteSpace(invitationUrl) ? "" : GenSimpleAnchor(url: invitationUrl, linkText: invitationUrl);
                    parameters.Add(Tokens.InvitationLink, invitationLink);
                }
            }

            if (ExposeListSampleProps)
            {
                if (aliasByQnnListPropId == null) throw new ArgumentException(nameof(aliasByQnnListPropId));

                //Make available all the list sample properties for this sample as replacement tokens
                //nb: this would override any of the above tokens having the same name
                Guid listId = (Guid)qnnDply[Constants.FieldName.ListId];
                Filter bySampleAndList = Filter.And
                    .Equal(listId, Constants.FieldName.ListId)
                    .Equal(listSampleId, Constants.FieldName.ListSampleId);
                List<DynamicEntity> props = await qnnListSamplePropModel.GetAsync(bySampleAndList);
                foreach (var listSampleProp in props)
                {
                    string alias = aliasByQnnListPropId[(Guid)listSampleProp[Constants.FieldName.ListPropId]];
                    string value = (string)listSampleProp[Constants.FieldName.PropValue]; 
                    parameters[alias] = value;
                }
            }
            // Skip DelegateCode token if qnnDply RequireAccessCode is false
            if ((bool)qnnDply[Constants.FieldName.RequireAccessCode])
            {
                string delegationCode = "";
                try
                {
                    delegationCode = EncryptionHelper.DecryptStr((string)qnnDplySampleInfo[Constants.FieldName.DelegationCode], Constants.LoginKey, Constants.LoginIv);
                }
                catch
                {
                    throw new InternalError($"QNN_DPLY_SAMPLE_INFO '{dlsi}' delegationCode can not decrypt");
                }
                parameters.Add(Tokens.DelegationCode, delegationCode);
            }

            return parameters;
        }

        private class SampleEntityInformation
        {
            //qnnListSample, vSpListSampleInfo, qnnDplySampleInfo
            /// <summary>
            /// QNN_LIST_SAMPLE
            /// </summary>
            public DynamicEntity ListSample { get; private set; }

            /// <summary>
            /// vSP_ListSampleInfo
            /// </summary>
            public DynamicEntity ListSampleInfo { get; private set; }

            /// <summary>
            /// QNN_DPLY_SAMPLE_INFO
            /// </summary>
            public DynamicEntity DplySampleInfo { get; private set; }

            /// <summary>
            /// QNN_SAMPLE_ADDRESS
            /// </summary>
            public DynamicEntity SampleAddress { get; private set; }

            public SampleEntityInformation(
                DynamicEntity qnnListSample,
                DynamicEntity vSPListSampleInfo,
                DynamicEntity qnnDplySampleInfo,
                DynamicEntity qnnSampleAddress)
            {
                this.ListSample = qnnListSample ?? throw new ArgumentNullException(nameof(qnnListSample));
                this.ListSampleInfo = vSPListSampleInfo ?? throw new ArgumentNullException(nameof(vSPListSampleInfo));
                this.DplySampleInfo = qnnDplySampleInfo ?? throw new ArgumentNullException(nameof(qnnDplySampleInfo));
                this.SampleAddress = qnnSampleAddress ?? throw new ArgumentNullException(nameof(qnnSampleAddress)); //hmm?
            }
        }

        /// <summary>
        /// Returns entities containing information about the specified sample's participation in the survey.
        /// Specifically: the QNN_LIST_SAMPLE and vSP_LIST_SAMPLE_INFO for the specified sample in the deployment.
        /// </summary>
        /// <param name="qnnDplyId">Id of the QNN_DPLY</param>
        /// <param name="listSampleId">Id of the QNN_LIST_SAMPLE</param>
        /// <returns>qnnListSample, vSpListSampleInfo</returns>
        private async Task<SampleEntityInformation> RetrieveSampleEntitiesAsync(Guid qnnDplyId, Guid listSampleId)
        {
            //QNN_LIST_SAMPLE
            //nb: as per pre-refactoring behaviour this doesnt fail if its marked as deleted
            Filter byListSampleId = Filter.And.Equal(listSampleId, Constants.FieldName.Id);
            DynamicEntity qnnListSample
                = (await qnnListSampleModel.GetAsync(byListSampleId)).FirstOrDefault();
            if (qnnListSample == null)
            {
                throw new InternalError($"QNN_LIST_SAMPLE '{listSampleId}' does not exist");
            }

            //QNN_DPLY_SAMPLE_INFO & vSP_LIST_SAMPLE_INFO (sadly we need to fetch both of them instead of just view)
            Filter byListSampleIdAndDplyId = Filter.And
                .Equal(listSampleId, Constants.FieldName.ListSampleId)
                .Equal(qnnDplyId, Constants.FieldName.DplyId);
            DynamicEntity qnnDplySampleInfo
                = (await qnnDplySampleInfoModel.GetAsync(byListSampleIdAndDplyId)).FirstOrDefault();
            if (qnnDplySampleInfo == null)
            {
                throw new InternalError($"QNN_DPLY_SAMPLE_INFO '{qnnDplyId}' does not exist");
            }
            DynamicEntity vSpListSampleInfo
                    = (await vSpListSampleInfoModel.GetAsync(byListSampleIdAndDplyId)).FirstOrDefault();
            if (qnnDplySampleInfo == null)
            {
                //This shouldn't happen if the table row was found, so when it does happen first thing to check is the view definition
                //(Since we aren't in a transaction its technically possible for it to have been deleted between the two queries 
                //but a broken view definition is a far more likely reason for seeing this in logs)
                throw new InternalError($"QNN_DPLY_SAMPLE_INFO '{qnnDplyId}' exists but the equivalent vSP_ListSampleInfo row is missing");
            }

            Guid sampleId = (Guid)qnnListSample[Constants.FieldName.SampleId];
            Guid structDivisionForAddress = (Guid)vSpListSampleInfo[Constants.FieldName.StructDivisionId]; //view gets it from QNN_DPLY
            DynamicEntity qnnSampleAddress
                = await InternetAccountApplication.GetSampleAddressAsync(sampleId, structDivisionForAddress, qnnSampleAddressModel);
            if(qnnSampleAddress==null && logger.IsEnabled(LogLevel.Warning))
            {
                //It shouldn't be null, but may be due to import errors or such like. In this case we don't fail fast but do log a warning
                logger.LogWarning(nameof(RetrieveSampleEntitiesAsync) + " - missing {0} record for sampleId={1}, structDivisionId={2}",
                    qnnSampleAddressModel.Name, sampleId, structDivisionForAddress);
            }
            return new SampleEntityInformation(qnnListSample, vSpListSampleInfo, qnnDplySampleInfo, qnnSampleAddress);
        }

        /// <summary>
        /// Populate the placeholder tokens in the subject and template with values from parameters disctionary.
        /// </summary>
        /// <param name="parameters">token values</param>
        /// <returns>subjectCopy, bodyCopy</returns>
        private (string, string) FillTemplate(Dictionary<string, string> parameters)
        {
            //TODO - this technique for doing the replacements doesnt scale well for big templates so would be better replaced
            //with some kind of pull mechanism that parses the template (see RAMS example)
            //and requests the values it needs rather than having them all iterated and pushed in
            //this would also make it easier to be case-insensitive if we want that.
            //The above is even more the case now that I've added yet another half dozen tokens for the addressbook feature! -20230510AH
            var subjectCopy = string.IsNullOrEmpty(EmailSubject) ? null : new StringBuilder(EmailSubject); //subject might be null
            var bodyCopy = new StringBuilder(template); //nb: template not allowed to be null
            foreach (var p in parameters)
            {
                var key = $"{{{p.Key}}}";

                if (subjectCopy != null)
                {
                    subjectCopy.Replace(key, p.Value);
                }

                bodyCopy.Replace(key, p.Value);
            }
            return (subjectCopy?.ToString(), bodyCopy.ToString());
        }

        private async Task GenerateProfileCsv(
            List<Guid> listSampleIds,
            DynamicEntity qnnDply,
            Guid dplyMsgId)
        {
            if (listSampleIds.Count == 0) return; //Nothing to do here

            if (logger.IsEnabled(LogLevel.Debug))
                logger.LogDebug("Generating profile for qnnDplyMsgId={0}, sample count={1}", dplyMsgId, listSampleIds.Count);

            List<Dictionary<string, object>> items = await spSP_GetListSampleProfile.GetForProfile((Guid)qnnDply["ListId"], listSampleIds);

            if (items != null && items.Any())
            {
                var expandoObjects = items.Select(i => (dynamic)i.ToExpando()).Select(x =>
                {
                    x.PASSWORD = EncryptionHelper.DecryptStr(x.PASSWORD, Constants.LoginKey, Constants.LoginIv);
                    return x;
                });
                using (var csvFileData = new MemoryStream())
                {
                    using (var writer = new StreamWriter(csvFileData))
                    {
                        //TODO - consider using InvariantCulture here. See: https://github.com/JoshClose/CsvHelper/issues/1441
                        using (CsvWriter csv = new CsvWriter(writer, CultureInfo.CurrentCulture))
                        {
                            //Save CSV to database
                            csv.WriteRecords(expandoObjects);
                            csv.Flush();
                            writer.Flush(); //important to flush, or else streamTemp length can be anything
                            csvFileData.Seek(0, SeekOrigin.Begin);
                            string dplyName = (string)qnnDply[Constants.FieldName.Name];
                            string filename = $"{dplyName} List User Profiles.csv"; //TODO - are dply names always filename friendly?
                            string token = await SaveFileToDatabase(filename, csvFileData, Constants.ContentTypes.CsvFileType);

                            //save token identifying the CSV to QNN_DPLY_MSG record
                            DynamicEntity qnnDplyMsg = await RetrieveQnnDplyMsgAsync(dplyMsgId);
                            var dyObjectsList = new List<dynamic>();
                            qnnDplyMsg[Constants.FieldName.GenerateProfileOutputToken] = token;
                            qnnDplyMsg[Constants.FieldName.GenerateProfileDone] = true;
                            qnnDplyMsg[Constants.FieldName.UpdatedBy] = userId;
                            qnnDplyMsg[Constants.FieldName.UpdatedDate] = DateTime.Now;
                            await qnnDplyMsgModel.UpdateSingleAsync(qnnDplyMsg);
                        } // end using csv
                    } // end using write
                } //end using ms
            } //end if any items
        }

        private Task<string> SaveFileToDatabase(string name, Stream data, string contentType)
        {
            var properties = new Dictionary<string, string>();
            properties.Add(Constants.FileProperties.Name, name);
            properties.Add(Constants.FileProperties.ContentType, contentType);
            return CloverRuntime.ContentProvider.AddAsync(data, properties);
        }

        /// <summary>
        /// Instantiate a Winnovate PdfConverter with settings settings appropriate for our mail merge.
        /// For use when generating individual PDFs to be zipped.
        /// </summary>
        /// <returns></returns>
        private PdfConverter CreatePdfConverter()
        {
            PdfConverter htmlToPdfConverter = HtmlToPdfStream.NewConverterInstance();
            htmlToPdfConverter.ConversionDelay = Winnovative_ConversionDelay;
            htmlToPdfConverter.PdfDocumentOptions.CompressCrossReference = Winnovative_CompressCrossReference;
            htmlToPdfConverter.PdfDocumentOptions.EmbedFonts = Winnovative_EmbedFonts;
            htmlToPdfConverter.PdfDocumentOptions.ImagesScalingEnabled = Winnovative_ImageScalingEnabled;
            htmlToPdfConverter.PdfDocumentOptions.JpegCompressionEnabled = Winnovative_JpegCompressionEnabled;
            htmlToPdfConverter.PdfDocumentOptions.JpegCompressionLevel = Winnovative_JpegCompressionLevel;
            return htmlToPdfConverter;
        }

        /// <summary>
        /// Instantiate a Winnovate Document (for use when assembling a single pdf from multiple mails)
        /// and initialise with settings appropriate for our mail merge.
        /// </summary>
        /// <returns>Document</returns>
        private Document CreatePdfDocument()
        {
            //TODO - although this + CreateHtmlToPdfElement should set same compression settings as would be 
            //       used in CreatePdfConverter I note with no compression we still seem to get some jpeg artifacts
            //       on images which we don't get with ZippedPdfs. Need to troubleshoot this.
            Document pdfDocument = new Document();
            pdfDocument.LicenseKey = Constants.WINNOVATIVE_LICENSE_KEY;
            pdfDocument.CompressCrossReference = Winnovative_CompressCrossReference;
            //n.b no option to embed fonts or image scaling here, these are set in CreateHtmlToPdfElement instead
            pdfDocument.CompressionLevel = Winnovative_CompressionLevel;
            pdfDocument.JpegCompressionEnabled = Winnovative_JpegCompressionEnabled;
            pdfDocument.JpegCompressionLevel = Winnovative_JpegCompressionLevel;
            return pdfDocument;
        }

        /// <summary>
        /// Instantiate a Winnovate HtmlToPdfElement (for use when converting individual mails when generating single file pdf)
        /// and initialise with settings appropriate for our mail merge.
        /// </summary>
        /// <returns>Document</returns>
        private HtmlToPdfElement CreateHtmlToPdfElement(string documentContent)
        {
            HtmlToPdfElement element
                = new HtmlToPdfElement(documentContent, UrlBase, InternalDocLinksUrl);
            element.ConversionDelay = Winnovative_ConversionDelay;
            element.EmbedFonts = Winnovative_EmbedFonts;
            element.ImagesScalingEnabled = Winnovative_ImageScalingEnabled;
            return element;
        }

        /// <summary>
        /// Retrieves a lookup table of QNN_LIST_PROP Id to Alias for the specified QNN_LIST
        /// </summary>
        /// <param name="listId"></param>
        /// <returns></returns>
        private async Task<Dictionary<Guid, string>> PreparePropAliasLookup(Guid listId)
        {
            Filter byListId = Filter.And.Equal(listId, Constants.FieldName.ListId);
            List<DynamicEntity> qnnListProps = await qnnListPropModel.GetAsync(byListId);
            Dictionary<Guid, string> aliasByQnnListPropId 
                = qnnListProps.ToDictionary(e => (Guid)e[Constants.FieldName.Id], e => (string)e[Constants.FieldName.Alias]);
            return aliasByQnnListPropId; //warning: currently this is still case-sensitive
        }

        private static string GenSurveyUrl(string internetDomainAuthority, string dlsi, string formNames, string languages)
        {
            var urls = new StringBuilder("<br>");
            if (string.IsNullOrWhiteSpace(formNames) || string.IsNullOrWhiteSpace(languages)) return "";
            var formNameArray = formNames.Split("||");
            var languageArray = languages.Split("||");
            if (formNameArray.Length != languageArray.Length) return "";
            //there is an issue where user receive the email but unable to click on the link
            //thats why we include the hyperlink into the text so user have access to the link
            for (int i = 0; i < formNameArray.Length; i++)
            {
                string surveyUrl = $"{internetDomainAuthority}/form/{formNameArray[i]}/dlsi/{dlsi}"; //nb: constructor added the https
                urls.Append($"<a href=\"{surveyUrl}\">{languageArray[i]} - {surveyUrl}</a><br>");
            }
            return urls.ToString();
        }

        /// <summary>
        /// Generate an invitation link or short survey link that can be resolved and forwarded by TODO or GoSurvey in RespController
        /// on the internet side. (Will determine which to generate based on presence or absence of qnnQnnFormNumberId).
        /// An empty string is returned if the accessCode is not provided.
        /// </summary>
        private string InvitationOrDirectAccessUrl(
            string internetDomainAuthority,
            int qnnDplySampleInfoNumberId,
            AccessCode accessCode,
            int? qnnQnnFormNumberId = null)
        {
            if (accessCode == null) return "";

            //We obfuscate the running number NumberId a little bit by xoring it with some junk (but the real security is the access code)
            int waxOn = accessCode.ToString().Select((c) => (int)c).Sum() + Constants.MagicNumber;
            int obfuscatedQnnDplySampleInfoNumberId = qnnDplySampleInfoNumberId ^ waxOn;
            string dlsiCode = AccessCode.EncodeLongAsString(obfuscatedQnnDplySampleInfoNumberId);

            if(qnnQnnFormNumberId == null)
            {   //Generate an invitation link (in)
                string shortUrl = $"{internetDomainAuthority}/in/{accessCode}/{dlsiCode}"; //constructor added the https
                return shortUrl;
            }
            else
            {
                //Generate a direct access link (go)
                string formCode = AccessCode.EncodeLongAsString((int)qnnQnnFormNumberId);
                string shortUrl = $"{internetDomainAuthority}/go/{accessCode}/{dlsiCode}/{formCode}"; //constructor added the https
                return shortUrl;
            }
        }

        private string GenQRCodeAndUrlText(string url)
        {
            StringBuilder html = new StringBuilder();
            string srcBase64 = QRCodeAsImgSrc(url, QRPixelsPerModule);
            html.Append($"<div style=\"display: inline-block; text-align: center;\">");
            html.Append($"<img alt=\"(QR Code)\" style=\"{QRImageStyle}\" src=\"{srcBase64}\" /><br>");
            if(QRTextEnabled)
            {
                html.Append($"<div style=\"{QRTextDivStyle}\"><a style=\"{QRTextStyle}\" href=\"{url}\">{url}</a></div>");
            }
            html.Append($"</div>");

            return html.ToString();
        }

        private string GenSimpleAnchor(string url, string linkText)
        {
            string html = $"<a  href=\"{url}\">{linkText}</a>";
            return html;
        }

        /// <summary>
        /// Generate a QR code as an html img src string using base64 data to encode the QR code
        /// </summary>
        /// <param name="code">string to encode in the QR code</param>
        /// <param name="pixelsPerModule">default is 4 pixels per square</param>
        /// <returns>img src string</returns>
        private string QRCodeAsImgSrc(string code, int pixelsPerModule)
        {
            byte[] pngBytes = QRCodeUtils.GenerateQrCodePng(code, pixelsPerModule);
            string pngBytesBase64 = Convert.ToBase64String(pngBytes);
            string src = "data:image/png;base64, " + pngBytesBase64;
            return src;
        }

        private string ArchiveWithExternalTool(string archiveFolderNameWithoutPath)
        {
            try
            {
                if (string.IsNullOrEmpty(archiveFolderNameWithoutPath))
                    throw new ArgumentException(nameof(archiveFolderNameWithoutPath));
                if (string.IsNullOrWhiteSpace(MailMergeArchivedFolderCommand))
                    throw new InvalidOperationException(nameof(MailMergeArchivedFolderCommand) + " not provided");
                if (string.IsNullOrWhiteSpace(MailMergeArchivedFolderExtension))
                    throw new InvalidOperationException(nameof(MailMergeArchivedFolderExtension) + " not provided");
                string executable = MailMergeArchivedFolderCommand;
                string arguments = MailMergeArchivedFolderCommandArguments ?? "";
                string archiveFileName = $"{archiveFolderNameWithoutPath}.{MailMergeArchivedFolderExtension}"; 
                arguments = arguments.Replace("{ArchiveName}", archiveFileName);
                arguments = arguments.Replace("{FolderName}", archiveFolderNameWithoutPath);
                logger.LogDebug(nameof(ArchiveWithExternalTool) + " - Tool FileName={0}, Arguments={1}", executable, arguments);
                using (Process process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = executable,
                        Arguments = arguments,
                        RedirectStandardInput = false,
                        RedirectStandardError = true,
                        UseShellExecute = false,
                        WorkingDirectory = MailMergeFolderPath, //When UseShellExecute==false WorkingDirectory applies to process that is started
                        RedirectStandardOutput = true,
                        CreateNoWindow = true
                    }
                })
                {
                    const int successCode = 0;
                    const int timeoutMs = 5 * 60000; //todo - make it configurable

                    process.Start();                    
                    bool exitedNormally = process.WaitForExit(timeoutMs);
                    //Im not sure if defaults to exitCode 0 if the process never exits? (it IS 0 for 7z.exe i (which never exits on my machine!))
                    int exitCode = process.ExitCode;
                    string stdout = process.StandardOutput.ReadToEnd();
                    logger.LogDebug(nameof(ArchiveWithExternalTool) + " - external tool exitedNormally={0}, exitCode={1}, stdout={2}", exitedNormally, exitCode, stdout);
                    if (!exitedNormally || exitCode != successCode)
                    {
                        string stderr = process.StandardError.ReadToEnd();
                        logger.LogError(nameof(ArchiveWithExternalTool) + " - external tool exitCode={0}, stderr={1}", exitCode, stdout);
                    }
                    if (exitedNormally)
                    {
                        if(exitCode != successCode)
                            throw new InternalError($"External tool returned error code {exitCode} for {executable} {arguments}");
                        string fullArchivePath = Path.GetFullPath(Path.Combine(MailMergeFolderPath, archiveFileName));
                        if (!File.Exists(fullArchivePath))
                        {
                            throw new InternalError($"External tool did not create expected file {fullArchivePath}");
                        }
                        else
                        {
                            //Having confirmed that the archive file was created we can cleanup the temporary folder with the pdfs now
                            string archiveFolderNameWithPath = Path.Combine(MailMergeFolderPath, archiveFolderNameWithoutPath);
                            Directory.Delete(archiveFolderNameWithPath, recursive: true);
                        }
                        return fullArchivePath;
                    }
                    else
                    {
                        throw new InternalError($"External tool did not exit within the allowed {timeoutMs} milliseconds");
                    }                    
                }
            }
            catch(InternalError)
            {
                throw;
            }
            catch(Exception e)
            {
                logger.LogDebug(e, nameof(ArchiveWithExternalTool) + " - unexpected exception preparing archive {0}", archiveFolderNameWithoutPath);
                throw new Exception($"Error preparing archive {archiveFolderNameWithoutPath} using the external tool", e);
            }            
        }

        /// <summary>
        /// Apply any template specific settings that are configured in the template text in a template options block.
        /// This needs to be called after the code using this mail merger has set default properties so the template
        /// options can overwrite these.
        /// </summary>
        public void ApplyOptionsFromTemplate()
        {
            bool isTraceLoggingEnabled = logger.IsEnabled(LogLevel.Trace);
            try
            {
                //extraction of the template block is naive, it just looks for the markers to find the block
                //without parsing html/xml and it doesn't actually care that this happens to be an html comment
                //so the spacing of the comment needs to follow our format explicitly
                templateOptionsApplied = true; //record that this method was called (Execute will check this)
                const string BEGIN_TEMPLATE_OPTIONS = "<!-- BEGIN TEMPLATE OPTIONS";
                const string END_TEMPLATE_OPTIONS = "END TEMPLATE OPTIONS -->";
                int startIndex = template.IndexOf(BEGIN_TEMPLATE_OPTIONS);
                bool templateHasOptions = (startIndex != -1);
                if (templateHasOptions)
                {
                    int beginOptions = (startIndex + BEGIN_TEMPLATE_OPTIONS.Length);
                    int endOptions = template.IndexOf(END_TEMPLATE_OPTIONS, beginOptions);
                    if (endOptions == -1 || endOptions < beginOptions) throw new InternalError("Invalid template options (markers)");
                    string json = template.Substring(startIndex: beginOptions, length: (endOptions - beginOptions));
                
                    dynamic options = JsonConvert.DeserializeObject(json);
                    if (options.JpegCompressionEnabled != null)
                    {
                        Winnovative_JpegCompressionEnabled = (bool)options.JpegCompressionEnabled;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(Winnovative_JpegCompressionEnabled), Winnovative_JpegCompressionEnabled);
                    }
                    if (options.JpegCompressionLevel != null) 
                    { 
                        Winnovative_JpegCompressionLevel = (int)options.JpegCompressionLevel;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(Winnovative_JpegCompressionLevel), Winnovative_JpegCompressionLevel);
                    }
                    if (options.InternetDomainAuthority != null)
                    {
                        internetDomainAuthority = (string)options.InternetDomainAuthority;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(internetDomainAuthority), internetDomainAuthority);
                    }
                    if(options.PdfCompressionLevel != null)
                    {
                        Winnovative_CompressionLevel = (PdfCompressionLevel)(int)options.PdfCompressionLevel;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1} {2}", nameof(Winnovative_CompressionLevel),(int)Winnovative_CompressionLevel, Winnovative_CompressionLevel.ToString());
                    }
                    if(options.MailMergeType != null)
                    {
                        MailMergeType = (MergeFileType)Enum.Parse(typeof(MergeFileType), (string)options.MailMergeType);
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(MailMergeType), MailMergeType.ToString());
                    }
                    if(options.EmbedFonts != null)
                    {
                        Winnovative_EmbedFonts = (bool)options.EmbedFonts;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(Winnovative_EmbedFonts), Winnovative_EmbedFonts);
                    }
                    if(options.ImageScalingEnabled != null)
                    {
                        Winnovative_ImageScalingEnabled = (bool)options.ImageScalingEnabled;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(Winnovative_ImageScalingEnabled), Winnovative_ImageScalingEnabled);
                    }
                    if (options.QRPixelsPerModule != null)
                    {
                        QRPixelsPerModule = (int)options.QRPixelsPerModule;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(QRPixelsPerModule), QRPixelsPerModule);
                    }
                    if(options.QRImageStyle != null)
                    {
                        QRImageStyle = (string)options.QRImageStyle;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(QRImageStyle), QRImageStyle);
                    }
                    if(options.QRTextDivStyle != null)
                    {
                        QRTextDivStyle = (string)options.QRTextDivStyle;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(QRTextDivStyle), QRTextDivStyle);
                    }
                    if(options.QRTextStyle != null)
                    {
                        QRTextStyle = (string)options.QRTextStyle;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(QRTextStyle), QRTextStyle);
                    }
                    if(options.QRTextEnabled != null)
                    {
                        QRTextEnabled = (bool)options.QRTextEnabled;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(QRTextEnabled), QRTextEnabled);
                    }
                    if(options.CompressCrossReference != null)
                    {
                        Winnovative_CompressCrossReference = (bool)options.CompressCrossReference;
                        if (isTraceLoggingEnabled)
                            logger.LogTrace("Set {0} to {1}", nameof(Winnovative_CompressCrossReference), Winnovative_CompressCrossReference);
                    }

                } //end if template has options
            }
            catch (Exception e)
            {
                if (logger.IsEnabled(LogLevel.Debug))
                {
                    logger.LogDebug(e, nameof(ApplyOptionsFromTemplate) + " - caught unexpected exception");
                }
                throw new InternalError("Invalid template options (content) - " + e.Message);
            }
        }
    }
}