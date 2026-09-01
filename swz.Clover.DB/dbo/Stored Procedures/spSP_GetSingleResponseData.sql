

--pure, unrefined, answers
CREATE PROCEDURE [dbo].[spSP_GetSingleResponseData] 
		@RespId uniqueidentifier
	AS
BEGIN
	SELECT
		a.QnnFieldId AS QnnFieldId,
		a.AnsVal AS AnsVal,
		a.Id AS Id
	FROM
		QNN_RESP_ANS a
	WHERE
		a.RespId = @respId;
END