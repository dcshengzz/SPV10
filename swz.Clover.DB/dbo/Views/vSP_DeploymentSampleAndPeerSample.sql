

CREATE VIEW [dbo].[vSP_DeploymentSampleAndPeerSample] AS 
select dsi.Id, Concat(s.UID, s2.UID) as MergedUID, ls.Id as ListSampleId, dsi.DplyId, r.Id as RespId, r.IsPrePopulated  from QNN_DPLY_SAMPLE_INFO dsi
inner join QNN_LIST_SAMPLE ls on ls.Id = dsi.ListSampleId
inner join QNN_SAMPLE s on ls.SampleId=s.Id
left join QNN_SAMPLE s2 on ls.SamplePeerId =s2.Id
left join QNN_RESP r with (NOLOCK) on r.ListSampleId = dsi.ListSampleId and r.DplyId = dsi.DplyId
where ls.ActiveYN = 1 and ls.IsDeleted = 0

