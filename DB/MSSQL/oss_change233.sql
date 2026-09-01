-- Add Allow Questionnaire View, Edit permission to SurveyDesigner role
IF NOT EXISTS(SELECT 1 FROM dwSecurityRoleToSecurityPermission 
	WHERE Id IN ('67484a07-535e-436e-8e61-42105ef680ee','00c57f6f-885a-4d68-9ada-424a9398d2f9'))
BEGIN
	INSERT INTO dwSecurityRoleToSecurityPermission 
		(Id, SecurityRoleId, SecurityPermissionId, AccessType)
		VALUES
		('67484a07-535e-436e-8e61-42105ef680ee', 'FA472DC4-A130-3533-42FF-08B18D4435C2', '929F7F52-14FC-4B22-AAC9-3C2E2CD3FE25', 1),
		('00c57f6f-885a-4d68-9ada-424a9398d2f9', 'FA472DC4-A130-3533-42FF-08B18D4435C2', 'F3290A11-5EBC-D098-65A8-52F5F0441BE4', 1);
END

-- Create the UserAdmin permission security group
IF NOT EXISTS(SELECT 1 FROM dwSecurityPermissionGroup
	WHERE Id IN ('143afc14-591e-4618-990f-c687bca5283d'))
BEGIN
	INSERT INTO dwSecurityPermissionGroup	
		(Id, Name, Code)
		VALUES
		('143afc14-591e-4618-990f-c687bca5283d','UserAdmin','UserAdmin');
END

-- Create the View and Edit permissions in the UserAdmin security permission group
IF NOT EXISTS(SELECT 1 FROM dwSecurityPermission
	WHERE Id IN ('f8ebb101-fdf7-4a15-a184-2f8a6db555b8','6638a744-3442-4b8f-a878-4ba3233ed8b8'))
BEGIN
	INSERT INTO dwSecurityPermission 
		(Id, Code, Name, GroupId)
		VALUES
		('f8ebb101-fdf7-4a15-a184-2f8a6db555b8','View','View','143afc14-591e-4618-990f-c687bca5283d'),
		('6638a744-3442-4b8f-a878-4ba3233ed8b8','Edit','Edit','143afc14-591e-4618-990f-c687bca5283d');
END

-- Add Allow View, Edit UserAdmin permissions to UserAdmin role
IF NOT EXISTS(SELECT 1 FROM dwSecurityRoleToSecurityPermission
	WHERE Id IN('a4875d1b-cf96-46dc-b5b4-c2daf2648a27','1a530efb-024c-4e73-8f30-2f372fd3f3d5'))
BEGIN
	INSERT INTO dwSecurityRoleToSecurityPermission 
		(Id, SecurityRoleId, SecurityPermissionId, AccessType)
		VALUES
		('a4875d1b-cf96-46dc-b5b4-c2daf2648a27', '33AEEC86-9B08-F725-BEE0-412A2C8B3180', 'f8ebb101-fdf7-4a15-a184-2f8a6db555b8', 1),
		('1a530efb-024c-4e73-8f30-2f372fd3f3d5', '33AEEC86-9B08-F725-BEE0-412A2C8B3180', '6638a744-3442-4b8f-a878-4ba3233ed8b8', 1);
END

-- Create the GlobalMailer security permission group
IF NOT EXISTS(SELECT 1 FROM dwSecurityPermissionGroup
	WHERE Id IN ('4e8785b2-7e84-4006-99e7-43811eb4db70'))
BEGIN
	INSERT INTO dwSecurityPermissionGroup	
		(Id, Name, Code)
		VALUES
		('4e8785b2-7e84-4006-99e7-43811eb4db70','GlobalMailer','GlobalMailer');
END

-- Create the View and Edit permissions in the GlobalMailer security permission group
IF NOT EXISTS(SELECT 1 FROM dwSecurityPermission
	WHERE Id IN ('ce78dcc0-165c-40a1-a714-33d929d79d76','87800ef3-6f41-480a-8ef4-afe859b7067b'))
BEGIN
	INSERT INTO dwSecurityPermission 
		(Id, Code, Name, GroupId)
		VALUES
		('ce78dcc0-165c-40a1-a714-33d929d79d76','View','View','4e8785b2-7e84-4006-99e7-43811eb4db70'),
		('87800ef3-6f41-480a-8ef4-afe859b7067b','Edit','Edit','4e8785b2-7e84-4006-99e7-43811eb4db70');
END

-- Add Allow View, Edit GlobalMailer permissions to SurveyAdmin role
IF NOT EXISTS(SELECT 1 FROM dwSecurityRoleToSecurityPermission
	WHERE Id IN('15dd041e-1091-4513-9661-f31b6efa3a3c','cd3d36ab-268f-4d11-bcf6-6ee4e4260a68'))
BEGIN
	INSERT INTO dwSecurityRoleToSecurityPermission 
		(Id, SecurityRoleId, SecurityPermissionId, AccessType)
		VALUES
		('15dd041e-1091-4513-9661-f31b6efa3a3c', '2ED51785-C2D1-CE0D-6F6F-96400C443D05', 'ce78dcc0-165c-40a1-a714-33d929d79d76', 1),
		('cd3d36ab-268f-4d11-bcf6-6ee4e4260a68', '2ED51785-C2D1-CE0D-6F6F-96400C443D05', '87800ef3-6f41-480a-8ef4-afe859b7067b', 1);
END