
CREATE PROCEDURE [dbo].[spSP_SyncAuditSampleName]
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
		
	MERGE sy_AuditSampleName asn
	USING QNN_SAMPLE s
		ON asn.SampleId=s.Id
	WHEN MATCHED AND (asn.Name<>s.Name OR asn.UID <> s.UID) THEN
		UPDATE SET asn.Name=s.Name, asn.UID=s.UID
	WHEN NOT MATCHED THEN
		INSERT (SampleId, Name, UID) VALUES (s.Id, s.Name, s.UID);
END