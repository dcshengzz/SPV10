   
	ALTER PROCEDURE [dbo].[spSP_GetRespAnsWithDetails]
		@DplyId NVARCHAR(50),
		@QnnId NVARCHAR(50),
		@RespId NVARCHAR(50)
	AS
	BEGIN

		DECLARE @cols AS NVARCHAR(MAX),
		    @query_singleResp  AS NVARCHAR(MAX),
		    @query_allResp  AS NVARCHAR(MAX),
				@dplyName AS NVARCHAR(300),
				@qnnTitle AS NVARCHAR(300),
				@listName AS NVARCHAR(300)
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

		set @query_singleResp = 'SELECT @dplyName as [Deployment (SYS)], @qnnTitle as [Questionnaire (SYS)], @listName as [List (SYS)], [UID (SYS)], [Email (SYS)], [Name (SYS)], [Username (SYS)], 
		[Date Start (SYS)], [Date Complete (SYS)], [Status (SYS)], [Remarks (SYS)], 
		' + @cols + ' from
		(
		select  
		sample.UID as [UID (SYS)], sample.Email as [Email (SYS)], sample.Name as [Name (SYS)], u.Name as [Username (SYS)], r.DateStart as [Date Start (SYS)], 
		r.DateComplete as [Date Complete (SYS)], status.Title as [Status (SYS)], si.[Remarks] as [Remarks (SYS)], 
		a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
		inner join qnn_qnn_field f on f.Id = a.QnnFieldId
		inner join qnn_resp r on r.Id = a.RespId
		inner join qnn_list_sample ls on r.ListSampleId = ls.Id
		inner join qnn_sample sample on sample.Id = ls.SampleId
		inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
		inner join dwSecurityUser u on u.Id = r.UserId
		inner join qnn_status status on status.Id = si.Status
		where r.Id = '''+ @RespId+ '''' + '
		) d 
		pivot
		(
		max(AnsVal) 
		for SurveyFieldName in (' + @cols + ')
		            ) p order by NumberId'

		set @query_allResp = 'SELECT @dplyName as [Deployment (SYS)], @qnnTitle as [Questionnaire (SYS)], @listName as [List (SYS)], [UID (SYS)], [Email (SYS)], [Name (SYS)], [Username (SYS)], 
		[Date Start (SYS)], [Date Complete (SYS)], [Status (SYS)], [Remarks (SYS)], 
		' + @cols + ' from
		(
		select  
		sample.UID as [UID (SYS)], sample.Email as [Email (SYS)], sample.Name as [Name (SYS)], u.Name as [Username (SYS)], r.DateStart as [Date Start (SYS)], 
		r.DateComplete as [Date Complete (SYS)], status.Title as [Status (SYS)], si.[Remarks] as [Remarks (SYS)], 
		a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
		inner join qnn_qnn_field f on f.Id = a.QnnFieldId
		inner join qnn_resp r on r.Id = a.RespId
		inner join qnn_list_sample ls on r.ListSampleId = ls.Id
		inner join qnn_sample sample on sample.Id = ls.SampleId
		inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
		left join dwSecurityUser u on u.Id = r.UserId
		inner join qnn_status status on status.Id = si.Status
		
		where r.DplyId = '''+ @DplyId+ '''' + '
		) d 
		pivot
		(
		max(AnsVal) 
		for SurveyFieldName in (' + @cols + ')
		            ) p order by NumberId'


		if @RespId is null
			begin
				execute sp_executesql @query_allResp, N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300)', @dplyName, @qnnTitle, @listName;
			END
		ELSE
			begin
				execute sp_executesql @query_singleResp, N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300)', @dplyName, @qnnTitle, @listName;
			END
	END


