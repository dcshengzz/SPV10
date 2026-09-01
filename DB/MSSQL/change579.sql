-- Create new setting MonthlyAuditAccessLogRecipients 
-- Initialise it to AuditAdmin which will resolve to emails of all unlocked users holding AuditAdmin role
BEGIN TRANSACTION add_maalrecipients;

IF EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='MonthlyAuditAccessLogRecipients')
BEGIN
	RAISERROR ('dwAppSetting "MonthlyAuditAccessLogRecipients" already exists, skipping creation', 0,0) WITH NOWAIT; --ok
END
ELSE
BEGIN
	INSERT INTO dwAppSettings (
		[Name],
		[Value],
		[GroupName],
		[ParamName], 
		[Order], 
		[EditorType], 
		[IsHidden])
	VALUES (
		'MonthlyAuditAccessLogRecipients',
		'AuditAdmin',
		'Security',
		'Recipients of Monthly Audit Access Logs Report (comma delimited list of email, role-code, or user-login)',
		9,
		'0',
		0);
	RAISERROR ('dwAppSetting "MonthlyAuditAccessLogRecipients" created', 0,0) WITH NOWAIT; --ok
END

COMMIT TRANSACTION add_maalrecipients;