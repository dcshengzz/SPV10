


CREATE VIEW [dbo].[vSP_RespParticipation] AS
	SELECT 
		d.Id AS [Id], 
		d.StructDivisionId AS [StructDivisionId], 
		d.[Name] AS [Name], 
		s.[UID] AS [UID], 
		s.[Name] AS [RespondentName], 
		st.Id as [StatusId], 
		st.Title as [Status], 
		COALESCE(dlsi.StatusModifyOn, d.DateStart) AS [StatusDate], 
		r.Id as [RespId]
	FROM 
	QNN_DPLY_SAMPLE_INFO dlsi
	INNER JOIN QNN_DPLY d ON d.Id=dlsi.DplyId
	INNER JOIN QNN_LIST_SAMPLE ls ON ls.Id=dlsi.ListSampleId
	INNER JOIN QNN_SAMPLE s ON s.Id=ls.SampleId
	INNER JOIN QNN_STATUS st ON st.Id=dlsi.[Status]
	LEFT JOIN QNN_RESP r ON r.ListSampleId=dlsi.ListSampleId AND r.DplyId=dlsi.DplyId