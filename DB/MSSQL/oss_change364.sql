/* Upgrade QNN_STATUS code */
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'QNN_STATUS' AND COLUMN_NAME = 'Code'
AND DATA_TYPE = 'varchar' AND CHARACTER_MAXIMUM_LENGTH = 20)
	BEGIN
		PRINT 'Start to upgrade QNN_STATUS code';
		/* Add a temp column to store the code */
		EXEC ('ALTER TABLE [dbo].[QNN_STATUS] ADD TempCode varchar(20)');

		/* Copy the Code column to temp column */
		PRINT 'Copying Code to TempCode';
		EXEC ('UPDATE [dbo].[QNN_STATUS] SET TempCode = Code');

		/* Drop Original Code Column */
		EXEC ('ALTER TABLE [dbo].[QNN_STATUS] DROP COLUMN Code');

		/* Add Code Column with varchar(20) */
		EXEC ('ALTER TABLE [dbo].[QNN_STATUS] ADD Code varchar(20)');

		/* Copy the Code column to temp column */
		PRINT 'Copying TempCode to Code';
		EXEC ('UPDATE [dbo].[QNN_STATUS] SET Code = TempCode');

		/* Update column NULL to NOT NULL */
		EXEC ('ALTER TABLE [dbo].[QNN_STATUS] ALTER COLUMN Code VARCHAR(20) NOT NULL');

		/* Drop TempCode Column */
		EXEC ('ALTER TABLE [dbo].[QNN_STATUS] DROP COLUMN TempCode');
		PRINT 'Upgrade QNN_STATUS code is completed';
	END
ELSE
	PRINT 'QNN_STATUS Code is already upgraded to varchar(20)';
