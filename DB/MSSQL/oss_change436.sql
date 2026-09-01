--Create the Admins permission group and assign it to the Admins role
BEGIN TRANSACTION CreateAdminsPermissionGroup;
	
	DECLARE @AccessType_Inherit TINYINT = 0;
	DECLARE @AccessType_Allow TINYINT = 1;
	DECLARE @AccessType_Deny TINYINT = 2;

	--Existing well-known Ids
	DECLARE @Admins_Role UNIQUEIDENTIFIER 
		= (SELECT [Id] FROM [dwSecurityRole] WHERE Code='Admins'); --1B7F60C8-D860-4510-8E71-5469FC1814D3
	
	--New Ids
	DECLARE @Admins_Group UNIQUEIDENTIFIER = '67f5658e-1354-47e4-9778-ef9dcbf3c9b2';
	DECLARE @Admins_Permission_View UNIQUEIDENTIFIER = '34382cff-fb05-4ea1-8571-820dbf8b0b11';
	DECLARE @Admins_Permission_Edit UNIQUEIDENTIFIER = 'fb810962-c6e9-436c-a786-435ed0a62a6e';
	DECLARE @Admins_To_Admins_View UNIQUEIDENTIFIER = '64709f7f-7e0b-4ed5-913d-a2d4c01b66c0';
	DECLARE @Admins_To_Admins_Edit UNIQUEIDENTIFIER = 'b368af2b-7dfe-4a27-a604-7e4676443904';

	-- Create the new permission security group
	IF NOT EXISTS (SELECT 1 FROM dwSecurityPermissionGroup WHERE Id=@Admins_Group)
		BEGIN
			PRINT 'Creating the Admins permission group';
			INSERT INTO dwSecurityPermissionGroup
				([Id], [Name], [Code])
			VALUES
				(@Admins_Group, 'Admins','Admins');
		END
	ELSE
		PRINT 'Admins permission group exists, skipping creation';

	-- Create the View and Edit permissions in the new permission group
	IF 2>(SELECT COUNT(*) FROM dwSecurityPermission
		WHERE Id IN (@Admins_Permission_View, @Admins_Permission_Edit))
		BEGIN
			PRINT 'Creating View, Edit permission in the Admins permission group';
			INSERT INTO dwSecurityPermission 
				([Id], [Code], [Name], [GroupId])
				VALUES
				(@Admins_Permission_View,'View','View',@Admins_Group),
				(@Admins_Permission_Edit,'Edit','Edit',@Admins_Group);
		END
	ELSE
		PRINT 'Admins group View, Edit permissions exist, skipping creation';

	-- Add Admins premission group's View, Edit (allow) permissions to the Admins role
	IF 2>(SELECT COUNT(*) FROM dwSecurityRoleToSecurityPermission
		WHERE Id IN(@Admins_To_Admins_View, @Admins_To_Admins_Edit))
		BEGIN
			PRINT 'Linking Admins group View, Edit permissions to SampleAdmin role';
			INSERT INTO dwSecurityRoleToSecurityPermission 
				([Id], [SecurityRoleId], [SecurityPermissionId], [AccessType] )
				VALUES
				(@Admins_To_Admins_View, @Admins_Role, @Admins_Permission_View, @AccessType_Allow),
				(@Admins_To_Admins_Edit, @Admins_Role, @Admins_Permission_Edit, @AccessType_Allow);
		END
	ELSE
		PRINT 'Admins permission group View, Edit aready linked to Admins role, skipping linking';

COMMIT TRANSACTION CreateAdminsPermissionGroup;
