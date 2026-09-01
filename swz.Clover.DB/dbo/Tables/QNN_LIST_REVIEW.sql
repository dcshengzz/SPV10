CREATE TABLE [dbo].[QNN_LIST_REVIEW] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [NumberId]    INT              IDENTITY (1, 1) NOT NULL,
    [ListId]      UNIQUEIDENTIFIER NOT NULL,
    [Notes]       NVARCHAR (MAX)   NOT NULL,
    [Consent]     BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedDate] DATETIME         NULL,
    [IsDeleted]   BIT              DEFAULT ((0)) NOT NULL,
    [DeletedBy]   UNIQUEIDENTIFIER NULL,
    [DeletedDate] DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_LIST_REVIEW_QNN_LIST] FOREIGN KEY ([ListId]) REFERENCES [dbo].[QNN_LIST] ([Id]) ON DELETE CASCADE
);

