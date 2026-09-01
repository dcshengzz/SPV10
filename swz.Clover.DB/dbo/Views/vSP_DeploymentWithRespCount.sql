


CREATE VIEW [dbo].[vSP_DeploymentWithRespCount] AS 
	SELECT 
		d.Name, 
		d.Id, 
		d.IsAnonymous, 
		d.IsMultipleResponse, 
		
		CASE 
			WHEN d.RecurrenceEnabled=0 AND d.RecurrenceOfDplyId IS NULL THEN CAST('N' AS CHAR(1)) -- not a recurring survey
			WHEN d.RecurrenceEnabled=1 AND d.RecurrenceOfDplyId IS NULL THEN CAST('I' AS CHAR(1)) -- initial deployment for recurring survey
			WHEN d.RecurrenceEnabled=1 AND d.RecurrenceOfDplyId IS NOT NULL THEN CAST('?' AS CHAR(1)) -- (this is an invalid condition and should not happen)
			WHEN d.RecurrenceEnabled=0 AND d.RecurrenceOfDplyId IS NOT NULL THEN CAST('R' AS CHAR(1)) -- recurrence of a recurring survey
			ELSE CAST(NULL AS CHAR(1))
		END AS RecurrenceType,
		d.QnnId, qnn.Title AS QnnId_Title, 
		qnn.Type AS QnnId_Type, 
		list.Name AS ListId_Name, 
		d.Tags AS Tags, 
		d.CreatedDate, 
		ISNULL(drc.RespCount, 0 ) AS RespCount, 
		ISNULL(sc.SampleCount,0) AS SampleCount, 
		d.StructDivisionId 
	FROM 
		QNN_DPLY d
		LEFT JOIN vSP_DeploymentRespCount drc ON d.Id = drc.DplyId
		INNER JOIN QNN_QNN qnn ON d.QnnId = qnn.Id
		INNER JOIN QNN_LIST list ON d.ListId = list.Id
		LEFT JOIN vSP_DeploymentSampleCount sc ON d.Id = sc.DplyId
