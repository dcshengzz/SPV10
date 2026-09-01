CREATE TABLE [dbo].[QNN_LIST] (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [NumberId]          INT              IDENTITY (1, 1) NOT NULL,
    [Name]              NVARCHAR (300)   NOT NULL,
    [Description]       NVARCHAR (MAX)   NULL,
    [Status]            BIT              DEFAULT ((0)) NOT NULL,
    [UIDUsrEditYN]      BIT              DEFAULT ((0)) NOT NULL,
    [NameUsrEditYN]     BIT              DEFAULT ((0)) NOT NULL,
    [EmailUsrEditYN]    BIT              DEFAULT ((0)) NOT NULL,
    [ActiveUsrEditYN]   BIT              DEFAULT ((0)) NOT NULL,
    [PasswordUsrEditYN] BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]         UNIQUEIDENTIFIER NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         UNIQUEIDENTIFIER NULL,
    [UpdatedDate]       DATETIME         NULL,
    [IsDeleted]         BIT              DEFAULT ((0)) NOT NULL,
    [DeletedBy]         UNIQUEIDENTIFIER NULL,
    [DeletedDate]       DATETIME         NULL,
    [StructDivisionId]  UNIQUEIDENTIFIER NULL,
    [TrkListIds]        NVARCHAR (MAX)   NULL,
    [Tags]              NVARCHAR (MAX)   NULL,
    [isArchived] BIT NOT NULL DEFAULT ((0)), 
    CONSTRAINT [PK_QNN_LIST] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_LIST_StructDivision] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_StructDivisionId]
    ON [dbo].[QNN_LIST]([StructDivisionId] ASC);

