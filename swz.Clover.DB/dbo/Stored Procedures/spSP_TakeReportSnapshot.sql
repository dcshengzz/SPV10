





CREATE PROCEDURE [dbo].[spSP_TakeReportSnapshot]
	@DplyId UNIQUEIDENTIFIER
AS
BEGIN TRY
	
	-- This procedure was previously named spSP_GetTaskScheduler
	-- Its purpose is to extract and write today's batch of response counts by weightgroup
	-- into QNN_REPORT_SNAPSHOT for use in certain reports. 
	-- See also: spSP_GetDailySnapshot

	SET XACT_ABORT, NOCOUNT ON;

	BEGIN TRANSACTION take_report_snapshot;
	
	DECLARE @BatchNo NVARCHAR(50) = REPLACE(CONVERT(VARCHAR, GETDATE(),101),'/','');

	-- Part I:
	-- Extract response counts for the deployment into temp table #tempReport

	CREATE TABLE #tempReport (
		[StatusId] UNIQUEIDENTIFIER,
		[ResponseCategory] NVARCHAR(50),
		[TA] INT, 
		[MTS] INT, 
		[STS] INT, 
		[Total] INT, --will be TA + MTS + STS
		[TS] INT, --TS comes after Total because its not included in Total
		[TOTALS] INT); --will be TA + TS

	DECLARE 
		@ListId UNIQUEIDENTIFIER,
		@TA INT, 
		@MTS INT, 
		@STS INT,
		@TS INT,
		@StatusIdExtracting UNIQUEIDENTIFIER, 
		@StatusCode VARCHAR(20),
		@ResponseCategory NVARCHAR(50);
	
	SELECT @ListId = ListId FROM QNN_DPLY WHERE Id= @DplyId;
	
	-- Will select one at a time and delete from the temp table after processing till all processed
	SELECT Id, Code INTO #tempStatus FROM QNN_STATUS ORDER BY Code; 

	--Iterate each status and extract response counts of respondents in various weightgroups
	SELECT TOP 1 @StatusIdExtracting=Id, @StatusCode=Code FROM #tempStatus ORDER BY Code; 
	WHILE @@ROWCOUNT <> 0
	BEGIN 	
		-- Note that the weightgroup value can be found in ANY prop, the name is not checked
		-- Users must therefore be careful not to set these values in unrelated props (i.e. TA, MTS, STS, TS) 

		SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
			WHERE DplyId = @DplyId  AND [Status]= @StatusIdExtracting AND ListSampleId IN (
				SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListId AND PropValue IN ('TA','Take-All','Large Take-All'));					

		SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
			WHERE DplyId = @DplyId AND [Status]= @StatusIdExtracting AND ListSampleId IN (
				SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListId AND PropValue IN ('MTS','Take-Some Medium','Medium Take-All'));

		SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
			WHERE DplyId = @DplyId AND [Status]= @StatusIdExtracting AND ListSampleId IN (
				SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListId AND PropValue IN ('STS','Take-Some Small','Medium Take-Some'));

		SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
			WHERE DplyId = @DplyId AND [Status]= @StatusIdExtracting AND ListSampleId IN (
				SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListId AND PropValue ='TS');

		SELECT @ResponseCategory=CASE
			WHEN @StatusCode IN ('RC', 'DE', 'SB', 'CL')				THEN 'Active(Usable)'
			WHEN @StatusCode IN ('CR', 'PR', 'IE', 'EM', 'OS', 'HC')	THEN 'Active(Not Usable)'
			WHEN @StatusCode IN ('CO', 'DM', 'SO', 'NI')				THEN 'Inactive'
			WHEN @StatusCode IN ('PE', 'BO')							THEN 'Non-Response'
			ELSE ' ' END;  --covers AC (and any others that are added)
		
		INSERT INTO #tempReport (StatusId, ResponseCategory, TA, MTS, STS, Total, TS, TOTALS)
			VALUES (@StatusIdExtracting, @ResponseCategory, @TA, @MTS, @STS, (@TA+@MTS+@STS), @TS, (@TA+@TS));

		--Get the next status to process
		DELETE FROM #tempStatus WHERE Id=@StatusIdExtracting;
		SELECT TOP 1 @StatusIdExtracting=Id, @StatusCode=Code FROM #tempStatus ORDER BY Code; 
	END --end while iterating tempstatus
		



	-- Part II
	-- Copy the batch of data from tempReport to QNN_REPORT_SNAPSHOT

	DECLARE 
		@SumTA INT,
		@SumMTS INT,
		@SumSTS INT,
		@SumTS INT,
		@StatusIdCopying UNIQUEIDENTIFIER;

	--We will now iterate all the status (indeterminate order) from the tempReport and write snapshot data to QNN_REPORT_SNAPSHOT
	SELECT StatusId INTO #tempStatusId FROM #tempReport;
	SELECT TOP 1 @StatusIdCopying = [StatusId] FROM #tempStatusId; 			
	WHILE @@ROWCOUNT <> 0	
	BEGIN 
		SELECT @SumTA  = SUM(TA)  FROM #tempReport WHERE [StatusId]=@StatusIdCopying;
		SELECT @SumMTS = SUM(MTS) FROM #tempReport WHERE [StatusId]=@StatusIdCopying;
		SELECT @SumSTS = SUM(STS) FROM #tempReport WHERE [StatusId]=@StatusIdCopying;
		SELECT @SumTS  = SUM(TS)  FROM #tempReport WHERE [StatusId]=@StatusIdCopying;		
		
		INSERT INTO QNN_REPORT_SNAPSHOT
			(Id, DplyId, [Status], Weightgroup, [Count], CreatedDate, BatchNo) 
			VALUES 
			(NewID(), @DplyId, @StatusIdCopying, 'TA',  @SumTA,  GETDATE(), @BatchNo),
			(NewID(), @DplyId, @StatusIdCopying, 'MTS', @SumMTS, GETDATE(), @BatchNo),
			(NewID(), @DplyId, @StatusIdCopying, 'STS', @SumSTS, GETDATE(), @BatchNo),
			(NewID(), @DplyId, @StatusIdCopying, 'TS',  @SumTS,  GETDATE(), @BatchNo);

		--Get the next status to process
		DELETE FROM #tempStatusId WHERE StatusID=@StatusIdCopying;
		SELECT TOP 1 @StatusIdCopying=StatusId FROM #tempStatusId;			
	END --end while iterating tempStatusId
	



	-- Part III
	-- Return a resultset to caller (for testing / verification purpose)
	-- TODO: currently the Hangfire job that calls us just ignores this but it should use it to verify that
	--       desired info was extracted. We may wish to modify what info is returned here accordingly.

	SELECT 
		s.Code AS Code,		
		tr.ResponseCategory,
		s.Title AS [Status], 
		tr.TA,
		tr.MTS,
		tr.STS,
		tr.Total,
		tr.TS,
		tr.TOTALS
	FROM
		#tempReport tr
		LEFT JOIN QNN_STATUS s ON s.Id=tr.StatusId
	ORDER BY
		ResponseCategory;
	COMMIT TRANSACTION take_report_snapshot;

	-- n.b. the local temp tables are dropped automatically when procedure exits

END TRY
BEGIN CATCH	

	ROLLBACK TRANSACTION take_report_snapshot;

	DECLARE 
		@ErrorMessage NVARCHAR(4000),
		@ErrorSeverity INT,
		@ErrorState INT;  

	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

	RAISERROR (
		@ErrorMessage, -- Message text.  
		@ErrorSeverity, -- Severity.  
		@ErrorState -- State.  
	);
END CATCH