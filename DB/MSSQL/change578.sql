-- Replaces the setting AdditionalSMTPTestRecipients with SMTPTestRecipients
-- Initialises it based on current value of AdditionalSMTPTestRecipients prefixed with Maintenance

BEGIN TRANSACTION update_smtptestrecipients;

	DECLARE @old_additionalsmtptestrecipients BIT;
	SELECT @old_additionalsmtptestrecipients=1 FROM dwAppSettings WHERE [Name]='AdditionalSMTPTestRecipients';

	DECLARE @new_smtptestrecipients BIT;
	SELECT @new_smtptestrecipients=1 FROM dwAppSettings WHERE [Name]='SMTPTestRecipients';

	IF (@old_additionalsmtptestrecipients IS NULL AND @new_smtptestrecipients=1)
	BEGIN
		RAISERROR ('dwAppSetting "SMTPTestRecipients" already exists, skipping creation', 0,0) WITH NOWAIT; --ok
	END
	ELSE
	BEGIN
		IF(@old_additionalsmtptestrecipients=1 AND @new_smtptestrecipients IS NULL)
		BEGIN
			DECLARE @old_value NVARCHAR(1000);
			SELECT @old_value=[Value] FROM dwAppSettings WHERE [Name]='AdditionalSMTPTestRecipients';

			DECLARE @new_value NVARCHAR(1000);
			SELECT @new_value = CASE WHEN TRIM(@old_value)='' THEN 'Maintenance' ELSE CONCAT('Maintenance, ',TRIM(@old_value)) END;

			INSERT INTO dwAppSettings (
				[Name],
				[Value],
				[GroupName],
				[ParamName], 
				[Order], 
				[EditorType], 
				[IsHidden])
			VALUES (
				'SMTPTestRecipients',
				@new_value,
				'Maintenance',
				'SMTP Test Recipients (comma delimited list of email, role-code, or user-login)',
				0,
				'0',
				0);
			RAISERROR ('dwAppSetting "SMTPTestRecipients" created', 0,0) WITH NOWAIT; --ok

			DELETE FROM dwAppSettings WHERE [Name]='AdditionalSMTPTestRecipients' AND GroupName='Maintenance';
			RAISERROR ('dwAppSetting "AdditionalSMTPTestRecipients" deleted', 0,0) WITH NOWAIT; --ok
		END
		ELSE
		BEGIN
			SELECT 
				@old_additionalsmtptestrecipients AS old_additionalsmtptestrecipients,
				@new_smtptestrecipients AS new_smtptestrecipients;
			
			SELECT * FROM dwAppSettings WHERE [GroupName]='Maintenance' ORDER BY [Name];

			RAISERROR ('The values in dwAppSettings are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
						16, -- Severity.
						1 -- State.
						);
		END
	END

COMMIT TRANSACTION update_smtptestrecipients;