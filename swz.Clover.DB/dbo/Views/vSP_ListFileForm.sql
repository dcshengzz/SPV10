

CREATE VIEW [dbo].[vSP_ListFileForm] AS 
select 
			qq.Id,
			qq.IsDeleted, 
			qq.Status, 
			qq.Type,
			SUBSTRING(
			        (
			            SELECT '||'+qqf.Name  AS [text()]
			            FROM dbo.QNN_QNN_FORM qqf
			            where qqf.QnnId = qq.Id
			            ORDER BY qqf.[Language], qqf.[Name]
			            FOR XML PATH ('')
			        ), 3, 1000) [FormNames],
			
			SUBSTRING(
					(
						SELECT '||'+qqf.[Language]  AS [text()]
						FROM dbo.QNN_QNN_FORM qqf
						WHERE qqf.QnnId = qq.Id
						ORDER BY qqf.[Language], qqf.[Name]
						FOR XML PATH ('')
					), 3, 1000) [Languages],
			
			SUBSTRING(
			        (
			            SELECT '||'+qql.Name  AS [text()]
			            FROM dbo.QNN_QNN_FILE qql
			            WHERE qql.QnnId = qq.Id
			            ORDER BY qql.[Language], qql.[Name]
			            FOR XML PATH ('')
			        ), 3, 1000) [FileNames],
			SUBSTRING(
					(
							SELECT '||'+qql.[Language]  AS [text()]
							FROM dbo.QNN_QNN_FILE qql
							WHERE qql.QnnId = qq.Id
							ORDER BY qql.[Language], qql.[Name]
							FOR XML PATH ('')
					), 3, 1000) [FileLanguages],
			
			SUBSTRING(
			        (
			            SELECT '||'+qql.Token  AS [text()]
			            FROM dbo.QNN_QNN_FILE qql
			            WHERE qql.QnnId = qq.Id
			            ORDER BY qql.[Language], qql.[Name]
			            FOR XML PATH ('')
			        ), 3, 1000) [FileTokens]
			FROM dbo.QNN_QNN qq