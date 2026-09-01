CREATE TABLE [dbo].[QNN_RESP_ADMIN] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [Name]        NVARCHAR (50)    NOT NULL,
    [EditorState] NVARCHAR (MAX)   NULL,
    [Description] NVARCHAR (MAX)   NULL,
    [StartDate]   DATETIME         NULL,
    [EndDate]     DATETIME         NULL,
    [CreatedBy]   UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   UNIQUEIDENTIFIER NULL,
    [UpdatedDate] DATETIME         NULL,
    [NumberId]    INT              IDENTITY (1, 1) NOT NULL,
    [Status]      BIT              NULL,
    [Type]        NVARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_QNN_RESP_ADMIN] PRIMARY KEY CLUSTERED ([Id] ASC)
);

