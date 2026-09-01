-- Create new settings:
--   spSP_GetListSampleProps.Timeout (with default 30)
--   spSP_GetListSampleProps.Retries (with default 3)
--   spSP_GetListSampleProps.RetryDelay (with default 20)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetListSampleProps.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetListSampleProps.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetListSampleProps.Timeout',
			'30',
			'Performance',
			'GetListSampleProps - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetListSampleProps.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetListSampleProps.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetListSampleProps.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetListSampleProps.Retries',
			'3',
			'Performance',
			'GetListSampleProps - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetListSampleProps.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetListSampleProps.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetListSampleProps.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetListSampleProps.RetryDelay',
			'20',
			'Performance',
			'GetListSampleProps - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetListSampleProps.RetryDelay" already exists, skipping creation');