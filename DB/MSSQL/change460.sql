-- Create new settings:
--   spSP_GetSingleResponseData.Timeout (with default 30)
--   spSP_GetSingleResponseData.Retries (with default 3)
--   spSP_GetSingleResponseData.RetryDelay (with default 20)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetSingleResponseData.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetSingleResponseData.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetSingleResponseData.Timeout',
			'30',
			'Performance',
			'GetSingleResponseData - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetSingleResponseData.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetSingleResponseData.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetSingleResponseData.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetSingleResponseData.Retries',
			'3',
			'Performance',
			'GetSingleResponseData - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetSingleResponseData.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetSingleResponseData.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetSingleResponseData.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetSingleResponseData.RetryDelay',
			'20',
			'Performance',
			'GetSingleResponseData - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetSingleResponseData.RetryDelay" already exists, skipping creation');