//This was previously DefaultMetadataProvider, I tried to merge in the one from the internet side too, however it
//seems these impls arent being used. Just the support classes. So have removed the impls and left the support classes.
//For the impls, MSSQLMetadataProvider is the intranet side one but with the interface change for GetCollectionAsync .
//Copied the internet version here as ApiMetadataProvider (was named MSSQLMetadataProvider too)
namespace swz.Clover.Core.Metadata
{
    public class MetadataOperations
    {
        public const string Compile = "compile";
        public const string Load = "load";
        public const string Change = "change";
        public const string UploadLicense = "uploadlicense";
        public const string ResetAppCache = "resetappcache";
        public const string AnalyseDb = "analysedb";
        public const string LoadForm = "loadform";
        public const string LoadForms = "loadforms";
        public const string LoadLocalization = "loadlocalization";
        public const string LocalizationUpdateTemplate = "localizationupdatetemplate";
        
        public const string Workflow = "workflow";
        public const string Users = "users";
    }

    public class MetadataWorkflowOperations
    {
        public const string Load = "load";
        public const string LoadList = "loadlist";
        public const string Create = "create";
        public const string Delete = "delete";
        public const string SetState = "setstate";
        public const string SetInstanceStatus = "setinstancestatus";
        public const string SetObsolete = "setobsolete";
        public const string GetStates = "getstates";
        
    }

    public class MetadataUsersOperations
    {
        public const string Load = "load";
        public const string LoadList = "loadlist";
    }

    public enum MetadataObjectState
    {
        Unchanged = 0,
        Inserted,
        Updated,
        Deleted,
        Unknown = 255,
    }

    public class MetadataSections
    {
        public const string AppSettings = "appsettings";
        public const string Datamodel = "datamodel";
        public const string DataSync = "datasync";
        public const string Codeactions = "codeactions";
        public const string Form = "form";
        public const string FormMapping = "formmapping";
        public const string FormCode = "formcode";
        public const string CssCode = "csscode";
        public const string FilesUpload = "fileuploads";

		public const string Workflow = "workflow";

        public const string Businessflow = "businessflow";
        public const string Modules = "modules";

        public const string Users = "users";
        public const string Groups = "groups";
        public const string Roles = "roles";
        public const string Permissions = "permissions";
        
        public const string SyncData = "syncdata";
        public const string Localization = "localization";

        public const string Rule = "rule";
    }
}