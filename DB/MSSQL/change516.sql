-- Adds an index on QNN_SAMPLE_ADDRESS.SampleId that includes columns:
-- StructDivisionId, ToEmails, CcEmails, AddressLine1, AddressLine2, AddressLine3

DECLARE @qnn_sample_address_object_id INT;
SELECT @qnn_sample_address_object_id = object_id FROM sys.objects WHERE name='QNN_SAMPLE_ADDRESS';

DECLARE @new_idx_sampleid_includes BIT;
SELECT @new_idx_sampleid_includes=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_sample_address_object_id
		AND si.Name='IDX_SampleId_includes' 
		AND si.type_desc='NONCLUSTERED'
	) THEN 1 ELSE 0 END;

IF( @new_idx_sampleid_includes=0)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Creating index IDX_SampleId_includes', 0,0) WITH NOWAIT;
	CREATE NONCLUSTERED INDEX IDX_SampleId_includes
		ON QNN_SAMPLE_ADDRESS (SampleId)
		INCLUDE (StructDivisionId, ToEmails, CcEmails, AddressLine1, AddressLine2, AddressLine3)
		WITH (FILLFACTOR=80);
END
ELSE
BEGIN
	IF(@new_idx_sampleid_includes=1)
	BEGIN
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
END
GO