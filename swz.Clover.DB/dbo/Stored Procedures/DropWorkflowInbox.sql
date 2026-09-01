CREATE PROCEDURE [dbo].[DropWorkflowInbox]
		@processId uniqueidentifier
	AS
	BEGIN
		BEGIN TRAN
		DELETE FROM dbo.WorkflowInbox WHERE ProcessId = @processId
		COMMIT TRAN
	END
