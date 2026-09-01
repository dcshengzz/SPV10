CREATE VIEW [dbo].[vSP_DplySample] AS 
select concat(s.UID, ' (', s.Name, ')') as Sampler, ls.Id as ListSampleId, dsi.DplyId  from QNN_DPLY_SAMPLE_INFO dsi
inner join QNN_LIST_SAMPLE ls on ls.Id = dsi.ListSampleId
inner join QNN_SAMPLE s on ls.SampleId=s.Id
where ls.ActiveYN = 1 and ls.IsDeleted = 0
