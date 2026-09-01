-- Originally created in MPA Pentest Branch

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'WhitelistedFileExt') BEGIN
	PRINT('Adding record WhitelistedFileExt to table [dbo].[dwAppSettings]');
	INSERT INTO [dbo].[dwAppSettings] ([Name] ,[Value] ,[GroupName] ,[ParamName] ,[Order] ,[EditorType] ,[IsHidden]) VALUES ('WhitelistedFileExt', 'doc,docx,xls,xlsx,csv,txt,jpg,jpeg,png,pdf' ,'File Management' ,'Whitelisted File Extenstion', 1 ,0 ,0);
END
ELSE BEGIN
	PRINT('Record WhitelistedFileExt existed in table [dbo].[dwAppSettings]');
END
