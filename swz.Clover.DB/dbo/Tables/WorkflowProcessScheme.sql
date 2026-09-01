CREATE TABLE [dbo].[WorkflowProcessScheme] (
    [Id]                     UNIQUEIDENTIFIER NOT NULL,
    [Scheme]                 NTEXT            NOT NULL,
    [DefiningParameters]     NTEXT            NOT NULL,
    [DefiningParametersHash] NVARCHAR (24)    NOT NULL,
    [SchemeCode]             NVARCHAR (256)   NOT NULL,
    [IsObsolete]             BIT              DEFAULT ((0)) NOT NULL,
    [RootSchemeCode]         NVARCHAR (256)   NULL,
    [RootSchemeId]           UNIQUEIDENTIFIER NULL,
    [AllowedActivities]      NVARCHAR (MAX)   NULL,
    [StartingTransition]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_WorkflowProcessScheme] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_SchemeCode_Hash_IsObsolete]
    ON [dbo].[WorkflowProcessScheme]([SchemeCode] ASC, [DefiningParametersHash] ASC, [IsObsolete] ASC);

