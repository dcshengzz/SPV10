

CREATE PROCEDURE [dbo].[JsonWebTokens_GetById]
	@TokenId VARCHAR(36)
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
	SELECT [TokenId],
		   [UserId],
		   [RenewCount],
		   [TokenExpiry],
		   [RenewalExpiry],
		   [TokenHash],
		   [RenewalHash]
	FROM dbo.[JsonWebTokens]
	WHERE TokenId=@TokenId
END