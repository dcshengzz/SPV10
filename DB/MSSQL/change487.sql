--Adds a foreign key constraint on QNN_DPLY_SCHEDULER DplyId Column

DECLARE @qnn_dply_scheduler_object_id INT;
SELECT @qnn_dply_scheduler_object_id = object_id FROM sys.objects WHERE name='QNN_DPLY_SCHEDULER';

DECLARE @dangling_dplyid_count INT;
	SELECT @dangling_dplyid_count=COUNT(*) FROM QNN_DPLY_SCHEDULER ds LEFT JOIN QNN_DPLY d ON ds.DplyId=d.Id WHERE d.Id IS NULL;

DECLARE @new_fk_dplyid BIT;
SELECT @new_fk_dplyid=CASE WHEN OBJECT_ID('dbo.[FK_QNN_DPLY_SCHEDULER_DplyId]', 'F') IS NOT NULL THEN 1 ELSE 0 END;

IF( @dangling_dplyid_count=0 AND @new_fk_dplyid=0)
BEGIN
	RAISERROR ('Expected pre-script objects found in QNN_DPLY_SCHEDULER, proceeding with modifications', 0,0) WITH NOWAIT;

	RAISERROR ('Adding foreign key constraint FK_QNN_DPLY_SCHEDULER_DplyId with ON DELETE CASCADE', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_DPLY_SCHEDULER ADD CONSTRAINT FK_QNN_DPLY_SCHEDULER_DplyId FOREIGN KEY ([DplyId]) REFERENCES QNN_DPLY([Id])
		ON DELETE CASCADE;
END
ELSE
BEGIN
	IF( @dangling_dplyid_count=0 AND @new_fk_dplyid=1)
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
			@dangling_dplyid_count AS dangling_dplyid_count,
			@new_fk_dplyid			
		;

		IF(@dangling_dplyid_count > 0)
		BEGIN
			--Need to remove the invalid rows before we add the FK constraint (which must be done in the next script in another batch)
			RAISERROR('There are %i rows in QNN_DPLY_SCHEDULER where DplyId does not reference an existing deployment',0,0, @dangling_dplyid_count) WITH NOWAIT;

			SELECT DISTINCT
				DplyId AS dangling_dplyid
			FROM 
				QNN_DPLY_SCHEDULER ds LEFT JOIN QNN_DPLY d ON ds.DplyId=d.Id 
			WHERE 
				d.Id IS NULL
			;

		END

		RAISERROR ('The objects in QNN_DPLY_SCHEDULER are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END