
CREATE PROCEDURE [dbo].[spSP_GetWeeklyActiveResponseByDplyId]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

--Active Statuses  ('RC','DE','SB','CL','CR','PR','IE','EM','NI') then 'Active'
--Check DatePart start from the day or every 7days
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
