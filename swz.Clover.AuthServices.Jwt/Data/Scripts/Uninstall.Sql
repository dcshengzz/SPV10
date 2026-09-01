

/** Drop stored procedures, tables, etc. **/

IF OBJECT_ID(N'dbo.[JsonWebTokens_GetById]', N'P') IS NOT NULL
	DROP PROCEDURE dbo.[JsonWebTokens_GetById]
GO

IF OBJECT_ID(N'dbo.[JsonWebTokens_GetUserTokens]', N'P') IS NOT NULL
	DROP PROCEDURE dbo.[JsonWebTokens_GetUserTokens]
GO

IF OBJECT_ID(N'dbo.[JsonWebTokens_Add]', N'P') IS NOT NULL
	DROP PROCEDURE dbo.[JsonWebTokens_Add]
GO

IF OBJECT_ID(N'dbo.[JsonWebTokens_Update]', N'P') IS NOT NULL
	DROP PROCEDURE dbo.[JsonWebTokens_Update]
GO

IF OBJECT_ID(N'dbo.[JsonWebTokens_DeleteById]', N'P') IS NOT NULL
	DROP PROCEDURE dbo.[JsonWebTokens_DeleteById]
GO

IF OBJECT_ID(N'dbo.[JsonWebTokens_DeleteByUser]', N'P') IS NOT NULL
	DROP PROCEDURE dbo.[JsonWebTokens_DeleteByUser]
GO

IF OBJECT_ID(N'dbo.[JsonWebTokens_DeleteExpired]', N'P') IS NOT NULL
	DROP PROCEDURE dbo.[JsonWebTokens_DeleteExpired]
GO

IF OBJECT_ID(N'dbo.JsonWebTokens', N'U') IS NOT NULL
	DROP TABLE dbo.[JsonWebTokens]
GO
