USE [surveyplus.net]
GO

--StoredProcedure  [dbo].[spSP_UpdateDplyScheduler] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSP_UpdateDplyScheduler]

@DplyId uniqueidentifier,
@EmailSuccess bit,
@EmailFailure bit,
@UpdatedBy nvarchar(50),
@EmailRecipient nvarchar(max),
@UpdatedDate datetime
	

AS
BEGIN
--
SET NOCOUNT ON;

BEGIN

Update QNN_DPLY_SCHEDULER
set EmailSuccess = @EmailSuccess,EmailFailure = @EmailFailure, EmailRecipients = @EmailRecipient, UpdatedBy = @UpdatedBy, UpdatedDate = @UpdatedDate
where DplyId = @DplyId
	
	
END

END

--StoredProcedure [dbo].[spSP_GetWeightgroupbyDplyID]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spSP_GetWeightgroupbyDplyID]

		@DplyId uniqueidentifier

AS
BEGIN
--
SET NOCOUNT ON;

			DECLARE @ListID AS CHAR(50),@TA AS INT, @MTS AS INT, @STS AS INT,@TS AS INT,@Statuses AS NVARCHAR(50), @Code AS NVARCHAR(50)

BEGIN

			CREATE TABLE ##tempReport (Code NVARCHAR(5),ResponseCategory NVARCHAR(50),Status NVARCHAR(50), TA INT, MTS INT, STS INT, Total INT,TS INT,TOTALS INT)--TO STORE FINAL RESULT, No INT NOT NULL IDENTITY (1,1)

			SELECT @ListID = ListId FROM QNN_DPLY WHERE Id= @DplyId ---- FETCH LISTID BY DPLYID FROM QNN_DPLY

SET ROWCOUNT 0

			SELECT id,Code INTO ##tempStatus FROM QNN_STATUS order by Code -- HOLD ALL THE STATUSES IN THE TEMPSTATUS TABLE
			
SET ROWCOUNT 1


			SELECT @statuses = id, @Code = Code FROM ##tempStatus 

BEGIN

 WHILE @@ROWCOUNT <> 0

	BEGIN 

		SET ROWCOUNT 0
		IF((@Code = 'RC') OR (@Code = 'DE') OR (@Code = 'SB') OR (@Code = 'CL'))

			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Active(Usable)',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE
		IF((@Code = 'CR') OR (@Code = 'PR') OR (@Code = 'IE') OR (@Code = 'EM') OR (@Code = 'OS')OR (@Code = 'HC'))

			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Active(Not Usable)',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE
		IF((@Code = 'CO') OR (@Code = 'DM') OR (@Code = 'SO') OR (@Code = 'NI'))

			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Inactive',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE
		IF((@Code = 'PE') OR (@Code = 'BO'))

			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Non-Response',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE		
			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,' ',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END

		
		SET ROWCOUNT 1

			SELECT @Statuses = id,@Code = Code FROM ##tempStatus

			

	END

END

SET ROWCOUNT 0


			SELECT * FROM ##tempReport order by ResponseCategory

			IF (SELECT object_id = '##tempStatus') IS NOT NULL

			BEGIN 

				DROP TABLE ##tempStatus

			END

				IF(SELECT object_id = '##tempReport') IS NOT NULL

			BEGIN 

				DROP TABLE ##tempReport

			End

END
END

--StoredProcedure [dbo].[spSP_GetTaskScheduler]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSP_GetTaskScheduler]

		@DplyId uniqueidentifier

AS
BEGIN
--
SET NOCOUNT ON;

			DECLARE @ListID AS CHAR(50),@TA AS INT, @MTS AS INT, @STS AS INT,@TS AS INT,@Statuses AS NVARCHAR(50), @Code AS NVARCHAR(50),@sumTA AS INT,@SumMTS AS INT,@sumSTS AS INT, @sumTS AS INT,@Title AS NVARCHAR(50),@SID uniqueidentifier,@CreatedDate datetime,@BatchNo nvarchar(50)

   SET @CreatedDate = convert(varchar, getdate(), 10) 
  SET @BatchNo = replace(convert(varchar, getdate(),101),'/','')

