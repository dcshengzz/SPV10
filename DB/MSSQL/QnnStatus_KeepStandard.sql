-- Purpose of the script : Keep standard Status and remove the rest.

BEGIN TRY
BEGIN TRANSACTION

SET IDENTITY_INSERT [dbo].[QNN_STATUS] ON 

-- Pending
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'a3d01086-40fc-4a7a-bf0c-de17bdd205fa')
BEGIN
PRINT('Adding new status "Pending"...');
INSERT [dbo].[QNN_STATUS] ([Id], [NumberId], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) VALUES (N'a3d01086-40fc-4a7a-bf0c-de17bdd205fa', 1, N'PE', N'Pending', 1, N'', NULL, CAST(GETDATE() AS DateTime), NULL, CAST(GETDATE() AS DateTime), 0, NULL, NULL, 0, NULL)
END

-- Submitted
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'7c23b23e-23a3-4f04-96ef-89521babe78d')
BEGIN
PRINT('Adding new status "Submitted"...');
INSERT [dbo].[QNN_STATUS] ([Id], [NumberId], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) VALUES (N'7c23b23e-23a3-4f04-96ef-89521babe78d', 3, N'SB', N'Submitted', 1, N'', NULL, CAST(GETDATE() AS DateTime), NULL, CAST(GETDATE() AS DateTime), 0, NULL, NULL, 1, NULL)
END

-- Cleared
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'129c7781-536d-42f6-aca4-33a62f2e2c1f')
BEGIN
PRINT('Adding new status "Cleared"...');
INSERT [dbo].[QNN_STATUS] ([Id], [NumberId], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) VALUES (N'129c7781-536d-42f6-aca4-33a62f2e2c1f', 5, N'CL', N'Cleared', 1, N'', NULL, CAST(GETDATE() AS DateTime), NULL, CAST(GETDATE() AS DateTime), 0, NULL, NULL, 1, NULL)
END

-- In-Progress
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'0d67932c-62ea-4cd3-a254-0cc63e742c93')
BEGIN
PRINT('Adding new status "In-Progress"...');
INSERT [dbo].[QNN_STATUS] ([Id], [NumberId], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) VALUES (N'0d67932c-62ea-4cd3-a254-0cc63e742c93', 2, N'DE', N'In-Progress', 1, N'', NULL, CAST(GETDATE() AS DateTime), NULL, CAST(GETDATE() AS DateTime), 0, NULL, NULL, 1, NULL)
END

-- Exempted
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'9731de1d-2b6a-484c-bf10-44f842a3140e')
BEGIN
PRINT('Adding new status "Exempted"...');
INSERT [dbo].[QNN_STATUS] ([Id], [NumberId], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) VALUES (N'9731de1d-2b6a-484c-bf10-44f842a3140e', 4, N'EM', N'Exempted', 1, N'', NULL, CAST(GETDATE() AS DateTime), NULL, CAST(GETDATE() AS DateTime), 0, NULL, NULL, 0, NULL)
END

-- Acknowledged
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'19a0c4ff-be69-4011-a135-3c05a5429616')
BEGIN
PRINT('Adding new status "Acknowledged"...');
INSERT [dbo].[QNN_STATUS] ([Id], [NumberId], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) VALUES (N'19a0c4ff-be69-4011-a135-3c05a5429616', 17, N'AC', N'Acknowledged', 1, N'', NULL, CAST(GETDATE() AS DateTime), NULL, CAST(GETDATE() AS DateTime), 0, NULL, NULL, 0, NULL)
END

-- Updating Exempted-NIO to Exempted
IF EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'9731de1d-2b6a-484c-bf10-44f842a3140e'
	AND Title = 'Exempted-NIO')
BEGIN
PRINT('Updating status "Exempted-NIO" to "Exempted"...');
UPDATE [dbo].[QNN_STATUS] SET [TITLE] = 'Exempted'
WHERE [Id] = '9731de1d-2b6a-484c-bf10-44f842a3140e'
END

SET IDENTITY_INSERT [dbo].[QNN_STATUS] OFF

-- Adding the standard status flow
SET IDENTITY_INSERT [dbo].[QNN_STATUS_FLOW] ON

IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW 
	WHERE Id = N'15a6dca9-789c-43c3-9eaa-efd1713a5b89')
