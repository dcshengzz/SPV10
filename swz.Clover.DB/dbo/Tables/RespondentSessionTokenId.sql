CREATE TABLE [dbo].[RespondentSessionTokenId] (
    [SampleId]  UNIQUEIDENTIFIER NOT NULL,
    [LoginDate] DATETIME         NOT NULL,
    [TokenId] VARCHAR(36) NOT NULL, 
    CONSTRAINT [PK_LoginSessionStatus] PRIMARY KEY CLUSTERED ([SampleId] ASC),
    CONSTRAINT [FK_LoginSessionStatus_SampleId] FOREIGN KEY ([SampleId]) REFERENCES [dbo].[QNN_SAMPLE] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [FK_LoginSessionStatus_TokenId] FOREIGN KEY ([TokenId]) REFERENCES [dbo].[JsonWebTokens]([TokenId]) ON DELETE CASCADE ON UPDATE CASCADE

);

