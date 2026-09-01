

CREATE PROCEDURE [dbo].[spSP_GetListSampleProfile]
	@ListId uniqueidentifier, --required
	@IncludePassword BIT = 1, --optional: include respondent password column
	@ListSampleIds NVARCHAR(MAX) = null --optional: filter the list to only these samples
AS
BEGIN
	DECLARE 
		@cols AS NVARCHAR(MAX),
		@query AS NVARCHAR(MAX);

	--Get the names of the list sample properties
	select @cols = STUFF((SELECT ',' + UPPER(QUOTENAME(Alias)) 
		                from qnn_list_prop where ListId = @ListId
		                group by Alias, NumberId
		                order by NumberId
		        FOR XML PATH(''), TYPE
		        ).value('.', 'NVARCHAR(MAX)') 
		    ,1,1,'')

	SET @query = '
		SELECT
			[UID],
			[NAME],
			[EMAIL],
			[CC_EMAILS],			
			[ACTIVE],
			[PASSWORD_RESET],
			[PEER_UID],
			[ADDRESSLINE1],
			[ADDRESSLINE2],
			[ADDRESSLINE3]';
	IF(@IncludePassword = 1)
		SET @query = @query +',
			[PASSWORD]';
	IF(@cols IS NOT NULL)
		SET @query = @query +',
			' + @cols;
	SET @query = @query + '
		FROM (
			SELECT 
				ls.Id AS [ListSampleId],
				s.UID AS [UID],
				sp.UID AS [PEER_UID],
				s.Pwd AS [PASSWORD],
				s.Name AS [NAME],
				COALESCE(sa.ToEmails,'''') AS [EMAIL],
				COALESCE(sa.CcEmails,'''') AS [CC_EMAILS],
				s.ActiveYN AS [ACTIVE],
				s.PwdResetYN AS [PASSWORD_RESET],
				COALESCE(sa.AddressLine1,'''') AS [ADDRESSLINE1],
				COALESCE(sa.AddressLine2,'''') AS [ADDRESSLINE2],
				COALESCE(sa.AddressLine3,'''') AS [ADDRESSLINE3]';
	IF(@cols IS NOT NULL)
		SET @query=@query +',
				lp.Alias AS [PropAlias],
				lsp.PropValue AS [PropValue]';
	SET @query = @query +'
			FROM 
				QNN_LIST_SAMPLE ls
				LEFT JOIN QNN_LIST_SAMPLE_PROP lsp ON ls.Id=lsp.ListSampleId
				LEFT JOIN QNN_LIST_PROP lp ON lp.Id=lsp.ListPropId
				LEFT JOIN QNN_SAMPLE s ON s.Id=ls.SampleId
				LEFT JOIN QNN_LIST l ON l.Id=@ListId
				LEFT JOIN QNN_SAMPLE_ADDRESS sa ON sa.SampleId=s.Id AND sa.StructDivisionId=l.StructDivisionId
				LEFT JOIN QNN_SAMPLE sp ON sp.Id=ls.SamplePeerId
			WHERE
				ls.ListId=@ListId';
	IF(@ListSampleIds IS NOT NULL)
		SET @query = @query +'
				AND ls.Id IN (SELECT Item FROM dbo.splitIds(@ListSampleIds, '',''))';
	SET @query = @query +'
			) d';
	IF(@cols IS NOT NULL)
		SET @query = @query + '
			PIVOT (
				MAX(PropValue) 
				FOR PropAlias IN (' + @cols + ')
			) p';
	SET @query = @query +'
		ORDER BY
			UID ASC;';

	IF(@ListSampleIds IS NULL)
		EXECUTE sp_executesql 
			@query, 
			N'@ListId uniqueidentifier', 
			@ListId;
	ELSE
		EXECUTE sp_executesql 
			@query, 
			N'@ListId uniqueidentifier, @ListSampleIds NVARCHAR(MAX)', 
			@ListId,
			@ListSampleIds;

END

