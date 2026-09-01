

CREATE PROCEDURE [dbo].[JsonWebTokens_Update]
	@TokenId VARCHAR(36),
	@TokenExpiry SMALLDATETIME,
	@TokenHash VARCHAR(96)
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
	UPDATE dbo.[JsonWebTokens]
	SET TokenExpiry=@TokenExpiry, TokenHash=@TokenHash, RenewCount=RenewCount+1
	WHERE TokenId=@TokenId
END