






--Indended mainly for use in Response Import, set certain QNN_DPLY_SAMPLE_INFO columns without an audit event
CREATE PROCEDURE [dbo].[spSP_UpdateDplySampleInfoForImport]
		@Id UNIQUEIDENTIFIER,
		@Status UNIQUEIDENTIFIER,
		@Remarks NVARCHAR(MAX)
	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;
		UPDATE QNN_DPLY_SAMPLE_INFO SET
			[Status]=@Status,
			[Remarks]=@Remarks
		WHERE
			[Id]=@Id;
	END