BEGIN
PRINT('Adding new status flow "Submitted to Cleared"...');
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [NumberId], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'15a6dca9-789c-43c3-9eaa-efd1713a5b89', 1, N'7c23b23e-23a3-4f04-96ef-89521babe78d', N'129c7781-536d-42f6-aca4-33a62f2e2c1f', NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW 
	WHERE Id = N'a0491fad-c686-4b43-820b-f09115c61bdb')
BEGIN
PRINT('Adding new status flow "Cleared to Submitted"...');
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [NumberId], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'a0491fad-c686-4b43-820b-f09115c61bdb', 2, N'129c7781-536d-42f6-aca4-33a62f2e2c1f', N'7c23b23e-23a3-4f04-96ef-89521babe78d', NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW 
	WHERE Id = N'8f318ed6-3636-4567-a69e-f09205bf8eec')
BEGIN
PRINT('Adding new status flow "Exempted to Pending"...');
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [NumberId], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'8f318ed6-3636-4567-a69e-f09205bf8eec', 3, N'9731de1d-2b6a-484c-bf10-44f842a3140e', N'a3d01086-40fc-4a7a-bf0c-de17bdd205fa', NULL, NULL)
END

IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW 
	WHERE Id = N'8AEF7979-14F0-4B91-BF93-9F2038CF209D')
BEGIN
PRINT('Adding new status flow "Acknowledged to Exempted to"...');
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [NumberId], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'8AEF7979-14F0-4B91-BF93-9F2038CF209D', 4, N'19a0c4ff-be69-4011-a135-3c05a5429616' ,N'9731de1d-2b6a-484c-bf10-44f842a3140e', NULL, NULL)
END

SET IDENTITY_INSERT [dbo].[QNN_STATUS_FLOW] OFF


