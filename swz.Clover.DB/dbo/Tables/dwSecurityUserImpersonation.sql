CREATE TABLE [dbo].[dwSecurityUserImpersonation] (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [SecurityUserId]    UNIQUEIDENTIFIER NOT NULL,
    [ImpSecurityUserId] UNIQUEIDENTIFIER NOT NULL,
    [DateFrom]          DATETIME         NOT NULL,
    [DateTo]            DATETIME         NOT NULL,
    CONSTRAINT [PK_dwSecurityUserImpersonation] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dwSecurityUserImpersonation_dwSecurityUser] FOREIGN KEY ([SecurityUserId]) REFERENCES [dbo].[dwSecurityUser] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_dwSecurityUserImpersonation_dwSecurityUser1] FOREIGN KEY ([ImpSecurityUserId]) REFERENCES [dbo].[dwSecurityUser] ([Id])
);

