CREATE TABLE [dbo].[QNN_LIST_PROP] (
    [Id]            UNIQUEIDENTIFIER NOT NULL,
    [NumberId]      INT              IDENTITY (1, 1) NOT NULL,
    [ListId]        UNIQUEIDENTIFIER NOT NULL,
    [Type]          INT              DEFAULT ((1)) NOT NULL,
    [Alias]         NVARCHAR (50)    NOT NULL,
    [ReqdYN]        BIT              DEFAULT ((0)) NOT NULL,
    [UsrEditYN]     BIT              DEFAULT ((0)) NOT NULL,
    [TxtRow]        INT              NULL,
    [TxtRegExp]     NVARCHAR (1000)  NULL,
    [TxtRegExpErr]  NVARCHAR (1000)  NULL,
    [OptType]       INT              NULL,
    [UsrVisibleYN]  BIT              DEFAULT ((1)) NOT NULL,
    [RespVisibleYN] BIT              DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_LIST_PROP_QNN_LIST] FOREIGN KEY ([ListId]) REFERENCES [dbo].[QNN_LIST] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IDX_ListId]
    ON [dbo].[QNN_LIST_PROP]([ListId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_Alias]
    ON [dbo].[QNN_LIST_PROP]([Alias] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_NumberId]
    ON [dbo].[QNN_LIST_PROP]([NumberId] ASC);

