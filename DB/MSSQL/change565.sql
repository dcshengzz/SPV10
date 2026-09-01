-- Remove all old jwt records and reset the expiry config to new default values
-- (JWT issuance logic and behaviour has been changed, the old values no longer apply)

DELETE FROM JsonWebTokens;

UPDATE dwAppSettings SET [Value]='60' WHERE [Name]='RespJwtSessionTokenExpiry';
UPDATE dwAppSettings SET [Value]='1440' WHERE [Name]='RespJwtRenewalTokenExpiry';

UPDATE dwAppSettings SET [Value]='60' WHERE [Name]='3PAJwtSessionTokenExpiry';
UPDATE dwAppSettings SET [Value]='1440' WHERE [Name]='3PAJwtRenewalTokenExpiry';
