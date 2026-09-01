-- Create new setting:
--   ResponseExport.CSV.Scope (with default WithResponsesOrRemarks)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='ResponseExport.CSV.Scope')
BEGIN
	PRINT('Adding new dwAppSetting "ResponseExport.CSV.Scope"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'ResponseExport.CSV.Scope',
			'WithResponsesOrRemarks',
			'Response Export',
			'Samples to include in CSV (WithResponsesOnly|WithResponsesOrRemarks|AllSamples)',
			1,
			'0',
			0);
END
ELSE
	PRINT('dwAppSetting "ResponseExport.CSV.Scope" already exists, skipping creation');