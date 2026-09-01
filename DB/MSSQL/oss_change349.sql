--Change the description of the legacy EnableGoogleAuthenticator 1FA setting to avoid confusion in UI with new Google Authenticator 2FA
UPDATE dwAppSettings 
	SET ParamName='Use Authenticator Code instead of Password' 
	WHERE Name='EnableGoogleAuthenticator' AND ParamName='Enable Google Authenticator';
