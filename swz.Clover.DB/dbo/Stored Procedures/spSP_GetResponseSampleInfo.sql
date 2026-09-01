


CREATE PROCEDURE [dbo].[spSP_GetResponseSampleInfo] 
        @DplyId uniqueidentifier
    AS
BEGIN

	--Retrieve list's StructDivisionId upfront (for joining correct QNN_SAMPLE_ADDRESS row later) 
	DECLARE @ListStructDivisionId UNIQUEIDENTIFIER;
	SELECT @ListStructDivisionId=l.StructDivisionId 
		FROM QNN_DPLY d INNER JOIN QNN_LIST l ON l.Id=d.ListId
		WHERE d.Id=@DplyId;
		
	--Get responses metainfo for all samples in the specified deployment
	SELECT 
		dsi.[Id] AS [dlsi],
		dsi.[ListSampleId],
		s.[UID],
		s.[Name] AS [SampleName], 
		a.[ToEmails], 
		a.[CcEmails], 
		a.[AddressLine1],
		a.[AddressLine2],
		a.[AddressLine3],
		dsi.[Status] AS [Status],
		dsi.[Remarks],
		CASE WHEN r.[Id] IS NOT NULL THEN 1 ELSE 0 END AS [HasResponse],
		r.[Id] AS [RespId],
		CASE WHEN r.[IsPrePopulated] IS NOT NULL THEN r.[IsPrePopulated] ELSE 0 END AS [IsPrePopulated],
		lru.[Name] AS [UserName], --last intranet data editor to modify it (this column pre-dates LastResponder)
		r.[DateStart], 
		r.[DateComplete],	
		r.[UpdatedDate],
		r.[IpAddress],
		r.[InitialResponseAs], 
		r.[InitialResponseBy],
		r.[InitialResponseVia],
		CASE 
			WHEN r.[InitialResponseBy] IS NULL THEN NULL
			WHEN r.[InitialResponseBy]='Sample' THEN [s].[UID]
			WHEN r.[InitialResponseBy]='Editor' AND r.[InitialResponseUserId] IS NOT NULL THEN iru.[Name]
			ELSE 'Unknown' END 
			AS [InitialResponder],
		r.[CompletedResponseAs],
		r.[CompletedResponseBy],
		r.[CompletedResponseVia],		
		CASE 
			WHEN r.[CompletedResponseBy] IS NULL AND r.[DateComplete] IS NULL THEN NULL
			WHEN r.[CompletedResponseBy] IS NULL AND r.[DateComplete] IS NOT NULL THEN 'Unknown'
			WHEN r.[CompletedResponseBy]='Sample' THEN s.[UID]
			WHEN r.[CompletedResponseBy]='Editor' AND r.[CompletedResponseUserId] IS NOT NULL THEN cru.[Name]
			ELSE 'Unknown' END 
			AS [CompletedResponder],
		r.[LastResponseAs],
		r.[LastResponseBy],
		r.[LastResponseVia],		
		CASE 
			WHEN r.[LastResponseBy] IS NULL THEN NULL
			WHEN r.[LastResponseBy]='Sample' THEN s.[UID]
			WHEN r.[LastResponseBy]='Editor' AND r.[UserId] IS NOT NULL THEN lru.[Name]
			ELSE 'Unknown' END 
			AS [LastResponder]
	FROM 
		QNN_DPLY_SAMPLE_INFO dsi
		INNER JOIN QNN_LIST_SAMPLE ls ON ls.[Id]=dsi.[ListSampleId]
		INNER JOIN QNN_SAMPLE s ON s.[Id]=ls.[SampleId]
		--n.b. we're taking sample's address from the list's structdivision rather than the deployment's
		LEFT JOIN QNN_SAMPLE_ADDRESS a ON a.[SampleId]=s.[Id] AND a.[StructDivisionId]=@ListStructDivisionId
		LEFT JOIN QNN_RESP r ON r.[DplyId]=@DplyId AND r.[ListSampleId]=dsi.ListSampleId --with multi-response/anon this can result in extra rows
		LEFT JOIN dwSecurityUser lru ON lru.[Id]=r.[UserId] --userId is effectively 'LastResponseUserId'		
		LEFT JOIN dwSecurityUser iru ON iru.Id=r.[InitialResponseUserId]
		LEFT JOIN dwSecurityUser cru ON cru.Id=r.[CompletedResponseUserId]
	WHERE 
		dsi.[DplyId]=@DplyId
	OPTION (MAXDOP 1) --seem to get better plans and memory grants without parallelism for this query
	;
END