-- This script will check data in QNN_REPORT_SNAPSHOT for invalid nulls and duplicated NumberId and then
-- alter a number of columns to be non-nullable and impose a unique constraint/index on NumberId
-- The following columns will be set to NOT NULL: Id, BatchNo, DplyId, Status, Weightgroup, Count, CreatedDate
-- This will ensure the table is in a suitable state for addition of further indexes & keys in the subsequent script.
-- WARNING: rows that have a value for DplyId that does not refer to an existing Id in QNN_DPLY will be DELETED.

DECLARE @qnn_report_snapshot_object_id INT;
SELECT @qnn_report_snapshot_object_id = object_id FROM sys.objects WHERE name='QNN_REPORT_SNAPSHOT';

DECLARE @nullable_id BIT;
SELECT @nullable_id=is_nullable FROM sys.columns WHERE name='Id' AND object_id=@qnn_report_snapshot_object_id;

DECLARE @nullable_batchno BIT;
SELECT @nullable_batchno=is_nullable FROM sys.columns WHERE name='BatchNo' AND object_id=@qnn_report_snapshot_object_id;

DECLARE @nullable_dplyid BIT;
SELECT @nullable_dplyid=is_nullable FROM sys.columns WHERE name='DplyId' AND object_id=@qnn_report_snapshot_object_id;

DECLARE @nullable_status BIT;
SELECT @nullable_status=is_nullable FROM sys.columns WHERE name='Status' AND object_id=@qnn_report_snapshot_object_id;

DECLARE @nullable_weightgroup BIT;
SELECT @nullable_weightgroup=is_nullable FROM sys.columns WHERE name='Weightgroup' AND object_id=@qnn_report_snapshot_object_id;

DECLARE @nullable_count BIT;
SELECT @nullable_count=is_nullable FROM sys.columns WHERE name='Count' AND object_id=@qnn_report_snapshot_object_id;

DECLARE @nullable_createddate BIT;
SELECT @nullable_createddate=is_nullable FROM sys.columns WHERE name='CreatedDate' AND object_id=@qnn_report_snapshot_object_id;

DECLARE @invalid_rowcount INT;
SELECT @invalid_rowcount=COUNT(*) FROM QNN_REPORT_SNAPSHOT WHERE
	[Id] IS NULL OR [BatchNo] IS NULL OR [DplyId] IS NULL OR [Status] IS NULL 
	OR [Weightgroup] IS NULL OR [COUNT] IS NULL OR [CreatedDate] IS NULL;

DECLARE @duplicate_numberid_count INT;
SELECT @duplicate_numberid_count=COUNT(duplicated_NumberId) FROM (
	SELECT NumberId AS duplicated_NumberId, COUNT(NumberId) AS [rowcount] 
	FROM QNN_REPORT_SNAPSHOT GROUP BY NumberId HAVING COUNT(NumberId)>1) dni;

DECLARE @new_uq_numberid BIT;
SELECT @new_uq_numberid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_report_snapshot_object_id
		AND si.Name='UQ_NumberId' 
		AND si.type_desc='NONCLUSTERED' 
		AND si.is_unique_constraint=1
	) THEN 1 ELSE 0 END;

IF( @invalid_rowcount=0 AND @duplicate_numberid_count=0
	AND @nullable_id=1 AND @nullable_batchno=1 AND @nullable_dplyid=1 AND @nullable_status=1
	AND @nullable_weightgroup=1 AND @nullable_count=1 AND @nullable_createddate=1
	AND @new_uq_numberid=0)
