-- Create new settings:
--   spSP_UpdateResp.Timeout (with default 20)
--   spSP_UpdateResp.Retries (with default 3)
--   spSP_UpdateResp.RetryDelay (with default 5)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_UpdateResp.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_UpdateResp.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_UpdateResp.Timeout',
			'20',
			'Performance',
			'UpdateResp - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_UpdateResp.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_UpdateResp.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_UpdateResp.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_UpdateResp.Retries',
			'3',
			'Performance',
			'UpdateResp - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_UpdateResp.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_UpdateResp.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_UpdateResp.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_UpdateResp.RetryDelay',
			'5',
			'Performance',
			'UpdateResp - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_UpdateResp.RetryDelay" already exists, skipping creation');