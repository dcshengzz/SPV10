--Index updates in QNN_SAMPLE
--Rename the SQL Server assigned name for the PK index to PK_QNN_SAMPLE
--Remove IDX_UID as it duplicates Unique_UID
--Rebuild IDX_NumberId
--Change fill factor on some indexes in QNN_SAMPLE, specifically:
-- PK_QNN_SAMPLE 80%
-- IDX_Name 90%
-- Unique_UID 90%

DECLARE @PkClusteredIndexName NVARCHAR(MAX);
SELECT @PkClusteredIndexName=CONCAT('dbo.QNN_SAMPLE.',si.Name)
		FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_SAMPLE' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
		AND si.is_primary_key=1;

DECLARE @new_pk_qnn_sample BIT;
SELECT @new_pk_qnn_sample=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_SAMPLE' 
		AND si.Name='PK_QNN_SAMPLE' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=80)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @old_idx_uid BIT;
SELECT @old_idx_uid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_SAMPLE' 
		AND si.Name='IDX_UID' 
		AND si.type_desc='NONCLUSTERED' 
		AND si.is_unique=1
	) THEN 1 ELSE 0 END;

IF(@PkClusteredIndexName IS NOT NULL AND @old_idx_uid=1 AND @new_pk_qnn_sample=0)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Removing IDX_UID', 0,0) WITH NOWAIT;
	DROP INDEX [IDX_UID] ON QNN_SAMPLE;

	RAISERROR ('Renaming clustered index %s to PK_QNN_SAMPLE', 0,0, @PkClusteredIndexName) WITH NOWAIT;
	EXEC sp_rename @PkClusteredIndexName, N'PK_QNN_SAMPLE', N'INDEX';

	RAISERROR ('Rebuilding PK_QNN_SAMPLE with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [PK_QNN_SAMPLE] ON [QNN_SAMPLE] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding Unique_UID with FILLFACTOR 90', 0,0) WITH NOWAIT;
	ALTER INDEX [Unique_UID] ON [QNN_SAMPLE] REBUILD WITH (FILLFACTOR = 90);

	RAISERROR ('Rebuilding IDX_Name with FILLFACTOR 90', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_Name] ON [QNN_SAMPLE] REBUILD WITH (FILLFACTOR = 90);

	RAISERROR ('Rebuilding IDX_NumberId', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_NumberId] ON [QNN_SAMPLE] REBUILD;
END
ELSE
BEGIN
	IF(@new_pk_qnn_sample=1 AND @old_idx_uid=0)
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
			so.Name='QNN_SAMPLE';

		SELECT 
			@PkClusteredIndexName AS PkClusteredIndexName, 
			@new_pk_qnn_sample AS new_pk_qnn_sample
		;

		RAISERROR ('The objects in QNN_SAMPLE are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END







