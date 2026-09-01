--Create dwAppsettings row for Additional SMTP Test Recipients
--Create the Maintenance role and a Maintenance permission group
BEGIN TRANSACTION T;
	
	--Create a row in dwAppSettings to hold comma-delimited list of emails to recieve the SMTP Test Email
	DECLARE @RecipientSetting NVARCHAR(50) = 'AdditionalSMTPTestRecipients';
	IF NOT EXISTS (SELECT 1 FROM dwAppSettings WHERE Name=@RecipientSetting)
		BEGIN
			PRINT 'Creating the ' + @RecipientSetting + ' setting';
			INSERT INTO dwAppSettings 
					([Name], [Value], [GroupName], [ParamName], [Order], [EditorType], [IsHidden]) 
				VALUES 
					(@RecipientSetting,'','Maintenance','Additional SMTP Test Recipients',0,0,0);
		END
	ELSE
		PRINT @RecipientSetting + ' setting already exists, skipping creation';
	
	DECLARE @AccessType_Inherit TINYINT = 0;
	DECLARE @AccessType_Allow TINYINT = 1;
	DECLARE @AccessType_Deny TINYINT = 2;

	--New Ids

	--For the new Role
	DECLARE @Maintenance_Role UNIQUEIDENTIFIER = 'ae7cf8a7-87f7-4e35-b34f-2994a621dfee';

	--For the Permission Group
	DECLARE @Maintenance_Group UNIQUEIDENTIFIER = '9e78ab95-ce9f-49cc-ae4f-c31824ca4825';

	--For Permissions in the permission group
	DECLARE @Maintenance_Permission_View UNIQUEIDENTIFIER = '388bf907-5433-4ba4-a7f6-471d870a4b5a';
	DECLARE @Maintenance_Permission_Edit UNIQUEIDENTIFIER = '8af06ac1-cf8e-4f50-9050-caa781647edf';

	--For linking the role to the permissions
	DECLARE @Maintenance_To_Maintenance_View UNIQUEIDENTIFIER = 'd82c3901-9813-4da1-a78f-109d66e7cdf5';
	DECLARE @Maintenance_To_Maintenance_Edit UNIQUEIDENTIFIER = 'dbdace46-80ce-4183-9e55-8fd82e556d4d';


	-- Create the new role
	IF NOT EXISTS (SELECT 1 FROM dwSecurityRole WHERE Id=@Maintenance_Role)
		BEGIN
			PRINT 'Creating the Maintenance role';
			INSERT INTO dwSecurityRole
				([Id], [Code], [Name])
			VALUES
				(@Maintenance_Role, 'Maintenance','Maintenance');
		END
	ELSE
		PRINT 'Maintenance role exists, skipping creation';

	-- Create the new permission security group
	IF NOT EXISTS (SELECT 1 FROM dwSecurityPermissionGroup WHERE Id=@Maintenance_Group)
		BEGIN
			PRINT 'Creating the Maintenance permission group';
			INSERT INTO dwSecurityPermissionGroup
				([Id], [Name], [Code])
			VALUES
				(@Maintenance_Group, 'Maintenance','Maintenance');
		END
	ELSE
		PRINT 'Maintenance permission group exists, skipping creation';

	-- Create the View and Edit permissions in the new permission group
	IF 2>(SELECT COUNT(*) FROM dwSecurityPermission
		WHERE Id IN (@Maintenance_Permission_View, @Maintenance_Permission_Edit))
		BEGIN
			PRINT 'Creating View, Edit permission in the Maintenance permission group';
			INSERT INTO dwSecurityPermission 
				([Id], [Code], [Name], [GroupId])
				VALUES
				(@Maintenance_Permission_View,'View','View',@Maintenance_Group),
				(@Maintenance_Permission_Edit,'Edit','Edit',@Maintenance_Group);
		END
	ELSE
		PRINT 'Maintenance View, Edit permissions exist, skipping creation';

	-- Add Maintenance View, Edit (allow) permissions to the Maintenance role
	IF 2>(SELECT COUNT(*) FROM dwSecurityRoleToSecurityPermission
		WHERE Id IN(@Maintenance_To_Maintenance_View, @Maintenance_To_Maintenance_Edit))
		BEGIN
			PRINT 'Linking Maintenance View, Edit permissions to Maintenance role';
			INSERT INTO dwSecurityRoleToSecurityPermission 
				([Id], [SecurityRoleId], [SecurityPermissionId], [AccessType] )
				VALUES
				(@Maintenance_To_Maintenance_View, @Maintenance_Role, @Maintenance_Permission_View, @AccessType_Allow),
				(@Maintenance_To_Maintenance_Edit, @Maintenance_Role, @Maintenance_Permission_Edit, @AccessType_Allow);
		END
	ELSE
		PRINT 'Maintenance View, Edit permissions aready linked to Maintenance role, skipping linking';

COMMIT TRANSACTION T;
