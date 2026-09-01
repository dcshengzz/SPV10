
---- ADD IP ADDRESS COLUMN
ALTER TABLE QNN_RESP
ADD IpAddress nvarchar(2056);


---- ADD IP ADDRESS 
ALTER PROCEDURE [dbo].[spSP_UpdateResp]
		@Id uniqueidentifier,
		@UpdatedDate datetime,
		@DateStart datetime,		
		@DateComplete datetime = null,
		@RespIp NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0,
		@IsImputed AS BIT = 0,
		@LastSavedPage NVARCHAR(255) = null,
		@IpAddress NVARCHAR(2056) = null

	AS
	BEGIN
		SET NOCOUNT ON;

		DECLARE @OriginalValue  AS NVARCHAR(MAX)
		set @OriginalValue = (select * from QNN_RESP where Id=@Id FOR JSON AUTO)

		IF @UserId is null
			BEGIN
				Update QNN_RESP 
				set 
				DateStart = @DateStart,				
				UpdatedDate = @UpdatedDate,
				DateComplete = @DateComplete,
				RespIp = @RespIp,
				IsImputed = @IsImputed,
				LastSavedPage = @LastSavedPage,
				IpAddress = @IpAddress
				where Id = @Id
			END
		ELSE
			BEGIN
				Update QNN_RESP 
				set 
				DateStart = @DateStart,				
				UpdatedDate = @UpdatedDate,
				DateComplete = @DateComplete,
				RespIp = @RespIp,
				UserId = @UserId,
				IsImputed = @IsImputed,
				LastSavedPage = @LastSavedPage,
				IpAddress = @IpAddress
				where Id = @Id
			END


		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Update', 'QNN_RESP', @Id, null, @OriginalValue, 
						(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;

			END

	END
	
--ADD IP ADDRESS
ALTER PROCEDURE [dbo].[spSP_InsertResp]
		@Id uniqueidentifier,
		@QnnId uniqueidentifier,
		@ListSampleId uniqueidentifier,
		@DplyId uniqueidentifier,
		@UpdatedDate datetime,
		@DateStart datetime,
		@DateComplete datetime,
		@RespIp NVARCHAR(MAX),
		@UserId uniqueidentifier,
		@SampleId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 0,
		@IsImputed AS BIT = 0,
		@LastSavedPage NVARCHAR(255) = null,
		@IpAddress AS NVARCHAR(2056) = null


	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO QNN_RESP 
					(Id, QnnId, ListSampleId, DplyId, UserId, UpdatedDate, DateStart, DateComplete, RespIp, IsImputed, LastSavedPage, IpAddress)
				SELECT @Id, @QnnId, @ListSampleId, @DplyId, @UserId, @UpdatedDate, @DateStart, @DateComplete, @RespIp, @IsImputed, @LastSavedPage, @IpAddress;


		IF @AuditOn=1
			BEGIN
				INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, @SampleId, @EventBatch, @EventDate, 'Insert', 'QNN_RESP', null, null, null, 
						(select * from QNN_RESP where Id=@Id FOR JSON AUTO), @StructDivisionId;

			END

	END

--ADD IP ADDRESS ON COLUMN EXPORT
ALTER PROCEDURE [dbo].[spSP_GetRespAnsWithDetailsWithNoResponse]
	@DplyId uniqueidentifier,
	@QnnId uniqueidentifier,
	@GetProps BIT = 1,
	@Skip INT = 0,
	@Take	INT = 200,
	@ColCount INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @cols AS NVARCHAR(MAX),
	    @query_singleResp  AS NVARCHAR(MAX),
	    @query_allResp  AS NVARCHAR(MAX),
			@dplyName AS NVARCHAR(300),
			@qnnTitle AS NVARCHAR(300),
			@listName AS NVARCHAR(300),
			@listId AS uniqueidentifier,
			@props AS NVARCHAR(MAX)


		if(@GetProps=1)
			BEGIN

				set @dplyName = (select Name from qnn_dply where Id = @DplyId)
				set @qnnTitle = (select Title from qnn_qnn where Id = @QnnId)
				set @listName = (select l.Name from qnn_list l inner join qnn_dply d on d.ListId = l.Id where d.Id = @DplyId)
				set @listId = (select l.Id from qnn_list l inner join qnn_dply d on d.ListId = l.Id where d.Id = @DplyId)


				select @props = STUFF((SELECT ',' + UPPER(QUOTENAME(Alias)) 
														from qnn_list_prop where ListId = @ListId
														group by Alias, NumberId
														order by NumberId
										FOR XML PATH(''), TYPE
										).value('.', 'NVARCHAR(MAX)') 
								,1,1,'')

				if(@props is not NULL)
					Begin

						set @query_allResp = 'SELECT p1.ListSampleId, p1.RespId, @dplyName as [ Deployment], @qnnTitle as [ Questionnaire], @listName as [ List], [ UID], [ Email], [ Name], [ Username], ' + @props + ', 
						[ Date Start], [ Date Complete], [ IP Address], [ Status], [ Remarks] from
						(
						select 
						sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
						r.DateComplete as [ Date Complete], r.IpAddress as [ IP Address], status.Title as [ Status ], si.[Remarks] as [ Remarks], 
						r.id as RespId, r.NumberId, si.ListSampleId from qnn_dply_sample_info si
						inner join qnn_list_sample ls on si.ListSampleId = ls.Id
						inner join qnn_sample sample on sample.Id = ls.SampleId
						inner join qnn_dply d on si.DplyId = d.Id
						left join qnn_resp r with (NOLOCK) on r.DplyId = si.DplyId and r.QnnId = d.QnnId and r.ListSampleId = si.ListSampleId
						left join dwSecurityUser u on u.Id = r.UserId
						left join qnn_status status on status.Id = si.Status
						
						where d.Id = @DplyId and d.QnnId=@QnnId
						) p1 

						inner join 

						(
						select a.ListSampleId, f.Alias as PropAlias, a.PropValue from qnn_list_sample_prop a
						inner join qnn_list_prop f on f.Id = a.ListPropId
						inner join qnn_list_sample r on r.Id = a.ListSampleId
						inner join qnn_dply_sample_info si on si.ListSampleId = a.ListSampleId
						where f.ListId = @ListId and a.ListId = @ListId and si.DplyId = @DplyId
						) props
						pivot
						(
						max(PropValue) 
						for PropAlias in (' + @props + ')
												) p2 


						on p1.ListSampleId = p2.ListSampleId

						order by NumberId desc, p1.ListSampleId'

					END

				ELSE
					begin

						set @query_allResp = 'SELECT ListSampleId, RespId, @dplyName as [ Deployment], @qnnTitle as [ Questionnaire], @listName as [ List], [ UID], [ Email], [ Name], [ Username], 
						[ Date Start], [ Date Complete], [ IP Address], [ Status], [ Remarks] from
						(
						select 
						sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
						r.DateComplete as [ Date Complete], r.IpAddress as [ IP Address], status.Title as [ Status ], si.[Remarks] as [ Remarks], 
						r.id as RespId, r.NumberId, si.ListSampleId from qnn_dply_sample_info si
						inner join qnn_list_sample ls on si.ListSampleId = ls.Id
						inner join qnn_sample sample on sample.Id = ls.SampleId
						inner join qnn_dply d on si.DplyId = d.Id
						left join qnn_resp r with (NOLOCK) on r.DplyId = si.DplyId and r.QnnId = d.QnnId and r.ListSampleId = si.ListSampleId
						left join dwSecurityUser u on u.Id = r.UserId
						left join qnn_status status on status.Id = si.Status
						
						where d.Id = @DplyId and d.QnnId=@QnnId
						) p1 

						order by p1.NumberId desc, ListSampleId'
					END
					
				SELECT @ColCount = (select count(*) from qnn_qnn_field where QnnId = @QnnId
														and Name<>'swzPdfFormIdentifier' and Name<>'btnSubmit');
			END

		ELSE
			BEGIN
				select @cols = STUFF((SELECT ',' + QUOTENAME(Name) 
														from qnn_qnn_field where QnnId = @QnnId
														and Name<>'swzPdfFormIdentifier' and Name<>'btnSubmit' 
														group by Name, NumberId
														order by NumberId
														OFFSET (@Skip) ROWS FETCH NEXT (@Take) ROWS ONLY
										FOR XML PATH(''), TYPE
										).value('.', 'NVARCHAR(MAX)') 
								,1,1,'')

	


					set @query_allResp = 'SELECT ListSampleId, RespId, 
					' + @cols + ' from
					(
					select  					 
					si.ListSampleId, a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a with (NOLOCK) 
					inner join qnn_qnn_field f on f.Id = a.QnnFieldId
					inner join qnn_resp r with (NOLOCK) on r.Id = a.RespId  and f.QnnId=r.QnnId
					inner join qnn_list_sample ls on r.ListSampleId = ls.Id
					inner join qnn_sample sample on sample.Id = ls.SampleId
					inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
					left join dwSecurityUser u on u.Id = r.UserId
					left join qnn_status status on status.Id = si.Status			
					where r.DplyId = @DplyId and f.QnnId= @QnnId
					) d 
					pivot
					(
					max(AnsVal) 
					for SurveyFieldName in (' + @cols + ')
											) p order by NumberId'


					SELECT @ColCount = 0;			
				END





			if @props is null
				begin
					execute sp_executesql @query_allResp, N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300), @DplyId uniqueidentifier, @QnnId uniqueidentifier', @dplyName, @qnnTitle, @listName, @DplyId, @QnnId;			
				END
			ELSE
				begin
					execute sp_executesql @query_allResp, N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300), @ListId uniqueidentifier, @DplyId uniqueidentifier, @QnnId uniqueidentifier', @dplyName, @qnnTitle, @listName, @ListId, @DplyId, @QnnId;
				END


END