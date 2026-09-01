

CREATE PROCEDURE [dbo].[JsonWebTokens_Add]
	@TokenId VARCHAR(36),
	@UserId uniqueidentifier,
	@TokenExpiry DATETIME,
	@RenewalExpiry DATETIME,
	@TokenHash VARCHAR(96),
	@RenewalHash VARCHAR(96)
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;
	INSERT INTO dbo.[JsonWebTokens] (
		TokenId,
		UserId,
		TokenExpiry,
		RenewalExpiry,
		TokenHash,
		RenewalHash)
	VALUES (
		@TokenId,
		@UserId,
		@TokenExpiry,
		@RenewalExpiry,
		@TokenHash,
		@RenewalHash)
END