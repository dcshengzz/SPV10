-- 1. Fix capitalisation of the Application Settings group
-- 2. Create new settings:
--   SurveyResponseUpdater.DataEditorResubmitPolicy  (with default Allow)
--   SurveyResponseUpdater.RespondentResubmitPolicy  (with default Allow)


BEGIN TRANSACTION add_resub_policy_setting;

IF EXISTS(SELECT 1 FROM dwAppSettings WHERE [GroupName] COLLATE SQL_Latin1_General_CP1_CS_AS = 'Application settings')
BEGIN
	PRINT('Correcting capitalisation of the Application Settings group name');
	UPDATE dwAppSettings SET [GroupName]='Application Settings' WHERE [GroupName] COLLATE SQL_Latin1_General_CP1_CS_AS = 'Application settings';
END
ELSE
BEGIN
	PRINT('Application Settings group name is already using the correct capitalisation, skipping correction');
END

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='SurveyResponseUpdater.DataEditorResubmitPolicy')
BEGIN
	PRINT('Adding new dwAppSetting "SurveyResponseUpdater.DataEditorResubmitPolicy"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'SurveyResponseUpdater.DataEditorResubmitPolicy',
			'Allow',
			'Application Settings',
			'Re-submit policy for Data Editor (Allow|Block|SaveOnly)',
			10,
			'0',
			0);
END
ELSE
BEGIN
	PRINT('dwAppSetting "SurveyResponseUpdater.DataEditorResubmitPolicy" already exists, skipping creation');
END

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='SurveyResponseUpdater.RespondentResubmitPolicy')
BEGIN
	PRINT('Adding new dwAppSetting "SurveyResponseUpdater.RespondentResubmitPolicy"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'SurveyResponseUpdater.RespondentResubmitPolicy',
			'Allow',
			'Application Settings',
			'Re-submit policy for Respondent (Allow|Block|SaveOnly)',
			10,
			'0',
			0);
END
ELSE
BEGIN
	PRINT('dwAppSetting "SurveyResponseUpdater.RespondentResubmitPolicy" already exists, skipping creation');
END

COMMIT TRANSACTION add_resub_policy_setting;