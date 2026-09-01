-- Convert the instance to use the SIMS Status definitions and status flows. (Based on sims_change432.sql)
-- WARNING: This will eliminate any custom / non-sims-standard status
--          Any responses with non-SIMS status will be forcibly converted to Pending status. 
--          Messaging records and track list sample records for non-SIMS status will be DELETED.
--          (None of this should be an issue in prod as this script is expected to be  run against a clean database there,
--           but developers should take note of the effect on their test data in dev environments)

--SIMS Custom Status
DECLARE @SIMS_Received              UNIQUEIDENTIFIER = '50a76e5a-98f3-44bf-a161-003ed4fb2f3b';
DECLARE @SIMS_CeasedOps             UNIQUEIDENTIFIER = '2868495b-b1d3-40a8-943b-0078927caa60';
DECLARE @SIMS_Dormant               UNIQUEIDENTIFIER = 'c90486b7-a885-49fd-bcf4-00cf80d3d730';
DECLARE @SIMS_OutOfScope            UNIQUEIDENTIFIER = '8e08e44f-8a62-495a-8831-043e9cbdb2bc';
DECLARE @SIMS_StruckOff             UNIQUEIDENTIFIER = '3a216f10-3ddd-4008-aa20-04c75dfde4ac';
DECLARE @SIMS_HoldingCompany        UNIQUEIDENTIFIER = '77a2d45e-3d98-43b9-ad2f-05af5b0f0a5b';
DECLARE @SIMS_NotInOpsYet           UNIQUEIDENTIFIER = '9a0db841-f236-48da-91af-05dec27a92b4';
DECLARE @SIMS_Bounced               UNIQUEIDENTIFIER = '5a1a28d7-df6a-4391-9965-05f17d7660e3';
DECLARE @SIMS_ConsoReturn           UNIQUEIDENTIFIER = 'e9cc3d0b-9488-4546-9d17-08addc93e437';
DECLARE @SIMS_PartialReturn         UNIQUEIDENTIFIER = '93e2c53d-cf1e-4b4a-9226-0a33e6f06afa';
DECLARE @SIMS_IncompleteDataEntry   UNIQUEIDENTIFIER = 'c1c3d084-f194-4719-b7ae-0b62f14f67e8';

--Standard Core Status for SurveyPlus (Used in SIMS)
DECLARE @Core_InProgress            UNIQUEIDENTIFIER = '0d67932c-62ea-4cd3-a254-0cc63e742c93';
DECLARE @Core_Cleared               UNIQUEIDENTIFIER = '129c7781-536d-42f6-aca4-33a62f2e2c1f';
DECLARE @Core_Exempted              UNIQUEIDENTIFIER = '9731de1d-2b6a-484c-bf10-44f842a3140e';
DECLARE @Core_Submitted             UNIQUEIDENTIFIER = '7c23b23e-23a3-4f04-96ef-89521babe78d';
DECLARE @Core_Pending               UNIQUEIDENTIFIER = 'a3d01086-40fc-4a7a-bf0c-de17bdd205fa';
DECLARE @Core_Acknowledged          UNIQUEIDENTIFIER = '19a0c4ff-be69-4011-a135-3c05a5429616';

