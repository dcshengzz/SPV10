


CREATE PROCEDURE [dbo].[spSP_GetMonthlyAccessLogs] 
	@StartDate DATE, --inclusive
	@EndDate DATE --exclusive
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;

	SELECT 
		EventDate AS [Date], 
		UserName AS [User Name], 
		UID AS [Sample UID] , 
		SampleName AS [Sample Name], 
		EventBatch as [BatchJob ID],  
		EventType AS [Event Type], 
		TableName AS [Table Name], 
		ColumnName AS [Field Modified], 
		OriginalValue AS [Original Value], 
		NewValue AS [New Value]
	FROM 
		sySP_vSP_auditLog 
	WHERE 
		EventDate >= @StartDate AND EventDate < @EndDate
		AND (
			EventType IN ('Login','LogOff','LoginFailed')
			OR TableName IN (
				'SecurityUser', 'dwSecurityUser',
				'dwSecurityGroup', 'SecurityGroup',
				'dwSecurityGroupToSecurityRole', 'SecurityGroupToSecurityRole',
				'dwSecurityGroupToSecurityUser', 'SecurityGroupToSecurityUser',
				'dwSecurityPermission', 'SecurityPermission',
				'dwSecurityPermissionGroup', 'SecurityPermissionGroup',
				'dwSecurityRole', 'SecurityRole',
				'dwSecurityRoleToSecurityPermission', 'SecurityRoleToSecurityPermission',
				'dwSecurityUserToSecurityRole', 'SecurityUserToSecurityRole'))
	ORDER BY 
		EventDate ASC;
END