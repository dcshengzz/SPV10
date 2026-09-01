CREATE PROCEDURE [dbo].[spSP_GetDplyUploadedFilesDataCollection]
		@DplyId NVARCHAR(50),
		@StatusList NVARCHAR(300),
		@QnnId NVARCHAR(300)
AS
BEGIN
	SET NOCOUNT ON;

	IF NULLIF(@StatusList, '') IS NULL
	BEGIN
		set @StatusList = NULL
	END

	SELECT ra.AnsVal as Token, concat(s.UID COLLATE DATABASE_DEFAULT, '_', ra.AnsVal COLLATE DATABASE_DEFAULT,'_',uf.Name COLLATE DATABASE_DEFAULT) as Filename
	FROM   QNN_RESP_ANS ra
	inner join QNN_RESP r on r.Id = ra.RespId
	inner join QNN_LIST_SAMPLE ls on r.ListSampleId = ls.Id
	inner join QNN_SAMPLE s on s.Id = ls.SampleId
	inner join QNN_DPLY d on d.Id = r.DplyId
	inner join QNN_QNN_FIELD f on f.Id = ra.QnnFieldId
	inner join dwUploadedFiles uf on uf.Id = upper(dbo.StrToGuid(ra.AnsVal))
	inner join qnn_dply_sample_info si on si.ListSampleId = ls.Id and si.DplyId = r.DplyId
	left join dwSecurityUser u on u.Id = r.UserId
	left join qnn_status status on status.Id = si.Status
	WHERE r.DplyId = @DplyId and r.QnnId=@QnnId
	and f.Type = 'input' and dbo.IsFileToken(ra.AnsVal)=1
	and (@StatusList is null or si.Status in (@StatusList))
END 
