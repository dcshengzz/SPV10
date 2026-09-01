ALTER TABLE [dbo].[QNN_RESP] ALTER COLUMN [UpdatedDate] datetime NULL 
GO

   
ALTER PROCEDURE [dbo].[spSP_GetRespAns]
	@DplyId NVARCHAR(50),
	@QnnId NVARCHAR(50),
	@RespId NVARCHAR(50)
AS
BEGIN

	DECLARE @cols AS NVARCHAR(MAX),
	    @query_singleResp  AS NVARCHAR(MAX),
	    @query_allResp  AS NVARCHAR(MAX)

	select @cols = STUFF((SELECT ',' + QUOTENAME(Name) 
	                    from qnn_qnn_field where QnnId = @QnnId
											and Name<>'swzPdfFormIdentifier' and Name<>'btnSubmit' 
	                    group by Name, NumberId
	                    order by NumberId
	            FOR XML PATH(''), TYPE
	            ).value('.', 'NVARCHAR(MAX)') 
	        ,1,1,'')


	set @query_singleResp = 'SELECT RespId, NumberId,' + @cols + ' from
	(
	select a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
	inner join qnn_qnn_field f on f.Id = a.QnnFieldId
	inner join qnn_resp r on r.Id = a.RespId
	where r.Id = '''+ @RespId+ '''' + '
	) d 
	pivot
	(
	max(AnsVal) 
	for SurveyFieldName in (' + @cols + ')
	            ) p order by NumberId'

	set @query_allResp = 'SELECT RespId, NumberId, ' + @cols + ' from
	(
	select a.RespId, r.NumberId, f.Name as SurveyFieldName, a.AnsVal from qnn_resp_ans a
	inner join qnn_qnn_field f on f.Id = a.QnnFieldId
	inner join qnn_resp r on r.Id = a.RespId
	where r.DplyId = '''+ @DplyId+ '''' + '
	) d 
	pivot
	(
	max(AnsVal) 
	for SurveyFieldName in (' + @cols + ')
	            ) p order by NumberId'


	if @RespId is null
		begin
			execute sp_executesql @query_allResp;
		END
	ELSE
		begin
			execute sp_executesql @query_singleResp;
		END
END

GO

CREATE PROCEDURE [dbo].[spSP_GetRespAnsWithDetails]
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

		set @query_singleResp = 'SELECT @dplyName as Deployment, @qnnTitle as Questionnaire, @listName as List, UID, Email, Name, Username, 
		[Date Start], [Date Complete], [Status], [Remarks], 
		' + @cols + ' from
		(
		select  
		sample.UID, sample.Email, sample.Name, u.Name as Username, r.DateStart as [Date Start], 
		r.DateComplete as [Date Complete], status.Title as [Status], si.[Remarks], 
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

		set @query_allResp = 'SELECT @dplyName as Deployment, @qnnTitle as Questionnaire, @listName as List, UID, Email, Name, Username, 
		[Date Start], [Date Complete], [Status], [Remarks], 
		' + @cols + ' from
		(
		select 
		sample.UID, sample.Email, sample.Name, u.Name as Username, r.DateStart as [Date Start], 
		r.DateComplete as [Date Complete], status.Title as [Status], si.[Remarks], 
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



GO


CREATE VIEW [dbo].[vSP_DeploymentWithRespCount] AS 
select d.Name, d.Id, d.QnnId, qnn.Title as QnnId_Title, qnn.Type as QnnId_Type, list.Name as ListId_Name, c.Name as CategoryId_Name, 
d.CreatedDate, ISNULL(drc.RespCount, 0 ) as RespCount, sc.SampleCount from QNN_DPLY d
left join vSP_DeploymentRespCount drc on d.Id = drc.DplyId
inner join QNN_QNN qnn on d.QnnId = qnn.Id
inner join QNN_LIST list on d.ListId = list.Id
inner join vSP_DeploymentSampleCount sc on d.Id = sc.DplyId 
left join QNN_CATEGORY c on d.CategoryId = c.Id

GO