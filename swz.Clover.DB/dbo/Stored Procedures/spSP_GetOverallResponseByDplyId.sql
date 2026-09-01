CREATE PROCEDURE [dbo].[spSP_GetOverallResponseByDplyId]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

SELECT 
	s.[Group_Name],
	LSP.PropValue AS WeightGroup,
	LSPb.PropValue As IndustryGroup,
	COUNT(DS.Status) As Number

FROM 
    (
		SELECT 
			case
            when T.[Code] in ('RC','DE','SB','CL','CR','PR','IE','EM','NI') then 'Active'
            when T.[Code] in ('CO','DM','SO','NI','BO') then 'BouncedAndInActive'
			when T.[Code] in ('PE', NULL) then 'Pending'
        end as Group_Name,
		T.Code,
		T.Title,
		T.Id
		FROM [QNN_Status] as T 
    )
as s
	LEFT JOIN QNN_DPLY_SAMPLE_INFO DS ON s.Id = DS.Status and DS.DplyId = @DplyId
	LEFT JOIN QNN_LIST_SAMPLE_PROP LSP ON DS.ListSampleId = LSP.ListSampleId AND LSP.ListPropId IN (SELECT Id FROM QNN_LIST_PROP WHERE QNN_LIST_PROP.Alias = 'WEIGHTGROUP')
	LEFT JOIN QNN_LIST_SAMPLE_PROP LSPb ON DS.ListSampleId = LSPb.ListSampleId AND LSPb.ListPropId IN (SELECT Id FROM QNN_LIST_PROP WHERE QNN_LIST_PROP.Alias = 'INDUSTRY')
GROUP BY s.Group_Name, LSPb.PropValue, LSP.PropValue
ORDER BY Group_name ASC, WeightGroup ASC, IndustryGroup ASC

END 
