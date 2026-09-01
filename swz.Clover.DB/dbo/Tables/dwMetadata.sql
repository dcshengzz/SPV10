CREATE TABLE [dbo].[dwMetadata] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [Folder]           NVARCHAR (255)   NULL,
    [Filename]         NVARCHAR (255)   NOT NULL,
    [IsDeleted]        BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]        UNIQUEIDENTIFIER NULL,
    [CreatedDate]      DATETIME         NULL,
    [DeletedBy]        UNIQUEIDENTIFIER NULL,
    [DeletedDate]      DATETIME         NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedDate]      DATETIME         NULL,
    [Data]             NVARCHAR (MAX)   NULL,
    [StructDivisionId] UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwMetadata_StructDivision] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_dwMetaData_Filename]
    ON [dbo].[dwMetadata]([Filename] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_dwMetaData_Folder]
    ON [dbo].[dwMetadata]([Folder] ASC);

