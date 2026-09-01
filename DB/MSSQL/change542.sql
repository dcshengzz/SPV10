-- Will make QNN_DPLY.IsIncludeUnansweredSection a NOT NULL column
-- For any old deployments where this has a NULL value in the columns it will be changed to to 0 (false value).

IF EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='QNN_DPLY' AND COLUMN_NAME = 'IsIncludeUnansweredSection' AND IS_NULLABLE='YES')
BEGIN
	RAISERROR ('Updating IsIncludeUnansweredSection to be not null', 0,0) WITH NOWAIT;
	-- Initialise the value of IsIncludeUnansweredSection in old QNN_DPLY rows with default value
	UPDATE QNN_DPLY 
		SET [IsIncludeUnansweredSection]=0 
		WHERE [IsIncludeUnansweredSection] IS NULL;
	ALTER TABLE QNN_DPLY ALTER COLUMN IsIncludeUnansweredSection BIT NOT NULL;	
END
ELSE
BEGIN
	RAISERROR ('IsIncludeUnansweredSection already defined as not null, no further action required', 0,0) WITH NOWAIT;
END

