
-- Separate JWT token expiry settings for respondent and 3pa. 

-- Remove the old Jwt Expiry Setting.
IF EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'JwtSessionTokenExpiry')
	DELETE FROM dwAppSettings WHERE [Name] = 'JwtSessionTokenExpiry'

IF EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'JwtRenewalTokenExpiry')
	DELETE FROM dwAppSettings WHERE [Name] = 'JwtRenewalTokenExpiry'



-- Add Respondent Jwt token exiry default settings.
-- SessionTokenExpiry : 365 days
-- RenewaTokenExpiry : 365 + 14 days

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'RespJwtSessionTokenExpiry')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('RespJwtSessionTokenExpiry','525600','Security','Respondent JWT Session Token Expiration Date in minutes',15,'0',0);
ELSE
	PRINT 'RespJwtSessionTokenExpiry already exists';


IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'RespJwtRenewalTokenExpiry')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('RespJwtRenewalTokenExpiry','545760','Security','Respondent JWT Renewal Token Expiration Date in minutes',16,'0',0);
ELSE
	PRINT 'RespJwtRenewalTokenExpiry already exists';
	
	
	
	
-- Add 3PA Jwt token exiry default settings.
-- SessionTokenExpiry : 365 days
-- RenewaTokenExpiry : 365 + 14 days

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = '3PAJwtSessionTokenExpiry')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('3PAJwtSessionTokenExpiry','525600','Security','3PA JWT Session Token Expiration Date in minutes',17,'0',0);
ELSE
	PRINT '3PAJwtSessionTokenExpiry already exists';


IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = '3PAJwtRenewalTokenExpiry')
	INSERT INTO dwAppSettings 
		([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
	VALUES
		('3PAJwtRenewalTokenExpiry','545760','Security','3PA JWT Renewal Token Expiration Date in minutes',18,'0',0);
ELSE
	PRINT '3PAJwtRenewalTokenExpiry already exists';