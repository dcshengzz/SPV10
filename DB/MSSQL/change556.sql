-- Remove obsolete statement-level retry configurations for the following procedures:
--  spSP_InsertResp
--  spSP_UpdateResp
--  spSP_DeleteAllRespAnsByRespId
--  spSP_UpdateDplySampleInfo
--(Note that their Timeout setting remains)

DELETE FROM dwAppSettings 
	WHERE [Name] IN (
		'spSP_InsertResp.Retries', 'spSP_InsertResp.RetryDelay', 
		'spSP_UpdateResp.Retries', 'spSP_UpdateResp.RetryDelay', 
		'spSP_DeleteAllRespAnsByRespId.Retries', 'spSP_DeleteAllRespAnsByRespId.RetryDelay', 
		'spSP_UpdateDplySampleInfo.Retries', 'spSP_UpdateDplySampleInfo.RetryDelay') 
		AND [GroupName]='Performance';
