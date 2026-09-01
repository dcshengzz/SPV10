CREATE TABLE [dbo].[QNN_DPLY_SAMPLE_INFO] (
    [Id]                          UNIQUEIDENTIFIER NOT NULL,
    [NumberId]                    INT              IDENTITY (1, 1) NOT NULL,
    [DplyId]                      UNIQUEIDENTIFIER NOT NULL,
    [ListSampleId]                UNIQUEIDENTIFIER NOT NULL,
    [Remarks]                     NVARCHAR (MAX)   NULL,
    [StatusModifyBy]              UNIQUEIDENTIFIER NULL,
    [StatusModifyOn]              DATETIME         NULL,
    [RemarksModifyBy]             UNIQUEIDENTIFIER NULL,
    [RemarksModifyOn]             DATETIME         NULL,
    [DispatchInd]                 VARCHAR (10)     NULL,
    [ReturnInd]                   VARCHAR (10)     NULL,
    [ProcessValidInd]             VARCHAR (10)     NULL,
    [ProcessEditInd]              VARCHAR (10)     NULL,
    [Status]                      UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]                   UNIQUEIDENTIFIER NULL,
    [CreatedDate]                 DATETIME         NULL,
    [DelegationCode]              VARCHAR (50)     NULL,
    [DelegationAccessFailAttempt] INT              CONSTRAINT [DF_QNN_DPLY_SAMPLE_INFO_DelegationAccessFailAttempt] DEFAULT ((0)) NOT NULL,
    [DirectAccessCode]            VARCHAR (24)     NULL,
    [PrintAccessCode]             VARCHAR (50)     NULL,
    CONSTRAINT [PK_QNN_DPLY_SAMPLE_INFO] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_QNN_DPLY_SAMPLE_INFO_DplyId] FOREIGN KEY ([DplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_QNN_DPLY_SAMPLE_INFO_ListSampleId] FOREIGN KEY ([ListSampleId]) REFERENCES [dbo].[QNN_LIST_SAMPLE] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_QNN_DPLY_SAMPLE_INFO_Status] FOREIGN KEY ([Status]) REFERENCES [dbo].[QNN_STATUS] ([Id])
);






















GO





GO
CREATE NONCLUSTERED INDEX [IDX_ListSampleId]
    ON [dbo].[QNN_DPLY_SAMPLE_INFO]([ListSampleId] ASC) WITH (FILLFACTOR = 80);




GO
CREATE NONCLUSTERED INDEX [IDX_Status]
    ON [dbo].[QNN_DPLY_SAMPLE_INFO]([Status] ASC) WITH (FILLFACTOR = 80);




GO
CREATE NONCLUSTERED INDEX [IDX_DplyId_includes]
    ON [dbo].[QNN_DPLY_SAMPLE_INFO]([DplyId] ASC)
    INCLUDE([ListSampleId], [Status], [Remarks]);

