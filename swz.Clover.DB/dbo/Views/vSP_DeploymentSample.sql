










CREATE VIEW [dbo].[vSP_DeploymentSample] AS 
select 

Concat(sample.UID, ' (', sample.Name, ')') as [UIDName],
IIF (sample2.UID is null, null, Concat(sample2.UID, ' (', sample2.Name, ')')) as [PeerUIDName],
ls.ActiveYN as [Active],
sample.UID,
address.ToEmails,
sample.Name,
si.Remarks,
r.DateStart,
r.DateComplete,
(select top 1 1 from QNN_TRK_LIST_SAMPLE where UID=sample.UID) as HasTrkListIds,
si.ListSampleId as RespListSampleId,
r.Id as RespId,
si.Id as Id,
si.ListSampleId,
si.[Status],
s.Code as StatusCode,
s.Title as StatusTitle,
si.ReturnInd,
si.ProcessValidInd,
si.ProcessEditInd,
si.DplyId,
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

d.QnnId,
d.CreatedDate,

q.Type,
--f.Name as FormName,

so.UserId, --consider as LastResponseUserId
d.StructDivisionId,

u.[Name] as UpdatedBy, -- name of the last data editor to edit the response (but respondent may have edited since)
CASE 
	WHEN r.InitialResponseBy IS NULL THEN NULL
	WHEN r.InitialResponseBy='Sample' THEN [sample].[UID]
	WHEN r.InitialResponseBy='Editor' AND r.InitialResponseUserid IS NOT NULL THEN initialResponseUser.[Name]
	ELSE 'Unknown' END AS InitialResponder,
CASE 
	WHEN r.CompletedResponseBy IS NULL AND r.DateComplete IS NULL THEN NULL
	WHEN r.CompletedResponseBy IS NULL AND r.DateComplete IS NOT NULL THEN 'Unknown'
	WHEN r.CompletedResponseBy='Sample' THEN [sample].[UID]
	WHEN r.CompletedResponseBy='Editor' AND r.CompletedResponseUserId IS NOT NULL THEN completedResponseUser.[Name]
	ELSE 'Unknown' END AS CompletedResponder,
CASE 
	WHEN r.LastResponseBy IS NULL THEN NULL
	WHEN r.LastResponseBy='Sample' THEN [sample].[UID]
	WHEN r.LastResponseBy='Editor' AND r.UserId IS NOT NULL THEN u.[Name]
	ELSE 'Unknown' END AS LastResponder,

r.UpdatedDate AS UpdatedDate,

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

r.IsExcelResponse as IsExcelResponse,
r.IsExcelResponseDE as IsExcelResponseDE,
r.ExcelUploadDate as ExcelUploadDate,
r.InitialResponseAs as InitialResponseAs,
r.InitialResponseBy as InitialResponseBy,
r.InitialResponseVia as InitialResponseVia,
r.CompletedResponseAs as CompletedResponseAs,
r.CompletedResponseBy as CompletedResponseBy,
r.CompletedResponseVia as CompletedResponseVia,
r.LastResponseAs as LastResponseAs,
r.LastResponseBy as LastResponseBy,
r.LastResponseVia as LastResponseVia,
rc.CompleteCount as CompleteCount,
rc.IncompleteCount as IncompleteCount,
CASE WHEN (r.NumberId=rc.LatestNumberId) THEN 1 ELSE 0 END AS IsLatestResponse


from QNN_DPLY_SAMPLE_INFO si
left join QNN_DPLY d on d.Id = si.DplyId
left join QNN_QNN q on d.QnnId = q.Id
left join QNN_LIST_SAMPLE ls on si.ListSampleId = ls.Id
left join QNN_LIST list ON list.Id=ls.ListId
left join QNN_SAMPLE_ADDRESS address ON address.SampleId=ls.SampleId AND address.StructDivisionId=list.StructDivisionId
left join QNN_SAMPLE sample on sample.Id = ls.SampleId
left join QNN_SAMPLE sample2 on sample2.Id = ls.SamplePeerId
left join QNN_STATUS s on si.Status = s.Id
left join QNN_DPLY_SAMPLE_OWNER so on so.DplyId = si.DplyId and so.ListSampleId = si.ListSampleId
left join QNN_RESP r with (NOLOCK) on r.DplyId = si.DplyId and r.ListSampleId = si.ListSampleId and r.QnnId = d.QnnId
left join dwSecurityUser initialResponseUser on initialResponseUser.Id=r.InitialResponseUserId
left join dwSecurityUser u on u.Id = r.UserId --fulfils purpose of lastResponseUser
left join dwSecurityUser completedResponseUser on completedResponseUser.Id=r.CompletedResponseUserId
left join vSP_DplySampleInfoResponseCount rc ON si.Id=rc.Id
where ls.ActiveYN = 1


