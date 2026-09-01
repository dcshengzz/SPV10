-- Update indexes on AuditLog heap (must be run in db containing dbo.AuditLog)
-- THIS SCRIPT MUST BE RUN IN DOWNTIME
-- It may need some time to execute depending on the amount of data in the db.
-- 
-- Create IDX_EventDate 
-- Change fill factor to 80 for PK_AuditLog
-- Drop IDX_TableName
-- Drop IDX_StructDivisionId
-- Drop IDX_EventType
-- Drop IDX_UserId


DECLARE @old_pk_auditlog BIT;
SELECT  @old_pk_auditlog=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='AuditLog' 
		AND si.Name='PK_AuditLog' 
		AND si.type_desc='NONCLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @new_pk_auditlog BIT;
SELECT  @new_pk_auditlog=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='AuditLog' 
		AND si.Name='PK_AuditLog' 
		AND si.type_desc='NONCLUSTERED' 
		AND (si.fill_factor=80)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

IF(@old_pk_auditlog=1)
BEGIN
	RAISERROR ('Expected pre-script objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Creating IDX_EventDate (this may need some time)', 0,0) WITH NOWAIT;
	CREATE NONCLUSTERED INDEX IDX_EventDate ON dbo.AuditLog (EventDate DESC)
	WITH ( FILLFACTOR = 100, ONLINE = OFF, MAXDOP = 0, OPTIMIZE_FOR_SEQUENTIAL_KEY = ON );

	RAISERROR ('Rebuilding PK_QNN_DPLY_SAMPLE_OWNER with FILLFACTOR 80 (this may need some time)', 0,0) WITH NOWAIT;
	ALTER INDEX [PK_AuditLog] ON dbo.AuditLog REBUILD WITH (FILLFACTOR = 80, ONLINE = OFF, MAXDOP = 0);

	RAISERROR ('Dropping IDX_TableName', 0,0) WITH NOWAIT;
	DROP INDEX [IDX_TableName] ON AuditLog;

	RAISERROR ('Dropping IDX_StructDivisionId', 0,0) WITH NOWAIT;
	DROP INDEX [IDX_StructDivisionId] ON AuditLog;

	RAISERROR ('Dropping IDX_EventType', 0,0) WITH NOWAIT;
	DROP INDEX [IDX_EventType] ON AuditLog;

	RAISERROR ('Dropping IDX_UserId', 0,0) WITH NOWAIT;
	DROP INDEX [IDX_UserId] ON AuditLog;
END
ELSE
BEGIN

	IF(@new_pk_auditlog=1)
	BEGIN
		--Do note that the above condition is just a heuristic
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
	ELSE
	BEGIN
		--Unexpected situation, requires dba to check and decide how to proceed.
		--Get some diagnostic info. Go see the results window for this.
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
			so.Name='AuditLog';

		SELECT 
			@old_pk_auditlog AS old_pk_auditlog, 
			@new_pk_auditlog AS new_pk_auditlog
		;

		RAISERROR ('The objects in AuditLog are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);		
	END
END