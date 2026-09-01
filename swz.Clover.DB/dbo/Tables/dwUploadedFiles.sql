CREATE TABLE [dbo].[dwUploadedFiles] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [Data]             VARBINARY (MAX)  NOT NULL,
    [AttachmentLength] BIGINT           NOT NULL,
    [Used]             BIT              DEFAULT ((0)) NOT NULL,
    [Name]             NVARCHAR (MAX)   NOT NULL,
    [ContentType]      NVARCHAR (255)   NULL,
    [Properties]       NVARCHAR (MAX)   NULL,
    [IsDeleted]        BIT              DEFAULT ((0)) NOT NULL,
    [CreatedBy]        NVARCHAR (320)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (320)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    [IsLocalStorage]   BIT              CONSTRAINT [DF_dwUploadedFiles_IsLocalStorage] DEFAULT ((0)) NULL,
    [StructDivisionId] UNIQUEIDENTIFIER CONSTRAINT [DF_dwUploadedFiles_StructDivisionId] DEFAULT ('00000000-0000-0000-0000-000000000000') NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

