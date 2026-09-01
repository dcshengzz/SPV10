-- Disable the procedure-level retry logic for the following procedures:
--   spSP_DeleteAllRespAnsByRespId
--   spSP_UpdateResp
--   spSP_InsertResp
--   spSP_UpdateDplySampleInfo

UPDATE 
	dwAppSettings
SET
	[Value] = '0'
WHERE
	[GroupName] = 'Performance'
	AND [Name] IN (
		'spSP_DeleteAllRespAnsByRespId.Retries',
		'spSP_UpdateResp.Retries',
		'spSP_InsertResp.Retries',
		'spSP_UpdateDplySampleInfo.Retries',
		
		'spSP_DeleteAllRespAnsByRespId.RetryDelay',
		'spSP_UpdateResp.RetryDelay',
		'spSP_InsertResp.RetryDelay',
		'spSP_UpdateDplySampleInfo.RetryDelay')
;