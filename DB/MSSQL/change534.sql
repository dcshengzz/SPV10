-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzDplyList-code.js

UPDATE [dwMetadata] SET
[Id]='4d440057-891c-4fe7-aa60-47b67638b311', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.280', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-07-19 19:31:40.130', 
[Data]=N'{
    init: function (args) {
        const isDataOwner = CloverApp.API.checkRole("DataOwner");
        
        //used by button rendere by respCOuntFormatter and actionsFormatter
        const prepareExport = function (baseUrl, dplyId) {
            Utils.loadingStart();
            Utils.postFormRequest(baseUrl + encodeURIComponent(dplyId)).then(
                response => {
                    alertify.success( Utils.encodeHTML(response.message), 20000);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason), 20000);
                }
            ).finally(Utils.loadingStop);
        };
        
        const respCountFormatter = function (p) {
            const dplyId = p.row.Id;
            const hasAnyResponses = p.row.RespCount > 0;
            return CloverApp.API.createElement(
                "button", 
                {
                    style: {
                        width: "100%",
                        color: (hasAnyResponses ? "black" : "red"),
                    },
                    onClick: hasAnyResponses
                        ? isDataOwner 
                            ? ((e)=>{e.stopPropagation(); prepareExport("/deployment/exportresponse/prepare/",dplyId);}) 
                            : ((e)=>{e.stopPropagation(); alertify.error("You need DataOwner role to export the responses",10000);})
                        : ((e)=>{e.stopPropagation(); alertify.error("This deployment has no responses yet",10000);}),
                    className: "small ui button secondary invert",
                }, 
                p.row.RespCount + " / " + p.row.SampleCount);
        }; //end of respCountFormatter
                
        const actionsFormatter = function (p) {
            const dplyId = p.row.Id;
            const hasAnyResponses = p.row.RespCount > 0;
            if(!hasAnyResponses || !isDataOwner) {
                return CloverApp.API.createElement("div", {}, "");
            } else {
                return CloverApp.API.createElement(
                    "button", 
                    {
                        style: {
                            width: "100%",
                            color: "black",
                        },
                        onClick: isDataOwner
                            ? ((e)=> {e.stopPropagation(); prepareExport("/deployment/exportuploadedfiles/prepare/", dplyId)})
                            : ((e)=>{e.stopPropagation(); alertify.error("You need DataOwner role to export the respondent uploaded files",10000)}),
                        className: "small ui button secondary invert",
                    }, 
                    "Export Files"); 
            }
        }; //end of actionsFormatter     
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();
            if(tags.length > 3) {
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: tags, className:"react-grid-Cell-Comments"}, tagsLabel); 
        }; //end of tagsColumnFormatter
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }); 
                cols.RespCount.customFormatter = respCountFormatter;
                cols.Action.customFormatter = actionsFormatter;          
                cols.Tags.customFormatter = tagsColumnFormatter;
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

    updateFilter: function(args) {
        console.log("args to updateFilter", args);
        const data = args.data;
        
        const search = data.FilterSearch ? data.FilterSearch : null;
        const filterAnonymousType = data.FilterAnonymous ? data.FilterAnonymous : "AllAnonymous";
        const filterMultipleType = data.FilterMultiple ? data.FilterMultiple : "AllMultiple";
        const filterRecurrenceType = data.FilterRecurrenceType ? data.FilterRecurrenceType : "AllRecurrenceType";
        
        const filter = [];
        if(search) {
            filter.push({
               column: "Name, QnnTitle, QnnType, ListName, Tags, CreatedDate",
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
        if("AllRecurrenceType" != filterRecurrenceType) {
            if(filterRecurrenceType=="IR") {
                filter.push({
                    column: "RecurrenceType",
                    nextValue: ["I","R"],
                    term: "IN",
                    value: ["I","R"],
                });
            } else {
                filter.push({
                    column: "RecurrenceType",
                    nextValue: filterRecurrenceType,
                    term: "=",
                    value: filterRecurrenceType,
                });
            }
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
        console.log("delta", delta, "filter", filter);
        return delta;
    },
    
    test: function(args,foo,bar) {
        console.log(args,foo,bar);
    },
    
    closeDeleteModal: function(args) {
        args.component.refs.deleteModal.close();
        CloverApp.API.setDataField(''deleteGridView'', null);
        return {};
    },
    
    openDeleteModal: function(args){
		const grid = args.controlRef; //expects grid as event target	
		const selectedGridIndices = grid.state.selectedIndexes;	
        const noRecordsSelectInGrid = (selectedGridIndices.length===0);
        if(noRecordsSelectInGrid){
            args.component.refs.deleteModal.close();
            alertify.error("Please select at least one record");
        } else {
            const dplyNames = selectedGridIndices.map( gridIndex => grid.state.items[gridIndex]);
            CloverApp.API.setDataField(''deleteGridView'', null);
            CloverApp.API.setDataField(''deleteGridView'', dplyNames);
        }
        return {};
    }, //end of openDeleteModal
}
' WHERE [Id]='4d440057-891c-4fe7-aa60-47b67638b311';

