CREATE TABLE [dbo].[DotNetCoreSession] (
    [Id]                         NVARCHAR (449)     COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
    [Value]                      VARBINARY (MAX)    NOT NULL,
    [ExpiresAtTime]              DATETIMEOFFSET (7) NOT NULL,
    [SlidingExpirationInSeconds] BIGINT             NULL,
    [AbsoluteExpiration]         DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK__DotNetCo__3214EC07891EC6A5] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_ExpiresAtTime]
    ON [dbo].[DotNetCoreSession]([ExpiresAtTime] ASC);

