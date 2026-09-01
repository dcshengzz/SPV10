CREATE TABLE [dbo].[dwSecurityUserToSecurityRole] (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [SecurityRoleId] UNIQUEIDENTIFIER NOT NULL,
    [SecurityUserId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_SecurityUserToSecurityRole] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwSecurityUserToSecurityRole_dwSecurityRole] FOREIGN KEY ([SecurityRoleId]) REFERENCES [dbo].[dwSecurityRole] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_dwSecurityUserToSecurityRole_dwSecurityUser] FOREIGN KEY ([SecurityUserId]) REFERENCES [dbo].[dwSecurityUser] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

