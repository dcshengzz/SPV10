-- Update indexes in QNN_DPLY_SAMPLE_OWNER
-- Drop IDX_DplyId
-- Create UQ_QNN_DPLY_SAMPLE_OWNER with fill factor 80
-- Change fill factor to 80 for
--  PK_QNN_DPLY_SAMPLE_OWNER
--  IDX_ListSampleId
--  IDX_UserId

DECLARE @old_pk_qnn_dply_sample_owner BIT;
SELECT  @old_pk_qnn_dply_sample_owner=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_DPLY_SAMPLE_OWNER' 
		AND si.Name='PK_QNN_DPLY_SAMPLE_OWNER' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @new_pk_qnn_dply_sample_owner BIT;
SELECT  @new_pk_qnn_dply_sample_owner=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_DPLY_SAMPLE_OWNER' 
		AND si.Name='PK_QNN_DPLY_SAMPLE_OWNER' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=80)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @duplicate_count INT;
SELECT @duplicate_count=COUNT(*) FROM (
	SELECT DplyId, ListSampleId, UserId 
	FROM QNN_DPLY_SAMPLE_OWNER 
	GROUP BY DplyId, ListSampleId, UserId 
	HAVING COUNT(*) > 1) duplicates;

IF(@duplicate_count=0 AND @old_pk_qnn_dply_sample_owner=1)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Rebuilding PK_QNN_DPLY_SAMPLE_OWNER with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [PK_QNN_DPLY_SAMPLE_OWNER] ON [QNN_DPLY_SAMPLE_OWNER] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding IDX_ListSampleId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_ListSampleId] ON [QNN_DPLY_SAMPLE_OWNER] REBUILD WITH (FILLFACTOR = 80);

	RAISERROR ('Rebuilding IDX_UserId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_UserId] ON [QNN_DPLY_SAMPLE_OWNER] REBUILD WITH (FILLFACTOR = 80);

	RAISERROR ('Creating unique constraint/index UQ_QNN_DPLY_SAMPLE_OWNER', 0,0) WITH NOWAIT;
	ALTER TABLE [QNN_DPLY_SAMPLE_OWNER] 
		ADD CONSTRAINT [UQ_DPLY_SAMPLE_OWNER] 
		UNIQUE(DplyId, UserId, ListSampleId)
		WITH (FILLFACTOR = 80);

	--The new index for the unique constraint can be used instead
	RAISERROR ('Dropping IDX_DplyId', 0,0) WITH NOWAIT;
	DROP INDEX [IDX_DplyId] ON QNN_DPLY_SAMPLE_OWNER;
END
ELSE
BEGIN

	IF(@duplicate_count=1)
	BEGIN
		--Show duplicated data editor assignments that would prevent creating the unique constraint
		SELECT 
			DplyId, ListSampleId, UserId 
		FROM 
			QNN_DPLY_SAMPLE_OWNER 
		GROUP BY 
			DplyId, ListSampleId, UserId 
		HAVING 
			COUNT(*) > 1;

		RAISERROR ('There are duplicate sample owner assignments',
				16, -- Severity.
				1 -- State.
				);
	END

	IF(@new_pk_qnn_dply_sample_owner=1)
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
			so.Name='QNN_DPLY_SAMPLE_OWNER';

		SELECT 
			@duplicate_count AS duplicate_count,
			@old_pk_qnn_dply_sample_owner AS old_pk_qnn_dply_sample_owner, 
			@new_pk_qnn_dply_sample_owner AS new_pk_qnn_dply_sample_owner
		;

		RAISERROR ('The objects in QNN_DPLY_SAMPLE_OWNER are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);		
	END
END