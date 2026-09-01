--Create the AuditAdmin role if it doesn't exist and give it Audit View and Edit
--and Remove the Audit View and Edit permissions from SurveyAdmin
--and give the swzadmin account AuditAdmin role
DECLARE @AuditAdminRole UNIQUEIDENTIFIER;
SET @AuditAdminRole = '88ac611d-220f-4c29-82a6-c6a2e03dfaf5';
IF NOT EXISTS(SELECT 1 FROM dwSecurityRole
	WHERE Id IN (@AuditAdminRole))
BEGIN
	INSERT INTO dwSecurityRole ([Id],[Code],[Name])
	VALUES
		(@AuditAdminRole,'AuditAdmin','AuditAdmin');

	DECLARE @AccessInherit TINYINT;
	DECLARE @AccessAllow TINYINT;
	DECLARE @AccessDeny TINYINT;
	SET @AccessInherit = 0;
	SET @AccessAllow = 1;
	SET @AccessDeny = 2;

	DECLARE @AuditViewPermission UNIQUEIDENTIFIER;
	DECLARE @AuditEditPermission UNIQUEIDENTIFIER;
	SET @AuditViewPermission = '0C05AB64-F483-57D5-F063-16F776287A64';
	SET @AuditEditPermission = '1EB05067-BB74-4B04-8939-00456795F343';

	--Give the Audit View and Edit permissions to AuditAdmin
	INSERT INTO dwSecurityRoleToSecurityPermission ([Id],[SecurityRoleId],[SecurityPermissionId],[AccessType])
	VALUES
		('0ad3c125-a396-4e2d-9069-cc3919418ae0', @AuditAdminRole, @AuditViewPermission, @AccessAllow),
		('ef585cd6-9d95-4b2c-ad8f-5d61f01e6f70', @AuditAdminRole, @AuditEditPermission, @AccessAllow);

	--Remove these permissions from SurveyAdmin
	DECLARE @SurveyAdmin UNIQUEIDENTIFIER;
	SET @SurveyAdmin = '2ED51785-C2D1-CE0D-6F6F-96400C443D05';
	UPDATE dwSecurityRoleToSecurityPermission
		SET [AccessType] = @AccessInherit
		WHERE [SecurityRoleId] = @SurveyAdmin
		AND [SecurityPermissionId] IN (@AuditViewPermission, @AuditEditPermission);

	--Give swzAdmin the AuditAdmin role
	DECLARE @SwzAdminUser UNIQUEIDENTIFIER;
	SET @SwzAdminUser = 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C';

	INSERT INTO dwSecurityUserToSecurityRole ([Id],[SecurityRoleId],[SecurityUserId])
	VALUES
		('74c214ba-5fcc-493a-8e0f-141cc429809c',@AuditAdminRole,@SwzAdminUser);
END
