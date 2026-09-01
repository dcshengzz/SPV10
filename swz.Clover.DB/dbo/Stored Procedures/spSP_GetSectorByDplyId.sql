--Version 1.67
CREATE PROCEDURE [dbo].[spSP_GetSectorByDplyId]
		@DplyId uniqueidentifier,
		@Sectors NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

--SELECT T.C.value('.', 'NVARCHAR(100)') AS [Name]
--INTO #tblSector
--FROM (SELECT CAST ('<Name>' + REPLACE(@Sectors, '|', '</Name><Name>') + '</Name>' AS XML) AS [Names]) AS A
--CROSS APPLY Names.nodes('/Name') as T(C)

SELECT 
	s.[Group_Name],
	LSP.PropValue As Sector,
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
	(SELECT Id FROM QNN_LIST_PROP WHERE QNN_LIST_PROP.Alias = 'SECTOR') --AND LSP.PropValue IN(SELECT NAME FROM #tblSector)
	LEFT JOIN QNN_LIST_SAMPLE_PROP LSPc ON DS.ListSampleId = LSPc.ListSampleId AND LSPc.ListPropId IN 
	(SELECT Id FROM QNN_LIST_PROP WHERE QNN_LIST_PROP.Alias = 'WEIGHTGROUP')
GROUP BY s.Group_Name, LSP.PropValue, LSPc.PropValue
ORDER BY Group_name ASC, Sector ASC
--DROP TABLE #tblSector

END 
