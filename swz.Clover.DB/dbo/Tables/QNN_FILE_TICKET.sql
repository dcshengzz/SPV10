CREATE TABLE [dbo].[QNN_FILE_TICKET] (
    [Id]                   UNIQUEIDENTIFIER NOT NULL,
    [NumberId]             INT              IDENTITY (1, 1) NOT NULL,
    [FileId]               UNIQUEIDENTIFIER NOT NULL,
    [IsEnabled]            BIT              DEFAULT ((1)) NOT NULL,
    [Purpose]              VARCHAR (32)     NOT NULL,
    [RestrictedToUserId]   UNIQUEIDENTIFIER NULL,
    [RestrictedToRoles]    VARCHAR (MAX)    NULL,
    [ExpiryDate]           DATETIME         NULL,
    [IsDeleteFileOnExpiry] BIT              DEFAULT ((1)) NOT NULL,
    [StructDivisionId]     UNIQUEIDENTIFIER NULL,
    [CreatedBy]            UNIQUEIDENTIFIER NULL,
    [CreatedDate]          DATETIME         DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]            UNIQUEIDENTIFIER NULL,
    [UpdatedDate]          DATETIME         NULL,
    CONSTRAINT [PK_QNN_FILE_TICKET] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_QNN_FILE_TICKET_FileId] FOREIGN KEY ([FileId]) REFERENCES [dbo].[dwUploadedFiles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_QNN_FILE_TICKET_RestrictedToUserId] FOREIGN KEY ([RestrictedToUserId]) REFERENCES [dbo].[dwSecurityUser] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_QNN_FILE_TICKET_StructDivisionId] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE CASCADE
);



