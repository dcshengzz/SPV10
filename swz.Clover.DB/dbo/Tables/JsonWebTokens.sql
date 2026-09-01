CREATE TABLE [dbo].[JsonWebTokens] (
    [TokenId]       VARCHAR (36)     NOT NULL,
    [UserId]        UNIQUEIDENTIFIER NOT NULL,
    [CreatedOn]     SMALLDATETIME    DEFAULT (getdate()) NOT NULL,
    [RenewCount]    INT              DEFAULT ((0)) NOT NULL,
    [TokenExpiry]   DATETIME         NOT NULL,
    [RenewalExpiry] DATETIME         NOT NULL,
    [TokenHash]     VARCHAR (96)     NOT NULL,
    [RenewalHash]   VARCHAR (96)     NOT NULL,
    CONSTRAINT [PK_JsonWebTokens] PRIMARY KEY CLUSTERED ([TokenId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_JsonWebTokens_UsertId]
    ON [dbo].[JsonWebTokens]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_JsonWebTokens_RenewalExpiry]
    ON [dbo].[JsonWebTokens]([RenewalExpiry] ASC);