BEGIN

			CREATE TABLE ##tempReport (Code NVARCHAR(5),ResponseCategory NVARCHAR(50),Status NVARCHAR(50), TA INT, MTS INT, STS INT, Total INT,TS INT,TOTALS INT)--TO STORE FINAL RESULT, No INT NOT NULL IDENTITY (1,1)

			SELECT @ListID = ListId FROM QNN_DPLY WHERE Id= @DplyId ---- FETCH LISTID BY DPLYID FROM QNN_DPLY

SET ROWCOUNT 0

			SELECT id,Code INTO ##tempStatus FROM QNN_STATUS order by Code -- HOLD ALL THE STATUSES IN THE TEMPSTATUS TABLE
			
SET ROWCOUNT 1


			SELECT @statuses = id, @Code = Code FROM ##tempStatus 

BEGIN

 WHILE @@ROWCOUNT <> 0

	BEGIN 

		SET ROWCOUNT 0
		IF((@Code = 'RC') OR (@Code = 'DE') OR (@Code = 'SB') OR (@Code = 'CL'))

			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')					

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Active(Usable)',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE
		IF((@Code = 'CR') OR (@Code = 'PR') OR (@Code = 'IE') OR (@Code = 'EM') OR (@Code = 'OS')OR (@Code = 'HC'))

			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Active(Not Usable)',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE
		IF((@Code = 'CO') OR (@Code = 'DM') OR (@Code = 'SO') OR (@Code = 'NI'))

			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Inactive',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

					

			END
		ELSE
		IF((@Code = 'PE') OR (@Code = 'BO'))

			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Non-Response',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE		
			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TA')				

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='MTS')

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='STS')

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,' ',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END

		
		SET ROWCOUNT 1

		

			SELECT @Statuses = id,@Code = Code FROM ##tempStatus

			

	END

END
SET ROWCOUNT 0

          
			SELECT * FROM ##tempReport order by ResponseCategory
		   

SET ROWCOUNT 0
			SELECT Status INTO ##tempStatusTitle FROM ##tempReport 
SET ROWCOUNT 1
	
	
			SELECT @Title = Status FROM ##tempStatusTitle 
			
BEGIN

	WHILE @@ROWCOUNT <> 0
	

		BEGIN 

				SET ROWCOUNT 0

							SELECT @sumTA =  SUM (TA) from ##tempReport where Status = @Title
							SELECT @SumMTS = SUM(MTS) from ##tempReport where Status = @Title 
							SELECT @sumSTS = SUM(STS) from ##tempReport where Status = @Title
							SELECT @sumTS = SUM(TS) from ##tempReport where Status = @Title
							
							SELECT @SID = ID FROM QNN_STATUS WHERE Title = @Title

							INSERT INTO QNN_REPORT_SNAPSHOT (Id,DplyId,Status,Weightgroup,Count,CreatedDate,BatchNo)
							VALUES (NewID(),@DplyId,@SID,'TA',@sumTA,GETDATE(),@BatchNo)
							INSERT INTO QNN_REPORT_SNAPSHOT (Id,DplyId,Status,Weightgroup,Count,CreatedDate,BatchNo)
							VALUES (NewID(),@DplyId,@SID,'MTS',@SumMTS,GETDATE(),@BatchNo)
							INSERT INTO QNN_REPORT_SNAPSHOT (Id,DplyId,Status,Weightgroup,Count,CreatedDate,BatchNo)
							VALUES (NewID(),@DplyId,@SID,'STS',@sumSTS,GETDATE(),@BatchNo)
							INSERT INTO QNN_REPORT_SNAPSHOT (Id,DplyId,Status,Weightgroup,Count,CreatedDate,BatchNo)
							VALUES (NewID(),@DplyId,@SID,'TS',@sumTS,GETDATE(),@BatchNo)

							DELETE ##tempStatusTitle where Status = @Title
			 
				SET ROWCOUNT 1

		

			SELECT @Title = Status FROM ##tempStatusTitle 
	
	
		
	END

