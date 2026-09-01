




	CREATE PROCEDURE [dbo].[spSP_DeleteSampleProp]
		@ListId uniqueidentifier,
		@ListSampleIds NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0

	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		--TODO - refactor as this procedure is very slow, it takes several minutes for 16k ids in ListSampleIds

		if(Exists(select top 1 1 from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ','))))

			BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO sy_AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_LIST_SAMPLE_PROP', null, null,(select * from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END			
				delete from QNN_LIST_SAMPLE_PROP where ListId = @ListId and ListSampleId IN( SELECT Item FROM dbo.splitIds(@ListSampleIds, ',')); 
			END

	END