CREATE TABLE [dbo].[QNN_AUDIT_TRAIL] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [NumberId]    INT              IDENTITY (1, 1) NOT NULL,
    [ModuleCode]  NVARCHAR (50)    NOT NULL,
    [Ref_Id]      UNIQUEIDENTIFIER NOT NULL,
    [Ref_Name]    NVARCHAR (500)   NOT NULL,
    [ChangeDate]  DATETIME         NOT NULL,
    [UserId]      UNIQUEIDENTIFIER NOT NULL,
    [UserName]    NVARCHAR (50)    NOT NULL,
    [AuditAction] NVARCHAR (50)    NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

