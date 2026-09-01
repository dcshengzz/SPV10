using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Collections.ObjectModel;
using System.Text.RegularExpressions;

namespace swz.SurveyPlus.Application
{
    //For some pitfalls in using const string instead of static readonly see:
    //  https://exceptionnotfound.net/const-vs-static-vs-readonly-in-c-sharp-applications/
    //(tldr=other modules using the values declared with const won't pick up any changes made here until they themselves are recompiled)

    public static class Constants
    {
        /// <summary>
        /// Consolidates the route strings for the u@app api into one place so its easier for us to keep track of them.
        /// In customer installations we will often need a list of these so that api gateways and firewalls can be configured properly.
        /// </summary>
        public class UAppRoutes
        {
            /// <summary>
            /// First part of the url path for the u@app api routes, for use in Route declarations
            /// </summary>
            public const string ApiBase = "api/";

            //Partial urls - these will be prepended with ApiBase to form the full route

            public const string ConnectivityTest = "connectivityTest";

            public const string Logoff = "resp/logoff";
            public const string PasswordLogin = "resp/passwordLogin";
            public const string DirectAccessLogin = "resp/directAccessLogin";
            public const string InvitesLogin = "resp/invitesLogin";
            //20231121 - changing to avoid use of "spcp" in url - public const string SpcpLogin = "resp/spcpLogin";
            public const string SpcpLogin = "resp/iam"; //20231121
            public const string Verify = "resp/verify";
            public const string Renew = "resp/renew";

            public const string SendPasswordResetLink = "resp/reset/send";
            public const string ValidatePasswordResetToken = "resp/reset/validate";
            public const string PasswordReset = "resp/reset";
            public const string PasswordChange = "resp/password";

            public const string ShortLink_WithCode = "shortlink/{linkCode}/{accessCode}";
            public const string ShortLink_NoCode = "shortlink/{linkCode}/";
            public const string Setting = "setting/{name}";
            public const string Metadata = "metadata"; //TODO - would like folder/filename in url, but how to specify route?
            public const string Help = "help";
            public const string RespondentContent = "content/{type}";

            public const string ListSampleInfoSingle = "listSampleInfo/{dlsi}";
            public const string RespondentDashboardData = "dashboard";

            public const string DelegateSurvey = "survey/delegation";
            public const string IsDelegationExceeded = "survey/delegation/exceeded/{dlsi}";
            public const string ValidateDelegation = "survey/delegation/validate/{dlsi}";
            public const string RevokeAllDelegation = "survey/delegation/revokeAll/{dlsi}";
            public const string RevokeSingleDelegation = "survey/delegation/revokeSingle/{id}";
            public const string DelegationHistory = "survey/delegation/history/{dlsi}";
            
            public const string ResponseData = "resp/data/{form}"; //WARNING: changing this one needs extra work. TODO - would like to be survey/response, but data is pulled by InternetApiDataSource using DataUrl in model for the survey form. Goes to DataEditController.

            public const string AddSurveyResponse = "survey/add/{dlsi}";
            public const string IsAnonymousSurvey = "survey/anonymous/{dlsi}";
            public const string DownloadSurveyExcel = "download/file/{dlsi}/{token}/"; 
            public const string DownloadSurveyExcel_Resp = "download/file/{dlsi}/{token}/{respId}";
            public const string UploadExcelResponse = "survey/upload";
            
            public const string FileLocalStorageProperties = "file/localStorage/properties/{fileName}";
            public const string FileLocalStorageContent = "file/localstorage/content/{fileName}";
            public const string FileTokenProperties = "file/token/properties/{token}";
            public const string FileTokenContent = "file/token/content/{token}";
            public const string RespondentFileUpload = "file/upload";

            public const string GetSurveyDataForPrint_Resp = "print/data/{formName}/{dlsi}/{respId}";
            public const string GetSurveyDataForPrint = "print/data/{formName}/{dlsi}";
            public const string EnqueuePrintJob = "print/job";
            public const string CheckPdfExportRateLimit = "print/ratelimit";
            public const string UpdatePdfExportStatus = "print/status";
        }

        public class IntranetRoutes
        {
            public const string DeploymentExportResponsePrepare = "/deployment/exportresponse/prepare/{dplyIdStr}";
            public const string DeploymentExportUploadedFilesPrepare = "/deployment/exportuploadedfiles/prepare/{dplyIdStr}";
            public const string FileTicketDownload = "/file/ticket/{ticket}";
        }

        public const string LogFormat = "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level}] ({SourceContext}) {Message}{NewLine}{Exception}";

        public const string UnknownFileName = "unknown";        
        public const string LoginKey = "#r$bUthefat44mat";
        public const string LoginIv = "PrA2raSwuCResUfA";
        public const int NumRetry = 9;
        public const string PdfFormDownloadRoute = "/pdfform/post";
        public const string QnnDelimiter = "{{{swz}}}";
        public const int MagicNumber = 1729; //We could all use a little magic sometimes

        /// <summary>
        /// Link protocol for links in qr codes and emails - this must always be https. 
        /// In prod server it probably eventually auto-redirects them to https anyway BUT http link address can be seen in the middle
        /// and may contain sensitive tokens etc, so we will always use https for these links going forward. 
        /// (Until we get the dev environment running in https you will just have to manually remove the s when testing in dev.)
        /// </summary>
        public const string MailLinksProtocol = "https://";

        /// <summary>
        /// Format used when representing certain datetime as string. Includes the seconds.
        /// yyyy-MM-dd HH:mm:ss
        /// TODO: rename as SurveyPlusDateFormat as the Qnn is only one of many place it is used now
        /// </summary>
        public const string QnnDatetimeFormat = "yyyy-MM-dd HH:mm:ss";

        /// <summary>
        /// DateTime format for display purposes. Does not include seconds.
        /// yyyy-MM-dd HH:mm
        /// </summary>
        public const string DatetimeFormat = "yyyy-MM-dd HH:mm";

        /// <summary>
        /// An ISO8601 DateTime format suitable for technical purposes, 
        /// includes the full milliseconds. (Note that it doesn't include the 'Kind'
        /// which there isn't a format placeholder for)
        /// </summary>
        public const string DatetimeFull8601Format = "yyyy-MM-ddTHH:mm:ss.fff";

        /// <summary>
        /// Date-only date format, no time.
        /// yyyy-MM-dd
        /// </summary>
        public const string DateFormat = "yyyy-MM-dd";

        public const int GateWayToAppAllowedTimeSpanInSeconds = 60;
        public const string RespFilesSubFolder = "Files";

        public const string WINNOVATIVE_LICENSE_KEY = "VdvI2svayMjC2sPUytrJy9TLyNTDw8PD";

        public const string ThankYouPage = "/thankyou.html";

        //TODO - we need some concept of behaviour groups for our status (below is using known exempted types for MPA, iirc SIMS only uses EM?)
        public static readonly ImmutableArray<string> StatusCodesForExempted 
            = new string[] { "EM", "EC", "EE", "EO" }.ToImmutableArray();

        //TODO - consider moving this to SampleListImporter
        /// <summary>
        /// Required columns in the sample list csv and their indices
        /// </summary>
        public class SampleListCsv
        {
            public static readonly ImmutableArray<string> REQUIRED_COLUMNS = "UID,NAME,EMAIL,CC_EMAILS,ACTIVE,PASSWORD_RESET,PEER_UID"
                .Split(',').ToImmutableArray();
            public const int idxUid = 0;
            public const int idxName = 1;
            public const int idxEmail = 2;
            public const int idxCcEmails = 3;
            public const int idxActive = 4;
            public const int idxPasswordReset = 5;
            public const int idxPeerUid = 6;

            //Optional address book columns
            public const string AddressLine1 = "ADDRESSLINE1";
            public const string AddressLine2 = "ADDRESSLINE2";
            public const string AddressLine3 = "ADDRESSLINE3";
            public static readonly ImmutableArray<string> OPTIONAL_COLUMNS = "ADDRESSLINE1,ADDRESSLINE2,ADDRESSLINE3"
                .Split(',').ToImmutableArray();
        }

