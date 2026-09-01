-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_DPLY_PRE_POPULATE.json
-- QNN_DPLY_PRE_POPULATE-code.js
-- QNN_DPLY_PRE_POPULATE-settings.json
-- QNN_DPLY.json
-- QNN_DPLY-settings.json

UPDATE [dwMetadata] SET
[Id]='54181d8d-523f-4075-ac8e-575e817af26b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:50:14.213', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-03 23:48:07.247', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Data Pre-Populate",
    "size": "huge",
    "subheader": " {Name}"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "Deployment",
        "data-buildertype": "dictionary",
        "label": "Source Deployment",
        "fluid": true,
        "selection": true,
        "dataModel": "vSP_DeploymentOnline",
        "columns": "Name ASC",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "removeAllFields"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "clearable": true,
        "multiple": false,
        "filters": "[{\"column\":\"Id\", \"value\":\"{Id}\", \"term\":\"!=\"}]"
      }
    ],
    "style-width": "50%",
    "style-marginBottom": "20px",
    "events": {}
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_3",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "DeploymentQnnFields",
        "data-buildertype": "dictionary",
        "label": "Source Fields",
        "fluid": true,
        "selection": true,
        "dataModel": "vSP_DeploymentQnnFields",
        "columns": "Name, NumberId asc",
        "events": {
          "onChange": {
            "active": false,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        },
        "style-customcss": "",
        "clearable": true,
        "multiple": true,
        "filters": "[{\"column\":\"DplyId\", \"value\":\"{Deployment}\", \"term\":\"=\"}]",
        "search": true
      },
      {
        "key": "container_6",
        "data-buildertype": "container",
        "children": [
          {
            "key": "addAllFields",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "Add All",
                "url": "/",
                "active": false
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "addAllFields"
                ],
                "targets": [
                  "DeploymentQnnFields"
                ],
                "parameters": []
              }
            },
            "style-marginRight": "10px"
          },
          {
            "key": "breadcrumb_1",
            "data-buildertype": "breadcrumb",
            "items": [
              {
                "text": "Remove All",
                "url": "/",
                "active": false
              }
            ],
            "events": {
              "onItemClick": {
                "active": true,
                "actions": [
                  "removeAllFields"
                ],
                "targets": [
                  "DeploymentQnnFields"
                ],
                "parameters": []
              }
            }
          }
        ]
      }
    ],
    "style-width": "50%",
    "style-marginBottom": "20px",
    "events": {},
    "other-visibleConition": "data.Deployment"
  },
  {
    "key": "container_5",
    "data-buildertype": "container",
    "style-source": "clear: both;",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "button_1",
        "data-buildertype": "button",
        "content": "Pre-Populate",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "prePopulate"
            ],
            "targets": [
              "DeploymentQnnFields"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Cancel",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirectToForm"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "formName",
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true,
        "inverted": true
      }
    ],
    "style-marginBottom": "20px",
    "events": {},
    "other-visibleConition": "data.Deployment"
  }
]' WHERE [Id]='54181d8d-523f-4075-ac8e-575e817af26b';

UPDATE [dwMetadata] SET
[Id]='d31cbc75-a3e9-46fc-9176-7ada5ecd7c09', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:51:04.643', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-03 23:47:46.050', 
[Data]=N'{
    addAllFields: function(args){
        var allFields = args.controlRef.state.options.map(function(option){
            return option.key;
        });
        CloverApp.API.setDataField("DeploymentQnnFields", allFields);
    },
    removeAllFields: function(args){
        CloverApp.API.setDataField("DeploymentQnnFields", []);
    },    
    
    prePopulate: function(args){
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});        
        
        var fieldIds = args.controlRef.props.value;
        if(!fieldIds || fieldIds.length==0){
            alertify.error("Please select at least one field");
            return;
        }
        var dplyId = args.data.Id;
        var sourceDplyId = args.data.Deployment;
        var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''fieldIds'', fieldIds); 
        formData.append(''sourceDplyId'', sourceDplyId);         
        var url = ''/deployment/prepopulate'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                   
                if (response.success) {
                    alertify.success(response.message);
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(() => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');                
            });            
    }
 
}' WHERE [Id]='d31cbc75-a3e9-46fc-9176-7ada5ecd7c09';

