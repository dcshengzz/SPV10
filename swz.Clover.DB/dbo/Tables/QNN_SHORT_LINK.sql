CREATE TABLE [dbo].[QNN_SHORT_LINK] (
    [Id]                 UNIQUEIDENTIFIER NOT NULL,
    [NumberId]           INT              IDENTITY (1000, 1) NOT NULL,
    [Name]               NVARCHAR (300)   NOT NULL,
    [Description]        NVARCHAR (MAX)   NULL,
    [LinkType]           VARCHAR (32)     NOT NULL,
    [DplyId]             UNIQUEIDENTIFIER NULL,
    [FormName]           NVARCHAR (256)   NULL,
    [Url]                NVARCHAR (1024)  NULL,
    [IsEnhancedSecurity] BIT              DEFAULT ((1)) NOT NULL,
    [AccessCode]         VARCHAR (24)     NOT NULL,
    [Status]             BIT              DEFAULT ((1)) NOT NULL,
    [StructDivisionId]   UNIQUEIDENTIFIER NULL,
    [CreatedBy]          UNIQUEIDENTIFIER NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          UNIQUEIDENTIFIER NULL,
    [UpdatedDate]        DATETIME         NULL,
    CONSTRAINT [PK_QNN_SHORT_LINK] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CHK_QNN_SHORT_LINK_LinkType] CHECK ([LinkType]='Message' OR [LinkType]='Anonymous' OR [LinkType]='Url'),
    CONSTRAINT [FK_QNN_SHORT_LINK_QNN_DPLY] FOREIGN KEY ([DplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id]) ON DELETE SET NULL,
    CONSTRAINT [FK_QNN_SHORT_LINK_StructDivisionId] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE CASCADE
);



