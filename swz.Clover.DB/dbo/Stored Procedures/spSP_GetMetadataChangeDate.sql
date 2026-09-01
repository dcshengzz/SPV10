
CREATE PROCEDURE [dbo].spSP_GetMetadataChangeDate
    @MostRecentChange        DATETIME OUTPUT -- Output parameter to return the latest update Date
AS
BEGIN
    SET XACT_ABORT, NOCOUNT ON;

	SELECT 
		@MostRecentChange = MAX(v.DateValue)
	FROM 
		dwMetadata
		CROSS APPLY (VALUES (CreatedDate), (UpdatedDate)) AS v(DateValue)
	;

	SELECT @MostRecentChange;
END