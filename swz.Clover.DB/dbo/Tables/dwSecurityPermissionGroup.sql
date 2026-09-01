CREATE TABLE [dbo].[dwSecurityPermissionGroup] (
    [Id]   UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR (128)   NOT NULL,
    [Code] NVARCHAR (128)   NOT NULL,
    CONSTRAINT [PK_dwSecurityPermissionGroup] PRIMARY KEY CLUSTERED ([Id] ASC)
);

