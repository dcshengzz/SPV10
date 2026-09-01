--survey_extraction.sql 
--Last Updated 20240320 18:30

--Valid for SurveyPlus database schema as at SQL 457 on 20230319
--May need to be adjusted for backward and forward compatability with other versions 
--as per any relevant schema changes that have occured.

--Requires a special [survey_extration] target database. This has been specially cleaned and
--certain triggers and records removed. The data will be copied into it.

--Warning, this script is destructive to the [survey_extraction] target database, take care that the
--database [survey_extraction] does not have existing data that must be preserved.

--TODO - update script to nuke more data in the extraction target db to facilitate retries better
--TODO - Track List support

-- DOES NOT COPY THE FORM DESIGN from dwUploadedFiles or dwSecurityUser (this may break things, but can we still export?)
-- the last updated user will not be in the export

--Change the following to your source database. Destination database must always be named [survey_extraction]
USE [swz_surveyplus_v6];

DECLARE @DplyId UNIQUEIDENTIFIER;
--Update the deployment name or explicit Id below to select the source deployment
--SELECT @DplyId = '29599F08-7CD5-4290-A138-DCDEBFE00A34';
SELECT @DplyId= (SELECT Id FROM QNN_DPLY WHERE Name='Basic Sandwich Survey');

DECLARE @StructDivisionId UNIQUEIDENTIFIER;
DECLARE @QnnId UNIQUEIDENTIFIER;
DECLARE @ListId UNIQUEIDENTIFIER;
DECLARE @SystemDefaultStructDivisionId UNIQUEIDENTIFIER = 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045';

--This extraction script expects the data tables to be clean, but a failed run may have polluted them
--clean up now to make it easier to retry without re-restoring the extraction database. 
PRINT 'Ensuring clean target table QNN_RESP';
DELETE FROM [survey_extraction].[dbo].[QNN_RESP] ;
PRINT 'Ensuring clean target table QNN_DPLY_SAMPLE_INFO';
DELETE FROM [survey_extraction].[dbo].[QNN_DPLY_SAMPLE_INFO];
PRINT 'Ensuring clean target table QNN_DPLY';
DELETE FROM [survey_extraction].[dbo].[QNN_DPLY];
PRINT 'Ensuring clean target table QNN_LIST_SAMPLE_PROP';
DELETE FROM [survey_extraction].[dbo].[QNN_LIST_SAMPLE_PROP];
PRINT 'Ensuring clean target table QNN_SAMPLE';
DELETE FROM [survey_extraction].[dbo].[QNN_SAMPLE] WHERE [Id] NOT IN ('00000000-0000-0000-0000-000000000000');
PRINT 'Ensuring clean target table QNN_LIST';
DELETE FROM [survey_extraction].[dbo].[QNN_LIST];
PRINT 'Ensuring clean target table QNN_QNN';
DELETE FROM [survey_extraction].[dbo].[QNN_QNN];
PRINT 'Ensuring clean target table QNN_STATUS_FLOW';
DELETE FROM [survey_extraction].[dbo].[QNN_STATUS_FLOW];
PRINT 'Ensuring clean target table QNN_STATUS';
DELETE FROM [survey_extraction].[dbo].[QNN_STATUS];
PRINT 'Ensuring clean target table StructDivision';
DELETE FROM [survey_extraction].[dbo].[StructDivision] WHERE [Id] NOT IN (@SystemDefaultStructDivisionId, '00000000-0000-0000-0000-000000000000');

--Find the main survey objects for this deployment
SELECT @StructDivisionId=[StructDivisionId], @QnnId=[QnnId], @ListId=[ListId] FROM [QNN_DPLY] WHERE [Id]=@DplyId;

--If one of these is still ON then we can't turn on for any other, so make sure all are off before starting
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_STATUS] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_STATUS_FLOW] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_QNN] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_QNN_FIELD] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_PROP] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_PROP_OPT] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_SAMPLE] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_SAMPLE_ADDRESS] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_SAMPLE] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_SAMPLE_PROP] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_DPLY] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_DPLY_SAMPLE_INFO] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_RESP] OFF;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_RESP_ANS] OFF;

