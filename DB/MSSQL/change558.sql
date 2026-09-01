-- Create new settings:
--   spSP_UpdateQnnRespAns.Timeout (with default 30)

IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name]='spSP_UpdateQnnRespAns.Timeout')
BEGIN
	PRINT('Adding new dwAppSetting "spSP_UpdateQnnRespAns.Timeout"...');
	INSERT INTO dwAppSettings (
			[Name],
			[Value],
			[GroupName],
			[ParamName], 
			[Order], 
			[EditorType], 
			[IsHidden])
		VALUES (
			'spSP_UpdateQnnRespAns.Timeout',
			'30',
			'Performance',
			'UpdateQnnRespAns - Timeout (Seconds)',
			1,
			'number',
			0);
END
ELSE
	PRINT('dwAppSetting "spSP_UpdateQnnRespAns.Timeout" already exists, skipping creation');
