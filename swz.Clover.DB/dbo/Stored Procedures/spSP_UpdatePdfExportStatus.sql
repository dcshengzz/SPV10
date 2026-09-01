CREATE   PROCEDURE [dbo].[spSP_UpdatePdfExportStatus]
    @Id             UNIQUEIDENTIFIER,
    @Status         NVARCHAR(20),
    @ErrorMessage   NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [dbo].[QNN_RESP_PDF_EXPORT]
    SET [Status] = @Status,
        [ErrorMessage] = @ErrorMessage
    WHERE [Id] = @Id;
END