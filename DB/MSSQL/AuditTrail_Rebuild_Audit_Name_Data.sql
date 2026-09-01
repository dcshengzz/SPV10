-- AuditTrail_Rebuild_Audit_Name_Data.sql
-- Last Updated 2023-04-18

-- Script to rebuild the data in the AuditSampleName, AuditUserName, AuditDivisionName tables
-- based on the existing data in the AuditLog, QNN_SAMPLE, dwSecurityUser, StructDivision tables.
-- This should be run from the SURVEYPLUS DATABASE *after* the audit table synonyms have been pointed
-- to the appropriate tables (either local or externalised as desired for the installation environment)
-- Note that this script will write to the name table synonyms but pulls its data directly from the local
-- SurveyPlus database it is running in.

DELETE FROM sy_AuditSampleName;
INSERT INTO sy_AuditSampleName (SampleId, Name, UID)
	SELECT DISTINCT COALESCE(al.SampleId, qs.Id) AS SampleId, COALESCE(qs.Name,'DELETED SAMPLE') AS Name, COALESCE(qs.UID,'') AS UID
	FROM
	AuditLog al FULL OUTER JOIN QNN_SAMPLE qs ON al.SampleId=qs.Id
	WHERE NOT (qs.Id IS NULL AND al.SampleId IS NULL);	

DELETE FROM sy_AuditUserName;
INSERT INTO sy_AuditUserName (UserId, Name)
	SELECT DISTINCT COALESCE(al.UserId,su.Id) AS UserId, COALESCE(su.Name,'DELETED USER') AS Name
		FROM 
		AuditLog al FULL OUTER JOIN dwSecurityUser su ON al.UserId=su.Id
		WHERE NOT (su.Id IS NULL AND al.UserID IS NULL);

DELETE FROM sy_AuditDivisionName;
INSERT INTO sy_AuditDivisionName
	SELECT DISTINCT COALESCE(al.StructDivisionId, sd.Id) AS StructDivisionId, COALESCE(sd.Name,'DELETED ORGANISATION') AS Division
	FROM
	AuditLog al FULL OUTER JOIN StructDivision sd ON al.StructDivisionId=sd.Id
	WHERE NOT (sd.Id IS NULL AND al.StructDivisionId IS NULL);