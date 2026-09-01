CREATE TABLE [dbo].[QNN_GLOBAL_MSG] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [NumberId]         INT              IDENTITY (1, 1) NOT NULL,
    [MsgContent]       NVARCHAR (MAX)   NULL,
    [MsgContentJson]   NVARCHAR (MAX)   NULL,
    [EmailSubj]        NVARCHAR (300)   NULL,
    [EmailFrom]        NVARCHAR (320)   NULL,
    [CreatedBy]        UNIQUEIDENTIFIER NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        UNIQUEIDENTIFIER NULL,
    [UpdatedDate]      DATETIME         NULL,
    [StructDivisionId] UNIQUEIDENTIFIER NULL,
    [ScheduledDate]    DATETIME         NULL,
    [JobId]            VARCHAR (50)     NULL,
    [JobIsCanceled]    BIT              NULL,
    [IsTargetUsers]    BIT              NULL,
    CONSTRAINT [PK_QNN_GLOBAL_MSG] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_GLOBAL_MSG_StructDivisionId] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL
);





