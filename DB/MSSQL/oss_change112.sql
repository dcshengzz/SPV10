-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzDplyList-code.js
-- SwzDplyList-settings.json
-- SwzDplyList.json
-- swzHelpList-settings.json
-- swzHelpList.json

UPDATE [dwMetadata] SET
[Id]='4d440057-891c-4fe7-aa60-47b67638b311', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.280', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-08 19:13:28.073', 
[Data]=N'{
     init: function (args) {
        var innerArgs = args;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[model.columns.length-2].customFormatter = function (p) {
                    
                    //return CloverApp.API.createElement(''input'',{type: ''checkbox'', className: ''ui checkbox'', id: p.row.Id, defaultChecked: p.row.Status, onChange: () => showModal(innerArgs, p.row.Id)});
                    var url = "/deployment/download/resp/" + p.row.Id + "/" + p.row.QnnId;
                    if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
                    return CloverApp.API.createElement("a", {href: url, target: "_blank", onClick: (e)=>{e.stopPropagation()}}, p.row.RespCount + " / " + p.row.SampleCount);
                    //return CloverApp.API.createElement("a", {href: url}, "Export");  
                };
                model.columns[model.columns.length-1].customFormatter = function (p) {
                    //return CloverApp.API.createElement("div", {}, p.row.RespCount + " / " + p.row.SampleCount); 
                    if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
                    
                    return CloverApp.API.createElement("span", {onClick: (e)=> {e.stopPropagation(); swzdplylistUserActions.scheduleZipFileDownload(p.row.Id)}, className: ''link-style''}, ''Download Zip''); 
                };                

            }
            return model;
        };

        var activateDeploymentAsync = function (args, id) {
            
            if(!$(''#''+id).is('':checked'')){
                $(''#''+id).prop(''checked'', true);
                args.controlRef.refs.swzmodalNotAllowed.props.swzData.isOpen = true;
                args.controlRef.refs.swzmodalNotAllowed.openModal();
            }
            else{
                $(''#''+id).prop(''checked'', false);
                args.state.app.extra.dplyId = id;
                args.controlRef.refs.confirmModal.props.swzData.isOpen = true;
                args.controlRef.refs.confirmModal.openModal();
            }
  
            return {};
        };

        var showModal = function (args, id) {

            return activateDeploymentAsync(args, id);

        };

        CloverApp.API.rewriteControlModel("gridview_1", gridModelRewriter);

    },
    
    closeModal: function (args){
        //console.log("closeModal args:", args);
        args.component.refs.swzmodalNotAllowed.close();
    },


    activateDeployment: function (args) {
        
        var changeStatusAsync = function (id) {
            var formData = new FormData();
            formData.append(''id'', id);
            var url = ''/deployment/activate'';
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
                         $(''#''+id).prop(''checked'', true);

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });
                 args.component.refs.confirmModal.close();


        };
        console.log("activateDeployment args:", args);
        let id =  args.state.app.extra.dplyId;
        $(''#''+id).prop(''checked'', false);   
        changeStatusAsync(id);
        return {


        };

    },
    
    scheduleZipFileDownload: function (dplyId) {

        var url = ''/deployment/schedule/zipfiledownload/'' + dplyId;
        var d1 = new Date();
        Pace.start();
        $(''body'').loadingModal({
            text: ''Processing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});

        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {

        		var d2 = new Date();
        		var diff = (d2-d1)/1000;	
                if(diff<2){
        		    setTimeout(
            			function(){
    		                Pace.stop();
    		                $(''body'').loadingModal(''destroy'');
            			}, 2000);                     
                }
                if (response.success) {
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
        		var d2 = new Date();
        		var diff = (d2-d1)/1000;	
                if(diff<2){
        		    setTimeout(
            			function(){
    		                Pace.stop();
    		                $(''body'').loadingModal(''destroy'');
            			}, 2000);                     
                }                
                alertify.error(error.message);;
            });
    },

    updateFilter: function(args) {
        console.log("args to updateFilter", args);
        const data = args.data;
        
        const search = data.FilterSearch ? data.FilterSearch : null;
        const filterAnonymousType = data.FilterAnonymous ? data.FilterAnonymous : "AllAnonymous";
        const filterMultipleType = data.FilterMultiple ? data.FilterMultiple : "AllMultiple";
        
        const filter = [];
        if(search) {
            filter.push({
               column: "Name, QnnTitle, QnnType, ListName, CategoryName, CreatedDate",
               nextValue: search,
               term: "like",
               value: search,
            });
        }
        if("AllAnonymous" != filterAnonymousType) {
            filter.push({
               column: "IsAnonymous",
               nextValue: filterAnonymousType,
               term: "=",
               value: filterAnonymousType,
            });
        }
        if("AllMultiple" != filterMultipleType) {
            filter.push({
               column: "IsMultipleResponse",
               nextValue: filterMultipleType,
               term: "=",
               value: filterMultipleType,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridview_1: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta);
        return delta;
    },
    
}
' WHERE [Id]='4d440057-891c-4fe7-aa60-47b67638b311';

UPDATE [dwMetadata] SET
[Id]='fd2d5864-e3e9-45f8-a960-540bec63f6ec', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.327', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-08 19:08:58.090', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzDplyList",
  "lastUpdate": "2021-07-08T19:08:58.0833377+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "058228ef-f056-b36f-c7ec-702668c9294a",
      "entityId": "f80dfd0d-8d02-4fa0-b96d-a8d0a4b158c3",
      "filter": "StructAsyncFilter",
      "control": "gridview_1",
      "dataMap": [
        {
          "id": "20724308-7569-e228-19f7-8363d510a2f9",
          "attributeId": "7cf8625b-4118-4801-bfa3-e97948989e72",
          "control": "CategoryName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "19511b88-44e8-86e1-6d14-82bbe1011505",
          "attributeId": "f0a7d187-b968-4ad8-abec-e46b32bab0cf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9c6b9cbf-4767-22e2-ca9e-9ff48eb9966d",
          "attributeId": "619d0245-2d3b-46bc-ad67-4d0d69b779a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7aff8724-8cd0-625d-d36b-ace2a505e040",
          "attributeId": "a2a0d06f-d6d9-4452-9910-df0e88be6104",
          "control": "ListName",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9da9dd72-7068-08ac-d0a7-4923caf23aca",
          "attributeId": "abc42150-cc13-446b-9a8a-8277022e11d0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "99fe6b46-ff27-ee98-7bc3-8132656515e2",
          "attributeId": "bef244ee-2ee4-496d-82aa-b3c212ed1d0b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1a7a3938-317b-fb4b-0f19-49c9531e7035",
          "attributeId": "b1a5e363-bc28-40d6-864d-791bc353e150",
          "control": "QnnTitle",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c7b50251-f8e2-c9df-fe21-dfb83887e9d0",
          "attributeId": "d4044d06-1bd3-4e33-93ee-e0e7ef5384dc",
          "control": "QnnType",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "76e6c076-85d3-8ed9-07d2-1b267ceb476c",
          "attributeId": "932f78f2-eed2-43ad-a8ee-435d0fc7b3b8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14b37898-b089-fbbb-6db6-d83280200104",
          "attributeId": "5a4cf42f-8ec4-446c-81cf-ae35f7318a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d083abec-c35f-6363-3a7d-862b0526ef58",
          "attributeId": "f29c04ff-05dc-4c47-9ba3-47c0b54a3a74",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a72c10e3-ad37-5968-ecc4-3d3a0a3fd32f",
          "attributeId": "04522c05-b4ee-4c68-ba7d-a94236d7f0b4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c0c7530a-11ac-6e69-4b3b-714e51056ab3",
          "attributeId": "623bdb8d-e43f-4157-8944-6c3cdb497a89",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='fd2d5864-e3e9-45f8-a960-540bec63f6ec';

UPDATE [dwMetadata] SET
[Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.377', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-08 19:08:43.037', 
[Data]=N'[
  {
    "key": "container_4",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_2",
        "data-buildertype": "header",
        "content": "Deployment",
        "size": "huge",
        "style-source": "",
        "events": {}
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonAdd",
            "data-buildertype": "button",
            "content": "Create",
            "primary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridCreate"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "style-marginBottom": "0.25em"
          },
          {
            "key": "buttonDelete",
            "data-buildertype": "button",
            "content": "Delete",
            "secondary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "gridDelete"
                ],
                "targets": [
                  "gridview_1"
                ],
                "parameters": []
              }
            },
            "circular": false,
            "style-marginBottom": "0.25em"
          },
          {
            "key": "FilterSearch",
            "data-buildertype": "input",
            "label": "",
            "fluid": false,
            "onChangeTimeout": 200,
            "placeholder": "Search...",
            "style-width": "300px",
            "style-source": "",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-marginBottom": "0.25em",
            "style-marginRight": "0.25em"
          },
          {
            "key": "FilterAnonymous",
            "data-buildertype": "dropdown",
            "label": "",
            "fluid": false,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "AllAnonymous",
                "text": "Filter Anonymous"
              },
              {
                "key": 2,
                "value": "true",
                "text": "Show Anonymous ONLY"
              },
              {
                "key": 3,
                "value": "false",
                "text": "Show Not Anonymous ONLY"
              }
            ],
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "defaultValue": "AllAnonymous",
            "style-source": "",
            "style-marginBottom": "0.25em",
            "style-marginRight": "0.25em"
          },
          {
            "key": "FilterMultiple",
            "data-buildertype": "dropdown",
            "label": "",
            "fluid": false,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "AllMultiple",
                "text": "Filter Multiple"
              },
              {
                "key": 2,
                "value": "true",
                "text": "Show Multiple ONLY"
              },
              {
                "key": 3,
                "value": "false",
                "text": "Show Not Multiple ONLY"
              }
            ],
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "defaultValue": "AllMultiple",
            "style-marginBottom": "0.25em",
            "style-marginRight": "0.25em"
          }
        ],
        "style-float": "left",
        "style-marginBottom": "",
        "style-source": ""
      }
    ],
    "events": {},
    "style-source": "width: 100%;\nfloat:left;",
    "style-marginRight": "",
    "style-marginTop": "",
    "style-marginBottom": "1em"
  },
  {
    "key": "gridview_1",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "IsAnonymous",
        "name": "Anonymous",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "IsMultipleResponse",
        "name": "Multiple",
        "type": "checkbox",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "QnnTitle",
        "name": "Form",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "QnnType",
        "name": "Type",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "ListName",
        "name": "List",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "CategoryName",
        "name": "Category",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "CreatedDate",
        "name": "Date Created",
        "type": "datetime",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "Response",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "name": "Response"
      },
      {
        "key": "Action",
        "name": "Action",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false
      }
    ],
    "editForm": "QNN_DPLY",
    "rowKey": "Id",
    "multiselect": true,
    "defaultSort": "Name ASC",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowDblClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onSelectionChanged": {
        "active": false,
        "actions": [],
        "targets": [],
        "parameters": []
      }
    },
    "pagerType": "server",
    "autoHeight": false,
    "offSet": "100px",
    "style-marginTop": "10px",
    "rowHeight": "80",
    "minHeight": "500"
  }
]' WHERE [Id]='5fa900f6-191c-4135-977d-f1c8c3d06d38';

