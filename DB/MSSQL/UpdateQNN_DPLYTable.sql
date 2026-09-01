ALTER TABLE dbo.QNN_DPLY
ADD SurveyName varchar(300) NOT NULL Default 'Survey';

UPDATE a
SET a.SurveyName = b.Title
FROM dbo.QNN_DPLY a
INNER JOIN dbo.QNN_QNN b
ON a.QnnId = b.Id;
