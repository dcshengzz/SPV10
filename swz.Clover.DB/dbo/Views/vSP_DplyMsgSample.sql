
-----------------------------
CREATE VIEW [dbo].[vSP_DplyMsgSample] AS 
	SELECT 
		s.Name, 
		s.UID, 
		ms.EmailSentDate,
		COALESCE(ms.ToEmails,'(Not recorded)') AS ToEmails,
		COALESCE(ms.CcEmails,'(Not recorded)') AS CcEmails,
		ms.Id, 
		ms.DplyMsgId, 
		ms.ListSampleId 
	FROM
		QNN_DPLY_MSG_SAMPLE ms
		INNER JOIN QNN_LIST_SAMPLE ls ON ls.Id=ms.ListSampleId
		INNER JOIN QNN_SAMPLE s ON ls.SampleId=s.Id
