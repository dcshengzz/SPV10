CREATE VIEW [dbo].[vSP_DeploymentSampleCount] AS 
select d.Id as DplyId, count(*) as SampleCount from QNN_DPLY_SAMPLE_INFO i
inner join QNN_DPLY d on d.Id = i.DplyId
group by d.Id
