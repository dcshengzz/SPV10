

-----------------------------
CREATE VIEW [dbo].[vSP_GlobalMsgSample] AS 
	SELECT 
		s.Name, 
		s.UID, 
		COALESCE(gms.ToEmails,'(Not recorded)') AS ToEmails,
		COALESCE(gms.CcEmails,'(Not recorded)') AS CcEmails,
		gms.EmailSentDate, 
		gms.Id, 
		gms.GlobalMsgId 
	FROM 
		QNN_GLOBAL_MSG_SAMPLE gms
		INNER JOIN QNN_SAMPLE s on gms.SampleId = s.Id;