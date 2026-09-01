CREATE TABLE [dbo].[QNN_QNN] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [NumberId]         INT              IDENTITY (1, 1) NOT NULL,
    [Title]            NVARCHAR (300)   NOT NULL,
    [Description]      NVARCHAR (MAX)   NULL,
    [FieldCount]       INT              DEFAULT ((0)) NOT NULL,
    [Type]             CHAR (1)         DEFAULT ('P') NOT NULL,
    [Status]           BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]        UNIQUEIDENTIFIER NULL,
    [CreatedDate]      DATETIME         NULL,
    [IsDeleted]        BIT              DEFAULT ((0)) NOT NULL,
    [DeletedBy]        UNIQUEIDENTIFIER NULL,
    [DeletedDate]      DATETIME         NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedDate]      DATETIME         NULL,
    [StructDivisionId] UNIQUEIDENTIFIER NULL,
    [Tags]             NVARCHAR (MAX)   NULL,
    [isArchived] BIT NOT NULL DEFAULT ((0)), 
    CONSTRAINT [PK_QNN_QNN] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_QNN_StructDivision] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_StructDivisionId]
    ON [dbo].[QNN_QNN]([StructDivisionId] ASC);

