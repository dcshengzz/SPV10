-- oss_change388.sql
-- Last Updated: 2023-04-18
-- CREATES AuditSampleName, AuditUserName, AuditDivisionName
-- and populates them based on existing data in the database.
-- (If you need to redo this population later you may wish to use AuditTrail_Rebuild_Audit_Name_Data.sql )

-- Note that this doesn't perform certain schema changes for various related updates related to this ( #542 ). 
-- These will be performed by a seperate schema update script (in uat/prod env) or schema compare/update (in dev env)

-- AuditSampleName
IF OBJECT_ID (N'dbo.AuditSampleName', N'U') IS NULL  
	BEGIN;
		PRINT 'Creating AuditSampleName table';
		
		CREATE TABLE [dbo].[AuditSampleName](
			[SampleId] [uniqueidentifier] NOT NULL,
			[Name] [nvarchar](128) NOT NULL,
			[UID] [nvarchar](320) NOT NULL,
		 CONSTRAINT [PK_AuditSampleName] PRIMARY KEY CLUSTERED 
		(
			[SampleId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY];
		
		PRINT 'Populating AuditSampleName table based on existing sample and audit data';
		INSERT INTO AuditSampleName (SampleId, Name, UID)
		SELECT DISTINCT 
			COALESCE(al.SampleId, qs.Id) AS SampleId, 
			COALESCE(qs.Name,'DELETED SAMPLE') AS Name, 
			COALESCE(qs.UID,'') AS UID
		FROM
			AuditLog al 
			FULL OUTER JOIN QNN_SAMPLE qs ON al.SampleId=qs.Id
		WHERE NOT (qs.Id IS NULL AND al.SampleId IS NULL);			
	END;
ELSE
	BEGIN;
		PRINT 'AuditSampleName already exists (skipping creation and population)';
	END;
GO

-- AuditUserName
IF OBJECT_ID (N'dbo.AuditUserName', N'U') IS NULL 
	BEGIN;
		PRINT 'Creating AuditUserName table';
	
		CREATE TABLE [dbo].[AuditUserName](
			[UserId] [uniqueidentifier] NOT NULL,
			[Name] [nvarchar](256) NOT NULL,
		 CONSTRAINT [PK_AuditUserName] PRIMARY KEY CLUSTERED 
		(
			[UserId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY];
	
	PRINT 'Populating AuditUserName table based on existing user and audit data)';
	
	INSERT INTO AuditUserName (UserId, Name)
		SELECT DISTINCT 
			COALESCE(al.UserId,su.Id) AS UserId, 
			COALESCE(su.Name,'DELETED USER') AS Name
		FROM 
			AuditLog al 
			FULL OUTER JOIN dwSecurityUser su ON al.UserId=su.Id
		WHERE 
			NOT (su.Id IS NULL AND al.UserID IS NULL);

	END;
ELSE
	BEGIN;
		PRINT 'AuditUserName already exits (skipping creation and population)';
	END;
GO
	
-- AuditDivisionName
IF OBJECT_ID (N'dbo.AuditDivisionName', N'U') IS NULL 
	BEGIN;
		PRINT 'Creating AuditDivisionName table';
		
		CREATE TABLE [dbo].[AuditDivisionName](
			[StructDivisionId] [uniqueidentifier] NOT NULL,
			[Name] [nvarchar](256) NOT NULL,
		 CONSTRAINT [PK_AuditDivisionName] PRIMARY KEY CLUSTERED 
		(
			[StructDivisionId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY];
		
		PRINT 'Populating AuditDivisionName table based on existing organisation and audit data';
		
		INSERT INTO AuditDivisionName
			SELECT DISTINCT 
				COALESCE(al.StructDivisionId, sd.Id) AS StructDivisionId, 
				COALESCE(sd.Name,'DELETED ORGANISATION') AS Division
			FROM
				AuditLog al FULL OUTER JOIN StructDivision sd ON al.StructDivisionId=sd.Id
			WHERE 
				NOT (sd.Id IS NULL AND al.StructDivisionId IS NULL);
		
	END;
ELSE
	BEGIN;
		PRINT 'AuditDivisionName table already exists (skipping creation and poulation)';
	END;
GO
