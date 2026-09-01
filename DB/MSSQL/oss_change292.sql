-- Will UPDATE existing row(s) in dwMetadata for the following:
-- UserAccessMatrix-settings.json

UPDATE [dwMetadata] SET
[Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.310', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-04-01 16:42:29.260', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2022-04-01T16:42:29.2494479+08:00",
  "isTemplate": false,
  "securityGroup": "UserAdmin"
}' WHERE [Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d';

