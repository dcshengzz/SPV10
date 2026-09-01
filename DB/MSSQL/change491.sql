-- Create new settings:
--   spSP_InsertResp.Timeout (with default 20)
--   spSP_InsertResp.Retries (with default 3)
--   spSP_InsertResp.RetryDelay (with default 5)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_InsertResp.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_InsertResp.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_InsertResp.Timeout',
			'20',
			'Performance',
			'InsertResp - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_InsertResp.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_InsertResp.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_InsertResp.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_InsertResp.Retries',
			'3',
			'Performance',
			'InsertResp - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_InsertResp.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_InsertResp.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_InsertResp.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_InsertResp.RetryDelay',
			'5',
			'Performance',
			'InsertResp - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_InsertResp.RetryDelay" already exists, skipping creation');