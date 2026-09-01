CREATE TABLE [dbo].[QNN_DPLY_MSG] (
    [Id]                         UNIQUEIDENTIFIER NOT NULL,
    [NumberId]                   INT              IDENTITY (1, 1) NOT NULL,
    [DplyStep]                   CHAR (1)         NOT NULL,
    [DplyId]                     UNIQUEIDENTIFIER NOT NULL,
    [NotifyMerge]                BIT              DEFAULT ((0)) NOT NULL,
    [NotifyEmail]                BIT              DEFAULT ((0)) NOT NULL,
    [NotifyGenerate]             BIT              DEFAULT ((0)) NOT NULL,
    [MsgContent]                 NVARCHAR (MAX)   NULL,
    [MsgContentJson]             NVARCHAR (MAX)   NULL,
    [EmailSubj]                  NVARCHAR (300)   NULL,
    [EmailFrom]                  NVARCHAR (320)   NULL,
    [GenerateQnnYN]              BIT              DEFAULT ((0)) NOT NULL,
    [GenerateDateTime]           DATETIME         NULL,
    [IsDeleted]                  BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]                  UNIQUEIDENTIFIER NULL,
    [CreatedDate]                DATETIME         NULL,
    [DeletedBy]                  UNIQUEIDENTIFIER NULL,
    [DeletedDate]                DATETIME         NULL,
    [UpdatedBy]                  UNIQUEIDENTIFIER NULL,
    [UpdatedDate]                DATETIME         NULL,
    [MergeDone]                  BIT              DEFAULT ((0)) NOT NULL,
    [MergeOutputToken]           VARCHAR (50)     NULL,
    [GenerateProfileDone]        BIT              DEFAULT ((0)) NOT NULL,
    [GenerateProfileOutputToken] VARCHAR (50)     NULL,
    [ScheduledDate]              DATETIME         NULL,
    [JobId]                      VARCHAR (50)     NULL,
    [JobIsCanceled]              BIT              NULL,
    CONSTRAINT [PK_QNN_DPLY_MSG] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_DPLY_MSG_DplyId] FOREIGN KEY ([DplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id]) ON DELETE CASCADE
);






GO
CREATE NONCLUSTERED INDEX [IDX_DplyId]
    ON [dbo].[QNN_DPLY_MSG]([DplyId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_JobId]
    ON [dbo].[QNN_DPLY_MSG]([JobId] ASC);

