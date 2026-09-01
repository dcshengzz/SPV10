-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_HELP.json
-- QNN_HELP-settings.json
-- UserAccessMatrix.json
-- UserAccessMatrix-settings.json
-- UserAccessMatrix-code.js

UPDATE [dwMetadata] SET
[Id]='23b8f3ee-35cc-4d74-8299-ca39d80a4d18', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_HELP.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 11:03:46.423', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-09 11:48:20.390', 
[Data]=N'[
  {
    "key": "header_2",
    "data-buildertype": "header",
    "content": "Online Help Content Management",
    "size": "large"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "Type",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 2,
                "value": "admin",
                "text": "Survey Admin"
              },
              {
                "key": 3,
                "value": "resp",
                "text": "Respondent Portal"
              }
            ],
            "style-width": "320px",
            "events": {},
            "defaultValue": "",
            "placeholder": "",
            "other-required": true
          },
          {
            "key": "Topic",
            "data-buildertype": "input",
            "label": "Topic",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "style-width": "480px"
          },
          {
            "key": "Heading",
            "data-buildertype": "input",
            "label": "Heading",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "style-width": "480px"
          },
          {
            "key": "Status",
            "data-buildertype": "checkbox",
            "label": "Visible",
            "toggle": true,
            "events": {}
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": []
          }
        ]
      }
    ]
  },
  {
    "key": "container_5",
    "data-buildertype": "container",
    "children": [
      {
        "key": "HelpContent",
        "data-buildertype": "swzhtml",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "onHtmlChange"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "other-visibleConition": "",
        "other-customValidation": "",
        "defaultValue": "",
        "hideOutput": "none",
        "other-required": true,
        "style-width": "640px"
      }
    ],
    "style-width": "800px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "btnSave",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "save"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "primary": true
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Save Editor",
        "events": {
          "onClick": {
            "actions": [
              "submitHtmlData"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "primary": true,
        "disabled": false,
        "fluid": false,
        "circular": true,
        "inverted": true,
        "compact": false,
        "secondary": true,
        "style-hidden": true
      },
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Fetch Editor State",
        "events": {
          "onClick": {
            "actions": [
              "fetchEditorState"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {}
            ]
          }
        },
        "primary": false,
        "disabled": false,
        "secondary": true,
        "style-hidden": true
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
                "value": "/form/swzHelpList"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-marginBottom": "20px"
  }
]' WHERE [Id]='23b8f3ee-35cc-4d74-8299-ca39d80a4d18';

UPDATE [dwMetadata] SET
[Id]='87808dc3-c297-44f0-a75e-f83eb22ad52a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_HELP-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 11:03:46.440', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-09 11:48:20.433', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_HELP",
  "lastUpdate": "2021-08-09T11:48:20.4340088+08:00",
  "entityId": "bb075204-7deb-44cc-9251-b1d158e816d3",
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
    }
  ],
  "dataMap": [
    {
      "id": "db188500-410c-b948-85ba-95072a3176f6",
      "attributeId": "a6368ee0-d4a5-4530-b1e4-bbcb4042d178",
      "control": "HelpContent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5a50392f-e54d-0e2f-73b1-6bdc4ad8f608",
      "attributeId": "6c306562-8aad-4af6-ae9b-d82b09b73f01",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8551abf1-fa37-ca9a-1180-18dd8498b685",
      "attributeId": "07b14e69-f5aa-470d-b8d3-24c94fd722fd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc1f01c5-751f-9cae-34f6-4cd6827badc6",
      "attributeId": "90a76b37-0d22-4e40-8524-f4f990a161d5",
      "control": "Heading",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9e78c85f-8330-54f6-141d-1dafdfff716f",
      "attributeId": "fbbc33ef-0afc-41f0-9b89-7f15de2865d2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "98b6ba10-12d1-0a43-ca6e-9a8575519ede",
      "attributeId": "9f9bcc38-0aef-489c-b86f-f33ef689e9f8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "90935ca2-0db8-1f6d-444c-310b7b83380d",
      "attributeId": "67f07b78-31a9-4d5d-bab8-ae1e6bd0ad49",
      "control": "Status",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f3d6810a-b9a7-3142-0479-2d97428c5660",
      "attributeId": "459a9286-34fe-4a23-9992-362731d39f49",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ee59f60a-0487-dadc-5d95-123bcaf8eb79",
      "attributeId": "d22e5a5a-0542-4dbe-9dc7-00a6c914e515",
      "control": "Topic",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "246dcd52-bdc7-3150-4bd3-bbd2c436dd0a",
      "attributeId": "94da5047-34a7-42a0-97ca-09e704f33af0",
      "control": "Type",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0b47d650-15e8-4233-a9fc-3191f50e2df2",
      "attributeId": "785f4da2-afa1-4ec5-8c14-05cbef3c8601",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c8205e0c-7502-98f8-3555-38fe4a5ce0a6",
      "attributeId": "00f4c6f4-cb93-4e0a-acc2-2388284927bf",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Content"
}' WHERE [Id]='87808dc3-c297-44f0-a75e-f83eb22ad52a';

UPDATE [dwMetadata] SET
[Id]='8192e808-5af8-4759-acac-ccf130460ef0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.250', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-09 11:34:51.683', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "User Access Matrix",
    "size": "huge",
    "style-marginBottom": "20px",
    "textAlign": "left"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "Aspect",
            "data-buildertype": "dropdown",
            "label": "User Access Aspect",
            "fluid": false,
            "selection": true,
            "data-elements": [],
            "placeholder": "",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "onChangeAspect",
                  "apply"
                ],
                "targets": [
                  "Download"
                ],
                "parameters": []
              }
            },
            "style-source": "",
            "style-marginBottom": "12px",
            "style-marginRight": "12px",
            "defaultValue": "",
            "disabled": false
          },
          {
            "key": "Download",
            "data-buildertype": "button",
            "content": "Download",
            "primary": true,
            "floated": "",
            "other-visibleConition": "",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "onDownload"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-hidden": false,
            "style-marginLeft": "",
            "style-marginTop": "",
            "fluid": false,
            "style-source": "",
            "style-marginBottom": "12px",
            "style-marginRight": "12px"
          }
        ],
        "style-width": "100%",
        "style-source": "",
        "style-marginBottom": ""
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "result",
            "data-buildertype": "staticcontent",
            "content": "",
            "isHtml": true,
            "isPre": true,
            "fetchData": true
          }
        ],
        "style-float": "",
        "style-marginTop": "40px"
      }
    ],
    "style-marginBottom": "10px"
  }
]' WHERE [Id]='8192e808-5af8-4759-acac-ccf130460ef0';

