CREATE INDEX [IDX_Alias] ON [dbo].[QNN_LIST_PROP]
([Alias] ASC) 
GO

CREATE INDEX [IDX_NumberId] ON [dbo].[QNN_LIST_PROP]
([NumberId] ASC) 
GO

ALTER TABLE [dbo].[QNN_DPLY_SAMPLE_INFO] ALTER COLUMN [Remarks] nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS 
GO

ALTER PROCEDURE [dbo].[spSP_GetRespAnsWithDetails]
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

						set @query_allResp = 'SELECT @dplyName as [ Deployment], @qnnTitle as [ Questionnaire], @listName as [ List], [ UID], [ Email], [ Name], [ Username], ' + @props + ', 
						[ Date Start], [ Date Complete], [ Status], [ Remarks] from
						(
						select 
						sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
						r.DateComplete as [ Date Complete], status.Title as [ Status ], si.[Remarks] as [ Remarks], 
						r.id as RespId, r.NumberId, r.ListSampleId from qnn_resp r
						inner join qnn_list_sample ls on r.ListSampleId = ls.Id
						inner join qnn_sample sample on sample.Id = ls.SampleId
						inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
						left join dwSecurityUser u on u.Id = r.UserId
						left join qnn_status status on status.Id = si.Status
						
						where r.DplyId = @DplyId and r.QnnId=@QnnId
						) p1 

						inner join 

						(
						select a.ListSampleId, f.Alias as PropAlias, a.PropValue from qnn_list_sample_prop a
						left join qnn_list_prop f on f.Id = a.ListPropId
						inner join qnn_list_sample r on r.Id = a.ListSampleId
						inner join QNN_RESP qr on qr.ListSampleId = a.ListSampleId
						where r.ListId = @ListId and qr.DplyId = @DplyId
						) props
						pivot
						(
						max(PropValue) 
						for PropAlias in (' + @props + ')
												) p2 


						on p1.ListSampleId = p2.ListSampleId

						order by NumberId'

					END

				ELSE
					begin

						set @query_allResp = 'SELECT @dplyName as [ Deployment], @qnnTitle as [ Questionnaire], @listName as [ List], [ UID], [ Email], [ Name], [ Username], 
						[ Date Start], [ Date Complete], [ Status], [ Remarks] from
						(
						select 
						sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
						r.DateComplete as [ Date Complete], status.Title as [ Status], si.[Remarks] as [ Remarks], 
						r.NumberId, r.ListSampleId from qnn_resp r
						inner join qnn_list_sample ls on r.ListSampleId = ls.Id
						inner join qnn_sample sample on sample.Id = ls.SampleId
						inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
						left join dwSecurityUser u on u.Id = r.UserId
						left join qnn_status status on status.Id = si.Status
						
						where r.DplyId = @DplyId and r.QnnId=@QnnId
						) p1 

						order by NumberId'
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

	


					set @query_allResp = 'SELECT 
					' + @cols + ' from
					(
					select  					 
					a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
					inner join qnn_qnn_field f on f.Id = a.QnnFieldId
					inner join qnn_resp r on r.Id = a.RespId  and f.QnnId=r.QnnId
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


GO