--Changes to indexes in QNN_RESP_ANS
--This may need significant time and resources if the table has a lot of data
--The database should not be in concurrent use (i.e. best done in downtime)

--RAISERROR 0,0 is used to display immediate progress in SSMS without waiting for the entire script to complete
RAISERROR ('Checking existing QNN_RESP_ANS indexes...', 0,0) WITH NOWAIT;

--Expected state if this script hasnt been run yet:
-- * Clustered Primary Key on Id: PK_QNN_RESP_ANS 100% fill factor
-- * Non-clustered index on RespId: IDX_RespId 100% fill factor
-- * Non-clustered index on QnnFieldId: IDX_QnnFieldId 100% fill factor
-- * (No other index on this table but script doesn't check this)
-- * SQL Server assigned name for the default constraint on Id
-- * SQL Server assigned name for the default constraint on IsPrePopulated

--Expected state if this script had already been run successfully:
-- * Clustered index on RespId: CI_RespId 80% fill factor
-- * Non-Clustered Primary key on Id: PK_QNN_RESP_ANS 80% fill factor
-- * Non-clustered index on QnnFieldId: IDX_QnnFieldId 80% fill factor
-- * DF_QNN_RESP_ANS_Id is name of the default constraint on Id
-- * DF_QNN_RESP_ANS_IsPrePopulated is name of the default constraint on IsPrePopulated

DECLARE @old_pk_qnn_resp_ans BIT;
SELECT @old_pk_qnn_resp_ans=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP_ANS' 
		AND si.Name='PK_QNN_RESP_ANS' 
		AND si.type_desc='CLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END;

DECLARE @new_pk_qnn_resp_ans BIT;
SELECT @new_pk_qnn_resp_ans=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP_ANS' 
		AND si.Name='PK_QNN_RESP_ANS' 
		AND si.type_desc='NONCLUSTERED' 
		AND si.fill_factor=80
		AND si.is_primary_key=1
	) THEN 1 ELSE 0 END

DECLARE @old_idx_qnnfieldid BIT;
SELECT @old_idx_qnnfieldid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP_ANS' 
		AND si.Name='IDX_QnnFieldId' 
		AND si.type_desc='NONCLUSTERED'
		AND (si.fill_factor=0 OR si.fill_factor=100)
	) THEN 1 ELSE 0 END;

DECLARE @new_idx_qnnfieldid BIT;
SELECT @new_idx_qnnfieldid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP_ANS' 
		AND si.Name='IDX_QnnFieldId' 
		AND si.type_desc='NONCLUSTERED' 
		AND si.fill_factor=80
	) THEN 1 ELSE 0 END;

DECLARE @old_idx_respid BIT;
SELECT @old_idx_respid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP_ANS'
		AND si.Name='IDX_RespId' 
		AND si.type_desc='NONCLUSTERED' 
		AND (si.fill_factor=0 OR si.fill_factor=100)
	) THEN 1 ELSE 0 END;

DECLARE @new_ci_respid BIT;
SELECT @new_ci_respid=CASE WHEN EXISTS(
		SELECT 1 FROM sys.indexes si JOIN sys.objects so ON si.object_id=so.object_id 
		WHERE so.Name='QNN_RESP_ANS'
		AND si.Name='CI_RespId' 
		AND si.type_desc='CLUSTERED' 
		AND si.fill_factor=80
	) THEN 1 ELSE 0 END;

--Find the name of the existing default constraint on Id
--As this was not set explicitly last time, it might vary between db instances.
DECLARE @IdDefaultConstraintName NVARCHAR(MAX);
SELECT 
	@IdDefaultConstraintName=dc.name
FROM 
	sys.all_columns ac 
	JOIN sys.tables t ON t.object_id=ac.object_id 
	JOIN sys.schemas s ON s.schema_id=t.schema_id
	JOIN sys.default_constraints dc ON dc.object_id=ac.default_object_id
WHERE
	s.name='dbo' AND t.name ='QNN_RESP_ANS' AND ac.name='Id';
DECLARE @new_id_default_constraint BIT;
SELECT @new_id_default_constraint=CASE WHEN @IdDefaultConstraintName='DF_QNN_RESP_ANS_Id' THEN 1 ELSE 0 END;

--Find the name of the existing default constraint for IsPrePopulated
DECLARE @IsPrePopulatedDefaultConstraintName NVARCHAR(MAX);
SELECT 
	@IsPrePopulatedDefaultConstraintName=dc.name
FROM 
	sys.all_columns ac 
	JOIN sys.tables t ON t.object_id=ac.object_id 
	JOIN sys.schemas s ON s.schema_id=t.schema_id
	JOIN sys.default_constraints dc ON dc.object_id=ac.default_object_id
WHERE
	s.name='dbo' AND t.name ='QNN_RESP_ANS' AND ac.name='IsPrePopulated';
DECLARE @new_isprepopulated_default_constraint BIT;
SELECT @new_isprepopulated_default_constraint=CASE WHEN @IsPrePopulatedDefaultConstraintName='DF_QNN_RESP_ANS_IsPrePopulated' THEN 1 ELSE 0 END;

