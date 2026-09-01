

CREATE VIEW [dbo].[vSP_DplySampleInfoResponseCount] AS 
SELECT 
	dsi.Id As Id, 
	d.IsMultipleResponse AS IsMultipleResponse,
	SUM( CASE WHEN r.DateComplete IS NOT NULL THEN 1 ELSE 0 END) AS CompleteCount ,
	SUM( CASE WHEN r.DateComplete IS  NULL THEN 1 ELSE 0 END) AS IncompleteCount ,
	COUNT(*) AS RespCount,
	MAX(r.NumberId) AS LatestNumberId
	
	FROM
	QNN_DPLY_SAMPLE_INFO dsi
	LEFT JOIN QNN_DPLY d ON (dsi.DplyId = d.Id)
	LEFT JOIN QNN_RESP r with (NOLOCK) ON (r.DplyId=dsi.DplyId AND r.ListSampleId=dsi.ListSampleId)	
	GROUP BY dsi.Id, d.IsMultipleResponse;