CREATE TABLE [dbo].[dwSecurityCredential] (
    [Id]                 UNIQUEIDENTIFIER NOT NULL,
    [PasswordHash]       NVARCHAR (128)   NULL,
    [PasswordSalt]       NVARCHAR (128)   NULL,
    [SecurityUserId]     UNIQUEIDENTIFIER NOT NULL,
    [Login]              NVARCHAR (256)   NOT NULL,
    [AuthenticationType] TINYINT          CONSTRAINT [DF_dwSecurityCredential_dwAuthenticationType] DEFAULT ((0)) NOT NULL,
    [RequireTotp]        BIT              CONSTRAINT [DF_dwSecurityCredential_RequireTotp] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dwSecurityCredential] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwSecurityCredential_dwSecurityUser] FOREIGN KEY ([SecurityUserId]) REFERENCES [dbo].[dwSecurityUser] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [Uniqe_login] UNIQUE NONCLUSTERED ([Login] ASC)
);



