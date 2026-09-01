

CREATE PROCEDURE [dbo].[JsonWebTokens_GetUserTokens]
	@UserId uniqueidentifier
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
	SELECT *
	FROM dbo.[JsonWebTokens]
	WHERE UserId=@UserId
END