        /// <summary>
        /// Required columns in the trk lst csv, and their indices
        /// </summary>
        public class TrackListCsv
        {
            public const string COLUMNS = "UID,NAME,EMAIL,REMARKS,STATUSCODE";
            public const int idxUid = 0;
            public const int idxName = 1;
            public const int idxEmail = 2;
            public const int idxRemarks = 3;
            public const int idxStatusCode = 4; 
        }

		public const string error404 = "/error/404";

        //If you are trying to validate email address format, you may check out this Clover.Core.Utils.Email.IsAddressFormatValid
        public const string REGEX_EMAIL =
            "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

        public const string MetadataFormsFolder = "metadata/forms";

        /// <summary>
        /// For use with places that follow the -1 means 'unlimited' convention
        /// </summary>
        public const int Unlimited = -1;

        public static List<string> OnlineFormControls = new List<string>
        {
            "dropdown",
            "input",
            "textarea",
            "checkbox",
            "radiogroup",
            "dropzonecontrol"
        };
        public static List<string> OnlineFormChoiceControls = new List<string>
        {
            "dropdown",
            "checkbox",
            "radiogroup"
        };
        //Add more controls to be included in WordCloudReport.
        public static List<string> WordCloudControls = new List<string>
        {
            "input"
        };

        public static class QnnType
        {
            public const string Pdf = "P"; //legacy 
            public const string Online = "O";
            public const string PdfWithAttachement = "A"; //legacy
        }

        public static class FileType
        {
            public const string Pdf = "pdf";
        }

        public static class ViewName
        {
            public const string Index = "Index";               
        }

        public static class ResponseAs
        {
            //If changing these values please remember to update ResponseApplication.IsValidResponseAs
            public const string Form = "Form";
            public const string Excel = "Excel";
            public const string Pdf = "PDF"; //legacy
            public const string Unknown = "Unknown";
            public const string PrePopulated = "PrePopulated";
            public const string Rejection = "Rejection";
        }

        public static class ResponseBy
        {
            //If changing these values please remember to update ResponseApplication.IsValidInitialResponseBy
            public const string Sample = "Sample";
            public const string Editor = "Editor";
            public const string Unknown = "Unknown";
        }

        public static class ResponseVia
        {
            //If changing these values please remember to update ResponseApplication.IsValidInitialResponseVia
            public const string Online = "Online";
            public const string Offline = "Offline";
            public const string Unknown = "Unknown";
        }

        public static class dwAppSettingName
        {
            public const string DelegationAccessCodeRetries = "DelegationAccessCodeRetries";
            public const string WhitelistedFileExt = "WhitelistedFileExt";
            public const string InternetDomainAuthority = "InternetDomainAuthority";
            public const string SMTPTestRecipients = "SMTPTestRecipients";
            public const string TrkListActiveYN = "TrkListActiveYN";
            public const string SurveyResponseUpdaterPrefix = "SurveyResponseUpdater";
            public const string AutosaveDelay = "AutosaveDelay";
            public const string AutosaveEnabled = "AutosaveEnabled";
            public const string IamIgnoreLogins = "IamIgnoreLogins";
            public const string MonthlyAuditAccessLogRecipients = "MonthlyAuditAccessLogRecipients";
        }

        public static class ModelName
        {
            public const string AuditLog = "AuditLog"; //The AuditLog entity now refers to sy_AuditLog as its db object
            public const string vSP_AuditLog = "vSP_AuditLog"; //the vSP_AuditLog entity now refers to sySP_vSP_auditlog as its db object
            public const string QNN_DPLY_TRANSITIONHISTORY = "QNN_DPLY_TRANSITIONHISTORY";
            public const string QNN_CATEGORY = "QNN_CATEGORY";
            public const string QNN_CATEGORY_ROLE = "QNN_CATEGORY_ROLE";
            public const string QNN_QNN_FIELD = "QNN_QNN_FIELD";
            public const string QNN_RESP = "QNN_RESP";
            public const string QNN_DPLY = "QNN_DPLY";
            public const string QNN_RESP_ANS = "QNN_RESP_ANS";
            public const string QNN_QNN = "QNN_QNN";
            public const string QNN_DPLY_CUSTOM_RECURRENCE = "QNN_DPLY_CUSTOM_RECURRENCE";
            public const string QNN_DPLY_SAMPLE_INFO = "QNN_DPLY_SAMPLE_INFO";
            public const string QNN_DPLY_SAMPLE_OWNER = "QNN_DPLY_SAMPLE_OWNER";
            public const string vSP_ListSampleInfo = "vSP_ListSampleInfo";
            public const string vSP_ListSampleInfoResp = "vSP_ListSampleInfoResp";
            public const string QNN_DPLY_SAMPLE_DUEDATE = "QNN_DPLY_SAMPLE_DUEDATE";
            public const string QNN_STATUS_FLOW = "QNN_STATUS_FLOW";
            public const string QNN_DPLY_MSG = "QNN_DPLY_MSG";
            public const string QNN_DPLY_MSG_SAMPLE = "QNN_DPLY_MSG_SAMPLE";
            public const string QNN_LIST_SAMPLE = "QNN_LIST_SAMPLE";
            public const string QNN_LIST_SAMPLE_PROP = "QNN_LIST_SAMPLE_PROP";
            public const string QNN_LIST_PROP = "QNN_LIST_PROP";
            public const string QNN_QNN_FORM = "QNN_QNN_FORM";
            public const string vSP_DeploymentRespCount = "vSP_DeploymentRespCount";
            public const string vSP_DeploymentRespCompleteCount = "vSP_DeploymentRespCompleteCount";
            public const string vSP_ListPropCount = "vSP_ListPropCount";
            public const string QNN_LIST = "QNN_LIST";
            public const string QNN_STATUS = "QNN_STATUS";
            public const string QNN_TRK_LIST = "QNN_TRK_LIST";
            public const string QNN_TRK_LIST_SAMPLE = "QNN_TRK_LIST_SAMPLE";
            public const string QNN_SAMPLE = "QNN_SAMPLE";
            public const string vSP_DeploymentWithRespCount = "vSP_DeploymentWithRespCount";
            public const string vSP_List = "vSP_List";
            public const string vSP_Category = "vSP_Category";
            public const string vSP_Category_D = "vSP_Category_D";
            public const string vSP_Category_L = "vSP_Category_L";
            public const string vSP_Category_Q = "vSP_Category_Q";
            public const string vSP_Qnn = "vSP_Qnn";
            public const string vSP_dataEditors = "vSP_dataEditors";
            public const string vSP_QnnSampleActive = "vSP_QnnSampleActive";
            public const string vSP_ListWithCount = "vSP_ListWithCount";
            public const string vSP_QnnSampleActiveForGrid = "vSP_QnnSampleActiveForGrid";
            public const string vSP_DataEditorDeployment = "vSP_DataEditorDeployment";
            public const string vSP_StructDivision = "vSP_StructDivision";
            public const string vSP_SurveyForm = "vSP_SurveyForm";
            public const string vSP_DeploymentOnline = "vSP_DeploymentOnline";
            public const string QNN_SAMPLE_STRUCTDIVISION = "QNN_SAMPLE_STRUCTDIVISION";
            public const string vSP_DeploymentSampleAndPeerSample = "vSP_DeploymentSampleAndPeerSample";
            public const string QNN_DPLY_SCHEDULER = "QNN_DPLY_SCHEDULER";
            public const string QNN_REPORT_SNAPSHOT = "QNN_REPORT_SNAPSHOT";
            public const string dwSecurityUser = "dwSecurityUser";
            public const string dwMetadata = "dwMetadata";
            public const string QNN_QNN_FILE = "QNN_QNN_FILE";
            public const string QNN_DPLY_DATASET = "QNN_DPLY_DATASET";
            public const string QNN_RESP_DELEGATION = "QNN_RESP_DELEGATION";
            public const string QNN_DPLY_MSG_FORSTATUS = "QNN_DPLY_MSG_FORSTATUS";
            public const string QNN_GLOBAL_MSG = "QNN_GLOBAL_MSG";
            public const string QNN_GLOBAL_MSG_FORSTATUS = "QNN_GLOBAL_MSG_FORSTATUS";
            public const string QNN_GLOBAL_MSG_SAMPLE = "QNN_GLOBAL_MSG_SAMPLE";
            public const string QNN_GLOBAL_MSG_USER = "QNN_GLOBAL_MSG_USER";
            public const string AccessReportSchedule = "AccessReportSchedule";
            public const string vSP_RespParticipation = "vSP_RespParticipation";
            //public const string vSP_DplySampleInfoResponseCount = "vSP_DplySampleInfoResponseCount"; //comment-out as not mapped as entity yet
            public const string QNN_SHORT_LINK = "QNN_SHORT_LINK";
            public const string vSP_TagsSearch = "vSP_TagsSearch";
            public const string QNN_RESP_ADMIN = "QNN_RESP_ADMIN";
            public const string vSP_RespDelegationGrid = "vSP_RespDelegationGrid";
            public const string vSP_RespDelegationActive = "vSP_RespDelegationActive";
            public const string dwUploadedFiles = "dwUploadedFiles";
            public const string QNN_HELP = "QNN_HELP";
            public const string QNN_SAMPLE_ADDRESS = "QNN_SAMPLE_ADDRESS";
            public const string vSP_UserRole = "vSP_UserRole";
            public const string QNN_SCHEDULED_EXPORT_RECIPIENT = "QNN_SCHEDULED_EXPORT_RECIPIENT";
            public const string QNN_FILE_TICKET = "QNN_FILE_TICKET";
            public const string QNN_DPLY_STRATA_QUOTA = "QNN_DPLY_STRATA_QUOTA";
            public const string QNN_STYLE = "QNN_STYLE";
        }

