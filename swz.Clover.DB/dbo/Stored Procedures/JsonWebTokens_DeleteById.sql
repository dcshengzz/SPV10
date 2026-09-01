

CREATE PROCEDURE [dbo].[JsonWebTokens_DeleteById]
	@TokenId VARCHAR(36)
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
	DELETE FROM dbo.[JsonWebTokens]
	WHERE TokenId=@TokenId
END