END
SET ROWCOUNT 0

	
		
			IF (SELECT object_id = '##tempStatus') IS NOT NULL

			BEGIN 

				DROP TABLE ##tempStatus

			END

				IF(SELECT object_id = '##tempReport') IS NOT NULL

			BEGIN 

				DROP TABLE ##tempReport

			End

			IF(SELECT object_id = '##tempStatusTitle') IS NOT NULL

			BEGIN 

				DROP TABLE ##tempStatusTitle

			End


END
END

--StoredProcedure [dbo].[spSP_GetdataforDplyScheduler]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSP_GetdataforDplyScheduler]

@DplyId uniqueidentifier,
@JobDescription nvarchar(max),
@EmailSuccess bit,
@EmailFailure bit,
@LastRunJob datetime,	
@CreatedBy uniqueidentifier,
@UpdatedBy uniqueidentifier,
@UpdatedDate datetime,
@EmailRecipient nvarchar(max)
	

AS
BEGIN
--
SET NOCOUNT ON;

BEGIN



INSERT INTO QNN_DPLY_SCHEDULER VALUES(NEWID(),@DplyId,@JobDescription,@EmailSuccess,@EmailFailure,@EmailRecipient,@LastRunJob,GETDATE(),@CreatedBy,@UpdatedDate,@UpdatedBy)
			
END

END
 

--StoredProcedure [dbo].[spSP_DeleteTaskScheduler] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSP_DeleteTaskScheduler]

		@DplyId uniqueidentifier
	

AS
BEGIN
--
SET NOCOUNT ON;
			
			Delete QNN_DPLY_SCHEDULER where DplyId = @DplyId

END


--StoredProcedure [dbo].[spSP_GetDailySnapShot]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spSP_GetDailySnapShot]

		@DplyId uniqueidentifier,
		@BatchNo as nvarchar(50)


AS


BEGIN
--
SET NOCOUNT ON;

			DECLARE @TA AS INT, @MTS AS INT, @STS AS INT,@TS AS INT,@Statuses AS NVARCHAR(50), @Code AS NVARCHAR(50)


BEGIN



			CREATE TABLE ##tempReport (Code NVARCHAR(5),ResponseCategory NVARCHAR(50),Status NVARCHAR(50), TA INT, MTS INT, STS INT, Total INT,TS INT,TOTALS INT)
			

SET ROWCOUNT 0

			SELECT id,Code INTO ##tempStatus FROM QNN_STATUS order by Code -- HOLD ALL THE STATUSES IN THE TEMPSTATUS TABLE
			
SET ROWCOUNT 1


			SELECT @statuses = id, @Code = Code FROM ##tempStatus 

