CREATE PROCEDURE [dbo].[spSP_GetStatusResponseDetails]
		@DplyId uniqueidentifier,
		@StatusIds nvarchar(max)  --comma delimited status Id
AS
BEGIN
	SET NOCOUNT ON;

	SELECT sample.UID AS UID, sample.Name AS Name, status.Code AS StatusCode, status.Title AS StatusTitle, dsi.Remarks AS Remarks
	FROM 
		QNN_DPLY_SAMPLE_INFO dsi
		LEFT JOIN QNN_STATUS status ON dsi.Status=status.Id
		LEFT JOIN QNN_LIST_SAMPLE listsample  ON dsi.ListSampleId=listsample.Id
		LEFT JOIN QNN_SAMPLE sample ON listsample.SampleId=sample.Id
	WHERE DplyId=@DplyId AND (@StatusIds='' OR status.Id IN( SELECT Item FROM dbo.splitIds(@StatusIds, ',')))
	ORDER BY UID ASC;

END