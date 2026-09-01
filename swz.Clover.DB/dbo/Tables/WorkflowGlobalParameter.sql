CREATE TABLE [dbo].[WorkflowGlobalParameter] (
    [Id]    UNIQUEIDENTIFIER NOT NULL,
    [Type]  NVARCHAR (306)   NOT NULL,
    [Name]  NVARCHAR (128)   NOT NULL,
    [Value] NVARCHAR (MAX)   NOT NULL,
    CONSTRAINT [PK_WorkflowGlobalParameter] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_Type_Name_Clustered]
    ON [dbo].[WorkflowGlobalParameter]([Type] ASC, [Name] ASC);

