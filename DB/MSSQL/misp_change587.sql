-- MISP-Specific values for SurveyResponseUpdater.DataEditorResubmitPolicy, SurveyResponseUpdater.RespondentResubmitPolicy

UPDATE dwAppSettings SET [Value]='Block' WHERE [Name]='SurveyResponseUpdater.DataEditorResubmitPolicy' AND [GroupName]='Application Settings';
UPDATE dwAppSettings SET [Value]='SaveOnly' WHERE [Name]='SurveyResponseUpdater.RespondentResubmitPolicy' AND [GroupName]='Application Settings';
