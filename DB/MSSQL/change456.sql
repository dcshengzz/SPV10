-- Will DELETE existing row(s) in dwMetadata for the following:
-- SurveyResponseReport.json
-- SurveyResponseReport-settings.json
-- SurveyResponseReport-code.js

DELETE FROM [dwMetadata] WHERE [FileName]='SurveyResponseReport.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='SurveyResponseReport-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='SurveyResponseReport-code.js' AND [Folder]='metadata/forms';

