-- Renames the setting UserDormancyReportEmails to UserDormancyReportRecipients
-- and updates its description to note role and login names are now supported too.
BEGIN TRANSACTION update_udrrecipients;

	DECLARE @old_userdormancyreportemails BIT;
	SELECT @old_userdormancyreportemails=1 FROM dwAppSettings WHERE [Name]='UserDormancyReportEmails';

	DECLARE @new_userdormancyreportrecipients BIT;
	SELECT @new_userdormancyreportrecipients=1 FROM dwAppSettings WHERE [Name]='UserDormancyReportRecipients';

	IF (@old_userdormancyreportemails IS NULL AND @new_userdormancyreportrecipients=1)
	BEGIN
		RAISERROR ('dwAppSetting "UserDormancyReportRecipients" already exists, skipping update', 0,0) WITH NOWAIT; --ok
	END
	ELSE
	BEGIN
		IF(@old_userdormancyreportemails=1 AND @new_userdormancyreportrecipients IS NULL)
		BEGIN
			UPDATE dwAppSettings SET 
				[Name]='UserDormancyReportRecipients' ,
				[ParamName]='Emails to receive dormancy report (comma delimited list of email, role-code, or user-login)'
			WHERE 
				[Name]='UserDormancyReportEmails' 
				AND [GroupName]='Security';

			RAISERROR ('dwAppSetting "UserDormancyReportEmails" renamed to "UserDormancyReportRecipients"', 0,0) WITH NOWAIT; --ok
		END
		ELSE
		BEGIN
			SELECT 
				@old_userdormancyreportemails AS old_additionalsmtptestrecipients,
				@new_userdormancyreportrecipients AS new_smtptestrecipients;
			
			SELECT * FROM dwAppSettings WHERE [Name] IN ('UserDormancyReportEmails','UserDormancyReportRecipients');

			RAISERROR ('The values in dwAppSettings are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
						16, -- Severity.
						1 -- State.
						);
		END
	END

COMMIT TRANSACTION update_udrrecipients;