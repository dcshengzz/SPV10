CREATE TABLE [dbo].[AuditDivisionName] (
    [StructDivisionId] UNIQUEIDENTIFIER NOT NULL,
    [Name]             NVARCHAR (256)   NOT NULL,
    CONSTRAINT [PK_AuditDivisionName] PRIMARY KEY CLUSTERED ([StructDivisionId] ASC)
);