BEGIN
	RAISERROR ('Expected pre-script objects found in QNN_REPORT_SNAPSHOT and existing data ok, proceeding with modifications', 0,0) WITH NOWAIT;

	DECLARE @dangling_dplyid_count INT;
	SELECT @dangling_dplyid_count=COUNT(*) FROM QNN_REPORT_SNAPSHOT rs LEFT JOIN QNN_DPLY d ON rs.DplyId=d.Id WHERE d.Id IS NULL;

	IF(@dangling_dplyid_count > 0)
	BEGIN
		--Need to remove the invalid rows before we add the FK constraint (which will be done in the 
		--next script as it needs to be in another batch)
		RAISERROR('Deleting %i rows from QNN_REPORT_SNAPSHOT where DplyId does not reference an existing deployment',0,0, @dangling_dplyid_count) WITH NOWAIT;

		DELETE 
			FROM QNN_REPORT_SNAPSHOT
			FROM QNN_REPORT_SNAPSHOT rs LEFT JOIN QNN_DPLY d ON rs.DplyId=d.Id
			WHERE d.Id IS NULL;

	END

	RAISERROR ('Altering the following columns to be NOT NULL - Id, BatchNo, DplyId, Status, Weightgroup, Count, CreatedDate', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_REPORT_SNAPSHOT ALTER COLUMN [Id] UNIQUEIDENTIFIER NOT NULL;
	ALTER TABLE QNN_REPORT_SNAPSHOT ALTER COLUMN [BatchNo] NVARCHAR(50) NOT NULL;
	ALTER TABLE QNN_REPORT_SNAPSHOT ALTER COLUMN [DplyId] UNIQUEIDENTIFIER NOT NULL;
	ALTER TABLE QNN_REPORT_SNAPSHOT ALTER COLUMN [Status] UNIQUEIDENTIFIER NOT NULL;
	ALTER TABLE QNN_REPORT_SNAPSHOT ALTER COLUMN [Weightgroup] NVARCHAR(25) NOT NULL;
	ALTER TABLE QNN_REPORT_SNAPSHOT ALTER COLUMN [Count] INT NOT NULL;
	ALTER TABLE QNN_REPORT_SNAPSHOT ALTER COLUMN [CreatedDate] DATETIME NOT NULL;

	RAISERROR ('Adding index UQ_NumberId', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_REPORT_SNAPSHOT ADD CONSTRAINT UQ_NumberId UNIQUE ([NumberId]) WITH (FILLFACTOR = 100); 
END
ELSE
BEGIN
	IF( @nullable_id=0 AND @nullable_batchno=0 AND @nullable_dplyid=0 AND @nullable_status=0
		AND @nullable_weightgroup=0 AND @nullable_count=0 AND @nullable_createddate=0
		AND @new_uq_numberid=1)
	BEGIN
		--The table wasn't as we expected it to be, but it looks like the changes have already been made
		--Do note that the above condition is just a heuristic to decide this
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
	ELSE
	--The table wasn't as we expected it to be and its not because the changes were already made 
	--so we don't know how to handle it and must fail
	BEGIN
		--Unexpected situation, requires dba to check and decide how to proceed.
		--Get some diagnostic info. Go see the results window for this.
		
		SELECT
			@invalid_rowcount AS invalid_rowcount,
			@duplicate_numberid_count AS duplicate_numberid_count,
			@nullable_id AS nullable_id,
			@nullable_batchno AS nullable_batchno,
			@nullable_dplyid AS nullable_dplyid,
			@nullable_status AS nullable_status,
			@nullable_weightgroup AS nullable_weightgroup,
			@nullable_count AS nullable_count,
			@nullable_createddate AS nullable_createddate,
			@new_uq_numberid AS new_uq_numberid
		;

		--List out the invalid rows due to nulls in columns
		IF(@invalid_rowcount>0)
		BEGIN
			SELECT 
				[Id], 
				[BatchNo], 
				[NumberId], 
				[DplyId], 
				[Status], 
				[Weightgroup], 
				[Count], 
				[CreatedDate]
			FROM 
				QNN_REPORT_SNAPSHOT 
			WHERE
				[Id] IS NULL 
				OR [BatchNo] IS NULL 
				OR [DplyId] IS NULL 
				OR [Status] IS NULL 
				OR [Weightgroup] IS NULL 
				OR [COUNT] IS NULL 
				OR [CreatedDate] IS NULL
			ORDER BY 
				[NumberId] ASC
			;
		END

		--List out the rows with duplicated NumberId
		IF(@duplicate_numberid_count>0)
		BEGIN
			SELECT 
				NumberId AS duplicate_numberid, 
				COUNT(NumberId) AS [rowcount] 
			FROM 
				QNN_REPORT_SNAPSHOT 
			GROUP BY 
				NumberId 
			HAVING 
				COUNT(NumberId)>1
			ORDER BY
				NumberId ASC
			;
		END

		RAISERROR ('The objects in QNN_REPORT_SNAPSHOT are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END







