USE [surveyplus.net1612]
GO

UPDATE [dbo].[QNN_DPLY_SAMPLE_INFO]
   SET 
      [Status] = 'A3D01086-40FC-4A7A-BF0C-DE17BDD205FA'
        WHERE Status is null
GO

SELECT * 
FROM  [dbo].[QNN_DPLY_SAMPLE_INFO]

  WHERE Status is null