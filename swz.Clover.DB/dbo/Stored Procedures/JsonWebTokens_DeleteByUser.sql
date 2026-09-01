

CREATE PROCEDURE [dbo].[JsonWebTokens_DeleteByUser]
	@UserId uniqueidentifier
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
	DELETE FROM dbo.[JsonWebTokens]
	WHERE UserId=@UserId
END