IF(@StructDivisionId <> @SystemDefaultStructDivisionId) 
BEGIN
	PRINT 'Copying from StructDivision';
	INSERT INTO [survey_extraction].[dbo].[StructDivision]
			([Id], [Name], [ParentId])
		SELECT 
			[Id], [Name], @SystemDefaultStructDivisionId AS [ParentId]
		FROM [StructDivision] WHERE [Id]=@StructDivisionId;
END

--QNN_STATUS
PRINT 'Copying from QNN_STATUS';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_STATUS] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_STATUS]
	([Id], [NumberId], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],
	[IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId], [Code])
	SELECT
	[Id], [NumberId], [Title], [Active], [Description], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],
	[IsDeleted], [DeletedBy], [DeletedDate], [HasRespYN], [StructDivisionId], [Code]
	FROM [QNN_STATUS] WHERE [StructDivisionId] IS NULL OR [StructDivisionId]=@StructDivisionId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_STATUS] OFF;

--QNN_STATUS_FLOW
PRINT 'Copying from QNN_STATUS_FLOW';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_STATUS_FLOW] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_STATUS_FLOW]
	([Id], [NumberId], [FromStatus], [ToStatus], [CreateBy], [CreateOn])
	SELECT 
	[f].[Id], [f].[NumberId], [f].[FromStatus], [f].[ToStatus], [f].[CreateBy], [f].[CreateOn]
	FROM [QNN_STATUS_FLOW] [f] LEFT JOIN [QNN_STATUS] [s] ON [f].[FromStatus]=[s].[Id] 
	WHERE [s].[StructDivisionId] IS NULL OR [s].[StructDivisionId]=@StructDivisionId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_STATUS_FLOW] OFF;

--QNN_QNN
PRINT 'Copying from QNN_QNN';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_QNN] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_QNN]
	([Id], [NumberId], [Title], [Description], [FieldCount], [Type], [Status], [CreatedBy], [CreatedDate], [IsDeleted], [DeletedBy],
	[DeletedDate], [UpdatedBy], [UpdatedDate], [StructDivisionId], [Tags])
	SELECT 
	[Id], [NumberId], [Title], [Description], [FieldCount], [Type], [Status], [CreatedBy], [CreatedDate], [IsDeleted], [DeletedBy],
	[DeletedDate], [UpdatedBy], [UpdatedDate], [StructDivisionId], [Tags]
	FROM QNN_QNN WHERE Id=@QnnId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_QNN] OFF;

--QNN_QNN_FIELD
PRINT 'Copying from QNN_QNN_FIELD';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_QNN_FIELD] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_QNN_FIELD]
	([Id], [NumberId], [QnnId], [Name], [Type], 
	[Required], [ReadOnly], [ValidationExp], [ValidationErr])
	SELECT 
	[qf].[Id], [qf].[NumberId], [qf].[QnnId], [qf].[Name], [qf].[Type], 
	[qf].[Required], [qf].[ReadOnly],[qf]. [ValidationExp], [qf].[ValidationErr]
	FROM QNN_QNN q LEFT JOIN QNN_QNN_FIELD qf ON qf.QnnId=q.Id WHERE q.Id=@QnnId; --left join as we expect at least one field
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_QNN_FIELD] OFF;

--QNN_LIST
PRINT 'Copying FROM QNN_LIST';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST] ON;
INSERT INTO  [survey_extraction].[dbo].[QNN_LIST]
	([Id], [NumberId], [Name], [Description], [Status], [UIDUsrEditYN], [NameUsrEditYN], [EmailUsrEditYN], [ActiveUsrEditYN], [PasswordUsrEditYN],
	[CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [StructDivisionId], [TrkListIds], [Tags])
	SELECT
	[Id], [NumberId], [Name], [Description], [Status], [UIDUsrEditYN], [NameUsrEditYN], [EmailUsrEditYN], [ActiveUsrEditYN], [PasswordUsrEditYN],
	[CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [IsDeleted], [DeletedBy], [StructDivisionId], [TrkListIds], [Tags]
	FROM QNN_LIST WHERE Id=@ListId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST] OFF;

--QNN_LIST_PROP
PRINT 'Copying from QNN_LIST_PROP';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_PROP] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_LIST_PROP]
	([Id], [NumberId], [ListId], [Type], [Alias], [ReqdYN], [UsrEditYN], [TxtRow], 
	[TxtRegExp], [TxtRegExpErr], [OptType], [UsrVisibleYN], [RespVisibleYN])
	SELECT
	[Id], [NumberId], [ListId], [Type], [Alias], [ReqdYN], [UsrEditYN], [TxtRow], 
	[TxtRegExp], [TxtRegExpErr], [OptType], [UsrVisibleYN], [RespVisibleYN]
	FROM QNN_LIST_PROP WHERE ListId=@ListId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_PROP] OFF;

