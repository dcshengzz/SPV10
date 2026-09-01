CREATE TABLE [dbo].[WorkflowProcessInstancePersistence] (
    [Id]            UNIQUEIDENTIFIER NOT NULL,
    [ProcessId]     UNIQUEIDENTIFIER NOT NULL,
    [ParameterName] NVARCHAR (MAX)   NOT NULL,
    [Value]         NVARCHAR (MAX)   NOT NULL,
    CONSTRAINT [PK_WorkflowProcessInstancePersistence] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_ProcessId_Clustered]
    ON [dbo].[WorkflowProcessInstancePersistence]([ProcessId] ASC);