BEGIN TRY
BEGIN TRANSACTION T;

	CREATE TABLE #sims_status (
		Id UNIQUEIDENTIFIER,
		NumberId INT,
		Code VARCHAR(20),
		Title NVARCHAR(30),
		Active BIT,
		Description NVARCHAR(300),
		CreatedBy UNIQUEIDENTIFIER,
		CreatedDate DATETIME,
		UpdatedBy UNIQUEIDENTIFIER,
		UpdatedDate DATETIME,
		IsDeleted BIT,
		DeletedBy UNIQUEIDENTIFIER,
		DeletedDate DATETIME,
		HasRespYN BIT,
		StructDivisionId UNIQUEIDENTIFIER
	);

	PRINT('Preparing temporary table of SIMS status definitions');
	INSERT INTO #sims_status
		([Id], [NumberId], [Code], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId]) 
		VALUES 
		(@Core_Pending, 1, N'PE', N'Pending', 1, N'', NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), 0, NULL, NULL, 0, NULL),
		(@Core_InProgress, 2, N'DE', N'In-Progress', 1, N'', NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), 0, NULL, NULL, 1, NULL),
		(@Core_Submitted, 3, N'SB', N'Submitted', 1, N'', NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), 0, NULL, NULL, 1, NULL),
		(@Core_Exempted, 4, N'EM', N'Exempted', 0, N'', NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), NULL, CAST(N'2013-01-24T17:07:54.417' AS DateTime), 0, NULL, NULL, 0, NULL),
		(@Core_Cleared, 5, N'CL', N'Cleared', 1, N'', NULL, CAST(N'2013-01-24T17:07:54.420' AS DateTime), NULL, CAST(N'2013-01-24T17:07:54.420' AS DateTime), 0, NULL, NULL, 1, NULL),
		(@SIMS_Received, 6, N'RC', N'Received', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_CeasedOps, 7, N'CO', N'Ceased Ops', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_Dormant, 8, N'DM', N'Dormant', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_OutOfScope, 9, N'OS', N'Out-of-Scope', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_StruckOff, 10, N'SO', N'Struck-off', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_HoldingCompany, 11, N'HC', N'Holding Company', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_NotInOpsYet, 12, N'NI', N'Not-In-Ops Yet', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_Bounced, 13, N'BO', N'Bounced', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_ConsoReturn, 14, N'CR', N'Conso-Return', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_PartialReturn, 15, N'PR', N'Partial Return', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL),
		(@SIMS_IncompleteDataEntry, 16, N'IE', N'Incomplete Data Entry', 1, N'', NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, NULL),
		(@Core_Acknowledged, 17, N'AC', N'Acknowledged', 1, N'', NULL, CAST(GETDATE() AS DateTime), NULL, CAST(GETDATE() AS DateTime), 0, NULL, NULL, 0, NULL);

	PRINT('Deleting ALL existing Status Flow definitions ');
	DELETE FROM QNN_STATUS_FLOW;

	PRINT('Forcibly converting any usage of non-SIMS status to Pending in QNN_DPLY_SAMPLE_INFO');
	UPDATE QNN_DPLY_SAMPLE_INFO SET Status=@Core_Pending WHERE Status NOT IN (SELECT ID FROM #sims_status);

	PRINT('DELETING any rows in QNN_DPLY_MSG_FORSTATUS referring to non-SIMS status');
	DELETE FROM QNN_DPLY_MSG_FORSTATUS WHERE ForStatus NOT IN (SELECT ID FROM #sims_status);
	
	PRINT('DELETING any rows in QNN_GLOBAL_MSG_FORSTATUS referring to non-SIMS status');
	DELETE FROM QNN_GLOBAL_MSG_FORSTATUS WHERE ForStatus NOT IN (SELECT ID FROM #sims_status);

	PRINT('DELETING any rows in QNN_TRK_LIST_SAMPLE referring to non-SIMS status');
	DELETE FROM QNN_TRK_LIST_SAMPLE WHERE Status NOT IN (SELECT ID FROM #sims_status);

	PRINT('DELETING all non-SIMS Status definitions');
	DELETE FROM QNN_STATUS WHERE Id NOT IN (SELECT Id FROM #sims_status);

	SET IDENTITY_INSERT [dbo].[QNN_STATUS] ON;

	PRINT('Inserting or updating SIMS Status Definitions');
	MERGE QNN_STATUS AS qs
		USING (SELECT * FROM #sims_status) AS ss
			ON qs.Id=ss.Id
		WHEN MATCHED THEN
		  UPDATE SET 
			qs.Code=ss.Code,
			qs.Title=ss.Title,
			qs.Active=ss.Active,
			qs.Description=ss.Description,
			qs.CreatedBy=ss.CreatedBy,
			qs.CreatedDate=ss.CreatedDate,
			qs.UpdatedBy=ss.UpdatedBy,
			qs.UpdatedDate=ss.UpdatedDate,
			qs.IsDeleted=ss.IsDeleted,
			qs.DeletedBy=ss.DeletedBy,
			qs.DeletedDate=ss.DeletedDate,
			qs.HasRespYN=ss.HasRespYN,
			qs.StructDivisionId=ss.StructDivisionId
		WHEN NOT MATCHED THEN
		  INSERT (
			Id,
			NumberId,
			Code,
			Title,
			Active,
			Description,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			IsDeleted,
			DeletedBy,
			DeletedDate,
			HasRespYN,
			StructDivisionId
		  ) VALUES (
			ss.Id,
			ss.NumberId,
			ss.Code,
			ss.Title,
			ss.Active,
			ss.Description,
			ss.CreatedBy,
			ss.CreatedDate,
			ss.UpdatedBy,
			ss.UpdatedDate,
			ss.IsDeleted,
			ss.DeletedBy,
			ss.DeletedDate,
			ss.HasRespYN,
			ss.StructDivisionId);

	DROP TABLE #sims_status;

	SET IDENTITY_INSERT [dbo].[QNN_STATUS] OFF

	SET IDENTITY_INSERT [dbo].[QNN_STATUS_FLOW] ON;

	PRINT('Creating SIMS Status Flow definitions');
	INSERT [dbo].[QNN_STATUS_FLOW] ([Id], [NumberId], [FromStatus], [ToStatus], [CreateBy], [CreateOn]) 
		VALUES 		
		('15a6dca9-789c-43c3-9eaa-efd1713a5b89',  1, @Core_Submitted, @Core_Cleared, NULL, NULL),
		('a0491fad-c686-4b43-820b-f09115c61bdb',  2, @Core_Cleared, @Core_Submitted, NULL, NULL),
		('8f318ed6-3636-4567-a69e-f09205bf8eec',  3, @Core_Exempted, @Core_Pending, NULL, NULL),
		('5a4cefc8-67fe-4ad9-94c3-f1796b37eff8',  4, @Core_Pending, @SIMS_Received, NULL, NULL),
		('4c5e7cc9-1b2b-4c37-a0a8-f183cf46572f',  5, @Core_Pending, @SIMS_CeasedOps, NULL, NULL),
		('bf72f7db-f806-49c5-b857-f1854c12b1be',  6, @Core_Pending, @SIMS_Dormant, NULL, NULL),
		('3eb2414a-c200-4cde-9ca8-f186239b4b05',  7, @Core_Pending, @SIMS_OutOfScope, NULL, NULL),
		('5fa900f6-191c-4135-977d-f1c8c3d06d38',  8, @Core_Pending, @SIMS_StruckOff, NULL, NULL),
		('e21e74d5-248e-4658-81d8-f486c8f207c1',  9, @Core_Pending, @SIMS_HoldingCompany, NULL, NULL),
		('381ac4ee-b056-4c36-9cd3-fa1aaa8336fb', 10, @Core_Pending, @SIMS_NotInOpsYet, NULL, NULL),
		('59a78f60-ccb4-4d36-a361-fa1ec8dd29d2', 11, @Core_Pending, @SIMS_Bounced, NULL, NULL),
		('facb8bb6-e720-46c0-bcc7-fcb1b551e071', 12, @Core_InProgress, @SIMS_IncompleteDataEntry, NULL, NULL),
		('c9df7fc2-9c37-4292-b6dd-fd0ff4ebb738', 13, @Core_Submitted, @SIMS_IncompleteDataEntry, NULL, NULL),
		('55831859-15d6-47cc-accd-ff632cdd1845', 14, @SIMS_Received, @Core_Pending, NULL, NULL),
		('3ef06d3f-71ed-47da-a6b4-ff871c5957b1', 15, @SIMS_Received, @SIMS_ConsoReturn, NULL, NULL),
		('ff049fc4-435e-463f-815d-ffe7dc6297f6', 16, @SIMS_Received, @SIMS_PartialReturn, NULL, NULL),
		('bb9f789e-a771-4ab1-964e-dbbd4510221a', 17, @SIMS_CeasedOps, @Core_Pending, NULL, NULL),
		('5c0d25c6-c409-4e95-a477-deca76f4691a', 18, @SIMS_Dormant, @Core_Pending, NULL, NULL),
		('6518a592-09cd-4b6f-8235-deeebb8b81cf', 19, @SIMS_OutOfScope, @Core_Pending, NULL, NULL),
		('d30e9375-a533-41e9-9990-deffbe2c8179', 20, @SIMS_StruckOff, @Core_Pending, NULL, NULL),
		('4ca16395-823c-41f0-b859-e3dbf59f50a8', 21, @SIMS_HoldingCompany, @Core_Pending, NULL, NULL),
		('8c3ecb61-263b-4651-875c-e4ad9a4f5fb4', 22, @SIMS_NotInOpsYet, @Core_Pending, NULL, NULL),
		('745c7596-a365-4f9b-bf2b-e5aabea3137d', 23, @SIMS_Bounced, @Core_Pending, NULL, NULL),
		('ccaa91e7-286c-435b-9cc7-e6fed66f68b2', 24, @SIMS_ConsoReturn, @SIMS_Received, NULL, NULL),
		('65e99b1a-44c8-47cf-94f3-e96a73e3f9fd', 25, @SIMS_PartialReturn, @SIMS_Received, NULL, NULL),
		('79d3e257-6849-4bf7-848c-eb2742e86b2e', 26, @SIMS_IncompleteDataEntry, @Core_InProgress, NULL, NULL),
		('8AEF7979-14F0-4B91-BF93-9F2038CF209D', 27, @Core_Acknowledged, @Core_Exempted, NULL, NULL);

	SET IDENTITY_INSERT [dbo].[QNN_STATUS_FLOW] OFF;

COMMIT TRANSACTION T;
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