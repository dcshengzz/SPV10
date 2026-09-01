CREATE TABLE [dbo].[QNN_TRK_LIST] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newsequentialid()) NOT NULL,
    [NumberId]         INT              IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (300)   NOT NULL,
    [CreatedBy]        UNIQUEIDENTIFIER NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedDate]      DATETIME         NULL,
    [IsDeleted]        BIT              DEFAULT ((0)) NOT NULL,
    [DeletedBy]        UNIQUEIDENTIFIER NULL,
    [DeletedDate]      DATETIME         NULL,
    [StructDivisionId] UNIQUEIDENTIFIER NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_TRK_LIST_StructDivision] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL
);

