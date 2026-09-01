using System;

namespace swz.Clover.Core.Utils
{
    /// <summary>
    /// Clover Core Constants
    /// </summary>
    public static class Constants
    {
        public const string PagingColumnName = "pagingrownumber";
        public const string AuditTable = "AuditLog";
		public const string DownloadString = "/data/download/";

        public static class StoredProcedure
        {
            public const string InsertAuditLog = "InsertAuditLog";
        }

        public static class Role
        {
            public const string UserAdmin = "UserAdmin";
            public const string Admins = "Admins";
            public const string AuditAdmin = "AuditAdmin";
            public const string HelpEditor = "HelpEditor";
        }
        /// <summary>
        /// Well-known properties in dwUploadedFiles Properties json
        /// (SurveyPlus Clover Core)
        /// </summary>
        public static class FileProperties
        {
            public const string Name = "Name";
            public const string Length = "Length";
            public const string ContentType = "ContentType";
            public const string IsLocalStorage = "IsLocalStorage";
            public const string CreatedBy = "CreatedBy";
            public const string CreatedDate = "CreatedDate";
            public const string UpdatedBy = "UpdatedBy";
            public const string UpdatedDate = "UpdatedDate";
            public const string IsDownloadable = "IsDownloadable";
        }

        /// <summary>
        /// Columns in entity/table that are considered part of the Clover Core for SurveyPlus
        /// (SurveyPlus Clover Core)
        /// </summary>
        public static class FieldName
        {
            // // // // // // // // // // // // // // // // // // // //
            // These constants are intended ONLY for CORE entities   //
            // DO NOT put Application entity definitions here!       //
            // // // // // // // // // // // // // // // // // // // //

            /// <summary>
            /// Columns in dwUploadedFiles 
            /// </summary>
            public static class dwUploadedFiles
            {
                //note that application level code is maintaining its own
                //Constants.FieldName class that may duplicate some of these.

                public const string Id = "Id";
                public const string Data = "Data";
                public const string AttachmentLength = "AttachmentLength";
                public const string Used = "Used";
                public const string Name = "Name";
                public const string ContentType = "ContentType";
                public const string Properties = "Properties";
                [Obsolete] public const string IsDeleted = "IsDeleted";
                public const string CreatedBy = "CreatedBy";
                public const string CreatedDate = "CreatedDate";
                public const string UpdatedBy = "UpdatedBy";
                public const string UpdatedDate = "UpdatedDate";
                public const string IsLocalStorage = "IsLocalStorage";
                public const string StructDivisionId = "StructDivisionId";
            }

            public static class dwSecurityCredential
            {
                public const string SecurityUserId = "SecurityUserId";
                public const string AuthenticationType = "AuthenticationType";
                public const string Login = "Login";
            }

            public static class dwSecurityUser
            {
                public const string LinkedDomainLogin = "LinkedDomainLogin";
                public const string Id = "Id";
                public const string Name = "Name";
            }

            public static class dwAppSetting
            {
                public const string Name = "Name";
            }

            public static class AuditLog
            {
                public const string EventDate = "EventDate";
                public const string EventType = "EventType";
                public const string TableName = "TableName";
            }
        }
    }
}