--QNN_LIST_PROP_OPT
PRINT 'Copying from QNN_LIST_PROP_OPT';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_PROP_OPT] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_LIST_PROP_OPT]
	([Id], [NumberId], [PropId], [OptVal], [OptTxt])
	SELECT
	[o].[Id], [o].[NumberId], [o].[PropId], [o].[OptVal], [o].[OptTxt]
	FROM QNN_LIST_PROP p INNER JOIN QNN_LIST_PROP_OPT o ON p.Id=o.PropId WHERE p.ListId=@ListId; --inner join as may be none
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_PROP_OPT] OFF;

--QNN_QNN_SAMPLE
PRINT 'Copying from QNN_SAMPLE (ignoring Pwd)';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_SAMPLE] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_SAMPLE]
	([Id], [NumberId], [ActiveYN], [UID], [Name], [PwdResetYN], [Pwd], 
	[NumRetry], [CreatedBy], [CreatedDate],[UpdatedBy], [UpdatedDate], [SelfUpdatedDate], 
	[IsDeleted], [DeletedBy], [DeletedDate], [PwdResetToken], [LastLoginDate])
	SELECT
	[s].[Id], [s].[NumberId], [s].[ActiveYN], [s].[UID], [s].[Name], [s].[PwdResetYN], NULL /*Pwd*/, 
	[s].[NumRetry], [s].[CreatedBy], [s].[CreatedDate], [s].[UpdatedBy], [s].[UpdatedDate], [s].[SelfUpdatedDate], 
	[s].[IsDeleted], [s].[DeletedBy], [s].[DeletedDate], [s].[PwdResetToken], [s].[LastLoginDate]
	FROM QNN_LIST_SAMPLE ls LEFT JOIN QNN_SAMPLE s ON ls.SampleId=s.Id WHERE ListId=@ListId; --left join as we expect at least one sample in list
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_SAMPLE] OFF;

--QNN_SAMPLE_STRUCTDIVISION
PRINT 'Copying from QNN_SAMPLE_STRUCTDIVISION';
--n.b. no identity column here
INSERT INTO [survey_extraction].[dbo].[QNN_SAMPLE_STRUCTDIVISION]
	([Id],[SampleId], [StructDivisionId])
	SELECT 
		[d].[Id], [d].[SampleId], [d].[StructDivisionId]
	FROM QNN_LIST_SAMPLE ls LEFT JOIN QNN_SAMPLE_STRUCTDIVISION d ON ls.SampleId=d.SampleId 
	WHERE ls.ListId=@ListId AND d.StructDivisionId=@StructDivisionId;

--QNN_SAMPLE_ADDRESS
PRINT 'Copying from QNN_SAMPLE_ADDRESS';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_SAMPLE_ADDRESS] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_SAMPLE_ADDRESS]
	([Id], [NumberId], [SampleId], [StructDivisionId], 
	[CreatedBy], [CreatedDate],[UpdatedBy],[UpdatedDate],
	[ToEmails], [CcEmails], [AddressLine1], [AddressLine2], [AddressLine3])
	SELECT 
	[a].[Id], [a].[NumberId], [a].[SampleId], [a].[StructDivisionId], 
	[a].[CreatedBy], [a].[CreatedDate], [a].[UpdatedBy], [a].[UpdatedDate],
	[a].[ToEmails], [a].[CcEmails], [a].[AddressLine1], [a].[AddressLine2], [a].[AddressLine3]
	FROM QNN_LIST_SAMPLE ls INNER JOIN QNN_SAMPLE_ADDRESS a ON ls.SampleId=a.SampleId
	WHERE ls.ListId=@ListId AND a.StructDivisionId=@StructDivisionId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_SAMPLE_ADDRESS] OFF;

