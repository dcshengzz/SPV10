IF NOT EXISTS (SELECT TOP 1 1 FROM [dwSecurityRole] WHERE [Code] = '3PAClient')
BEGIN
	PRINT('Adding new role "3PAClient"...');
	INSERT INTO [dwSecurityRole] ([Code], [Name], [Comment], [Id], [DomainGroup]) VALUES ('3PAClient','3PAClient', NULL, NEWID(), NULL);
END

PRINT('Removing new role "DatahubAdmin"...');
DELETE FROM [dwSecurityRole] WHERE [Code] = 'DatahubAdmin'