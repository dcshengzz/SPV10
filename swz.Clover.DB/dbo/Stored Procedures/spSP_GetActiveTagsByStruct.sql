
CREATE PROCEDURE [dbo].[spSP_GetActiveTagsByStruct]
	@UserStructDivisionId UNIQUEIDENTIFIER,
	@NumOfTags int
AS
BEGIN
	SET NOCOUNT ON;

	-- Get the ChildStruct from the user struct
	DECLARE @ChildrenStructDivisionIds nvarchar(MAX);
	SELECT @ChildrenStructDivisionIds = COALESCE(@ChildrenStructDivisionIds + ',' + convert(nvarchar(max),[id]),convert(nvarchar(max),[id]))  FROM [dbo].[vStructDivisionParentsAndThis] where ParentId = @UserStructDivisionId

    -- Get the tags
	SELECT TOP (@NumOfTags) Tags, COUNT(Tags) as Count FROM (
	SELECT value as Tags FROM [dbo].[QNN_DPLY] CROSS APPLY OPENJSON(Tags) WHERE [StructDivisionId] IN (SELECT Item FROM dbo.splitIds(@ChildrenStructDivisionIds, ','))
	 UNION ALL
	SELECT value as Tags FROM [dbo].[QNN_QNN] CROSS APPLY OPENJSON(Tags) WHERE [StructDivisionId] IN (SELECT Item FROM dbo.splitIds(@ChildrenStructDivisionIds, ','))
	 UNION ALL
	SELECT value as Tags FROM [dbo].[QNN_LIST] CROSS APPLY OPENJSON(Tags) WHERE [StructDivisionId] IN (SELECT Item FROM dbo.splitIds(@ChildrenStructDivisionIds, ','))
) as t
GROUP BY Tags ORDER BY count DESC
END