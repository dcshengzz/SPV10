
CREATE VIEW [dbo].[vSP_ListSampleIdSegment] AS 
select lsp.PropValue as [Segment], lsp.ListSampleId from QNN_LIST_SAMPLE_PROP lsp
inner join QNN_LIST_PROP lp on lp.ListId = lsp.ListId and lp.Id=lsp.ListPropId
where lp.Alias='Segment'