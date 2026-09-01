--Make the index on QNN_DPLY_SAMPLE_INFO.DplyId also cover some columns useful for joining and the export query
--(Deletes IDX_DplyId and replaces it with IDX_DplyId_includes)

DECLARE @qnn_dply_sample_info_object_id INT;
SELECT @qnn_dply_sample_info_object_id = object_id FROM sys.objects WHERE name='QNN_DPLY_SAMPLE_INFO';

DECLARE @old_idx_dplyid BIT;
SELECT @old_idx_dplyid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_dply_sample_info_object_id
		AND si.Name='IDX_DplyId' 
		AND si.type_desc='NONCLUSTERED'
	) THEN 1 ELSE 0 END;

DECLARE @new_idx_dplyid_includes BIT;
SELECT @new_idx_dplyid_includes=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_dply_sample_info_object_id
		AND si.Name='IDX_DplyId_includes' 
		AND si.type_desc='NONCLUSTERED'
	) THEN 1 ELSE 0 END;

IF( @old_idx_dplyid=1 AND @new_idx_dplyid_includes=0)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Creating new index IDX_DplyId_includes for QNN_DPLY_SAMPLE_INFO', 0,0) WITH NOWAIT;
	CREATE NONCLUSTERED INDEX IDX_DplyId_includes
		ON QNN_DPLY_SAMPLE_INFO (DplyId)
		INCLUDE (ListSampleId, [Status], Remarks);

	RAISERROR ('Dropping old index IDX_DplyId on for QNN_DPLY_SAMPLE_INFO', 0,0) WITH NOWAIT;
	DROP INDEX IDX_DplyId ON QNN_DPLY_SAMPLE_INFO;	
END
ELSE
BEGIN
	IF(@old_idx_dplyid=0 AND @new_idx_dplyid_includes=1)
	BEGIN
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
	ELSE
	BEGIN
		--Unexpected situation, requires dba to check and decide how to proceed.
		--Get some diagnostic info. Go see the results window for this.
		
		SELECT 
			si.Name AS existing_index_name, 
			si.type_desc, 
			si.is_unique, 
			si.is_primary_key,
			si.fill_factor,
			si.is_unique_constraint
		FROM 
			sys.indexes si 
			WHERE si.object_id=@qnn_dply_sample_info_object_id
		;

		SELECT 
			@old_idx_dplyid AS old_idx_dplyid,
			@new_idx_dplyid_includes AS new_idx_dplyid_includes
		;

		RAISERROR ('The objects in QNN_DPLY_SAMPLE_INFO are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END
GO
