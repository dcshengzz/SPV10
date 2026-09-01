CREATE VIEW [dbo].[vSP_ListWithCount] AS 
select l.Id, l.NumberId, l.Name, l.Tags as Tags, ISNULL(lsc.SampleCount, 0) as SampleCount, l.UpdatedDate, l.Status, l.StructDivisionId, l.isArchived from QNN_LIST l
left join vSP_ListSampleCount lsc on lsc.ListId = l.Id
