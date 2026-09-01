-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_RULE-settings.json

UPDATE [dwMetadata] SET
[Id]='6ccabc70-6921-4dc1-bbfd-3b1138bbbcc4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_RULE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-06-29 12:33:23.423', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-20 15:16:03.467', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_RULE",
  "lastUpdate": "2026-01-20T15:16:03.4522203+08:00",
  "entityId": "ea08b91d-a603-41a2-8396-8430ccb3f1bb",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert",
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateRequireFieldsTrigger",
      "parameter": "{Form: \"QNN_RULE\"}"
    }
  ],
  "dataMap": [
    {
      "id": "452aa6b6-9b92-900a-3547-8a378e54aaf3",
      "attributeId": "c18b92cc-d3c6-56f9-419d-acb41056f78c",
      "control": "Comments",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "afad88af-db28-d247-7821-c43d39c6093d",
      "attributeId": "250acf7c-d9fb-4738-88f9-8069b98a1ff5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "772df5ed-04ff-c7e5-d9cc-737220693e93",
      "attributeId": "2e95decc-de0f-47f7-9e2e-46ea22985ac0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5d8a9a88-f255-79fa-cad0-83be647fb54e",
      "attributeId": "3da67c4c-93fe-4ecc-b9a7-046dddad5de5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "40b5a625-6c9a-5f6e-5952-088e7f0ed9a5",
      "attributeId": "9a055a7f-4eb9-4441-8df5-b74c489e6e1a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "10810acc-812c-a8cd-d35a-3e88f9ce0288",
      "attributeId": "430e1edc-de90-4af3-9f02-effe8089800a",
      "control": "Description",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ccdc00d6-443a-c432-bb64-6a0fec5b512c",
      "attributeId": "9fff33de-bcb2-4348-a7bf-559894ac6aec",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8c0de3c7-52cc-9d0c-81fb-35c6542d320a",
      "attributeId": "4760359f-8a71-44ec-baf0-bef43ff238bf",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c6d5af00-6ac2-723b-7aee-9073bc9f8f79",
      "attributeId": "b12c7eb3-c550-4c9c-8999-4a663ee9f29d",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f3bdd25f-a4a0-a1ef-9429-afa351eb50d7",
      "attributeId": "92044df4-e4bc-45f2-b023-9d50e722297e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f736b448-581b-6fc5-e852-c959d7163c20",
      "attributeId": "640e1fee-733e-41cb-9687-2bd9bd6bcb57",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c4dba87c-e810-fd32-bac5-e5164406f6d1",
      "attributeId": "89594fdd-5dde-42af-b69d-5d3722883bef",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "622067d3-6fc2-69b5-ede8-2e587312afd8",
      "attributeId": "9192b784-b6ef-4d5e-b9bb-ebccadeed2dc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9306376e-090c-2b27-a0ba-64468aabfdb3",
      "attributeId": "765eaf26-34e9-4154-a57b-ad54564a506f",
      "control": "Validation",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Designer",
  "isArchived": false
}' WHERE [Id]='6ccabc70-6921-4dc1-bbfd-3b1138bbbcc4';

