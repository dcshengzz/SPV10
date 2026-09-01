
IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'IntranetDomainAuthority') BEGIN
	PRINT('Adding record IntranetDomainAuthority to table [dbo].[dwAppSettings]');
	INSERT INTO [dbo].[dwAppSettings] ([Name] ,[Value] ,[GroupName] ,[ParamName] ,[Order] ,[EditorType] ,[IsHidden]) VALUES ('IntranetDomainAuthority', 'localhost:48800' ,'Intranet Settings' ,'Intranet Domain Authority', 0 ,0 ,0);
END
ELSE BEGIN
	PRINT('Record IntranetDomainAuthority existed in table [dbo].[dwAppSettings]');
END