--QNN_LIST_SAMPLE
PRINT 'Copying from QNN_LIST_SAMPLE (ignoring SamplePeerId)';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_SAMPLE] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_LIST_SAMPLE]
	([Id], [NumberId], [ListId], [ActiveYN], [CreatedBy], [CreatedDate],[UpdatedBy], [UpdatedDate], 
	[IsDeleted], [DeletedBy], [DeletedDate],[SampleId], [SamplePeerId])
	SELECT
	[Id], [NumberId], [ListId], [ActiveYN], [CreatedBy], [CreatedDate],[UpdatedBy], [UpdatedDate], 
	[IsDeleted], [DeletedBy], [DeletedDate],[SampleId], NULL /*SamplePeerId*/
	FROM QNN_LIST_SAMPLE WHERE ListId=@ListId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_SAMPLE] OFF;

--QNN_LIST_SAMPLE_PROP
PRINT 'Copying from QNN_LIST_SAMPLE_PROP';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_SAMPLE_PROP] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_LIST_SAMPLE_PROP]
	([Id], [NumberId], [ListId], [ListSampleId], [ListPropId], [PropValue])
	SELECT
	[Id], [NumberId], [ListId], [ListSampleId], [ListPropId], [PropValue]
	FROM QNN_LIST_SAMPLE_PROP WHERE ListId=@ListId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_LIST_SAMPLE_PROP] OFF;

--QNN_DPLY
PRINT 'Copying from QNN_DPLY (ignoring RecurrenceOfDplyId)';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_DPLY] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_DPLY]
	([Id], [NumberId], [QnnId], [Type], [Target], [Status], [Name], [ListId], [DateStart], [DateEnd], [QnnDuration],
	[QnnDurationUnit], [CompleteAction], [CompleteURL], [NavigateBackYN], [NavigateCancelYN], [NavigateCancelURL],
	[MaxResponse], [DaysUpdate], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate],
	[StructDivisionId], [VisibleToRespondent], [RestrictIp], [IpCountry], [RestrictIpInclusive], [IpRange], [IsAnonymous], [IsMultipleResponse],
	[State], [StateName], [EnableWorkflow], [Remarks], [IsDataToData], [ValidationDplyId], [RecurrenceFrequency], [RecurrenceEndDate],
	[RecurrenceAdvanceDays], [RecurrenceOfDplyId], [RecurrenceNextDate], [RecurrenceJobId], [RecurrenceEnabled], [RecurrenceNotify],
	[RequireAccessCode], [IsExcelEnabled], [SurveyName], [Description], [IsRecurrencePrePopulateEnabled], [ApiIdentifier], [IsExposeListProperties],
	[IsDirectAccessEnabled], [IsDirectAccessForComplete], [Tags], [ScheduledExportEnabled], [ScheduledExportStartDate], [ScheduledExportEndDate],
	[ScheduledExportNextDate], [ScheduledExportFrequency], [ScheduledExportJobId], [IsIncludeUnansweredSection])
	SELECT 
	[Id], [NumberId], [QnnId], [Type], [Target], [Status], [Name], [ListId], [DateStart], [DateEnd], [QnnDuration],
	[QnnDurationUnit], [CompleteAction], [CompleteURL], [NavigateBackYN], [NavigateCancelYN], [NavigateCancelURL],
	[MaxResponse], [DaysUpdate], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate],
	[StructDivisionId], [VisibleToRespondent], [RestrictIp], [IpCountry], [RestrictIpInclusive], [IpRange], [IsAnonymous], [IsMultipleResponse],
	[State], [StateName], [EnableWorkflow], [Remarks], [IsDataToData], [ValidationDplyId], [RecurrenceFrequency], [RecurrenceEndDate],
	[RecurrenceAdvanceDays], NULL /*RecurrenceOfDplyId*/, [RecurrenceNextDate], [RecurrenceJobId], [RecurrenceEnabled], [RecurrenceNotify],
	[RequireAccessCode], [IsExcelEnabled], [SurveyName], [Description], [IsRecurrencePrePopulateEnabled], [ApiIdentifier], [IsExposeListProperties],
	[IsDirectAccessEnabled], [IsDirectAccessForComplete], [Tags], [ScheduledExportEnabled], [ScheduledExportStartDate], [ScheduledExportEndDate],
	[ScheduledExportNextDate], [ScheduledExportFrequency], [ScheduledExportJobId], [IsIncludeUnansweredSection]
	FROM QNN_DPLY WHERE Id=@DplyId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_DPLY] OFF;

