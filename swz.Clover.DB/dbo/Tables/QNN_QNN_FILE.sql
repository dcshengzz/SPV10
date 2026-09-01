CREATE TABLE [dbo].[QNN_QNN_FILE] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [NumberId]    INT              IDENTITY (1, 1) NOT NULL,
    [QnnId]       UNIQUEIDENTIFIER NOT NULL,
    [Name]        NVARCHAR (256)   NULL,
    [Token]       NVARCHAR (50)    NULL,
    [Size]        INT              NULL,
    [ContentType] NVARCHAR (255)   NULL,
    [Language]    NVARCHAR (50)    NULL,
    [Remarks]     NVARCHAR (300)   NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME         NULL,
    [IsDeleted]   BIT              DEFAULT ((0)) NOT NULL,
    [DeletedBy]   UNIQUEIDENTIFIER NULL,
    [DeletedDate] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_QNN_QNN_FILE] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_QNN_FILE_QnnId] FOREIGN KEY ([QnnId]) REFERENCES [dbo].[QNN_QNN] ([Id]) ON DELETE CASCADE
);




GO
CREATE NONCLUSTERED INDEX [IDX_Token]
    ON [dbo].[QNN_QNN_FILE]([Token] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_QnnId]
    ON [dbo].[QNN_QNN_FILE]([QnnId] ASC);

