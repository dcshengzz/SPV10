CREATE TABLE [dbo].[dwSecurityGroupToSecurityRole] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [SecurityGroupId] UNIQUEIDENTIFIER NOT NULL,
    [SecurityRoleId]  UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_dwSecurityGroupToSecurityRole] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwSecurityGroupToSecurityRole_dwSecurityGroup] FOREIGN KEY ([SecurityGroupId]) REFERENCES [dbo].[dwSecurityGroup] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_dwSecurityGroupToSecurityRole_dwSecurityRole] FOREIGN KEY ([SecurityRoleId]) REFERENCES [dbo].[dwSecurityRole] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

