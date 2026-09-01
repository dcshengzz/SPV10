--Add an AppSetting to exempt certain users from dormancy inactive check

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'UserDormancyExcludeLogins')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('UserDormancyExcludeLogins','swzadmin','Security','Logins to exempt from dormancy (comma delimited)',13,'0',0);
ELSE
	PRINT 'UserDormancyExcludeLogins already exists';
