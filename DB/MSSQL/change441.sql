--Create the IamClient role for CAM access

--For the new Role
	DECLARE @IamClient_Role UNIQUEIDENTIFIER = 'A367307C-0956-907B-D881-38D151E713C8';

-- Create the new role
	IF NOT EXISTS (SELECT 1 FROM dwSecurityRole WHERE Id=@IamClient_Role)
		BEGIN
			PRINT 'Creating the IamClient role';
			INSERT INTO dwSecurityRole
				([Id], [Code], [Name])
			VALUES
				(@IamClient_Role, 'IamClient','IamClient');
		END
	ELSE
		PRINT 'IamClient role exists, skipping creation';