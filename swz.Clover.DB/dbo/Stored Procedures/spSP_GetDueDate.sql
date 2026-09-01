--This procedure returns the DueDate for a specific ListSample in a specific Deployment
--using either the deployment's end date or the appropriate sample-specific due date.
--Note that it DOES NOT factor in the DaysUpdate however (as its job is to find the due
--date rather than when it is closed to the respondent)
CREATE PROCEDURE dbo.spSP_GetDueDate
    @DplyId         UNIQUEIDENTIFIER, 
    @ListSampleId   UNIQUEIDENTIFIER,
    @DueDate        DATETIME OUTPUT -- Output parameter to return the Due Date
AS
BEGIN
    SET XACT_ABORT, NOCOUNT ON;

	--Note: This procedure should follow same logic for DueDate as found in vSP_ListSampleInfo

	--vSP_DplySampleDueDate should only have zero or one row per DplyId/ListSampleId
	SELECT @DueDate = DueDate 
		FROM vSP_DplySampleDueDate 
		WHERE ListSampleId=@ListSampleId AND DplyId=@DplyId;

	--When there is no sample-specific DueDate (this is the usual case actually) 
	--then we default to using the end of the survey period as per DateEnd
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT @DueDate = DateEnd FROM QNN_DPLY WHERE Id=@DplyId;

		--Prefer an explicit fail here rather than returning null
		IF @@ROWCOUNT = 0
		BEGIN
			RAISERROR ('Invalid DplyId', 16, 1);
			RETURN;
		END
    END

	SELECT @DueDate;

END