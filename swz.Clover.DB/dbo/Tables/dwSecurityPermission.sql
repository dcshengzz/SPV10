CREATE TABLE [dbo].[dwSecurityPermission] (
    [Id]      UNIQUEIDENTIFIER NOT NULL,
    [Code]    NVARCHAR (128)   NOT NULL,
    [Name]    NVARCHAR (MAX)   NULL,
    [GroupId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_dwSecurityPermission_1] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwSecurityPermission_dwSecurityPermissionGroup] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[dwSecurityPermissionGroup] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

