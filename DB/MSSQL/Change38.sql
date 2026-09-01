----------------------
--Must do database sync to add data model for view vSP_QnnSampleActiveForGrid and then set Id as its primary key
--Must also do mapping for form qnn_sample and swzsamplelist
---------------
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('22CDF459-84E7-4174-A19B-79618F6F383B', N'metadata/forms', N'QNN_SAMPLE-settings.json', '0', 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-11 16:41:54.853', NULL, NULL, 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-13 10:53:02.873', N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_SAMPLE",
  "lastUpdate": "2020-02-13T10:53:02.8327415+08:00",
  "entityId": "6c1647af-bc1f-4e1d-8dda-0b8c17ebde7b",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\"}"
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
      "codeAction": "EncryptPasswordAsyncTrigger"
    },
    {
      "triggers": [
        "AfterSelect"
      ],
      "codeAction": "DecryptPasswordAsyncTrigger"
    }
  ],
  "dataMap": [
    {
      "id": "5507f48b-a3fa-ba57-4ada-d5423c2d4a04",
      "attributeId": "011a70db-a5ae-4019-a9ac-4c167d60bbb0",
      "control": "ActiveYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72917582-c90c-5fc4-6da8-246fdf9bbcc4",
      "attributeId": "63a7a61b-6248-4197-8d08-3fc85ff686ba",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6f53044e-2da4-5373-9cf4-30aba20bd472",
      "attributeId": "be7d893d-9d5d-4c1e-a3e7-b04e13a5c303",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fee3c5c4-7cd0-b2ec-f1b5-6d0b9b23b1b7",
      "attributeId": "3cb554ec-8497-4513-93c5-58769fe5231c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "69cfbb51-b810-de90-f06f-dddbc566a42c",
      "attributeId": "8778e5f8-94eb-438f-bfd5-36ede705a05b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8ae23492-8099-ffe5-447c-2772be1e159d",
      "attributeId": "c2ec5478-2ca4-4bcc-9d48-81ac192f50d9",
      "control": "Email",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "34ee1abe-0e40-3b2b-9f61-acc62f196532",
      "attributeId": "96143a54-6881-4bfe-947e-39e6ab7fd935",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "efc5f4c7-f226-6216-5059-f9f6db667f8f",
      "attributeId": "b22a30c4-696c-4ced-aa4a-22620b16a884",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "03aafd33-9253-262b-897b-5e5b020d04a5",
      "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
      "control": "Name",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e76e738e-ff4e-b2ca-43c7-0c5ff1827c00",
      "attributeId": "1b3705b9-e1de-401c-996e-c7c9ac10366a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6bd481df-93c5-9049-e823-fece41180368",
      "attributeId": "ac3c5076-a671-43d0-bab9-d50d339598a9",
      "control": "NumRetry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d83201c1-f738-289f-1385-ed1230937233",
      "attributeId": "a02ab42a-6f9c-4a9d-8112-3cc7eae2a5fc",
      "control": "Pwd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9a5560ec-1c95-080f-2ce7-e8b44ecb84da",
      "attributeId": "700091f4-476a-440a-bc17-ab5351fa461b",
      "control": "PwdResetYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b9b7e2f8-6d8f-34cd-6e77-f5f31f34e2a0",
      "attributeId": "a7440614-efc1-454a-8ff7-cc29764ad271",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5e81a821-b73d-0932-370f-7a0b25e5595b",
      "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
      "control": "UID",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b6c989d4-4fd4-4d52-7f68-0d88baf79caf",
      "attributeId": "96609d0c-c7fc-4fcb-816b-cde87a1e5de3",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "690d908c-41b2-bcab-1783-097ebfb7b3c3",
      "attributeId": "791dc4a1-5ee5-4550-88d4-56ff82d0d867",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b1e3911f-fe59-3e64-bbfd-ad1173d31667",
      "attributeId": "c50309ed-78cf-4601-b861-a0e8c43f8ba3",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": []
}', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');

GO
----------------------------------------
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('6B16FA37-61D8-43A9-A851-558D889CA9C9', N'metadata/forms', N'QNN_SAMPLE.json', '0', 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-11 16:41:54.567', NULL, NULL, 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-13 10:11:17.420', N'[
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
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "events": {}
          },
          {
            "key": "UID",
            "data-buildertype": "input",
            "label": "UID",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {},
            "other-readOnlyConition": "data.Id"
          },
          {
            "key": "Email",
            "data-buildertype": "input",
            "label": "Email",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {},
            "other-customValidation": "/^(([^<>()[\\]\\\\.,;:\\s@\\\"]+(\\.[^<>()[\\]\\\\.,;:\\s@\\\"]+)*)|(\\\".+\\\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$/.test(value)?true:\"is not valid\"",
            "reference": "Email Address"
          },
          {
            "key": "Pwd",
            "data-buildertype": "input",
            "label": "Password",
            "fluid": true,
            "onChangeTimeout": 200,
            "events": {},
            "other-visibleConition": "CloverApp.API.checkRole(''Admins'')==true",
            "reference": "",
            "type": "password"
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
            "other-visibleConition": "data.Id"
          },
          {
            "key": "ActiveYN",
            "data-buildertype": "checkbox",
            "label": "Active"
          },
          {
            "key": "PwdResetYN",
            "data-buildertype": "checkbox",
            "label": "Change Password at First Login"
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "save"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "btnResetPassword",
                "data-buildertype": "button",
                "content": "Reset Password",
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
                "other-visibleConition": "data.Id"
              },
              {
                "key": "btnExit",
                "data-buildertype": "button",
                "content": "Cancel",
                "events": {
                  "onClick": {
                    "actions": [
                      "goBack"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "primary": false,
                "secondary": true
              }
            ],
            "style-float": "left"
          }
        ]
      }
    ]
  }
]', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');

