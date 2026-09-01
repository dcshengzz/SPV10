
CREATE VIEW [dbo].[vSP_ShortLink] AS 
	SELECT 
		sl.[Id],
		sl.[Name],
		CASE
			WHEN sl.[Description] IS NULL OR LEN(sl.[Description]) <= 175 THEN sl.[Description]
			ELSE CONCAT(LEFT(sl.[Description],173),'...') 
		END AS [DisplayDescription],	
		sl.[LinkType],
		CASE
			WHEN [LinkType]='Url' THEN 
				CASE WHEN sl.[Url] IS NULL OR LEN(sl.[Url]) <= 100 THEN sl.[Url]
				ELSE CONCAT(LEFT(sl.[Url], 97),'...')
			END
			WHEN [LinkType]='Anonymous' THEN 
				CASE 
					WHEN sl.[DplyId] IS NULL THEN '[DELETED DEPLOYMENT]'
					ELSE CONCAT(dply.[Name],' (', sl.[FormName], ')')
				END
			ELSE NULL
		END AS [DisplayTarget],
		sl.[IsEnhancedSecurity],
		sl.[Status],
		sl.[StructDivisionId] 
	FROM 
		QNN_SHORT_LINK sl
		LEFT JOIN QNN_DPLY dply ON sl.[DplyId]=dply.[Id];