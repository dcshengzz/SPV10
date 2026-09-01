

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
