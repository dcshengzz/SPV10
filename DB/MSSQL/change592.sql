-- Will UPDATE existing row(s) in dwMetadata for the following:
-- SwzListList-code.js
-- SwzQnnList-code.js

UPDATE [dwMetadata] SET
[Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.420', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-14 18:49:15.283', 
[Data]=N'{
    init: function(args) {
        console.log("args to init", args);
        const innerArgs = args;
        const hasEditPermission = CloverApp.API.checkPermission("Edit");
        console.log("hasEditPermission", hasEditPermission);
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("newSampleListName", "");
            CloverApp.API.setDataField("copySampleListId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            if(hasEditPermission) {
                return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
            } else {
                return null;
            }
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_LIST'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 5){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Name.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
        
        const dataArchived = false;
        
        const filter = [];
        filter.push({
            column: "IsArchived",
            nextValue: dataArchived,
            term: "=",
            value: dataArchived,
        });
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filter,
                        }
                    }
                }
            }    
        };
        return delta;
    }, //end of int
    
    //called by Copy button in modal
    copySampleList: function(args) {
        const data = args.data;
        const id = data.copySampleListId;
        const title = (data.newSampleListName===undefined) ? "" : data.newSampleListName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("sampleListId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating SampleList");
        Utils.postFormRequest("/list/duplicate", formData).then(
            result => {
                args.component.refs.grid.refresh();
                args.component.refs.copyModal.close();
                alertify.success( Utils.encodeHTML("Created " + title) );
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of copySampleList
    
    viewArgs: function (args){
        console.log("View", args);
    },
    
    importSampleList(args){
        const token = args.data.listFile;
        const listName = args.data.listName;
        const password = args.data.listPassword;
        
        const passwordError = globalUserActions.samplePasswordError(password);
        if(passwordError) {
            throw {
                level: 1,
                message: passwordError,
                formerrors: {main: {listPassword: true}}
            };
        }
        
        var errors = {};
        if (!listName || ""===listName){
            errors.listName = ''Please enter list name'';
        }
        if(!token){
            errors.listFile = ''Please select csv file'';
        }
        
        if(errors.listName || errors.listFile){
            alertify.error(''List name or file cannot be empty'');
            throw {
                level: 1,
                message: "List name or file cannot be empty",
                formerrors: {main: errors}
            };
        }      
        
        Utils.loadingStart("Importing...");
        const formData = new FormData();
        formData.append("token", token);
        formData.append("listName", listName);
        if(password && ""!==password) {
            formData.append("password", password);
        }
        Utils.postFormRequest("/list/importcsv", formData).then(
            response => {
                CloverApp.API.setDataField("listFile", null);
                CloverApp.API.setDataField("listName", null);
                args.component.refs.importModal.close();
                args.component.refs.grid.refresh();
                alertify.success( Utils.encodeHTML(response.message),10000);
                args.component.refs.importModal.close();
            }, reason => {
                console.error(reason);
                if("NAME EXISTS"===reason) {
                    alertify.error( "A list with this name already exists in this organisation", 25000);
                } else {
                    CloverApp.API.setDataField("listFile", null);
                    alertify.error( Utils.encodeHTML(reason), 25000);
                }
            }
        ).finally( Utils.loadingStop );
    }, 
    
    closeImportModal: function(args) {
        CloverApp.API.setDataField("listFile", null);
        CloverApp.API.setDataField("listName", null);
        args.component.refs.importModal.close();
    },
    
    closeCopyModal: function(args) {
        args.controlRef.close();  
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
    
            updateFilter: function(args) {
        const data = args.data;
        const dataArchived = data.Archived ? data.Archived : null;
        
        const filter = [];
        if(dataArchived != ''AllSampleList'') {
            filter.push({
               column: "IsArchived",
               nextValue: dataArchived,
               term: "=",
               value: dataArchived,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filter,
                        }
                    }
                }
            }    
        };
        return delta;
    },
}' WHERE [Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8';

UPDATE [dwMetadata] SET
[Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.607', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2026-01-14 18:46:35.883', 
[Data]=N'{
    init: function(args) {
        const innerArgs = args;
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("NewQnnName", "");
            CloverApp.API.setDataField("CopyQnnId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_QNN'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 3){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Title.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        
      
      CloverApp.API.rewriteControlModel("gridQnn", gridModelRewriter);
        const dataArchived = false;
        
        const filter = [];
        filter.push({
            column: "IsArchived",
            nextValue: dataArchived,
            term: "=",
            value: dataArchived,
        });
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridQnn: filter,
                        }
                    }
                }
            }    
        };
        return delta;

    },
    
    //called by Copy button in modal
    copyQnn: function(args) {
        const data = args.data;
        const id = data.CopyQnnId;
        const title = (data.NewQnnName===undefined) ? "" : data.NewQnnName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("qnnId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating Questionnaire");
        Utils.postFormRequest("/qnn/duplicate", formData).then(
            result => {
                args.component.refs.gridQnn.refresh();
                args.component.refs.copyModal.close();
                alertify.success( Utils.encodeHTML("Created " + title) );
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeModal: function(args) {
        args.controlRef.close();  
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
    
    updateFilter: function(args) {
        const data = args.data;
        const dataArchived = data.Archived ? data.Archived : null;
        
        const filter = [];
        if(dataArchived != ''AllFormProperties'') {
            filter.push({
               column: "IsArchived",
               nextValue: dataArchived,
               term: "=",
               value: dataArchived,
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridQnn: filter,
                        }
                    }
                }
            }    
        };
        return delta;
    },
}





' WHERE [Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d';

