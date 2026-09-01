-- Adds an extra covering index IDX_Id_includes on QNN_LIST_SAMPLE.Id
-- The table is already clustered on Id, so this index is duplicating a subset of that info (covering)
-- Include columns: SampleId, SamplePeerId, ListId, ActiveYN

DECLARE @qnn_list_sample_object_id INT;
SELECT @qnn_list_sample_object_id = object_id FROM sys.objects WHERE name='QNN_LIST_SAMPLE';

DECLARE @new_idx_id_includes BIT;
SELECT @new_idx_id_includes=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_list_sample_object_id
		AND si.Name='IDX_Id_includes' 
		AND si.type_desc='NONCLUSTERED'
	) THEN 1 ELSE 0 END;

IF( @new_idx_id_includes=0)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Creating new index IDX_Id_includes for QNN_LIST_SAMPLE', 0,0) WITH NOWAIT;
	CREATE NONCLUSTERED INDEX IDX_Id_includes
		ON QNN_LIST_SAMPLE (Id)
		INCLUDE (SampleId, SamplePeerId, ListId, ActiveYN)
		WITH (FILLFACTOR=80);
	
END
ELSE
BEGIN
	RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
END
GO
