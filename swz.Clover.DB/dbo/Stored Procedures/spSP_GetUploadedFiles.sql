CREATE PROCEDURE [dbo].[spSP_GetUploadedFiles]
		@DplyId NVARCHAR(MAX) = null,
		@QnnId NVARCHAR(MAX) = null,
		@ListId NVARCHAR(MAX) = null,
		@SampleId NVARCHAR(MAX) = null,
		@RespId NVARCHAR(MAX) = null,
		@UploadedFilesToken NVARCHAR(MAX) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @UploadedFilesToken = COALESCE(@UploadedFilesToken + ',' + ra.AnsVal, ra.AnsVal) 
	FROM   QNN_RESP_ANS ra
	inner join QNN_RESP r on r.Id = ra.RespId
	inner join QNN_LIST_SAMPLE ls on r.ListSampleId = ls.Id
	inner join QNN_SAMPLE s on s.Id = ls.SampleId
	inner join QNN_DPLY d on d.Id = r.DplyId
	inner join QNN_QNN_FIELD f on f.Id = ra.QnnFieldId
	inner join dwUploadedFiles uf on uf.Id = upper(dbo.StrToGuid(ra.AnsVal))
	WHERE (@RespId is null or ra.RespId = @RespId) 
	AND (@DplyId is null or r.DplyId IN( SELECT Item FROM dbo.splitIds(@DplyId, ',')))
	AND (@QnnId is null or r.QnnId IN( SELECT Item FROM dbo.splitIds(@QnnId, ',')))
	AND (@ListId is null or ls.ListId IN( SELECT Item FROM dbo.splitIds(@ListId, ',')))
	AND (@SampleId is null or s.Id IN( SELECT Item FROM dbo.splitIds(@SampleId, ',')))
	AND f.Type = 'input' and dbo.IsFileToken(ra.AnsVal)=1
END 
