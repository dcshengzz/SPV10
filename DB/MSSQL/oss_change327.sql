-- Update the DataEditor and Organization access control:
-- 1. Remove the DataEditor permission group from SurveyAdmin (it will become inherited access)
-- 2. Remove the 'Deny' access mapping of SetDataEditor for Data Editor
-- 3. Add an Edit permission to the SetDataEditor permissions group
-- 4. Move the Organization permission group from SurveyAdmin to UserAdmin
-- (This script depends on the roles and permissions using the 'well-known' Ids)

BEGIN TRANSACTION UpdateAccess	
	DECLARE @SurveyAdmin_Role UNIQUEIDENTIFIER 
		= (SELECT [Id] FROM [dwSecurityRole] WHERE Code='SurveyAdmin');

	DECLARE @DataEditor_Role UNIQUEIDENTIFIER 
		= (SELECT [Id] FROM [dwSecurityRole] WHERE Code='DataEditor');

	DECLARE @UserAdmin_Role UNIQUEIDENTIFIER 
		= (SELECT [Id] FROM [dwSecurityRole] WHERE Code='UserAdmin');

	DECLARE @SetDataEditor_PermissionGroup UNIQUEIDENTIFIER
		= (SELECT [Id] FROM [dwSecurityPermissionGroup] WHERE Code='SetDataEditor');

	DECLARE @DataEditor_View_Permission UNIQUEIDENTIFIER 
		= (SELECT p.[Id] FROM [dwSecurityPermission] p LEFT JOIN [dwSecurityPermissionGroup] pg ON p.[GroupId]=pg.[Id]
		WHERE p.Code='View' AND pg.Code='DataEditor');

	DECLARE @DataEditor_Edit_Permission UNIQUEIDENTIFIER 
		= (SELECT p.[Id] FROM [dwSecurityPermission] p LEFT JOIN [dwSecurityPermissionGroup] pg ON p.[GroupId]=pg.[Id]
		WHERE p.Code='Edit' AND pg.Code='DataEditor');

	DECLARE @SetDataEditor_View_Permission UNIQUEIDENTIFIER 
		= (SELECT p.[Id] FROM [dwSecurityPermission] p LEFT JOIN [dwSecurityPermissionGroup] pg ON p.[GroupId]=pg.[Id]
		WHERE p.Code='View' AND pg.Code='SetDataEditor');

	--Id the new row in dwSecurityPermission will use
	DECLARE @SetDataEditor_Edit_Permission UNIQUEIDENTIFIER = '6f8d444f-2311-4d72-b220-9bb848261d88';

	--Id the new row in dwSecurityRoleToSecurityPermission will use
	DECLARE @SurveyAdmin_to_SetDataEditor_Edit UNIQUEIDENTIFIER = 'b62b0cff-4bb6-427e-b2e4-2097c6382e7e';

	DECLARE @Organization_View_Permission UNIQUEIDENTIFIER
		= (SELECT p.[Id] FROM [dwSecurityPermission] p LEFT JOIN [dwSecurityPermissionGroup] pg ON p.[GroupId]=pg.[Id]
		WHERE p.Code='View' AND pg.Code='Organization');

	DECLARE @Organization_Edit_Permission UNIQUEIDENTIFIER
		= (SELECT p.[Id] FROM [dwSecurityPermission] p LEFT JOIN [dwSecurityPermissionGroup] pg ON p.[GroupId]=pg.[Id]
		WHERE p.Code='Edit' AND pg.Code='Organization');

	DECLARE @AccessType_Inherit TINYINT = 0;
	DECLARE @AccessType_Allow TINYINT = 1;
	DECLARE @AccessType_Deny TINYINT = 2;

	--Remove Allow DataEditor permissions from the SurveyAdmin role
	--nb: we expect that the DataEditor role already has DataEditor permission group
	PRINT 'Removing DataEditor Allow permissions from SurveyAdmin role (if present)';
	DELETE FROM [dwSecurityRoleToSecurityPermission] 
		WHERE 
			[SecurityPermissionId] IN (@DataEditor_View_Permission, @DataEditor_Edit_Permission) 
			AND [AccessType]=@AccessType_Allow
			AND [SecurityRoleId]=@SurveyAdmin_Role;			

	--We will no longer explicitly Deny SetDataEditor View permission for all users with DataEditor
	--(i.e. This means a SurveyAdmin who has the role can now set sample owners)
	PRINT 'Removing the DataEditor.View Deny permission from DataEditor role (if present)'; 
	DELETE FROM [dwSecurityRoleToSecurityPermission]
		WHERE
			[SecurityPermissionId]=@SetDataEditor_View_Permission
			AND [AccessType]=@AccessType_Deny
			AND [SecurityRoleId]=@DataEditor_Role;

	--Create the new Edit permission in the SetDataEditor permission group and map it to SurveyAdmin role
	IF NOT EXISTS(SELECT 1 FROM dwSecurityPermission WHERE Code='Edit' AND GroupId=@SetDataEditor_PermissionGroup)
	BEGIN
		PRINT 'Creating the DataEditor.Edit permission because it is not present';
		--Create a new Edit permission in SetDataEditor permission group
		INSERT INTO [dwSecurityPermission] 
			(Id, Code, Name, GroupId)
			VALUES 
			(@SetDataEditor_Edit_Permission,'Edit','Edit',@SetDataEditor_PermissionGroup);

		--Create the mapping to Allow SetDataEditor.Edit for SurveyAdmin
		PRINT 'Adding the newly created DataEditor.Edit permisson to SurveyAdmin role';
		INSERT INTO [dwSecurityRoleToSecurityPermission]
			(Id, SecurityRoleId, SecurityPermissionId, AccessType)
			VALUES
			(@SurveyAdmin_to_SetDataEditor_Edit, @SurveyAdmin_Role, @SetDataEditor_Edit_Permission, @AccessType_Allow);
	END
	ELSE
		PRINT '(SetDataEditor permissions group already has Edit permission)';

	--Move Allow Organization.View / Organization.Edit mappings from SurveyAdmin to UserAdmin role
	IF NOT EXISTS(
		SELECT 1 FROM [dwSecurityRoleToSecurityPermission] 
		WHERE [SecurityPermissionId] IN (@Organization_View_Permission, @Organization_Edit_Permission)
		AND [AccessType]=@AccessType_Allow
		AND [SecurityRoleId]=@UserAdmin_Role)
	BEGIN
		PRINT 'Moving Organization.Edit and Organization.View permission mappings from SurveyAdmin role to UserAdmin role';
		UPDATE [dwSecurityRoleToSecurityPermission] 
			SET 
				[SecurityRoleId]=@UserAdmin_Role
			WHERE
				[SecurityPermissionId] IN (@Organization_View_Permission, @Organization_Edit_Permission)
				AND [AccessType]=@AccessType_Allow
				AND [SecurityRoleId]=@SurveyAdmin_Role;
	END
	ELSE
		PRINT '(SurveyAdmin role already has Organization.View and Organization.Edit permission mappings)';

COMMIT TRANSACTION UpdateAccess

