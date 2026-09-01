CREATE TABLE [dbo].[dwSecurityUserState] (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [SecurityUserId] UNIQUEIDENTIFIER NOT NULL,
    [Key]            NVARCHAR (MAX)   NOT NULL,
    [Value]          NVARCHAR (MAX)   NOT NULL,
    CONSTRAINT [PK_SecurityUserState] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwSecurityUserState_dwSecurityUser] FOREIGN KEY ([SecurityUserId]) REFERENCES [dbo].[dwSecurityUser] ([Id]) ON DELETE CASCADE
);