BEGIN

 WHILE @@ROWCOUNT <> 0

	BEGIN 

		SET ROWCOUNT 0
		IF((@Code = 'RC') OR (@Code = 'DE') OR (@Code = 'SB') OR (@Code = 'CL'))

			BEGIN

			SELECT TOP 1 @TA = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TA' and BatchNo = @BatchNo 
			SELECT TOP 1 @MTS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'MTS' and BatchNo = @BatchNo
			SELECT TOP 1 @STS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'STS' and BatchNo = @BatchNo
			SELECT TOP 1 @TS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TS' and BatchNo = @BatchNo
			INSERT INTO ##tempReport 
		    SELECT Code,'Active(Usable)',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

	     	DELETE ##tempStatus where id = @Statuses

			END

		ELSE

		IF((@Code = 'CR') OR (@Code = 'PR') OR (@Code = 'IE') OR (@Code = 'EM') OR (@Code = 'OS')OR (@Code = 'HC'))

			BEGIN

			SELECT TOP 1 @TA = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TA' and BatchNo = @BatchNo 
			SELECT TOP 1 @MTS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'MTS' and BatchNo = @BatchNo
			SELECT TOP 1 @STS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'STS' and BatchNo = @BatchNo
			SELECT TOP 1 @TS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TS' and BatchNo = @BatchNo
		
	        INSERT INTO ##tempReport 
	        SELECT Code,'Active(Not Usable)',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

	        DELETE ##tempStatus where id = @Statuses

			END
		ELSE
		IF((@Code = 'CO') OR (@Code = 'DM') OR (@Code = 'SO') OR (@Code = 'NI'))

			BEGIN

			SELECT TOP 1 @TA = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TA' and BatchNo = @BatchNo 
			SELECT TOP 1 @MTS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'MTS' and BatchNo = @BatchNo
			SELECT TOP 1 @STS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'STS' and BatchNo = @BatchNo
			SELECT TOP 1 @TS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TS' and BatchNo = @BatchNo
		
		   INSERT INTO ##tempReport 
		   SELECT Code,'Inactive',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

		   DELETE ##tempStatus where id = @Statuses

			END
		ELSE
		IF((@Code = 'PE') OR (@Code = 'BO'))

			BEGIN

		    SELECT TOP 1 @TA = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TA' and BatchNo = @BatchNo 
			SELECT TOP 1 @MTS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'MTS' and BatchNo = @BatchNo
			SELECT TOP 1 @STS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'STS' and BatchNo = @BatchNo
			SELECT TOP 1 @TS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TS' and BatchNo = @BatchNo
					INSERT INTO ##tempReport 
					SELECT Code,'Non-Response',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE		
			BEGIN

			SELECT TOP 1 @TA = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TA' and BatchNo = @BatchNo 
			SELECT TOP 1 @MTS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'MTS' and BatchNo = @BatchNo
			SELECT TOP 1 @STS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'STS' and BatchNo = @BatchNo
			SELECT TOP 1 @TS = Count from QNN_REPORT_SNAPSHOT where DplyId = @DplyId and Status = @Statuses and Weightgroup = 'TS' and BatchNo = @BatchNo
					INSERT INTO ##tempReport 
					SELECT Code,' ',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END

		
		SET ROWCOUNT 1

			SELECT @Statuses = id,@Code = Code FROM ##tempStatus

			

	END

END

SET ROWCOUNT 0


			SELECT * FROM ##tempReport order by ResponseCategory

			IF (SELECT object_id = '##tempStatus') IS NOT NULL

			BEGIN 

				DROP TABLE ##tempStatus

			END

				IF(SELECT object_id = '##tempReport') IS NOT NULL

			BEGIN 

				DROP TABLE ##tempReport

			End

END
END


--StoredProcedure [dbo].[spSP_GetWeek] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery3.sql|7|0|C:\Users\swz\AppData\Local\Temp\~vsFDAF.sql

CREATE PROCEDURE [dbo].[spSP_GetWeek]

		@DplyId uniqueidentifier,
		@Flag nvarchar(50)
		

AS
BEGIN

IF(@Flag = 'Start')

BEGIN
SELECT TOP 1 CreatedDate FROM QNN_REPORT_SNAPSHOT WHERE DplyId = @DplyId order by CreatedDate ASC
END

ELSE IF (@Flag = 'List')

BEGIN
SELECT BatchNo FROM QNN_REPORT_SNAPSHOT WHERE DplyId = @DplyId
END

ElSE 

BEGIN
SELECT TOP 1 CreatedDate FROM QNN_REPORT_SNAPSHOT WHERE DplyId = @DplyId order by CreatedDate desc
END
	
END


--[dbo].[QNN_REPORT_SNAPSHOT] 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QNN_REPORT_SNAPSHOT](
	[Id] [uniqueidentifier] NULL,
	[BatchNo] [nvarchar](50) NULL,
	[NumberId] [int] IDENTITY(1,1) NOT NULL,
	[DplyId] [uniqueidentifier] NULL,
	[Status] [uniqueidentifier] NULL,
	[Weightgroup] [nvarchar](25) NULL,
	[Count] [int] NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]
GO


-- Table [dbo].[QNN_DPLY_SCHEDULER] 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QNN_DPLY_SCHEDULER](
	[Id] [uniqueidentifier] NOT NULL,
	[DplyId] [uniqueidentifier] NULL,
	[JobDescription] [nvarchar](50) NULL,
	[EmailSuccess] [bit] NULL,
	[EmailFailure] [bit] NULL,
	[EmailRecipients] [nvarchar](max) NULL,
	[LastJobRun] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
 CONSTRAINT [PK_QNN_DPLY_SCHEDULER] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
















