CREATE TABLE [dbo].[WorkflowProcessTransitionHistory] (
    [Id]                   UNIQUEIDENTIFIER NOT NULL,
    [ProcessId]            UNIQUEIDENTIFIER NOT NULL,
    [ExecutorIdentityId]   NVARCHAR (256)   NULL,
    [ActorIdentityId]      NVARCHAR (256)   NULL,
    [FromActivityName]     NVARCHAR (MAX)   NOT NULL,
    [ToActivityName]       NVARCHAR (MAX)   NOT NULL,
    [ToStateName]          NVARCHAR (MAX)   NULL,
    [TransitionTime]       DATETIME         NOT NULL,
    [TransitionClassifier] NVARCHAR (MAX)   NOT NULL,
    [IsFinalised]          BIT              NOT NULL,
    [FromStateName]        NVARCHAR (MAX)   NULL,
    [TriggerName]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_WorkflowProcessTransitionHistory] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_ProcessId_Clustered]
    ON [dbo].[WorkflowProcessTransitionHistory]([ProcessId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ExecutorIdentityId]
    ON [dbo].[WorkflowProcessTransitionHistory]([ExecutorIdentityId] ASC);

