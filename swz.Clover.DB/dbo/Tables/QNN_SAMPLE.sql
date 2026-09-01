CREATE TABLE [dbo].[QNN_SAMPLE] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [NumberId]        INT              IDENTITY (1, 1) NOT NULL,
    [ActiveYN]        BIT              DEFAULT ((0)) NOT NULL,
    [UID]             NVARCHAR (320)   NOT NULL,
    [Name]            NVARCHAR (128)   NOT NULL,
    [PwdResetYN]      BIT              DEFAULT ((0)) NOT NULL,
    [Pwd]             NVARCHAR (256)   NULL,
    [NumRetry]        INT              NOT NULL,
    [CreatedBy]       UNIQUEIDENTIFIER NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       UNIQUEIDENTIFIER NULL,
    [UpdatedDate]     DATETIME         NULL,
    [SelfUpdatedDate] DATETIME         NULL,
    [IsDeleted]       BIT              DEFAULT ((0)) NOT NULL,
    [DeletedBy]       UNIQUEIDENTIFIER NULL,
    [DeletedDate]     DATETIME         NULL,
    [PwdResetToken]   NVARCHAR (MAX)   NULL,
    [LastLoginDate]   DATETIME         NULL,
    CONSTRAINT [PK_QNN_SAMPLE] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [Unique_UID] UNIQUE NONCLUSTERED ([UID] ASC) WITH (FILLFACTOR = 90)
);












GO



GO
CREATE NONCLUSTERED INDEX [IDX_Name]
    ON [dbo].[QNN_SAMPLE]([Name] ASC) WITH (FILLFACTOR = 90);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_NumberId]
    ON [dbo].[QNN_SAMPLE]([NumberId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_Id_includes]
    ON [dbo].[QNN_SAMPLE]([Id] ASC)
    INCLUDE([UID], [Name], [LastLoginDate]) WITH (FILLFACTOR = 80);

