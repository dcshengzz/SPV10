--EnableGoogleAuthenticator has moved to appsettings.json as Clover:IsEnableGoogleAuthenticator
--This is the legacy GA 1FA support
DELETE FROM dwAppSettings WHERE Name='EnableGoogleAuthenticator' AND GroupName='Security';
