--Update indexes in QNN_SAMPLE_ADDRESS, setting a fill factor of 80
-- PK_QNN_SAMPLE_ADDRESS
-- UQ_QNN_SAMPLE_ADDRESS_SampleId_StructDivisionId

DECLARE @old_pk_qnn_sample_address BIT;
SELECT @old_pk_qnn_sample_address=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_SAMPLE_ADDRESS' 
		AND si.Name='PK_QNN_SAMPLE_ADDRESS' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @new_pk_qnn_sample_address BIT;
SELECT @new_pk_qnn_sample_address=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_SAMPLE_ADDRESS' 
		AND si.Name='PK_QNN_SAMPLE_ADDRESS' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=80)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

IF(@old_pk_qnn_sample_address=1)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Rebuilding PK_QNN_SAMPLE_ADDRESS with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [PK_QNN_SAMPLE_ADDRESS] ON [QNN_SAMPLE_ADDRESS] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding UQ_QNN_SAMPLE_ADDRESS_SampleId_StructDivisionId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [UQ_QNN_SAMPLE_ADDRESS_SampleId_StructDivisionId] ON [QNN_SAMPLE_ADDRESS] REBUILD WITH (FILLFACTOR = 80);
END
ELSE
BEGIN
	IF(@new_pk_qnn_sample_address=1)
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
			so.Name='QNN_SAMPLE_ADDRESS';

		SELECT 
			@old_pk_qnn_sample_address AS old_pk_qnn_sample_address, 
			@new_pk_qnn_sample_address AS new_pk_qnn_sample_address
		;

		RAISERROR ('The objects in QNN_SAMPLE_ADDRESS are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END







