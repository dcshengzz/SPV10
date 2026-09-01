--Remove settings used for the removed stored procedure spSP_GetRespAnsWithDetails

PRINT('Removing obsolete dwAppSetting "spSP_GetRespAnsWithDetails.Timeout');
DELETE FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsWithDetails.Timeout' AND [GroupName]='Performance';

PRINT('Removing obsolete dwAppSetting "spSP_GetRespAnsWithDetails.Retries');
DELETE FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsWithDetails.Retries' AND [GroupName]='Performance';

PRINT('Removing obsolete dwAppSetting "spSP_GetRespAnsWithDetails.RetryDelay');
DELETE FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsWithDetails.RetryDelay' AND [GroupName]='Performance';

PRINT('Removing obsolete dwAppSetting "spSP_GetRespAnsWithDetails.BatchSize');
DELETE FROM dwAppSettings WHERE [Name]='spSP_GetRespAnsWithDetails.BatchSize' AND [GroupName]='Performance';