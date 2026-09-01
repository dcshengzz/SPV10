CREATE TABLE [dbo].[AuditSampleName] (
    [SampleId] UNIQUEIDENTIFIER NOT NULL,
    [Name]     NVARCHAR (128)   NOT NULL,
    [UID]      NVARCHAR (320)   NOT NULL,
    CONSTRAINT [PK_AuditSampleName] PRIMARY KEY CLUSTERED ([SampleId] ASC)
);

