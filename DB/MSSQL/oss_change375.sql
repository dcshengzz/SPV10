--Create the Designer permission group and give it to SurveyDesigner role
BEGIN TRANSACTION CreateDesignerGroup
	
	DECLARE @AccessType_Inherit TINYINT = 0;
	DECLARE @AccessType_Allow TINYINT = 1;
	DECLARE @AccessType_Deny TINYINT = 2;

	DECLARE @SurveyDesigner_Role UNIQUEIDENTIFIER 
		= (SELECT [Id] FROM [dwSecurityRole] WHERE Code='SurveyDesigner'); 
	
	--New Ids
	DECLARE @Designer_Group UNIQUEIDENTIFIER = 'f834b0ee-779f-4c44-ada7-fec445dab009';
	DECLARE @Designer_Permission_View UNIQUEIDENTIFIER = 'caf10089-b7ee-42dc-8071-2d9b48b490c2';
	DECLARE @Designer_Permission_Edit UNIQUEIDENTIFIER = '37b9756e-82cc-43fe-a038-7e74ca3726c7';
	DECLARE @SurveyDesigner_To_Designer_View UNIQUEIDENTIFIER = 'df457608-069f-4a6b-adf9-d7f248dc2bc3';
	DECLARE @SurveyDesigner_To_Designer_Edit UNIQUEIDENTIFIER = 'a89a2108-313a-47ee-a88d-05a11ba1c0d2';

	-- Create the new permission security group
	IF NOT EXISTS(SELECT 1 FROM dwSecurityPermissionGroup WHERE Id=@Designer_Group)
	BEGIN
		INSERT INTO dwSecurityPermissionGroup	
			(Id, Name, Code)
			VALUES
			(@Designer_Group,'Designer','Designer');
	END

	-- Create the View and Edit permissions in the permission group
	IF NOT EXISTS(SELECT 1 FROM dwSecurityPermission
		WHERE Id IN (@Designer_Permission_View, @Designer_Permission_Edit))
	BEGIN
		INSERT INTO dwSecurityPermission 
			(Id, Code, Name, GroupId)
			VALUES
			(@Designer_Permission_View,'View','View',@Designer_Group),
			(@Designer_Permission_Edit,'Edit','Edit',@Designer_Group);
	END

	-- Add Allow View, Edit permissions to the role
	IF NOT EXISTS(SELECT 1 FROM dwSecurityRoleToSecurityPermission
		WHERE Id IN(@SurveyDesigner_To_Designer_View,@SurveyDesigner_To_Designer_Edit))
	BEGIN
		INSERT INTO dwSecurityRoleToSecurityPermission 
			(Id, SecurityRoleId, SecurityPermissionId, AccessType)
			VALUES
			(@SurveyDesigner_To_Designer_View, @SurveyDesigner_Role, @Designer_Permission_View, @AccessType_Allow),
			(@SurveyDesigner_To_Designer_Edit, @SurveyDesigner_Role, @Designer_Permission_Edit, @AccessType_Allow);
	END

COMMIT TRANSACTION CreateDesignerGroup