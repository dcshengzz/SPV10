






CREATE PROCEDURE [dbo].[spSP_SetListSamplesActiveYN]
		@ListId UNIQUEIDENTIFIER,
		@ListSampleIds NVARCHAR(MAX),
		@ActiveYN BIT,
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0,
		@Updated INT OUT
	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;
		
		--Split the list of ids, and also make sure they identify existing samples in the specified list
		--we will also grab a copy of their current value for ActiveYN now as we'll want that for the audit log
		--note that we ignore any specified samples that are missing, not in the specified list, 
		--or that already have the specified ActiveYN value
		DECLARE @Samples AS TABLE( Id NVARCHAR(MAX), ActiveYN BIT);
		INSERT INTO @Samples (Id, ActiveYN) 
			SELECT 
				ls.Id,
				ls.ActiveYN
			FROM 
				dbo.splitIds(@ListSampleIds, ',') split
				LEFT JOIN QNN_LIST_SAMPLE ls ON ls.Id=split.Item
			WHERE 
				ls.ListId=@ListId 
				AND ActiveYN<>@ActiveYN;
   
		IF @AuditOn=1
			BEGIN
				INSERT INTO 
					sy_AuditLog	(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, 
					OriginalValue, 
					NewValue, 
					StructDivisionId)
				SELECT 
					NEWID(), @UserId, NULL, @EventBatch, @EventDate, 'Update', 'QNN_LIST_SAMPLE', NULL, 'ActiveYN',
					(SELECT Id,ActiveYN FROM @Samples FOR JSON AUTO), 
					(SELECT Id,@ActiveYN AS ActiveYN FROM @Samples FOR JSON AUTO), 
					@StructDivisionId;
			END

		UPDATE QNN_LIST_SAMPLE
			SET 
				ActiveYN = @ActiveYN
			FROM 
				QNN_LIST_SAMPLE ls
				INNER JOIN @Samples AS samples ON ls.Id= samples.Id;

		--We return the number of rows that were actually updated as an out parameter
		SELECT	@Updated = @@ROWCOUNT;
	END