-- Add iam ignore logins to dwAppSettings

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='IamIgnoreLogins')
BEGIN
	PRINT('Adding new dwAppSetting "IamIgnoreLogins"...');
	INSERT INTO [dbo].[dwAppSettings]
			   ([Name]
			   ,[Value]
			   ,[GroupName]
			   ,[ParamName]
			   ,[Order]
			   ,[EditorType]
			   ,[IsHidden])
		 VALUES
			   ('IamIgnoreLogins'
			   ,'swzadmin'
			   ,'Security'
			   ,'IAM/CAM Users to Ignore (comma delimited)'
			   ,19
			   ,0
			   ,0)
END
ELSE
	PRINT('dwAppSetting "IamIgnoreLogins" already exists, skipping creation');