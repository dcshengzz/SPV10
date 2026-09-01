--Adds rows in dwAppSettings for mail-merge defaults (but only if they aren't there already)
--  MailMergeIncludeProps
--  MailMergeFileType

--MailMergeIncludeProps provides a default value to set in ExposeListSampleProps when using ProfileMailMerger
IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'MailMergeIncludeProps' AND [GroupName] = 'Mail Merge')
	BEGIN
		PRINT 'Adding MailMergeIncludeProps to dwAppSettings';
		INSERT INTO dwAppSettings 
			([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
		VALUES
			('MailMergeIncludeProps','True','Mail Merge','Include List Sample Properties for Token Substitution',0,'checkbox',0);		
	END
ELSE
	PRINT 'MailMergeIncludeProps already exists in dwAppSettings (skipping)';


--MailMergeFileType specifies file generation behaviour (See ProfileMailMerger.MergeFileType)
IF NOT EXISTS(SELECT 1 FROM dwAppSettings WHERE [Name] = 'MailMergeFileType' AND [GroupName] = 'Mail Merge')
	BEGIN
		PRINT 'Adding MailMergeFileType to dwAppSettings';
		INSERT INTO dwAppSettings 
			([Name],[Value],[GroupName],[ParamName],[Order],[EditorType],[IsHidden])
		VALUES
			('MailMergeFileType','Auto','Mail Merge','Generated Mail-Merge File Type (ZippedPdfs|SinglePdf|Auto)',1,'0',0);		
	END
ELSE
	PRINT 'MailMergeFileType already exists in dwAppSettings (skipping)';
