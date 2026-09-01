

CREATE PROCEDURE [dbo].[InsertSamlRecentAssertion]
    @AssertionID NVARCHAR(128),
    @Expiration DATETIME,
    @Success BIT OUTPUT
AS
BEGIN
	--Note that we specifically *don't* set XACT_ABORT here (because the violation
	--we catch would doom the parent tx, if any)
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO [SamlRecentAssertion] ([AssertionID], [Expiration])
        VALUES (@AssertionID, @Expiration);
        SET @Success = 1;
    END TRY
    BEGIN CATCH
        -- 2627: Primary Key Violation
        -- 2601: Unique Index Violation
        IF ERROR_NUMBER() IN (2627, 2601)
        BEGIN
            SET @Success = 0;
        END
        ELSE
        BEGIN            
            ;THROW;
        END
    END CATCH
END