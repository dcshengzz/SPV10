CREATE TABLE [dbo].[QNN_RESP_DELEGATION] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [NumberId]         INT              IDENTITY (1, 1) NOT NULL,
    [DplyListSampleId] UNIQUEIDENTIFIER NOT NULL,
    [FromName]         NVARCHAR (128)   NOT NULL,
    [Name]             NVARCHAR (128)   NOT NULL,
    [Email]            NVARCHAR (256)   NOT NULL,
    [Comments]         NVARCHAR (1000)  NULL,
    [ValidityStart]    DATETIME         NOT NULL,
    [ValidityEnd]      DATETIME         NOT NULL,
    [AccessCode]       VARCHAR (50)     NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [RevokedDate]      DATETIME         NULL,
    CONSTRAINT [PK_QNN_RESP_DELEGATION] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_RESP_DELEGATION_DplyListSampleId] FOREIGN KEY ([DplyListSampleId]) REFERENCES [dbo].[QNN_DPLY_SAMPLE_INFO] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);





