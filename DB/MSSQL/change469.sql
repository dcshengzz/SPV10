--Rebuilds the indexes in QNN_LIST_SAMPLE with fill factor of 80
--Specifically:
-- PK_LIST_SAMPLE
-- IDX_ListId
-- IDX_SampleId
-- IDX_SamplePeerId
-- QNN_LIST_SAMPLE_UNIQUE_SAMPLE
--Will also rename PK_LIST_SAMPLE to PK_QNN_LIST_SAMPLE

DECLARE @old_pk_list_sample BIT;
SELECT @old_pk_list_sample=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_LIST_SAMPLE' 
		AND si.Name='PK_LIST_SAMPLE' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @new_pk_qnn_list_sample BIT;
SELECT @new_pk_qnn_list_sample=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_LIST_SAMPLE' 
		AND si.Name='PK_QNN_LIST_SAMPLE' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=80)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

IF(@old_pk_list_sample=1 AND @new_pk_qnn_list_sample=0)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Rebuilding PK_LIST_SAMPLE with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [PK_LIST_SAMPLE] ON [QNN_LIST_SAMPLE] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Renaming PK_LIST_SAMPLE to PK_QNN_LIST_SAMPLE', 0,0) WITH NOWAIT;
	EXEC sp_rename N'dbo.QNN_LIST_SAMPLE.PK_LIST_SAMPLE', N'PK_QNN_LIST_SAMPLE', N'INDEX';

	RAISERROR ('Rebuilding IDX_ListId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_ListId] ON [QNN_LIST_SAMPLE] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding IDX_SampleId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_SampleId] ON [QNN_LIST_SAMPLE] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding IDX_SamplePeerId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_SamplePeerId] ON [QNN_LIST_SAMPLE] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding QNN_LIST_SAMPLE_UNIQUE_SAMPLE with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [QNN_LIST_SAMPLE_UNIQUE_SAMPLE] ON [QNN_LIST_SAMPLE] REBUILD WITH (FILLFACTOR = 80); 
END
ELSE
BEGIN
	IF(@new_pk_qnn_list_sample=1 AND @old_pk_list_sample=0)
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
			so.Name='QNN_LIST_SAMPLE';

		SELECT 
			@old_pk_list_sample AS old_pk_list_sample, 
			@new_pk_qnn_list_sample AS new_pk_qnn_list_sample
		;

		RAISERROR ('The objects in QNN_LIST_SAMPLE are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END