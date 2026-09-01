-- Restore status "Exempted"

-- adding Exempted in QNN_STATUS
SET IDENTITY_INSERT [dbo].[QNN_STATUS] ON 
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS 
	WHERE Id = N'9731de1d-2b6a-484c-bf10-44f842a3140e')
BEGIN
PRINT('Adding new status "Exempted"...');
INSERT [dbo].[QNN_STATUS] ([Id], [NumberId], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) VALUES (N'9731de1d-2b6a-484c-bf10-44f842a3140e', 4, N'EM', N'Exempted', 0, N'', NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), 0, NULL, NULL, 0, NULL)
END
SET IDENTITY_INSERT [dbo].[QNN_STATUS] OFF


-- adding Exempted QNN_STATUS_FLOW
SET IDENTITY_INSERT [dbo].[QNN_STATUS_FLOW] ON
IF NOT EXISTS(SELECT 1 FROM QNN_STATUS_FLOW 
	WHERE Id = N'8f318ed6-3636-4567-a69e-f09205bf8eec')
BEGIN
PRINT('Adding new status flow "Exempted to Pending"...');
INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [NumberId], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) VALUES (N'8f318ed6-3636-4567-a69e-f09205bf8eec', 3, N'9731de1d-2b6a-484c-bf10-44f842a3140e', N'a3d01086-40fc-4a7a-bf0c-de17bdd205fa', NULL, NULL)
END
SET IDENTITY_INSERT [dbo].[QNN_STATUS_FLOW] OFF