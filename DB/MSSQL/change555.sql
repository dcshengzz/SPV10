-- Create new settings:
--   SurveyResponseUpdater.UpdateInPlace (with default true)
--   SurveyResponseUpdater.CheckFieldsUpdatedForQnn (with default true)
--   SurveyResponseUpdater.Retries (with default 2)
--   SurveyResponseUpdater.RetryDelay (with default 5)
--   SurveyResponseUpdater.RetryMultiplier (with default 2.0)
-- (There is no SurveyResponseUpdater.Timeout setting)

--UpdateInPlace
IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='SurveyResponseUpdater.UpdateInPlace')
BEGIN
	PRINT('Adding new dwAppSetting "SurveyResponseUpdater.UpdateInPlace"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'SurveyResponseUpdater.UpdateInPlace',
			'true',
			'Performance',
			'SurveyResponseUpdater - Update In Place',
			1,
			'checkbox',
			0);
END
ELSE
	PRINT('dwAppSetting "SurveyResponseUpdater.Retries" already exists, skipping creation');

--CheckFieldsUpdatedForQnn
IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='SurveyResponseUpdater.CheckFieldsUpdatedForQnn')
BEGIN
	PRINT('Adding new dwAppSetting "SurveyResponseUpdater.CheckFieldsUpdatedForQnn"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'SurveyResponseUpdater.CheckFieldsUpdatedForQnn',
			'true',
			'Performance',
			'SurveyResponseUpdater - Check Fields Updated for QNN',
			1,
			'checkbox',
			0);
END
ELSE
	PRINT('dwAppSetting "SurveyResponseUpdater.Retries" already exists, skipping creation');

--Retries
IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='SurveyResponseUpdater.Retries')
BEGIN
	PRINT('Adding new dwAppSetting "SurveyResponseUpdater.Retries"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'SurveyResponseUpdater.Retries',
			'2',
			'Performance',
			'SurveyResponseUpdater - Retry Limit',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "SurveyResponseUpdater.Retries" already exists, skipping creation');

--RetryDelay
IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='SurveyResponseUpdater.RetryDelay')
BEGIN
	PRINT('Adding new dwAppSetting "SurveyResponseUpdater.RetryDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'SurveyResponseUpdater.RetryDelay',
			'5',
			'Performance',
			'SurveyResponseUpdater - Base Retry Delay (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "SurveyResponseUpdater.RetryDelay" already exists, skipping creation');

--RetryDelayMultiplier
IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='SurveyResponseUpdater.RetryDelayMultiplier')
BEGIN
	PRINT('Adding new dwAppSetting "SurveyResponseUpdater.RetryDelayMultiplier"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'SurveyResponseUpdater.RetryDelayMultiplier',
			'2.0',
			'Performance',
			'SurveyResponseUpdater - Retry Delay Multiplier',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "SurveyResponseUpdater.Retries" already exists, skipping creation');
