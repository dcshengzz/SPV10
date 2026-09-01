






	CREATE PROCEDURE [dbo].[spSP_AddDplySampleInfoByListId]
		@DplyId uniqueidentifier,
		@ListId uniqueidentifier,
		@Status uniqueidentifier = 'A3D01086-40FC-4A7A-BF0C-DE17BDD205FA', --Pending
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@DelegationCodes as nvarchar(max) = '',
		@AuditOn AS BIT = 0

	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

	    --Take the '|' delimited list of encrypted delegation codes and build a temp table in which each sample we will be creating
		--sample info for is assigned a code - we dont really care which code (X) - so @DelegationCodes should contain this number of 
		--codes or more, but not less - because if there aren't enough, some will get null (so its possible to call with an empty list 
		--or insufficient values but the delegation feature won't be useable by all the samples because they will have null DelegationCode).
		--(X) note: for a more sensitive use-case like Sample Passwords there might be security implications to the order 
		--          but for delegation codes I don't think it is important
		CREATE TABLE #CodesTable (SampleId uniqueidentifier, DelegationCode nvarchar(50) );
		INSERT INTO #CodesTable (SampleId, DelegationCode)
		SELECT l.SampleId AS SampleId, c.value AS DelegationCode FROM 
			(SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT 0)) AS row_num FROM STRING_SPLIT(@DelegationCodes,'|') WHERE RTRIM(value) <> '' ) AS c
			RIGHT JOIN
			(SELECT SampleId, ROW_NUMBER() OVER (ORDER BY Id) AS row_num FROM QNN_LIST_SAMPLE ls WHERE ListId=@ListId 
			and not EXISTS (select top 1 1 from QNN_DPLY_SAMPLE_INFO si where si.DplyId=@DplyId and si.ListSampleId = ls.Id)) AS l
			ON c.row_num = l.row_num;

		Create TABLE #DLSITable (Id uniqueidentifier)
		if(Exists(select top 1 1 from QNN_LIST_SAMPLE ls
		 WHERE ListId = @ListId 
		and not EXISTS (select top 1 1 from QNN_DPLY_SAMPLE_INFO si where si.DplyId=@DplyId and si.ListSampleId = ls.Id)
	))
			BEGIN		

				INSERT INTO QNN_DPLY_SAMPLE_INFO 
					(Id, DplyId, ListSampleId, Status, CreatedDate, DelegationCode)
				OUTPUT INSERTED.ID INTO #DLSITable(Id)
				SELECT 
					NEWID(), 
					@DplyId, 
					Id, 
					@Status, 
					GETDATE(), 
					ct.DelegationCode
					FROM QNN_LIST_SAMPLE ls 
					LEFT JOIN #CodesTable ct ON ls.SampleId=ct.SampleId
				    WHERE ListId = @ListId 
				and not EXISTS (select top 1 1 from QNN_DPLY_SAMPLE_INFO si where si.DplyId=@DplyId and si.ListSampleId = ls.Id)

				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Insert', 'QNN_DPLY_SAMPLE_INFO', null, null, null, 
								(select * from QNN_DPLY_SAMPLE_INFO where Id IN( SELECT Id FROM #DLSITable) FOR JSON AUTO), @StructDivisionId;

					END


			END


	END