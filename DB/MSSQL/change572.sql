-- change572.sql
-- Create the QNN_SAMPLE_REMARKS table
-- Update vSP_QnnSampleActiveForGrid to include remarks

DECLARE @qnn_sample_remarks_object_id INT;
SELECT @qnn_sample_remarks_object_id = object_id FROM sys.objects WHERE name='QNN_SAMPLE_REMARKS';

IF @qnn_sample_remarks_object_id IS NULL  
BEGIN
	PRINT 'Creating QNN_SAMPLE_REMARKS table';
			
	CREATE TABLE [dbo].[QNN_SAMPLE_REMARKS](
		[Id] [uniqueidentifier] NOT NULL,
		[SampleId] [uniqueidentifier] NOT NULL,
		[StructDivisionId] [uniqueidentifier] NOT NULL,
		[Remarks] [nvarchar](1024) NOT NULL
		CONSTRAINT [PK_QNN_SAMPLE_REMARKS] PRIMARY KEY CLUSTERED ([Id] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
			ON [PRIMARY],
		CONSTRAINT [UQ_QNN_SAMPLE_REMARKS_SampleId_StructDivisionId] UNIQUE NONCLUSTERED ([SampleId] ASC,[StructDivisionId] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR=80)
			ON [PRIMARY]
	) ON [PRIMARY];
	
	-- Default value constraint for remarks
	ALTER TABLE [dbo].[QNN_SAMPLE_REMARKS] ADD  CONSTRAINT [DF_QNN_SAMPLE_REMARKS_Remarks]  DEFAULT ('') FOR [Remarks];

	-- FK to QNN_SAMPLE
	ALTER TABLE [dbo].[QNN_SAMPLE_REMARKS] WITH CHECK ADD CONSTRAINT [FK_QNN_SAMPLE_REMARKS_QNN_SAMPLE] 
		FOREIGN KEY([SampleId]) 
		REFERENCES [dbo].[QNN_SAMPLE] ([Id]) 
		ON DELETE CASCADE;

	-- FK to StructDivision
	ALTER TABLE [dbo].[QNN_SAMPLE_REMARKS] WITH CHECK ADD CONSTRAINT [FK_QNN_SAMPLE_REMARKS_StructDivision] 
		FOREIGN KEY([StructDivisionId]) 
		REFERENCES [dbo].[StructDivision] ([Id]) 
		ON DELETE CASCADE;

END			
ELSE
BEGIN
	PRINT 'QNN_SAMPLE_REMARKS already exists (skipping creation)';
END
GO

-- ---------------------------------------------------------------------------------------------------------------------

PRINT 'Updating view vSP_QnnSampleActiveForGrid';
GO

--The ALTER has to be the only statement in its batch
ALTER VIEW [dbo].[vSP_QnnSampleActiveForGrid] AS 
SELECT 		
	ssd.StructDivisionId AS StructDivisionId,
	sd.Name AS StructDivisionName,
	s.Id AS Id,
	s.Name AS Name,
	s.UID AS UID,
	sa.ToEmails AS ToEmails,
	sa.CcEmails AS CcEmails,
	s.ActiveYN AS ActiveYN,
	s.NumRetry AS NumRetry,
	s.LastLoginDate AS LastLoginDate,
	r.Remarks
FROM
	QNN_SAMPLE_STRUCTDIVISION ssd
	INNER JOIN QNN_SAMPLE s ON ssd.SampleId=s.Id
	INNER JOIN StructDivision sd ON ssd.StructDivisionId=sd.Id
	LEFT JOIN QNN_SAMPLE_ADDRESS sa ON (sa.SampleId=s.Id AND sa.StructDivisionId=ssd.StructDivisionId)
	LEFT JOIN QNN_SAMPLE_REMARKS r ON (r.SampleId=s.Id AND r.StructDivisionId=ssd.StructDivisionId)		
WHERE
	s.IsDeleted = 0;