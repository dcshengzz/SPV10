-- Create the GetRespAnsWithDetailsTake dwAppSetting

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='GetRespAnsWithDetailsTake')
BEGIN
	PRINT('Adding new dwAppSetting "GetRespAnsWithDetailsTake"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'GetRespAnsWithDetailsTake',
			'300',
			'Performance',
			'Response Export Query Batch Size',
			0,
			0,
			0);
END
ELSE
	PRINT('dwAppSetting "GetRespAnsWithDetailsTake" already exists, skipping creation');