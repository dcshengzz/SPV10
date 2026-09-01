
CREATE PROCEDURE [dbo].[spSP_CountRecurrenceAfter]
		@DplyId uniqueidentifier,
		@DateStart datetime,
		@Recurrences int OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
	
		SELECT @Recurrences = COUNT(*)  FROM QNN_DPLY 
			WHERE [RecurrenceOfDplyId]=@DplyId
			AND [DateStart] >= @DateStart;

		RETURN;
	END