--QNN_DPLY_SAMPLE_INFO index fill factors
--Change fill factor to 80 (and rebuild) the following:
-- PK_QNN_DPLY_SAMPLE_INFO
-- IDX_ListSampleId
-- IDX_DplyId
-- IDX_Status

-- If the table has huge amounts of data this may take some time. Best performed during system downtime.

DECLARE @old_pk_qnn_dply_sample_info BIT;
SELECT @old_pk_qnn_dply_sample_info=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_DPLY_SAMPLE_INFO' 
		AND si.Name='PK_QNN_DPLY_SAMPLE_INFO' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @new_pk_qnn_dply_sample_info BIT;
SELECT @new_pk_qnn_dply_sample_info=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_DPLY_SAMPLE_INFO' 
		AND si.Name='PK_QNN_DPLY_SAMPLE_INFO' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=80)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

IF(@old_pk_qnn_dply_sample_info=1)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Rebuilding PK_QNN_DPLY_SAMPLE_INFO with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [PK_QNN_DPLY_SAMPLE_INFO] ON [QNN_DPLY_SAMPLE_INFO] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding IDX_ListSampleId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_ListSampleId] ON [QNN_DPLY_SAMPLE_INFO] REBUILD WITH (FILLFACTOR = 80);

	RAISERROR ('Rebuilding IDX_DplyId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_DplyId] ON [QNN_DPLY_SAMPLE_INFO] REBUILD WITH (FILLFACTOR = 80);
	
	RAISERROR ('Rebuilding IDX_Status with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_Status] ON [QNN_DPLY_SAMPLE_INFO] REBUILD WITH (FILLFACTOR = 80);
END
ELSE
BEGIN
	IF(@new_pk_qnn_dply_sample_info=1)
	BEGIN
		--Do note that the above condition is just a heuristic
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
	ELSE
	BEGIN
		--Unexpected situation, requires dba to check and decide how to proceed.
		--Get sone diagnostic info. Go see the results window for this.
		SELECT 
			si.Name, 
			si.type_desc, 
			si.is_unique, 
			si.is_primary_key,
			si.fill_factor
		FROM 
			sys.indexes si 
			JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE 
			so.Name='QNN_DPLY_SAMPLE_INFO';

		SELECT 
			@old_pk_qnn_dply_sample_info AS old_pk_qnn_resp, 
			@new_pk_qnn_dply_sample_info AS new_pk_qnn_resp
		;

		RAISERROR ('The objects in QNN_DPLY_SAMPLE_INFO are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END