        public static class FieldName
        {
            //WARNING: Make sure the case on these matches what is in the db & metadata otherwise entities can end up with
            //         duplicate fields when you try and change the value which can cause errors like
            //         "The variable name '@EmailUsrEditYN__value' has already been declared." when you try to save
            public const string StructDivisionId = "StructDivisionId";
            public const string Id = "Id";
            public const string NumberId = "NumberId";
            public const string QnnId = "QnnId";
            public const string Type = "Type";
            public const string ListSampleId = "ListSampleId";
            public const string DplyId = "DplyId";
            public const string UserId = "UserId";
            public const string RespId = "RespId";
            public const string QnnFieldId = "QnnFieldId";
            public const string AnsVal = "AnsVal";
            public const string AnsBin = "AnsBin";
            public const string IsExcelEnabled = "IsExcelEnabled";
            public const string IsExcelResponse = "IsExcelResponse";
            public const string IsExcelResponseDE = "IsExcelResponseDE";
            public const string ExcelToken = "ExcelToken";
            public const string ExcelUploadDate = "ExcelUploadDate";
            [Obsolete] public const string IsDeleted = "IsDeleted";
            public const string RequireAccessCode = "RequireAccessCode";
            public const string SampleId = "SampleId";
            public const string Pwd = "Pwd";
            public const string DplyListSampleId = "DplyListSampleId";
            public const string ValidityStart = "ValidityStart";
            public const string ValidityEnd = "ValidityEnd";
            public const string Email = "Email";
            public const string CcEmails = "CcEmails";
            public const string QnnTitle = "QnnTitle";
            public const string UID = "UID";
            public const string CreatedDate = "CreatedDate";
            public const string CreatedBy = "CreatedBy";
            public const string UpdatedBy = "UpdatedBy";
            public const string UpdatedDate = "UpdatedDate";
            //public const string DeletedBy = "DeletedBy";
            //public const string DeletedDate = "DeletedDate";
            public const string Name = "Name";
            public const string FromName = "FromName";
            public const string Comments = "Comments";
            public const string ListId = "ListId";
            public const string DplyMsgId = "DplyMsgId";
            public const string MergeOutputToken = "MergeOutputToken";
            public const string MergeDone = "MergeDone";
            public const string Status = "Status";
            public const string StatusModifyOn = "StatusModifyOn";
            public const string StatusModifyBy = "StatusModifyBy";
            public const string VisibleToRespondent = "VisibleToRespondent";
            public const string DueDate = "DueDate";
            public const string DaysUpdate = "DaysUpdate";
            public const string RespDateEnd = "RespDateEnd";
            public const string DateStart = "DateStart";
            public const string DateEnd = "DateEnd";
            public const string DateComplete = "DateComplete";
            public const string DateStart3PA = "DateStart";
            public const string DateComplete3PA = "DateComplete";
            public const string UpdatedDate3PA = "UpdatedDate";
            public const string RemarksModifyOn3PA = "RemarksModifyOn";
            public const string StatusModifyOn3PA = "StatusModifyOn";
            public const string IsPrePopulated = "IsPrePopulated";
            public const string PdfPassword = "PdfPassword";
            public const string Token = "Token";
            public const string RowNumber = "RowNumber";
            public const string ListPropId = "ListPropId";
            public const string PropValue = "PropValue";
            public const string GenerateProfileOutputToken = "GenerateProfileOutputToken";
            public const string GenerateProfileDone = "GenerateProfileDone";
            public const string FormNames = "FormNames";
            public const string Language = "Language";
            public const string Languages = "Languages";
            public const string DelegationCode = "DelegationCode";
            public const string DelegationAccessFailAttempt = "DelegationAccessFailAttempt";
            public const string AccessCode = "AccessCode";
            public const string RecurrenceDplyId = "RecurrenceDplyId";
            public const string RecurrenceOfDplyId = "RecurrenceOfDplyId";
            public const string RecurrenceJobId = "RecurrenceJobId";
            public const string LastLoginDate = "LastLoginDate";
            public const string Data = swz.Clover.Core.Utils.Constants.FieldName.dwUploadedFiles.Data;
            public const string Filename = "Filename";
            public const string Folder = "Folder";
            public const string DplyDateStart = "DplyDateStart";
            public const string GlobalMsgId = "GlobalMsgId";
            public const string MsgContent = "MsgContent";
            public const string MsgContentJson = "MsgContentJson";
            public const string EmailSubj = "EmailSubj";
            public const string EmailFrom = "EmailFrom";
            public const string ScheduledDate = "ScheduledDate";
            public const string JobId = "JobId";
            public const string ForStatus = "ForStatus";
            public const string EmailSentDate = "EmailSentDate";
            public const string ParentId = "ParentId";
            public const string JobIsCanceled = "JobIsCanceled";
            public const string IsAnonymous = "IsAnonymous";
            public const string IsMultipleResponse = "IsMultipleResponse";
            public const string ScheduleType = "ScheduleType";
            public const string DplyName = "DplyName";
            public const string IsEnabled = "IsEnabled";
            public const string ActiveYN = "ActiveYN";
            public const string IsTargetUsers = "IsTargetUsers";
            public const string DplyStatus = "DplyStatus";
            public const string QnnStatus = "QnnStatus";
            public const string DplyIsDeleted = "DplyIsDeleted";
            public const string QnnIsDeleted = "QnnIsDeleted";
            public const string QnnType = "QnnType";
            public const string StatusTitle = "StatusTitle";
            public const string CompleteAction = "CompleteAction";
            public const string CompleteURL = "CompleteURL";
            public const string RespCount = "RespCount";
            public const string MaxResponse = "MaxResponse";
            public const string CompleteCount = "CompleteCount";
            public const string IncompleteCount = "IncompleteCount";
            public const string CustomFrequencyType = "CustomFrequencyType";
            public const string RecurDay = "RecurDay";
            public const string RecurMonth = "RecurMonth";
            public const string RecurYear = "RecurYear";
            public const string IsLocalStorage = swz.Clover.Core.Utils.Constants.FieldName.dwUploadedFiles.IsLocalStorage;
            public const string SurveyName = "SurveyName";
            public const string Title = "Title";
            public const string SamplePeerId = "SamplePeerId";
            public const string StartDate = "StartDate";
            public const string EndDate = "EndDate";
            public const string Topic = "Topic";
            public const string Heading = "Heading";
            public const string DplyDateEnd = "DplyDateEnd";
            public const string ApiIdentifier = "ApiIdentifier";
            public const string InitialResponseAs = "InitialResponseAs";
            public const string InitialResponseBy = "InitialResponseBy";
            public const string InitialResponseVia = "InitialResponseVia";
            public const string InitialResponseUserId = "InitialResponseUserId";
            public const string LastResponseAs = "LastResponseAs";
            public const string LastResponseBy = "LastResponseBy";
            public const string LastResponseVia = "LastResponseVia";
            public const string CompletedResponseAs = "CompletedResponseAs";
            public const string CompletedResponseBy = "CompletedResponseBy";
            public const string CompletedResponseVia = "CompletedResponseVia";
            public const string CompletedResponseUserId = "CompletedResponseUserId";
            public const string RecurrenceNotify = "RecurrenceNotify";
            public const string RecurrenceNextDate = "RecurrenceNextDate";
            public const string RecurrenceAdvanceDays = "RecurrenceAdvanceDays";
            public const string RecurrenceFrequency = "RecurrenceFrequency";
            public const string RecurrenceEndDate = "RecurrenceEndDate";
            public const string RecurrenceEnabled = "RecurrenceEnabled";
            public const string State = "State";
            public const string PropCount = "PropCount";
            public const string Fields = "Fields";
            public const string FieldsId = "FieldsId";
            public const string NumRetry = "NumRetry";
            public const string PwdResetYN = "PwdResetYN";
            public const string TrkListActiveYN = "TrkListActiveYN";
            public const string TrklistId = "TrklistId";
            public const string DormancyDate = "DormancyDate";
            public const string IsLocked = "IsLocked";
            public const string Login = "Login";
            public const string Remarks = "Remarks";
            public const string RespondentName = "RespondentName";
            public const string StatusDate = "StatusDate";
            public const string StatusId = "StatusId";
            public const string NotifyMerge = "NotifyMerge";
            public const string NotifyEmail = "NotifyEmail";
            public const string NotifyGenerate = "NotifyGenerate";
            public const string DplyStep = "DplyStep";
            public const string RemarksModifyOn = "RemarksModifyOn";
            public const string RemarksModifyBy = "RemarksModifyBy";
            public const string LastSavedPage = "LastSavedPage";
            public const string UIDName = "UIDName";
            public const string Alias = "Alias";
            public const string IsExposeListProperties = "IsExposeListProperties";
            public const string IsDirectAccessEnabled = "IsDirectAccessEnabled"; //f.k.a. TrackableAnonymous
            public const string IsDirectAccessForComplete = "IsDirectAccessForComplete"; //f.k.a. AccessSubmitted
            public const string DirectAccessCode = "DirectAccessCode";
            public const string IsEnhancedSecurity = "IsEnhancedSecurity";
            public const string LinkType = "LinkType";
            public const string Url = "Url";
            public const string FormName = "FormName";
            public const string Tags = "Tags";
            public const string RevokedDate = "RevokedDate";
            public const string SelfUpdatedDate = "SelfUpdatedDate";
            public const string PwdResetToken = "PwdResetToken";
            public const string Content = "Content";
            public const string EditorState = "EditorState";
            public const string DplyWorkflowState = "DplyWorkflowState";
            public const string DplyCreatedDate = "DplyCreatedDate";
            public const string ListSampleRecordActiveYN = "ListSampleRecordActiveYN";
            public const string PrintAccessCode = "PrintAccessCode";
            public const string ToEmails = "ToEmails";
            public const string SampleRecordActiveYN = "SampleRecordActiveYN";
            public const string TrkListIds = "TrkListIds";
            public const string AddressLine1 = "AddressLine1";
            public const string AddressLine2 = "AddressLine2";
            public const string AddressLine3 = "AddressLine3";
            public const string IncludeTags = "IncludeTags";
            public const string ExcludeTags = "ExcludeTags";
            public const string Code = "Code";
            public const string ScheduledExportEnabled = "ScheduledExportEnabled";
            public const string ScheduledExportFrequency = "ScheduledExportFrequency";
            public const string ScheduledExportStartDate = "ScheduledExportStartDate";
            public const string ScheduledExportEndDate = "ScheduledExportEndDate";
            public const string ScheduledExportNextDate = "ScheduledExportNextDate";
            public const string ScheduledExportJobId = "ScheduledExportJobId";
            public const string SecurityUserId = "SecurityUserId";
            public const string SecurityUserName = "SecurityUserName";
            public const string RoleCode = "RoleCode";
            public const string RoleName = "RoleName";
            public const string SecurityUserStructDivisionId = "SecurityUserStructDivisionId";
            public const string FileId = "FileId";
            public const string Purpose = "Purpose";
            public const string RestrictedToUserId = "RestrictedToUserId";
            public const string RestrictedToRoles = "RestrictedToRoles";
            public const string ExpiryDate = "ExpiryDate";
            public const string IsDeleteFileOnExpiry = "IsDeleteFileOnExpiry";
            public const string Score = "Score";
            public const string TimeTook = "TimeTook";
            public const string GroupName = "GroupName";
            public const string EmailRecipients = "EmailRecipients";
            public const string EmailSuccess = "EmailSuccess";
            public const string EmailFailure = "EmailFailure";
            public const string MergedUID = "MergedUID";
            public const string HasResponse = "HasResponse";
            public const string UserName = "UserName";
            public const string IpAddress = "IpAddress";
            public const string SampleName = "SampleName";
            public const string AnonymousId = "AnonymousId";
            public const string JobDescription = "JobDescription";
            public const string LastJobRun = "LastJobRun";
            public const string UIDUsrEditYN = "UIDUsrEditYN";
            public const string NameUsrEditYN = "NameUsrEditYN";
            public const string EmailUsrEditYN = "EmailUsrEditYN";
            public const string ActiveUsrEditYN = "ActiveUsrEditYN";
            public const string PasswordUsrEditYN = "PasswordUsrEditYN";
            public const string ReqdYN = "ReqdYN";
            public const string UsrEditYN = "UsrEditYN";
            public const string TxtRow = "TxtRow";
            public const string TxtRegExp = "TxtRegExp";
            public const string TxtRegExpErr = "TxtRegExpErr";
            public const string OptType = "OptType";
            public const string UsrVisibleYN = "UsrVisibleYN";
            public const string RespVisibleYN = "RespVisibleYN";
            public const string TrkListId = "TrkListId";
            public const string StrataSource = "StrataSource";
            public const string Strata = "Strata";
            public const string StrataValue = "StrataValue";
            public const string Description = "Description";
            public const string FieldCount = "FieldCount";
            public const string CategoryId = "CategoryId";
            public const string Required = "Required";
            public const string ReadOnly = "ReadOnly";
            public const string ValidationExp = "ValidationExp";
            public const string ValidationErr = "ValidationErr";
            public const string AttachmentLength = "AttachmentLength";
            public const string Used = "Used";
            public const string ContentType = "ContentType";
            public const string Properties = "Properties";
            public const string Size = "Size";
            public const string IsRecurrencePrePopulateEnabled = "IsRecurrencePrePopulateEnabled";
            public const string ToStatus = "ToStatus";
            public const string FromStatus = "FromStatus";
        }

