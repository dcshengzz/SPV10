
CREATE PROCEDURE [dbo].[spSP_UpdateRespondentSessionTokenId]
		@SampleId uniqueidentifier,
		@TokenId VARCHAR(36)

	AS
	BEGIN
		SET XACT_ABORT, NOCOUNT ON;

		IF(@TokenId IS NOT NULL)
			MERGE RespondentSessionTokenId AS lss
			USING (SELECT @SampleId AS SampleId) AS source 
			ON lss.SampleId = source.SampleId
			WHEN MATCHED THEN
				UPDATE SET lss.LoginDate=CURRENT_TIMESTAMP, lss.TokenId=@TokenId
			WHEN NOT MATCHED THEN
				INSERT (SampleId, LoginDate, TokenId) VALUES (source.SampleId, CURRENT_TIMESTAMP, @TokenId);
		ELSE
			DELETE FROM RespondentSessionTokenId WHERE SampleId=@SampleId;

	END