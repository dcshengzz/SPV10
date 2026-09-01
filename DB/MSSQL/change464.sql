-- Create new setting:
--   ResponseExport.CSV.Bom (with default 1)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='ResponseExport.CSV.Bom')
BEGIN
	PRINT('Adding new dwAppSetting "ResponseExport.CSV.Bom"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'ResponseExport.CSV.Bom',
			'false',
			'Response Export',
			'Add UTF-8 BOM to CSV',
			2,
			'checkbox',
			0);
END
ELSE
	PRINT('dwAppSetting "ResponseExport.CSV.Bom" already exists, skipping creation');