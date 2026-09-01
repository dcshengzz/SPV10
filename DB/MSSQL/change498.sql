-- Create new settings:
--   spSP_UpdateDplySampleInfo.Timeout (with default 20)
--   spSP_UpdateDplySampleInfo.Retries (with default 3)
--   spSP_UpdateDplySampleInfo.RetryDelay (with default 5)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_UpdateDplySampleInfo.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_UpdateDplySampleInfo.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_UpdateDplySampleInfo.Timeout',
			'20',
			'Performance',
			'UpdateDplySampleInfo - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_UpdateDplySampleInfo.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_UpdateDplySampleInfo.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_UpdateDplySampleInfo.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_UpdateDplySampleInfo.Retries',
			'3',
			'Performance',
			'UpdateDplySampleInfo - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_UpdateDplySampleInfo.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_UpdateDplySampleInfo.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_UpdateDplySampleInfo.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_UpdateDplySampleInfo.RetryDelay',
			'5',
			'Performance',
			'UpdateDplySampleInfo - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_UpdateDplySampleInfo.RetryDelay" already exists, skipping creation');