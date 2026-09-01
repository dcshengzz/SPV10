

CREATE VIEW [dbo].[vSP_RespSummary] AS
SELECT 
	r.Id,
	s.[UID], 
	s.[Name],	
	d.Id AS DplyId,
	d.[Name] AS DplyName,
	st.Title AS StatusTitle,
	dsi.StatusModifyBy,
	smu.[Name] AS StatusModifyByName,
	dsi.StatusModifyOn,
	dsi.RemarksModifyBy,
	rmu.[Name] AS RemarksModifyByName,
	dsi.RemarksModifyOn,
	r.DateStart,
	r.DateComplete,
	r.UpdatedDate,
	r.IsExcelResponse,
	r.IsExcelResponseDE,
	r.InitialResponseAs,
	r.InitialResponseBy,
	r.InitialResponseVia,
	r.LastResponseAs,
	r.LastResponseBy,
	r.LastResponseVia,
	CASE 
		WHEN r.InitialResponseBy IS NULL THEN NULL
		WHEN r.InitialResponseBy='Sample' THEN [s].[UID]
		WHEN r.InitialResponseBy='Editor' AND r.InitialResponseUserid IS NOT NULL THEN iru.[Name]
		ELSE 'Unknown' END AS InitialResponder,
	CASE 
		WHEN r.CompletedResponseBy IS NULL AND r.DateComplete IS NULL THEN NULL
		WHEN r.CompletedResponseBy IS NULL AND r.DateComplete IS NOT NULL THEN 'Unknown'
		WHEN r.CompletedResponseBy='Sample' THEN [s].[UID]
		WHEN r.CompletedResponseBy='Editor' AND r.CompletedResponseUserId IS NOT NULL THEN cru.[Name]
		ELSE 'Unknown' END AS CompletedResponder,
	CASE 
		WHEN r.LastResponseBy IS NULL THEN NULL
		WHEN r.LastResponseBy='Sample' THEN [s].[UID]
		WHEN r.LastResponseBy='Editor' AND r.UserId IS NOT NULL THEN lru.[Name]
		ELSE 'Unknown' END AS LastResponder,
	r.UserId,
	r.CompletedResponseAs,
	r.CompletedResponseBy,
	r.CompletedResponseVia,
	r.CompletedResponseUserId,
	r.Strata,
	dsi.Remarks,
	CASE
		WHEN due.DueDate IS NOT NULL THEN due.DueDate
		ELSE d.DateEnd END AS DueDate
FROM 
	QNN_RESP r
	INNER JOIN QNN_DPLY_SAMPLE_INFO dsi ON (dsi.ListSampleId=r.ListSampleId AND dsi.DplyId=r.DplyId)
	INNER JOIN QNN_LIST_SAMPLE ls ON ls.Id=r.ListSampleId
	INNER JOIN QNN_SAMPLE s ON s.Id=ls.SampleId
	INNER JOIN QNN_STATUS st ON st.Id=dsi.Status
	INNER JOIN QNN_DPLY d ON d.Id=r.DplyId
	LEFT JOIN dwSecurityUser iru on iru.Id=r.InitialResponseUserId
	LEFT JOIN dwSecurityUser cru on cru.Id=r.CompletedResponseUserId
	LEFT JOIN dwSecurityUser lru on lru.Id=r.UserId
	LEFT JOIN dwSecurityUser smu on smu.Id=r.UserId
	LEFT JOIN dwSecurityUser rmu on rmu.Id=r.UserId
	LEFT JOIN vSP_DplySampleDueDate due on (due.DplyId=r.DplyId AND r.ListSampleId = due.ListSampleId)
;