-- Removing the non-standard status and the flow.
IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'50a76e5a-98f3-44bf-a161-003ed4fb2f3b')
BEGIN
PRINT('Removing status "Received"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'50a76e5a-98f3-44bf-a161-003ed4fb2f3b' OR ToStatus =N'50a76e5a-98f3-44bf-a161-003ed4fb2f3b'
DELETE FROM QNN_STATUS WHERE [Id] = N'50a76e5a-98f3-44bf-a161-003ed4fb2f3b'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'2868495b-b1d3-40a8-943b-0078927caa60')
BEGIN
PRINT('Removing status "Ceased Ops"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'2868495b-b1d3-40a8-943b-0078927caa60' OR ToStatus =N'2868495b-b1d3-40a8-943b-0078927caa60'
DELETE FROM QNN_STATUS WHERE [Id] = N'2868495b-b1d3-40a8-943b-0078927caa60'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'c90486b7-a885-49fd-bcf4-00cf80d3d730')
BEGIN
PRINT('Removing status "Dormant"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'c90486b7-a885-49fd-bcf4-00cf80d3d730' OR ToStatus =N'c90486b7-a885-49fd-bcf4-00cf80d3d730'
DELETE FROM QNN_STATUS WHERE [Id] = N'c90486b7-a885-49fd-bcf4-00cf80d3d730'
END


IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'8e08e44f-8a62-495a-8831-043e9cbdb2bc')
BEGIN
PRINT('Removing status "Out-of-Scope"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'8e08e44f-8a62-495a-8831-043e9cbdb2bc' OR ToStatus =N'8e08e44f-8a62-495a-8831-043e9cbdb2bc'
DELETE FROM QNN_STATUS WHERE [Id] = N'8e08e44f-8a62-495a-8831-043e9cbdb2bc'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'3a216f10-3ddd-4008-aa20-04c75dfde4ac')
BEGIN
PRINT('Removing status "Struck-off"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'3a216f10-3ddd-4008-aa20-04c75dfde4ac' OR ToStatus =N'3a216f10-3ddd-4008-aa20-04c75dfde4ac'
DELETE FROM QNN_STATUS WHERE [Id] = N'3a216f10-3ddd-4008-aa20-04c75dfde4ac'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'77a2d45e-3d98-43b9-ad2f-05af5b0f0a5b')
BEGIN
PRINT('Removing status "Holiding Company"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'77a2d45e-3d98-43b9-ad2f-05af5b0f0a5b' OR ToStatus =N'77a2d45e-3d98-43b9-ad2f-05af5b0f0a5b'
DELETE FROM QNN_STATUS WHERE [Id] = N'77a2d45e-3d98-43b9-ad2f-05af5b0f0a5b'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'9a0db841-f236-48da-91af-05dec27a92b4')
BEGIN
PRINT('Removing status "Not-In-Ops Yet"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'9a0db841-f236-48da-91af-05dec27a92b4' OR ToStatus =N'9a0db841-f236-48da-91af-05dec27a92b4'
DELETE FROM QNN_STATUS WHERE [Id] = N'9a0db841-f236-48da-91af-05dec27a92b4'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'5a1a28d7-df6a-4391-9965-05f17d7660e3')
BEGIN
PRINT('Removing status "Bounced"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'5a1a28d7-df6a-4391-9965-05f17d7660e3' OR ToStatus =N'5a1a28d7-df6a-4391-9965-05f17d7660e3'
DELETE FROM QNN_STATUS WHERE [Id] = N'5a1a28d7-df6a-4391-9965-05f17d7660e3'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'e9cc3d0b-9488-4546-9d17-08addc93e437')
BEGIN
PRINT('Removing status "Conso-Return"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'e9cc3d0b-9488-4546-9d17-08addc93e437' OR ToStatus =N'e9cc3d0b-9488-4546-9d17-08addc93e437'
DELETE FROM QNN_STATUS WHERE [Id] = N'e9cc3d0b-9488-4546-9d17-08addc93e437'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'93e2c53d-cf1e-4b4a-9226-0a33e6f06afa')
BEGIN
PRINT('Removing status "Partial Return"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'93e2c53d-cf1e-4b4a-9226-0a33e6f06afa' OR ToStatus =N'93e2c53d-cf1e-4b4a-9226-0a33e6f06afa'
DELETE FROM QNN_STATUS WHERE [Id] = N'93e2c53d-cf1e-4b4a-9226-0a33e6f06afa'
END


IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'c1c3d084-f194-4719-b7ae-0b62f14f67e8')
BEGIN
PRINT('Removing status "Incomplete Data Entry"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'c1c3d084-f194-4719-b7ae-0b62f14f67e8' OR ToStatus =N'c1c3d084-f194-4719-b7ae-0b62f14f67e8'
DELETE FROM QNN_STATUS WHERE [Id] = N'c1c3d084-f194-4719-b7ae-0b62f14f67e8'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'3FE8F2F4-4DEE-4A4A-B93C-B3FA12EA35D2')
BEGIN
PRINT('Removing status "Exempted-CR"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'3FE8F2F4-4DEE-4A4A-B93C-B3FA12EA35D2' OR ToStatus =N'3FE8F2F4-4DEE-4A4A-B93C-B3FA12EA35D2'
DELETE FROM QNN_STATUS WHERE [Id] = N'3FE8F2F4-4DEE-4A4A-B93C-B3FA12EA35D2'
END


IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'C14F238B-C28C-44F4-A8A4-105704F2BD85')
BEGIN
PRINT('Removing status "Exempted-Ex"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'C14F238B-C28C-44F4-A8A4-105704F2BD85' OR ToStatus =N'C14F238B-C28C-44F4-A8A4-105704F2BD85'
DELETE FROM QNN_STATUS WHERE [Id] = N'C14F238B-C28C-44F4-A8A4-105704F2BD85'
END


IF EXISTS(SELECT 1 FROM QNN_STATUS
	WHERE Id = N'16B54BE9-3418-4E7D-8E35-C8BFCF26FC95')
BEGIN
PRINT('Removing status "Exempted-OS"...');
DELETE FROM QNN_STATUS_FLOW WHERE FromStatus = N'16B54BE9-3418-4E7D-8E35-C8BFCF26FC95' OR ToStatus =N'16B54BE9-3418-4E7D-8E35-C8BFCF26FC95'
DELETE FROM QNN_STATUS WHERE [Id] = N'16B54BE9-3418-4E7D-8E35-C8BFCF26FC95'
END

IF EXISTS(SELECT 1 FROM QNN_STATUS_FLOW
	WHERE ToStatus = N'9731de1d-2b6a-484c-bf10-44f842a3140e')
BEGIN
PRINT('Removing flow status "Exempted-NIO"...');
DELETE FROM QNN_STATUS_FLOW WHERE ToStatus =N'9731de1d-2b6a-484c-bf10-44f842a3140e'
END


COMMIT TRANSACTION
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
    DECLARE @ErrorState INT = ERROR_STATE()

    -- Use RAISERROR inside the CATCH block to return error  
    -- information about the original error that caused  
    -- execution to jump to the CATCH block.  
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	ROLLBACK TRANSACTION
END CATCH