UPDATE [dwMetadata] SET
[Id]='3ec905bd-86b6-457c-a0e8-073beb43fb6f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:50:14.283', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-03 23:48:07.323', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_DPLY_PRE_POPULATE",
  "lastUpdate": "2021-08-03T23:48:07.3167405+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "c786f28a-7c1d-18a1-4e82-b9f14e49d539",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0967f63c-7b85-ccb8-9303-3e9b7cf2fe33",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5023f9da-3f2e-dda2-0f73-5a6311cce0c7",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "83bce928-58fa-df11-8c38-8023ae24ffd3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "deca8cf6-dcd5-16dd-b0c0-394a30bc5bb4",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1b987af7-cddd-db61-fcd8-22c3f4c53430",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "374a9edc-ec27-f0f3-e318-ae95b1d65d56",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6368b51c-2ae4-cb3a-5ef7-1b413c202b5c",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "26703d56-1156-31f0-171d-e8d87610d564",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3b4f621f-b303-8322-460f-b72a0b58edec",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8579bacc-ad88-1655-66bf-fc4c0bc0e799",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a20baeb1-4027-5887-98ef-be1c2688cb8b",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c032b3d1-5303-f950-b1e0-23b6f059fa21",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8713a7b4-640f-8759-797b-8a6bfed64ca5",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7c124c4a-951e-b2cb-a968-d8c5273788e1",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "dfd118fb-c4ae-28e5-0842-3651bbcc6547",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "05468910-5730-4606-ca8a-2e51c41a049b",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e4805992-33ac-ccb9-86e7-8dc8676e91d8",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0d2eaa09-3b24-f802-60f0-866ee281d2bb",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "08388972-fcf2-f431-14ee-2760c49ac885",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "32f0783b-3ac4-05ef-afcb-513c0cf8a96a",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "22f01e4c-f4f5-b0a8-9ace-fff152c8861f",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2f395ae-8032-fb82-68ff-21491768e624",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8c9d150c-a4f8-bb87-e6d9-a1bc85955e43",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4cba037-57a7-977b-5611-779850d41495",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "16fdf4f0-9710-d9c5-dfd9-919d2566a221",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9460cdee-c086-e3af-0ccd-b73915f33012",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5bf9eaaa-01b8-944f-0718-aa190ae0afa8",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "42882ed3-0f8e-6d54-2a52-3499a8ed8dc7",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "14a0cd73-68bc-b02e-36eb-c474113482f2",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4a3934ed-0ab2-ddfe-94b6-5dcefe8dfc01",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b217f1e9-4d95-46af-6850-93438bbaa77b",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bda4a316-cb9c-9c63-031a-d5f5c962de8c",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "40074d33-2215-8f83-a2c6-103e301b60d2",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0f7f7c29-6856-d67d-7a28-52c37db4898a",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a8f1c8a9-ccb9-8119-3302-300fef905b8e",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "53a8bb29-ee35-bbbe-5e21-53706eb76527",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "29d92318-26b2-a87c-2a62-36fc4e014814",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cb1eb284-f895-ba94-87d0-22c7a6553d6a",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "624201ff-d565-fd15-2cb0-b007910456ac",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fad4c089-b443-251a-f24e-708131b711ea",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2eba97d8-5a12-25d7-e37a-a52fea864488",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5a106511-5ee8-8d68-456d-122801b83c44",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e8ca787-2034-33c4-5966-190cfc0d1d78",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8dbefaa4-9886-95c2-ed6b-fcda217425d8",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "56b98d6c-ecf2-cf2c-dba7-29a2ea1a4cf3",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "722646b8-e0fa-5664-a7d1-9e3fa23bd1e9",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "739c6a49-f04a-f95b-2e67-863ae59a2db2",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4c505d0d-4bd1-3673-b360-3af13fe1c638",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4fb7b109-f7b4-1e28-0944-1371fb8059de",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "85ea249a-e020-aa37-6bf2-b1e891cd656e",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": []
}' WHERE [Id]='3ec905bd-86b6-457c-a0e8-073beb43fb6f';

