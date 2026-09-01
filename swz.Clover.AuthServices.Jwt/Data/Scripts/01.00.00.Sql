

/************************************************************
 ***** TABLE: JsonWebTokens
 ************************************************************/
IF OBJECT_ID(N'dbo.JsonWebTokens', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.[JsonWebTokens]
	(
		[TokenId]           VARCHAR(36) NOT NULL,   -- this is not a unicode string!
		[UserId]            uniqueidentifier NOT NULL,
		[CreatedOn]         SMALLDATETIME NOT NULL DEFAULT (GETDATE()),
		[RenewCount]        INT NOT NULL DEFAULT (0),
		[TokenExpiry]       DATETIME NOT NULL, -- access token expiry timestamp
		[RenewalExpiry]     DATETIME NOT NULL, -- renewal token expiry timestamp
		[TokenHash]         VARCHAR(96) NOT NULL,   -- access token SHA1 (for validation)
		[RenewalHash]       VARCHAR(96) NOT NULL,   -- renewal token SHA1 (for validation)
		CONSTRAINT [PK_JsonWebTokens] PRIMARY KEY ([TokenId])
	)

	CREATE NONCLUSTERED INDEX [IX_JsonWebTokens_UsertId]
		ON dbo.[JsonWebTokens] ([UserId])

	CREATE NONCLUSTERED INDEX [IX_JsonWebTokens_RenewalExpiry]
		ON dbo.[JsonWebTokens] ([RenewalExpiry])
END
GO

/************************************************************
 ***** SPROC: JsonWebTokens_GetById
 ************************************************************/
IF OBJECT_ID(N'dbo.[JsonWebTokens_GetById]', N'P') IS NULL
	EXEC('CREATE PROCEDURE dbo.[JsonWebTokens_GetById] AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE dbo.[JsonWebTokens_GetById]
	@TokenId VARCHAR(36)
AS
BEGIN
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
GO

/************************************************************
 ***** SPROC: JsonWebTokens_GetUserTokens
 ************************************************************/
IF OBJECT_ID(N'dbo.[JsonWebTokens_GetUserTokens]', N'P') IS NULL
	EXEC('CREATE PROCEDURE dbo.[JsonWebTokens_GetUserTokens] AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE dbo.[JsonWebTokens_GetUserTokens]
	@UserId uniqueidentifier
AS
BEGIN
	SELECT *
	FROM dbo.[JsonWebTokens]
	WHERE UserId=@UserId
END
GO

/************************************************************
 ***** SPROC: JsonWebTokens_Add
 ************************************************************/
IF OBJECT_ID(N'dbo.[JsonWebTokens_Add]', N'P') IS NULL
	EXEC('CREATE PROCEDURE dbo.[JsonWebTokens_Add] AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE dbo.[JsonWebTokens_Add]
	@TokenId VARCHAR(36),
	@UserId uniqueidentifier,
	@TokenExpiry DATETIME,
	@RenewalExpiry DATETIME,
	@TokenHash VARCHAR(96),
	@RenewalHash VARCHAR(96)
AS
BEGIN
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
GO

/************************************************************
 ***** SPROC: JsonWebTokens_Update
 ************************************************************/
IF OBJECT_ID(N'dbo.[JsonWebTokens_Update]', N'P') IS NULL
	EXEC('CREATE PROCEDURE dbo.[JsonWebTokens_Update] AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE dbo.[JsonWebTokens_Update]
	@TokenId VARCHAR(36),
	@TokenExpiry SMALLDATETIME,
	@TokenHash VARCHAR(96)
AS
BEGIN
	UPDATE dbo.[JsonWebTokens]
	SET TokenExpiry=@TokenExpiry, TokenHash=@TokenHash, RenewCount=RenewCount+1
	WHERE TokenId=@TokenId
END
GO

/************************************************************
 ***** SPROC: JsonWebTokens_DeleteById
 ************************************************************/
IF OBJECT_ID(N'dbo.[JsonWebTokens_DeleteById]', N'P') IS NULL
	EXEC('CREATE PROCEDURE dbo.[JsonWebTokens_DeleteById] AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE dbo.[JsonWebTokens_DeleteById]
	@TokenId VARCHAR(36)
AS
BEGIN
	DELETE FROM dbo.[JsonWebTokens]
	WHERE TokenId=@TokenId
END
GO

/************************************************************
 ***** SPROC: JsonWebTokens_DeleteByUser
 ************************************************************/
IF OBJECT_ID(N'dbo.[JsonWebTokens_DeleteByUser]', N'P') IS NULL
	EXEC('CREATE PROCEDURE dbo.[JsonWebTokens_DeleteByUser] AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE dbo.[JsonWebTokens_DeleteByUser]
	@UserId uniqueidentifier
AS
BEGIN
	DELETE FROM dbo.[JsonWebTokens]
	WHERE UserId=@UserId
END
GO

/************************************************************
 ***** SPROC: JsonWebTokens_DeleteExpired
 ************************************************************/
IF OBJECT_ID(N'dbo.[JsonWebTokens_DeleteExpired]', N'P') IS NULL
	EXEC('CREATE PROCEDURE dbo.[JsonWebTokens_DeleteExpired] AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE dbo.[JsonWebTokens_DeleteExpired]
AS
BEGIN
	DELETE FROM dbo.[JsonWebTokens]
	WHERE DATEDIFF(day, RenewalExpiry, GETDATE()) > 0
END
GO
