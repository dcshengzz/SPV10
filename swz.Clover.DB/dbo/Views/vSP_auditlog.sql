





CREATE VIEW [dbo].[vSP_auditlog]
AS 
--Note that in metadata.json this is mapped indirectly via synonym sySP_vSP_AuditLog
--The metadata continues to name it vSP_auditlog, but the DB Object is sySP_vSP_AuditLog
--Take note when updating
	SELECT 
		al.Id, 
		al.UserId, 
		al.SampleId, 
		al.EventBatch,
		al.EventDate,
		al.EventType,
		al.TableName,
		al.RecordId,
		al.ColumnName, 
		al.OriginalValue,
		al.NewValue,
		al.StructDivisionId,
		NULLIF(asn.UID,'') AS [UID],
		NULLIF(asn.Name,'') AS [SampleName],
		NULLIF(aun.Name,'') AS [UserName],
		NULLIF(adn.Name,'') AS [Division]
	FROM
		sy_AuditLog al
		INNER JOIN dbo.AuditUserName aun ON ISNULL(al.UserId,'00000000-0000-0000-0000-000000000000') = aun.UserId
		INNER JOIN dbo.AuditSampleName asn ON ISNULL(al.SampleId,'00000000-0000-0000-0000-000000000000') = asn.SampleId
		INNER JOIN dbo.AuditDivisionName adn ON ISNULL(al.StructDivisionId,'00000000-0000-0000-0000-000000000000') = adn.StructDivisionId;

GO


