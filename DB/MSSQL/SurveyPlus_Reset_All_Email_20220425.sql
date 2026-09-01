/*
	RESET / CLEAR EMAIL ADDRESSES
	This script last updated 2022-04-25
	Will clear or reset to a placeholder email addresses in the database.
	This may be used to ensure there aren't external email addresses still configured in the installation.

	Before use, please set an appropriate placeholder email
*/
BEGIN TRAN T1 WITH MARK 'Updating email addresses in the db';

	/* For things requiring an email, use this address.
	   Can't leave it blank as some functionality expects to have an address */
	DECLARE @PlaceholderEmail AS VARCHAR(256) = 'zaphod_beeblebrox@example.com';

	/* Update those emails configured in the appSettings. This DOES NOT include the MailServerLogin name. */
	UPDATE dwAppSettings SET [Value]=@PlaceholderEmail WHERE [Name] IN ('HostEmails','UserDormancyReportEmails');
	
	/* Update the mail merge records to use placeholder or blank email, including as sender address */
	UPDATE QNN_DPLY_SCHEDULER SET EmailRecipients=@PlaceholderEmail WHERE EmailRecipients IS NOT NULL AND EmailRecipients <> '';
	UPDATE QNN_DPLY_MSG SET EmailCC='', EmailBCC='', EmailFrom=@PlaceholderEmail;
	UPDATE QNN_GLOBAL_MSG SET EmailCC='', EmailBCC='', EmailFrom=@PlaceholderEmail;

	/* Make the delegation records use the placeholder email (ie: redact whatever address it used to have) */
	UPDATE QNN_RESP_DELEGATION SET Email=@PlaceholderEmail;

	/* Make all intranet users use the placeholder email */
	UPDATE dwSecurityUser SET [Email]=@PlaceholderEmail;

	/* Make all respondents with an email use the placeholder email instead */
	UPDATE QNN_TRK_LIST_SAMPLE SET Email=@PlaceholderEmail WHERE Email IS NOT NULL AND Email <> '';
	UPDATE QNN_SAMPLE SET Email=@PlaceholderEmail WHERE Email IS NOT NULL AND Email <> '';

COMMIT;
