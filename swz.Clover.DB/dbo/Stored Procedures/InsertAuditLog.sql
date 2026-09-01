





CREATE PROCEDURE [dbo].[InsertAuditLog]
		@UserId UNIQUEIDENTIFIER, --may be null
		@SampleId UNIQUEIDENTIFIER, --may be null
		@EventBatch UNIQUEIDENTIFIER,
		@EventDate DATETIME,
		@EventType NVARCHAR(20),
		@TableName NVARCHAR(100), --may be null
		@RecordId UNIQUEIDENTIFIER, --may be null
		@ColumnName NVARCHAR(100), --may be null
		@OriginalValue NVARCHAR(MAX), --may be null
		@NewValue NVARCHAR(MAX), --may be null
		@StructDivisionId UNIQUEIDENTIFIER, --may be null
		@Id UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000' OUTPUT
	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;
		SET @Id = NEWID();

		--Note that the insertion is using the sy_AuditLog synonym instead of writing directly to the table.
		--Using a synonym gives us a redirection mechanism, by changing where the synonym points we can externalise the table if desired.
		INSERT INTO [sy_AuditLog] 
			([Id], [UserId], [SampleId], [EventBatch], [EventDate], [EventType], [TableName], [RecordId], [ColumnName], [OriginalValue], [NewValue], [StructDivisionId])
			VALUES
			(@Id, @UserId, @SampleId, @EventBatch, @EventDate, @EventType, @TableName, @RecordId, @ColumnName, @OriginalValue, @NewValue, @StructDivisionId);
	END