


CREATE PROCEDURE [dbo].[spSP_GetListSampleUids]
	@ListId UNIQUEIDENTIFIER
		
AS
BEGIN
	SET NOCOUNT ON;

	--Get the UID and ListSampleId for samples in the specified List
	SELECT 
	ls.[Id] AS [ListSampleId],
	s.[UID]  AS [UID]	
	FROM
		QNN_LIST l
		LEFT JOIN QNN_LIST_SAMPLE  ls ON ls.ListId=l.Id
		LEFT JOIN QNN_SAMPLE s ON ls.SampleId=s.Id
	WHERE 
		l.Id=@ListId;
END