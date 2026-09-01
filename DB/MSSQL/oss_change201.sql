
IF NOT EXISTS (SELECT TOP 1 1 FROM [dwSecurityRole] WHERE [Code] = 'HelpEditor')
BEGIN
	PRINT('Adding new role "HelpEditor"...');
	INSERT INTO [dwSecurityRole] ([Code], [Name], [Comment], [Id], [DomainGroup]) VALUES ('HelpEditor','HelpEditor', NULL, NEWID(), NULL);
	
	IF EXISTS (SELECT TOP 1 1 FROM [dwSecurityPermission] WHERE [GroupId] = (SELECT [Id] FROM [dwSecurityPermissionGroup] WHERE [Code] = 'Content') AND [Code] = 'View')
	BEGIN
		PRINT('Adding new permission "Content" > "View" to role "HelpEditor"...');
		INSERT INTO [dwSecurityRoleToSecurityPermission] ([Id], [SecurityRoleId], [SecurityPermissionId], [AccessType]) VALUES (NEWID(), 
		(SELECT [Id] FROM [dwSecurityRole] WHERE [Code] = 'HelpEditor'), 
		(SELECT [Id] FROM [dwSecurityPermission] WHERE [GroupId] = (SELECT [Id] FROM [dwSecurityPermissionGroup] WHERE [Code] = 'Content') AND [Code] = 'View'),1);
	
	END
	
	IF EXISTS (SELECT TOP 1 1 FROM [dwSecurityPermission] WHERE [GroupId] = (SELECT [Id] FROM [dwSecurityPermissionGroup] WHERE [Code] = 'Content') AND [Code] = 'Edit')
	BEGIN
		PRINT('Adding new permission "Content" > "Edit" to role "HelpEditor"...');
		INSERT INTO [dwSecurityRoleToSecurityPermission] ([Id], [SecurityRoleId], [SecurityPermissionId], [AccessType]) VALUES (NEWID(), 
		(SELECT [Id] FROM [dwSecurityRole] WHERE [Code] = 'HelpEditor'), 
		(SELECT [Id] FROM [dwSecurityPermission] WHERE [GroupId] = (SELECT [Id] FROM [dwSecurityPermissionGroup] WHERE [Code] = 'Content') AND [Code] = 'Edit'),1);
	
	END
END

PRINT('Removing new permission "Content" from role "SurveyAdmin"...');
DELETE FROM [dwSecurityRoleToSecurityPermission] WHERE [SecurityRoleId] = (SELECT [Id] FROM [dwSecurityRole] WHERE [Code] = 'SurveyAdmin') AND [SecurityPermissionId] IN (SELECT [Id] FROM [dwSecurityPermission] WHERE [GroupId] = (SELECT [Id] FROM [dwSecurityPermissionGroup] WHERE [Code] = 'Content'));
