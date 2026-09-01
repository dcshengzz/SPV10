--Remove IntegrationApiKey from dwAppSettings
DELETE FROM dwAppSettings WHERE NAME='IntegrationApiKey' AND GroupName='Application settings';
