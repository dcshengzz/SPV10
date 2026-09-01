CREATE TABLE [dbo].[QNN_DPLY] (
    [Id]                             UNIQUEIDENTIFIER NOT NULL,
    [NumberId]                       INT              IDENTITY (1, 1) NOT NULL,
    [QnnId]                          UNIQUEIDENTIFIER NOT NULL,
    [Type]                           CHAR (1)         NOT NULL,
    [Target]                         CHAR (1)         NOT NULL,
    [Status]                         BIT              DEFAULT ((0)) NOT NULL,
    [Name]                           NVARCHAR (300)   NOT NULL,
    [ListId]                         UNIQUEIDENTIFIER NOT NULL,
    [DateStart]                      DATETIME         NULL,
    [DateEnd]                        DATETIME         NULL,
    [QnnDuration]                    INT              NULL,
    [QnnDurationUnit]                CHAR (1)         NULL,
    [CompleteAction]                 CHAR (1)         NOT NULL,
    [CompleteURL]                    NVARCHAR (255)   NULL,
    [NavigateBackYN]                 BIT              DEFAULT ((1)) NOT NULL,
    [NavigateCancelYN]               CHAR (1)         NULL,
    [NavigateCancelURL]              NVARCHAR (255)   NULL,
    [MaxResponse]                    INT              NULL,
    [DaysUpdate]                     INT              NULL,
    [IsDeleted]                      BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]                      UNIQUEIDENTIFIER NULL,
    [CreatedDate]                    DATETIME         NULL,
    [DeletedBy]                      UNIQUEIDENTIFIER NULL,
    [DeletedDate]                    DATETIME         NULL,
    [UpdatedBy]                      UNIQUEIDENTIFIER NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [StructDivisionId]               UNIQUEIDENTIFIER NULL,
    [VisibleToRespondent]            BIT              DEFAULT ((1)) NULL,
    [RestrictIp]                     BIT              NULL,
    [IpCountry]                      NVARCHAR (1000)  NULL,
    [RestrictIpInclusive]            BIT              NULL,
    [IpRange]                        NVARCHAR (1000)  NULL,
    [IsAnonymous]                    BIT              DEFAULT ((0)) NULL,
    [IsMultipleResponse]             BIT              DEFAULT ((0)) NULL,
    [State]                          NVARCHAR (1024)  DEFAULT ('Draft') NOT NULL,
    [StateName]                      NVARCHAR (1024)  NULL,
    [EnableWorkflow]                 BIT              DEFAULT ((0)) NOT NULL,
    [Remarks]                        NVARCHAR (MAX)   NULL,
    [IsDataToData]                   BIT              CONSTRAINT [DF_QNN_DPLY_DataOnData] DEFAULT ((0)) NOT NULL,
    [ValidationDplyId]               UNIQUEIDENTIFIER NULL,
    [RecurrenceFrequency]            NVARCHAR (64)    DEFAULT ('') NOT NULL,
    [RecurrenceEndDate]              DATETIME         NULL,
    [RecurrenceAdvanceDays]          INT              DEFAULT ((0)) NOT NULL,
    [RecurrenceOfDplyId]             UNIQUEIDENTIFIER NULL,
    [RecurrenceNextDate]             DATETIME         NULL,
    [RecurrenceJobId]                NVARCHAR (64)    NULL,
    [RecurrenceEnabled]              BIT              DEFAULT ((0)) NOT NULL,
    [RecurrenceNotify]               NVARCHAR (1000)  NULL,
    [RequireAccessCode]              BIT              CONSTRAINT [DF_QNN_DPLY_RequireAccessCode] DEFAULT ((0)) NOT NULL,
    [IsExcelEnabled]                 BIT              DEFAULT ((0)) NOT NULL,
    [SurveyName]                     VARCHAR (300)    DEFAULT ('Survey') NOT NULL,
    [Description]                    NVARCHAR (MAX)   NULL,
    [IsRecurrencePrePopulateEnabled] BIT              NULL,
    [ApiIdentifier]                  NVARCHAR (255)   NULL,
    [IsExposeListProperties]         BIT              CONSTRAINT [DF_QNN_DPLY_IsExposeListProperties] DEFAULT ((0)) NOT NULL,
    [IsDirectAccessEnabled]          BIT              DEFAULT ((0)) NOT NULL,
    [IsDirectAccessForComplete]      BIT              DEFAULT ((0)) NOT NULL,
    [Tags]                           NVARCHAR (MAX)   NULL,
    [ScheduledExportEnabled]         BIT              CONSTRAINT [DF_QNN_DPLY_ScheduledExportEnabled] DEFAULT ((0)) NOT NULL,
    [ScheduledExportStartDate]       DATETIME         NULL,
    [ScheduledExportEndDate]         DATETIME         NULL,
    [ScheduledExportNextDate]        DATETIME         NULL,
    [ScheduledExportFrequency]       NVARCHAR (64)    CONSTRAINT [DF_QNN_DPLY_ScheduledExportFrequency] DEFAULT ('') NOT NULL,
    [ScheduledExportJobId]           NVARCHAR (64)    NULL,
    [StrataSource]                   NVARCHAR (150)   NULL,
    CONSTRAINT [PK_QNN_DPLY] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_DPLY_ListId] FOREIGN KEY ([ListId]) REFERENCES [dbo].[QNN_LIST] ([Id]),
    CONSTRAINT [FK_QNN_DPLY_QnnId] FOREIGN KEY ([QnnId]) REFERENCES [dbo].[QNN_QNN] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_QNN_DPLY_RecurrenceOfDplyId] FOREIGN KEY ([RecurrenceOfDplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id]),
    CONSTRAINT [FK_QNN_DPLY_StructDivision] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL,
    CONSTRAINT [FK_QNN_DPLY_ValidationDplyId] FOREIGN KEY ([ValidationDplyId]) REFERENCES [dbo].[QNN_DPLY] ([Id])
);






































GO
CREATE NONCLUSTERED INDEX [IDX_ListId]
    ON [dbo].[QNN_DPLY]([ListId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_QnnId]
    ON [dbo].[QNN_DPLY]([QnnId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_StructDivisionId]
    ON [dbo].[QNN_DPLY]([StructDivisionId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_RecurrenceOfDplyId]
    ON [dbo].[QNN_DPLY]([RecurrenceOfDplyId] ASC);

