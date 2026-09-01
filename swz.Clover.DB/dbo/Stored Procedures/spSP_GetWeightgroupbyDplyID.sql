-- Batch submitted through debugger: SQLQuery3.sql|7|0|C:\Users\swz\AppData\Local\Temp\~vsFDAF.sql

CREATE PROCEDURE [dbo].[spSP_GetWeightgroupbyDplyID]

		@DplyId uniqueidentifier

AS
BEGIN
--
SET NOCOUNT ON;

			DECLARE @ListID AS CHAR(50),@TA AS INT, @MTS AS INT, @STS AS INT,@TS AS INT,@Statuses AS NVARCHAR(50), @Code AS NVARCHAR(50)

--SET @DplyId = '87AE3744-44C3-45D8-99DD-E94B6D597660'

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
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('TA','Take-All','Large Take-All'))

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('MTS','Take-Some Medium','Medium Take-All'))

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('STS','Take-Some Small','Medium Take-Some'))

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
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('TA','Take-All','Large Take-All'))

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('MTS','Take-Some Medium','Medium Take-All'))

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('STS','Take-Some Small','Medium Take-Some'))

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
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('TA','Take-All','Large Take-All'))

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('MTS','Take-Some Medium','Medium Take-All'))

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('STS','Take-Some Small','Medium Take-Some'))

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
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('TA','Take-All','Large Take-All'))

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('MTS','Take-Some Medium','Medium Take-All'))

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('STS','Take-Some Small','Medium Take-Some'))

					SELECT @TS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue ='TS')

					INSERT INTO ##tempReport 
					SELECT Code,'Non-Response',title,@TA,@MTS,@STS,(@TA+@MTS+@STS),@TS,(@TA+@TS) FROM QNN_STATUS WHERE Id = @Statuses 

					DELETE ##tempStatus where id = @Statuses

			END
		ELSE		
			BEGIN

					SELECT @TA = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId  AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('TA','Take-All','Large Take-All'))

					SELECT @MTS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('MTS','Take-Some Medium','Medium Take-All'))

					SELECT @STS = COUNT(*) FROM QNN_DPLY_SAMPLE_INFO 
					WHERE DplyId = @DplyId AND status= @Statuses AND ListSampleId IN (SELECT ListSampleId FROM QNN_LIST_SAMPLE_PROP WHERE ListId = @ListID AND PropValue IN ('STS','Take-Some Small','Medium Take-Some'))

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

			--SELECT * FROM ##tempReport where ResponseCategory = 'Active(Not Usable)' order by Status

			--SELECT * FROM ##tempReport GROUP BY ResponseCategory
			

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


 







