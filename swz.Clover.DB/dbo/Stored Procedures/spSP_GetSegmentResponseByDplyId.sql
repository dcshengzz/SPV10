
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
                 when T.[Code] in ('RC','DE','SB','CL','CR') then 'Responded'
            when T.[Code] in ('CO','DM','SO','NI','BO') then 'BouncedAndInActive' --Correct
			when T.[Code] in ('PE', NULL,'PR','IE','EM','NI') then 'Others' --
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
ORDER BY Segment ASC, Group_name ASC
END 

--Old method, keep incase

/****** Object:  StoredProcedure [dbo].[spSP_GetSegmentByDplyId]    Script Date: 28/2/2020 12:50:58 AM ******/
SET ANSI_NULLS ON
