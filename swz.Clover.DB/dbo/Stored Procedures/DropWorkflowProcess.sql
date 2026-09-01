CREATE PROCEDURE [dbo].[DropWorkflowProcess]
		@id uniqueidentifier
	AS
	BEGIN
		BEGIN TRAN

		DELETE FROM dbo.WorkflowProcessInstance WHERE Id = @id
		DELETE FROM dbo.WorkflowProcessInstanceStatus WHERE Id = @id
		DELETE FROM dbo.WorkflowProcessInstancePersistence  WHERE ProcessId = @id

		COMMIT TRAN
	END
