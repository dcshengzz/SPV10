

CREATE PROCEDURE [dbo].[spSP_GetRespondentSessionTokenId]
		@SampleId uniqueidentifier

	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		SELECT TokenId FROM RespondentSessionTokenId WHERE SampleId=@SampleId;

	END