-- Create new settings:
--   spSP_DeleteAllRespAnsByRespId.Timeout (with default 15)
--   spSP_DeleteAllRespAnsByRespId.Retries (with default 5)
--   spSP_DeleteAllRespAnsByRespId.RetryDelay (with default 10)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_DeleteAllRespAnsByRespId.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_DeleteAllRespAnsByRespId.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_DeleteAllRespAnsByRespId.Timeout',
			'15',
			'Performance',
			'DeleteAllRespAnsByRespId - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_DeleteAllRespAnsByRespId.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_DeleteAllRespAnsByRespId.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_DeleteAllRespAnsByRespId.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_DeleteAllRespAnsByRespId.Retries',
			'5',
			'Performance',
			'DeleteAllRespAnsByRespId - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_DeleteAllRespAnsByRespId.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_DeleteAllRespAnsByRespId.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_DeleteAllRespAnsByRespId.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_DeleteAllRespAnsByRespId.RetryDelay',
			'10',
			'Performance',
			'DeleteAllRespAnsByRespId - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_DeleteAllRespAnsByRespId.RetryDelay" already exists, skipping creation');