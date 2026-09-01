CREATE TABLE [dbo].[QNN_RESP] (
    [Id]                      UNIQUEIDENTIFIER NOT NULL,
    [NumberId]                INT              IDENTITY (1, 1) NOT NULL,
    [DplyId]                  UNIQUEIDENTIFIER NULL,
    [QnnId]                   UNIQUEIDENTIFIER NULL,
    [ListSampleId]            UNIQUEIDENTIFIER NULL,
    [UserId]                  UNIQUEIDENTIFIER NULL,
    [Score]                   INT              DEFAULT ((-1)) NOT NULL,
    [TimeTook]                INT              DEFAULT ((-1)) NOT NULL,
    [DateStart]               DATETIME         NULL,
    [DateComplete]            DATETIME         NULL,
    [UpdatedDate]             DATETIME         NULL,
    [IsPrePopulated]          BIT              NULL,
    [LastSavedPage]           NVARCHAR (255)   NULL,
    [AnonymousId]             UNIQUEIDENTIFIER NULL,
    [IpAddress]               VARCHAR (45)     NULL,
    [IsExcelResponse]         BIT              DEFAULT ((0)) NOT NULL,
    [ExcelToken]              NVARCHAR (50)    NULL,
    [ExcelUploadDate]         DATETIME         NULL,
    [IsExcelResponseDE]       BIT              DEFAULT ((0)) NOT NULL,
    [InitialResponseAs]       NVARCHAR (50)    CONSTRAINT [DF_QNN_RESP_InitialResponseAs] DEFAULT ('Unknown') NOT NULL,
    [InitialResponseBy]       NVARCHAR (50)    CONSTRAINT [DF_QNN_RESP_InitialResponseBy] DEFAULT ('Unknown') NOT NULL,
    [InitialResponseVia]      NVARCHAR (50)    CONSTRAINT [DF_QNN_RESP_InitialResponseVia] DEFAULT ('Unknown') NOT NULL,
    [CompletedResponseAs]     NVARCHAR (50)    NULL,
    [CompletedResponseBy]     NVARCHAR (50)    NULL,
    [CompletedResponseVia]    NVARCHAR (50)    NULL,
    [LastResponseAs]          NVARCHAR (50)    CONSTRAINT [DF_QNN_RESP_LastResponseAs] DEFAULT ('Unknown') NOT NULL,
    [LastResponseBy]          NVARCHAR (50)    CONSTRAINT [DF_QNN_RESP_LastResponseBy] DEFAULT ('Unknown') NOT NULL,
    [LastResponseVia]         NVARCHAR (50)    CONSTRAINT [DF_QNN_RESP_LastResponseVia] DEFAULT ('Unknown') NOT NULL,
    [InitialResponseUserId]   UNIQUEIDENTIFIER NULL,
    [CompletedResponseUserId] UNIQUEIDENTIFIER NULL,
    [Strata]                  NVARCHAR (255)   NULL,
    CONSTRAINT [PK_QNN_RESP] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_QNN_RESP_DplyId] FOREIGN KEY ([DplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id]),
    CONSTRAINT [FK_QNN_RESP_ListSampleId] FOREIGN KEY ([ListSampleId]) REFERENCES [dbo].[QNN_LIST_SAMPLE] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_QNN_RESP_QnnId] FOREIGN KEY ([QnnId]) REFERENCES [dbo].[QNN_QNN] ([Id])
);




















GO
ALTER TABLE [dbo].[QNN_RESP] SET (LOCK_ESCALATION = DISABLE);








GO
CREATE NONCLUSTERED INDEX [IDX_DateComplete]
    ON [dbo].[QNN_RESP]([DateComplete] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_DateStart]
    ON [dbo].[QNN_RESP]([DateStart] ASC);


GO





GO



GO
CREATE NONCLUSTERED INDEX [IDX_ListSampleId]
    ON [dbo].[QNN_RESP]([ListSampleId] ASC) WITH (FILLFACTOR = 80);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NumberId]
    ON [dbo].[QNN_RESP]([NumberId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_QnnId]
    ON [dbo].[QNN_RESP]([QnnId] ASC) WITH (FILLFACTOR = 80);




GO
CREATE NONCLUSTERED INDEX [IDX_UserId]
    ON [dbo].[QNN_RESP]([UserId] ASC) WITH (FILLFACTOR = 80);




GO
CREATE NONCLUSTERED INDEX [IDX_IsPrePopulated]
    ON [dbo].[QNN_RESP]([IsPrePopulated] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_DplyId_includes]
    ON [dbo].[QNN_RESP]([DplyId] ASC)
    INCLUDE([ListSampleId], [UserId], [DateStart], [DateComplete], [UpdatedDate], [IsPrePopulated], [IpAddress], [InitialResponseAs], [InitialResponseBy], [InitialResponseVia], [CompletedResponseAs], [CompletedResponseBy], [CompletedResponseVia], [LastResponseAs], [LastResponseBy], [LastResponseVia], [InitialResponseUserId], [CompletedResponseUserId]);

