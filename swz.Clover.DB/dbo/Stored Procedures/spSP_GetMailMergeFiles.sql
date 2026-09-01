

CREATE PROCEDURE [dbo].[spSP_GetMailMergeFiles]
		@DplyId NVARCHAR(MAX) = null, --comma delimited list of dplyId
		@UploadedFilesToken NVARCHAR(MAX) OUTPUT --will be appended if not null
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;

	-- MergeOutputToken (the message template)
	SELECT 
		@UploadedFilesToken = COALESCE(@UploadedFilesToken + ',' + m.MergeOutputToken, m.MergeOutputToken) 
	FROM
		dbo.SplitIds(@DplyId,',') AS d
		INNER JOIN QNN_DPLY_MSG m ON (d.Item=m.DplyId AND m.MergeOutputToken IS NOT NULL)
		INNER JOIN dwUploadedFiles duf ON dbo.StrToGuid(m.MergeOutputToken)=duf.Id;

	-- GenerateProfileOutputToken (the generated profile csv)
	SELECT 
		@UploadedFilesToken = COALESCE(@UploadedFilesToken + ',' + m.GenerateProfileOutputToken, m.GenerateProfileOutputToken) 
	FROM
		dbo.SplitIds(@DplyId,',') AS d
		INNER JOIN QNN_DPLY_MSG m ON (d.Item=m.DplyId AND m.GenerateProfileOutputToken IS NOT NULL)
		INNER JOIN dwUploadedFiles duf ON dbo.StrToGuid(m.GenerateProfileOutputToken)=duf.Id;
END