-- Create new settings:
--   spSP_GetRespAnsRows.Timeout (with default 20)
--   spSP_GetRespAnsRows.Retries (with default 3)
--   spSP_GetRespAnsRows.RetryDelay (with default 5)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsRows.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetRespAnsRows.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetRespAnsRows.Timeout',
			'30',
			'Performance',
			'GetRespAnsRows - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetRespAnsRows.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsRows.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetRespAnsRows.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetRespAnsRows.Retries',
			'3',
			'Performance',
			'GetRespAnsRows - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetRespAnsRows.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsRows.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetRespAnsRows.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetRespAnsRows.RetryDelay',
			'5',
			'Performance',
			'GetRespAnsRows - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetRespAnsRows.RetryDelay" already exists, skipping creation');