--QNN_DPLY_SAMPLE_INFO
PRINT 'Copying from QNN_DPLY_SAMPLE_INFO (ignoring DelegationCode, DirectAccessCode, PrintAccessCode)';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_DPLY_SAMPLE_INFO] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_DPLY_SAMPLE_INFO]
	([Id], [NumberId], [DplyId], [ListSampleId], [Remarks], [StatusModifyBy], [StatusModifyOn], [RemarksModifyBy], [RemarksModifyOn],
	[DispatchInd], [ReturnInd], [ProcessValidInd], [ProcessEditInd], [Status], [CreatedBy], [CreatedDate], [DelegationCode],
	[DelegationAccessFailAttempt], [DirectAccessCode], [PrintAccessCode])
	SELECT
	[Id], [NumberId], [DplyId], [ListSampleId], [Remarks], [StatusModifyBy], [StatusModifyOn], [RemarksModifyBy], [RemarksModifyOn],
	[DispatchInd], [ReturnInd], [ProcessValidInd], [ProcessEditInd], [Status], [CreatedBy], [CreatedDate], NULL /*DelegationCode*/,
	[DelegationAccessFailAttempt], NULL /*DirectAccessCode*/, NULL /*PrintAccessCode*/
	FROM
	QNN_DPLY_SAMPLE_INFO WHERE DplyId=@DplyId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_DPLY_SAMPLE_INFO] OFF;

--QNN_RESP
PRINT 'Copying from QNN_RESP';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_RESP] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_RESP]
	([Id], [NumberId], [DplyId], [QnnId], [ListSampleId], [UserId], [Score], [TimeTook], [RespIp],
	[DateStart], [DateComplete], [UpdatedDate], [IsPrePopulated], [LastSavedPage], [AnonymousId], [IpAddress],
	[IsExcelResponse], [ExcelToken], [ExcelUploadDate], [IsExcelResponseDE], [InitialResponseAs], [InitialResponseBy], [InitialResponseVia])
	SELECT 
	[Id], [NumberId], [DplyId], [QnnId], [ListSampleId], [UserId], [Score], [TimeTook], [RespIp],
	[DateStart], [DateComplete], [UpdatedDate], [IsPrePopulated], [LastSavedPage], [AnonymousId], [IpAddress],
	[IsExcelResponse], [ExcelToken], [ExcelUploadDate], [IsExcelResponseDE], [InitialResponseAs], [InitialResponseBy], [InitialResponseVia]
	FROM QNN_RESP WHERE DplyId=@DplyId;
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_RESP] OFF;

--QNN_RESP_ANS
PRINT 'Copying from QNN_RESP_ANS';
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_RESP_ANS] ON;
INSERT INTO [survey_extraction].[dbo].[QNN_RESP_ANS]
	([Id], [NumberId], [RespId], [QnnFieldId], [AnsVal], [IsPrePopulated])
	SELECT
	[ra].[Id], [ra].[NumberId], [ra].[RespId], [ra].[QnnFieldId], [ra].[AnsVal], [ra].[IsPrePopulated]
	FROM QNN_RESP r LEFT JOIN QNN_RESP_ANS ra ON r.Id=ra.RespId WHERE r.DplyId=@DplyId; 
SET IDENTITY_INSERT [survey_extraction].[dbo].[QNN_RESP_ANS] OFF;

--dwUploadedFiles
PRINT 'Copying from dwUploadedFiles is not implemented';
--to implement we would need to identify which type 'input' fields are token references
--we examine all the response data for the survey and find which fields have some answers all of whose answers are
--null, empty, or match the pattern of what a token looks like, and then use those alias in some kind of constructed query.
--But I think is not very practical?

