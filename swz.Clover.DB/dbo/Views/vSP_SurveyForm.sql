CREATE VIEW [dbo].[vSP_SurveyForm] AS 
SELECT 
    LEFT(m.Filename, LEN(m.Filename)-14) AS Id,
    LEFT(m.Filename, LEN(m.Filename)-14) AS [Name],
    m.StructDivisionId,
    ISNULL(JSON_VALUE(m.Data, '$.isArchived'), 'false') AS IsArchived
FROM dwMetadata m
WHERE 
    Folder = 'metadata/forms'
    AND RIGHT(m.Filename, 14) = '-settings.json'
    AND IsDeleted = 0
    AND m.Data LIKE '%"isSurvey": true%'
    AND m.Data LIKE '%"isTemplate": false%';
