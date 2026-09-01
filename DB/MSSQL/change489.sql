-- Additional changes to QNN_DPLY_SCHEDULER

-- Part I , update old EmailRecipients values
DECLARE @obsolete_no_recipient_count INT;
SELECT @obsolete_no_recipient_count = COUNT(*) FROM QNN_DPLY_SCHEDULER WHERE EmailRecipients='No Recipient';
IF(@obsolete_no_recipient_count>0)
BEGIN
	RAISERROR ('Removing %i obsolete No Recipient indicators from QNN_DPLY_SCHEDULER.EmailRecipients', 0,0, @obsolete_no_recipient_count) WITH NOWAIT;
	UPDATE QNN_DPLY_SCHEDULER SET EmailRecipients='' WHERE EmailRecipients='No Recipient';
END

-- Part II , define unique constraint on DplyId as the relationsjip is 1-1 (or 1-0)
DECLARE @qnn_dply_scheduler_object_id INT;
SELECT @qnn_dply_scheduler_object_id = object_id FROM sys.objects WHERE name='QNN_DPLY_SCHEDULER';

DECLARE @new_uq_dplyid BIT; 
SELECT @new_uq_dplyid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si 
		WHERE si.object_id=@qnn_dply_scheduler_object_id
		AND si.Name='UQ_DplyId'  
		AND si.is_unique_constraint=1
	) THEN 1 ELSE 0 END;

DECLARE @duplicate_dplyid_count INT;
SELECT @duplicate_dplyid_count=COUNT(duplicated_DplyId) FROM (
	SELECT DplyId AS duplicated_DplyId, COUNT(DplyId) AS [rowcount] 
	FROM QNN_DPLY_SCHEDULER GROUP BY DplyId HAVING COUNT(DplyId)>1) ddi;

IF( @new_uq_dplyid=0 AND @duplicate_dplyid_count=0)
BEGIN
	RAISERROR ('Adding index UQ_DplyId', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_DPLY_SCHEDULER ADD CONSTRAINT UQ_DplyId UNIQUE ([DplyId]) WITH (FILLFACTOR = 100); 
END
ELSE 
BEGIN
	IF(@new_uq_dplyid=1 AND @duplicate_dplyid_count=0)
	BEGIN
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
			WHERE si.object_id=@qnn_dply_scheduler_object_id
		;

		SELECT 
			@obsolete_no_recipient_count AS obsolete_no_recipient_count,
			@new_uq_dplyid AS new_uq_dplyid,
			@duplicate_dplyid_count AS duplicate_dplyid_count;

		IF(@duplicate_dplyid_count>0) 
		BEGIN
			SELECT 
				DplyId AS duplicated_DplyId, 
				COUNT(DplyId) AS [rowcount] 
			FROM 
				QNN_DPLY_SCHEDULER 
			GROUP BY 
				DplyId 
			HAVING 
				COUNT(DplyId)>1;

			SELECT 
				Id, 
				DplyId,
				CreatedDate, 
				UpdatedDate, 
				JobDescription, 
				EmailSuccess, 
				EmailFailure, 
				EmailRecipients 
			FROM 
				QNN_DPLY_SCHEDULER 
			WHERE 
				DplyId IN (SELECT DplyId FROM QNN_DPLY_SCHEDULER GROUP BY DplyId HAVING COUNT(DplyId)>1) 
			ORDER BY 
				CreatedDate DESC;
		END

		RAISERROR ('The objects in QNN_REPORT_SNAPSHOT are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);
	END
END
