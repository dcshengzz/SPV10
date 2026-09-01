




	CREATE PROCEDURE [dbo].[spSP_CopyStrataQuota]
		@ParentDplyId uniqueidentifier,
		@RecurrenceDplyId uniqueidentifier,		
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@AuditOn AS BIT = 0

	AS
	BEGIN

		SET XACT_ABORT, NOCOUNT ON;

		Create TABLE #Temp (Id uniqueidentifier);
		
		INSERT INTO QNN_DPLY_STRATA_QUOTA (
			[Id], 
			[DplyId], 
			[StrataValue],
			[MaxResponse],
			[Description]
		) 
		OUTPUT 
			INSERTED.[Id] INTO #Temp([Id])
		SELECT 
			NEWID() AS [Id], 
			@RecurrenceDplyId AS [DplyId], 
			[StrataValue],
			[MaxResponse],
			[Description]
		FROM 
			QNN_DPLY_STRATA_QUOTA 
		WHERE 
			[DplyId]=@ParentDplyId;


		
		IF @@RowCount>0 AND @AuditOn=1
		BEGIN
			INSERT INTO sy_AuditLog 
						(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
					SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Insert', 'QNN_DPLY_STRATA_QUOTA', null, null, null, 
					(select * from QNN_DPLY_STRATA_QUOTA where Id IN( SELECT Id FROM #Temp) FOR JSON AUTO), @StructDivisionId;
		END
	END