UPDATE [dwMetadata] SET
[Id]='655275cf-8202-4438-b66b-874eab315889', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-03 23:57:12.553', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_7",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left",
            "subheader": ""
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_23",
        "data-buildertype": "container",
        "children": [
          {
            "key": "workflowbar_1",
            "data-buildertype": "workflowbar",
            "events": {
              "onCommandClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowExecuteCommand",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              },
              "onSetStateClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowSetState",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "blockSetState": true,
            "other-visibleConition": ""
          },
          {
            "key": "container_21",
            "data-buildertype": "container",
            "children": [
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<strong>State:</strong> {StateName}",
                "isHtml": true
              }
            ]
          },
          {
            "key": "form_3",
            "data-buildertype": "form",
            "children": [
              {
                "key": "Remarks",
                "data-buildertype": "textarea",
                "label": "",
                "fluid": true,
                "style-width": "",
                "reference": "Remarks",
                "events": {},
                "placeholder": "Please append your remarks",
                "style-customcss": "ui fluid input",
                "other-required": false
              }
            ]
          },
          {
            "key": "formgroup_9",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": []
          }
        ],
        "style-source": "",
        "style-customcss": "ui message",
        "other-visibleConition": "data.Id && data.EnableWorkflow"
      },
      {
        "key": "formgroup_10",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "container_22",
            "data-buildertype": "container",
            "style-float": "right",
            "children": [
              {
                "key": "container_13",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "importModal",
                    "data-buildertype": "swzmodal",
                    "style-source": "float: right;",
                    "secondary": true,
                    "content": "Import Response",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_1",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "header_3",
                            "data-buildertype": "header",
                            "content": "Import Response",
                            "size": "medium",
                            "events": {},
                            "other-visibleConition": ""
                          },
                          {
                            "key": "listFile",
                            "data-buildertype": "input",
                            "label": "",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "file",
                            "style-marginTop": "10px"
                          },
                          {
                            "key": "totalRows",
                            "data-buildertype": "header",
                            "content": "Total rows: {totalRows}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalRows!= null && data.totalRows!= undefined)"
                          },
                          {
                            "key": "totalSampleResponseAdded",
                            "data-buildertype": "header",
                            "content": "Rows added: {totalSampleResponseAdded}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalSampleResponseAdded!= null && data.totalSampleResponseAdded!= undefined)"
                          },
                          {
                            "key": "totalSampleNoResponse",
                            "data-buildertype": "header",
                            "content": "Rows not added (No response): {totalSampleNoResponse}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                          },
                          {
                            "key": "totalInvalidUIDs",
                            "data-buildertype": "header",
                            "content": "Rows not added (Invalid UID): {totalInvalidUIDs}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                          },
                          {
                            "key": "totalInvalidQnnColumns",
                            "data-buildertype": "header",
                            "content": "Total invalid columns: {totalInvalidQnnColumns}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidQnnColumns!= null && data.totalInvalidQnnColumns!= undefined)"
                          },
                          {
                            "key": "moreModal",
                            "data-buildertype": "swzmodal",
                            "style-source": "",
                            "secondary": true,
                            "content": "More information",
                            "style-display": "none",
                            "children": [
                              {
                                "key": "form_2",
                                "data-buildertype": "form",
                                "children": [
                                  {
                                    "key": "form_2",
                                    "data-buildertype": "form",
                                    "children": [
                                      {
                                        "key": "container_13",
                                        "data-buildertype": "container",
                                        "style-float": "right",
                                        "children": [
                                          {
                                            "key": "invalidQnnColumns",
                                            "data-buildertype": "header",
                                            "content": "Invalid columns:  {totalInvalidQnnColumns}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_1",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidColumns"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                          },
                                          {
                                            "key": "invalidUIDs",
                                            "data-buildertype": "header",
                                            "content": "Invalid rows (UID): {totalInvalidRows}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_2",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidUIDs"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                          },
                                          {
                                            "key": "totalInvalidDates_Updated",
                                            "data-buildertype": "header",
                                            "content": "Total invalid date start and complete: {totalInvalidDates_Updated}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.totalInvalidDates_Updated!= undefined && data.totalInvalidDates_Updated.length > 0)",
                                            "style-hidden": true
                                          },
                                          {
                                            "key": "invalidDates_Updated",
                                            "data-buildertype": "header",
                                            "content": "Invalid date start and complete : {totalInvalidDates_Updated}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_3",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidDates"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                          },
                                          {
                                            "key": "button_1",
                                            "data-buildertype": "button",
                                            "content": "Cancel",
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
                                                  "closeMoreModal"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "",
                                            "style-source": "float: right;",
                                            "inverted": false,
                                            "secondary": true
                                          }
                                        ],
                                        "style-marginRight": "",
                                        "style-width": "100%",
                                        "style-marginBottom": "",
                                        "style-source": ""
                                      }
                                    ],
                                    "style-source": "overflow-y: auto;\noverflow-x: auto;"
                                  }
                                ],
                                "style-source": "overflow-y: auto;\noverflow-x: auto;"
                              }
                            ],
                            "size": "",
                            "events": {
                              "onClick": {
                                "active": false,
                                "actions": [],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "other-customValidation": "",
                            "other-visibleConition": "(data.invalidUIDs != null && data.invalidUIDs != undefined)"
                          },
                          {
                            "key": "container_17",
                            "data-buildertype": "container"
                          },
                          {
                            "key": "formgroup_7",
                            "data-buildertype": "formgroup",
                            "widths": "equal"
                          },
                          {
                            "key": "container_7",
                            "data-buildertype": "container",
                            "style-float": "right",
                            "children": [
                              {
                                "key": "btnImportCancel",
                                "data-buildertype": "button",
                                "content": "Cancel",
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
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                },
                                "other-visibleConition": "",
                                "style-source": "float: right;",
                                "inverted": false,
                                "secondary": true
                              },
                              {
                                "key": "btnImportSave",
                                "data-buildertype": "button",
                                "content": "Save",
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
                                      "submitFile"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                },
                                "other-visibleConition": "",
                                "style-source": "float: right;"
                              }
                            ],
                            "style-marginRight": "",
                            "style-width": "100%",
                            "style-marginBottom": "10px"
                          }
                        ],
                        "style-source": "overflow-y: auto;\noverflow-x: auto;"
                      }
                    ],
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "data.Id && CloverApp.API.checkRole(''Admins'')",
                    "style-marginLeft": ""
                  }
                ],
                "style-float": "right",
                "style-marginLeft": "",
                "other-visibleConition": ""
              },
              {
                "key": "container_8",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "buttonManageMessageHistory",
                    "data-buildertype": "button",
                    "content": "Manage Message History",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "redirectToForm"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyMessages"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  },
                  {
                    "key": "buttonManageListSamples",
                    "data-buildertype": "button",
                    "content": "Manage List Samples",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "redirectToForm"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyListSample"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  }
                ],
                "style-float": "right",
                "style-marginLeft": "",
                "style-marginRight": "3.5px"
              },
              {
                "key": "container_12",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "buttonManageDataEditors",
                    "data-buildertype": "button",
                    "content": "Manage Data Editors",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirectToForm"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplySampleOwner"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "floated": "right"
                  },
                  {
                    "key": "buttonManagePrePopulate",
                    "data-buildertype": "button",
                    "content": "Manage Pre-Populate",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirectToForm"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "QNN_DPLY_PRE_POPULATE"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''PrePopulate'')",
                    "floated": "right"
                  },
                  {
                    "key": "button_5",
                    "data-buildertype": "button",
                    "content": "Manage Validation Data",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "redirectToForm"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyValidation"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  },
                  {
                    "key": "btnManageRecurringDeployments",
                    "data-buildertype": "button",
                    "content": "Manage Recurring Deployments",
                    "secondary": true,
                    "floated": "right",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "redirectToForm"
                        ],
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplyRecurrence"
                          }
                        ]
                      }
                    },
                    "other-visibleConition": "data.Id!=null"
                  }
                ],
                "style-float": "right",
                "style-width": "100%",
                "style-marginTop": "15px"
              }
            ]
          }
        ]
      }
    ],
    "style-width": "100%",
    "style-float": "right"
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
            "key": "headerBasicProperties",
            "data-buildertype": "header",
            "content": "Basic Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "textName",
                "data-buildertype": "input",
                "label": "Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "other-customValidation": "",
                "other-required": true,
                "events": {},
                "reference": "Deployment Name"
              },
              {
                "key": "dictCategory",
                "data-buildertype": "dictionary",
                "label": "Category",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_CATEGORY",
                "placeholder": "Select category...",
                "columns": "Name ASC",
                "search": true,
                "other-required": false,
                "other-readOnlyConition": "",
                "clearable": true,
                "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
              },
              {
                "key": "dictQuestionnaire",
                "data-buildertype": "dictionary",
                "label": "Questionnaire",
                "fluid": true,
                "selection": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "dropdownQuestionnaireOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "onChangeTimeout": "",
                "dataModel": "QNN_QNN",
                "columns": "Title ASC",
                "placeholder": "Select a questionnaire...",
                "other-required": true,
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                "other-readOnlyConition": "",
                "reference": "Questionnaire"
              },
              {
                "key": "dictList",
                "data-buildertype": "dictionary",
                "label": "List",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_LIST",
                "columns": "Name ASC",
                "search": true,
                "events": {},
                "placeholder": "Select a list...",
                "other-required": true,
                "style-source": "",
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                "other-readOnlyConition": "",
                "other-visibleConition": "",
                "reference": "List"
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "events": {},
            "style-source": "clear:both;"
          },
          {
            "key": "formGroupStartEndDate",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "DateStart",
                "data-buildertype": "input",
                "label": "Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "z-index: 1000;",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": true
              },
              {
                "key": "DateEnd",
                "data-buildertype": "input",
                "label": "End On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-readOnlyConition": "",
                "other-required": true,
                "style-source": "z-index: 1000;"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "fg_RecurrenceInfo",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "This is a recurring deployment."
              },
              {
                "key": "RecurrenceNextDate",
                "data-buildertype": "input",
                "label": "Next Deployment Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "z-index: 1000;",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": false,
                "readOnly": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3",
            "orientation": "grouped",
            "other-visibleConition": "data.RecurrenceEnabled"
          },
          {
            "key": "formgroup_5",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "VisibleToRespondent",
                "data-buildertype": "checkbox",
                "label": "Visible to Respondent",
                "defaultValue": "True",
                "toggle": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_IsExcelEnabled",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "IsExcelEnabled",
                "data-buildertype": "checkbox",
                "label": "Enable Online Excel Support",
                "defaultValue": "",
                "toggle": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_12",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "RequireAccessCode",
                "data-buildertype": "checkbox",
                "label": "Require Access Code",
                "defaultValue": "",
                "toggle": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_11",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "EnableWorkflow",
                "data-buildertype": "checkbox",
                "label": "Enable Workflow",
                "defaultValue": "0",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setDplyState"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "other-required": false,
                "other-readOnlyConition": "data.Id",
                "reference": "Enable Workflow"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_8",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "IsMultipleResponse",
                "data-buildertype": "checkbox",
                "label": "Allow Multiple Responses",
                "defaultValue": "0",
                "toggle": true,
                "events": {},
                "other-required": false,
                "other-readOnlyConition": "data.Id"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_6",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "IsAnonymous",
                "data-buildertype": "checkbox",
                "label": "Is Anonymous",
                "defaultValue": "0",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "toggleCompletionUrl"
                    ],
                    "targets": [
                      "textCompleteURL"
                    ],
                    "parameters": []
                  }
                },
                "other-required": false,
                "style-width": "50%",
                "other-readOnlyConition": "data.Id"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "textCompleteURL",
                "data-buildertype": "input",
                "label": "Completion URL",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "",
                "other-visibleConition": "data.IsAnonymous== ''1'' ? true : false",
                "events": {},
                "style-marginLeft": "",
                "other-customValidation": "!(data.IsAnonymous== ''1''  && !value)? true : '' - Please provide completion URL for anonymous survey''",
                "style-width": "",
                "reference": "Completion URL"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium",
            "style-hidden": true
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "radioCompletionAction",
                "data-buildertype": "radiogroup",
                "label": "Action",
                "data-elements": [
                  {
                    "key": 1,
                    "value": "C",
                    "text": "Do nothing"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Redirect to URL"
                  }
                ],
                "direction": "v",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "radioCompletionActionOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "C"
              },
              {
                "key": "textCompleteURL-3",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ],
            "style-hidden": true
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "hedderNavigationProperties",
                "data-buildertype": "header",
                "content": "Navigation Properties",
                "size": "medium"
              },
              {
                "key": "fromGroupNavigationProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "radioNavBack",
                    "data-buildertype": "radiogroup",
                    "label": "Back Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "0",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "1",
                        "text": "Show"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavBackOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "8px",
                    "defaultValue": "0"
                  },
                  {
                    "key": "radioNavCancel",
                    "data-buildertype": "radiogroup",
                    "label": "Cancel Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "N",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "Y",
                        "text": "Show"
                      },
                      {
                        "key": 3,
                        "value": "YURL",
                        "text": "Show and redirect to URL"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavCancelOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "defaultValue": "N"
                  },
                  {
                    "key": "textNavCancelUrl",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "size": "",
                    "placeholder": "Specify redirect url (http://www.google.com)",
                    "style-marginLeft": "24px",
                    "events": {},
                    "other-visibleConition": "data.radioNavCancel == ''YURL'' ? true : false"
                  }
                ]
              }
            ],
            "style-hidden": true
          },
          {
            "key": "headerResponseProperties",
            "data-buildertype": "header",
            "content": "Response Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "custom",
            "widthsCustom": "2",
            "children": [
              {
                "key": "MaxResponse",
                "data-buildertype": "input",
                "label": "Maximum Number of Responses",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "events": {},
                "defaultValue": "-1"
              },
              {
                "key": "DaysUpdate",
                "data-buildertype": "input",
                "label": "Days for Update",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "defaultValue": "0",
                "events": {}
              }
            ]
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "cbMailMerge",
                    "data-buildertype": "checkbox",
                    "label": "Mail Merge",
                    "slider": true,
                    "toggle": true,
                    "style-marginRight": "20px",
                    "defaultValue": ""
                  },
                  {
                    "key": "cbEmail",
                    "data-buildertype": "checkbox",
                    "label": "Email",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "breadcrumb_4",
                    "data-buildertype": "breadcrumb",
                    "items": [
                      {
                        "text": "Download Template",
                        "active": false
                      }
                    ],
                    "events": {
                      "onItemClick": {
                        "active": true,
                        "actions": [
                          "downloadEmailTemplate"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-width": "100%",
                    "style-source": "padding-top: 20px;"
                  }
                ]
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "emailFrom",
                    "data-buildertype": "input",
                    "label": "From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "(!data.cbEmail || ( value ? value : \"\" ) !== \"\" ) ? true : ''is required!''",
                    "reference": "Email From"
                  },
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "(!data.cbEmail || ( value ? value : \"\" ) !== \"\" ) ? true : ''is required!''",
                    "reference": "Email Subject"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "parseHtml"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-customValidation": ""
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px"
          }
        ]
      }
    ],
    "style-float": "left",
    "style-width": "100%"
  },
  {
    "key": "container_18",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_5",
        "data-buildertype": "header",
        "content": "Restriction Properties",
        "size": "medium",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "RestrictIp",
        "data-buildertype": "checkbox",
        "label": "Ip Restriction",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "setIpRestriction"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "reference": "Ip Restriction",
        "style-marginBottom": "20px",
        "defaultValue": "0"
      },
      {
        "key": "RestrictIpInclusive",
        "data-buildertype": "radiogroup",
        "label": "",
        "data-elements": [
          {
            "text": "Inclusive",
            "value": "1"
          },
          {
            "value": "0",
            "text": "Exclusive"
          }
        ],
        "defaultValue": "1",
        "other-visibleConition": "data.RestrictIp==1",
        "events": {
          "onChange": {
            "active": false,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "countryOrIpRange",
        "data-buildertype": "radiogroup",
        "label": "",
        "data-elements": [
          {
            "text": "Countries",
            "value": "1"
          },
          {
            "text": "IP Ranges",
            "value": "0"
          }
        ],
        "defaultValue": "1",
        "other-visibleConition": "data.RestrictIp==1",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "clearContent"
            ],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "IpCountry",
        "data-buildertype": "dropdown",
        "label": "IpCountry",
        "fluid": true,
        "selection": true,
        "data-elements": [
          {
            "key": 1,
            "value": "SG",
            "text": "Singapore"
          },
          {
            "value": "MY",
            "text": "Malaysia"
          }
        ],
        "multiple": true,
        "reference": "Respondent Country",
        "placeholder": "Select countries",
        "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange==1)",
        "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==1 && data.IpCountry && data.IpCountry!=\"[]\") || (data.countryOrIpRange==0))) || (data.RestrictIp!=1))?true:\"is required\"",
        "events": {}
      },
      {
        "key": "IpRange",
        "data-buildertype": "dropdown",
        "label": "",
        "fluid": true,
        "selection": true,
        "data-elements": [],
        "multiple": true,
        "search": true,
        "allowAddItems": true,
        "reference": "Ip Ranges",
        "placeholder": "192.168.0.0/24 or 192.168.0.0/255.255.255.0 or 192.168.0.0-192.168.0.255",
        "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==0 && data.IpRange && data.IpRange!=\"[]\") || (data.countryOrIpRange==1))) || (data.RestrictIp!=1) )?true:\"is required\"",
        "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange!=1)",
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      }
    ]
  },
  {
    "key": "container_14",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_16",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "children": []
      },
      {
        "key": "header_4",
        "data-buildertype": "header",
        "content": "Report Properties",
        "size": "medium",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "chkScheduler",
        "data-buildertype": "checkbox",
        "label": "Save Snap Shot Daily",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "container_9",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "dailySsForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlEmailReceipients",
            "data-buildertype": "dictionary",
            "label": "Email Recipient/s",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_dataEditors",
            "columns": "Name ASC",
            "clearable": true,
            "multiple": true,
            "events": {},
            "style-marginTop": "",
            "style-marginBottom": "",
            "other-visibleConition": "",
            "paging": true,
            "search": true
          },
          {
            "key": "container_15",
            "data-buildertype": "container",
            "style-marginTop": "30px",
            "style-marginBottom": "30px"
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "chkEmailSuccess",
                "data-buildertype": "checkbox",
                "label": "Email Success",
                "toggle": true
              },
              {
                "key": "chkEmailFail",
                "data-buildertype": "checkbox",
                "label": "Email Fail",
                "toggle": true
              }
            ],
            "style-marginTop": "30px",
            "style-marginBottom": "30px",
            "orientation": "inline"
          }
        ],
        "other-visibleConition": "(data.chkScheduler != null && data.chkScheduler != 0 ? true: false)",
        "events": {},
        "other-customValidation": "",
        "other-readOnlyConition": ""
      }
    ],
    "other-visibleConition": "data.Id != null",
    "style-marginTop": "30px",
    "style-marginBottom": "30px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "onClickSave",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": ""
      },
      {
        "key": "button_3",
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
                "value": "/form/SwzDplyList"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px",
    "style-marginTop": "30px"
  }
]' WHERE [Id]='655275cf-8202-4438-b66b-874eab315889';

