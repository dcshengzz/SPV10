
-- ============================================================
-- Stored Procedure: spSP_LogPdfGeneration
-- Atomically checks rate limit and logs the generation request.
-- Uses DplyListSampleId for rate limiting when available (exact
-- survey instance), falls back to SampleId + FormName.
-- ============================================================
CREATE   PROCEDURE [dbo].[spSP_LogPdfGeneration]
    @SampleId           UNIQUEIDENTIFIER    = NULL,
    @DplyListSampleId   UNIQUEIDENTIFIER    = NULL,
    @RespId             UNIQUEIDENTIFIER    = NULL,
    @FormName           NVARCHAR(200),
    @SurveyName         NVARCHAR(500)       = NULL,
    @Emails             NVARCHAR(MAX)       = NULL,
    @CooldownMinutes    INT,
    @IsRateLimited      BIT                 OUTPUT,
    @Id                 UNIQUEIDENTIFIER    = '00000000-0000-0000-0000-000000000000' OUTPUT
AS
BEGIN
    SET XACT_ABORT, NOCOUNT ON;

    DECLARE @IsLimited BIT = 0;

    -- Rate limit check: prefer DplyListSampleId (exact survey instance),
    -- fall back to SampleId + FormName
    IF @DplyListSampleId IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM [dbo].[QNN_RESP_PDF_EXPORT]
            WHERE [DplyListSampleId] = @DplyListSampleId
              AND [Status] IN ('Processing', 'Failed', 'Completed')
              AND [RequestedAt] > DATEADD(MINUTE, -@CooldownMinutes, GETDATE())
        )
            SET @IsLimited = 1;
    END
    ELSE IF @SampleId IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM [dbo].[QNN_RESP_PDF_EXPORT]
            WHERE [SampleId] = @SampleId
              AND [FormName] = @FormName
              AND [Status] IN ('Processing', 'Failed', 'Completed')
              AND [RequestedAt] > DATEADD(MINUTE, -@CooldownMinutes, GETDATE())
        )
            SET @IsLimited = 1;
    END

    SET @IsRateLimited = @IsLimited;
    SET @Id = NEWID();

    INSERT INTO [dbo].[QNN_RESP_PDF_EXPORT]
        ([Id], [SampleId], [DplyListSampleId], [RespId], [FormName], [SurveyName], [Emails], [RequestedAt], [Status])
    VALUES
        (@Id, @SampleId, @DplyListSampleId, @RespId, @FormName, @SurveyName, @Emails, GETDATE(),
         CASE WHEN @IsLimited = 1 THEN 'RateLimited' ELSE 'Processing' END);
END