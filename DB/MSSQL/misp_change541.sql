-- misp_change541.sql
-- Specifically for MISP instances of SurveyPlus:
-- Update NULL values in IsIncludeUnansweredSection QNN_DPLY.Is for MISP to the MISP default of true,
-- this will leave no null values for change532.sql to find.
--
-- WARNING: If the default value of IsIncludeUnansweredSection in MISP Intranet appsettings is not true
--          (i.e. it's been changed to false) then do not run this script!

UPDATE QNN_DPLY 
		SET [IsIncludeUnansweredSection]=1 
		WHERE [IsIncludeUnansweredSection] IS NULL;
