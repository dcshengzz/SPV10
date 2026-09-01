CREATE TABLE [dbo].[QNN_LIST_SAMPLE_UPD_NOTIF] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [NumberId]    INT              IDENTITY (1, 1) NOT NULL,
    [ListUsrId]   UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDate] DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

