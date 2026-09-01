IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'StructDivisionId'
          AND Object_ID = Object_ID(N'dwUploadedFiles'))
BEGIN
	PRINT 'Updating table [dwUploadedFiles] with column [StructDivisionId]';

	ALTER TABLE [dwUploadedFiles] ADD [StructDivisionId] UNIQUEIDENTIFIER;

	EXEC('UPDATE f SET f.[StructDivisionId] = u.[StructDivisionId] FROM [dwUploadedFiles] f INNER JOIN [dwSecurityUser] u ON u.[Name] = f.[CreatedBy] AND f.[StructDivisionId] IS NULL;');

	EXEC('UPDATE [dwUploadedFiles] SET [StructDivisionId] = (SELECT [Id] FROM [StructDivision] WHERE [Name] = ''[System Default]'') WHERE [StructDivisionId] IS NULL AND [CreatedBy] IS NOT NULL;');

	EXEC('UPDATE [dwUploadedFiles] SET [StructDivisionId] = (SELECT CAST(0x0 AS UNIQUEIDENTIFIER)) WHERE [StructDivisionId] IS NULL AND [CreatedBy] IS NULL;');
	
	ALTER TABLE [dwUploadedFiles] ADD CONSTRAINT [DF_dwUploadedFiles_StructDivisionId] DEFAULT '00000000-0000-0000-0000-000000000000' FOR [StructDivisionId];
END
ELSE
BEGIN
	PRINT 'Reupdating table [dwUploadedFiles] with column [StructDivisionId]';

	IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE [name] ='DF_dwUploadedFiles_StructDivisionId' AND parent_object_id = Object_ID(N'dwUploadedFiles'))
	BEGIN
		ALTER TABLE [dwUploadedFiles] DROP CONSTRAINT [DF_dwUploadedFiles_StructDivisionId];
	END

	ALTER TABLE [dwUploadedFiles] DROP COLUMN [StructDivisionId];
	
	EXEC('ALTER TABLE [dwUploadedFiles] ADD [StructDivisionId] UNIQUEIDENTIFIER;');

	EXEC('UPDATE f SET f.[StructDivisionId] = u.[StructDivisionId] FROM [dwUploadedFiles] f INNER JOIN [dwSecurityUser] u ON u.[Name] = f.[CreatedBy] AND f.[StructDivisionId] IS NULL;');

	EXEC('UPDATE [dwUploadedFiles] SET [StructDivisionId] = (SELECT [Id] FROM [StructDivision] WHERE [Name] = ''[System Default]'') WHERE [StructDivisionId] IS NULL AND [CreatedBy] IS NOT NULL;');
	
	EXEC('UPDATE [dwUploadedFiles] SET [StructDivisionId] = (SELECT CAST(0x0 AS UNIQUEIDENTIFIER)) WHERE [StructDivisionId] IS NULL AND [CreatedBy] IS NULL;');
	
	EXEC('ALTER TABLE [dwUploadedFiles] ADD CONSTRAINT [DF_dwUploadedFiles_StructDivisionId] DEFAULT ''00000000-0000-0000-0000-000000000000'' FOR [StructDivisionId];')
END

