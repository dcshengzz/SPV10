-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_SAMPLE.json
-- QNN_SAMPLE-settings.json

UPDATE [dwMetadata] SET
[Id]='6b16fa37-61d8-43a9-a851-558d889ca9c9', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 16:41:54.567', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-11 16:09:41.910', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "{entityState} Sample",
        "size": "huge",
        "subheader": ""
      },
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "fg_CoreProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "style-source": "border: 1px solid black;\npadding: 20px;",
                "children": [
                  {
                    "key": "header_CoreProperties",
                    "data-buildertype": "header",
                    "content": "Core Sample Properties",
                    "size": "small",
                    "textAlign": "left",
                    "subheader": "(The core sample properties are global for the sample across all organisations and lists in the system. Sample identity is based on UID.)"
                  },
                  {
                    "key": "Name",
                    "data-buildertype": "input",
                    "label": "Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-required": true,
                    "events": {},
                    "style-width": "400px"
                  },
                  {
                    "key": "UID",
                    "data-buildertype": "input",
                    "label": "UID (Identifies Samples, globally unique across all organisations in the application)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "events": {},
                    "other-readOnlyConition": "data.Id",
                    "other-required": true,
                    "style-width": "250px"
                  },
                  {
                    "key": "Pwd",
                    "data-buildertype": "input",
                    "label": "Password",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "events": {},
                    "other-visibleConition": "CloverApp.API.checkRole(''Admins'')==true || !data.Id",
                    "reference": "Password",
                    "type": "password",
                    "other-customValidation": "(/^[a-zA-Z0-9]{12,100}$/.test(value)  || (CloverApp.API.checkRole(''Admins'')==false && data.Id))?true:\"must contain alphanumeric characters only; password must be between 12 and 100 characters!\"",
                    "style-width": "400px"
                  },
                  {
                    "key": "btnResetPassword",
                    "data-buildertype": "button",
                    "content": "Send Password Reset Link",
                    "primary": false,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "resetPassword"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id",
                    "compact": true
                  },
                  {
                    "key": "NumRetry",
                    "data-buildertype": "input",
                    "label": "NumRetry",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "defaultValue": "0",
                    "other-required": true,
                    "reference": "NumRetry",
                    "type": "number",
                    "other-visibleConition": "data.Id",
                    "events": {},
                    "style-width": "100px"
                  },
                  {
                    "key": "LastLoginDate",
                    "data-buildertype": "input",
                    "label": "Last Login Date",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "defaultValue": "",
                    "other-required": false,
                    "reference": "Last Login Date",
                    "type": "datetime",
                    "other-visibleConition": "data.Id",
                    "events": {},
                    "readOnly": true
                  },
                  {
                    "key": "ActiveYN",
                    "data-buildertype": "checkbox",
                    "label": "Active",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "resetNumRetry"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "PwdResetYN",
                    "data-buildertype": "checkbox",
                    "label": "Change Password at First Login",
                    "toggle": true
                  }
                ],
                "events": {},
                "style-width": "500px"
              }
            ],
            "style-float": "left",
            "style-marginBottom": "20px",
            "style-marginRight": "20px"
          },
          {
            "key": "container_4",
            "data-buildertype": "container",
            "style-float": "",
            "children": [
              {
                "key": "formgroup_MappedOrganisations",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "MappedOrganisations",
                    "data-buildertype": "collectioneditor",
                    "idField": "Id",
                    "parentIdField": "ParentId",
                    "columns": [
                      {
                        "key": "StructDivisionName2",
                        "name": "Mapped Organisations",
                        "control": "span"
                      }
                    ],
                    "readOnly": true,
                    "disableDelete": true,
                    "disableAdd": true,
                    "other-visibleConition": "",
                    "style-width": "",
                    "header": false,
                    "style-source": ""
                  }
                ],
                "orientation": "grouped",
                "style-source": "padding: 20px;\nborder: 1px solid black;",
                "style-width": "100%"
              }
            ],
            "style-marginBottom": "20px",
            "other-visibleConition": "data.Id!=null",
            "style-source": "display:flex",
            "style-width": "250px"
          },
          {
            "key": "container_7",
            "data-buildertype": "container",
            "style-float": "",
            "children": [
              {
                "key": "formgroup_2",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "header_3",
                    "data-buildertype": "header",
                    "content": "Remarks",
                    "size": "small",
                    "textAlign": "left",
                    "subheader": "(Remarks are specific to an organisation but shared across sample lists)"
                  },
                  {
                    "key": "OrganisationRemarks",
                    "data-buildertype": "collectioneditor",
                    "idField": "Id",
                    "parentIdField": "ParentId",
                    "columns": [
                      {
                        "key": "StructDivisionName3",
                        "name": "Organisation",
                        "control": "span",
                        "width": "150px"
                      },
                      {
                        "key": "Remarks",
                        "name": "Remarks",
                        "control": "textarea",
                        "width": "100%"
                      }
                    ],
                    "readOnly": false,
                    "disableDelete": true,
                    "disableAdd": true,
                    "other-visibleConition": "",
                    "style-width": "",
                    "header": false,
                    "other-customValidation": "qnn_sampleUserActions.validateOrganisationRemarks(value)",
                    "events": {}
                  }
                ],
                "orientation": "grouped",
                "style-source": "padding: 20px;\nborder: 1px solid black;",
                "style-width": "100%"
              }
            ],
            "style-marginBottom": "20px",
            "other-visibleConition": "data.Id!=null",
            "style-source": "display:flex"
          },
          {
            "key": "fg_AddressBook",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "style-source": "clear:both;\nborder: 1px solid black;\npadding: 20px;",
            "children": [
              {
                "key": "header_AddressBook",
                "data-buildertype": "header",
                "content": "Address Book",
                "size": "small",
                "textAlign": "left",
                "subheader": "(Properties that are specific to an organisation but shared across sample lists. Multiple email addresses may be separated by commas)"
              },
              {
                "key": "AddressBook",
                "data-buildertype": "collectioneditor",
                "idField": "Id",
                "parentIdField": "ParentId",
                "columns": [
                  {
                    "key": "StructDivisionName",
                    "name": "Organisation",
                    "control": "span"
                  },
                  {
                    "key": "ToEmails",
                    "name": "To Emails",
                    "control": "textarea",
                    "width": ""
                  },
                  {
                    "key": "CcEmails",
                    "name": "CC Emails",
                    "control": "textarea",
                    "width": ""
                  },
                  {
                    "key": "AddressLine1",
                    "name": "Address Line 1",
                    "control": "textarea"
                  },
                  {
                    "name": "Address Line 2",
                    "key": "AddressLine2",
                    "control": "textarea"
                  },
                  {
                    "key": "AddressLine3",
                    "name": "Address Line 3",
                    "control": "textarea"
                  }
                ],
                "header": true,
                "disableAdd": true,
                "disableDelete": true,
                "other-customValidation": "qnn_sampleUserActions.validateAddressBook(value)",
                "layoutOption": "vertical"
              }
            ],
            "other-visibleConition": "data.Id != null",
            "style-marginTop": "20px"
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_2",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnSave",
                    "data-buildertype": "button",
                    "content": "Save",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "validate",
                          "customSave"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true,
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "btnExit",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirect"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "target",
                            "value": "/form/swzsamplelist"
                          }
                        ]
                      }
                    },
                    "primary": false,
                    "secondary": true
                  }
                ],
                "style-float": "left",
                "style-marginBottom": "20px"
              }
            ],
            "style-source": "clear:both;",
            "style-marginTop": "20px",
            "style-marginBottom": "20px",
            "style-width": "100%"
          }
        ]
      }
    ]
  },
  {
    "key": "divModal",
    "data-buildertype": "container",
    "children": [
      {
        "key": "errorModal",
        "data-buildertype": "swzmodal",
        "content": "errorModal",
        "style-display": "block",
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "System Message",
                "size": "medium",
                "style-source": "font-family: Lato,''Helvetica Neue'',Arial,Helvetica,sans-serif;\npadding-bottom: 1.5rem;\ncolor: rgba(0,0,0,.85);\nborder-bottom: 1px solid rgba(34,36,38,.15);"
              },
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "{ErrorText}",
                "style-customcss": "content",
                "style-source": "word-wrap: normal;\nleft-margin: auto; right-margin: auto;"
              },
              {
                "key": "container_6",
                "data-buildertype": "container",
                "style-width": "100%",
                "style-source": "clear: both;\npadding: 20px;",
                "children": [
                  {
                    "key": "btn_cancelErrorModal",
                    "data-buildertype": "button",
                    "content": "OK",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "cancelModal"
                        ],
                        "targets": [
                          "errorModal"
                        ],
                        "parameters": []
                      }
                    },
                    "primary": true,
                    "floated": "right"
                  }
                ]
              }
            ]
          }
        ]
      }
    ],
    "style-hidden": true
  }
]' WHERE [Id]='6b16fa37-61d8-43a9-a851-558d889ca9c9';

