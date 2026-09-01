
IF NOT EXISTS (SELECT TOP 1 1 FROM [dwSecurityRole] WHERE [Code] = 'DatahubAdmin')
BEGIN
	PRINT('Adding new role "DatahubAdmin"...');
	INSERT INTO [dwSecurityRole] ([Code], [Name], [Comment], [Id], [DomainGroup]) VALUES ('DatahubAdmin','DatahubAdmin', NULL, NEWID(), NULL);
END