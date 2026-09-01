--DB compatability level for SurveyPlus v8
--Verify that the compatability level of the current database is at least 150 (SQL Server 2019)
PRINT 'Verifying that database has correct compatability level set (>=150)';
DECLARE @current_database nvarchar(max);
DECLARE @compatability_level int;
SELECT @current_database = DB_NAME();
SELECT @compatability_level=compatibility_level FROM sys.databases WHERE name=@current_database;
IF(@compatability_level<150) 
	BEGIN
		DECLARE @msg nvarchar(max);
		SET @msg = 'The database compatability level is ' + CAST(@compatability_level as varchar)
			+ CHAR(13)+CHAR(10)
			+ 'This is incorrect for SurveyPlus v8, please set to 150 (SQL Server 2019 level)' 
			+ CHAR(13)+CHAR(10)
			+ '(Technical limitations prevent this script issuing the command itself)' 
			+ CHAR(13)+CHAR(10) + CHAR(13)+CHAR(10)
			+ 'You may issue the following statement to do this:' 
			+ CHAR(13)+CHAR(10)
			+ 'ALTER DATABASE ' + @current_database + ' SET COMPATIBILITY_LEVEL = 150;';
		RAISERROR (@msg, -- Message text.
				   16, -- Severity.
				   1 -- State.
				   );
	END
ELSE
	BEGIN
		PRINT 'Ok - compatability level ' + CAST(@compatability_level as varchar) + ' found';
	END