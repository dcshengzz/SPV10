-- AuditTrail_Copy_Existing_Data.sql
-- Last Updated: 2023-04-18

-- This script will copy existing rows from the local Auditog table to the externalised table.
-- Run this from the SurveyPlus database AFTER pointing the sy_AuditLog synonym at the externalised table.
-- (Note that this script DOES NOT drop or delete the local AuditLog table).

INSERT INTO sy_AuditLog (Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
	SELECT Id, UserId, SampleID, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId
	FROM dbo.AuditLog;