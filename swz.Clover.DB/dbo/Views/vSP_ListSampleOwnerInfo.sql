


CREATE   VIEW [dbo].[vSP_ListSampleOwnerInfo]
AS (SELECT vlsis.Segment, lsi.Id, lsi.NumberId, lsi.DplyId, lsi.ListSampleId, s.UID, s.Name, CASE WHEN s1.UID IS NULL THEN NULL WHEN s1.UID IS NOT NULL THEN Concat(s1.UID, ' (', s1.Name, ')') END AS PeerName, qs.Title AS StatusTitle, s1.UID AS UIDPeer, 
             d.DateStart AS DplyDateStart, d.DateEnd AS DplyDateEnd, 
			 CASE 
			 WHEN due.DueDate IS NOT NULL THEN due.DueDate
			 ELSE d.DateEnd END AS DueDate, 
			 r.DateStart AS RespDateStart, d.StructDivisionId, 
             r.DateComplete AS RespDateEnd
FROM   dbo.QNN_DPLY_SAMPLE_INFO AS lsi LEFT OUTER JOIN
             dbo.QNN_LIST_SAMPLE AS ls ON lsi.ListSampleId = ls.Id LEFT OUTER JOIN
   			 dbo.vSP_ListSampleIdSegment AS vlsis ON lsi.ListSampleId = vlsis.ListSampleId LEFT OUTER JOIN  
             dbo.QNN_SAMPLE AS s ON ls.SampleId = s.Id LEFT OUTER JOIN
             dbo.QNN_SAMPLE AS s1 ON ls.SamplePeerId = s1.Id INNER JOIN
             dbo.QNN_DPLY AS d ON lsi.DplyId = d.Id LEFT OUTER JOIN
             dbo.QNN_RESP AS r WITH (NOLOCK) ON lsi.DplyId = r.DplyId AND lsi.ListSampleId = r.ListSampleId AND r.QnnId = d.QnnId LEFT OUTER JOIN
             dbo.QNN_QNN AS q ON d.QnnId = q.Id LEFT OUTER JOIN
             dbo.vSP_DplySampleDueDate AS due ON lsi.DplyId = due.DplyId AND lsi.ListSampleId = due.ListSampleId LEFT OUTER JOIN
             dbo.QNN_STATUS AS qs ON qs.Id = lsi.Status
WHERE (d.IsDeleted = 0) AND (d.Status = 1))