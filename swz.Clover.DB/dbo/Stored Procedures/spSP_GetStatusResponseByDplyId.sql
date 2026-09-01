--Version 1.67
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
