-- This script is based on 474 (specific to a certain customised build), 
-- and if that one has already been run this should find no work to do.

--This script will add the following new columns to QNN_RESP
-- CompletedResponseAs
-- CompletedResponseBy
-- CompletedResponseVia
-- LastResponseAs
-- LastResponseBy
-- LastResponseVia

--And will also rename some existing default column constraints in QNN_RESP to have the following fixed names
--  DF_QNN_RESP_InitialResponseAs
--  DF_QNN_RESP_InitialResponseBy
--  DF_QNN_RESP_InitialResponseVia

--Note that RAISERROR ... 0,0) WITH NOWAIT; is used in this script 
--to print informational messages in the SSMS messages tab 
--without waiting till script completion as PRINT would

DECLARE @qnn_resp_object_id INT;
SELECT @qnn_resp_object_id=Object_ID(N'dbo.QNN_RESP');

DECLARE @new_column_count INT;
SELECT @new_column_count=COUNT(*) FROM sys.columns 
	WHERE Name IN (
		'CompletedResponseAs', 'CompletedResponseBy', 'CompletedResponseVia',
		'LastResponseAs', 'LastResponseBy', 'LastResponseVia',
		'InitialResponseUserId', 'CompletedResponseUserId'
		) AND Object_ID=@qnn_resp_object_id;

DECLARE @initialresponseas_default_constraint_name NVARCHAR(MAX);
SELECT 
	@initialresponseas_default_constraint_name=dc.name
FROM 
	sys.all_columns ac 
	JOIN sys.tables t ON t.object_id=ac.object_id 
	JOIN sys.schemas s ON s.schema_id=t.schema_id
	JOIN sys.default_constraints dc ON dc.object_id=ac.default_object_id
WHERE
	s.name='dbo' AND t.name ='QNN_RESP' AND ac.name='InitialResponseAs';
DECLARE @new_initialresponseas_default_constraint BIT;
SELECT @new_initialresponseas_default_constraint=CASE WHEN @initialresponseas_default_constraint_name='DF_QNN_RESP_InitialResponseAs' THEN 1 ELSE 0 END;

DECLARE @initialresponseby_default_constraint_name NVARCHAR(MAX);
SELECT 
	@initialresponseby_default_constraint_name=dc.name
FROM 
	sys.all_columns ac 
	JOIN sys.tables t ON t.object_id=ac.object_id 
	JOIN sys.schemas s ON s.schema_id=t.schema_id
	JOIN sys.default_constraints dc ON dc.object_id=ac.default_object_id
WHERE
	s.name='dbo' AND t.name ='QNN_RESP' AND ac.name='InitialResponseBy';
DECLARE @new_initialresponseby_default_constraint BIT;
SELECT @new_initialresponseby_default_constraint=CASE WHEN @initialresponseby_default_constraint_name='DF_QNN_RESP_InitialResponseBy' THEN 1 ELSE 0 END;

DECLARE @initialresponsevia_default_constraint_name NVARCHAR(MAX);
SELECT 
	@initialresponsevia_default_constraint_name=dc.name
FROM 
	sys.all_columns ac 
	JOIN sys.tables t ON t.object_id=ac.object_id 
	JOIN sys.schemas s ON s.schema_id=t.schema_id
	JOIN sys.default_constraints dc ON dc.object_id=ac.default_object_id
WHERE
	s.name='dbo' AND t.name ='QNN_RESP' AND ac.name='InitialResponseVia';
DECLARE @new_initialresponsevia_default_constraint BIT;
SELECT @new_initialresponsevia_default_constraint=CASE WHEN @initialresponsevia_default_constraint_name='DF_QNN_RESP_InitialResponseVia' THEN 1 ELSE 0 END;

IF(@new_column_count=0 
	AND @new_initialresponseas_default_constraint=0
	AND @new_initialresponseby_default_constraint=0
	AND @new_initialresponsevia_default_constraint=0)
