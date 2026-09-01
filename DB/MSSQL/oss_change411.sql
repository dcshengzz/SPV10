--Create the DataOwner role
BEGIN TRANSACTION CreateDataOwnerRole;
	
	--New Ids
	DECLARE @DataOwner_Role UNIQUEIDENTIFIER = '4dec1d94-1008-437f-85d3-09dbaf97f428';

	-- Create the new role
	IF NOT EXISTS (SELECT 1 FROM dwSecurityRole WHERE Id=@DataOwner_Role)
		BEGIN
			PRINT 'Creating the DataOwner role';
			INSERT INTO dwSecurityRole
				([Id], [Code], [Name])
			VALUES
				(@DataOwner_Role, 'DataOwner','DataOwner');
		END
	ELSE
		PRINT 'DataOwner role exists, skipping creation';

	-- n.b initially this new role has no associated permissions

COMMIT TRANSACTION CreateDataOwnerRole;