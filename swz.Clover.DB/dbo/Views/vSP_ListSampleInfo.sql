



CREATE     VIEW [dbo].[vSP_ListSampleInfo] AS 
select lsi.Id, lsi.NumberId, lsi.DplyId, lsi.ListSampleId, lsi.Remarks, lsi.StatusModifyBy, lsi.StatusModifyOn, lsi.RemarksModifyBy, lsi.RemarksModifyOn, lsi.DispatchInd, lsi.ReturnInd, lsi.ProcessValidInd, lsi.ProcessEditInd, lsi.Status, lsi.CreatedBy, lsi.CreatedDate, s.UID, s.Id as SampleId, 
Concat(s.UID, ' (', s.Name, ')') as UIDName, 

CASE
	WHEN s1.UID is null THEN null   
	WHEN s1.UID is not null THEN Concat(s1.UID, ' (', s1.Name, ')')
END 
as PeerName,

qs.Title as StatusTitle,
s1.UID as UIDPeer, d.CreatedDate as DplyCreatedDate, d.Name as DplyName, d.IpCountry, d.RestrictIp, d.RestrictIpInclusive, d.IpRange,
d.DateStart as DplyDateStart, d.DateEnd as DplyDateEnd, d.QnnId, d.IsDeleted as DplyIsDeleted, d.Status as DplyStatus, d.State as DplyWorkflowState, d.CompleteAction, d.CompleteURL, d.DaysUpdate, d.MaxResponse, d.VisibleToRespondent, d.IsAnonymous, d.IsMultipleResponse,

CASE
when due.DueDate is not null then due.DueDate
else d.DateEnd
END 
as DueDate, 

d.SurveyName as QnnTitle, q.IsDeleted as QnnIsDeleted, q.Status as QnnStatus, q.Type as QnnType,
CASE
	WHEN q.Type='P' THEN 'Offline'   --nb: offline has been deprecated and removed
	WHEN q.Type='O' THEN 'Online'   
END 
as Type,

ls.ListId,

SUBSTRING(
        (
            SELECT '||'+qqf.Name  AS [text()]
            FROM QNN_QNN_FORM qqf
            WHERE qqf.QnnId = q.Id
            ORDER BY qqf.[Language], qqf.[Name]
            FOR XML PATH ('')
        ), 3, 1000) [FormNames], 

SUBSTRING(
		(
				SELECT '||'+qqf.[Language]  AS [text()]
				FROM QNN_QNN_FORM qqf
				WHERE qqf.QnnId = q.Id
				ORDER BY qqf.[Language], qqf.[Name]
				FOR XML PATH ('')
		), 3, 1000) [Languages],

d.StructDivisionId,

SUBSTRING(
        (
            SELECT '||'+qql.Name  AS [text()]
            FROM QNN_QNN_FILE qql
            WHERE qql.QnnId = q.Id
            ORDER BY qql.[Language], qql.[Name]
            FOR XML PATH ('')
        ), 3, 1000) [FileNames],
SUBSTRING(
		(
				SELECT '||'+qql.[Language]  AS [text()]
				FROM QNN_QNN_FILE qql
				WHERE qql.QnnId = q.Id
				ORDER BY qql.[Language], qql.[Name]
				FOR XML PATH ('')
		), 3, 1000) [FileLanguages],

SUBSTRING(
        (
            SELECT '||'+qql.Token  AS [text()]
            FROM QNN_QNN_FILE qql
            WHERE qql.QnnId = q.Id
            ORDER BY qql.[Language], qql.[Name]
            FOR XML PATH ('')
        ), 3, 1000) [FileTokens],
d.IsExcelEnabled as IsExcelEnabled,
d.RequireAccessCode as RequireAccessCode,
rc.CompleteCount as CompleteCount,
rc.IncompleteCount as IncompleteCount,
ls.ActiveYN as ListSampleRecordActiveYN,
s.ActiveYN as SampleRecordActiveYN --added 20230424

from QNN_DPLY_SAMPLE_INFO lsi
left join QNN_LIST_SAMPLE ls on lsi.ListSampleId = ls.Id
left join QNN_SAMPLE s on ls.SampleId = s.Id
left join QNN_SAMPLE s1 on ls.SamplePeerId = s1.Id
inner join QNN_DPLY d on lsi.DplyId = d.Id
left join QNN_QNN q on d.QnnId = q.Id
left join vSP_DplySampleDueDate due on lsi.DplyId = due.DplyId and lsi.ListSampleId = due.ListSampleId
left join QNN_STATUS qs on qs.Id = lsi.Status
left join vSP_DplySampleInfoResponseCount rc ON lsi.Id=rc.Id
where d.IsDeleted = 0 and d.Status = 1

