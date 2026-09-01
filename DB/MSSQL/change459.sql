-- Create new settings:
--   spSP_GetResponseSampleInfo.Timeout (with default 60)
--   spSP_GetResponseSampleInfo.Retries (with default 5)
--   spSP_GetResponseSampleInfo.RetryDelay (with default 15)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetResponseSampleInfo.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetResponseSampleInfo.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetResponseSampleInfo.Timeout',
			'60',
			'Performance',
			'GetResponseSampleInfo - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetResponseSampleInfo.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetResponseSampleInfo.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetResponseSampleInfo.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetResponseSampleInfo.Retries',
			'5',
			'Performance',
			'GetResponseSampleInfo - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetResponseSampleInfo.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetResponseSampleInfo.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetResponseSampleInfo.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetResponseSampleInfo.RetryDelay',
			'15',
			'Performance',
			'GetResponseSampleInfo - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetResponseSampleInfo.RetryDelay" already exists, skipping creation');