


CREATE PROCEDURE [dbo].[spSP_GetAllSampleUid]
		
AS
BEGIN
	SET NOCOUNT ON;

	--Get ALL the Id and UID except the placeholder empty one (regardless of StructDivisionId)
	SELECT [Id],[UID] FROM QNN_SAMPLE WHERE [Id]<>'00000000-0000-0000-0000-000000000000';

END