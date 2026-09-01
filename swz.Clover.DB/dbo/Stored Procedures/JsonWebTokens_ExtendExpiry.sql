

CREATE PROCEDURE [dbo].[JsonWebTokens_ExtendTokenExpiry]
	@TokenId VARCHAR(36),
	@TokenExpiry SMALLDATETIME
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
	UPDATE dbo.[JsonWebTokens]
	SET TokenExpiry=@TokenExpiry
	WHERE TokenId=@TokenId
END