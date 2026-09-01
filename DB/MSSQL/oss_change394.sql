-- oss_change394.sql
-- First time population of the Sample AddressBook based on existing data in database

-- This script will create the QNN_SAMPLE_ADDRESS table and populate it based on the existing values in the
-- Email and CcEmails columns in QNN_SAMPLE for samples that are mapped in QNN_SAMPLE_STRUCTDIVISION.
-- Note that this script does not drop the Email, CcEmails columns from QNN_SAMPLE (this will be done in a
-- later schema update script (in uat/production) or schema compare & update (in dev)

IF OBJECT_ID (N'dbo.QNN_SAMPLE_ADDRESS', N'U') IS NULL  
	BEGIN;
		PRINT 'Creating QNN_SAMPLE_ADDRESS table';
			
		CREATE TABLE [dbo].[QNN_SAMPLE_ADDRESS](
			[Id] [uniqueidentifier] NOT NULL,
			[NumberId] [int] IDENTITY(1,1) NOT NULL,
			[SampleId] [uniqueidentifier] NOT NULL,
			[StructDivisionId] [uniqueidentifier] NULL,
			[CreatedBy] [uniqueidentifier] NULL,
			[CreatedDate] [datetime] NOT NULL,
			[UpdatedDate] [datetime] NULL,
			[UpdatedBy] [uniqueidentifier] NULL,
			[ToEmails] [nvarchar](max) NOT NULL,
			[CcEmails] [nvarchar](max) NOT NULL,
			[AddressLine1] [nvarchar](64) NOT NULL,
			[AddressLine2] [nvarchar](64) NOT NULL,
			[AddressLine3] [nvarchar](64) NOT NULL,
		 CONSTRAINT [PK_QNN_SAMPLE_ADDRESS] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
		 CONSTRAINT [UQ_QNN_SAMPLE_ADDRESS_SampleId_StructDivisionId] UNIQUE NONCLUSTERED 
		(
			[SampleId] ASC,
			[StructDivisionId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] ADD  CONSTRAINT [DF_QNN_SAMPLE_ADDRESS_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate];
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] ADD  CONSTRAINT [DF_QNN_SAMPLE_ADDRESS_ToEmails]  DEFAULT ('') FOR [ToEmails];
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] ADD  CONSTRAINT [DF_QNN_SAMPLE_ADDRESS_CcEmails]  DEFAULT ('') FOR [CcEmails];
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] ADD  CONSTRAINT [DF_QNN_SAMPLE_ADDRESS_AddressLine1]  DEFAULT ('') FOR [AddressLine1];
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] ADD  CONSTRAINT [DF_QNN_SAMPLE_ADDRESS_AddressLine2]  DEFAULT ('') FOR [AddressLine2];
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] ADD  CONSTRAINT [DF_QNN_SAMPLE_ADDRESS_AdddressLine3]  DEFAULT ('') FOR [AddressLine3];
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] WITH CHECK ADD  CONSTRAINT [FK_QNN_SAMPLE_ADDRESS_QNN_SAMPLE] FOREIGN KEY([SampleId]) REFERENCES [dbo].[QNN_SAMPLE] ([Id]) ON DELETE CASCADE;
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] CHECK CONSTRAINT [FK_QNN_SAMPLE_ADDRESS_QNN_SAMPLE];
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] WITH CHECK ADD  CONSTRAINT [FK_QNN_SAMPLE_ADDRESS_StructDivision] FOREIGN KEY([StructDivisionId]) REFERENCES [dbo].[StructDivision] ([Id]) ON DELETE SET NULL;
		ALTER TABLE [dbo].[QNN_SAMPLE_ADDRESS] CHECK CONSTRAINT [FK_QNN_SAMPLE_ADDRESS_StructDivision];		
			
		PRINT 'Checking for unmapped samples';
		SET NOCOUNT ON;
		DECLARE @UnmappedSamples TABLE (
			Id uniqueidentifier,
			UID nvarchar(320),
			Email nvarchar(320),
			CcEmails nvarchar(max) );
		INSERT INTO @UnmappedSamples (Id, UID, Email, CcEmails)
			SELECT 
				s.Id, s.UID, s.Email, s.CcEmails
			FROM 
				QNN_SAMPLE s 
				LEFT JOIN QNN_SAMPLE_STRUCTDIVISION ssd ON s.Id=ssd.SampleId
			WHERE 
				ssd.Id IS NULL
				AND s.Id<>'00000000-0000-0000-0000-000000000000';
		DECLARE @UnmappedSampleCount INTEGER;
		SELECT @UnmappedSampleCount=COUNT(*) FROM @UnmappedSamples;
		IF @UnmappedSampleCount > 0
			BEGIN;
				PRINT 'WARNING: There are ' + CAST(@UnmappedSampleCount AS NVARCHAR) + ' samples with no mapping in QNN_SAMPLE_STRUCTDIVISION';
				--SELECT * FROM @UnmappedSamples;
			END;
		ELSE
			PRINT 'OK: There are no samples without a mapping in QNN_SAMPLE_STRUCTDIVISION';
		SET NOCOUNT OFF;
			
		-- Initial population of the addressbook.
		-- Warning, samples that do not have a mapping in QNN_SAMPLE_STRUCTDIVISION will not have their addreess
		-- data copied, meaning it will be lost when the Email, CcEmail column is dropped from QNN_SAMPLE
		PRINT 'Populating QNN_SAMPLE_ADDRESS table based on existing sample and organisation mapping data';
		INSERT INTO QNN_SAMPLE_ADDRESS (
			Id,
			SampleId,
			StructDivisionId,
			ToEmails,
			CcEmails)
			SELECT
				NEWID() AS Id,
				ssd.SampleId AS SampleId,
				ssd.StructDivisionId AS StructDivisionId,
				TRIM(COALESCE(s.Email,'')) AS ToEmails,
				TRIM(COALESCE(s.CcEmails,'')) AS CCEmails
			FROM
				QNN_SAMPLE_STRUCTDIVISION ssd
				LEFT JOIN QNN_SAMPLE s ON ssd.SampleId=s.Id
			WHERE
				ssd.StructDivisionId <> '00000000-0000-0000-0000-000000000000'
			ORDER BY NumberId;
	END;
ELSE
	BEGIN;
		PRINT 'QNN_SAMPLE_ADDRESS already exists (skipping creation and population)';
	END;
GO