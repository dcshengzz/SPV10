-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_LIST-code.js
-- base.json

UPDATE [dwMetadata] SET
[Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.910', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-21 20:28:21.460', 
[Data]=N'{   
    init: function(args){
        console.log("QNNLIST Args",args);
    }, 
    
    processTrkList: function(args){
        var trkListIds = args.data.TrkListIds;
        if(trkListIds==null || trkListIds==undefined) return {};   
        try {
            var arr = JSON.parse(trkListIds);
            var sourceArray = args.component.refs.TrkListIds.state.options;
        
            let newArray = [];
            arr.map((currentValue, index, array) => {
                // return element to new Array
                if (sourceArray.filter(function(e) { return e.key === currentValue; }).length > 0) {
                      /* contains the element we''re looking for */
                      newArray.push(currentValue);
                }

            });
            CloverApp.API.setDataField("TrkListIds", JSON.stringify(newArray));
            
        } catch (e) {
            return {};
        }
        return {};   

    },
    
    deleteListSample: function(args){
        if(args.controlRef.state.selectedIndexes.length==0){
             alertify.error("Please select at least one list sample");
             return {};
            
        }

        const listId = args.data.Id;
        const listSampleIds = [];
        for (let i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            const gridIndex = args.controlRef.state.selectedIndexes[i];
            const listSampleId = args.controlRef.state.items[gridIndex].Id;
            listSampleIds.push(listSampleId);
        }

        const formData = new FormData();
        formData.append(''listId'', listId);
        formData.append(''listSampleIds'', listSampleIds);      
        Utils.loadingStart();
        Utils.postFormRequest("/list/deletelistsample",formData).then(
            response => {
                alertify.success(response.message);
                args.controlRef.refresh();
            }, reason => {
                console.log("Error deleting list samples", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },   
    
    toggleListSamplesActive: function(args) {
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].Id);
        if(listSampleIds.length==0){
             alertify.error("Please select at least one list sample");
             return {};
        }

        const action = args.parameters.action;
        let waitMessage;
        let url;
        if("enable"===action) {
            url = "/list/enablelistsamples";
            waitMessage = "Enabling selected samples...";
        } else if("disable"===action) {
            url = "/list/disablelistsamples";
            waitMessage = "Disabling selected samples...";
        } else {
            throw "INTERNAL ERROR (UI): Invalid action";
        }
        const listId = args.data.Id;
        const formData = new FormData();
        formData.append("listId", listId);
        formData.append("listSampleIds", listSampleIds);    
        Utils.loadingStart(waitMessage);
        Utils.postFormRequest(url, formData).then(
            response => {
                alertify("Samples disabled");
            }, reason => {
                console.log("disableListSample failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    },
    
    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },
    
    exportSample: function (args){
        let defaultFormName = args.originalData.nameInput + ".csv";
        let inputName = null;
        while(inputName == null){
          inputName = prompt(CloverLang.forms.QNN_LIST.provideNameToDownload, defaultFormName);
          if(inputName == null || inputName == undefined){
            return;
          }else if(inputName.trim().length == 0 ){
            inputName = null;
            alert(CloverLang.forms.QNN_LIST.provideName);
          }
        }
        var url = ''/list/exportsample?listId='' + args.data.Id + ''&fileName='' + encodeURIComponent(inputName);
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    
    /*hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        CloverApp.API.setDataField("gridviewImportSummary", null);         
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null 
                      }
                  },
                  models:{
                      //hideControls: [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headerListSampleUpdated'']
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'',''gridviewImportSummary'']
                  }
              }
            }
        }        
        
    }, */
    
   submitFile(args)
    {
        var token = args.data.inputImportListSample;
        var password = args.data.inputPassword;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        if(password){
            var errors = {};
            var req = new RegExp(/^[a-zA-Z0-9]{12,100}$/);
            var countChars = function(str, type) {
                var count=0,len=str.length;
                    for(var i=0;i<len;i++) {
                        if(type==0){
                            if(/[A-Z]/.test(str.charAt(i))) count++;                    
                        }
                        else if(type==1){
                            if(/[a-z]/.test(str.charAt(i))) count++;                    
                        }
                        else if(type==2){
                            if(/[0-9]/.test(str.charAt(i))) count++;                    
                        }                
                    }
                return count;
            };                
            if(!req.test(password)){
                errors.inputPassword = true;
                errors.passwordComplex = "Password must contain alphanumeric characters only; password must be between 12 and 100 characters)";            
            }
    
            if(countChars(password, 0)<3 || countChars(password, 1)<3 || countChars(password, 2)<3){
                errors.inputPassword = true;
                errors.passwordStrength = "Password must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";            
            }
            
    
            if(errors.passwordComplex){
              throw {
                  level: 1,
                  message: errors.passwordComplex,
                  formerrors: {main: errors}
              };
            }
            if(errors.passwordStrength){
              throw {
                  level: 1,
                  message: errors.passwordStrength,
                  formerrors: {main: errors}
              };
            }            
            
        }

        var url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id + ''&password='' + password;
        if(password == null || password == undefined) url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id;
        console.log("url :", url);
        Utils.loadingStart();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                Utils.loadingStop();
                if (response.success) {
                    var _securitySiteIdRewriter = function (model) {
                        model.filters = ''[{"column":"IsDeleted", "value": "0", "term":"="}]'';
                        model.disabled = false;
                    };
                    
                    CloverApp.API.setDataField("inputImportListSample", null);
                    CloverApp.API.setDataField("inputPassword", null);
                    /* CloverApp.API.setDataField("sampleAdded", response.statistics.sampleAdded);
                    CloverApp.API.setDataField("sampleUpdated", response.statistics.sampleUpdated);
                    CloverApp.API.setDataField("sampleDuplicated", response.statistics.sampleDuplicated);
                    CloverApp.API.setDataField("totalRows", response.statistics.totalRows);
                    CloverApp.API.setDataField("invalidRows", response.statistics.exceptionCount); */
                    alertify.success(response.message,8000);
                    args.component.refs.modalImportSample.close();
                    args.component.refs.gridviewSample.refresh();
                    if(response.items!=null && response.items!=undefined){
                        //CloverApp.API.setDataField("invalidRowsDetail", response.items);

                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: [],
                                        }
                                    }
                                },
    
                                
                            }
                        });  
                    }
                    else{
                         return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: [],
                                        }
                                    }
                                },
    
                                
                            }
                        });                        
                    }
                    qnn_listUserActions.closeModal(args);
   
                } else {
                    alertify.error(response.message);

                }
            })
            .catch(error => {
                Utils.loadingStop();
                alertify.error(error.message);
            });
 
        };
    }, 
    
    dbExport: function(args){
        
    var downloadLink = document.createElement("a");
    var csv2 = "Email,ActiveYN,Name,NumRetry,Pwd,Mat@yahoo.com,TRUE,Mat Tan,34,5566,anthony@yahoo.com,TRUE,Anthony Chew,35,5566,John ,TRUE,John ,36,5566,Cathy,TRUE,Cathy,37,5566,zBenedict,TRUE,zBenedict,38,5566,zJane,TRUE,zJane,39,5566";
   
    var json = csv2;
    var fields = Object.keys(json[0])
    var replacer = function(key, value) { return value === null ? '''' : value } 
    var csv = json.map(function(row){
      return fields.map(function(fieldName){
        return JSON.stringify(row[fieldName], replacer)
      }).join('','')
    })
    csv.unshift(fields.join('','')) // add header column
    
    //console.log(csv.join(''\r\n''))
    
    //console.log(csv)

      var blob = new Blob(["\ufeff", csv]);
      var url = URL.createObjectURL(blob);
      downloadLink.href = url;
      downloadLink.download = "data.csv";

      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
    },
    
    dbImport: function(args){
      
        var csvdata = args.component.refs.swzimport_1.state.csvdata;
        var datamodel = "QNN_LIST"
        if (csvdata == null) return alertify.error("Please choose a file!")
        var csvDataCount = csvdata.length;
        var oldData = args.state.app.form.data.modified;
        var newData = {};
        newData[''collectioneditor_sample''] = JSON.stringify(csvdata);
        var formData = $.extend(true,oldData,newData);
        
        var url = ''/SwzData/change?name='' + datamodel;
        var formDataString = JSON.stringify(formData);
        var msg = alertify.success("Loading...");

        //TODO use postFormRequest
        $.post(url,{data: formDataString}).done(function (data) {
            
            if(data.success){
                var msg = csvDataCount + " respondents have been created"
                  
                alertify.success(msg) ;
                //console.log("response Json", data);
                //console.log(args.state.app.form.data.modified.__collectioneditor_sample_totalcount);
                   
                return {
                    app: {
                        form: {
                            data: {
                                modified: {
                                    __collectioneditor_sample_totalcount:csvDataCount
                                }
                            }
                        }
                    }
                } //end return
            }
            else {
                alertify.error(data.message);
                //console.log(data.message);
                //console.log(data);
            }
        }).fail(function (jqxhr, textStatus, error) {
           alertify.error(textStatus);
        }); 
    return {};
      
    },
    
    goRecords: function(args){
        var modelArray = args.state.app.form.models.model; 
        var recordsCont= args.state.app.form.models.model[4];
        var isHidden = false;
        
        var newModal= {''key'': recordsCont[''key''], ''data-buildertype'': recordsCont[''data-buildertype''], ''children'': recordsCont[''children''],
        ''style-customcss'': recordsCont[''style-customcss''], ''style-float'':recordsCont[''style-float''], ''style-width'': recordsCont[''style-width''],
        ''style-hidden'': isHidden,};
    
        modelArray.splice(4,1,newModal); //Replace item in whole model series
    
        return {
            app:{
                form:{
                    models:{
                        model: modelArray
                    }
                }
            }
        }
    },
    
    newListSample: function(args){
        //window.location.href = ''/form/QNN_LIST_SAMPLE?listId='' +args.data.Id;
        //return {
        //    router :{
        //        push: ''/form/QNN_LIST_SAMPLE/listId/'' +args.data.Id
        //    
        //    }
        //}
         CloverApp.API.redirect(''form'', ''QNN_LIST_SAMPLE'', ''/listId/''+ args.data.Id)

    },

    
    
    goReview: function(args){

        var userId = args.data.Id;
        //console.log("userid is" , userId);
        var form = ''/form/swzreviewlist/'';
        var userReview = form + userId;
        
        if (userId !== undefined ){    
            return {
                router :{
                    push: userReview
                    
                }
            };
        }
    },
    
    listExport: function(args){
        //console.log("list export")
        var modelArray = args.state.app.form.models.model; //The whole model series
        var oldModal = args.state.app.form.models.model[3].children[0].children[1].children[1].children[0].children[0].children[2].children[0];
        
        var jsonData = args.component.refs.collectioneditor_sample.state.data;
        //console.log(jsonData);
          
        var newModal = {''content'': "Export", ''data-buildertype'': oldModal[''data-buildertype''], ''key'':  oldModal[''key''], ''secondary'': true, ''size'': "" ,''jsonData'': jsonData}

        //console.log(''new model'', modelArray);
        //console.log(''old model'', oldModal);
        
        modelArray.splice(1,1,newModal); //Replace item in whole model series
    
          return {
              app: {
                  form: {
                      models: {
                         model: modelArray
                        }
                      }
                  }
            }
        
    },
    
    
    listImport: function (args){
      //console.log("View CSV DATA")
        //console.log(args);
//      console.log(args.component.refs.swzimport_1.state.csvdata);
        var csvdata = args.component.refs.swzimport_1.state.csvdata;
        //console.log(csvdata);
        if (csvdata === undefined || csvdata === null ){
            //console.log("include file");
          alertify.error("Please, include CSV file for import!");
        }
        else if (csvdata !== undefined || csvdata !== null ){
            //console.log("all undefined")
             return {
                  app: {
                      form: {
                          data: {
                              modified: {
                                  collectioneditor_sample:csvdata
                              }
                          }
                      }
                  }
              }
        }
        
    },
      
    closeModal: function (args){
        /*CloverApp.API.setDataField("sampleAdded", null);
        CloverApp.API.setDataField("sampleUpdated", null);
        CloverApp.API.setDataField("invalidRows", null);
        CloverApp.API.setDataField("sampleDuplicated", null);
        CloverApp.API.setDataField("totalRows", null);
        CloverApp.API.setDataField("invalidRowsDetail", null); */
        CloverApp.API.setDataField("inputImportListSample", null);
        CloverApp.API.setDataField("inputPassword", null);
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          //sampleAddedCount:null,
                          //sampleUpdatedCount:null,
                          listFile:null,
                          listName:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: []
                  }
              }
            }
        }       
    },  
    /*closeModal: function (args){
        //CloverApp.API.setDataField("inputImportListSample", null);
        //CloverApp.API.setDataField("inputPassword", null);
        //CloverApp.API.setDataField("sampleAddedCount", null);
        //CloverApp.API.setDataField("sampleUpdatedCount", null);
        //CloverApp.API.setDataField("listSampleAddedCount", null);
        //CloverApp.API.setDataField("listSampleUpdatedCount", null);   
        //args.state.aop.forms.models.hideControls = [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headListSampleUpdated'']
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          //sampleAddedCount:null,
                          //sampleUpdatedCount:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      //hideControls: [''headerSampleAdded'',''headerSampleUpdated'',''headerListSampleAdded'',''headerListSampleUpdated'']
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gridviewImportSummary'']
                  }
              }
            }
        }       
    } */
}' WHERE [Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082';

UPDATE [dwMetadata] SET
[Id]='cb82c0f3-8ea8-42a5-aad7-cc6f3e07053a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/localization', [FileName]=N'base.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:10.700', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-21 18:05:41.163', 
[Data]=N'{
  "common": {
    "dateFormat": "DD MMM YYYY",
    "timeFormat": "HH:mm",
    "datetimeFormat": "DD MMM YYYY HH:mm"
  },
  "msg": {
    "deleteAllSampleAssignmentTitle": "Remove ALL Sample Assignments",
    "deleteAllSampleAssignmentText": "This will delete ALL the DataEditor assignments for this deployment. Proceed?",
      
    "addSampleConfirmTitle": "Add List Samples",
    "addSampleConfirmText": "Are you sure you want to add new samples from the list to this deployment?",
    
    "submitSurveyConfirmTitle": "Survey Submission",
    "submitSurveyConfirmText": "Are you sure you want to submit survey?",
    
    "deleteListSamplesConfirmTitle": "Remove List Samples from Sample List",
    "deleteListSamplesConfirmText": "WARNING: Removing the samples from this list will also delete all their related data in deployments that use this list INCLUDING RESPONSE DATA. Are you absolutely sure you want to continue?", 
    
    "deleteSampleListConfirmTitle": "Delete Sample List & Associated Records",
    "deleteSampleListConfirmText": "WARNING: Deleting a Sample List will also immediately delete all deployments that use it INCLUDING RESPONSE DATA",
    "deleteSampleListConfirmOk": "Delete List",
    
    "deletionConfirmTitle": "Deletion Confirmation",
    "deletionConfirmText": "All the data related with selected records will be deleted. Are you sure you want to continue?",
    
    "deleteSampleConfirmTitle": "Delete Samples",
    "deleteSampleConfirmText": "WARNING: ALL the data related with selected samples will be deleted, INCLUDING RESPONSE DATA, sample list properties and etc. Are you absolutely sure you want to continue?",    
    
    "disableSamplesConfirmTitle": "Disable Samples",
    "disableSamplesConfirmText": "The selected sample''s status will be set to inactive in this list, making them inactive in deployments using this list (existing response data will NOT be deleted and you can re-enable them later). Continue?",  
    
    "createDplyConfirmTitle": "Create deployment?",
    "createDplyConfirmText": "Please confirm that you are ready to continue with the deployment record creation now. (Note: Certain deployment settings may only be specified before creating the deployment record and are not subsequently adjustable)",
    
    "resetResponseConfirmTitle": "Confirm Reset Response",
    "resetResponseConfirmText": "Click Reset to delete the answers for this response and set its status back to Pending",
    "resetResponseConfirmOk": "Reset",
    
    "setStatusConfirmTitle": "Confirm Change Status",
    "setStatusConfirmText": "This will change the response status. Continue?",
    
    "exemptConfirmTitle": "Set Exempted Status",
    "exemptConfirmText": "This will change the response status to Exempted. (The respondent will still be able to access the survey if it is visible to respondents)",
    "exemptConfirmOk": "Exempt"
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
      "gridviewSample_PeerName": "Peer Name",
      "provideNameToDownload": "You may provide another preferred name, click OK to download",
      "provideName": "Please provide a name."
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
}' WHERE [Id]='cb82c0f3-8ea8-42a5-aad7-cc6f3e07053a';

