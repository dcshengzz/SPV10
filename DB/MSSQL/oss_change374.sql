-- Will UPDATE existing row(s) in dwMetadata for the following:
-- RespondentParticipationReport-settings.json
-- WordCloudReport-settings.json

UPDATE [dwMetadata] SET
[Id]='6dbdbfc3-9969-4847-b2a5-3394bfa75853', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespondentParticipationReport-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-04-05 12:37:25.483', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-02 11:49:27.303', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "RespondentParticipationReport",
  "lastUpdate": "2023-01-02T11:49:27.2975558+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "20546719-949d-bbd0-9300-389938b26f54",
      "entityId": "edae2d91-a5b4-4bcb-a268-7e3c4966c532",
      "filter": "StructAsyncFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "c068911a-57b5-7873-9558-1487ab0bee11",
          "attributeId": "a0df13b1-bd63-4dfe-8200-08e11196f831",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6513cd6b-0800-6fb1-02bd-f40e0a029a45",
          "attributeId": "b362071e-92a7-4f80-8680-32d36700b061",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "23173da0-cce0-1804-7558-c3a1c19b82b5",
          "attributeId": "b6e5918b-6c76-41bd-9587-dfe2485d8b1d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e4b10d60-e9e5-37f3-a2f6-e08fe70e8a6b",
          "attributeId": "c9e2504d-934a-4589-bdae-c5ae75e386c6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d8aeb6ad-bb63-381d-6fec-6ba35cdc0a4f",
          "attributeId": "0bca6c1b-46fa-4554-b48e-fcb4bfa1a424",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "06fb3ca7-3e22-4366-5f4b-e9a888f2caff",
          "attributeId": "8f15ec99-ab32-4ada-97e5-096df1df7096",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "35967132-9c07-7389-fa50-f313e244159e",
          "attributeId": "8e115ea7-402b-4d44-b47f-b441d98c875e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b4c347e-66c4-ea2d-0efb-040a47de89ab",
          "attributeId": "41f1f4b7-c4cb-42a3-abcc-e18369d55bd9",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
    }
  ],
  "securityGroup": "Reports"
}' WHERE [Id]='6dbdbfc3-9969-4847-b2a5-3394bfa75853';

UPDATE [dwMetadata] SET
[Id]='cb7445d4-be58-41e8-8618-99630fcda5f4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'WordCloudReport-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-10-07 16:35:22.860', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-01-02 11:44:31.670', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2023-01-02T11:44:31.6582273+08:00",
  "isTemplate": false,
  "securityGroup": "Reports"
}' WHERE [Id]='cb7445d4-be58-41e8-8618-99630fcda5f4';

