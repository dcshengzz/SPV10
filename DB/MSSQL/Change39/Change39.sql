---------------------------
-------------------------------
--Add list properties to export data; remove SYS from the column name
   
	ALTER PROCEDURE [dbo].[spSP_GetRespAnsWithDetails]
		@DplyId uniqueidentifier,
		@QnnId uniqueidentifier,
		@RespId uniqueidentifier
	AS
	BEGIN

		DECLARE @cols AS NVARCHAR(MAX),
		    @query_singleResp  AS NVARCHAR(MAX),
		    @query_allResp  AS NVARCHAR(MAX),
				@dplyName AS NVARCHAR(300),
				@qnnTitle AS NVARCHAR(300),
				@listName AS NVARCHAR(300),
				@listId AS uniqueidentifier,
				@props AS NVARCHAR(MAX)

		select @cols = STUFF((SELECT ',' + QUOTENAME(Name) 
		                    from qnn_qnn_field where QnnId = @QnnId
												and Name<>'swzPdfFormIdentifier' and Name<>'btnSubmit' 
		                    group by Name, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'')

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

				set @query_singleResp = 'SELECT @dplyName as [Deployment], @qnnTitle as [Questionnaire], @listName as [ List], [ UID], [ Email], [ Name], [ Username], ' + @props + ', 
				[ Date Start], [ Date Complete], [ Status], [ Remarks], 
				' + @cols + ' from
				(
				select  
				sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
				r.DateComplete as [ Date Complete], status.Title as [ Status], si.[Remarks] as [ Remarks], 
				a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
				inner join qnn_qnn_field f on f.Id = a.QnnFieldId
				inner join qnn_resp r on r.Id = a.RespId and f.QnnId=r.QnnId
				inner join qnn_list_sample ls on r.ListSampleId = ls.Id
				inner join qnn_sample sample on sample.Id = ls.SampleId
				inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
				inner join dwSecurityUser u on u.Id = r.UserId
				inner join qnn_status status on status.Id = si.Status
				where r.Id = @RespId and f.QnnId= @QnnId' + '
				) ans 
				pivot
				(
				max(AnsVal) 
				for SurveyFieldName in (' + @cols + ')
										) p1 

				left join 

				(
				select a.ListSampleId, f.Alias as PropAlias, a.PropValue from qnn_list_sample_prop a
				left join qnn_list_prop f on f.Id = a.ListPropId
				inner join qnn_list_sample r on r.Id = a.ListSampleId
				inner join qnn_sample s on s.Id = r.SampleId
				left join qnn_sample s2 on s2.Id = r.SamplePeerId
				where r.ListId = @ListId 
				) props 
				pivot
				(
				max(PropValue) 
				for PropAlias in (' + @props + ')
										) p2 

				on p1.ListSampleId = p2.ListSampleId


				order by NumberId'

				set @query_allResp = 'SELECT @dplyName as [ Deployment], @qnnTitle as [ Questionnaire], @listName as [ List], [ UID], [ Email], [ Name], [ Username], ' + @props + ', 
				[ Date Start], [ Date Complete], [ Status], [ Remarks], 
				' + @cols + ' from
				(
				select  
				sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
				r.DateComplete as [ Date Complete], status.Title as [ Status ], si.[Remarks] as [ Remarks], 
				a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal,r.ListSampleId from qnn_resp_ans a
				inner join qnn_qnn_field f on f.Id = a.QnnFieldId
				inner join qnn_resp r on r.Id = a.RespId  and f.QnnId=r.QnnId
				inner join qnn_list_sample ls on r.ListSampleId = ls.Id
				inner join qnn_sample sample on sample.Id = ls.SampleId
				inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
				left join dwSecurityUser u on u.Id = r.UserId
				inner join qnn_status status on status.Id = si.Status
				
				where r.DplyId = @DplyId and f.QnnId=@QnnId
				) ans 
				pivot
				(
				max(AnsVal) 
				for SurveyFieldName in (' + @cols + ')
										) p1


				left join 

				(
				select a.ListSampleId, f.Alias as PropAlias, a.PropValue from qnn_list_sample_prop a
				left join qnn_list_prop f on f.Id = a.ListPropId
				inner join qnn_list_sample r on r.Id = a.ListSampleId
				inner join qnn_sample s on s.Id = r.SampleId
				left join qnn_sample s2 on s2.Id = r.SamplePeerId
				where r.ListId = @ListId 
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
				set @query_singleResp = 'SELECT @dplyName as [ Deployment], @qnnTitle as [ Questionnaire], @listName as [ List], [ UID], [ Email], [ Name], [ Username], 
				[ Date Start], [ Date Complete], [ Status], [ Remarks], 
				' + @cols + ' from
				(
				select  
				sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
				r.DateComplete as [ Date Complete], status.Title as [ Status], si.[Remarks] as [ Remarks], 
				a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
				inner join qnn_qnn_field f on f.Id = a.QnnFieldId
				inner join qnn_resp r on r.Id = a.RespId and f.QnnId=r.QnnId
				inner join qnn_list_sample ls on r.ListSampleId = ls.Id
				inner join qnn_sample sample on sample.Id = ls.SampleId
				inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
				inner join dwSecurityUser u on u.Id = r.UserId
				inner join qnn_status status on status.Id = si.Status
				where r.Id = @RespId and f.QnnId=@QnnId
				) d 
				pivot
				(
				max(AnsVal) 
				for SurveyFieldName in (' + @cols + ')
										) p order by NumberId'

				set @query_allResp = 'SELECT @dplyName as [ Deployment], @qnnTitle as [ Questionnaire], @listName as [ List], [ UID], [ Email], [ Name], [ Username], 
				[ Date Start], [ Date Complete], [ Status], [ Remarks], 
				' + @cols + ' from
				(
				select  
				sample.UID as [ UID], sample.Email as [ Email], sample.Name as [ Name], u.Name as [ Username], r.DateStart as [ Date Start], 
				r.DateComplete as [ Date Complete], status.Title as [ Status], si.[Remarks] as [ Remarks], 
				a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
				inner join qnn_qnn_field f on f.Id = a.QnnFieldId
				inner join qnn_resp r on r.Id = a.RespId  and f.QnnId=r.QnnId
				inner join qnn_list_sample ls on r.ListSampleId = ls.Id
				inner join qnn_sample sample on sample.Id = ls.SampleId
				inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
				left join dwSecurityUser u on u.Id = r.UserId
				inner join qnn_status status on status.Id = si.Status
				
				where r.DplyId = @DplyId and f.QnnId= @QnnId
				) d 
				pivot
				(
				max(AnsVal) 
				for SurveyFieldName in (' + @cols + ')
										) p order by NumberId'
			END

		if @RespId is null
			begin			
				if @props is null
					begin
						execute sp_executesql @query_allResp, N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300), @DplyId uniqueidentifier, @QnnId uniqueidentifier', @dplyName, @qnnTitle, @listName, @DplyId, @QnnId;			
					END
				ELSE
					begin
						execute sp_executesql @query_allResp, N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300), @ListId uniqueidentifier, @DplyId uniqueidentifier, @QnnId uniqueidentifier', @dplyName, @qnnTitle, @listName, @ListId, @DplyId, @QnnId;
					END
			END

		ELSE

			begin			
				if @props is null
					begin		
						execute sp_executesql @query_singleResp, N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300), @RespId uniqueidentifier, @QnnId uniqueidentifier', @dplyName, @qnnTitle, @listName, @RespId, @QnnId;

					END
				ELSE
					begin
						execute sp_executesql @query_singleResp, N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300), @ListId uniqueidentifier, @RespId uniqueidentifier, @QnnId uniqueidentifier', @dplyName, @qnnTitle, @listName, @ListId, @RespId, @QnnId;
					END



			END
	END
GO



