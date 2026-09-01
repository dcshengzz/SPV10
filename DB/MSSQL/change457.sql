SET ANSI_NULLS ON
GO

-- change457.sql
-- Schema change to fix ordering of data returned by stored procedure spSP_GetWeek

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spSP_GetWeek]
	@DplyId uniqueidentifier,
	@Flag nvarchar(50)		

AS
BEGIN
	IF(@Flag = 'Start')
		BEGIN
			SELECT TOP 1 CreatedDate FROM QNN_REPORT_SNAPSHOT WHERE DplyId = @DplyId ORDER BY CreatedDate ASC;
		END
	ELSE IF (@Flag = 'List')
		BEGIN
			SELECT BatchNo FROM QNN_REPORT_SNAPSHOT WHERE DplyId = @DplyId;
		END
	ELSE IF (@Flag = 'Distinct')
		BEGIN
			SELECT DISTINCT CreatedDate FROM QNN_REPORT_SNAPSHOT WHERE DplyId = @DplyId ORDER BY CreatedDate ASC;
		END
	ElSE 
		BEGIN
			SELECT TOP 1 CreatedDate FROM QNN_REPORT_SNAPSHOT WHERE DplyId = @DplyId ORDER BY CreatedDate DESC;
		END	
END
GO


