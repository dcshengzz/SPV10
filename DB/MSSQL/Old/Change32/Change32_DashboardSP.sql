--GetOverallResponse
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
GO
--GetSegmentResponse
CREATE PROCEDURE [dbo].[spSP_GetSegmentResponseByDplyId]
		@DplyId uniqueidentifier,
		@Segments NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

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
	LEFT JOIN QNN_LIST_SAMPLE_PROP LSPc ON DS.ListSampleId = LSPc.ListSampleId AND LSPc.ListPropId IN 
	(SELECT Id FROM QNN_LIST_PROP WHERE QNN_LIST_PROP.Alias = 'WEIGHTGROUP')
GROUP BY s.Group_Name, LSP.PropValue, LSPc.PropValue
ORDER BY Group_name ASC, Segment ASC

END 
GO
--GetSectorResponse
CREATE PROCEDURE [dbo].[spSP_GetSectorResponseByDplyId]
		@DplyId uniqueidentifier,
		@Sectors NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

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

END 
GO
--GetStatusResponse
CREATE PROCEDURE [dbo].[spSP_GetStatusResponseByDplyId]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @Completed  AS INT = (SELECT 	
	COUNT(DS.Status) As Number
FROM [QNN_Status] as s
	LEFT JOIN QNN_DPLY_SAMPLE_INFO DS ON s.Id = DS.Status and DS.DplyId = @DplyId
);


SELECT
	s.[Title],
	s.[Code],
	COUNT(DS.Status) As Number

FROM [QNN_Status]
as s
	LEFT JOIN QNN_DPLY_SAMPLE_INFO DS ON s.Id = DS.Status and DS.DplyId = @DplyId
GROUP BY s.[Title], s.[Code]
ORDER BY s.[Title] ASC

END 
GO
--GetWeeklyResponse
CREATE PROCEDURE [dbo].[spSP_GetWeeklyActiveResponseByDplyId]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
SELECT DATEPART(wk, DateStart) AS WeekNumber,
LSP.PropValue As WeightGroup,
COUNT(*) AS Number
FROM QNN_RESP R
	LEFT JOIN QNN_LIST_SAMPLE_PROP LSP ON R.ListSampleId = LSP.ListSampleId AND LSP.ListPropId IN 
	(SELECT Id FROM QNN_LIST_PROP WHERE QNN_LIST_PROP.Alias = 'WEIGHTGROUP')
	LEFT JOIN QNN_DPLY_SAMPLE_INFO DS ON R.ListSampleId = DS.ListSampleId
	LEFT JOIN QNN_Status S ON DS.Status = S.Id 
	AND S.Code = 'RC' AND S.Code = 'DE' AND S.Code = 'SB' AND S.Code = 'CL' AND S.Code = 'PR' AND S.Code = 'IE' AND S.Code = 'EM' AND S.Code = 'NI'
WHERE R.DplyId = @DplyId
GROUP BY 
DATEPART(wk, DateStart), S.Title, LSP.PropValue
ORDER BY WeekNumber ASC

END 
GO


CREATE PROCEDURE [dbo].[spSP_GetResponseAftRemovalByDplyId]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

--T.[Code] in ('RC','DE','SB','CL','CR','PR','IE','EM','NI') + ('PE') then 'Sample after removal
SELECT 
COUNT(*) AS Number
FROM QNN_DPLY_SAMPLE_INFO DS
WHERE  DS.DplyId = @DplyId AND DS.Status IN (SELECT ID FROM QNN_STATUS AS S WHERE S.Code = 'RC' OR S.Code = 'DE' OR S.Code = 'SB' OR S.Code = 'CL' OR S.Code = 'PR' OR S.Code = 'IE' OR S.Code = 'EM' OR S.Code = 'NI' OR S.Code = 'PE')


END 
GO


