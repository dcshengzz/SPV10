--Create the SampleAdmin role and it will take the View, Edit permissions from the List permission group
--Do a one-time assignment of the SampleAdmin role to all users who currently have SurveyAdmin
--Remove the List Edit permission from SurveyAdmin role
BEGIN TRANSACTION CreateSampleAdminRole;
	
	DECLARE @AccessType_Inherit TINYINT = 0;
	DECLARE @AccessType_Allow TINYINT = 1;
	DECLARE @AccessType_Deny TINYINT = 2;

	--Existing Ids
	DECLARE @SurveyAdmin_Role UNIQUEIDENTIFIER 
		= (SELECT Id FROM dwSecurityRole WHERE Code='SurveyAdmin'); --2ED51785-C2D1-CE0D-6F6F-96400C443D05
	
	DECLARE @List_Permission_Group UNIQUEIDENTIFIER
		= (SELECT Id FROM dwSecurityPermissionGroup WHERE Code='List'); --42096EA9-3CB4-8C51-BBF2-5165029AE2C5

	DECLARE @List_View_Permission UNIQUEIDENTIFIER
		= (SELECT Id FROM dwSecurityPermission WHERE GroupId=@List_Permission_Group AND Code='View'); --3FEF0DBF-0DA5-43E0-A3B6-055BECF67B49

	DECLARE @List_Edit_Permission UNIQUEIDENTIFIER
		= (SELECT Id FROM dwSecurityPermission WHERE GroupId=@List_Permission_Group AND Code='Edit'); --5B6D0C2D-734A-2BE8-9002-C696DDD12613

	DECLARE @SurveyAdmin_To_List_Edit UNIQUEIDENTIFIER
		= (SELECT Id FROM dwSecurityRoleToSecurityPermission WHERE SecurityRoleId=@SurveyAdmin_Role AND SecurityPermissionId=@List_Edit_Permission); --779F2696-60FE-43B3-880A-EC34B6900337

	--New Ids
	DECLARE @SampleAdmin_Role UNIQUEIDENTIFIER = '6ed9e7b0-771c-4d02-8bc1-13fdf3bece52';	
	DECLARE @SampleAdmin_To_List_View UNIQUEIDENTIFIER = 'd7c90dfe-9cac-46cc-ab0f-808ba14f4066';
	DECLARE @SampleAdmin_To_List_Edit UNIQUEIDENTIFIER = '97697ea7-80af-4e01-bc75-c3fbee29f192';

	-- Create the new role, and assign it to anyone who already has SurveyAdmin
	IF NOT EXISTS (SELECT 1 FROM dwSecurityRole WHERE Id=@SampleAdmin_Role)
		BEGIN
			PRINT 'Creating the SampleAdmin role';
			INSERT INTO dwSecurityRole
				(Id, Code, Name)
			VALUES
				(@SampleAdmin_Role, 'SampleAdmin','SampleAdmin');

			--Do a one-time grant of this role to all the users who already have SurveyAdmin
			PRINT 'Assigning SampleAdmin role to all users with the SurveyAdmin role';
			INSERT INTO dwSecurityUserToSecurityRole (
				Id, SecurityRoleId, SecurityUserId )
				SELECT 
					NEWID() AS Id,
					@SampleAdmin_Role AS SecurityRoleId,
					SecurityUserId AS SecurityUserId
				FROM
					dwSecurityUserToSecurityRole
				WHERE
					SecurityRoleId=@SurveyAdmin_Role;

			PRINT 'Adding List permission group View, Edit permissions to SampleAdmin role';
			INSERT INTO dwSecurityRoleToSecurityPermission
				(Id, SecurityRoleId, SecurityPermissionId, AccessType)
				VALUES
				(@SampleAdmin_To_List_View, @SampleAdmin_Role, @List_View_Permission, @AccessType_Allow),
				(@SampleAdmin_To_List_Edit, @SampleAdmin_Role, @List_Edit_Permission, @AccessType_Allow);

			PRINT 'Removing List permission group Edit permission from SurveyAdmin role';
			UPDATE dwSecurityRoleToSecurityPermission
				SET AccessType=@AccessType_Inherit
				WHERE 
					Id=@SurveyAdmin_To_List_Edit;

		END
	ELSE
		PRINT 'SampleAdmin role exists, skipping creation and assuming permission linkages have been completed';


COMMIT TRANSACTION CreateSampleAdminRole;
