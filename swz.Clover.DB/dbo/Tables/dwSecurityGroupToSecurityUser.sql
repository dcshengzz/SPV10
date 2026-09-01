CREATE TABLE [dbo].[dwSecurityGroupToSecurityUser] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [SecurityGroupId] UNIQUEIDENTIFIER NOT NULL,
    [SecurityUserId]  UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_dwSecurityGroupToSecurityUser] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwSecurityGroupToSecurityUser_dwSecurityGroup] FOREIGN KEY ([SecurityGroupId]) REFERENCES [dbo].[dwSecurityGroup] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_dwSecurityGroupToSecurityUser_dwSecurityUser] FOREIGN KEY ([SecurityUserId]) REFERENCES [dbo].[dwSecurityUser] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