GO
------------------------------------------------
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('EF95ED35-6B68-4A52-8433-F85554DBD1FE', N'metadata/forms', N'QNN_SAMPLE-code.js', '0', 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-11 20:33:31.493', NULL, NULL, 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-13 09:20:20.967', N'{
    resetPassword: function(args){
            var formData = new FormData();
            if(!args.data.Id){
                alertify.error("The sample must exist");
                return;
            } 
            formData.append(''sampleIds'', args.data.Id);
            var url = ''/deployment/resetresppassword'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        alertify.success(response.message);

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });
        
    }
}', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
GO
----------------------------------------------------------------
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('E3AA01F6-089E-477B-BC56-7BB0A62CA971', N'metadata/forms', N'swzsamplelist-settings.json', '0', 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-11 09:33:32.437', NULL, NULL, 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-11 15:38:25.437', N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "swzsamplelist",
  "lastUpdate": "2020-02-11T15:38:25.4276618+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "71b48e2c-7b9b-17d7-d790-99f8533733ac",
      "entityId": "d65b8f40-8347-4627-90b1-c48b21e5cbb6",
      "filter": "StructAsyncFilter",
      "control": "grid",
      "dataMap": [
        {
          "id": "5de53dd8-912e-87af-d4c8-02729ee81505",
          "attributeId": "6c1c1798-4775-42e2-abd8-58199e381b15",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3569760c-d2bd-5bad-57f4-e0a3c8fa6bfa",
          "attributeId": "de1c0e8a-8c40-4424-ba86-8cbb7d04a2eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "90d47a9d-80a2-6b2c-ebcf-3b1c9e161575",
          "attributeId": "5a5d4e6f-b8ac-44e1-b082-0c29a95fc078",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "39b857ea-273b-deb8-ec5c-466ff73771b8",
          "attributeId": "cc1d7f61-7718-4a8f-8206-563a0321dbba",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dee6e1fa-dc9b-6502-bc8e-45452cb743a8",
          "attributeId": "a4c25b3e-784f-4501-872c-ef37d0a0d3a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d9786d56-dfc4-dbf4-cef8-fd88b3f2a9bc",
          "attributeId": "f95b7a83-a4b1-4542-b71b-7e9254da684d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f23cc8f7-49b8-ab3c-08e6-1a7f08cf0e9a",
          "attributeId": "1a723190-b8fd-40cf-aea5-7623c626d10d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dc43865b-2bca-cb74-d181-52c71c116748",
          "attributeId": "82b2bc05-413b-409a-a2ab-3d0dec47a2f7",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
GO
------------------------------------------------------------------
INSERT INTO [surveyplus.net].[dbo].[dwMetadata] ([Id], [Folder], [Filename], [IsDeleted], [CreatedBy], [CreatedDate], [DeletedBy], [DeletedDate], [UpdatedBy], [UpdatedDate], [Data], [StructDivisionId]) VALUES ('29D6757B-A248-477D-A1D5-E5A4F7550F07', N'metadata/forms', N'swzsamplelist.json', '0', 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-11 09:33:31.797', NULL, NULL, 'B9D69BA9-282B-D3D2-8F23-EFC2596A082C', '2020-02-11 15:38:25.217', N'[
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_6",
        "data-buildertype": "container",
        "children": [
          {
            "key": "pageHeader",
            "data-buildertype": "header",
            "content": "Samples",
            "size": "huge",
            "textAlign": "left",
            "style-marginTop": "",
            "style-source": "padding-top:20px;",
            "style-marginLeft": "",
            "style-width": "250px",
            "events": {}
          }
        ],
        "style-marginBottom": "10px"
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "style-float": "left",
        "children": [
          {
            "key": "button_3",
            "data-buildertype": "button",
            "content": "Export",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridExport"
                ],
                "targets": [
                  "gridviewwithactions_1"
                ],
                "parameters": []
              }
            },
            "style-hidden": true,
            "secondary": true
          },
          {
            "key": "btnCreate",
            "data-buildertype": "button",
            "content": "Create",
            "style-customcss": "",
            "primary": true,
            "events-onClick": true,
            "events-onClick-actions": [
              "gridAdd"
            ],
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridCreate"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            },
            "other-visibleConition": "",
            "style-source": "float:left"
          },
          {
            "key": "button_1",
            "data-buildertype": "button",
            "content": "Delete",
            "style-customcss": "",
            "primary": false,
            "events-onClick": true,
            "events-onClick-actions": [
              "gridAdd"
            ],
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "gridDelete"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "deleteSampleConfirmTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "deleteSampleConfirmText"
                  }
                ]
              }
            },
            "other-visibleConition": "",
            "style-source": "float:left",
            "inverted": false,
            "secondary": true,
            "compact": false
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_1",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "inputSearch",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": "",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setFilter",
                          "applyFilter"
                        ],
                        "targets": [
                          "grid"
                        ],
                        "parameters": [
                          {
                            "name": "column",
                            "value": "Name, UID"
                          }
                        ]
                      }
                    },
                    "placeholder": "Search by Name or UID"
                  }
                ],
                "style-float": "left",
                "style-width": "300px"
              }
            ],
            "style-float": "left"
          }
        ],
        "style-marginRight": "20px",
        "style-width": "100%"
      }
    ],
    "style-float": "left",
    "style-width": "100%",
    "style-marginBottom": "1em"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": false,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "UID",
        "name": "UID",
        "sortable": false,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "Email",
        "name": "Email",
        "type": "",
        "sortable": false,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "StructDivisionName",
        "name": "Division",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "NumRetry",
        "name": "Num Retry",
        "type": "",
        "sortable": false,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "ActiveYN",
        "name": "Active",
        "type": "checkbox",
        "sortable": false,
        "filterable": false,
        "resizable": true
      }
    ],
    "rowKey": "Id",
    "pageSize": "50",
    "defaultSort": "Name",
    "pagerType": "server",
    "multiselect": true,
    "disableSort": false,
    "editForm": "QNN_SAMPLE",
    "events": {
      "onRowDblClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "rowHeight": "80",
    "minHeight": "500"
  }
]', 'F6E34BDF-B769-42DD-A2BE-FEE67FAF9045');
GO
-----------------------------------
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A', [Folder]=N'metadata/forms', [Filename]=N'sidemenu-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:24.490', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-13 09:51:24.707', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2020-02-13T09:51:24.704929+08:00",
  "isTemplate": false
}', [StructDivisionId]=NULL WHERE ([Id]='82CCC3B1-E283-4DA5-9CBB-D5F5622FF62A');
GO
-------------------------------------------------------
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='55636648-E5A4-4002-9F59-D597FD167C04', [Folder]=N'metadata/forms', [Filename]=N'sidemenu.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:25.787', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-13 09:51:24.603', [Data]=N'[
  {
    "key": "sidemenu",
    "data-buildertype": "menu",
    "items": [
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true",
        "children": [
          {
            "title": "Questionnaire",
            "target": "",
            "distype": "dropdownheader"
          },
          {
            "title": "Form Designer",
            "target": "/surveydesigner",
            "visibleCondition": "CloverApp.API.checkRole(''''SurveyDesigner'''')==true",
            "icon": ""
          },
          {
            "target": "/form/SwzQnnList",
            "title": "Form Properties",
            "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true",
            "icon": ""
          }
        ],
        "icon": "file alternate outline",
        "distype": "dropdown"
      },
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true",
        "children": [
          {
            "title": "<b>List</b>",
            "distype": "dropdownheader"
          },
          {
            "target": "/form/SwzListList",
            "title": "Sample List",
            "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track List",
            "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true",
            "icon": ""
          }
        ],
        "distype": "dropdown",
        "icon": "list alternate outline"
      },
      {
        "target": "",
        "title": "",
        "children": [
          {
            "title": "Deployment",
            "target": "/form/SwzDplyList"
          }
        ],
        "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true",
        "icon": "send",
        "distype": "dropdown"
      },
      {
        "title": "",
        "target": "",
        "visibleCondition": "CloverApp.API.checkRole(''''DataEditor'''')==true",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor"
          }
        ],
        "distype": "dropdown"
      },
      {
        "distype": "dropdown",
        "icon": "database",
        "visibleCondition": "CloverApp.API.checkRole(''''DataEditor'''')==true",
        "children": [
          {
            "distype": "dropdownheader",
            "title": "<b>Dashboard and Reports</b>"
          },
          {
            "target": "/form/ChoiceCount",
            "title": "Frequency Count Report",
            "visibleCondition": "CloverApp.API.checkRole(''''DataEditor'''')==true"
          },
          {
            "target": "/form/ResponseReport",
            "title": "Response Report",
            "visibleCondition": "CloverApp.API.checkRole(''''DataEditor'''')==true"
          },
          {
            "target": "/form/DashboardOverall",
            "title": "Overall Response Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''''DataEditor'''')==true"
          },
          {
            "target": "/form/DashboardSectorSegment",
            "title": "Sector/Segment Response Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''''DataEditor'''')==true"
          },
          {
            "target": "/form/DashboardStatus",
            "title": "Status Response Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''''DataEditor'''')==true",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''''DataEditor'''')==true"
          }
        ]
      },
      {
        "target": "",
        "children": [
          {
            "title": "Category",
            "target": "/form/SwzCategoryList",
            "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true",
            "icon": ""
          },
          {
            "target": "/form/swzsamplelist",
            "title": "Samples",
            "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true"
          },
          {
            "target": "/useradmin",
            "title": "Security",
            "visibleCondition": "CloverApp.API.checkRole(''''SurveyAdmin'''')==true",
            "icon": ""
          },
          {
            "title": "Respondent Content Management",
            "target": "/form/SwzRespAdminList",
            "children": [],
            "visibleCondition": "CloverApp.API.checkRole(''''Admins'''')==true",
            "icon": ""
          },
          {
            "target": "/form/organizations",
            "title": "Organizations",
            "visibleCondition": "CloverApp.API.checkRole(''''Admins'''')==true",
            "icon": ""
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''''Admins'''')==true",
            "icon": "",
            "children": []
          }
        ],
        "distype": "dropdown",
        "title": "",
        "icon": "bars"
      }
    ],
    "vertical": true,
    "events": {
      "onItemClick": {
        "active": true,
        "actions": [
          "redirect"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "link": true,
    "fluid": false,
    "tabular": false,
    "secondary": false,
    "pointing": false,
    "other-visibleConition": "",
    "icon": false,
    "compact": false,
    "style-width": ""
  }
]', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='55636648-E5A4-4002-9F59-D597FD167C04');
GO

--------------------------------
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='CB82C0F3-8EA8-42A5-AAD7-CC6F3E07053A', [Folder]=N'metadata/localization', [Filename]=N'base.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:10.700', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-11 15:43:33.393', [Data]=N'{
  "common": {
    "dateFormat": "DD MMM YYYY",
    "timeFormat": "HH:mm"
  },
  "msg": {
    "addSampleConfirmTitle": "Add List Samples",
    "addSampleConfirmText": "Are you so sure you want to add new samples from the list to this deployment?",
    "submitSurveyConfirmTitle": "Survey Submission",
    "submitSurveyConfirmText": "Are you so sure you want to submit survey?",
    "deleteListSampleConfirmTitle": "Delete List Samples",
    "deleteListSampleConfirmText": "All the data related with selected list samples including response data will be deleted. Are you so sure you want to continue?",    
    "deletionConfirmTitle": "Deletion Confirmation",
    "deletionConfirmText": "All the data related with selected records will be deleted. Are you so sure you want to continue?",
    "deleteSampleConfirmTitle": "Delete Samples",
    "deleteSampleConfirmText": "All the data related with selected samples will be deleted, including response data, sample list properties and etc. Are you so sure you want to continue?",    
    

  },
  "forms": {
    "CategoryList": {
      "pageHeader_content": "List",
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete",
      "searchField_label": ""
    },
    "DataEditorDeployment": {
      "Name_content": "{Name}",
      "remarks_label": "Remarks",
      "button_1_content": "Submit",
      "grid_UID": "UID (Name)",
      "grid_DateStart": "Date Start",
      "grid_DateComplete": "Date Complete",
      "grid_ActiveYN": "Active",
      "grid_CreatedDate": "",
      "grid_Remarks": "Remarks",
      "dropdownStatus_label": "Dropdown",
      "button_2_content": "Cancel",
      "grid_PeerUID": "Peer UID (Name)",
      "grid_StatusTitle": "Status",
      "grid_Actions": "Actions",
      "grid_Actions2": ""
    },
    "DataEditorDeploymentList": {
      "headerDataEditorList_content": "Data Editor",
      "headerDataEditorList_subheader": "View a list of deployments under you",
      "dictionary_1_label": "Category",
      "input_1_label": "Filter",
      "grid_Name": "Name",
      "grid_StatusText": "Status",
      "grid_Title": "Questionnaire",
      "grid_Category": "Category",
      "grid_DateEnd": "Date End",
      "grid_Responses": "Responses",
      "grid_CategoryId": "",
      "refreshChart_content": "Refresh",
      "grid_QnnType": "Type"
    },
    "DEDplys": {
      "gridview_1_Id": "ID",
      "gridview_1_Name": "Name",
      "gridview_1_ListId_Name": "List"
    },
    "DocumentEdit": {
      "btnOpenWorkflowDesigner_content": "Open in Workflow Designer",
      "name_label": "Name",
      "managerId_label": "Manager",
      "number_label": "Number",
      "amount_label": "Money amount (Must be more 0!)",
      "author_label": "Author",
      "stateName_label": "State",
      "comment_label": "Comment",
      "header_1_content": "Document''s Transition History",
      "gridHistory_from": "From",
      "gridHistory_to": "To",
      "gridHistory_command": "Command",
      "gridHistory_executor": "Executor",
      "gridHistory_TransitionTime": "Date",
      "gridHistory_availiablefor": "Availiable for",
      "save_content": "Save",
      "saveexit_content": "Save & Exit"
    },
    "Documents": {
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete",
      "btnRefresh_content": "Refresh",
      "button_1_content": "Export",
      "inputSearch_label": "",
      "grid_number": "#",
      "grid_stateName": "State",
      "grid_name": "Name",
      "grid_comment": "Comment",
      "grid_author": "Author",
      "grid_manager": "Manager",
      "grid_amount": "Amount"
    },
    "footer": {
      "staticcontent_1_content": "<b>Please contact <a href=\"mailto:sales@softworkz.net\">sales@softworkz.net</a>.</b>\nOfficial site - <a href=\"http://softworkz.net\">http://softworkz.net</a>"
    },
    "header": {
      "currentUser_/admin": "Admin panel",
      "currentUser_/form/settings": "Settings",
      "currentUser_/account/logoff": "Logout"
    },
    "qnns": {},
    "QNN_AUDIT_TRAIL": {
      "AuditAction_label": "AuditAction",
      "ChangeDate_label": "ChangeDate",
      "ModuleCode_label": "ModuleCode",
      "NumberId_label": "NumberId",
      "Ref_Id_label": "Ref_Id",
      "Ref_Name_label": "Ref_Name",
      "UserId_label": "UserId",
      "UserName_label": "UserName",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "qnn_categories": {
      "button_1_content": "Delete"
    },
    "QNN_CATEGORY": {
      "Name_label": "Name",
      "Description_label": "Description",
      "dropdownType_label": "Type",
      "dictRoles_label": "Roles",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_CATEGORY2": {
      "Name_label": "Name",
      "Description_label": "Description",
      "ParentId_label": "ParentId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel",
      "gridview_1_Id": "ID",
      "gridview_1_Name": "Name"
    },
    "QNN_CATEGORY_ROLE": {
      "CategoryId_label": "CategoryId",
      "RoleId_label": "RoleId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY": {
      "header_1_content": "Deployments",
      "buttonManageListSamples_content": "Manage List Samples",
      "buttonManageDataEditors_content": "Manage Data Editors",
      "btnCancel_content": "Cancel",
      "btnSave_content": "Save",
      "headerBasicProperties_content": "Basic Properties",
      "textName_label": "Name",
      "dictCategory_label": "Category",
      "dictQuestionnaire_label": "Questionnaire",
      "dictList_label": "List",
      "DateStart_label": "Start On",
      "DateEnd_label": "End On",
      "headerCompletionProperties_content": "Completion  Properties",
      "textCompleteURL_label": "",
      "hedderNavigationProperties_content": "Navigation Properties",
      "textNavCancelUrl_label": "",
      "headerResponseProperties_content": "Response Properties",
      "MaxResponse_label": "Maximum Number of Responses",
      "DaysUpdate_label": "Days for Update",
      "button_1_content": "Manage List Samples",
      "button_2_content": "Manage Data Editors",
      "button_3_content": "Cancel",
      "button_4_content": "Save",
      "buttonManageMessageHistory_content": "Manage Message History",
      "header_2_content": "Initial Notification Type",
      "cbMailMerge_label": "Mail Merge",
      "cbEmail_label": "Email",
      "cbProfile_label": "Generate Profile",
      "subject_label": "Subject"
    },
    "QNN_DPLY_MSG": {
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "DplyId_label": "DplyId",
      "DplyStep_label": "DplyStep",
      "EmailBCC_label": "EmailBCC",
      "EmailCC_label": "EmailCC",
      "EmailFrom_label": "EmailFrom",
      "EmailSubj_label": "EmailSubj",
      "GenerateDateTime_label": "GenerateDateTime",
      "GenerateQnnYN_label": "GenerateQnnYN",
      "IsDeleted_label": "IsDeleted",
      "MsgContent_label": "MsgContent",
      "NotifyEmail_label": "NotifyEmail",
      "NotifyGenerate_label": "NotifyGenerate",
      "NotifyMerge_label": "NotifyMerge",
      "NumberId_label": "NumberId",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_MSG_SAMPLE": {
      "CreatedDate_label": "CreatedDate",
      "DplyMsgId_label": "DplyMsgId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_DUEDATE": {
      "DplyId_label": "DplyId",
      "DueDate_label": "DueDate",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_INFO": {
      "DispatchInd_label": "DispatchInd",
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "ProcessEditInd_label": "ProcessEditInd",
      "ProcessValidInd_label": "ProcessValidInd",
      "Remarks_label": "Remarks",
      "RemarksModifyBy_label": "RemarksModifyBy",
      "RemarksModifyOn_label": "RemarksModifyOn",
      "ReturnInd_label": "ReturnInd",
      "Status_label": "Status",
      "StatusModifyBy_label": "StatusModifyBy",
      "StatusModifyOn_label": "StatusModifyOn",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_OWNER": {
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "UserId_label": "UserId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_LIST": {
      "bcList_1": "List",
      "bcList_2": "Manage List",
      "headerName_content": "Manage {nameInput}",
      "headerName_subheader": "",
      "headerProperties_content": "Properties",
      "nameInput_label": "List Title",
      "headerDescription_label": "List Description",
      "dictionaryCategory_label": "Category Name",
      "toggleStatus_label": "Status",
      "headerUser_content": "Records User Control",
      "toggleEditName_label": "Edit Name",
      "toggleEditEmail_label": "Edit Email",
      "togglePassword_label": "Edit Password",
      "btnSaveR_content": "Save & Review",
      "btnSave_content": "Save",
      "btnCancel_content": "Cancel",
      "headerRecords_content": "Records ",
      "btnCreate2_content": "Create",
      "btnDelete_content": "Delete",
      "header_5_content": "Import Sample",
      "header_5_subheader": "CSV Format.. ",
      "button_7_content": "Create",
      "button_8_content": "Cancel",
      "button_1_content": "Export",
      "btnRefresh_content": "Refresh",
      "headerCount_content": "Total Count: {__collectioneditor_sample_totalcount}",
      "gridviewSample_Id": "ID",
      "gridviewSample_Name": "Title",
      "gridviewSample_Email": "Email",
      "collectioneditor_sample_UID": "UID",
      "collectioneditor_sample_Name": "Name",
      "collectioneditor_sample_Email": "Email",
      "collectioneditor_sample_NumRetry": "NumRetry",
      "collectioneditor_sample_Pwd": "Password",
      "collectioneditor_sample_ActiveYN": "Active",
      "collectioneditor_sample_PwdResetYN": "PwdResetYN",
      "collectioneditor_1_Alias": "Alias",
      "collectioneditor_1_ReqdYN": "Reqd",
      "collectioneditor_1_UsrEditYN": "UsrEdit",
      "collectioneditor_1_TxtRow": "TxtRow",
      "collectioneditor_1_TxtRegExp": "TxtRegExp",
      "collectioneditor_1_TxtRegExpErr": "TxtRegExpErr",
      "inputPassword_label": "Password",
      "inputImportListSample_label": "",
      "headerSampleAdded_content": "Sample Added: {sampleAddedCount}",
      "headerSampleUpdated_content": "Sample Updated: {sampleUpdatedCount}",
      "headerListSampleAdded_content": "List Sample Added: {listSampleAddedCount}",
      "headerListSampleUpdated_content": "List Sample Updated: {listSampleUpdatedCount}",
      "gridviewSample_UID": "UID",
      "gridviewSample_PeerUID": "Peer UID",
      "gridviewSample_PeerName": "Peer Name"
    },
    "QNN_LIST2": {
      "Name_label": "Name",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "qnn_lists": {
      "button_1_content": "Delete"
    },
    "QNN_LIST_REVIEW": {
      "dictionary_1_label": "List Name",
      "Notes_label": "Notes",
      "Consent_label": "Consent",
      "btnSave_content": "Save",
      "button_1_content": "Cancel",
      "searchField2_label": ""
    },
    "QNN_LIST_SAMPLE": {
      "header_1_content": "Manage Sample",
      "DictionaryListName_label": "List Title",
      "Name_label": "Name",
      "Email_label": "Email",
      "UID_label": "Username",
      "UIDPeer_label": "UIDPeer",
      "Pwd_label": "Password",
      "ActiveYN_label": "Status",
      "PwdResetYN_label": "Password Reset",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel",
      "dictionarySample_label": "Sample",
      "dictionarySamplePeer_label": "Sample Peer"
    },
    "QNN_QNN": {
      "Alias_label": "Alias",
      "CategoryId_label": "CategoryId",
      "Status_label": "Status",
      "Title_label": "Title",
      "collectioneditor_1_Name": "Name",
      "collectioneditor_1_Token": "File",
      "collectioneditor_1_Language": "Language",
      "collectioneditor_1_Remarks": "Remarks",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel",
      "button_1_content": "Generate Qnn Fields",
      "header_1_content": "Questionnaire",
      "Type_label": "Type",
      "collectioneditor_2_Name": "Form Name",
      "collectioneditor_2_Language": "Language",
      "collectioneditor_2_Remarks": "Remarks"
    },
    "QNN_QNN_ENTITY": {
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "IsDeleted_label": "IsDeleted",
      "Language_label": "Language",
      "NumberId_label": "NumberId",
      "QnnId_label": "QnnId",
      "Remarks_label": "Remarks",
      "Token_label": "Token",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_FIELD": {
      "Name_label": "Name",
      "QnnId_label": "QnnId",
      "ReadOnly_label": "ReadOnly",
      "Required_label": "Required",
      "Type_label": "Type",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_REVIEW": {
      "QnnId_label": "QnnId",
      "Notes_label": "Notes",
      "Consent_label": "Consent",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_REVIEW_FILES": {
      "Name_label": "Name",
      "NumberId_label": "NumberId",
      "ReviewId_label": "ReviewId",
      "Size_label": "Size",
      "token_label": "token",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_RESP": {
      "DateComplete_label": "DateComplete",
      "DateStart_label": "DateStart",
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "QnnId_label": "QnnId",
      "RespIp_label": "RespIp",
      "Score_label": "Score",
      "TimeTook_label": "TimeTook",
      "UpdatedDate_label": "UpdatedDate",
      "UserId_label": "UserId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_RESP_ADMIN": {
      "Name_label": "Title",
      "Type_label": "Type",
      "StartDate_label": "StartDate",
      "EndDate_label": "EndDate",
      "Status_label": "Status",
      "btnSave_content": "Save",
      "button_2_content": "Save Editor",
      "button_1_content": "Fetch Editor State",
      "btnExit_content": "Cancel",
      "header_2_content": "Respondent Content Management"
    },
    "QNN_RESP_ANS": {
      "AnsBin_label": "AnsBin",
      "AnsVal_label": "AnsVal",
      "NumberId_label": "NumberId",
      "QnnFieldId_label": "QnnFieldId",
      "RespId_label": "RespId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_STATUS": {
      "Active_label": "Active",
      "Code_label": "Code",
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "Description_label": "Description",
      "HasRespYN_label": "HasRespYN",
      "NumberId_label": "NumberId",
      "Title_label": "Title",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "respdashboard": {
      "gridview_1_DplyName": "Name",
      "gridview_1_QnnTitle": "Questionnaire",
      "gridview_1_DplyDateStart": "Survey Start",
      "gridview_1_DplyDateEnd": "Survey End",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Response Complete",
      "header_1_content": "Respondent Home",
      "header_2_content": "Current Surveys",
      "grid_QnnTitle": "Survey Name",
      "grid_Type": "Type",
      "grid_PeerName": "Peer",
      "grid_DplyDateStart": "Launched On",
      "grid_DueDate": "Due On",
      "grid_RespDateStart": "Responded On",
      "grid_RespDateEnd": "Submitted On",
      "grid_Password": "Password",
      "header_3_content": "Previous Surveys",
      "gridview_QnnTitle": "Survey Name",
      "gridview_Type": "Type",
      "gridview_PeerName": "Peer",
      "gridview_DplyDateStart": "Launched On",
      "gridview_DueDate": "Due On",
      "gridview_RespDateStart": "Responded On",
      "gridview_RespDateEnd": "Submitted On",
      "gridview_Password": "Password",
      "password_label": "",
      "btnClose_content": "OK"
    },
    "resplogin": {
      "login_label": "Respondent Login",
      "password_label": "Password",
      "remember_label": "Remember",
      "btnLogin_content": "Login",
      "breadcrumb_1_1": "Forgot Password"
    },
    "Settings": {
      "header_1_content": "Workflow",
      "button_1_content": "Manage workflow schemes",
      "header_3_content": "Roles",
      "btnRoles_content": "Manage roles",
      "header_2_content": "StructDivisions",
      "structdivision_name": "Name",
      "structdivision_roles": "Roles"
    },
    "sidemenu": {
      "sidemenu_/form/SwzQnnList": "Questionaires",
      "sidemenu_/form/SwzListList": "List",
      "sidemenu_/form/SwzDplyList": "Deployment",
      "sidemenu_/form/DataEditorDeploymentList": "Data Editor",
      "sidemenu_/form/SwzCategoryList": "Category",
      "sidemenu_/form/SwzQnnList/": "Questionaires",
      "sidemenu_/surveydesigner": "Survey Designer",
      "sidemenu_/form/SwzRespAdminList": "Respondent Content Management"
    },
    "spfooter": {
      "staticcontent_1_content": "<b>Please contact <a href=\"mailto:sales@softworkz.net\">sales@softworkz.net</a>.</b>\nOfficial site - <a href=\"http://softworkz.net\">http://softworkz.net</a>"
    },
    "spheader": {
      "currentUser_/form/respsettings": "Settings",
      "currentUser_/resp/logoff": "Logout",
      "currentUser_/form/respdashboard": "Home",
      "currentUser_/form/RespAccountChangePassword": "Settings"
    },
    "sptop": {},
    "SwzCategoryList": {
      "header_1_content": "Categories",
      "buttonAdd_content": "Add",
      "buttonDelete_content": "Delete",
      "gridCategory_Name": "Name"
    },
    "SwzDataEditor": {
      "header_1_content": "Samples",
      "buttonCancel_content": "Cancel",
      "buttonSave_content": "Save",
      "gridviewListSamples_ReturnInd": "Return",
      "gridviewListSamples_ProcessValidInd": "Validation",
      "gridviewListSamples_ProcessEditInd": "Editing"
    },
    "SwzDataEditorList": {
      "headerDataEditorList_content": "Data Editor",
      "headerDataEditorList_subheader": "View a list of deployments under you",
      "buttonDelete_content": "Delete",
      "buttonAddDataEditor_content": "Add",
      "gridviewDeployments_Name": "Name",
      "gridviewDeployments_Status": "Status",
      "gridviewDeployments_QnnId_Title": "Questionnaire",
      "gridviewDeployments_ListId_Name": "List",
      "gridviewDeployments_CategoryId_Name": "Category"
    },
    "SwzDplyList": {
      "header_2_content": "Deployments",
      "buttonAdd_content": "Add",
      "buttonDelete_content": "Delete",
      "gridview_1_Name": "Name",
      "gridview_1_Status": "Status",
      "gridview_1_QnnId_Title": "Questionnaire",
      "gridview_1_ListId_Name": "List",
      "gridview_1_CategoryId_Name": "Category",
      "gridview_1_QnnId_Type": "Type",
      "gridview_1_CreatedDate": "Date Created"
    },
    "SwzListList": {
      "pageHeader_content": "List",
      "button_3_content": "Export",
      "btnCreate_content": "Create",
      "header_1_content": "Are you sure?",
      "button_1_content": "Confirm",
      "button_2_content": "Cancel",
      "inputSearch_label": "",
      "grid_Name": "Name",
      "grid_Category": "Category",
      "grid_SampleCount": "No. Of Records",
      "grid_UpdatedDate": "Date Modified",
      "grid_Status": "Status"
    },
    "SwzQnnList": {
      "header_1_content": "Questionnaire",
      "btnCreate2_content": "Create",
      "header_2_content": "Are you sure?",
      "button_1_content": "Confirm",
      "button_2_content": "Cancel",
      "button_3_content": "Delete",
      "gridview_1_Title": "Name",
      "gridview_1_Type": "Type",
      "gridview_1_Status": "Status"
    },
    "SwzRespAdminList": {
      "header_1_content": "Respondent Content Management",
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete"
    },
    "SwzReviewList": {
      "pageHeader_content": "Reviews",
      "List_content": "List Name: {Listname}",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "Save_content": "Save",
      "cancelbu_content": "Cancel",
      "button_1_content": "Export",
      "header_1_content": "Total Count: {__review_gridview_totalcount}"
    },
    "SwzReviewQnn": {
      "header_1_content": "Reviews",
      "Questionnaire_content": "Questionnaire: {Title}",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "button_2_content": "Save",
      "button_3_content": "Cancel",
      "button_1_content": "Export",
      "header_2_content": "Total Count: {__swzgridview_1_totalcount}"
    },
    "test": {
      "button_1_content": "Button"
    },
    "top": {},
    "login": {
      "login_label": "Login",
      "password_label": "Password",
      "remember_label": "Remember",
      "btnLogin_content": "Login"
    },
    "Job": {
      "Arguments_label": "Arguments",
      "CreatedAt_label": "CreatedAt",
      "ExpireAt_label": "ExpireAt",
      "InvocationData_label": "InvocationData",
      "StateId_label": "StateId",
      "StateName_label": "StateName",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplyListSample": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Manage list of samples specific to this deployment",
      "txtFilter_label": "",
      "input_1_label": "Filter Due Date  >=",
      "input_5_label": "Filter Due Date  <=",
      "dueDate_label": "Due Date",
      "button_5_content": "Submit",
      "input_2_label": "Filter Generated Date  >=",
      "input_3_label": "Filter Generated Date  <=",
      "btnResetPassword_content": "Reset Password",
      "cbMailMerge_label": "Mail Merge",
      "cbEmail_label": "Email",
      "cbProfile_label": "Generate Profile",
      "subject_label": "Subject",
      "button_2_content": "Submit",
      "gridview_1_UIDName": "UID (Name)",
      "gridview_1_PeerName": "Peer UID (Name)",
      "gridview_1_StatusTitle": "Status",
      "gridview_1_DueDate": "Due Date",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Respponse End",
      "gridview_1_CreatedDate": "Generated On",
      "button_1_content": "Add New List Sample",
      "button_4_content": "Manage Message History",
      "button_3_content": "Back"
    },
    "TestControllsForSurveyForm": {
      "header_1_content": "Name: {input_1}",
      "input_1_label": "Input",
      "textarea_1_label": "TextArea",
      "dropdown_1_label": "Dropdown",
      "checkbox_1_label": "Checkbox",
      "input_2_label": "Input",
      "input_3_label": "Input",
      "input_4_label": "Input",
      "input_6_label": "Input",
      "button_1_content": "Button"
    },
    "TestControllsForSurveyForm_table": {
      "input_1_label": "Input",
      "textarea_1_label": "TextArea",
      "dropdown_1_label": "Dropdown",
      "checkbox_1_label": "Checkbox",
      "input_2_label": "Input",
      "input_3_label": "Input",
      "button_1_content": "Button"
    },
    "Server": {
      "Data_label": "Data",
      "LastHeartbeat_label": "LastHeartbeat",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "test123": {},
    "RespAccountChangePassword": {
      "header_1_content": "Please enter your new password",
      "oldPassword_label": "Old Password",
      "newPassword_label": "New Password",
      "confirmPassword_label": "Confirm Password",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "tableForm": {},
    "AggregatedCounter": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "testCustom2": {
      "input_112_label": "Input",
      "button_1_content": "Button"
    },
    "RespResetPasswordSuccess": {
      "header_1_content": "Check email for reset password link.",
      "btnSubmit_content": "Resend",
      "button_1_content": "Cancel"
    },
    "testForm": {
      "input_1_label": "Input"
    },
    "Hash": {
      "ExpireAt_label": "ExpireAt",
      "Field_label": "Field",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "testrequired": {
      "input_1_label": "Input",
      "button_1_content": "Button"
    },
    "testCustom": {},
    "RespResetPassword": {
      "resetPwdHeader_content": "Enter login to receive reset password link in email",
      "resetPwdHeader_subheader": "",
      "UID_label": "Respondent Login",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "sysdiagrams": {
      "definition_label": "definition",
      "name_label": "name",
      "principal_id_label": "principal_id",
      "version_label": "version",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplyMessages": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Manage message history of this deployment",
      "grid_DplyStep": "Step",
      "grid_NotifyMerge": "Mail Merge?",
      "grid_NotifyEmail": "Email?",
      "grid_NotifyGenerate": "Generate Profile?",
      "grid_SampleCount": "Number of Samples",
      "grid_CreatedDate": "Created On",
      "grid_UserName": "Created By",
      "button_3_content": "Back"
    },
    "testText": {
      "input_1_label": "Input"
    },
    "State": {
      "CreatedAt_label": "CreatedAt",
      "Data_label": "Data",
      "JobId_label": "JobId",
      "Name_label": "Name",
      "Reason_label": "Reason",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "JobQueue": {
      "FetchedAt_label": "FetchedAt",
      "JobId_label": "JobId",
      "Queue_label": "Queue",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "MP2015_Questionnaire": {
      "header_1_content": "Header",
      "input_1_label": "Input"
    },
    "JobParameter": {
      "JobId_label": "JobId",
      "Name_label": "Name",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "vSP_ListSampleCount": {
      "ListId_label": "ListId",
      "SampleCount_label": "SampleCount",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Schema": {
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Counter": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplysampleowner": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Assign Data Editors for Deployment Samplers",
      "DataEditor_label": "Data Editor",
      "gridview_1_UIDName": "UID (Name)",
      "gridview_1_PeerName": "Peer UID (Name)",
      "gridview_1_StatusTitle": "Status",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Response Complete",
      "gridview_1_DueDate": "Due Date",
      "button_1_content": "Save",
      "button_2_content": "Cancel"
    },
    "RespChangePassword": {
      "header_1_content": "Please enter your new password",
      "newPassword_label": "New Password",
      "confirmPassword_label": "Confirm Password",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "deletethis": {
      "header_4_content": "Attemp to hide container",
      "button_1_content": "Show Args",
      "toggle_label": "Toggle",
      "input_2_label": "Show = true",
      "input_3_label": "Show = false",
      "header_1_content": "Container A",
      "input_1_label": "1st"
    },
    "RespChangePasswordSuccess": {
      "header_1_content": "Change password successful",
      "btnSubmit_content": "Home"
    },
    "ResendTemplateOne": {
      "subject_content": "SP7: Resend",
      "body_content": "Dear {Name}!<br/><br/>\n\n<br />DplyName:  {DplyName}, <br />\n<br />DplyQnn: {DplyQnn}, <br /> \n<br />DplyList: {DplyList}, <br />\n<br />DplyCategory: {DplyCategory}, <br />\n<br />Name: {Name}, <br /> \n<br />Email: {Email}, <br /> \n<br />UID: {UID}, <br /> \n<br />UIDPeer: {UIDPeer}, <br /> \n<br />ActiveYN: {ActiveYN}, <br />\n<br />Password: {Password}, <br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<p>&nbsp;</p>\n"
    },
    "TestWorkflow": {
      "input_1_label": "Input",
      "button_1_content": "Button"
    },
    "LitterCount": {
      "Name_label": "Name",
      "Observer _label": "I am an Observer ",
      "dropdown_1_label": "Location"
    },
    "testreg": {
      "input_1_label": "Input"
    },
    "ThankYou": {
      "header_1_content": "Completion of Survey"
    },
    "List": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Set": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Score_label": "Score",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    }
  }
}', [StructDivisionId]=NULL WHERE ([Id]='CB82C0F3-8EA8-42A5-AAD7-CC6F3E07053A');
GO



------------------------------------
--Index numberId
CREATE UNIQUE INDEX [IDX_NumberId] ON [dbo].[QNN_SAMPLE]
([NumberId] ASC) 
GO

-----------------------------
--when listsample is deleted, cascade delete its resp (when sample is deleted, listsample is cascade deleted as well)
ALTER TABLE [dbo].[QNN_RESP] DROP CONSTRAINT [FK_QNN_RESP_ListUsrId]
GO

ALTER TABLE [dbo].[QNN_RESP] ADD CONSTRAINT [FK_QNN_RESP_ListSampleId] FOREIGN KEY ([ListSampleId]) REFERENCES [dbo].[QNN_LIST_SAMPLE] ([Id]) ON DELETE CASCADE ON UPDATE NO ACTION
GO




--------------------------------
--View for sample grid
--to do a database sync for this data model
Create VIEW [dbo].[vSP_QnnSampleActiveForGrid] AS 
select s.StructDivisionId, sd.Name as [StructDivisionName], q.Id, q.Name, q.UID, q.Email, q.ActiveYN, q.NumRetry from QNN_SAMPLE_STRUCTDIVISION s
inner join qnn_sample q on s.SampleId = q.Id
inner join StructDivision sd on sd.Id = s.StructDivisionId
where q.ActiveYN = 1 and q.IsDeleted = 0
GO
--------------
--Added delete qnnsample records
ALTER PROCEDURE [dbo].[spSP_DeleteByTableNameAndIds]
		@Ids NVARCHAR(MAX),
		@TableName NVARCHAR(50),
		@UserId uniqueidentifier,
		@StructDivisionId uniqueidentifier,
		@EventBatch uniqueidentifier,
		@EventDate datetime,
		@AuditOn AS BIT = 1

	AS
	BEGIN
		DECLARE @query_all  AS NVARCHAR(MAX),
		 @dplyIds  AS NVARCHAR(MAX);
		--DECLARE @AuditOn AS NVARCHAR(50);
		--set @AuditOn = (select [Value] from dwAppSettings where [Name] = 'AuditOn');

		SET NOCOUNT ON;

		if(UPPER(@TableName)='QNN_DPLY')
			BEGIN

				if(Exists(select top 1 1 from QNN_RESP where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))

					BEGIN
						IF @AuditOn=1
							BEGIN
								INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r left join QNN_RESP_ANS ra on ra.RespId = r.Id 
								where r.DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END
								
							delete from qnn_resp where DplyId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
					END

				IF @AuditOn=1
					BEGIN 
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_DPLY where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 
			END
		ELSE IF(UPPER(@TableName)='QNN_LIST')
		 BEGIN

				if(Exists(select top 1 1 from QNN_RESP r inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO AuditLog 
										(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
									SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r 
									inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id left join QNN_RESP_ANS ra on ra.RespId = r.Id 
									where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END

						delete r from qnn_resp r inner join QNN_LIST_SAMPLE s on r.ListSampleId=s.Id where s.ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

					END

				if(Exists(select top 1 1 from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
								where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId
							END									
							delete from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

					END
				IF @AuditOn=1
					BEGIN 
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_LIST', null, null,(select * from QNN_LIST 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;

					END

				delete from QNN_LIST where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')); 

		 END
		ELSE IF(UPPER(@TableName)='QNN_QNN')
		 BEGIN
				if(Exists(select top 1 1 from QNN_RESP  where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP', null, null,(select r.*, ra.QnnFieldId, ra.AnsVal from QNN_RESP r left join QNN_RESP_ANS ra on ra.RespId = r.Id 
								where r.QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END
						delete from qnn_resp where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ','));
	
					END

				if(Exists(select top 1 1 from QNN_DPLY where ListId IN( SELECT Item FROM dbo.splitIds(@Ids, ','))))
					BEGIN
						IF @AuditOn=1
							BEGIN 
								INSERT INTO AuditLog 
									(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
								SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_DPLY', null, null,(select * from QNN_DPLY 
								where QnnId IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
							END
						delete from QNN_DPLY where QnnId IN (select Item FROM dbo.splitIds(@Ids, ',')); 
					END
					IF @AuditOn=1
						BEGIN 
							INSERT INTO AuditLog 
								(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
							SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_QNN', null, null,(select * from QNN_QNN 
							where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
						END

				delete from QNN_QNN where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
		ELSE IF(UPPER(@TableName)='QNN_CATEGORY')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_CATEGORY', null, null,(select * from QNN_CATEGORY 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_CATEGORY where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_RESP_ADMIN')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_RESP_ADMIN', null, null,(select * from QNN_RESP_ADMIN 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_RESP_ADMIN where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_TRK_LIST_SAMPLE')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_TRK_LIST_SAMPLE', null, null,(select * from QNN_TRK_LIST_SAMPLE 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_TRK_LIST_SAMPLE where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END

		ELSE IF(UPPER(@TableName)='QNN_TRK_LIST')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_TRK_LIST', null, null,(select * from QNN_TRK_LIST 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
				delete from QNN_TRK_LIST where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
		ELSE IF(UPPER(@TableName)='QNN_SAMPLE')
		 BEGIN
				IF @AuditOn=1
					BEGIN
						INSERT INTO AuditLog 
							(Id, UserId, SampleId, EventBatch, EventDate, EventType, TableName, RecordId, ColumnName, OriginalValue, NewValue, StructDivisionId)
						SELECT NEWID(), @UserId, null, @EventBatch, @EventDate, 'Delete', 'QNN_SAMPLE', null, null,(select * from QNN_SAMPLE 
						where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ',')) FOR JSON AUTO), null, @StructDivisionId;
					END
			    delete p from QNN_LIST_SAMPLE_PROP p inner join QNN_LIST_SAMPLE ls on p.ListSampleId = ls.Id inner join QNN_SAMPLE s on s.Id = ls.SampleId where s.Id in( SELECT Item FROM dbo.splitIds(@Ids, ','))
				delete from QNN_SAMPLE where Id IN( SELECT Item FROM dbo.splitIds(@Ids, ','));  

		 END
	END
GO
-------------------------------------