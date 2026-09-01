CREATE TABLE [dbo].[dwSecurityRoleToSecurityPermission] (
    [Id]                   UNIQUEIDENTIFIER NOT NULL,
    [SecurityRoleId]       UNIQUEIDENTIFIER NOT NULL,
    [SecurityPermissionId] UNIQUEIDENTIFIER NOT NULL,
    [AccessType]           TINYINT          DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SecurityRoleToSecurityPermission] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwSecurityRoleToSecurityPermission_dwSecurityPermission] FOREIGN KEY ([SecurityPermissionId]) REFERENCES [dbo].[dwSecurityPermission] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_dwSecurityRoleToSecurityPermission_dwSecurityRole] FOREIGN KEY ([SecurityRoleId]) REFERENCES [dbo].[dwSecurityRole] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

