

CREATE PROCEDURE [dbo].[spSP_GetRespAnsWithDetailsDataCollection]
	@DplyId uniqueidentifier,
	@QnnId uniqueidentifier,
	@GetProps BIT = 1,
	@Skip INT = 0,
	@Take INT = 200,
	@StatusList NVARCHAR(300) = '', --comma delimited list of Id in QNN_STATUS
	@ColCount INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@cols AS NVARCHAR(MAX),
	    @query_allResp AS NVARCHAR(MAX),
		@dplyName AS NVARCHAR(300),
		@qnnTitle AS NVARCHAR(300),
		@listName AS NVARCHAR(300),
		@listId AS uniqueidentifier,
		@props AS NVARCHAR(MAX)
	;

	IF NULLIF(@StatusList, '') IS NULL 
		SET @StatusList = NULL;

	if(@GetProps=1)
		BEGIN

			SET @dplyName = (SELECT Name FROM QNN_DPLY WHERE Id=@DplyId);
			SET @qnnTitle = (SELECT Title FROM QNN_QNN WHERE Id=@QnnId);
			SET @listName = (SELECT l.Name FROM QNN_LIST l INNER JOIN QNN_DPLY d ON d.ListId=l.Id WHERE d.Id=@DplyId);
			SET @listId   = (SELECT l.Id FROM QNN_LIST l INNER JOIN qnn_dply d ON d.ListId=l.Id WHERE d.Id=@DplyId);

			SELECT @props = STUFF(
				(SELECT 
					',' + UPPER(QUOTENAME(Alias)) 
				FROM 
					QNN_LIST_PROP 
				WHERE 
					ListId=@ListId
				GROUP BY 
					Alias, NumberId
				ORDER BY 
					NumberId
				FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

			set @query_allResp = '
			SELECT
				[UID], 
				[ToEmails],
				[CcEmails], 
				[AddressLine1],
				[AddressLine2],
				[AddressLine3],
				[Name], 
				[Username], '
				+ CASE WHEN @props IS NULL THEN '' ELSE @props+',' END + '
				[DateStart], 
				[DateComplete], 
				[IPAddress], 
				[Status], 
				[StatusCode],
				[StatusModifyOn], 
				[Remarks], 
				[RemarksModifyOn], 
				[InitialResponseAs],
				[InitialResponseBy],
				[InitialResponseVia],
				[UpdatedDate],
				[IsPrePopulated] 
			FROM
				(SELECT 
					sample.UID AS [UID], 
					address.ToEmails AS [ToEmails], 
					address.CcEmails AS [CcEmails], 
					address.AddressLine1 AS [AddressLine1],
					address.AddressLine2 AS [AddressLine2],
					address.AddressLine3 AS [AddressLine3],
					sample.Name AS [Name], 
					u.Name AS [Username], 
					r.DateStart AS [DateStart], 
					r.DateComplete AS [DateComplete], 
					r.IpAddress AS [IPAddress], 
					status.Title AS [Status], 
					status.Code AS [StatusCode],
					si.StatusModifyOn, 
					si.[Remarks] AS [Remarks], 
					si.RemarksModifyOn,
					r.id AS RespId, 
					r.NumberId, 
					r.ListSampleId, 
					r.InitialResponseAs AS [InitialResponseAs], 
					r.InitialResponseBy AS [InitialResponseBy],
					r.InitialResponseVia AS [InitialResponseVia],
					r.UpdatedDate AS [UpdatedDate], 
					r.IsPrePopulated AS [IsPrePopulated]
				FROM 
					QNN_RESP r
					INNER JOIN QNN_LIST_SAMPLE ls ON r.ListSampleId=ls.Id
					INNER JOIN QNN_LIST list ON list.Id=ls.ListId
					INNER JOIN QNN_SAMPLE sample ON sample.Id=ls.SampleId
					INNER JOIN QNN_DPLY_SAMPLE_INFO si ON si.ListSampleId=ls.Id AND si.DplyId=r.DplyId
					LEFT JOIN dwSecurityUser u ON u.Id=r.UserId
					LEFT JOIN QNN_STATUS status ON status.Id=si.Status		
					LEFT JOIN QNN_SAMPLE_ADDRESS address ON address.SampleId=sample.Id AND address.StructDivisionId=list.StructDivisionId
				WHERE 
					r.DplyId=@DplyId 
					AND r.QnnId=@QnnId
					AND (@StatusList IS NULL OR si.Status IN ( SELECT Item FROM dbo.splitIds(@StatusList, '','')))
				) p1'; 

			IF @props IS NOT NULL SET @query_allResp +='
				INNER JOIN 
				(SELECT 
					a.ListSampleId, 
					f.Alias as PropAlias, 
					a.PropValue 
				FROM 
					QNN_LIST_SAMPLE_PROP a
					LEFT JOIN QNN_LIST_PROP f ON f.Id=a.ListPropId
					INNER JOIN QNN_LIST_SAMPLE r ON r.Id=a.ListSampleId
					INNER JOIN QNN_RESP qr ON qr.ListSampleId=a.ListSampleId
				WHERE 
					r.ListId=@ListId
					AND qr.DplyId=@DplyId
				) props PIVOT (
					MAX(PropValue) 
					FOR PropAlias IN (' + @props + ')
				) p2 ON p1.ListSampleId=p2.ListSampleId';

			SET @query_allResp +='
			ORDER BY NumberId ASC'

			SELECT @ColCount = (
				SELECT COUNT(*) 
					FROM 
						QNN_QNN_FIELD 
					WHERE 
						QnnId=@QnnId
						AND Name<>'swzPdfFormIdentifier' 
						AND Name<>'btnSubmit'
			);
		END
	ELSE
		--getProps is 0
		BEGIN
			SELECT @cols = STUFF(
				(SELECT 
					',' + QUOTENAME(Name) 
				FROM 
					QNN_QNN_FIELD
				WHERE 
					QnnId=@QnnId
					AND Name<>'swzPdfFormIdentifier' 
					AND Name<>'btnSubmit' 
				GROUP BY 
					Name, 
					NumberId
				ORDER BY 
					NumberId
				OFFSET (@Skip) ROWS FETCH NEXT (@Take) ROWS ONLY
				FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,1,'')

			SET @query_allResp = '
				SELECT 
					' + @cols + '
				FROM (
					SELECT  					 
						a.RespId, 
						r.NumberId, 
						f.Name AS SurveyFieldName, 
						a.AnsVal 
					FROM 
						QNN_RESP_ANS a
						INNER JOIN QNN_QNN_FIELD f ON f.Id= a.QnnFieldId
						INNER JOIN QNN_RESP r ON r.Id=a.RespId AND f.QnnId=r.QnnId
						INNER JOIN QNN_LIST_SAMPLE ls ON ls.Id=r.ListSampleId
						INNER JOIN QNN_SAMPLE sample ON sample.Id=ls.SampleId
						INNER JOIN QNN_DPLY_SAMPLE_INFO si ON si.ListSampleId=ls.Id AND si.DplyId=r.DplyId
						LEFT JOIN dwSecurityUser u ON u.Id=r.UserId
						LEFT JOIN qnn_status status ON status.Id=si.Status			
					WHERE 
						r.DplyId=@DplyId 
						AND f.QnnId=@QnnId
						AND (@StatusList IS NULL OR si.Status IN ( SELECT Item FROM dbo.splitIds(@StatusList, '','')))
					) d PIVOT (
						MAX(AnsVal) 
						FOR SurveyFieldName IN (' + @cols + ')
					) p 
				ORDER BY 
					NumberId ASC';

			SELECT @ColCount = 0;
		END;

	if @props is null
		EXECUTE sp_executesql 
			@query_allResp, 
			N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300), @DplyId uniqueidentifier, @QnnId uniqueidentifier, @StatusList NVARCHAR(300)',
			@dplyName, 
			@qnnTitle, 
			@listName, 
			@DplyId, 
			@QnnId, 
			@StatusList;			
	ELSE
		EXECUTE sp_executesql 
			@query_allResp, 
			N'@dplyName NVARCHAR(300), @qnnTitle NVARCHAR(300), @listName NVARCHAR(300), @ListId uniqueidentifier, @DplyId uniqueidentifier, @QnnId uniqueidentifier,  @StatusList NVARCHAR(300)', 
			@dplyName, 
			@qnnTitle, 
			@listName, 
			@ListId, 
			@DplyId, 
			@QnnId, 
			@StatusList;

END
GO