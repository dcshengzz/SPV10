CREATE TABLE [dbo].[dwSecurityGroup] (
    [Id]                    UNIQUEIDENTIFIER NOT NULL,
    [Name]                  NVARCHAR (128)   NOT NULL,
    [Comment]               NVARCHAR (MAX)   NULL,
    [IsSyncWithDomainGroup] BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dwSecurityGroup] PRIMARY KEY CLUSTERED ([Id] ASC)
);

