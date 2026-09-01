
IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'StructDivisionId'
          AND Object_ID = Object_ID(N'dwUploadedFiles'))
BEGIN
	PRINT 'Updating table [dwUploadedFiles] with column [StructDivisionId]';

	ALTER TABLE [dwUploadedFiles] ADD [StructDivisionId] UNIQUEIDENTIFIER;

	EXEC('UPDATE f SET f.[StructDivisionId] = u.[StructDivisionId] FROM [dwUploadedFiles] f INNER JOIN [dwSecurityUser] u ON u.[Name] = f.[CreatedBy] AND f.[StructDivisionId] IS NULL;');

	EXEC('UPDATE [dwUploadedFiles] SET [StructDivisionId] = (SELECT [Id] FROM [StructDivision] WHERE [Name] = ''[System Default]'') WHERE [StructDivisionId] IS NULL;');
	
END
ELSE
BEGIN
	PRINT 'Column [StructDivisionId] already updated in table [dwUploadedFiles]';
END

