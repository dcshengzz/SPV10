

CREATE PROCEDURE [dbo].[CleanupSamlRecentAssertion]
AS
BEGIN
    SET XACT_ABORT, NOCOUNT ON;
    DELETE FROM SamlRecentAssertion WHERE Expiration < GETUTCDATE(); --Note this is a UTC date
END