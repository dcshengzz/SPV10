CREATE TABLE [dbo].[QNN_DPLY_SCHEDULER] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [DplyId]          UNIQUEIDENTIFIER NOT NULL,
    [JobDescription]  NVARCHAR (300)   NOT NULL,
    [EmailSuccess]    BIT              NOT NULL,
    [EmailFailure]    BIT              NOT NULL,
    [EmailRecipients] NVARCHAR (MAX)   NOT NULL,
    [LastJobRun]      DATETIME         NULL,
    [CreatedDate]     DATETIME         NOT NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDate]     DATETIME         NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_QNN_DPLY_SCHEDULER] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_DPLY_SCHEDULER_DplyId] FOREIGN KEY ([DplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_DplyId] UNIQUE NONCLUSTERED ([DplyId] ASC) WITH (FILLFACTOR = 100)
);





