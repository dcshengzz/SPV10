CREATE VIEW [dbo].[vSP_ListSampleCount] AS 
select l.Id as ListId, count(*) as SampleCount from QNN_LIST_SAMPLE s
left join QNN_LIST l on l.Id = s.ListId
group by l.Id
