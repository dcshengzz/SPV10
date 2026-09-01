
CREATE PROCEDURE [dbo].[spSP_GetSegmentByDplyId]
		@DplyId uniqueidentifier,
		@Segments NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

--SELECT T.C.value('.', 'NVARCHAR(100)') AS [Name]
--INTO #tblSegments
--FROM (SELECT CAST ('<Name>' + REPLACE(@Segments, '|', '</Name><Name>') + '</Name>' AS XML) AS [Names]) AS A
--CROSS APPLY Names.nodes('/Name') as T(C)

SELECT 
	s.[Group_Name],
	LSP.PropValue As Segment,
	LSPc.PropValue AS WeightGroup,
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
	LEFT JOIN QNN_LIST_SAMPLE_PROP LSP ON DS.ListSampleId = LSP.ListSampleId AND LSP.ListPropId IN 
	(SELECT Id FROM QNN_LIST_PROP WHERE QNN_LIST_PROP.Alias = 'SEGMENT')
	 --AND LSP.PropValue IN(SELECT NAME FROM #tblSegments)
	LEFT JOIN QNN_LIST_SAMPLE_PROP LSPc ON DS.ListSampleId = LSPc.ListSampleId AND LSPc.ListPropId IN 
	(SELECT Id FROM QNN_LIST_PROP WHERE QNN_LIST_PROP.Alias = 'WEIGHTGROUP')
GROUP BY s.Group_Name, LSP.PropValue, LSPc.PropValue
ORDER BY Group_name ASC, Segment ASC
--DROP TABLE #tblSegments

END 