BEGIN
	RAISERROR ('Expected pre-script target objects found. Will proceed with modifications.', 0,0) WITH NOWAIT;

	RAISERROR ('Renaming default constraint on InitialResponseUserId', 0,0) WITH NOWAIT;
	EXEC sp_rename @initialresponseas_default_constraint_name, N'DF_QNN_RESP_InitialResponseAs', N'OBJECT';

	RAISERROR ('Renaming default constraint on InitialResponseBy', 0,0) WITH NOWAIT;
	EXEC sp_rename @initialresponseby_default_constraint_name, N'DF_QNN_RESP_InitialResponseBy', N'OBJECT';

	RAISERROR ('Renaming default constraint on InitialResponseVia', 0,0) WITH NOWAIT;
	EXEC sp_rename @initialresponsevia_default_constraint_name, N'DF_QNN_RESP_InitialResponseVia', N'OBJECT';

	RAISERROR ('Adding columns CompletedResponseAs, CompletedResponseBy, CompletedResponseVia (nullable)', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_RESP ADD CompletedResponseAs NVARCHAR(50) NULL;
	ALTER TABLE QNN_RESP ADD CompletedResponseBy NVARCHAR(50) NULL;
	ALTER TABLE QNN_RESP ADD CompletedResponseVia NVARCHAR(50) NULL;

	RAISERROR ('Adding columns LastResponseAs, LastResponseBy, LastResponseVia (not nullable, with default constraint)', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_RESP ADD LastResponseAs NVARCHAR(50) NOT NULL CONSTRAINT DF_QNN_RESP_LastResponseAs DEFAULT 'Unknown';
	ALTER TABLE QNN_RESP ADD LastResponseBy NVARCHAR(50) NOT NULL CONSTRAINT DF_QNN_RESP_LastResponseBy DEFAULT 'Unknown';
	ALTER TABLE QNN_RESP ADD LastResponseVia NVARCHAR(50) NOT NULL CONSTRAINT DF_QNN_RESP_LastResponseVia DEFAULT 'Unknown';

	--n.b. UserId column already fulfils the purpose of LastResponseUserId (we won't rename it though)
	--We don't add an FK constraint to these columns (they refer to dwSecurityUser)
	RAISERROR ('Adding columns InitialResponseUserId, CompletedResponseUserId (nullable)', 0,0) WITH NOWAIT;
	ALTER TABLE QNN_RESP ADD InitialResponseUserId UNIQUEIDENTIFIER NULL;
	ALTER TABLE QNN_RESP ADD CompletedResponseUserId UNIQUEIDENTIFIER NULL;

END
ELSE 
BEGIN
	IF(@new_column_count=8
		AND @new_initialresponseas_default_constraint=1
		AND @new_initialresponseby_default_constraint=1
		AND @new_initialresponsevia_default_constraint=1) 
	BEGIN
		RAISERROR ('The target objects have already been updated, skipping modifications', 0,0) WITH NOWAIT;
	END
	ELSE
	BEGIN
		SELECT 
			@initialresponseas_default_constraint_name AS initialresponseas_default_constraint_name,
			@new_initialresponseas_default_constraint AS new_initialresponseas_default_constraint,
			@initialresponseby_default_constraint_name AS initialresponseby_default_constraint_name,
			@new_initialresponseby_default_constraint AS new_initialresponseby_default_constraint,
			@initialresponsevia_default_constraint_name AS initialresponsevia_default_constraint_name,
			@new_initialresponsevia_default_constraint AS new_initialresponsevia_default_constraint;

		SELECT 
			'0 if not updated, 8 if updated already' AS expected_new_column_count, 
			@new_column_count AS actual_new_column_count;

		--list of all the columns found in the table for convenience
		SELECT 
			c.[name] AS [column_in_QNN_RESP], 
			CASE WHEN c.[is_nullable]=1 THEN 'NULL' ELSE 'NOT NULL' END AS [nullability], 
			t.[name] AS [column_type]
		FROM 
			[sys].[columns] c
			LEFT JOIN [sys].[types] t ON (t.[user_type_id]=c.[user_type_id] AND t.[system_type_id]=c.[system_type_id])
		WHERE 
			Object_ID=@qnn_resp_object_id 
		ORDER BY 
			column_id;

		RAISERROR ('The columns in QNN_RESP are in an unexpected state. Skipping modifications. Please check before continuing. (Some information to assist in check has been selected to the results pane.)',
					16, -- Severity.
					1 -- State.
					);		
	END
END