UPDATE [dwMetadata] SET
[Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-23 12:18:10.310', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-09 11:34:51.787', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-08-09T11:34:51.7715705+08:00",
  "isTemplate": false,
  "securityGroup": ""
}' WHERE [Id]='a5429522-1a5d-4cfb-b902-73c4a0611b2d';

UPDATE [dwMetadata] SET
[Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-26 15:58:32.583', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-08 21:05:09.237', 
[Data]=N'{
    init: function(args){
        const _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
        
        const _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        _loadingStart();
        
        const innerArgs = args;
        const url = ''/report/useraccessmatrix/options'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''get''
            })
            .then(response => {
                return response.json();
            })
            .then(response => {
                _loadingStop();
                var dropdownoptions = function (model) {
                    model[''label''] = ''User Access Aspect'';
                    model[''data-elements''] = response.options;
                };
                CloverApp.API.rewriteControlModel("Aspect", dropdownoptions);
                CloverApp.API.setDataField("Aspect", "Role");
                
                innerArgs.data.Aspect = "Role";
                useraccessmatrixUserActions.onChangeAspect(args);
                
            })
            .catch(error => {
                _loadingStop();
                alertify.error(error.message);;
            });
    },
    
    onChangeAspect: function(args){
        if(args.data.Aspect == undefined || args.data.Aspect == "")
            return;

        var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
        
        var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        _loadingStart();
        
        var formData = new FormData();
        formData.append(''aspect'', args.data.Aspect);
        var url = ''/report/useraccessmatrix'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => {
                return response.json();
            })
            .then(response => {
                _loadingStop();
                if (response.Success) {
                    var htmlOverall = ''<div class="field"><label>Result</label></div><div>'' + response.Result + ''</div>''
                    CloverApp.API.setDataField("result", htmlOverall);
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                _loadingStop();
                alertify.error(error.message);;
            });
    },
    
    onDownload: function(args){
        
        if(args.data.Aspect == undefined || args.data.Aspect == "")
            return;

        var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
        
        var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
        
        _loadingStart();
        
        var formData = new FormData();
        formData.append(''aspect'', args.data.Aspect);    
        var url = ''/report/useraccessmatrix/download'';
        
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.blob())
            .then(blob => {
                _loadingStop();
                var url = window.URL.createObjectURL(blob);
                var a = document.createElement(''a'');
                a.href = url;
                a.download = ''User '' + args.data.Aspect + '' Access Matrix.pdf'';
                document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
                a.click();    
                a.remove();  //afterwards we remove the element again  
            })
            .catch(error => {
                _loadingStop();
                alertify.error(error.message);;
            });

    }
}' WHERE [Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6';