        public static class Views
        {
            public static class FieldName
            {
                public const string Active = "Active";
                public const string Inactive = "Inactive";
                public const string Revoked = "Revoked";
                public const string Scheduled = "Scheduled";
                public const string Expired = "Expired";
                public const string Unknown = "Unknown";
                public const string ListSampleRecordActiveYN = "ListSampleRecordActiveYN";
            }
        }

        public static class StoredProcedure
        {
            public const string InsertAuditLog = swz.Clover.Core.Utils.Constants.StoredProcedure.InsertAuditLog;
            public const string InsertSamlRecentAssertion = "InsertSamlRecentAssertion";
            public const string CleanupSamlRecentAssertion = "CleanupSamlRecentAssertion";
            public const string spSP_GetListSampleProfile = "spSP_GetListSampleProfile";
            public const string spSP_AddDplySampleInfoByListId = "spSP_AddDplySampleInfoByListId";
			public const string spSP_GetAddDplySampleInfoCount = "spSP_GetAddDplySampleInfoCount";
            public const string spSP_DeleteAuditLogBeforeCreatedDate = "spSP_DeleteAuditLogBeforeCreatedDate";
            public const string spSP_GetListSampleSurveyPassword = "spSP_GetListSampleSurveyPassword";
            public const string spSP_UpdateLoginSessionId = "spSP_UpdateLoginSessionId";
            public const string spSP_GetLoginSessionId = "spSP_GetLoginSessionId";
            public const string spSP_DeleteAllRespAnsByRespId = "spSP_DeleteAllRespAnsByRespId";
            public const string spSP_InsertResp = "spSP_InsertResp";
            public const string spSP_UpdateResp = "spSP_UpdateResp";
            public const string spSP_UpdateDplySampleInfo = "spSP_UpdateDplySampleInfo";
            public const string spSP_DeleteSampleOwnerByIds = "spSP_DeleteSampleOwnerByIds";
            public const string spSP_DeleteSampleOwnerByDplyId = "spSP_DeleteSampleOwnerByDplyId";
            public const string spSP_GetRecurrencePreviousRespAns = "spSP_GetRecurrencePreviousRespAns";
            public const string spSP_UpdateRecurrencePrePopulateField = "spSP_UpdateRecurrencePrePopulateField";
            public const string spSP_CountRecurrenceAfter = "spSP_CountRecurrenceAfter";
            public const string spSP_SetDataForDplyScheduler = "spSP_SetDataForDplyScheduler";
            public const string spSP_GetRespAnsWithDetailsDataCollection = "spSP_GetRespAnsWithDetailsDataCollection";
            public const string spSP_GetDplyUploadedFilesDataCollection = "spSP_GetDplyUploadedFilesDataCollection";
            public const string spSP_CopyRecurrentDply = "spSP_CopyRecurrentDply";
            public const string spSP_CopySampleOwner = "spSP_CopySampleOwner";
            public const string spSP_DeleteSampleProp = "spSP_DeleteSampleProp";
            public const string spSP_GetMonthlyAccessLogs = "spSP_GetMonthlyAccessLogs";
            public const string spSP_GetAuditLogsCreatedBeforeDate = "spSP_GetAuditLogsCreatedBeforeDate";
            public const string spSP_DeleteByTableNameAndIds = "spSP_DeleteByTableNameAndIds";
            public const string spSP_GetUploadedFiles = "spSP_GetUploadedFiles";
            public const string spSP_GetDplyChoiceCount = "spSP_GetDplyChoiceCount";
            public const string spSP_GetDplyWordCount = "spSP_GetDplyWordCount";
            public const string spSP_GetDplyUploadedFiles = "spSP_GetDplyUploadedFiles";
            public const string spSP_GetActiveTagsByStruct = "spSP_GetActiveTagsByStruct";
            public const string spSP_GetStatusResponseByDplyId = "spSP_GetStatusResponseByDplyId";
            public const string spSP_GetStatusResponseDetails = "spSP_GetStatusResponseDetails";
            public const string spSP_SyncAuditSampleName = "spSP_SyncAuditSampleName";
            public const string spSP_GetAllSampleUid = "spSP_GetAllSampleUid";
            public const string spSP_GetTrkListSample = "spSP_GetTrkListSample";
            public const string spSP_SetListSamplesActiveYN = "spSP_SetListSamplesActiveYN";
            public const string spSP_UpdateRespondentSessionTokenId = "spSP_UpdateRespondentSessionTokenId";
            public const string spSP_GetRespondentSessionTokenId = "spSP_GetRespondentSessionTokenId";
            public const string spSP_GetListSampleUids = "spSP_GetListSampleUids";
            public const string spSP_GetDplySampleInfoIdForDply = "spSP_GetDplySampleInfoIdForDply";
            public const string spSP_UpdateDplySampleInfoForImport = "spSP_UpdateDplySampleInfoForImport";
            public const string spSP_GetWeek = "spSP_GetWeek";
            public const string spSP_TakeReportSnapshot = "spSP_TakeReportSnapshot";
            public const string spSP_GetListSampleProps = "spSP_GetListSampleProps";
            public const string spSP_GetSingleResponseData = "spSP_GetSingleResponseData";
            public const string spSP_GetResponseSampleInfo = "spSP_GetResponseSampleInfo";
            public const string spSP_GetRespAnsRows = "spSP_GetRespAnsRows";
            public const string spSP_GetSampleIdentity = "spSP_GetSampleIdentity";
            public const string spSP_InsertAllSamplesToDataEditor = "spSP_InsertAllSamplesToDataEditor";
            public const string spSP_PurgeResp = "spSP_PurgeResp";
            public const string spSP_GetSegmentResponseByDplyId = "spSP_GetSegmentResponseByDplyId";
            public const string spSP_GetSectorResponseByDplyId = "spSP_GetSectorResponseByDplyId";
            public const string spSP_GetResponseAftRemovalByDplyId = "spSP_GetResponseAftRemovalByDplyId";
            public const string spSP_GetWeeklyActiveResponseByDplyId = "spSP_GetWeeklyActiveResponseByDplyId";
            public const string spSP_GetOverallResponseByDplyId = "spSP_GetOverallResponseByDplyId"; 
            public const string spSP_GetWeightgroupbyDplyID = "spSP_GetWeightgroupbyDplyID";
            public const string spSP_GetResponseStratumCount = "spSP_GetResponseStratumCount";
            public const string spSP_CopyStrataQuota = "spSP_CopyStrataQuota";
            public const string spSP_UpdateQnnRespAns = "spSP_UpdateQnnRespAns";
            public const string spSP_GetDueDate = "spSP_GetDueDate";
            public const string spSP_DeleteQnnDplyDataset = "spSP_DeleteQnnDplyDataset";
            public const string GetObjectPageUsage = "GetObjectPageUsage";
            public const string spSP_ListUserProfiles = "spSP_ListUserProfiles";
            public const string spSP_LogPdfGeneration = "spSP_LogPdfGeneration";
            public const string spSP_UpdatePdfExportStatus = "spSP_UpdatePdfExportStatus";
            public const string spSP_GetMetadataChangeDate = "spSP_GetMetadataChangeDate";
        }

