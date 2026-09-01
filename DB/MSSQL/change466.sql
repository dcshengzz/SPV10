--Changes fill factors on Guid column indexes in QNN_RESP
--Renames IDX_Imputed to IDX_IsPrePopulated

DECLARE @old_pk_qnn_resp BIT;
SELECT @old_pk_qnn_resp=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP' 
		AND si.Name='PK_QNN_RESP' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @new_pk_qnn_resp BIT;
SELECT @new_pk_qnn_resp=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP' 
		AND si.Name='PK_QNN_RESP' 
		AND si.type_desc='CLUSTERED' 
		AND si.fill_factor=80
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END

DECLARE @old_idx_imputed BIT;
SELECT @old_idx_imputed=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP' AND si.Name='IDX_Imputed' 
	) THEN 1 ELSE 0 END

DECLARE @new_idx_isprepopulated BIT;
SELECT @new_idx_isprepopulated=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP' AND si.Name='IDX_IsPrePopulated' 
	) THEN 1 ELSE 0 END

IF(@old_pk_qnn_resp=1 AND @old_idx_imputed=1)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	--Drop the fill factor for the clustered index to 80
	RAISERROR ('Rebuilding PK_QNN_RESP with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [PK_QNN_RESP] ON [QNN_RESP] REBUILD WITH (FILLFACTOR = 80); 

	--We will leave existing fill factor (100%) alone for IDX_DateComplete, IDC_DateStart, IDX_NumberId
	RAISERROR ('Rebuilding IDX_DateComplete (keeping existing fill factor)', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_DateComplete] ON [QNN_RESP] REBUILD;

	RAISERROR ('Rebuilding IDX_DateStart (keeping existing fill factor)', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_DateStart] ON [QNN_RESP] REBUILD;

	RAISERROR ('Rebuilding IDX_NumberId (keeping existing fill factor)', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_NumberId] ON [QNN_RESP] REBUILD;

	--For the indexes on Guid FKs we shall set the fill factor to 80
	RAISERROR ('Rebuilding IDX_DplyId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_DplyId] ON [QNN_RESP] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding IDX_ListSampleId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_ListSampleId] ON [QNN_RESP] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding IDX_QnnId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_QnnId] ON [QNN_RESP] REBUILD WITH (FILLFACTOR = 80); 

	RAISERROR ('Rebuilding IDX_UserId with FILLFACTOR 80', 0,0) WITH NOWAIT;
	ALTER INDEX [IDX_UserId] ON [QNN_RESP] REBUILD WITH (FILLFACTOR = 80); 

	--Recreate the index on IsPrePopulated, but don't change its fillfactor
	RAISERROR ('Renaming IDX_Imputed to IDX_IsPrePopulated and rebuilding', 0,0) WITH NOWAIT;
	DROP INDEX [IDX_Imputed] ON [QNN_RESP];
	CREATE NONCLUSTERED INDEX [IDX_IsPrePopulated] ON [QNN_RESP] ([IsPrePopulated] ASC);
END
ELSE
BEGIN
	IF(@new_pk_qnn_resp=1 AND @new_idx_isprepopulated=1)
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
			so.Name='QNN_RESP';

		SELECT 
			@old_pk_qnn_resp AS old_pk_qnn_resp, 
			@new_pk_qnn_resp AS new_pk_qnn_resp,
			@old_idx_imputed AS old_idx_imputed,
			@new_idx_isprepopulated AS new_idx_isprepopulated
		;

		RAISERROR ('The objects in QNN_RESP are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END