UPDATE [dwMetadata] SET
[Id]='22cdf459-84e7-4174-a19b-79618f6f383b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 16:41:54.853', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-11 16:09:42.050', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_SAMPLE",
  "lastUpdate": "2026-01-11T16:09:42.0401196+08:00",
  "entityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{NumRetry: 0, CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\"}"
    },
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "EncryptPasswordAsyncTrigger",
      "parameter": "{BeforeUpdateTrigger: \"0\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "EncryptPasswordAsyncTrigger",
      "parameter": "{BeforeUpdateTrigger: \"1\"}"
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
        "AfterSelect"
      ],
      "codeAction": "DecryptPasswordAsyncTrigger"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertSampleStructDivisionAsync"
    },
    {
      "triggers": [
        "AfterInsert",
        "AfterUpdate"
      ],
      "codeAction": "SyncAuditSampleNameAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertSampleAddressAsync"
    },
    {
      "triggers": [
        "BeforeUpdate",
        "AfterNew"
      ],
      "codeAction": "ValidateQnnSampleTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "68025520-09f5-8e87-de8a-d02b755a2e17",
      "attributeId": "e9ee47ca-3a33-42de-54e8-f98a5323d26d",
      "control": "LastLoginDate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "edc7e5b8-3583-18b9-c627-cf5e7cb86f24",
      "attributeId": "011a70db-a5ae-4019-a9ac-4c167d60bbb0",
      "control": "ActiveYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1a49787b-ba63-68a2-17b3-36da7da2cf2a",
      "attributeId": "63a7a61b-6248-4197-8d08-3fc85ff686ba",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fbdffc8e-e317-f0d7-53b4-04aa30f76d98",
      "attributeId": "be7d893d-9d5d-4c1e-a3e7-b04e13a5c303",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8ff7b685-f4d8-fb31-e481-f56b2789e4c3",
      "attributeId": "3cb554ec-8497-4513-93c5-58769fe5231c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3f1f58c5-4e1c-2f43-7ff3-5f26b5cc9a98",
      "attributeId": "8778e5f8-94eb-438f-bfd5-36ede705a05b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3c3d5589-a4b2-5a16-3334-24c619fbcdcc",
      "attributeId": "96143a54-6881-4bfe-947e-39e6ab7fd935",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a6cb92af-19df-2766-c04e-b94f1f078fe0",
      "attributeId": "b22a30c4-696c-4ced-aa4a-22620b16a884",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c2e8cc4b-66f9-f92f-4eb3-55a05b13914b",
      "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5cf2cb99-c2d4-d091-a37f-d857b1273fa6",
      "attributeId": "1b3705b9-e1de-401c-996e-c7c9ac10366a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7435cf97-3c62-30f1-4a23-4d823c702644",
      "attributeId": "ac3c5076-a671-43d0-bab9-d50d339598a9",
      "control": "NumRetry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "73ab14d4-d93e-6287-ffff-59e47491846d",
      "attributeId": "a02ab42a-6f9c-4a9d-8112-3cc7eae2a5fc",
      "control": "Pwd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "eae93866-4ae7-aec2-c89b-b10233e2beb9",
      "attributeId": "700091f4-476a-440a-bc17-ab5351fa461b",
      "control": "PwdResetYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f467544-177f-9368-48bd-501792ae1096",
      "attributeId": "a7440614-efc1-454a-8ff7-cc29764ad271",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e4ad5c54-eea6-5a18-b8d2-878a742ef438",
      "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c37738de-03a7-9b0e-cce8-db6ac0994dd1",
      "attributeId": "96609d0c-c7fc-4fcb-816b-cde87a1e5de3",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "acf1b3ba-ad4d-ed4a-62a8-145645ae5a31",
      "attributeId": "791dc4a1-5ee5-4550-88d4-56ff82d0d867",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8376408e-eb50-67e7-5260-eb9d677237eb",
      "attributeId": "c50309ed-78cf-4601-b861-a0e8c43f8ba3",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "1318a691-79c2-4d23-9e4b-29748cfe2ff1",
      "entityId": "48188aea-bf3d-45fe-8173-51f409497771",
      "filter": "SampleMappingsFilter",
      "control": "AddressBook",
      "dataMap": [
        {
          "id": "1575a53e-84b0-3e34-8ea6-c192ea46933e",
          "attributeId": "dcc822c9-1fa5-4d21-8eec-aebf01b6189d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f2df8051-7024-380e-a942-bd8927f94542",
          "attributeId": "c2ed800c-0cd5-4a76-adce-e315b65bf765",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8a524894-339d-42eb-d3a3-713f72652afd",
          "attributeId": "f619adde-1faa-4560-94ef-0e83714e067c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f44ea9c9-be98-6084-d54e-f764fb3826b7",
          "attributeId": "68dd7da4-94ed-4401-9895-e22c3d8a8e71",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c99f6ad7-92ea-be32-feb7-0271416cb489",
          "attributeId": "c6a061e3-229c-462d-90e2-35acfc735fd8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c8530355-fb19-cc2b-bd1f-9775a18f2f5f",
          "attributeId": "8e081f3f-77f3-49ec-9388-77edd594c8dc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "101039a7-efdf-c1ab-b831-4556b4d2a7bd",
          "attributeId": "eacf1752-f109-4c4d-8219-1932c08c467c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e8e9692e-ca00-25ef-432e-c1f11bd2d7ca",
          "attributeId": "01ec6849-8f6d-4d77-98a1-3c9cad29afb6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ab4ce3bd-56f3-f6c9-a4de-3248949e0b71",
          "attributeId": "91cf943b-610e-40a0-aa88-2910fb679c27",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5751a653-a7be-f416-a99e-f434986ad28d",
          "attributeId": "df70459b-50df-48ae-9f54-53a35cc60414",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "126319e1-ddfd-da00-c7d1-f920b3f0c14e",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionName",
          "parentId": "5751a653-a7be-f416-a99e-f434986ad28d",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "90ee21ac-e8c2-9870-5755-9ff255e468af",
          "attributeId": "5958b446-a320-41b6-8a09-bfb1bddf8429",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "79185a8f-10a4-545e-f740-89a83cef7529",
          "attributeId": "439de409-d7af-45df-b742-fb94059a4208",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "166392ec-db4d-b874-16d9-41c531b5cf5d",
          "attributeId": "0b83a30f-b46c-4d5f-bf85-8472c188b02d",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__AddressBook_totalcount"
    },
    {
      "id": "0399dcde-a3f6-5dfe-7cdb-a466f2533ab0",
      "entityId": "08c52333-7dcf-456b-af56-c30cf818f6c1",
      "filter": "SampleMappingsFilter",
      "control": "MappedOrganisations",
      "dataMap": [
        {
          "id": "8a095466-40c2-9aa3-6e17-036ddf23937a",
          "attributeId": "b6869873-d1dd-474f-a804-16faba21fc72",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8b34b1b1-7aa1-fd6b-65d8-d2ddf0875263",
          "attributeId": "400fafbc-52f6-4ab3-8760-f0f699516ca8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9209cf24-3976-f6b3-aabb-9664a1b18fac",
          "attributeId": "83da3ded-2adb-4d43-a25f-5e64f7608605",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "57a240cf-a0e2-e729-4167-1b10a25f615c",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionName2",
          "parentId": "9209cf24-3976-f6b3-aabb-9664a1b18fac",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": true,
      "totalCountPropertyName": "__MappedOrganisations_totalcount"
    },
    {
      "id": "e7af6502-1ece-9ba4-5fc9-47b1e95c1b94",
      "entityId": "11362fb2-6363-4042-bd07-b786ef81f86b",
      "filter": "SampleMappingsFilter",
      "control": "OrganisationRemarks",
      "dataMap": [
        {
          "id": "220a60f1-9f84-ef18-1d91-5fa819e9a261",
          "attributeId": "a0d35614-4ea6-4b38-9d0b-449208977482",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "59424cb5-5007-c207-0996-ba28514ff702",
          "attributeId": "593a53f2-e483-43fa-812a-733cd546f844",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3cc3db57-6c83-3440-b455-8ba4b572dd84",
          "attributeId": "fbc37fc4-7b06-4e88-9cae-2caae9a3fcd8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "63c2aa2a-b9fd-56b0-ddaa-5fe52fa8ce74",
          "attributeId": "31f9bdbf-51bb-49b7-adcc-3608113a5d8b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b15466e1-e3b8-3511-8862-7f3fdef63699",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "control": "StructDivisionName3",
          "parentId": "63c2aa2a-b9fd-56b0-ddaa-5fe52fa8ce74",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__OrganisationRemarks_totalcount"
    }
  ],
  "securityGroup": "List",
  "isArchived": false
}' WHERE [Id]='22cdf459-84e7-4174-a19b-79618f6f383b';

