--Constrain DplyId, JobDescription, EmailSuccess, EmailFailure, EmailRecipients, CreatedDate, CreatedBy to be NOT NULL
--Will check if any rows have nulls in these columns and fail if so (none are expected)
--WARNING: will delete any rows in QNN_DPLY_SCHEDULER where DplyId does not refer to the Id of an existing row in QNN_DPLY
--(i.e deletes leftover snapshot settings for deleted deployments)

DECLARE @qnn_dply_scheduler_object_id INT;
SELECT @qnn_dply_scheduler_object_id = object_id FROM sys.objects WHERE name='QNN_DPLY_SCHEDULER';

DECLARE @invalid_rowcount INT;
SELECT @invalid_rowcount=
	COUNT(*) FROM QNN_DPLY_SCHEDULER 
	WHERE [DplyId] IS NULL OR [JobDescription] IS NULL
	OR [EmailSuccess] IS NULL OR [EmailFailure] IS NULL
	OR [EmailRecipients] IS NULL OR [CreatedDate] IS NULL
	OR [CreatedBy] IS NULL;

DECLARE @nullable_dplyid BIT;
SELECT @nullable_dplyid=is_nullable FROM sys.columns WHERE name='DplyId' AND object_id=@qnn_dply_scheduler_object_id;

DECLARE @nullable_jobdescription BIT;
SELECT @nullable_jobdescription=is_nullable FROM sys.columns WHERE name='JobDescription' AND object_id=@qnn_dply_scheduler_object_id;

DECLARE @nullable_emailsuccess BIT;
SELECT @nullable_emailsuccess=is_nullable FROM sys.columns WHERE name='EmailSuccess' AND object_id=@qnn_dply_scheduler_object_id;

DECLARE @nullable_emailfailure BIT;
SELECT @nullable_emailfailure=is_nullable FROM sys.columns WHERE name='EmailFailure' AND object_id=@qnn_dply_scheduler_object_id;

DECLARE @nullable_emailrecipients BIT;
SELECT @nullable_emailrecipients=is_nullable FROM sys.columns WHERE name='EmailRecipients' AND object_id=@qnn_dply_scheduler_object_id;

DECLARE @nullable_createddate BIT;
SELECT @nullable_createddate=is_nullable FROM sys.columns WHERE name='CreatedDate' AND object_id=@qnn_dply_scheduler_object_id;

DECLARE @nullable_createdby BIT;
SELECT @nullable_createdby=is_nullable FROM sys.columns WHERE name='CreatedBy' AND object_id=@qnn_dply_scheduler_object_id;

IF( @invalid_rowcount=0
	AND @nullable_dplyid=1 AND @nullable_jobdescription=1 AND @nullable_emailsuccess=1 AND @nullable_emailfailure=1
	AND @nullable_createddate=1 AND @nullable_createdby=1)
BEGIN
	RAISERROR ('Expected pre-script objects found in QNN_DPLY_SCHEDULER and existing data ok, proceeding with modifications', 0,0) WITH NOWAIT;

	DECLARE @dangling_dplyid_count INT;
	SELECT @dangling_dplyid_count=COUNT(*) FROM QNN_DPLY_SCHEDULER ds LEFT JOIN QNN_DPLY d ON ds.DplyId=d.Id WHERE d.Id IS NULL;

	IF(@dangling_dplyid_count > 0)
	BEGIN
		--Need to remove the invalid rows before we add the FK constraint (which must be done in the next script in another batch)
		RAISERROR('Deleting %i rows from QNN_DPLY_SCHEDULER where DplyId does not reference an existing deployment',0,0, @dangling_dplyid_count) WITH NOWAIT;

		DELETE 
			FROM QNN_DPLY_SCHEDULER
			FROM QNN_DPLY_SCHEDULER ds LEFT JOIN QNN_DPLY d ON ds.DplyId=d.Id
			WHERE d.Id IS NULL;

	END

	RAISERROR ('Altering the following columns to be NOT NULL - DplyId, JobDescription, EmailSuccess, EmailFailure, EmailRecipients, CreatedDate, CreatedBy', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_DPLY_SCHEDULER ALTER COLUMN [DplyId] UNIQUEIDENTIFIER NOT NULL;
	ALTER TABLE QNN_DPLY_SCHEDULER ALTER COLUMN [JobDescription] NVARCHAR(300) NOT NULL;
	ALTER TABLE QNN_DPLY_SCHEDULER ALTER COLUMN [EmailSuccess] BIT NOT NULL;
	ALTER TABLE QNN_DPLY_SCHEDULER ALTER COLUMN [EmailFailure] BIT NOT NULL;
	ALTER TABLE QNN_DPLY_SCHEDULER ALTER COLUMN [EmailRecipients] NVARCHAR(MAX) NOT NULL;
	ALTER TABLE QNN_DPLY_SCHEDULER ALTER COLUMN [CreatedDate] DATETIME NOT NULL;
	ALTER TABLE QNN_DPLY_SCHEDULER ALTER COLUMN [CreatedBy] UNIQUEIDENTIFIER NOT NULL;
END
ELSE
BEGIN
	IF( @invalid_rowcount=0
		AND @nullable_dplyid=0 AND @nullable_jobdescription=0 AND @nullable_emailsuccess=0 AND @nullable_emailfailure=0
		AND @nullable_createddate=0 AND @nullable_createdby=0)
	BEGIN
		--The table wasn't as we expected it to be, but it looks like the changes have already been made
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
			@nullable_dplyid AS nullable_dlyid,
			@nullable_dplyid AS nullable_jobdescription,
			@nullable_emailsuccess AS nullable_emailsuccess,
			@nullable_emailfailure AS nullable_emailfailure,
			@nullable_createddate AS nullable_createddate,
			@nullable_createdby AS nullable_createdby
		;

		--List out the invalid rows due to nulls in columns
		IF(@invalid_rowcount>0)
		BEGIN
			RAISERROR('There are %i rows in QNN_DPLY_SCHEDULER that have invalid data',0,0, @invalid_rowcount) WITH NOWAIT;

			SELECT 
				*
			FROM 
				QNN_DPLY_SCHEDULER 
			WHERE
				[DplyId] IS NULL 
				OR [JobDescription] IS NULL
				OR [EmailSuccess] IS NULL
				OR [EmailFailure] IS NULL
				OR [EmailRecipients] IS NULL
				OR [CreatedDate] IS NULL
				OR [CreatedBy] IS NULL
			ORDER BY 
				[CreatedDate] ASC,
				[UpdatedDate] ASC,
				[Id] ASC
			;
		END

		RAISERROR ('The objects in QNN_DPLY_SCHEDULER are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END