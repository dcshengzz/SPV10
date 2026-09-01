-- Update HostEmails description to note it only supports emails
-- Update dwAppSettings descriptions from 'role-code' to 'role' 
--     MonthlyAuditAccessLogRecipients
--     SMTPTestRecipients
--     UserDormancyReportRecipients
-- Update dwAppSettings to use checkbox EditorType for 
--     AuditOn
--     TrkListActiveYN
--     UseMetadataCache
-- Remove unused dwAppSettings for UseMetadataCache

BEGIN TRANSACTION update_settings;

-- HostEmails
UPDATE dwAppSettings 
	SET [ParamName]='Administrator Emails (comma delimited list of email)' 
	WHERE [Name]='HostEmails';

--MonthlyAuditAccessLogRecipients
UPDATE dwAppSettings 
	SET [ParamName]='Recipients of Monthly Audit Access Logs Report (comma delimited list of email, role, or user-login)' 
	WHERE [Name]='MonthlyAuditAccessLogRecipients';

--SMTPTestRecipients
UPDATE dwAppSettings 
	SET [ParamName]='SMTP Test Recipients (comma delimited list of email, role, or user-login)' 
	WHERE [Name]='SMTPTestRecipients' ;

-- UserDormancyReportRecipients
UPDATE dwAppSettings 
	SET [ParamName]='Recipients to receive dormancy report (comma delimited list of email, role, or user-login)' 
	WHERE [Name]='UserDormancyReportRecipients';

-- AuditOn
UPDATE dwAppSettings 
	SET [EditorType]='checkbox' 
	WHERE [Name]='AuditOn';

-- TrkListActiveYN
UPDATE dwAppSettings 
	SET [EditorType]='checkbox' 
	WHERE [Name]='TrkListActiveYN';

-- UseMetadataCache
DELETE FROM dwAppSettings WHERE [Name]='UseMetadataCache' AND [GroupName]='Metadata';

COMMIT TRANSACTION update_settings;