        public static class FileProperties
        {
            public const string Name = swz.Clover.Core.Utils.Constants.FileProperties.Name;
            public const string Length = swz.Clover.Core.Utils.Constants.FileProperties.Length;
            public const string ContentType = swz.Clover.Core.Utils.Constants.FileProperties.ContentType;
            public const string IsLocalStorage = swz.Clover.Core.Utils.Constants.FileProperties.IsLocalStorage;
            public const string CreatedBy = swz.Clover.Core.Utils.Constants.FileProperties.CreatedBy;
            public const string CreatedDate = swz.Clover.Core.Utils.Constants.FileProperties.CreatedDate;
            public const string UpdatedBy = swz.Clover.Core.Utils.Constants.FileProperties.UpdatedBy;
            public const string UpdatedDate = swz.Clover.Core.Utils.Constants.FileProperties.UpdatedDate;
            public const string IsDownloadable = swz.Clover.Core.Utils.Constants.FileProperties.IsDownloadable;
        }

        public class PdfFieldType
        {
            public const string TextBox = "TextBox";
            public const string PushButton = "PushButton";
            public const string CheckBox = "CheckBox";
            public const string RadioButton = "RadioButton";
            public const string ComboBox = "ComboBox";
            public const string ListBox = "ListBox";
            public const string Signature = "Signature";
            public const string Unknown = "Unknown";
        }

        public class PdfFieldName
        {
            public const string BtnSubmit = "btnSubmit";
            public const string SwzPdfFormRespIdentifier = "swzPdfFormIdentifier";
            public const string SwzOnlineFormRespIdentifier = "swzOnlineFormIdentifier";
        }

        //todo - many of these are much too specific (ie single use) to be here and should be moved to the class that uses them
        public static class Message
        {
            public static class Prefix
            {
                /// <summary>
                /// Prefix for exception messages that may be reported to the clientside (will be checked by ChangeData et al)
                /// </summary>
                public const string ClientReportable = "CLIENT REPORTABLE:";

