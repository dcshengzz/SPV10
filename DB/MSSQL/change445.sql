--Create the SurveyAdmin permission group and assign it to the existing SurveyAdmin role
BEGIN TRANSACTION CreateSurveyAdminPermissionGroup;
	
	DECLARE @AccessType_Inherit TINYINT = 0;
	DECLARE @AccessType_Allow TINYINT = 1;
	DECLARE @AccessType_Deny TINYINT = 2;

	--Existing well-known Ids
	DECLARE @SurveyAdmin_Role UNIQUEIDENTIFIER 
		= (SELECT [Id] FROM [dwSecurityRole] WHERE Code='SurveyAdmin'); --2ED51785-C2D1-CE0D-6F6F-96400C443D05
	
	--New Ids
	DECLARE @SurveyAdmin_Group UNIQUEIDENTIFIER = 'b13b5f04-c42b-438b-9aa6-cddb0f0338de';
	DECLARE @SurveyAdmin_Permission_View UNIQUEIDENTIFIER = '5d7d19c3-c23f-4caf-bf4f-07b990d17de7';
	DECLARE @SurveyAdmin_Permission_Edit UNIQUEIDENTIFIER = 'b966003b-5b4b-4258-84bf-0a3b769662c0';
	DECLARE @SurveyAdmin_To_SurveyAdmin_View UNIQUEIDENTIFIER = '358a45af-59aa-4506-bc9d-df9a766fd835';
	DECLARE @SurveyAdmin_To_SurveyAdmin_Edit UNIQUEIDENTIFIER = '9408cbbd-9e27-4a40-8e58-ca945499702b';


	-- Create the new permission security group
	IF NOT EXISTS (SELECT 1 FROM dwSecurityPermissionGroup WHERE Id=@SurveyAdmin_Group)
		BEGIN
			PRINT 'Creating the SurveyAdmin permission group';
			INSERT INTO dwSecurityPermissionGroup
				([Id], [Name], [Code])
			VALUES
				(@SurveyAdmin_Group, 'SurveyAdmin','SurveyAdmin');
		END
	ELSE
		PRINT 'SurveyAdmin permission group exists, skipping creation';

	-- Create the View and Edit permissions in the new permission group
	IF 2>(SELECT COUNT(*) FROM dwSecurityPermission
		WHERE Id IN (@SurveyAdmin_Permission_View, @SurveyAdmin_Permission_Edit))
		BEGIN
			PRINT 'Creating View, Edit permission in the SurveyAdmin permission group';
			INSERT INTO dwSecurityPermission 
				([Id], [Code], [Name], [GroupId])
				VALUES
				(@SurveyAdmin_Permission_View,'View','View',@SurveyAdmin_Group),
				(@SurveyAdmin_Permission_Edit,'Edit','Edit',@SurveyAdmin_Group);
		END
	ELSE
		PRINT 'SurveyAdmin group View, Edit permissions exist, skipping creation';

	-- Add Admins premission group's View, Edit (allow) permissions to the Admins role
	IF 2>(SELECT COUNT(*) FROM dwSecurityRoleToSecurityPermission
		WHERE Id IN(@SurveyAdmin_To_SurveyAdmin_View, @SurveyAdmin_To_SurveyAdmin_Edit))
		BEGIN
			PRINT 'Linking SurveyAdmin View, Edit permissions to SurveyAdmin role';
			INSERT INTO dwSecurityRoleToSecurityPermission 
				([Id], [SecurityRoleId], [SecurityPermissionId], [AccessType] )
				VALUES
				(@SurveyAdmin_To_SurveyAdmin_View, @SurveyAdmin_Role, @SurveyAdmin_Permission_View, @AccessType_Allow),
				(@SurveyAdmin_To_SurveyAdmin_Edit, @SurveyAdmin_Role, @SurveyAdmin_Permission_Edit, @AccessType_Allow);
		END
	ELSE
		PRINT 'SurveyAdmin permission group View, Edit aready linked to SurveyAdmin role, skipping linking';

COMMIT TRANSACTION CreateSurveyAdminPermissionGroup;
