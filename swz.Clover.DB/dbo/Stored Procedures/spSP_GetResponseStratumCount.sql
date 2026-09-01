


--Retrieve the counts per Strata for complete responses
CREATE PROCEDURE [dbo].[spSP_GetResponseStratumCount]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	--Ignore incomplete responses. Note that result set won't include rows for Strata that
	--have no responses yet. There may also be a NULL strata row counting responses with no strata
	SELECT 
		r.Strata, 
		COUNT(*) AS StrataCount
	FROM 
		QNN_RESP r
	WHERE 
		r.DplyId=@DplyId
		AND r.DateComplete IS NOT NULL
	GROUP BY 
		Strata;

END