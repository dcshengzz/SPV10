-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzDplyList-code.js
-- SwzDplyList-settings.json

UPDATE [dwMetadata] SET
[Id]='4d440057-891c-4fe7-aa60-47b67638b311', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.280', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-16 17:00:35.353', 
[Data]=N'{
    init: function (args) {
        const respCountFormatter = function (p) {
            const hasAnyResponses = p.row.RespCount > 0;
            const content = hasAnyResponses
                ? //has some responses then download link
                CloverApp.API.createElement("span", {
                        onClick: (e)=>{e.stopPropagation(); swzdplylistUserActions.exportResponse(p.row.Id,p.row.QnnId)},
                    }, p.row.RespCount + " / " + p.row.SampleCount)
                : //else no responses yet then text only
                CloverApp.API.createElement("span", {
                        style: {
                            color: "red",
                        },
                    }, "0 / " + p.row.SampleCount)
                ;
            const div = CloverApp.API.createElement("div", {
                    style: {
                        //textAlign: "right",
                        //marginRight: "1em",
                    },
                }, content);
            return div;
        }; //end of respCountFormatter
                
        const actionsFormatter = function (p) {
            if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
            return CloverApp.API.createElement("span", {
                    onClick: (e)=> {e.stopPropagation(); swzdplylistUserActions.scheduleZipFileDownload(p.row.Id)},
                    className: ''link-style''
                }, ''Download Zip''); 
        }; //end of actionsFormatter     
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }); 
                
                cols.RespCount.sortable = true;
                cols.RespCount.customFormatter = respCountFormatter;
                
                cols.Action.sortable = false;
                cols.Action.customFormatter = actionsFormatter;          

            }
            return model;
        }; //end of gridModelRewriter

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

        return {};
    }, //end of init
    
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
    
    exportResponse: function (dplyId,qnnId) {
        var url = "/deployment/download/resp/" + dplyId + "/" + qnnId;
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
    
    test: function(args,foo,bar) {
        console.log(args,foo,bar);
    },
}
' WHERE [Id]='4d440057-891c-4fe7-aa60-47b67638b311';

UPDATE [dwMetadata] SET
[Id]='fd2d5864-e3e9-45f8-a960-540bec63f6ec', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.327', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-02-23 13:56:33.340', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "SwzDplyList",
  "lastUpdate": "2022-02-23T13:56:33.3307582+08:00",
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
      "readOnly": false,
      "totalCountPropertyName": "__gridview_1_totalcount"
    }
  ],
  "securityGroup": "Deployment"
}' WHERE [Id]='fd2d5864-e3e9-45f8-a960-540bec63f6ec';

