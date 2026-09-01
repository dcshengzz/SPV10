
CREATE VIEW vSP_ListSampleAddress AS
	SELECT 
		ls.Id AS Id,
		s.UID,
		s.Name,
		ls.ActiveYN AS ListSampleActiveYN,
		s.ActiveYN AS SampleActiveYN,
		l.Status AS ListStatus,
		sa.ToEmails,
		sa.CcEmails,
		sa.AddressLine1,
		sa.AddressLine2,
		sa.AddressLine3,
		ls.SampleId AS SampleId,
		ls.SamplePeerId AS SamplePeerId,
		ls.ListId AS ListId
	FROM
		QNN_LIST_SAMPLE ls
		LEFT JOIN QNN_SAMPLE s ON s.Id=ls.SampleId
		LEFT JOIN QNN_LIST l ON l.Id=ls.ListId
		LEFT JOIN QNN_SAMPLE_ADDRESS sa ON sa.SampleId=s.Id AND sa.StructDivisionId=l.StructDivisionId;