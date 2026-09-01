-- Batch submitted through debugger: SQLQuery3.sql|7|0|C:\Users\swz\AppData\Local\Temp\~vsFDAF.sql

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


 










 







