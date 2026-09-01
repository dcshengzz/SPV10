CREATE TABLE [dbo].[dwSecurityRole] (
    [Code]        NVARCHAR (128)   NOT NULL,
    [Name]        NVARCHAR (128)   NOT NULL,
    [Comment]     NVARCHAR (MAX)   NULL,
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [DomainGroup] NVARCHAR (512)   NULL,
    CONSTRAINT [PK_dwSecurityRole] PRIMARY KEY CLUSTERED ([Id] ASC)
);

