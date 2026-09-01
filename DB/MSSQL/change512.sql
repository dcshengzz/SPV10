-- Will DELETE existing row(s) in dwMetadata for the following:
-- dplyImputation.json
-- dplyImputation-settings.json
-- dplyImputation-code.js
-- SwzDataEditor.json
-- SwzDataEditor-settings.json
-- SwzDataEditorList.json
-- SwzDataEditorList-settings.json
-- test.json
-- test-settings.json
-- TestForm.json
-- TestForm-settings.json
-- TestForm-code.js

DELETE FROM [dwMetadata] WHERE [FileName]='dplyImputation.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='dplyImputation-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='dplyImputation-code.js' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='SwzDataEditor.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='SwzDataEditor-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='SwzDataEditorList.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='SwzDataEditorList-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='test.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='test-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='TestForm.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='TestForm-settings.json' AND [Folder]='metadata/forms';

DELETE FROM [dwMetadata] WHERE [FileName]='TestForm-code.js' AND [Folder]='metadata/forms';

