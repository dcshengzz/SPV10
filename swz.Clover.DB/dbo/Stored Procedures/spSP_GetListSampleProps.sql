
CREATE PROCEDURE [dbo].[spSP_GetListSampleProps] 
		@ListSampleId uniqueidentifier
    AS
BEGIN
	SELECT
		lsp.ListPropId,
		lsp.PropValue
	FROM
		QNN_LIST_SAMPLE_PROP lsp
	WHERE
		lsp.ListSampleId=@ListSampleId;
END