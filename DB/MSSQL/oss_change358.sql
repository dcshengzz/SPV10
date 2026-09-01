-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzDplyList-code.js

UPDATE [dwMetadata] SET
[Id]='4d440057-891c-4fe7-aa60-47b67638b311', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.280', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-10-25 19:51:31.190', 
[Data]=N'{
    init: function (args) {
        const respCountFormatter = function (p) {
            const hasAnyResponses = p.row.RespCount > 0;
            const content = hasAnyResponses
                ? //has some responses then download link
                CloverApp.API.createElement("span", {
                        onClick: (e)=>{e.stopPropagation(); swzdplylistUserActions.exportResponse(p.row.Id)},
                        className: ''link-style''},
                        p.row.RespCount + " / " + p.row.SampleCount)
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
                cols.RespCount.customFormatter = respCountFormatter;
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
        var url = "/deployment/download/resp/" + dplyId;
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

