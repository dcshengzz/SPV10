CREATE TABLE [dbo].[QNN_STATUS] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [NumberId]         INT              IDENTITY (1, 1) NOT NULL,
    [Title]            NVARCHAR (30)    NOT NULL,
    [Active]           BIT              DEFAULT ((0)) NOT NULL,
    [Description]      NVARCHAR (300)   NULL,
    [CreatedBy]        UNIQUEIDENTIFIER NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedDate]      DATETIME         NULL,
    [IsDeleted]        BIT              DEFAULT ((0)) NOT NULL,
    [DeletedBy]        UNIQUEIDENTIFIER NULL,
    [DeletedDate]      DATETIME         NULL,
    [HasRespYN]        BIT              NULL,
    [StructDivisionId] UNIQUEIDENTIFIER NULL,
    [Code]             VARCHAR (20)     NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_STATUS] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_StructDivisionId]
    ON [dbo].[QNN_STATUS]([StructDivisionId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_Title]
    ON [dbo].[QNN_STATUS]([Title] ASC);

