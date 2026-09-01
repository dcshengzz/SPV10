-- Adds dwAppSettings items for the use by the DormantUsersProcessor
-- In dev Will be configured as disabled (-1 days) by default for convenience

--UNCOMMENT FOR TESTING
--DELETE FROM dwAppSettings WHERE [Name] IN ('UserDormancyReportEmails','UserLockInactiveDays','UserLockWarnDays');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'UserDormancyReportEmails')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('UserDormancyReportEmails','','Security','Emails to receive dormancy report (comma delimited)',10,'0',0);
ELSE
	PRINT 'UserDormancyReportEmails already exists';

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'UserLockInactiveDays')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('UserLockInactiveDays','-1','Security','Days inactivity to lock (-1 to disable)',11,'0',0);
ELSE
	PRINT 'UserLockInactiveDays already exists';

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'UserLockWarnDays')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('UserLockWarnDays','-1','Security','Days inactivity to warn (-1 to disable)',12,'0',0);
ELSE
	PRINT 'UserLockWarnDays already exists';
