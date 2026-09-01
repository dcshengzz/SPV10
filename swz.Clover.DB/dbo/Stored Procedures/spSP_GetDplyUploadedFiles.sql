CREATE PROCEDURE [dbo].[spSP_GetDplyUploadedFiles]
		@DplyId uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ra.AnsVal as Token, concat(s.UID COLLATE DATABASE_DEFAULT,'_', f.Name COLLATE DATABASE_DEFAULT, '_', 
		CONVERT(CHAR(8), uf.CreatedDate, 112) + REPLACE(CONVERT(CHAR(8), uf.CreatedDate, 108), ':', '') COLLATE DATABASE_DEFAULT,
		'_', ra.AnsVal COLLATE DATABASE_DEFAULT, 
		'_', uf.Name COLLATE DATABASE_DEFAULT) as Filename
	FROM   QNN_RESP_ANS ra
	inner join QNN_RESP r on r.Id = ra.RespId
	inner join QNN_LIST_SAMPLE ls on r.ListSampleId = ls.Id
	inner join QNN_SAMPLE s on s.Id = ls.SampleId
	inner join QNN_DPLY d on d.Id = r.DplyId
	inner join QNN_QNN_FIELD f on f.Id = ra.QnnFieldId
	inner join dwUploadedFiles uf on uf.Id = upper(dbo.StrToGuid(ra.AnsVal))
	WHERE d.Id = @DplyId and 
	f.Type = 'input' and dbo.IsFileToken(ra.AnsVal)=1
END 
