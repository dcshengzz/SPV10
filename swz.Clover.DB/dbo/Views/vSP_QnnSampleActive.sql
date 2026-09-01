CREATE VIEW [dbo].[vSP_QnnSampleActive] AS 
select s.StructDivisionId, q.Id, q.Name, q.UID from QNN_SAMPLE_STRUCTDIVISION s
inner join qnn_sample q on s.SampleId = q.Id
where q.ActiveYN = 1 and q.IsDeleted = 0
