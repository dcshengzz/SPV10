CREATE TABLE [dbo].[QNN_RESP_PDF_EXPORT] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [SampleId]         UNIQUEIDENTIFIER NULL,
    [DplyListSampleId] UNIQUEIDENTIFIER NULL,
    [RespId]           UNIQUEIDENTIFIER NULL,
    [FormName]         NVARCHAR (200)   NOT NULL,
    [SurveyName]       NVARCHAR (500)   NULL,
    [Emails]           NVARCHAR (MAX)   NULL,
    [RequestedAt]      DATETIME         DEFAULT (getdate()) NOT NULL,
    [Status]           NVARCHAR (20)    NOT NULL,
    [ErrorMessage] NVARCHAR(200) NULL, 
    CONSTRAINT [PK_QNN_RESP_PDF_EXPORT] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_QNN_RESP_PDF_EXPORT_SampleId]
    ON [dbo].[QNN_RESP_PDF_EXPORT]([SampleId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_QNN_RESP_PDF_EXPORT_RateLimit]
    ON [dbo].[QNN_RESP_PDF_EXPORT]([SampleId] ASC, [FormName] ASC, [RequestedAt] ASC) WHERE ([Status]<>'RateLimited');


GO
CREATE NONCLUSTERED INDEX [IX_QNN_RESP_PDF_EXPORT_DplyListSampleId]
    ON [dbo].[QNN_RESP_PDF_EXPORT]([DplyListSampleId] ASC, [RequestedAt] ASC) WHERE ([Status] <> 'RateLimited' AND [DplyListSampleId] IS NOT NULL);

