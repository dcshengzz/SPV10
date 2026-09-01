


CREATE PROCEDURE [dbo].[JsonWebTokens_DeleteExpired]
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;

	-- This procedure uses DATEDIFF so it will delete where the renewal date was before the start of today
	-- (Today's expiries are ignored)
	DELETE FROM 
		dbo.[JsonWebTokens]
	WHERE 
		    DATEDIFF(day, RenewalExpiry, GETDATE()) > 0
		AND DATEDIFF(day, TokenExpiry, GETDATE()) > 0
END