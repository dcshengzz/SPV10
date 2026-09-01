



--Get SampleId, UID given either a DLSI or a ListSampleId
--You only need to specify ONE of ListSampleId or DplySampleInfoId
CREATE PROCEDURE [dbo].[spSP_GetSampleIdentity]	
	@ListSampleId UNIQUEIDENTIFIER = null,
	@DplySampleInfoId UNIQUEIDENTIFIER = null		
AS
BEGIN
	SET NOCOUNT ON;
	IF(@ListSampleId IS NOT NULL)
	BEGIN
		SELECT 
			s.Id AS SampleId, 
			s.[UID] AS [UID]
		FROM 
			QNN_LIST_SAMPLE ls
			LEFT JOIN QNN_SAMPLE s ON s.Id=ls.SampleId
		WHERE
			ls.Id=@ListSampleId
		;		
	END
	ELSE IF(@DplySampleInfoId IS NOT NULL)
	BEGIN
		SELECT 
			s.Id AS SampleId, 
			s.[UID] AS [UID]
		FROM 
			QNN_DPLY_SAMPLE_INFO dsi
			LEFT JOIN QNN_LIST_SAMPLE ls ON ls.Id=dsi.ListSampleId
			LEFT JOIN QNN_SAMPLE s ON s.Id=ls.SampleId
		WHERE
			dsi.Id=@DplySampleInfoId
		;
	END
	ELSE
	BEGIN
		RAISERROR ('No parameters were provided', 16,20);
	END

END