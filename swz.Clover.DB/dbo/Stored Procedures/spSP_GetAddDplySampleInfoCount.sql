

CREATE PROCEDURE [dbo].[spSP_GetAddDplySampleInfoCount]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	--Return the number of QNN_DPLY_SAMPLE_INFO that still need to be added for the deployment
	-- based on its specified list (ie: sample is in QNN_LIST_SAMPLE for the deployment's list but 
	-- it has no corresponding row in QNN_SAMPLE_INFO yet)
	SELECT COUNT(*) AS [SampleCount]
		FROM QNN_DPLY d
		LEFT JOIN QNN_LIST_SAMPLE ls ON d.ListId=ls.ListId
		LEFT JOIN QNN_DPLY_SAMPLE_INFO dlsi ON ls.Id=dlsi.ListSampleId AND dlsi.DplyId=d.Id
		WHERE dlsi.Id IS NULL
		AND d.Id = @DplyId;
END