-- This script will add the missing primary key constraint for QNN_REPORT_SNAPSHOT on the Id columns
-- and will set convert the table to a clustered table (on BatchNo) instead of a heap and add some indexes
-- to support the common queries against the table. 

DECLARE @qnn_report_snapshot_object_id INT;
SELECT @qnn_report_snapshot_object_id = object_id FROM sys.objects WHERE name='QNN_REPORT_SNAPSHOT';

--Check what other indexes the table currently has
--(we expect only UQ_NumberId if this script wasn't run yet and the table is a heap)
DECLARE @unexpected_index_count INT;
SELECT @unexpected_index_count = 
	COUNT(*) FROM sys.indexes si WHERE si.object_id=@qnn_report_snapshot_object_id
	AND type_desc<>'HEAP' 
	AND name<>'UQ_NumberId';

DECLARE @old_uq_numberid BIT; --Here 'old' is in reference to this script (UQ_NumberId was just added just in 484!)
SELECT @old_uq_numberid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_report_snapshot_object_id
		AND si.Name='UQ_NumberId' 
		AND si.type_desc='NONCLUSTERED' 
		AND si.is_unique_constraint=1
	) THEN 1 ELSE 0 END;

DECLARE @new_pk_qnn_report_snapshot BIT;
SELECT @new_pk_qnn_report_snapshot=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_report_snapshot_object_id
		AND si.Name='PK_QNN_REPORT_SNAPSHOT' 
		AND si.type_desc='NONCLUSTERED' 
		AND (si.fill_factor=80)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @new_ci_batchno BIT;
SELECT @new_ci_batchno=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_report_snapshot_object_id
		AND si.Name='CI_BatchNo' 
		AND si.type_desc='CLUSTERED'
		AND (si.fill_factor=100 OR si.fill_factor=0)
	) THEN 1 ELSE 0 END;

DECLARE @new_idx_dplyid BIT;
SELECT @new_idx_dplyid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_report_snapshot_object_id
		AND si.Name='IDX_DplyId' 
		AND si.type_desc='NONCLUSTERED'
		AND (si.fill_factor=100 OR si.fill_factor=0)
	) THEN 1 ELSE 0 END;

DECLARE @new_fk_dplyid BIT;
SELECT @new_fk_dplyid=CASE WHEN OBJECT_ID('dbo.[FK_QNN_REPORT_SNAPSHOT_DplyId]', 'F') IS NOT NULL THEN 1 ELSE 0 END;

DECLARE @dangling_dplyid_count INT; --expect 0 as previous script deleted them
SELECT @dangling_dplyid_count=COUNT(*) FROM QNN_REPORT_SNAPSHOT rs LEFT JOIN QNN_DPLY d ON rs.DplyId=d.Id WHERE d.Id IS NULL;

DECLARE @nullable_id BIT;
SELECT @nullable_id=is_nullable FROM sys.columns WHERE name='Id' AND object_id=@qnn_report_snapshot_object_id;

IF( @unexpected_index_count=0 AND @old_uq_numberid=1 AND @nullable_id=0
	AND @new_pk_qnn_report_snapshot=0 AND @new_ci_batchno=0 AND @new_fk_dplyid=0
	AND @dangling_dplyid_count=0)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	--Define the clustered index (converting table from heap to clustered) first
	RAISERROR ('Adding clustered index CI_BatchNo ', 0,0) WITH NOWAIT;
	CREATE CLUSTERED INDEX CI_BatchNo ON QNN_REPORT_SNAPSHOT ([BatchNo]) WITH (FILLFACTOR = 100);

	RAISERROR ('Defining primary key constraint on Id column', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_REPORT_SNAPSHOT ADD CONSTRAINT PK_QNN_REPORT_SNAPSHOT PRIMARY KEY ([Id]) WITH (FILLFACTOR = 80);

	RAISERROR ('Adding foreign key constraint FK_QNN_REPORT_SNAPSHOT_DplyId with ON DELETE CASCADE', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_REPORT_SNAPSHOT ADD CONSTRAINT FK_QNN_REPORT_SNAPSHOT_DplyId FOREIGN KEY ([DplyId]) REFERENCES QNN_DPLY([Id])
		ON DELETE CASCADE;

	RAISERROR ('Adding index IDX_DplyId', 0,0) WITH NOWAIT;
	CREATE NONCLUSTERED INDEX IDX_DplyId ON QNN_REPORT_SNAPSHOT ([DplyId]) INCLUDE ([BatchNo], [CreatedDate]) WITH (FILLFACTOR = 100);
END
ELSE
BEGIN
	IF(@new_ci_batchno=1 AND @new_pk_qnn_report_snapshot=1 AND @new_idx_dplyid=1 AND @new_fk_dplyid=1)
	BEGIN
		--Do note that the above condition is just a heuristic
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
			WHERE si.object_id=@qnn_report_snapshot_object_id
		;

		SELECT 
			@unexpected_index_count AS unexpected_index_count, 
			@old_uq_numberid AS old_uq_numberid,
			@new_ci_batchno AS new_ci_batchno,
			@new_pk_qnn_report_snapshot AS new_pk_qnn_report_snapshot,
			@new_idx_dplyid AS new_idx_dplyid,
			@new_fk_dplyid AS new_fk_dplyid,
			@dangling_dplyid_count AS dangling_dply_id_count,
			@nullable_id AS nullable_id
		;

		IF(@dangling_dplyid_count>0)
		BEGIN
			RAISERROR ('There are %i rows with invalid DplyId values', 0,0, @dangling_dplyid_count) WITH NOWAIT;
			SELECT 
				rs.Id, 
				rs.NumberId, 
				rs.DplyId AS dangling_dplyid 
			FROM 
				QNN_REPORT_SNAPSHOT rs LEFT JOIN QNN_DPLY d ON rs.DplyId=d.Id
			WHERE 
				d.Id IS NULL
			ORDER BY
				NumberId ASC;
			;
		END

		RAISERROR ('The objects in QNN_REPORT_SNAPSHOT are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END







