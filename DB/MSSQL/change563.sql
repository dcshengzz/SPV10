-- Create new setting MailServerDefaultFrom 
-- and initialise it with current value of MailServerLogin setting

IF EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='MailServerDefaultFrom')
BEGIN
	RAISERROR ('dwAppSetting "MailServerDefaultFrom" already exists, skipping creation', 0,0) WITH NOWAIT; --ok
END
ELSE
BEGIN
	DECLARE @MailServerLogin NVARCHAR(1000);
	SELECT @MailServerLogin=[Value] FROM dwAppSettings WHERE [Name]='MailServerLogin';	
	IF(@MailServerLogin IS NULL)
	BEGIN
		RAISERROR ('ERROR: Failed to find MailServerLogin setting in dwAppSettings!',16, 1); --not ok
	END
	ELSE
	BEGIN
		RAISERROR ('Adding new dwAppSetting "MailServerDefaultFrom"...', 0,0) WITH NOWAIT;
		INSERT INTO dwAppSettings (
				[Name],
				[Value],
				[GroupName],
				[ParamName], 
				[Order], 
				[EditorType], 
				[IsHidden])
			VALUES (
				'MailServerDefaultFrom',
				@MailServerLogin,
				'Mail',
				'Default From Address',
				5,
				'0',
				0);
	END
END