UPDATE [dwMetadata] SET
[Id]='0def75a6-d5e4-4c2c-8547-962065127c70', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzHelpList-settings.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 12:02:46.540', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-08 15:32:55.630', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "swzHelpList",
  "lastUpdate": "2021-07-08T15:32:55.6304963+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "930b9887-d8f2-03c6-4eda-732f59246c50",
      "entityId": "bb075204-7deb-44cc-9251-b1d158e816d3",
      "filter": "StructAsyncFilter",
      "control": "gridHelp",
      "dataMap": [
        {
          "id": "4385510a-144c-bcea-79ad-50ea87be6b22",
          "attributeId": "a6368ee0-d4a5-4530-b1e4-bbcb4042d178",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20800045-511c-530f-f6b0-23cce0512ca0",
          "attributeId": "6c306562-8aad-4af6-ae9b-d82b09b73f01",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "02b9587c-6a18-f9b5-b820-e07f7d6fff99",
          "attributeId": "07b14e69-f5aa-470d-b8d3-24c94fd722fd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d0bebb8-034c-b955-c82a-1187606ebe3f",
          "attributeId": "90a76b37-0d22-4e40-8524-f4f990a161d5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1e3eef2a-588b-8b33-0546-6e04e11705ee",
          "attributeId": "fbbc33ef-0afc-41f0-9b89-7f15de2865d2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d3ece22-1217-f09e-cf4e-8461e00a6beb",
          "attributeId": "9f9bcc38-0aef-489c-b86f-f33ef689e9f8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "a7c47c62-b2c5-9c56-bf13-838265c47be2",
          "attributeId": "67f07b78-31a9-4d5d-bab8-ae1e6bd0ad49",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "87cd88bd-6e24-cd61-46f2-32fae4780b38",
          "attributeId": "459a9286-34fe-4a23-9992-362731d39f49",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e74b2d19-beb4-0842-8d73-4087e3023b7a",
          "attributeId": "d22e5a5a-0542-4dbe-9dc7-00a6c914e515",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "34370749-0509-1466-b06e-db3d948e4d97",
          "attributeId": "94da5047-34a7-42a0-97ca-09e704f33af0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "014e64c5-6c25-97a5-fd64-8336e34b9e74",
          "attributeId": "785f4da2-afa1-4ec5-8c14-05cbef3c8601",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4d6e03af-cab0-0a1e-e70c-0a6e7b0d777a",
          "attributeId": "00f4c6f4-cb93-4e0a-acc2-2388284927bf",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Content"
}' WHERE [Id]='0def75a6-d5e4-4c2c-8547-962065127c70';

UPDATE [dwMetadata] SET
[Id]='3e37b27f-d66f-47c6-b6dc-c40d0a857db5', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'swzHelpList.json', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-07-14 12:02:46.520', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-08 15:32:55.590', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Online Help Content",
        "size": "huge",
        "style-marginBottom": "",
        "style-marginTop": "10px"
      },
      {
        "key": "container_3",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonAdd",
            "data-buildertype": "button",
            "content": "Create",
            "primary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "gridCreate"
                ],
                "targets": [
                  "gridHelp"
                ],
                "parameters": []
              }
            },
            "style-marginBottom": "0.25em",
            "style-marginRight": "0.25em"
          },
          {
            "key": "buttonDelete",
            "data-buildertype": "button",
            "content": "Delete",
            "secondary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "gridDelete",
                  "gridRefresh"
                ],
                "targets": [
                  "gridHelp"
                ],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "deletionConfirmTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "deletionConfirmText"
                  }
                ]
              }
            },
            "style-marginBottom": "0.25em",
            "style-marginRight": "0.25em"
          },
          {
            "key": "FilterSearch",
            "data-buildertype": "input",
            "label": "",
            "fluid": false,
            "onChangeTimeout": 200,
            "events": {
              "onClick": {
                "active": false,
                "actions": [
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              },
              "onChange": {
                "active": true,
                "actions": [
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "placeholder": "Search...",
            "style-marginBottom": "0.25em",
            "style-width": "300px",
            "style-source": "",
            "style-marginRight": "0.25em"
          },
          {
            "key": "FilterType",
            "data-buildertype": "dropdown",
            "label": "",
            "fluid": false,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "ALL",
                "text": "Show All"
              },
              {
                "key": 2,
                "value": "admin",
                "text": "Show Survey Admin"
              },
              {
                "key": 3,
                "value": "resp",
                "text": "Show Respondent Portal"
              }
            ],
            "defaultValue": "ALL",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "updateFilter"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-width": "200px",
            "style-marginBottom": "0.25em",
            "style-marginRight": "0.25em"
          }
        ],
        "style-float": "left",
        "events": {},
        "style-marginBottom": "1em"
      }
    ],
    "events": {},
    "style-marginBottom": "1em",
    "style-width": "100%"
  },
  {
    "key": "gridHelp",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Topic",
        "name": "Topic",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "Heading",
        "name": "Heading",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "Type",
        "name": "Type",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 100
      },
      {
        "key": "Status",
        "resizable": false,
        "type": "checkbox",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "width": 50
      }
    ],
    "editForm": "QNN_HELP",
    "multiselect": true,
    "rowKey": "Id",
    "autoHeight": false,
    "offSet": "-285px",
    "defaultSort": "Heading ASC",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-marginTop": "1em",
    "pagerType": "server",
    "rowHeight": "80",
    "pageSize": "50",
    "minHeight": "500"
  }
]' WHERE [Id]='3e37b27f-d66f-47c6-b6dc-c40d0a857db5';

