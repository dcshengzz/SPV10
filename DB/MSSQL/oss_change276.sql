-- Will UPDATE existing row(s) in dwMetadata for the following:
-- audittrail-settings.json

UPDATE [dwMetadata] SET
[Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-08-22 17:06:51.527', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-01-05 10:38:12.583', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "AuditTrail",
  "lastUpdate": "2022-01-05T10:38:12.5444408+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "8c386b02-6069-fc74-0a3c-970cbcc4f246",
      "entityId": "508b89a2-b6fc-4631-b226-5e509b04753c",
      "filter": "UserAuditFilter",
      "control": "gridUserAuditLog",
      "dataMap": [
        {
          "id": "eaa99175-fe0c-2b55-d9fb-e99ac183c740",
          "attributeId": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96b05054-f2e2-73f2-10cd-5d5beb80324e",
          "attributeId": "dc5cabe0-1a21-45bf-aa02-6130d90ba5c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fc91b26c-6dbb-6eb8-9218-7d6d83679de5",
          "attributeId": "9a7751c0-1d71-4ba0-b947-313b2d185486",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ac32e752-a32f-f980-bcc7-faec88bf814c",
          "attributeId": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "52e11100-2bc2-9226-7ee5-85362d373cae",
          "attributeId": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "12cd7b55-290c-ad1e-a9c2-0b8340fce6ae",
          "attributeId": "e20428cd-d8c7-4510-a758-d5247006116e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d060f249-db88-077b-1d9c-ae703ee503a6",
          "attributeId": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4d8bc32-8976-8eb6-9ee0-37eea7ce980f",
          "attributeId": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "32464828-58e9-8012-af69-c4647c36ea9c",
          "attributeId": "4326e114-aa4a-4899-9302-b09ccccfdc96",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dd1d5507-525b-c4c0-dd2f-ca72ae54c1a3",
          "attributeId": "712f40f5-5b68-496d-895f-32cc4971504a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6206d655-e39c-07f3-ff1e-554f13447d4c",
          "attributeId": "085cce6d-b602-4e4c-8c37-95327f6ec027",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "21679a71-b29f-ae12-55a8-19853357daed",
          "attributeId": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "81cc9561-54fd-d16d-cb4d-5002c6f892a9",
          "attributeId": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0cd0a723-ab1d-a598-81cf-0895c3fd9acb",
          "attributeId": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0b239f88-0682-31b7-6d2c-ca7655c88de8",
          "attributeId": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f2af7af6-9443-e547-a849-4a5f564ef036",
          "attributeId": "aed660ce-7ac0-455b-830f-ec060db01be2",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true
    },
    {
      "id": "2af70ce7-2a81-303f-0645-27c8116c71df",
      "entityId": "508b89a2-b6fc-4631-b226-5e509b04753c",
      "filter": "SampleAuditFilter",
      "control": "gridSampleAuditLog",
      "dataMap": [
        {
          "id": "1b354833-97c2-181f-8caa-6ffadd8e8d1b",
          "attributeId": "b3a898e2-cca9-4a30-90d5-b5397b5034fe",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "55c9fe05-c72f-52ae-99f3-d07eb82dec0a",
          "attributeId": "dc5cabe0-1a21-45bf-aa02-6130d90ba5c8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3683815b-0de9-da78-cfbf-39a4a62dceac",
          "attributeId": "9a7751c0-1d71-4ba0-b947-313b2d185486",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cbb3b615-d10f-4b1c-5dfd-582c194b7cbd",
          "attributeId": "1ac356f8-0c77-4a00-8fcc-ffbf830ad2b1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d1484c68-9635-e627-104f-41f3bfd69690",
          "attributeId": "401c01d5-217a-4b1d-9a79-3e902fd4b592",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d74db16e-c049-3d40-13e0-45967f8c40d4",
          "attributeId": "e20428cd-d8c7-4510-a758-d5247006116e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b1a5572d-9643-b53b-149b-a075f7bb3e88",
          "attributeId": "9acca696-5c7e-46ab-ad6e-a587ad0ed6af",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "33974948-1282-6b5d-4926-c6fa23ba23b9",
          "attributeId": "25a5e4d4-1e7b-4cb8-b236-267d47883e5e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "39ddd3dd-0d83-1b49-910d-6ac9cf6489d4",
          "attributeId": "4326e114-aa4a-4899-9302-b09ccccfdc96",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99c873b5-6fd4-d92f-d658-253abed0406c",
          "attributeId": "712f40f5-5b68-496d-895f-32cc4971504a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7231c5a7-b2f7-017b-d1d9-14e6151ed1cf",
          "attributeId": "085cce6d-b602-4e4c-8c37-95327f6ec027",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "81c2f6f1-0127-c3df-c983-7c2293a813f5",
          "attributeId": "6cd70bae-93b3-4fb2-9298-1f45eb9de551",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "01eccec3-2be0-a477-1e88-e98e44381f37",
          "attributeId": "b2eb8d39-95c4-490b-b8fc-216cd507128a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "51850924-7e34-7edd-83d8-145891a7d1b1",
          "attributeId": "d6ad4d6a-fb9b-4ac4-81c0-7c90a9b5c250",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7b92cb6b-899e-5672-4a57-d85487574f21",
          "attributeId": "a32fd8cb-fed5-40cf-86ad-2e4c2c12c6a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bce85eb2-fd34-9947-9ff3-20df91cde1ac",
          "attributeId": "aed660ce-7ac0-455b-830f-ec060db01be2",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": true
    }
  ],
  "securityGroup": "Audit"
}' WHERE [Id]='821d5319-793c-4b0e-aa09-6af302b3a6fd';