UPDATE [dwMetadata] SET
[Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.340', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-03 23:57:12.743', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2021-08-03T23:57:12.7428773+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"Status\": 1, \"Target\": \"N\",  \"Type\": \"E\",  \"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": " {\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyListSampleAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyMessageAsync"
    }
  ],
  "schemes": [
    "DeploymentRequest"
  ],
  "dataMap": [
    {
      "id": "49dc498b-862f-8db6-c96b-436359c1fe8f",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "control": "dictCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09c51019-6736-b903-ba90-49c6648aed13",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "control": "radioCompletionAction",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "000c5d4f-1fd1-8038-2591-0d619c11d8ee",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "control": "textCompleteURL",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2438929-3329-c80c-347b-9da9c989eff3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9dec37ab-922a-3546-4a78-d6b6dbfbf2a9",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3da35281-aa29-eddf-9e7b-286819c16b08",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "control": "DateEnd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa74d157-9a98-478e-d389-68f6e93d0118",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "control": "DateStart",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b3dfd15-2fbb-ba91-0671-7a9e60427bc3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bdf7e66-15d8-b585-644a-c8ab8460baba",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c1b23718-7f5e-a000-e54d-d928be553567",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1fddbcc0-83cb-119d-8e03-374668bb8854",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "319c8862-be47-1e69-a018-f83506cfa587",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "textName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "97cf1d53-28c5-46a1-0570-4988a6104d89",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce20b9d-22e3-cdc0-5b10-313082777c45",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2636b43a-a3ea-062a-574f-85d081788a96",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3190228d-0386-0414-b011-49465dd5116f",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d61f2305-3c49-14f0-6874-50ec12c9ce67",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09a1c46f-5fa4-537b-0d2c-25485bd76070",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e30afa8-b7b8-876c-4373-81d1d7060dc7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bf95ec-8916-105b-2c75-aae713335918",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "control": "DaysUpdate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d067751-8f32-8b30-efae-13ca8d1128f7",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "control": "dictList",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15c4e305-59f8-430d-e37b-fddc34f0480b",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "control": "MaxResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9f046ca8-9da9-3947-464b-7b854ef030bd",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f16cb492-4407-54c3-d6b7-c7e2d65135c2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "control": "dictQuestionnaire",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "548a8469-7142-e4f2-83f4-ac0fcbc365f4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "control": "radioNavBack",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e736758a-1122-7948-e429-0308aa9d6fb1",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "control": "textNavCancelUrl",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72f8e742-b794-320f-5dca-aea702eff73e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "control": "radioNavCancel",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8cc321aa-0522-d13a-b458-8a1398b903dd",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ff5bbc4-a456-559e-c4a0-97641498a8ad",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9aabe66a-0436-b54f-3375-aafdfb544635",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "control": "IpCountry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "77c80616-2cc4-8e3a-47a1-916e3b253c0a",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "control": "IpRange",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ed9480e-d106-52bf-6f5b-6055e9675044",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "control": "RestrictIp",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48323722-f032-b2b1-15ba-2346b03eeaeb",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "control": "RestrictIpInclusive",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "68dd1fb3-a7ba-4da3-e29e-c3c86dc56c1b",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "control": "IsMultipleResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a2a6881-7799-8e4a-eba7-95a661d41d68",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "control": "IsAnonymous",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a52af75b-5993-3104-55da-3834eb95fe46",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "91a4529a-a930-e58f-8e1f-5267bb706693",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6bac7e8b-eff4-6235-3446-46309d7b5fcd",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "control": "EnableWorkflow",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7d6ec65c-7e41-b878-d192-16e9432da0dd",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9a73050-00ea-672f-b10e-3138c1b79ab6",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc809a51-2fad-044b-d321-9454cfe8f0db",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27cb805c-a635-c840-2433-1a87616a5dc0",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "257bf9f6-6af8-0f42-932b-e42a6016483f",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "936d7192-b817-1a15-9916-e032d4e77277",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a647292-82ca-62ea-4608-e916df1a54b9",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27ecd879-7354-02b8-c642-b8cce602dc9e",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d3fdfdd8-c4ff-5d98-c555-f77268ec9990",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "df1e19f4-7444-56ff-da28-26cdb1423e59",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf01c628-9c75-0af4-9cbc-33ebb397e66e",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "163ac591-1545-9b80-cbb1-44eefe356dd0",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2f7fadb0-ee58-46a1-d654-57eca28fd426",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "control": "IsExcelEnabled",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}' WHERE [Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd';

