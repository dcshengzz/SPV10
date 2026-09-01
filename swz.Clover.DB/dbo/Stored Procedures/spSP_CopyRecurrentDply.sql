







CREATE PROCEDURE [dbo].[spSP_CopyRecurrentDply]
		@Id uniqueidentifier,
		@UserId uniqueidentifier,
		@DateStart datetime,
		@DateEnd datetime,
		@StartDeploymentImmediately bit,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0,
		@RecurrenceDplyId uniqueidentifier output

	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		DECLARE @RecurrenceId uniqueidentifier;
		SET @RecurrenceDplyId = NEWID();
	
		INSERT INTO QNN_DPLY ( 
			[Id], [DateStart], [DateEnd], 
			[VisibleToRespondent], [CreatedBy], [CreatedDate],
			[RecurrenceOfDplyId],
			[QnnId], [Type], [StructDivisionId],
			[Target], [Status], [Name], [ListId],
			[CompleteAction], [NavigateBackYN],	[NavigateCancelYN],
			[NavigateCancelURL], [MaxResponse], [DaysUpdate],
			[Tags], [IpCountry], [RestrictIp],
			[IpRange], [RestrictIpInclusive], [IsAnonymous], 
			[IsMultipleResponse], [SurveyName], [ApiIdentifier],
			[Description],[State], [RequireAccessCode], [IsExcelEnabled],
			[StrataSource]
		) SELECT 
			@RecurrenceDplyId, @DateStart AS [DateStart], @DateEnd AS [DateEnd],
			@StartDeploymentImmediately AS VisibleToRespondent, @UserId AS CreatedBy, @EventDate AS CreatedDate,
			@Id AS [RecurrenceOfDplyId],
			[QnnId], [Type], @StructDivisionId,
			[Target], [Status], CONCAT([Name], ' ', convert(varchar(10),@DateStart,23)), [ListId],
			[CompleteAction], [NavigateBackYN],	[NavigateCancelYN],
			[NavigateCancelURL], [MaxResponse], [DaysUpdate],
			[Tags], [IpCountry], [RestrictIp],
			[IpRange], [RestrictIpInclusive], [IsAnonymous], 
			[IsMultipleResponse], CONCAT([SurveyName], ' ', convert(varchar(10),@DateStart,23)), [ApiIdentifier],
			[Description], [State], [RequireAccessCode], [IsExcelEnabled],
			[StrataSource]
		FROM QNN_DPLY WHERE Id=@Id AND IsDeleted=0;

		IF @AuditOn=1
		BEGIN
			INSERT INTO sy_AuditLog 
				(Id, UserId, SampleId, 
				 EventBatch, EventDate, EventType,
				 TableName, RecordId, ColumnName,
				 OriginalValue, NewValue, StructDivisionId)
			SELECT 
				NEWID(), @UserId, NULL,
				@EventBatch, @EventDate, 'Insert',
				'QNN_DPLY', @Id, null,
				NULL, (select * from QNN_DPLY where Id=@RecurrenceId FOR JSON AUTO), @StructDivisionId;

		END

	END