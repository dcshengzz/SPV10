
CREATE PROCEDURE [dbo].[spSP_GetRespAnsRows] 
	@RespId UNIQUEIDENTIFIER,
	@LastSavedPage NVARCHAR(255) OUTPUT,
	@NumberId INT OUTPUT
AS
BEGIN
	SELECT @LastSavedPage=LastSavedPage, @NumberId=NumberId FROM QNN_RESP WHERE Id=@RespId;
		
	SELECT 
		f.[Name],
		a.AnsVal,
		a.IsPrePopulated
	FROM
		QNN_RESP_ANS a
		LEFT JOIN QNN_QNN_FIELD f ON f.Id=a.QnnFieldId
	WHERE
		a.RespId=@RespId
	;
END