IF(@old_pk_qnn_resp_ans=1 AND @old_idx_qnnfieldid=1 AND @old_idx_respid=1 
	AND @new_id_default_constraint=0 AND @new_isprepopulated_default_constraint=0)
BEGIN
	RAISERROR ('Expected pre-script target objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	--When we drop or add a clustered index the existing non-clustered indexes will need to be rebuilt
	--so we will drop them first and rebuild them afterwards ourselves so they only get rebuilt once
	RAISERROR ('Dropping indexes IDX_QnnFieldId, IDX_RespId', 0,0) WITH NOWAIT;
	DROP INDEX [IDX_QnnFieldId] ON [QNN_RESP_ANS];
	DROP INDEX [IDX_RespId] ON [QNN_RESP_ANS];

	--Drop the existing primary key, this will drop the clustered index on Id too, and table will convert to a heap
	RAISERROR ('Dropping the primary key constraint PK_QNN_RESP_ANS and its clustered index', 0,0) WITH NOWAIT;
	ALTER TABLE [QNN_RESP_ANS] DROP CONSTRAINT [PK_QNN_RESP_ANS];

	--We will now create the clustered index on the RespId field so answers for a given response are clustered. 
	--Creating a clustered index will re-organise the physical storage of the table. 
	--If it is big this may need some time to complete.
	--The old non-clustered index on RespId also included the answer value,
	--but for a clustered index everything is already included by definition. 
	RAISERROR ('Creating clustered index CI_RespId on RespId (this may take a while)', 0,0) WITH NOWAIT;
	CREATE CLUSTERED INDEX [CI_RespId] ON [QNN_RESP_ANS](RespId ASC) WITH (FILLFACTOR=80);

	--We can now recreate the primary key using a non-clustered index
	RAISERROR ('Creating non-clustered primary key on Id', 0,0) WITH NOWAIT;
	ALTER TABLE [QNN_RESP_ANS] ADD CONSTRAINT [PK_QNN_RESP_ANS] PRIMARY KEY NONCLUSTERED ([Id] ASC ) WITH (FILLFACTOR = 80);

	RAISERROR ('Creating non-clustered index IDX_QnnFieldId', 0,0) WITH NOWAIT;
	CREATE NONCLUSTERED INDEX [IDX_QnnFieldId] ON [dbo].[QNN_RESP_ANS]([QnnFieldId] ASC)
		WITH (
			FILLFACTOR = 80,
			PAD_INDEX = OFF, 
			STATISTICS_NORECOMPUTE = OFF, 
			SORT_IN_TEMPDB = OFF, 
			DROP_EXISTING = OFF, 
			ONLINE = OFF, 
			ALLOW_ROW_LOCKS = ON, 
			ALLOW_PAGE_LOCKS = ON);

	--Give the default constraint on Id a fixed name (so it will be the same in all instances)
	RAISERROR ('Renaming Id default constraint to DF_QNN_RESP_ANS_Id (You can ignore the "Caution" warning below)', 0,0) WITH NOWAIT;
	EXEC sp_rename @IdDefaultConstraintName, N'DF_QNN_RESP_ANS_Id', N'OBJECT';

	--Give the default constraint on IsPrePopulated a fixed name (will still default to 0)
	RAISERROR ('Renaming IsPrePopulated default constraint to DF_QNN_RESP_ANS_IsPrePopulated (You can ignore the "Caution" warning below)', 0,0) WITH NOWAIT;
	EXEC sp_rename @IsPrePopulatedDefaultConstraintName, N'DF_QNN_RESP_ANS_IsPrePopulated', N'OBJECT';
END
ELSE
BEGIN
	IF(@new_pk_qnn_resp_ans=1 AND @new_idx_qnnfieldid=1 AND @new_ci_respid=1 
		AND @new_id_default_constraint=1 AND @new_isprepopulated_default_constraint=1)
	BEGIN
		--Do note that the above condition is just a heuristic
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
	ELSE
	BEGIN
		--If the table isn't in either of the two expected states at the time that I wrote this
		--then I can't tell in advance how to sort it out, and you dear reader will have to take
		--a look and figure out what should be done.

		--But I'll lookup some info to aid in checking. Go see the results window for this.
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
			so.Name='QNN_RESP_ANS';

		SELECT 
			@old_pk_qnn_resp_ans AS old_pk_qnn_resp_ans, 
			@new_pk_qnn_resp_ans AS new_pk_qnn_resp_ans,
			@old_idx_qnnfieldid AS old_idx_qnnfieldid,
			@new_idx_qnnfieldid AS new_idx_qnnfieldid,
			@old_idx_respid AS old_idx_respid,
			@new_ci_respid AS new_ci_respid,
			@IdDefaultConstraintName AS IdDefaultConstraintName,
			@new_id_default_constraint AS new_id_default_constraint,
			@IsPrePopulatedDefaultConstraintName AS IsPrePopulatedDefaultConstraintName,
			@new_isprepopulated_default_constraint AS new_isprepopulated_default_constraint
		;

		RAISERROR ('The objects in QNN_RESP_ANS are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
				   16, -- Severity.
				   1 -- State.
				   );
	END
END;