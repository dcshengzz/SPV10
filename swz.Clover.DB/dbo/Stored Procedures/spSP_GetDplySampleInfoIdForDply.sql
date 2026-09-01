



CREATE PROCEDURE [dbo].[spSP_GetDplySampleInfoIdForDply]
	@DplyId UNIQUEIDENTIFIER
		
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		dlsi.Id AS DplySampleInfoId,
		dlsi.ListSampleId AS ListSampleId
	FROM
		QNN_DPLY_SAMPLE_INFO dlsi
	WHERE
		dlsi.DplyId=@DplyId;
END