CREATE TABLE [dbo].[StructDivision] (
    [Id]       UNIQUEIDENTIFIER NOT NULL,
    [Name]     NVARCHAR (256)   NOT NULL,
    [ParentId] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_StructDivision] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_StructDivision_StructDivision] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[StructDivision] ([Id])
);




GO
CREATE TRIGGER tr_UpdateAuditDivisionName
	ON StructDivision AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE sy_AuditDivisionName SET sy_AuditDivisionName.Name=inserted.Name
		FROM sy_AuditDivisionName JOIN inserted ON inserted.Id=sy_AuditDivisionName.StructDivisionId;
END;
GO
CREATE TRIGGER tr_InsertAuditDivisionName
	ON StructDivision AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO sy_AuditDivisionName (StructDivisionId, Name)
		SELECT Id AS StructDivisionId, Name AS NAME FROM inserted;
END;