                /// <summary>
                /// Prefix for exception/error messages that clients can retry. DbHelper.IsRetryable will check this in relation
                /// to exceptions thrown due to RAISERROR, and later we might use it in certain api errors etc. 
                /// </summary>
                public const string ClientRetryable = "CLIENT RETRYABLE:";
            }

            public const string UnknownError = "Unknown Error";
            public const string FieldsNotMatched = "Fields not matched. ";
            public const string FieldsCreatedSucccessfully = "Qnn fields created successfully";
            public const string InternalErrorException = "Internal Error. Please contact system administrator";
            public const string GetSurveyDataFailed = "The system was unable to retrieve the previously saved survey answers. You can try refreshing the page. If this error persists please contact the helpdesk.";
            public const string MultipleDeploymentMatched = "Multiple deployments match the specifier";
            public const string NoFileInputFound = "No file to download.Probably this deployment has no file type question";
            public const string NoDeploymentMatched = "No deployments match the specifier";
            public const string InvalidStatus = "Invalid Status Specified";
            public const string InvalidStartEndDate = "Start Date must be earlier than End Date";
            public const string InvalidStartBeforeAfterDate = "Start-Before Date must be later than Start-After Date";
            public const string AccountLocked = "Account is locked. Please contact system administrator.";
            public const string Unauthorized = "You are not authorized to access.";
            public const string UploadVirusDetected = "Virus detected on the file, unable to upload.";            

            /// <summary>
            /// Well-known message indicating the session is invalid. 
            /// This will be shown in user-facing error messages, and will also be checked for by clients.
            /// (notable the Internet Side looks for this response content when it gets a 403 from the Intranet side
            /// u@app API and will throw a SessionInvalidException which in turn triggers Internet session invalidation)
            /// </summary>
            public const string SessionInvalid = "Your session was logged out or got timed out due to inactivity, please login again";

            public const string SurveyHasReachedMaximumResponses = "Survey has reached maximum responses";
            public const string InvalidSurvey = "Invalid survey";
            public const string InvalidSurveyForm = "Invalid survey form";
            public const string InvalidInput = "Invalid input";
            public const string YouDontHaveThePermission = "You don't have the permission"; //TODO - most users of this should be throwing a  PermissionException instead (and there are many such places!)
            public const string FeatureNotEnabled = "This feature is not enabled";
        }

        public static class ControllerName
        {
            public const string RespChangePassword = "RespChangePassword";
            public const string Respondent = "Resp";
            public const string Gateway = "Resp";
            public const string Account = "Account";
            public const string StarterApplication = "StarterApplication";
        }

        public static class MethodName
        {
            public const string Login = "Login";
            public const string Index = "Index";
            public const string Timeout = "Timeout";
        }

        public static class SpForms
        {
            //TODO - replace or supplement this with a set since its used for Contains a lot
            //     - but note that it must be case-insensitive (on the other hand, for only half a dozen entries
            //       list is probably just as fast)
            public static List<string> RespForms = new List<string>
            {
                "RespDashboard",
                "SpHeader",
                "SpTop",
                "SpFooter",
                "QNN_RESP_ADMIN",
                "thankyou",
                "RespAccountChangePassword",
                "resplogin"
            };
        }

        public static class ConstYesNo
        {
            public const string Yes = "Y";
            public const string No = "N";
            public const string True = "TRUE";
            public const string False = "FALSE";
        }

        /// <summary>
        /// Guids of well-known QNN_STATUS master data
        /// TODO - Update these and code using them to use QnnStatusId class now
        /// </summary>
        public static class Status
        {
            /// <summary>
            /// Guid for Pending (PE) A3D01086-40FC-4A7A-BF0C-DE17BDD205FA
            /// </summary>
            public static readonly Guid PENDING = QnnStatusId.Pending.Value;

            /// <summary>
            /// Guid for In-Progress (DE) 0D67932C-62EA-4CD3-A254-0CC63E742C93
            /// </summary>
            public static readonly Guid IN_PROGRESS = QnnStatusId.InProgress.Value;

            /// <summary>
            /// Guid for Submitted (SB) 7C23B23E-23A3-4F04-96EF-89521BABE78D
            /// </summary>
            public static readonly Guid SUBMITTED = QnnStatusId.Submitted.Value;

            /// <summary>
            /// Guid for Exempted (EM) 9731DE1D-2B6A-484C-BF10-44F842A3140E
            /// </summary>
            public static readonly Guid EXEMPTED = QnnStatusId.Exempted.Value;

            /// <summary>
            /// Guid for Cleared (CL) 129C7781-536D-42F6-ACA4-33A62F2E2C1F
            /// </summary>
            public static readonly Guid CLEARED = QnnStatusId.Cleared.Value;

            public static readonly Guid ACKNOWLEDGED = QnnStatusId.Acknowledged.Value;
            
        } //end of Status

        /// <summary>
        /// Guid of Well-Known Status specific to SIMS
        /// TODO - Update these and code using them to use QnnStatusId class now
        /// </summary>
        public static class StatusForSIMS
        {
            /// <summary>
            /// Guid for Received RC 50A76E5A-98F3-44BF-A161-003ED4FB2F3B
            /// </summary>
            public static readonly Guid RECEIVED = Guid.Parse("50A76E5A-98F3-44BF-A161-003ED4FB2F3B");

            /// <summary>
            /// Guid for Ceased Ops (CO) 2868495B-B1D3-40A8-943B-0078927CAA60
            /// </summary>
            public static readonly Guid CEASED_OPS = Guid.Parse("2868495B-B1D3-40A8-943B-0078927CAA60");

            /// <summary>
            /// Guid for Dormant (DM) C90486B7-A885-49FD-BCF4-00CF80D3D730
            /// </summary>
            public static readonly Guid DORMANT = Guid.Parse("C90486B7-A885-49FD-BCF4-00CF80D3D730");
 
            /// <summary>
            /// Guid for Out-of-Scope (OS) 8E08E44F-8A62-495A-8831-043E9CBDB2BC
            /// </summary>
            public static readonly Guid OUT_OF_SCOPE = Guid.Parse("8E08E44F-8A62-495A-8831-043E9CBDB2BC");

            /// <summary>
            /// Guid for Struck-off (SO) 3A216F10-3DDD-4008-AA20-04C75DFDE4AC
            /// </summary>
            public static readonly Guid STRUCK_OFF = Guid.Parse("3A216F10-3DDD-4008-AA20-04C75DFDE4AC");

            /// <summary>
            /// Guid for Holding Company (HC) 77A2D45E-3D98-43B9-AD2F-05AF5B0F0A5B
            /// </summary>
            public static readonly Guid HOLDING_COMPANY = Guid.Parse("77A2D45E-3D98-43B9-AD2F-05AF5B0F0A5B");

            /// <summary>
            /// Guid for Not-in-Ops Yet (NI) 9A0DB841-F236-48DA-91AF-05DEC27A92B4
            /// </summary>
            public static readonly Guid NOT_IN_OPS_YET = Guid.Parse("9A0DB841-F236-48DA-91AF-05DEC27A92B4");

            /// <summary>
            /// Guid for (BO) 5A1A28D7-DF6A-4391-9965-05F17D7660E3
            /// </summary>
            public static readonly Guid BOUNCED = Guid.Parse("5A1A28D7-DF6A-4391-9965-05F17D7660E3");

            /// <summary>
            /// Guid for Conso-Return (CR) E9CC3D0B-9488-4546-9D17-08ADDC93E437
            /// </summary>
            public static readonly Guid CONSO_RETURN = Guid.Parse("E9CC3D0B-9488-4546-9D17-08ADDC93E437");

            /// <summary>
            /// Guid for Partial Return (PR) 93E2C53D-CF1E-4B4A-9226-0A33E6F06AFA
            /// </summary>
            public static readonly Guid PARTIAL_RETURN = Guid.Parse("93E2C53D-CF1E-4B4A-9226-0A33E6F06AFA");

            /// <summary>
            /// Guid for Incomplete Data Entry (IE) C1C3D084-F194-4719-B7AE-0B62F14F67E8
            /// </summary>
            public static readonly Guid INCOMPLETE_DATA_ENTRY = Guid.Parse("C1C3D084-F194-4719-B7AE-0B62F14F67E8");
        }

