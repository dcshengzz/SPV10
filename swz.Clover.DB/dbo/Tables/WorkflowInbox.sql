CREATE TABLE [dbo].[WorkflowInbox] (
    [Id]         UNIQUEIDENTIFIER NOT NULL,
    [ProcessId]  UNIQUEIDENTIFIER NOT NULL,
    [IdentityId] NVARCHAR (256)   NOT NULL,
    CONSTRAINT [PK_WorkflowInbox] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_IdentityId_Clustered]
    ON [dbo].[WorkflowInbox]([IdentityId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProcessId]
    ON [dbo].[WorkflowInbox]([ProcessId] ASC);

