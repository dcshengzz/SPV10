CREATE TABLE [dbo].[AuditLog] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [UserId]           UNIQUEIDENTIFIER NULL,
    [SampleId]         UNIQUEIDENTIFIER NULL,
    [EventBatch]       UNIQUEIDENTIFIER NOT NULL,
    [EventDate]        DATETIME         NOT NULL,
    [EventType]        NVARCHAR (20)    NOT NULL,
    [TableName]        NVARCHAR (100)   NULL,
    [RecordId]         UNIQUEIDENTIFIER NULL,
    [ColumnName]       NVARCHAR (100)   NULL,
    [OriginalValue]    NVARCHAR (MAX)   NULL,
    [NewValue]         NVARCHAR (MAX)   NULL,
    [StructDivisionId] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_AuditLog] PRIMARY KEY NONCLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80)
);




GO



GO



GO



GO
CREATE NONCLUSTERED INDEX [IDX_EventDate]
    ON [dbo].[AuditLog]([EventDate] DESC) WITH (FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = ON);

