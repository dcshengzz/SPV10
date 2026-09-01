-- Will UPDATE existing row(s) in dwMetadata for the following:
-- ListImportEmailTemplate.json
-- ListImportEmailTemplate-settings.json
-- ListImportEmailErrorTemplate.json
-- ListImportEmailErrorTemplate-settings.json

UPDATE [dwMetadata] SET
[Id]='55980b24-b22c-446e-b00f-65b71e52ce7b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ListImportEmailTemplate.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-07 16:14:10.503', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-21 18:37:28.340', 
[Data]=N'[
  {
    "key": "subject",
    "data-buildertype": "staticcontent",
    "content": "List \"{ListName}\" Import Result",
    "isHtml": true
  },
  {
    "key": "container_1",
    "data-buildertype": "container"
  },
  {
    "key": "body",
    "data-buildertype": "staticcontent",
    "content": "<style>\ntable, th, td {\n  border: 1px solid black;\n  border-collapse: collapse;\n}\nth, td{\ntext-align:left;\n}\n</style>\n\nDear {Name},<br>\n<p>\nList \"{ListName}\" import has completed.<br>\nTotal Rows                   : {TotalRows}.<br>\nSample Updated      : {SampleUpdated}.<br>\nSample Added           : {SampleAdded}.<br>\nSample Duplicated : {SampleDuplicated}.<br>\nError Count                : {ErrorCount}.<br>\n{ErrorSummary}<br>\n</p>\n\n<p>\nImport job duration was about {DurationMinutes} minutes.\n</p>\n\n<p>\nRegards\n</p>\n",
    "isHtml": true
  }
]' WHERE [Id]='55980b24-b22c-446e-b00f-65b71e52ce7b';

UPDATE [dwMetadata] SET
[Id]='d4f7bf00-590e-46d6-a3fb-3e727275ab5f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ListImportEmailTemplate-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-07 16:14:11.097', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-21 18:37:28.393', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "ListImportEmailTemplate",
  "lastUpdate": "2024-07-21T18:37:28.383647+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": []
}' WHERE [Id]='d4f7bf00-590e-46d6-a3fb-3e727275ab5f';

UPDATE [dwMetadata] SET
[Id]='c02c4b95-fcb7-4404-a992-2118d1e68279', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ListImportEmailErrorTemplate.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-08 10:16:39.457', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-21 18:42:29.787', 
[Data]=N'[
  {
    "key": "subject",
    "data-buildertype": "staticcontent",
    "content": "List \"{ListName}\" Import Result",
    "isHtml": true
  },
  {
    "key": "container_1",
    "data-buildertype": "container"
  },
  {
    "key": "body",
    "data-buildertype": "staticcontent",
    "content": "Dear {Name},<br>\n<p>\nList \"{ListName}\" import did not complete successfully.<br>\nPlease approach system administrator for more info.<br>\n</p>\n\n<p>\nImport job ran for about {DurationMinutes} minutes.\n</p>\n\n<p>\nRegards\n</p>\n",
    "isHtml": true
  }
]' WHERE [Id]='c02c4b95-fcb7-4404-a992-2118d1e68279';

UPDATE [dwMetadata] SET
[Id]='f104b2f1-6247-4fa8-b94f-ce340b847c6e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ListImportEmailErrorTemplate-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-08 10:16:39.930', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-21 18:42:29.830', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2024-07-21T18:42:29.8304799+08:00",
  "isTemplate": false
}' WHERE [Id]='f104b2f1-6247-4fa8-b94f-ce340b847c6e';

