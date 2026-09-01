alter VIEW [dbo].[vSP_DeploymentSample] AS 
select 

Concat(sample.UID, ' (', sample.Name, ')') as [UID (Name)],
IIF (sample2.UID is null, null, Concat(sample2.UID, ' (', sample2.Name, ')')) as [Peer UID (Name)],
ls.ActiveYN as [Active],


r.DateStart,
r.DateComplete,

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
            ORDER BY qqf.Name
            FOR XML PATH ('')
        ), 3, 1000) [FormNames], 

SUBSTRING(
		(
				SELECT '||'+qqf.[Language]  AS [text()]
				FROM QNN_QNN_FORM qqf
				WHERE qqf.QnnId = q.Id
				ORDER BY qqf.Name
				FOR XML PATH ('')
		), 3, 1000) [Languages],

SUBSTRING(
        (
            SELECT '||'+qqe.Token  AS [text()]
            FROM QNN_QNN_ENTITY qqe
            WHERE qqe.QnnId = q.Id
            ORDER BY qqe.[Language]
            FOR XML PATH ('')
        ), 3, 1000) [Tokens], 

SUBSTRING(
		(
				SELECT '||'+qqe.[Language]  AS [text()]
				FROM QNN_QNN_ENTITY qqe
				WHERE qqe.QnnId = q.Id
				ORDER BY qqe.[Language]
				FOR XML PATH ('')
		), 3, 1000) [OfflineLanguages],

d.QnnId,
d.CreatedDate,

q.Type,
--f.Name as FormName,

so.UserId,
d.StructDivisionId,
u.Name as UpdatedBy



from QNN_DPLY_SAMPLE_INFO si
left join QNN_DPLY d on d.Id = si.DplyId
left join QNN_QNN q on d.QnnId = q.Id
--left join QNN_QNN_FORM f on f.QnnId = q.Id
left join QNN_LIST_SAMPLE ls on si.ListSampleId = ls.Id
left join QNN_SAMPLE sample on sample.Id = ls.SampleId
left join QNN_SAMPLE sample2 on sample2.Id = ls.SamplePeerId
left join QNN_STATUS s on si.Status = s.Id
left join QNN_DPLY_SAMPLE_OWNER so on so.DplyId = si.DplyId and so.ListSampleId = si.ListSampleId
left join QNN_RESP r on r.DplyId = si.DplyId and r.ListSampleId = si.ListSampleId and r.QnnId = d.QnnId
left join dwSecurityUser u on u.Id = r.UserId
where ls.ActiveYN = 1
--where so.UserId = 'E41B48E3-C03D-484F-8764-1711248C4F8A' and si.DplyId = '24A7DA6E-E12D-47B8-8A7D-00A193FD2757'

GO