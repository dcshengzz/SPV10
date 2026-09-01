
--The ALTER has to be the only statement in its batch
CREATE VIEW [dbo].[vSP_QnnSampleActiveForGrid] AS 
SELECT 		
	ssd.StructDivisionId AS StructDivisionId,
	sd.Name AS StructDivisionName,
	s.Id AS Id,
	s.Name AS Name,
	s.UID AS UID,
	sa.ToEmails AS ToEmails,
	sa.CcEmails AS CcEmails,
	s.ActiveYN AS ActiveYN,
	s.NumRetry AS NumRetry,
	s.LastLoginDate AS LastLoginDate,
	r.Remarks
FROM
	QNN_SAMPLE_STRUCTDIVISION ssd
	INNER JOIN QNN_SAMPLE s ON ssd.SampleId=s.Id
	INNER JOIN StructDivision sd ON ssd.StructDivisionId=sd.Id
	LEFT JOIN QNN_SAMPLE_ADDRESS sa ON (sa.SampleId=s.Id AND sa.StructDivisionId=ssd.StructDivisionId)
	LEFT JOIN QNN_SAMPLE_REMARKS r ON (r.SampleId=s.Id AND r.StructDivisionId=ssd.StructDivisionId)		
WHERE
	s.IsDeleted = 0;