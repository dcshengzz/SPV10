-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_LIST-code.js

UPDATE [dwMetadata] SET
[Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.910', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-15 12:55:06.363', 
[Data]=N'{   
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
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
    
        //console.log("changeDueDate", args);
        if(args.controlRef.state.selectedIndexes.length==0){
             alertify.error("Please select at least one list sample");
             return {};
            
        }

        var listId = args.data.Id;
        var listSampleIds = [];
        
        for (var i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            var gridIndex = args.controlRef.state.selectedIndexes[i];
            var listSampleId = args.controlRef.state.items[gridIndex].Id;
            listSampleIds.push(listSampleId);
        }

        var formData = new FormData();
        formData.append(''listId'', listId);
        formData.append(''listSampleIds'', listSampleIds);        
        var url = ''/list/deletelistsample'';
    
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
                    args.controlRef.refresh();
    
                } else {
                    alertify.error(response.message);
                }
    
            })
            .catch(error => {
                alertify.error(error.message);;
            });        
    
    
    },   
    
    toggleListSamplesActive: function(args) {

		//-----------------------
		const loadingStart = function(loadingMessage) {
		    $(''body'').loadingModal({
		    text: loadingMessage ? loadingMessage : ''Please wait...'',
		    animation: ''foldingCube'',
		    backgroundColor: ''#1262E2''});
		};
		
		const loadingStop = function() {
		    $(''body'').loadingModal(''destroy'');
		};
		//--------------------------------------------
		
		//--------------------------------------------
        const postFormRequest = function (url, formData) {
            if (url === undefined || (url === null)) {
                throw new Error(''url not specified'');
            }
            if ((formData === undefined) || (formData === null)) {
                formData = new FormData();
            }
            const promise = fetch(url, {
                credentials: "same-origin",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                method: "post",
                body: formData,
            }).then( response => {
               return response.ok ? response.json() : Promise.reject("Failed to post to server: " + response.status);
            }, reason => {
                Promise.reject(reason);
            }).then( responseData => {
                return responseData.success ? responseData : Promise.reject(responseData.message ? responseData.message : responseData);
            }, reason => {
                const message = reason.message ? reason.message : reason;
                if(message && message.includes("Unexpected token")) {
                    console.warn(url + " appears to have returned a non JSON response. Is url correct?" 
                    + ( (!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : "") );
                }
                return Promise.reject(message);
            });
            return promise;
        };
        //--------------------------------------------   
        
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
        loadingStart(waitMessage);
        postFormRequest(url, formData).then(
            response => {
                alertify("Samples disabled");
            }, reason => {
                console.log("disableListSample failed", reason);
                alertify.error(reason);
            }
        ).finally(loadingStop);
        
        return {};
    },
    
    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },
    
    exportSample: function (args){
        var url = ''/list/exportsample?listId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    
    hideMessages: function (args){
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
        
    },
    
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
        Pace.start();
        $(''body'').loadingModal({
            text: ''Importing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
            var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
              
                if (response.success) {
                    var _securitySiteIdRewriter = function (model) {
                        model.filters = ''[{"column":"IsDeleted", "value": "0", "term":"="}]'';
                        model.disabled = false;
                    };

                    CloverApp.API.setDataField("inputImportListSample", null);
                    CloverApp.API.setDataField("inputPassword", null);
                    //args.component.refs.gridviewSample.refresh();
                    //CloverApp.API.setDataField("sampleAddedCount", response.statistics.sampleAdded);
                    //CloverApp.API.setDataField("sampleUpdatedCount", response.statistics.sampleUpdated);

                    CloverApp.API.setDataField("listSampleAddedCount", response.statistics.listSampleAdded);
                    CloverApp.API.setDataField("SampleCount", response.statistics.listSampleAdded);
                    CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.listSampleUpdated); 
                    alertify.success(response.message, 8000);
                    if(response.items!=null && response.items!=undefined){
                        CloverApp.API.setDataField("gridviewImportSummary", JSON.parse(response.items));  
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: []
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
                                            hideControls: [''gridviewImportSummary'']
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
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                alertify.error(error.message);;
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
                      }
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
            }
        
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
    }
}' WHERE [Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082';