        /// <summary>
        /// Constants to make explicitly readable the intended level of related entities an EntityModel should fetch with joins, 
        /// when calling MetadataToModelConverter.GetEntityModelByModelAsync
        /// If you want a level greater than 2 then use a literal - but you should probably rethink your approach in such cases.
        /// </summary>
        public static class Level
        {
            /// <summary>
            /// Only pull data from the entity row itself 
            /// </summary>
            public const byte NoJoins = 0;

            /// <summary>
            /// Also retrieve referenced entities at the first level (eg: those immediately referenced with a mapped foreign key)
            /// </summary>
            public const byte FetchJoins = 1;

            /// <summary>
            /// Fetch entities referenced with a foreign key and also entities those entities reference with their foreign keys (2nd level).
            /// You probably don't want this as its likely to result in big slow joins for all but the most trivial object entity graphs.
            /// </summary>
            public const byte DeepFetchJoins = 2;
        } //end of Level

        /// <summary>
        /// Standard SurveyPlus role names
        /// </summary>
        public static class Role
        {
            /// <summary>
            /// Role held by user who can access the admin panel
            /// </summary>
            public const string Admins = "Admins";

            public const string DataEditor = "DataEditor";
            public const string PrePopulate = "PrePopulate";
            public const string SurveyAdmin = "SurveyAdmin";
            public const string SurveyDesigner = "SurveyDesigner";
            public const string User = "User";
            public const string UserAdmin = "UserAdmin";
            public const string ThirdPartyAPIClient = "3PAClient";
            public const string AuditAdmin = "AuditAdmin";
            public const string SampleAdmin = "SampleAdmin";
            public const string DataOwner = "DataOwner";
            public const string Maintenance = "Maintenance";
            public const string IamClient = "IamClient";
        }

        public static class PermissionGroup
        {
            /// <summary>
            /// Well-known permission names that occur in most groups.
            /// </summary>
            public static class Permission
            {
                public const string Edit = "Edit";
                public const string View = "View";
            }

            public const string SetDataEditor = "SetDataEditor";
            public const string SetRemarks = "SetRemarks";
            public const string ShortLink = "ShortLink";
            public const string List = "List";
            public const string Questionnaire = "Questionnaire";
        }

        public static class Form
        {
            public static class FieldType
            {
                public const string input = "input";
                public const string checkbox = "checkbox";
                public const string textbox = "textbox";
                public const string dropdown = "dropdown";
                public const string radiogroup = "radiogroup";
            }
        }

        /// <summary>
        /// Well-known attributes in the http session on the respondent internet
        /// </summary>
        public static class RespondentHttpSession
        {
            public const string uId = "uId";
            public const string sampleId = "sampleId";
            public const string encrUserID = "encrUserID";
            public const string lastLoginDate = "lastLoginDate";
        }

        /// <summary>
        /// SurveyPlus custom HTTP headers, and also some standard header names that don't have constants in 
        /// netcore yet or where we need to use a constant instead of a static readonly string
        /// </summary>
        public static class HeaderNames
        {
            /// <summary>
            /// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options
            /// </summary>
            public const string XContentTypeOptions = "X-Content-Type-Options";

            /// <summary>
            /// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
            /// </summary>
            public const string XFrameOptions = "X-Frame-Options";

            /// <summary>
            /// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection
            /// </summary>
            public const string XXSSProtection = "X-XSS-Protection";

            /// <summary>
            /// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Referrer-Policy
            /// </summary>
            public const string ReferrerPolicy = "Referrer-Policy";

            /// <summary>
            /// See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cache-Control
            /// </summary>
            public const string CacheControl = "Cache-Control";

            /// <summary>
            /// Static file extensions exclude from cache control
            /// </summary>
            public static readonly string[] StaticFileExtensions = { ".css", ".js", ".png", ".jpg", ".woff2", ".ico", ".svg", ".gif" };

            /// <summary>
            /// Use when internet side calls u@app api to let us include the delegation code outside the json payload 
            /// </summary>
            public const string DelegationCode = "X-SWZ-DelegationCode";

            /// <summary>
            /// Used with file upload in the intranet side to express intent that file is for the local storage (annex files)
            /// nb: intended to one day rename this to X-SWZ-IsLocalStorage
            /// </summary>
            public const string isLocalStorage = "isLocalStorage"; //TODO this should be X-SWZ-IsLocalStorage but that will also require frontend changes

            /// <summary>
            /// Used with file upoad in the intranet side to pass the token of a file that is being updated in certain cases (eg see UploadNamedFileToLocalStorage)
            /// nb: intended to one day rename this to X-SWZ-UpdateFileToken
            /// </summary>
            public const string updateFileId = "updateFileId"; //TODO - this should be X-SWZ-UpdateFileToken, but that will require frontend changes

            /// <summary>
            /// Use when internet side calls u@app api to let us include the print access code outside the json payload 
            /// </summary>
            public const string PrintAccessCode = "X-SWZ-PrintAccessCode";

            /// <summary>
            /// Added to 401 challenge responses issued by certain implementations of IWindowsAuthenticationChallenger
            /// </summary>
            public const string Challenger = "X-SWZ-Challenger";

            /// <summary>
            /// Used to indicate if a survey response update request was generated by the Auto-Save mechanism
            /// TODO: add X-SWZ- prefix and proper capitalisation (needs frontend changes)
            /// </summary>
            public const string AutoSave = "autosave";

            /// <summary>
            /// Used by the legacy timestamp checking mechanism when saving response updates, used to pass the client
            /// machine's current time to the response updater. 
            /// This mechanism might be removed in a future version of surveyplus, but is still here for now. 
            /// TODO: add X-SWZ- prefix and proper capitalisation (needs frontend changes)
            /// </summary>
            public const string TimeStamp = "timestamp";

            /// <summary>
            /// Used to pass an IP Address to the updater endpoint
            /// TODO: who sets this? 
            /// TODO: if our code then add X-SWZ- prefix and proper capitalisation (needs frontend changes)
            /// </summary>
            public const string IPAddress = "ipaddress";
        }

        /// <summary>
        /// Name of forms used for email templates
        /// </summary>
        public static class EmailTemplate
        {
            public const string RecurrenceCreatedEmailTemplate = "RecurrenceCreatedEmailTemplate";
            public const string RecurrenceFailedEmailTemplate = "RecurrenceFailedEmailTemplate";
            public const string RejectResponseEmailTemplate = "RejectResponseEmailTemplate";
            public const string ListImportEmailErrorTemplate = "ListImportEmailErrorTemplate";
            public const string ListImportEmailTemplate = "ListImportEmailTemplate";
            public const string DplyWorkflowEmailTemplateStartWorkflow = "DplyWorkflowEmailTemplateStartWorkflow";
            public const string DplyWorkflowEmailTemplateCompleteWorkflow = "DplyWorkflowEmailTemplateCompleteWorkflow";
            public const string DplyWorkflowEmailTemplate = "DplyWorkflowEmailTemplate";
        }

        public static class FilenameValidation
        {
            public static readonly ReadOnlyCollection<string> WindowsBadFileNames = new List<string>( new string[]
            {
                "AUX", "CON", "PRN", "AUX", "NUL",
                "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9",
                "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8","LPT9"
            }).AsReadOnly(); //see: https://docs.microsoft.com/en-au/windows/win32/fileio/naming-a-file

            //Based on: https://stackoverflow.com/a/62855/8243046
            //nb: yes, Regex is thread-safe, its the result objects that arent
            //https://docs.microsoft.com/en-us/dotnet/standard/base-types/thread-safety-in-regular-expressions
            public static readonly Regex InvalidFileNameCharsRegex = new Regex("[" + Regex.Escape(new string(System.IO.Path.GetInvalidFileNameChars())) + "]", RegexOptions.None, TimeSpan.FromSeconds(1));
            public static readonly Regex InvalidPathCharsRegex = new Regex("[" + Regex.Escape(new string(System.IO.Path.GetInvalidPathChars())) + "]", RegexOptions.None, TimeSpan.FromSeconds(1));
        }

