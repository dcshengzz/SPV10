CREATE PROCEDURE [dbo].[spSP_GetRecurrencePreviousRespAns] 
		@DplyId uniqueidentifier,
		@QnnId uniqueidentifier,
		@RespId uniqueidentifier
	AS
	BEGIN
		DECLARE @cols AS NVARCHAR(MAX),
		    @query_singleResp  AS NVARCHAR(MAX)
		SELECT @cols = STUFF((SELECT ',' + QUOTENAME(Name) 
		                    FROM qnn_qnn_field WHERE QnnId = @QnnId
												and Name<>'swzPdfFormIdentifier' and Name<>'btnSubmit' 
		                    GROUP BY Name, NumberId
		                    order by NumberId
		            FOR XML PATH(''), TYPE
		            ).value('.', 'NVARCHAR(MAX)') 
		        ,1,1,'')


		SET @query_singleResp = 'SELECT ' + @cols + ' from
		(
		select a.RespId, r.NumberId, f.Name as SurveyFieldName, IIF(d.Id is not null, a.AnsVal, '''') as AnsVal from qnn_resp_ans a
		inner join qnn_qnn_field f on f.Id = a.QnnFieldId 
		inner join qnn_resp r on r.Id = a.RespId and f.QnnId=r.QnnId
		left join QNN_DPLY_RECURRENCE_PREPOPULATE_FIELD d on d.QnnFieldId = a.QnnFieldId
		where r.Id = @RespId and f.QnnId= @QnnId' + '
		) d 
		pivot
		(
		max(AnsVal) 
		for SurveyFieldName in (' + @cols + ')
		            ) p order by NumberId'

		BEGIN
			EXECUTE sp_executesql @query_singleResp, N'@RespId uniqueidentifier, @QnnId uniqueidentifier', @RespId, @QnnId;
		END
	END