USE [msdb]
GO

/****** Object:  Job [index defragmentation]    Script Date: 24/4/2020 8:15:38 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 24/4/2020 8:15:38 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'index defragmentation', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Daily index defragmentation at 2am', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1]    Script Date: 24/4/2020 8:15:38 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- Script 4: Automatically analyze and defragment indexes

-- Set variables
-- *********************************************************************************************
SET NOCOUNT ON

DECLARE @reorg_frag_thresh   float  SET @reorg_frag_thresh  = 10.0
DECLARE @rebuild_frag_thresh float  SET @rebuild_frag_thresh = 30.0
DECLARE @fill_factor         tinyint  SET @fill_factor = 0
DECLARE @report_only         bit  SET @report_only = 0
DECLARE @page_count_thresh   smallint SET @page_count_thresh = 1
-- *********************************************************************************************
DECLARE @objectid       int
DECLARE @indexid        int
DECLARE @partitioncount bigint
DECLARE @schemaname     nvarchar(130) 
DECLARE @objectname     nvarchar(130) 
DECLARE @indexname      nvarchar(130) 
DECLARE @partitionnum   bigint
DECLARE @partitions     bigint
DECLARE @frag           float
DECLARE @page_count     int
DECLARE @command        nvarchar(4000)
DECLARE @intentions     nvarchar(4000)
DECLARE @table_var      TABLE(
                          objectid     int,
                          indexid      int,
                          partitionnum int,
                          frag         float,
        page_count   int
                        )
INSERT INTO
    @table_var
SELECT
    [object_id]                    AS objectid,
    [index_id]                     AS indexid,
    [partition_number]             AS partitionnum,
    [avg_fragmentation_in_percent] AS frag,
    [page_count]      AS page_count
FROM
    sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, ''LIMITED'')
WHERE
    [avg_fragmentation_in_percent] > @reorg_frag_thresh 
  AND
  page_count > @page_count_thresh
  AND
    index_id > 0  
 DECLARE partitions CURSOR FOR
    SELECT * FROM @table_var 
OPEN partitions 
WHILE (1=1) BEGIN
    FETCH NEXT
        FROM partitions
        INTO @objectid, @indexid, @partitionnum, @frag, @page_count 
    IF @@FETCH_STATUS < 0 BREAK
    SELECT
        @objectname = QUOTENAME(o.[name]),
        @schemaname = QUOTENAME(s.[name])
    FROM
        sys.objects AS o WITH (NOLOCK)
        JOIN sys.schemas AS s WITH (NOLOCK)
        ON s.[schema_id] = o.[schema_id]
    WHERE
        o.[object_id] = @objectid 
    SELECT
        @indexname = QUOTENAME([name])
    FROM
        sys.indexes WITH (NOLOCK)
    WHERE
        [object_id] = @objectid AND
        [index_id] = @indexid 
    SELECT
        @partitioncount = count (*)
    FROM
        sys.partitions WITH (NOLOCK)
    WHERE
        [object_id] = @objectid AND
        [index_id] = @indexid    
    SET @intentions =
        @schemaname + N''.'' +
        @objectname + N''.'' +
        @indexname + N'':'' + CHAR(13) + CHAR(10)
    SET @intentions =
        REPLACE(SPACE(LEN(@intentions)), '' '', ''='') + CHAR(13) + CHAR(10) +
        @intentions
    SET @intentions = @intentions +
        N'' FRAGMENTATION: '' + CAST(@frag AS nvarchar) + N''%'' + CHAR(13) + CHAR(10) +
        N'' PAGE COUNT: ''    + CAST(@page_count AS nvarchar) + CHAR(13) + CHAR(10) 
    IF @frag < @rebuild_frag_thresh BEGIN
        SET @intentions = @intentions +
            N'' OPERATION: REORGANIZE'' + CHAR(13) + CHAR(10)
        SET @command =
            N''ALTER INDEX '' + @indexname +
            N'' ON '' + @schemaname + N''.'' + @objectname +
            N'' REORGANIZE; '' + 
            N'' UPDATE STATISTICS '' + @schemaname + N''.'' + @objectname + 
            N'' '' + @indexname + '';''
    END
    IF @frag >= @rebuild_frag_thresh BEGIN
        SET @intentions = @intentions +
            N'' OPERATION: REBUILD'' + CHAR(13) + CHAR(10)
        SET @command =
            N''ALTER INDEX '' + @indexname +
            N'' ON '' + @schemaname + N''.'' +     @objectname +
            N'' REBUILD''
    END
    IF @partitioncount > 1 BEGIN
        SET @intentions = @intentions +
            N'' PARTITION: '' + CAST(@partitionnum AS nvarchar(10)) + CHAR(13) + CHAR(10)
        SET @command = @command +
            N'' PARTITION='' + CAST(@partitionnum AS nvarchar(10))
    END
    IF @frag >= @rebuild_frag_thresh AND @fill_factor > 0 AND @fill_factor < 100 BEGIN
        SET @intentions = @intentions +
            N'' FILL FACTOR: '' + CAST(@fill_factor AS nvarchar) + CHAR(13) + CHAR(10)
        SET @command = @command +
            N'' WITH (FILLFACTOR = '' + CAST(@fill_factor AS nvarchar) + '')''
    END
    IF @report_only = 0 BEGIN
        SET @intentions = @intentions + N'' EXECUTING: '' + @command
        PRINT @intentions     
        EXEC (@command)
    END ELSE BEGIN
        PRINT @intentions
    END
        PRINT @command
END
CLOSE partitions
DEALLOCATE partitions
GO', 
		@database_name=N'SIMSProduction', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily Index defragmantation', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20200424, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, 
		@schedule_uid=N'32337550-1bf0-44ea-982c-bb1841b18476'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


