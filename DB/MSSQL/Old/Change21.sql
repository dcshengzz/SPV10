UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='5FA900F6-191C-4135-977D-F1C8C3D06D38', [Folder]=N'metadata/forms', [Filename]=N'SwzDplyList.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:25.377', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-24 10:21:48.540', [Data]=N'[
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
            }
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
            "circular": false
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
        "key": "QnnId_Title",
        "name": "Questionnaire",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "QnnId_Type",
        "name": "Type",
        "resizable": true,
        "sortable": true,
        "filterable": false
      },
      {
        "key": "ListId_Name",
        "name": "List",
        "sortable": true,
        "filterable": false,
        "resizable": true
      },
      {
        "key": "CategoryId_Name",
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
    "rowHeight": "50",
    "minHeight": "250"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='5FA900F6-191C-4135-977D-F1C8C3D06D38');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='4D440057-891C-4FE7-AA60-47B67638B311', [Folder]=N'metadata/forms', [Filename]=N'SwzDplyList-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:25.280', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-24 13:55:01.523', [Data]=N'{
     init: function (args) {
        var innerArgs = args;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[model.columns.length-2].customFormatter = function (p) {
                    
                    //return CloverApp.API.createElement(''input'',{type: ''checkbox'', className: ''ui checkbox'', id: p.row.Id, defaultChecked: p.row.Status, onChange: () => showModal(innerArgs, p.row.Id)});
                    var url = "/deployment/download/resp/" + p.row.Id + "/" + p.row.QnnId;
                    if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
                    return CloverApp.API.createElement("a", {href: url}, p.row.RespCount + " / " + p.row.SampleCount);
                    //return CloverApp.API.createElement("a", {href: url}, "Export");  
                };
                model.columns[model.columns.length-1].customFormatter = function (p) {
                    //return CloverApp.API.createElement("div", {}, p.row.RespCount + " / " + p.row.SampleCount); 
                    if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
                    return CloverApp.API.createElement("span", {onClick: ()=> swzdplylistUserActions.scheduleZipFileDownload(p.row.Id), className: ''link-style''}, ''Download Zip''); 
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
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''get''
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

}
', [StructDivisionId]=NULL WHERE ([Id]='4D440057-891C-4FE7-AA60-47B67638B311');
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='FD2D5864-E3E9-45F8-A960-540BEC63F6EC', [Folder]=N'metadata/forms', [Filename]=N'SwzDplyList-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:25.327', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-24 10:21:48.550', [Data]=N'{
  "isSurvey": false,
  "name": "SwzDplyList",
  "lastUpdate": "2019-09-24T10:21:48.5512613+08:00",
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
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c7b50251-f8e2-c9df-fe21-dfb83887e9d0",
          "attributeId": "d4044d06-1bd3-4e33-93ee-e0e7ef5384dc",
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
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Deployment"
}', [StructDivisionId]=NULL WHERE ([Id]='FD2D5864-E3E9-45F8-A960-540BEC63F6EC');
