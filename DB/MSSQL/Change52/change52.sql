-- Implementation step:
-- 1. execute this script
ALTER PROCEDURE [dbo].[spSP_GetRespAnsWithDetails]

		@DplyId uniqueidentifier,
		@QnnId uniqueidentifier
		--@Skip INT = 0,
		--@Take	INT = 200

AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	-- Declare variables
	DECLARE @QnnFieldName varchar(50), 
				@Prop varchar(50),
				@sql varchar(MAX),
				@dplyName AS NVARCHAR(300),
				@qnnTitle AS NVARCHAR(300),
				@listName AS NVARCHAR(300),
				@listId AS uniqueidentifier

	set @dplyName = (select Name from qnn_dply where Id = @DplyId)
	set @qnnTitle = (select Title from qnn_qnn where Id = @QnnId)
	set @listName = (select l.Name from qnn_list l inner join qnn_dply d on d.ListId = l.Id where d.Id = @DplyId)
	set @listId = (select l.Id from qnn_list l inner join qnn_dply d on d.ListId = l.Id where d.Id = @DplyId)





	-- Create empty temporary table with system columns
	CREATE TABLE #tempTable (RespId uniqueidentifier NOT NULL, ListSampleId uniqueidentifier NOT NULL,
[ Deployment] nvarchar(300) NULL, [ Questionnaire] nvarchar(300) NULL, [ List] nvarchar(300) NULL, 
[ UID] nvarchar(320) NULL, [ Email] nvarchar(320) NULL, [ Name] nvarchar(128) NULL,  [ Username] nvarchar(256) NULL 
)

	---- Insert prop Columns into pivot table ----
	-- Declare cursor to loop through table
	DECLARE curProps CURSOR FOR
	SELECT UPPER(QUOTENAME(Alias)) 
														from qnn_list_prop where ListId = @ListId
														group by Alias, NumberId
														order by NumberId
	OPEN curProps

	FETCH NEXT FROM curProps INTO @Prop
	WHILE @@FETCH_STATUS=0
	BEGIN
		-- Defines each column
		SET @sql = 'ALTER TABLE #tempTable ADD ' + @Prop + ' nvarchar(MAX) NULL'
		-- Executes the command which creates the column in the temp table
		EXEC(@sql)
		FETCH NEXT FROM curProps INTO @Prop
	END

	-- Clean up cursor
	CLOSE curProps
	DEALLOCATE curProps

	-- Defines system columns
	SET @sql = 'ALTER TABLE #tempTable ADD [ Date Start] datetime NULL, [ Date Complete] datetime NULL, [ Status] nvarchar(30) NULL, [ Remarks] nvarchar(3000) NULL'
	-- Executes the command which creates the column in the temp table
	EXEC(@sql)


  --CREATE CLUSTERED INDEX ix_RespId ON #tempTable ([RespId]);
	---- Insert qnn field Columns into pivot table ----
	-- Declare cursor to loop through table
	DECLARE curFields CURSOR FOR
	SELECT     Name as QnnFieldName
	FROM         QNN_QNN_FIELD where QnnId = @QnnId order by NumberId 
	--OFFSET (@Skip) ROWS FETCH NEXT (@Take) ROWS ONLY

	OPEN curFields

	FETCH NEXT FROM curFields INTO @QnnFieldName
	WHILE @@FETCH_STATUS=0
	BEGIN
		-- Defines each column
		SET @sql = 'ALTER TABLE #tempTable ADD [' + @QnnFieldName + '] nvarchar(MAX) NULL'
		-- Executes the command which creates the column in the temp table
		EXEC(@sql)
		FETCH NEXT FROM curFields INTO @QnnFieldName
	END

	-- Clean up cursor
	CLOSE curFields
	DEALLOCATE curFields
	---- End of Insert Columns section ----

	---- Insert RespId values into pivot table ----
	-- Create rows in temp table using IDs from Survey table
	INSERT INTO [#tempTable] (RespId, ListSampleId)
	SELECT     Id, ListSampleId
	FROM         QNN_RESP where DplyId = @DplyId and QnnId = @QnnId order by NumberId


	--update value of system columms
	UPDATE [#tempTable] 
	SET [ UID] = p1.[ UID], 
			[ Email] = p1.[ Email],
			[ Name] = p1.[ Name],
			[ Username] = p1.[ Username],
			[ Date Start] = p1.[ Date Start],
			[ Date Complete] = p1.[ Date Complete],
			[ Status] = p1.[ Status],
			[ Remarks] = p1.[ Remarks],
			[ Deployment] = @dplyName,
			[ Questionnaire] = @qnnTitle,
			[ List] = @listName

	FROM 	(
		select 
		sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
		r.DateComplete as [ Date Complete], status.Title as [ Status], si.[Remarks] as [ Remarks], 
		r.NumberId, r.ListSampleId, r.Id as RespId from qnn_resp r
		inner join qnn_list_sample ls on r.ListSampleId = ls.Id
		inner join qnn_sample sample on sample.Id = ls.SampleId
		inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
		left join dwSecurityUser u on u.Id = r.UserId
		left join qnn_status status on status.Id = si.Status
		
		where r.DplyId = @DplyId and r.QnnId=@QnnId
		) p1 
	WHERE 
			p1.RespId = [#tempTable].RespId


	---- Insert data into pivot table ----
	-- Loop through each row in list sample props
	-- Update values in pivot table

	-- Declare variables
	DECLARE @ListSampleId uniqueidentifier, @ListSampleProp varchar(50), @ListSamplePropValue nvarchar(MAX), @CurrentListSampleId uniqueidentifier

	-- Initialize variables
	SET @CurrentListSampleId = NEWID()
	SET @sql = ''

	-- Declare cursor to loop through table
	DECLARE curPropValues CURSOR FOR
	select TOP 1000000000 qlsp.ListSampleId, qlp.Alias as PropAlias, qlsp.PropValue from qnn_list_sample_prop qlsp
	inner join qnn_list_sample qls on qls.Id = qlsp.ListSampleId
	inner join qnn_list_prop qlp on qlp.Id = qlsp.ListPropId
	where qls.ListId = @ListId 
  order by qlsp.ListSampleId


	OPEN curPropValues

	FETCH NEXT FROM curPropValues INTO @ListSampleId, @ListSampleProp, @ListSamplePropValue
	WHILE @@FETCH_STATUS=0
	BEGIN
		IF @CurrentListSampleId<>@ListSampleId
			BEGIN
			-- This will run at the end of a set of Fields related to one survey
			-- And initializes variables for next set of Fields
				IF @sql<>''
					BEGIN
						SET @sql = STUFF(@sql, LEN(@sql), 1, ' WHERE (ListSampleId = ''' + convert(varchar(36), @CurrentListSampleId) + ''');')
						EXEC(@sql)
					END
				SET @sql = 'UPDATE [#tempTable] SET'
				SET @CurrentListSampleId = @ListSampleId
			END

	-- Update values in pivot table
		IF @ListSamplePropValue='' or @ListSamplePropValue is NULL
			BEGIN
				SET @sql = @sql + ' ' + @ListSampleProp + ' = '''  + ''','
			END
		ELSE
			BEGIN
				SET @sql = @sql + ' ' + @ListSampleProp + ' = ''' + REPLACE(@ListSamplePropValue, '''', '''''') + ''','
			END



		FETCH NEXT FROM curPropValues INTO @ListSampleId, @ListSampleProp, @ListSamplePropValue

		-- This section takes care of the last row since it will not go through the IF @sql<>'' code above. Uses same code as that section
		IF @@FETCH_STATUS = -1
			BEGIN
				SET @sql = STUFF(@sql, LEN(@sql), 1, ' WHERE (ListSampleId = ''' + convert(varchar(36), @CurrentListSampleId) + ''');')
				EXEC(@sql)
			END
	END

	-- Clean up answers cursor
	CLOSE curPropValues
	DEALLOCATE curPropValues



	---- Insert data into pivot table ----
	-- Loop through each row in Survey_Answers
	-- Update values in pivot table

	-- Declare variables
	DECLARE @RespId uniqueidentifier, @QnnFieldName2 varchar(50), @Answer nvarchar(MAX), @CurrentRespId uniqueidentifier

	-- Initialize variables
	SET @CurrentRespId = NEWID()
	SET @sql = ''

	-- Declare cursor to loop through table
	DECLARE curAnswers CURSOR FOR
	SELECT TOP 1000000000  r.Id as RespId, f.Name as QnnFieldName, a.AnsVal
	FROM         QNN_RESP_ANS a 
	INNER JOIN QNN_QNN_FIELD f on f.Id = a.QnnFieldId
	INNER JOIN QNN_RESP r on r.Id = a.RespId
	where r.DplyId = @DplyId and f.Id in
	(SELECT     Id
	FROM         QNN_QNN_FIELD where QnnId = @QnnId 
	--order by NumberId 
	--OFFSET (@Skip) ROWS FETCH NEXT (@Take) ROWS ONLY
	)

	order by r.NumberId, f.NumberId


	OPEN curAnswers

	FETCH NEXT FROM curAnswers INTO @RespId, @QnnFieldName2, @Answer
	WHILE @@FETCH_STATUS=0
	BEGIN
		IF @CurrentRespId<>@RespId
			BEGIN
			-- This will run at the end of a set of Fields related to one survey
			-- And initializes variables for next set of Fields
				IF @sql<>''
					BEGIN
						SET @sql = STUFF(@sql, LEN(@sql), 1, ' WHERE (RespId = ''' + convert(varchar(36), @CurrentRespId) + ''');')
						EXEC(@sql)
					END
				SET @sql = 'UPDATE [#tempTable] SET'
				SET @CurrentRespId = @RespId
			END

	-- Update values in pivot table
		IF @Answer='' or @Answer is NULL
			BEGIN
				SET @sql = @sql + ' ' + @QnnFieldName2 + ' = '''  + ''','
			END
		ELSE
			BEGIN
				SET @sql = @sql + ' ' + @QnnFieldName2 + ' = ''' + REPLACE(@Answer, '''', '''''') + ''','
			END



		FETCH NEXT FROM curAnswers INTO @RespId, @QnnFieldName2, @Answer

		-- This section takes care of the last row since it will not go through the IF @sql<>'' code above. Uses same code as that section
		IF @@FETCH_STATUS = -1
			BEGIN
				SET @sql = STUFF(@sql, LEN(@sql), 1, ' WHERE (RespId = ''' + convert(varchar(36), @CurrentRespId) + ''');')
				EXEC(@sql)
			END
	END

	-- Clean up answers cursor
	CLOSE curAnswers
	DEALLOCATE curAnswers

	ALTER TABLE [#tempTable] 
    DROP COLUMN RespId, ListSampleId;


	-- Select values from created table
	SELECT * from [#tempTable] 

	-- Clean up the pivot table
	DROP TABLE #tempTable
END
