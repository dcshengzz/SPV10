CREATE TABLE [dbo].[dwSecurityUser] (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [Name]              NVARCHAR (256)   NOT NULL,
    [Email]             NVARCHAR (256)   NULL,
    [IsLocked]          BIT              CONSTRAINT [DF__dwSecurit__IsLoc__37A5467C] DEFAULT ((0)) NOT NULL,
    [ExternalId]        NVARCHAR (1024)  NULL,
    [Timezone]          NVARCHAR (256)   NULL,
    [Localization]      NVARCHAR (256)   NULL,
    [DecimalSeparator]  NCHAR (1)        NULL,
    [PageSize]          INT              NULL,
    [StartPage]         NVARCHAR (256)   NULL,
    [IsRTL]             BIT              NULL,
    [StructDivisionId]  UNIQUEIDENTIFIER NULL,
    [IsHead]            BIT              CONSTRAINT [DF_dwSecurityUser_IsHead] DEFAULT ((0)) NOT NULL,
    [GaSalt]            VARCHAR (256)    NULL,
    [NumRetry]          INT              NOT NULL,
    [IpAddress]         NVARCHAR (2056)  NULL,
    [BrowserType]       NVARCHAR (2056)  NULL,
    [LastLoginDate]     DATETIME         NULL,
    [CreatedBy]         UNIQUEIDENTIFIER NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         UNIQUEIDENTIFIER NULL,
    [UpdatedDate]       DATETIME         NULL,
    [LinkedDomainLogin] NVARCHAR (256)   NULL,
    [DormancyDate]      DATETIME         NULL,
    CONSTRAINT [PK_dwSecurityUser] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 70),
    CONSTRAINT [FK_dwSecurityUser_StructDivision] FOREIGN KEY ([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id])
);










GO
CREATE NONCLUSTERED INDEX [IDX_Name]
    ON [dbo].[dwSecurityUser]([Name] ASC) WITH (FILLFACTOR = 70);


GO

CREATE TRIGGER [dbo].[tr_UpdateAuditUserName]
	ON [dbo].[dwSecurityUser] AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	IF UPDATE(Name)
	BEGIN
		UPDATE sy_AuditUserName SET sy_AuditUserName.Name=inserted.Name 
		FROM sy_AuditUserName JOIN Inserted ON Inserted.Id=sy_AuditUserName.UserId;
	END
END;
GO

CREATE TRIGGER [dbo].[tr_InsertAuditUserName]
	ON [dbo].[dwSecurityUser] AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO sy_AuditUserName (UserId, Name) 
		SELECT Id AS UserId, Name AS Name FROM inserted;
END;
GO
CREATE NONCLUSTERED INDEX [IDX_Id_includes]
    ON [dbo].[dwSecurityUser]([Id] ASC)
    INCLUDE([Name], [LastLoginDate], [Email]) WITH (FILLFACTOR = 80);

