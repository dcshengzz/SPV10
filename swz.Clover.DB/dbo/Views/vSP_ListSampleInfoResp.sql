



CREATE       VIEW [dbo].[vSP_ListSampleInfoResp] AS 
select lsi.Id, lsi.NumberId, lsi.DplyId, lsi.ListSampleId, vlsis.Segment, lsi.Remarks, lsi.StatusModifyBy, lsi.StatusModifyOn, lsi.RemarksModifyBy, lsi.RemarksModifyOn, lsi.DispatchInd, lsi.ReturnInd, lsi.ProcessValidInd, lsi.ProcessEditInd, lsi.Status, st.Title as StatusTitle, lsi.CreatedBy, lsi.CreatedDate, s.UID, s.Id as SampleId, 
Concat(s.UID, ' (', s.Name, ')') as UIDName, 

CASE
	WHEN s1.UID is null THEN null   
	WHEN s1.UID is not null THEN Concat(s1.UID, ' (', s1.Name, ')')
END 
as PeerName,
q.FormNames,
q.Languages,
q.FileNames,
q.FileLanguages,
q.FileTokens,
s1.UID as UIDPeer, d.CreatedDate as DplyCreatedDate, d.Name as DplyName, d.IpCountry, d.RestrictIp, d.RestrictIpInclusive, d.IpRange,
d.DateStart as DplyDateStart, d.DateEnd as DplyDateEnd, d.QnnId, d.IsDeleted as DplyIsDeleted, d.Status as DplyStatus, d.State as DplyWorkflowState, d.CompleteAction, d.CompleteURL, d.DaysUpdate, d.MaxResponse, d.VisibleToRespondent, d.IsAnonymous, d.IsMultipleResponse,

CASE
when due.DueDate is not null then due.DueDate
else d.DateEnd
END 
as DueDate, 

d.SurveyName as QnnTitle, q.IsDeleted as QnnIsDeleted, q.Status as QnnStatus, q.Type as QnnType,
--f.Name as FormName,  
CASE
	WHEN q.Type='P' THEN 'Offline'   --nb: offline has been deprecated and removed
	WHEN q.Type='O' THEN 'Online'   
END 
as Type,
ls.ListId,
r.Id as RespId, r.DateStart as RespDateStart, d.StructDivisionId,
r.DateComplete as RespDateEnd,
r.UpdatedDate as RespDateUpdate,
d.IsExcelEnabled as IsExcelEnabled,
r.IsExcelResponse as IsExcelResponse,
r.IsPrePopulated as IsPrePopulated,
d.RequireAccessCode as RequireAccessCode,
ls.ActiveYN as ListSampleRecordActiveYN,
    (SELECT COUNT(r_sub.DateComplete) 
     FROM QNN_RESP r_sub 
     WHERE r_sub.DplyId = d.Id
	 AND r_sub.DateComplete IS NOT NULL
     ) AS TotalComplete,
COALESCE(sa.ToEmails, '') +
CASE 
    WHEN sa.ToEmails IS NOT NULL AND sa.ToEmails <> '' AND sa.CcEmails IS NOT NULL AND sa.CcEmails <> '' THEN ','
    ELSE ''
END +
COALESCE(sa.CcEmails, '') as sampleEmails
from QNN_DPLY_SAMPLE_INFO lsi
left join QNN_STATUS st on lsi.Status = st.Id
left join QNN_LIST_SAMPLE ls on lsi.ListSampleId = ls.Id
Left outer join vSP_ListSampleIdSegment AS vlsis ON lsi.ListSampleId = vlsis.ListSampleId
left join QNN_SAMPLE s on ls.SampleId = s.Id
left join QNN_SAMPLE s1 on ls.SamplePeerId = s1.Id
inner join QNN_DPLY d on lsi.DplyId = d.Id
left join QNN_RESP r on lsi.DplyId = r.DplyId and lsi.ListSampleId = r.ListSampleId and r.QnnId = d.QnnId
left join vSP_ListFileForm q on q.Id = d.QnnId
left join vSP_DplySampleDueDate due on lsi.DplyId = due.DplyId and lsi.ListSampleId = due.ListSampleId
left join QNN_SAMPLE_ADDRESS sa on ls.SampleId = sa.SampleId and d.StructDivisionId = sa.StructDivisionId
where d.IsDeleted = 0 and d.Status = 1