        public static class ExcelUploadErrors
        {
            public const string InternalError = "INTERNAL ERROR";

            public const string IncorrectFileType = "INCORRECT FILE TYPE";
            public const string MissingRanges = "MISSING RANGES";
            public const string IncorrectUEN = "INCORRECT UEN";
            public const string RestrictedIP = "RESTRICTED IP";
            public const string IncorrectAccessCode = "INCORRECT ACCESS CODE";

            public const string NotEnabled = "EXCEL NOT ENABLED";

            /// <summary>
            /// Specific errors for which the UI should show a friendly message
            /// </summary>
            public static readonly ReadOnlyCollection<string> ReportableToClient = new List<string>(new string[]
            {
                IncorrectFileType, MissingRanges, IncorrectUEN, RestrictedIP, IncorrectAccessCode
            }).AsReadOnly();
        }

        public static class Flyweights
        {
            /// <summary>
            /// Threadsafe Empty ReadOnlyCollection of String
            /// </summary>
            public static readonly ReadOnlyCollection<string> Empty_ReadOnlyCollection_String
                = new ReadOnlyCollection<string>(new List<string>()); //why doesn't .net have something like this already?

            /// <summary>
            /// Threadsafe Empty ReadOnlyCollection of Guid  
            /// </summary>
            public static readonly ReadOnlyCollection<Guid> Empty_ReadOnlyCollection_Guid
                = new ReadOnlyCollection<Guid>(new List<Guid>());

            /// <summary>
            /// Threadsafe Empty ReadOnlyCollection of Guid  
            /// </summary>
            public static readonly ReadOnlyCollection<QnnStatusId> Empty_ReadOnlyCollection_QnnStatusId
                = new ReadOnlyCollection<QnnStatusId>(new List<QnnStatusId>());
        }

        public static class MonthlyAccessReportField
        {
            public const string Date = "Date";
            public const string UserName = "User Name";
            public const string SampleUID = "Sample UID";
            public const string SampleName = "Sample Name";
            public const string BatchJobID = "BatchJob ID";
            public const string EventType = "Event Type";
            public const string TableName = "Table Name";
            public const string FieldModified = "Field Modified";
            public const string OriginalValue = "Original Value";
            public const string NewValue = "New Value";
        }

        public static class FormAccessErrors
        {
            public const string DeploymentDisabled = "Deployment of the form being accessed is disabled.";
            public const string FormPropertiesDisabled = "Form Properties of the form being accessed is disabled.";
            public const string DeploymentDeleted = "Deployment of the form being accessed is deleted.";
            public const string SurveyNotVisible = "Survey is not visible to respondent.";
            public const string FormPropertiesDeleted = "Form properties of the form being accessed is deleted";
            public const string NotOnlineForm = "The form being accessed is not an online form";
            public const string InvalidSample = "Current respondent is not listed in sample list of the form being accessed.";
            public const string NotInFormProperties = "The form being accessed is not listed in form properties";
            public const string UnauthorizedSurveyDeletegate = "Invalid survey access without valid delegation access code";
        }

        /// <summary>
        /// Constants related to the anonymous sample
        /// </summary>
        public static class SwzAnonymous
        {
            /// <summary>
            /// Well-known fixed Id for swzanonymous in QNN_SAMPLE table
            /// (If create it with a different it will break things that expect this specific id, so dont do that)
            /// </summary>
            public static readonly Guid SampleId = Guid.Parse("87BEA0A3-DB44-4B66-9F16-D2036722C5C5"); 

            /// <summary>
            /// UID of the anonymous sample
            /// </summary>
            public const string Uid = "swzanonymous";
            
            public const string Password = "exJI0xoVTpMlEMFCxDB4";

            /// <summary>
            /// Name of cookie that holds anonymous id (used to retrieve draft answers etc)
            /// </summary>
            public const string AnonymousIdCookie = "AnonymousId";
        }

        /// <summary>
        /// Central place to define which comparer should be used for certain operations.
        /// Instead of directly referencing StringComparer.OrdinalIgnoreCase or StringComparer.InvariantCultureIgnoreCase
        /// use one of the references here to make the intent explicit in the code and standardise which is used.
        /// See also: https://learn.microsoft.com/en-us/dotnet/standard/base-types/best-practices-strings#choosing-a-stringcomparison-member-for-your-method-call
        /// For Equals comparisons you can use a comparer too, e.g.: 
        ///     Constants.Comparers.AliasCaseInsensitive.Equals("UID", h)
        /// And if you want to check filename extensions:
        ///     Constants.Comparers.ObjectNameCaseInsensitive.Equals(Path.GetExtension(uploadedFile.Name),".csv")
        /// </summary>
        public static class Comparers
        {
            /// <summary>
            /// (StringComparer.OrdinalIgnoreCase) The comparer to use for general case-insensitive comparison 
            /// of the names of objects, for instance filenames, column names, table names, etc
            /// (Note that for Alias you should use the AliasCaseInsensitive constant and for sample UID use UidCaseInsensitive)
            /// </summary>
            public static readonly StringComparer ObjectNameCaseInsensitive = StringComparer.OrdinalIgnoreCase;

            public static readonly StringComparer ObjectNameCaseSensitive = StringComparer.Ordinal;

            /// <summary>
            /// (OrdinalIgnoreCase) The case-insenstive string comparer to be used for comparing Sample UIDs. 
            /// This is defined here in constants so we can easily remember to use the right one for Uids 
            /// (as most other things use the InvariantCultureIgnoreCase instead).
            /// So you should use this reference instead of directly using StringComparer.OrdinalIgnoreCase
            /// (As of 20240716 many places still directly use StringComparer.OrdinalIgnoreCase. 
            /// Do update such cases you come across.)
            /// </summary>
            public static readonly StringComparer UidCaseInsensitive = ObjectNameCaseInsensitive;

            /// <summary>
            /// While alias are case-sensitive in the form (due to their need to be JS properties) many places such
            /// as pre-population treat them in a case-insensitive manner. This is the comparer they should use for
            /// that to be consistent.
            /// </summary>
            public static readonly StringComparer AliasCaseInsensitive = StringComparer.InvariantCultureIgnoreCase; //TODO - this should use CaseInsensitiveObjectName too (but that is a change so need to retest)
        }

        /// <summary>
        /// Content-Type definitions for some file types used in SurveyPlus, note that in some cases these differ from standard
        /// Where applicable, you should prefer to use values from System.Net.Mime.MediaTypeNames
        /// TODO - look to removing some of these where callers can use MediaTypeNames instead
        /// </summary>
        public static class ContentTypes
        {
            public const string PdfFileType = "application/pdf";

            /// <summary>
            /// This is defined as application/vnd.ms-excel
            /// Probably you should instead use System.Net.Mime.MediaTypeNames.Text.Csv
            /// </summary>
            public const string CsvFileType = "application/vnd.ms-excel";

            public const string ZipFileType = "application/zip";
            public const string SevenZipFileType = "application/x-7z-compressed";
            public const string XlsxFileType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            public const string TextFileType = "text/plain";
            public const string HtmlFileType = "text/html";
            public const string UnknownApplicationType = "application/unknown";
        }

        /// <summary>
        /// Additional properties included with survey response data by the SurveyResponseReader and SurveyResponseUpdater
        /// or for submission from clientside
        /// </summary>
        public static class SurveyResponseProperties
        {
            public const string SurveyResponseVersion = "surveyResponseVersion";
            public const string Success = "success";
            public const string FormIsReadOnly = "formIsReadOnly";
            public const string IsCleared = "isCleared";
            public const string Validation = "validation";
            public const string PrePopulatedFields = "prePopulatedFields";
            public const string IsComplete = "isComplete";
            public const string IsStrataFilled = "isStrataFilled";
            public const string SurveyRedirect = "surveyRedirect";
            public const string QnnRespId = "qnnRespId"; //TODO - why does clientside need this?
            public const string IsSurvey = "isSurvey";
            public const string SurveyRedirectUrl = "surveyRedirectUrl";
            public const string UrlFilter = "urlFilter";
            public const string LastSavedPage = "LastSavedPage";
        }

    }//end of Constants
}