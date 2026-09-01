CREATE TABLE [dbo].[QNN_DPLY_CUSTOM_RECURRENCE] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DplyId]              UNIQUEIDENTIFIER NOT NULL,
    [CustomFrequencyType] NVARCHAR (30)    NOT NULL,
    [RecurDay]            INT              NOT NULL,
    [RecurMonth]          INT              NOT NULL,
    [RecurYear]           INT              NOT NULL,
    [CreatedBy]           UNIQUEIDENTIFIER NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           UNIQUEIDENTIFIER NULL,
    [UpdatedDate]         DATETIME         NULL,
    CONSTRAINT [PK_QNN_DPLY_CUSTOM_RECURRENCE] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_DPLY] FOREIGN KEY ([DplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id]) ON DELETE CASCADE
);

