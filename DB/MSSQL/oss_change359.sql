-- New Survey Plus Core Status: Acknowledged
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'19a0c4ff-be69-4011-a135-3c05a5429616')
BEGIN
PRINT('Adding new status "Acknowledged"...');
--n.b. due to different instance having custom non-core status we can't pin down the NumberId, so only Id will be 'well-known'
INSERT INTO [dbo].[QNN_STATUS] (
	[Id], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],
	[IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) 
	VALUES (
	N'19a0c4ff-be69-4011-a135-3c05a5429616', N'AC', N'Acknowledged', 1, N'', NULL, CAST(GETDATE() AS DateTime), NULL, CAST(GETDATE() AS DateTime), 
	0, NULL, NULL, 0, NULL)
END