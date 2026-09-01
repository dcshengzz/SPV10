-- Rename dwAppSetting "GetRespAnsWithDetailsTake" to 
--  spSP_GetRespAnsWithDetails.BatchSize (for reference: change451.sql set the default to 300)
-- Create additional new settings:
--   spSP_GetRespAnsWithDetails.Timeout (with default 3600)
--   spSP_GetRespAnsWithDetails.Retries (with default 5)
--   spSP_GetRespAnsWithDetails.RetryDelay (with default 15)

IF EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='GetRespAnsWithDetailsTake')
BEGIN
	IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsWithDetails.BatchSize')
	BEGIN
		PRINT('Renaming existing dwAppSetting "GetRespAnsWithDetailsTake" to "spSP_GetRespAnsWithDetails.BatchSize"');
		UPDATE dwAppSettings 
			SET 
				[Name]='spSP_GetRespAnsWithDetails.BatchSize',
				[ParamName]='Response Export Query - Batch Size',
				[Order]='1',
				[EditorType]='number'
			WHERE 
				[Name]='GetRespAnsWithDetailsTake';
	END
	ELSE BEGIN
		--Would get here if change451.sql was re-run after change452.sql had been run and 452 is now being re-run
		--We don't just delete and recreate lest the value of the setting has been adjusted already for this environment
		PRINT('Removing obsolete dwAppSetting "GetRespAnsWithDetailsTake" because replacement setting "spSP_GetRespAnsWithDetails.BatchSize" already exists');
		DELETE FROM dwAppSettings WHERE [Name]='GetRespAnsWithDetailsTake';
	END

END
ELSE
	PRINT('dwAppSetting "GetRespAnsWithDetailsTake" not found, skipping rename to "spSP_GetRespAnsWithDetails.BatchSize"');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsWithDetails.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetRespAnsWithDetails.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetRespAnsWithDetails.Timeout',
			'3600',
			'Performance',
			'Response Export Query - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetRespAnsWithDetails.Timeout" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsWithDetails.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetRespAnsWithDetails.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetRespAnsWithDetails.Retries',
			'5',
			'Performance',
			'Response Export Query - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetRespAnsWithDetails.Retries" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsWithDetails.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_GetRespAnsWithDetails.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_GetRespAnsWithDetails.RetryDelay',
			'15',
			'Performance',
			'Response Export Query - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_GetRespAnsWithDetails.RetryDelay" already exists, skipping creation');