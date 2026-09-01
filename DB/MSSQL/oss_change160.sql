ALTER TABLE [dbo].[QNN_GLOBAL_MSG]
    ADD [IsTargetUsers] BIT NULL;
	
GO

Update [dbo].[QNN_GLOBAL_MSG]
SET IsTargetUsers = 0 
WHERE IsTargetUsers is null