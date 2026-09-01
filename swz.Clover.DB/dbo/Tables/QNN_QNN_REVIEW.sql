CREATE TABLE [dbo].[QNN_QNN_REVIEW] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [NumberId]    INT              IDENTITY (1, 1) NOT NULL,
    [QnnId]       UNIQUEIDENTIFIER NOT NULL,
    [Notes]       NVARCHAR (MAX)   NOT NULL,
    [Consent]     BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedDate] DATETIME         NULL,
    [IsDeleted]   BIT              DEFAULT ((0)) NOT NULL,
    [DeletedBy]   UNIQUEIDENTIFIER NULL,
    [DeletedDate] DATETIME         NULL,
    CONSTRAINT [PK_QNN_QNN_REVIEW] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_QNN_REVIEW_QnnId] FOREIGN KEY ([QnnId]) REFERENCES [dbo].[QNN_QNN] ([Id]) ON DELETE CASCADE
);

