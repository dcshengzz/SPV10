-- Create new settings:
--   AutosaveDelay (with default 3)
--   AutosaveEnabled (with default true)


IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='AutosaveDelay')
BEGIN
	PRINT('Adding new dwAppSetting "AutosaveDelay"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'AutosaveDelay',
			'3',
			'Application settings',
			'Autosave Delay (Whole Seconds)',
			5,
			0,
			0);
END
ELSE
	PRINT('dwAppSetting "AutosaveDelay" already exists, skipping creation');

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='AutosaveEnabled')
BEGIN
	PRINT('Adding new dwAppSetting "AutosaveEnabled"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'AutosaveEnabled',
			'True',
			'Application settings',
			'Enable Autosave',
			4,
			'checkbox',
			0);
END
ELSE
	PRINT('dwAppSetting "AutosaveEnabled" already exists, skipping creation');