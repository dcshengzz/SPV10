--Add an AppSetting to make duration JWT Token Expiry (365 days) and JWT Renewal Token Expiry (365 + 14 days) configurable

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'JwtSessionTokenExpiry')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('JwtSessionTokenExpiry','525600','Security','JWT Session Token Expiration Date in minutes',15,'0',0);
ELSE
	PRINT 'JwtSessionTokenExpiry already exists';


IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'JwtRenewalTokenExpiry')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('JwtRenewalTokenExpiry','545760','Security','JWT Renewal Token Expiration Date in minutes',16,'0',0);
ELSE
	PRINT 'JwtRenewalTokenExpiry already exists';
