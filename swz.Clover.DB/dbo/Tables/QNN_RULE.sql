CREATE TABLE [dbo].[QNN_RULE] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [NumberId]         INT              IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (100)   NOT NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [Validation]       NVARCHAR (MAX)   NULL,
    [CreatedBy]        UNIQUEIDENTIFIER NULL,
    [CreatedDate]      DATETIME         NULL,
    [IsDeleted]        BIT              NOT NULL,
    [DeletedBy]        UNIQUEIDENTIFIER NULL,
    [DeletedDate]      DATETIME         NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedDate]      DATETIME         NULL,
    [StructDivisionId] UNIQUEIDENTIFIER NULL,
    [Comments]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_QNN_RULE] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_RULE_StructDivisionId] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL
);



