-- AuditTrail_Initialise_Default_Local_Synonyms.sql
-- Last updated 2023-04-14

-- Recreate the synonyms to local audit tables in the same database (the default setup)

DROP SYNONYM IF EXISTS sy_AuditLog;
CREATE SYNONYM sy_AuditLog FOR dbo.AuditLog;

DROP SYNONYM IF EXISTS sy_AuditSampleName;
CREATE SYNONYM sy_AuditSampleName FOR dbo.AuditSampleName;

DROP SYNONYM IF EXISTS sy_AuditUserName;
CREATE SYNONYM sy_AuditUserName FOR dbo.AuditUserName;

DROP SYNONYM IF EXISTS sy_AuditDivisionName;
CREATE SYNONYM sy_AuditDivisionName FOR dbo.AuditDivisionName;

DROP SYNONYM IF EXISTS sySP_vSP_AuditLog;
CREATE SYNONYM sySP_vSP_AuditLog FOR dbo.vSP_AuditLog;
