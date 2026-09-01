{
    init: function(args){
       
        const eventDateFormatter = function(p) {
             const date = p.value && p.value != "" ? new Date(p.value) : null;
             const display = date instanceof Date && !isNaN(date)
                ? new Date(date.getTime() - date.getTimezoneOffset() * 60000).toISOString().replace('T', ' ').slice(0, 19)
                : "";
             return CloverApp.API.createElement("span", { onClick: () =>  {
                    window.open("/form/AuditLog/"+encodeURIComponent(p.row.Id), "_blank");
                }, className: "link-style" }, display);
        };
        
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
        CloverApp.API.setDataField("FilterEdited", false);
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                cols.EventDate.customFormatter = eventDateFormatter;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("gridAuditLog", gridModelRewriter);
    },
    
    validatePurgeModal: function(args) {
        const dataCreatedBefore = args.data.dataCreatedBefore;
        const dateArchive = args.data.dateArchive;
        
        const errorMessages = [];
        let hasError = false;
        const errors = {main: {}};    
        
        if(dataCreatedBefore== null || isNaN(new Date(dataCreatedBefore))) {
            errorMessages.push("Events Logged Before is required!");
            errors.main.dataCreatedBefore = true;
            hasError= true;
        }
        if(dateArchive== null || isNaN(new Date(dateArchive))) {
            errorMessages.push("Perform Archive At is required!");
            errors.main.dateArchive = true;
            hasError= true;
        }
        
        if(hasError){
          throw {
              level: 1,
              message: errorMessages,
              formerrors: errors
          };
        }
        return {};
    },
    
    purgeData: function (args){
        const gridView = args.controlRef;

        var formData = new FormData();

        if(args.data.dateArchive != null){
            formData.append('dateArchive', args.data.dateArchive);
        }

        formData.append('isArchive', args.data.checkboxArchive);
        formData.append('dataCreatedBefore', args.data.dataCreatedBefore);

        Utils.loadingStart();
        Utils.postFormRequest("/audit/purgeauditlog",formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                args.component.refs.purgeModal.close();
            }, reason => {
                console.error("purgeData failed:", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    //disable dimmer click because the modal will be closed when user select date in modal.
    //this issue is due to old react modal version.
    disableDimmerClick: function(args) {
        args.component.refs.purgeModal.state.dimmerClick = false;
    },
    
    closePurgeModal: function(args) {
        args.component.refs.purgeModal.close();
    },
    
    filterEdited: function(args) {
        if(!args.data.FilterEdited) {
            CloverApp.API.setDataField("FilterEdited", true);
            Utils.queueHideControl("btnApplyFilters", "show");
        }
        CloverApp.API.clearErrors();
    },
    
    quickFilter: function(args) {
        const name = args.parameters.name;
        console.log(name);
        
        switch(name) {
            
                
            case "start1stLastMonth":
                CloverApp.API.setDataField("FilterStart",
                   new Date(new Date().getFullYear(), new Date().getMonth() - 1, 1));
                break;
                
            case "start1stThisMonth":
                CloverApp.API.setDataField("FilterStart",
                    new Date(new Date().getFullYear(), new Date().getMonth(), 1));
                break;
                
            case "end1stThisMonth":
                CloverApp.API.setDataField("FilterEnd",
                   new Date(new Date().getFullYear(), new Date().getMonth(), 1));
                break;    
                
            case "endTomorrow":
                CloverApp.API.setDataField("FilterEnd",
                   new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() + 1));
                break;
                
            case "allLastMonth":
                CloverApp.API.setDataField("FilterStart",
                   new Date(new Date().getFullYear(), new Date().getMonth() - 1, 1));
                CloverApp.API.setDataField("FilterEnd",
                   new Date(new Date().getFullYear(), new Date().getMonth(), 1));
                break;
                
            case "allThisMonth":
                CloverApp.API.setDataField("FilterStart",
                    new Date(new Date().getFullYear(), new Date().getMonth(), 1));
                CloverApp.API.setDataField("FilterEnd",
                    new Date(new Date().getFullYear(), new Date().getMonth() + 1, 1));
                break;
                
            case "allToday":
                CloverApp.API.setDataField("FilterStart",
                    new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate()));
                CloverApp.API.setDataField("FilterEnd",
                   new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() + 1));
                break;
        }
        
        audittrailUserActions.filterEdited(args);
    },
    
    validateFilters: function(args) {

        const filterStart = args.data.FilterStart ? new Date(args.data.FilterStart) :null;
        const filterEnd = args.data.FilterEnd ? new Date(args.data.FilterEnd) : null;
        
        const errorMessages = [];
        let hasError = false;
        let filterSpecified = true;
        const errors = {main: {}};    
        
        if(filterStart==null || isNaN(filterStart)) {
            errorMessages.push("Start date is required");
            //errors.main.FilterStart = true;
            hasError= true;
            filterSpecified = false;
        }
        if(filterEnd==null || isNaN(filterEnd)) {
            errorMessages.push("End date is required");
            //errors.main.FilterEnd = true;
            hasError= true;
            filterSpecified = false;
        }
        if(filterStart >= filterEnd) {
            errorMessages.push("Start date must be before End date");
            //errors.main.FilterStart = true;
            hasError= true;
        }
        
        const days = (filterStart && filterEnd) 
          ? Math.round((filterEnd - filterStart) / 86400000) 
          : null;
        console.log("date range days", days);
        if(days && days > 62) {
            errorMessages.push("Range may not exceed 62 days (" + days + ")");
            //errors.main.FilterEnd = true;
            hasError= true;
        }
        
        if(hasError){
          throw {
              level: 1,
              message: errorMessages,
              formerrors: errors
          };
        }
        return {};
        
    },
    
    applyFilters: function(args) {
        const data = args.data;
        
        const filterStart = new Date(data.FilterStart);
        const filterEnd = new Date(data.FilterEnd);
        const filterTableName = data.FilterTableName;
        const filterEventType = data.FilterEventType;
        const filterOrganisation = data.FilterOrganisation;
        const filterEventBatch = data.FilterEventBatch;
        const filterUserName = data.FilterUserName;
        const filterSampleName = data.FilterSampleName;
        const filterRecordId = data.FilterRecordId;
        const filterSampleUid = data.FilterSampleUid;
        
        const filter = [];
        if(filterStart) {
            const formattedStart = new Date(filterStart.getTime() - filterStart.getTimezoneOffset() * 60000).toISOString().replace('T', ' ').slice(0, 19);
            filter.push({
               column: "EventDate",
               nextValue: formattedStart,
               term: ">=",
               value: formattedStart,
            });
        }
        if(filterEnd) {
            const formattedEnd = new Date(filterEnd.getTime() - filterEnd.getTimezoneOffset() * 60000).toISOString().replace('T', ' ').slice(0, 19);
            filter.push({
               column: "EventDate",
               nextValue: formattedEnd,
               term: "<",
               value: formattedEnd,
            });
        }
        if(filterTableName) {
            filter.push({
               column: "TableName",
               nextValue: filterTableName,
               term: "like",
               value: filterTableName,
            });
        }
        if(filterEventType) {
            filter.push({
               column: "EventType",
               nextValue: filterEventType,
               term: "=",
               value: filterEventType,
            });
        }
        if(filterOrganisation) {
            filter.push({
               column: "StructDivisionId",
               nextValue: filterOrganisation,
               term: "=",
               value: filterOrganisation,
            });
        }
        if(filterEventBatch) {
            filter.push({
               column: "EventBatch",
               nextValue: filterEventBatch,
               term: "like",
               value: filterEventBatch
            });
        }
        if(filterUserName) {
            filter.push({
               column: "UserName",
               nextValue: filterUserName,
               term: "like",
               value: filterUserName,
            });
        }
        if(filterSampleName) {
            filter.push({
               column: "SampleName",
               nextValue: filterSampleName,
               term: "like",
               value: filterSampleName,
            });
        }
        if(filterRecordId) {
            filter.push({
               column: "RecordId",
               nextValue: filterRecordId,
               term: "like",
               value: filterRecordId,
            });
        }
        if(filterSampleUid) {
            filter.push({
               column: "UID",
               nextValue: filterSampleUid,
               term: "like",
               value: filterSampleUid,
            });
        }
        
        console.log("updating filter", filter);
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridAuditLog: filter,
                        }
                    }
                }
            }
            
        };
      
        CloverApp.API.setDataField("FilterEdited", false);
        CloverApp.API.setDataField("FilterApplied", true);
        Utils.queueHideControl("btnRefresh", "show");
        Utils.queueHideControl("gridAuditLog", "show");
        Utils.queueHideControl("btnApplyFilters", "hide");
      
        alertify.success("Applying filter changes", 1000);
      
        CloverApp.API.clearErrors();
      
        return delta;
    },
  
}