
--Note: doesnt clear StructDivision (organisations) or users

--Note: doesn't cover workflow tables yet

--Note: doesn't clear QNN_HELP

--Note: will break audit trail (use AuditTrail_EmptyRows.sql to fix)

--Note: doesn't clear form designs and form templates

--Note: will lose the swzanonymous sammple, use intitialise_anonymous_sample to restore it

DELETE FROM [dbo].[QNN_RESP]
DELETE FROM [dbo].[QNN_DPLY_SAMPLE_INFO]
DELETE FROM [dbo].[QNN_DPLY_SAMPLE_OWNER]
DELETE FROM [dbo].[QNN_DPLY_SAMPLE_DUEDATE]
DELETE FROM [dbo].[QNN_DPLY_MSG]

--Following commented out because not correct. 
--Delete survey qnn (but this only deletes settings!)
--DELETE FROM [dbo].[dwMetadata] WHERE Data LIKE '%isSurvey": true%' 

DELETE FROM [dbo].[QNN_QNN]  
DELETE FROM [dbo].[QNN_LIST_SAMPLE_PROP]
DELETE FROM [dbo].[QNN_SAMPLE] WHERE Id NOT IN (SELECT SampleID FROM QNN_LIST_SAMPLE) 

DELETE FROM [dbo].[QNN_LIST_SAMPLE] WHERE Id NOT IN (SELECT ListId FROM QNN_LIST)

DELETE FROM [dbo].[QNN_SAMPLE] 
DELETE FROM [dbo].[QNN_LIST]
DELETE FROM [dbo].[QNN_TRK_LIST]
DELETE FROM [dbo].[QNN_TRK_LIST_SAMPLE]
DELETE FROM [dbo].[QNN_CATEGORY]

-- Delete non-annex files
DELETE FROM [dbo].[dwUploadedFiles] WHERE IsLocalStorage <> '1'

DELETE FROM [dbo].[AuditLog]
DELETE FROM [dbo].[QNN_DPLY_SCHEDULER]
DELETE FROM [dbo].[QNN_REPORT_SNAPSHOT]

DELETE FROM [dbo].[QNN_GLOBAL_MSG];
DELETE FROM [dbo].[QNN_RULE];
GO


