--Create the ShortLink permission group and give it to SurveyAdmin role
BEGIN TRANSACTION CreateShortLinkGroup
	
	DECLARE @AccessType_Inherit TINYINT = 0;
	DECLARE @AccessType_Allow TINYINT = 1;
	DECLARE @AccessType_Deny TINYINT = 2;

	--Existing well-known Ids
	DECLARE @SurveyAdmin_Role UNIQUEIDENTIFIER 
		= (SELECT [Id] FROM [dwSecurityRole] WHERE Code='SurveyAdmin'); --2ED51785-C2D1-CE0D-6F6F-96400C443D05
	
	--New Ids
	DECLARE @ShortLink_Group UNIQUEIDENTIFIER = '003c200e-4440-4772-8163-0d739fd5e67c';
	DECLARE @ShortLink_Permission_View UNIQUEIDENTIFIER = 'aae5adb3-cf3f-430a-b609-fca9e09aad28';
	DECLARE @ShortLink_Permission_Edit UNIQUEIDENTIFIER = 'd3ab5e78-5d41-4963-a4f2-7b272798dab3';
	DECLARE @SurveyAdmin_To_ShortLink_View UNIQUEIDENTIFIER = 'fa2ffde2-bc6e-4477-ad01-d90c132f6b47';
	DECLARE @SurveyAdmin_To_ShortLink_Edit UNIQUEIDENTIFIER = '8105b2b0-010b-4732-99f0-3b38717b106b';

	-- Create the new permission security group
	IF NOT EXISTS(SELECT 1 FROM dwSecurityPermissionGroup WHERE Id=@ShortLink_Group)
	BEGIN
		INSERT INTO dwSecurityPermissionGroup	
			(Id, Name, Code)
			VALUES
			(@ShortLink_Group,'ShortLink','ShortLink');
	END

	-- Create the View and Edit permissions in the permission group
	IF NOT EXISTS(SELECT 1 FROM dwSecurityPermission
		WHERE Id IN (@ShortLink_Permission_View, @ShortLink_Permission_Edit))
	BEGIN
		INSERT INTO dwSecurityPermission 
			(Id, Code, Name, GroupId)
			VALUES
			(@ShortLink_Permission_View,'View','View',@ShortLink_Group),
			(@ShortLink_Permission_Edit,'Edit','Edit',@ShortLink_Group);
	END

	-- Add Allow View, Edit permissions to the role
	IF NOT EXISTS(SELECT 1 FROM dwSecurityRoleToSecurityPermission
		WHERE Id IN(@SurveyAdmin_To_ShortLink_View,@SurveyAdmin_To_ShortLink_Edit))
	BEGIN
		INSERT INTO dwSecurityRoleToSecurityPermission 
			(Id, SecurityRoleId, SecurityPermissionId, AccessType)
			VALUES
			(@SurveyAdmin_To_ShortLink_View, @SurveyAdmin_Role, @ShortLink_Permission_View, @AccessType_Allow),
			(@SurveyAdmin_To_ShortLink_Edit, @SurveyAdmin_Role, @ShortLink_Permission_Edit, @AccessType_Allow);
	END

COMMIT TRANSACTION CreateShortLinkGroup