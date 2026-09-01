-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_LIST-code.js
-- QNN_LIST-settings.json
-- QNN_LIST.json
-- QNN_LIST_SAMPLE-code.js
-- QNN_LIST_SAMPLE-settings.json
-- QNN_LIST_SAMPLE.json

UPDATE [dwMetadata] SET
[Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.910', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-08 18:13:03.237', 
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
        var url = ''/list/exportsample?listId='' + args.data.Id;
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
[Id]='948ab167-d5b8-43df-b3d7-41f3fe871887', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-14 14:40:47.180', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_LIST",
  "lastUpdate": "2022-03-14T14:40:47.17889+08:00",
  "entityId": "78c2ec12-7c7c-42c2-ad36-6305868e4e51",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterNew"
      ],
      "codeAction": "SetFields",
      "parameter": "{CreatedBy: \"@CurrentUserId\", CreatedDate: \"@DateTimeNow\",  UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": "{UpdatedBy: \"@CurrentUserId\", UpdatedDate: \"@DateTimeNow\"}"
    }
  ],
  "dataMap": [
    {
      "id": "6bb9025a-7861-e177-eded-333d69e577d4",
      "attributeId": "17bf4b77-798d-4cba-83d4-16ea2a7696b7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b63f953d-7550-606b-742b-a593cba856a2",
      "attributeId": "c25bbd26-a246-4904-9400-a34ee23930a3",
      "control": "dictionaryCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "79853784-fc1e-c680-ffe9-cb8aaeff5c39",
      "attributeId": "ebcf3683-c851-499c-a4b9-e2daec3948c2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e158c090-63ad-c843-de20-e2fd018a051e",
      "attributeId": "9eef3bf1-726a-4bcc-81db-eb27a0a16b04",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4ea041ec-525a-89ac-0908-fab13baf146b",
      "attributeId": "76f762fb-7aa1-47fd-9ecf-b0c17bca4b43",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1ccd0d11-07a4-5fa0-41d7-b5979cbfdfd1",
      "attributeId": "852fb683-2f47-412a-9e40-11de48808b16",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e8b13f8-da52-e713-1b09-efb0d94a0148",
      "attributeId": "98399b10-9bc8-442e-88ce-2ff314a8c7ba",
      "control": "headerDescription",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ce4fa93-6667-133a-8f7a-7604cf99939b",
      "attributeId": "83bee845-79e5-4929-b4fb-fe5cff7748a8",
      "control": "toggleEditEmail",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ab9545bf-afde-3b8a-be20-7fd4fb38ff33",
      "attributeId": "27f10ba1-fbdf-4878-958c-8400ea40490f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1f07bb99-136e-4e3c-2401-c27a6d38e5c6",
      "attributeId": "a11f6ad2-bda5-4a4f-bafd-230fa27ccb36",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9cf7eb23-7a27-f882-e683-4d1cd4e17c97",
      "attributeId": "31d22ca8-d782-4351-a401-4f8d5a40f8e5",
      "control": "nameInput",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9bd5ce67-64b2-f488-1327-13b0fa4725bb",
      "attributeId": "483d548e-4239-40a9-82cd-c47981e25945",
      "control": "toggleEditName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ed6d936f-04af-04c3-2ff0-a1c23fa25c83",
      "attributeId": "0d50217d-3b94-4aa3-bccb-7dbdbb222749",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "292801af-0143-79be-0402-be3fc30eec41",
      "attributeId": "3f17e524-114a-4c9a-a71f-99154710f20e",
      "control": "togglePassword",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d4af24cb-542d-3804-ef56-7cb98f1ba120",
      "attributeId": "6899bb22-b9f9-48da-adef-29209c0b0595",
      "control": "toggleStatus",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "456dd0ff-56dd-614a-89a5-4c6983bdf189",
      "attributeId": "064f6b2f-14dc-48dd-8e6d-b4e175be873f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6daa775d-0f9a-63a3-a83f-3ee20de05d28",
      "attributeId": "82b9d680-7b4e-4d25-8b72-555bbb17fe8a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8f06fd16-7354-7c35-0406-313e3dca70d2",
      "attributeId": "bb19edbc-181e-4f9d-9e8b-3f64a38dd911",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ca7559f5-2bb1-9ca3-df65-72516fecebce",
      "attributeId": "ff0920d6-c055-4e3c-a7f5-26e7633a23cc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5194d452-7552-b246-c734-b81f51c9921e",
      "attributeId": "eba31ce9-8aea-467e-a463-4ed7ba17131b",
      "control": "TrkListIds",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "1a43fd37-d856-5d57-9cca-fbdd2bd6b356",
      "entityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
      "filter": "FilterByModelId",
      "parameter": "{ListId: \"@Id\"}",
      "control": "gridviewSample",
      "dataMap": [
        {
          "id": "49f4229e-2ed5-6cbf-bc35-84f3bdffa14f",
          "attributeId": "79245942-f97d-4d6a-b3a1-0d2dbdfd57d8",
          "control": "ActiveYN",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ca89d71-5128-9a6a-c46f-83c9b59d14f0",
          "attributeId": "e20b8f8b-bf7b-4e68-8954-17682f29f3a8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "62f8faa6-b7d9-e5ae-2b1d-88968f5ad0d9",
          "attributeId": "de101582-7962-4a76-a707-a849e4e12d24",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "dbf9842b-37d4-0fb0-ada0-d035f5821578",
          "attributeId": "1ad5922d-a88f-4f09-a1c3-75c1b2fece7b",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "b98176e2-3a0a-1342-d8b6-ecc361035af1",
          "attributeId": "98039f88-493b-42e6-9130-c060f8514b69",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "955eebb3-28e6-5927-75b7-f7cdebf0bb25",
          "attributeId": "5723662d-4af8-4861-a079-98880f6ca7b0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7d339890-30b0-5099-e5fa-c29f931d88f7",
          "attributeId": "af09e234-5b40-4d0e-9200-5963747f01a8",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "a6ab3152-ef5c-3e46-47b5-87c6ea7b39a6",
          "attributeId": "c8c2baf0-e53f-46ef-ab1e-ba8d864f8895",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b1a17e60-f698-b26d-8cf7-53dd3eed081f",
          "attributeId": "0804faae-6203-4764-9752-93b86a82c513",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e53a0cd0-bbb9-568d-434b-81ba82c172ef",
          "attributeId": "dcfaa7a1-164c-4c4d-a135-de834309c262",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "ce869cca-457e-8e84-7f2d-aedebaaa4f83",
          "attributeId": "e7666721-b415-43a5-a524-4922fa12ce97",
          "isEditable": true,
          "isLoadable": false
        },
        {
          "id": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "attributeId": "68dd8ed9-176e-44c7-845e-a28f61b75b57",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e949966f-95ee-78bd-208b-afb9f7465364",
          "attributeId": "c2ec5478-2ca4-4bcc-9d48-81ac192f50d9",
          "control": "Email",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d0cdf7e6-3aea-1d21-65f6-b93e864be0e2",
          "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
          "control": "Name",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d6e0819a-a46c-6f4d-4ee2-2dddee8062a1",
          "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
          "control": "UID",
          "parentId": "ff5c241d-aa83-cf71-db67-640e4abaaad2",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "attributeId": "0c91fef3-e53e-4824-be9d-60fecb8cb087",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "93a8b5de-28af-a8b7-313a-c6429a2ce66e",
          "attributeId": "0bbb1dd9-d8c0-495b-8495-f0405a7935ff",
          "control": "PeerName",
          "parentId": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "isEditable": false,
          "isLoadable": true
        },
        {
          "id": "d28cd4d5-202d-3a60-99d3-55ab0fd8a62e",
          "attributeId": "923d3e97-2302-4d8b-a3de-b289e070a070",
          "control": "PeerUID",
          "parentId": "d6ab61c7-d748-c978-4706-3f243263e3e7",
          "isEditable": false,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__gridviewSample_totalcount"
    },
    {
      "id": "dbf01fb4-db82-d562-bddb-a718f924ef35",
      "entityId": "ff3ecf46-eaa7-4904-95c8-19e1ab5937fc",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "8442fb3b-134a-c355-7d90-f3e49c30af2c",
          "attributeId": "9c84a07d-bde2-414d-8628-9665e6df1c4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9990f3ba-6ea2-01f2-2522-5df2b216d08e",
          "attributeId": "304670fb-e871-443c-9c62-75b544da93a7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e980519-bb41-ee3b-b0f9-724fad5fe32e",
          "attributeId": "495a9b97-319e-4139-aade-8103d4bc2e41",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0df8f806-b655-09c3-7a45-f6edf7604746",
          "attributeId": "27a0ea17-2da1-4ebb-ba54-0f783e3d2907",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b49e1ae4-2ad3-3cd2-4a86-66ce0cda30c2",
          "attributeId": "fc40cac5-1da7-46d7-90c3-f8e90cf935cd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8657b639-deed-2116-f436-1982cee0669d",
          "attributeId": "cde17e04-b25f-476e-b722-97c11da29326",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e5abd8c3-1e7f-166b-91d7-6725f32c6ded",
          "attributeId": "cbe9a1b9-bea3-49e1-9e1e-ac8391624939",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "df2b19f4-19fa-9d44-b12e-1590811b0e55",
          "attributeId": "f5682ad5-b493-43a5-864e-3d554ac37ddf",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "970989ac-c2e1-737a-1d0c-fd77022f0cfe",
          "attributeId": "70c763b0-6a8e-4a59-959e-fd6859fdfc17",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ddb1ae13-7ce8-8524-217c-23de6712a577",
          "attributeId": "b2761fa3-a119-48a0-84e8-5112873d10d3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e1e49ed9-982d-bfdc-cc71-a21fd33e3522",
          "attributeId": "6eaf8118-3a45-4e6d-88bd-f0fd37671cd3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b6adfdac-f4c3-b5bd-5158-25befb267921",
          "attributeId": "b430f4f3-2d95-4d88-a2c7-b8d12d33b144",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e128c585-70ab-a73c-ad73-1fd43d8f738e",
          "attributeId": "641d5acb-3586-4c86-a28b-22c339609610",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__collectioneditor_1_totalcount"
    }
  ],
  "securityGroup": "List"
}' WHERE [Id]='948ab167-d5b8-43df-b3d7-41f3fe871887';

UPDATE [dwMetadata] SET
[Id]='715ce353-26d4-4c0f-8b65-57db2da22232', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-14 14:40:47.113', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "bcList",
        "data-buildertype": "breadcrumb",
        "items": [
          {
            "divider": "right angle",
            "text": "List",
            "url": "/form/SwzListList"
          },
          {
            "text": "Manage List",
            "active": true
          }
        ],
        "events": {
          "onItemClick": {
            "active": true,
            "actions": [
              "redirect"
            ]
          }
        }
      }
    ],
    "style-float": "left",
    "style-width": "100%"
  },
  {
    "key": "container_9",
    "data-buildertype": "container",
    "children": [
      {
        "key": "headerPage",
        "data-buildertype": "container",
        "style-float": "left",
        "style-marginTop": "",
        "style-marginBottom": "",
        "style-marginLeft": "",
        "children": [
          {
            "key": "form_5",
            "data-buildertype": "form",
            "children": [
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "children": [
                  {
                    "key": "headerName",
                    "data-buildertype": "header",
                    "content": "Manage {nameInput}",
                    "size": "large",
                    "subheader": "",
                    "style-marginTop": "5px",
                    "style-marginLeft": "",
                    "style-source": "",
                    "style-width": "300px",
                    "events": {},
                    "style-customcss": ""
                  },
                  {
                    "key": "header_1",
                    "data-buildertype": "header",
                    "content": "",
                    "size": "large",
                    "subheader": "",
                    "style-marginTop": "5px",
                    "style-marginLeft": "",
                    "style-source": "",
                    "style-width": "300px",
                    "events": {},
                    "style-customcss": ""
                  }
                ]
              }
            ],
            "style-marginLeft": "7px",
            "style-customcss": ""
          }
        ],
        "style-source": "",
        "style-marginRight": "20px"
      }
    ],
    "style-source": "",
    "style-marginTop": "10px",
    "style-marginBottom": "",
    "style-marginLeft": "",
    "style-float": "left",
    "style-width": "",
    "style-customcss": ""
  },
  {
    "key": "container_10",
    "data-buildertype": "container",
    "style-source": "",
    "style-height": "",
    "children": []
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
            "key": "container_12",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_8",
                "data-buildertype": "container",
                "style-float": "left",
                "style-width": "100%",
                "children": [
                  {
                    "key": "form_3",
                    "data-buildertype": "form",
                    "children": [
                      {
                        "key": "headerProperties",
                        "data-buildertype": "header",
                        "content": "Properties",
                        "size": "medium"
                      },
                      {
                        "key": "formgroup_5",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "nameInput",
                            "data-buildertype": "input",
                            "label": "List Name",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "text",
                            "readOnly": false,
                            "events": {},
                            "labelPosition": "",
                            "style-width": "",
                            "other-required": true,
                            "reference": "List Name"
                          }
                        ]
                      },
                      {
                        "key": "formgroup_7",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "headerDescription",
                            "data-buildertype": "textarea",
                            "label": "List Description",
                            "fluid": true,
                            "other-required": false,
                            "events": {}
                          }
                        ]
                      },
                      {
                        "key": "formgroup_4",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "dictionaryCategory",
                            "data-buildertype": "dictionary",
                            "label": "Category Name",
                            "fluid": true,
                            "selection": true,
                            "dataModel": "QNN_CATEGORY",
                            "columns": "Name ASC",
                            "events": {},
                            "filters": "[{\"column\":\"Type\", \"value\":\"L\", \"term\":\"=\"}]"
                          },
                          {
                            "key": "TrkListIds",
                            "data-buildertype": "dictionary",
                            "label": "Track List",
                            "fluid": true,
                            "selection": true,
                            "dataModel": "QNN_TRK_LIST",
                            "columns": "Name ASC",
                            "events": {},
                            "multiple": true,
                            "clearable": true,
                            "style-hidden": false
                          }
                        ]
                      },
                      {
                        "key": "formgroup_2",
                        "data-buildertype": "formgroup",
                        "widths": "equal",
                        "children": [
                          {
                            "key": "toggleStatus",
                            "data-buildertype": "checkbox",
                            "label": "Status",
                            "toggle": true,
                            "events": {},
                            "style-width": "300px"
                          }
                        ]
                      }
                    ]
                  }
                ],
                "style-customcss": ""
              }
            ],
            "style-width": "100%",
            "style-float": "left"
          },
          {
            "key": "container_13",
            "data-buildertype": "container",
            "children": [
              {
                "key": "container_2",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-float": "",
                    "style-width": "100%",
                    "children": [
                      {
                        "key": "form_4",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "headerUser",
                            "data-buildertype": "header",
                            "content": "Records User Control",
                            "size": "medium"
                          },
                          {
                            "key": "formgroup_8",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "toggleEditName",
                                "data-buildertype": "checkbox",
                                "label": "Edit Name",
                                "toggle": true
                              }
                            ]
                          },
                          {
                            "key": "formgroup_3",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "toggleEditEmail",
                                "data-buildertype": "checkbox",
                                "label": "Edit Email",
                                "toggle": true
                              }
                            ]
                          },
                          {
                            "key": "formgroup_9",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "togglePassword",
                                "data-buildertype": "checkbox",
                                "label": "Edit Password",
                                "toggle": true
                              }
                            ]
                          }
                        ],
                        "style-source": "float:left"
                      }
                    ],
                    "other-visibleConition": "",
                    "style-hidden": true
                  },
                  {
                    "key": "container_11",
                    "data-buildertype": "container",
                    "children": [],
                    "style-float": "",
                    "style-source": "clear:both",
                    "style-customcss": "",
                    "style-width": ""
                  }
                ],
                "style-source": "",
                "style-width": "100%",
                "style-marginTop": "10px"
              }
            ],
            "style-width": "100%"
          }
        ]
      },
      {
        "key": "container_4",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_2",
            "data-buildertype": "header",
            "content": "List Sample Properties",
            "size": "medium"
          },
          {
            "key": "collectioneditor_1",
            "data-buildertype": "collectioneditor",
            "idField": "Id",
            "parentIdField": "ParentId",
            "columns": [
              {
                "key": "Alias",
                "name": "Alias",
                "width": "",
                "control": "input"
              },
              {
                "key": "ReqdYN",
                "name": "Reqd",
                "control": "checkbox",
                "width": "5%"
              },
              {
                "key": "UsrEditYN",
                "name": "UsrEdit",
                "control": "checkbox",
                "width": "5%"
              },
              {
                "key": "TxtRow",
                "name": "TxtRow",
                "control": "number",
                "width": "10%"
              },
              {
                "key": "TxtRegExp",
                "name": "TxtRegExp",
                "width": "25%",
                "control": "input"
              },
              {
                "key": "TxtRegExpErr",
                "name": "TxtRegExpErr",
                "width": "20%",
                "control": "input"
              }
            ],
            "header": false,
            "headerTitle": "List Sample Properties",
            "hierarchical": false,
            "placeholders": {
              "Type": [
                {
                  "key": "Type",
                  "data-buildertype": "input",
                  "label": "",
                  "fluid": true,
                  "onChangeTimeout": 200,
                  "readOnly": true,
                  "defaultValue": "1",
                  "style-hidden": false
                }
              ]
            },
            "events": {},
            "style-width": "100%",
            "style-customcss": "hmr-block",
            "style-marginBottom": "20px"
          }
        ],
        "style-customcss": "",
        "style-width": "100%",
        "style-source": "padding: 10px;\nborder: 1px solid rgba(34,36,38,.15);",
        "style-hidden": false,
        "other-visibleConition": "",
        "style-float": "left",
        "style-marginBottom": "20px"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnSave",
            "data-buildertype": "button",
            "content": "Save",
            "events": {
              "onClick": {
                "actions": [
                  "processTrkList",
                  "validate",
                  "save",
                  "goRecords"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/SwzListList"
                  }
                ]
              }
            },
            "primary": false,
            "secondary": true
          },
          {
            "key": "btnCancel",
            "data-buildertype": "button",
            "content": "Cancel",
            "events": {
              "onClick": {
                "actions": [
                  "exit",
                  "redirect"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/swzlistlist"
                  }
                ]
              }
            },
            "secondary": true
          }
        ],
        "style-float": "right",
        "style-marginBottom": "1em"
      }
    ],
    "style-width": ""
  },
  {
    "key": "cnt_visuallyDivideMasterAndDetail",
    "data-buildertype": "container",
    "children": [
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "<hr />",
        "isHtml": true,
        "style-source": "",
        "style-marginBottom": ""
      }
    ],
    "style-float": "",
    "style-source": "text-align: center;\nclear: both;",
    "style-marginBottom": "20px",
    "other-customValidation": "",
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "container_16",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "100%",
    "children": [
      {
        "key": "form_6",
        "data-buildertype": "form",
        "children": [
          {
            "key": "container_15",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerRecords",
                "data-buildertype": "header",
                "content": "Records ",
                "size": "medium",
                "subheader": "Samples in this list"
              },
              {
                "key": "container_17",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnCreate2",
                    "data-buildertype": "button",
                    "content": "Create",
                    "primary": true,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "newListSample"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_19",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDisable",
                    "data-buildertype": "button",
                    "content": "Disable",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "toggleListSamplesActive",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "disableSamplesConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "disableSamplesConfirmText"
                          },
                          {
                            "name": "action",
                            "value": "disable"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  },
                  {
                    "key": "btnEnable",
                    "data-buildertype": "button",
                    "content": "Enable",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "toggleListSamplesActive",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "action",
                            "value": "enable"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_22",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDeleteSample",
                    "data-buildertype": "button",
                    "content": "Delete Samples & Data",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "confirm",
                          "deleteListSample",
                          "gridRefresh"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": [
                          {
                            "name": "confirmTitle",
                            "value": "deleteListSamplesConfirmTitle"
                          },
                          {
                            "name": "confirmText",
                            "value": "deleteListSamplesConfirmText"
                          }
                        ]
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ],
                "style-float": "left"
              },
              {
                "key": "container_18",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "modalImportSample",
                    "data-buildertype": "swzmodal",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "formImportList",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "formgroup_6",
                            "data-buildertype": "formgroup",
                            "widths": "equal",
                            "children": [
                              {
                                "key": "header_5",
                                "data-buildertype": "header",
                                "content": "Import Sample",
                                "size": "small",
                                "subheader": "CSV Format.. "
                              }
                            ]
                          },
                          {
                            "key": "inputPassword",
                            "data-buildertype": "input",
                            "label": "Password",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "password"
                          },
                          {
                            "key": "container_21",
                            "data-buildertype": "container",
                            "children": [
                              {
                                "key": "inputImportListSample",
                                "data-buildertype": "input",
                                "label": "",
                                "fluid": true,
                                "onChangeTimeout": 200,
                                "type": "file",
                                "events": {
                                  "onChange": {
                                    "active": false,
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
                                "key": "button_7",
                                "data-buildertype": "button",
                                "content": "Submit",
                                "primary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [
                                      "gridviewSample"
                                    ],
                                    "parameters": []
                                  }
                                }
                              },
                              {
                                "key": "button_8",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "secondary": true,
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                }
                              }
                            ],
                            "style-float": "right",
                            "style-source": "padding: 1em\n"
                          }
                        ]
                      },
                      {
                        "key": "sampleListImportHeader",
                        "data-buildertype": "header",
                        "content": "Sample List Import Complete",
                        "size": "large",
                        "events": {},
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "style-hidden": true,
                        "textAlign": "left"
                      },
                      {
                        "key": "importSummaryStatic",
                        "data-buildertype": "staticcontent",
                        "content": "<table class=\"swzTable\" border=\"0\">\n<tr style=\"background-color: #F5F5F5;\"><td>Total Rows</td><td style=\"color: green; padding-left: 32px; padding-right: 32px; width: 250px; text-align: right;\">{totalRows}</td></tr>\n<tr><td>Sample Added</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleAdded}</td></tr>\n<tr><td>Sample Updated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleUpdated}</td></tr>\n<tr><td>Sample Duplicated</td><td style=\"color: black; padding-left: 32px; text-align: right;  padding-right: 32px;\">{sampleDuplicated}</td></tr>\n<tr><td>Invalid Rows</td><td style=\"color: red; padding-left: 32px; text-align: right; padding-right: 32px;\">{invalidRows}</td></tr>\n</table>",
                        "isHtml": true,
                        "style-font-size": "15px",
                        "style-hidden": true,
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "events": {}
                      },
                      {
                        "key": "containerInvalidDetails",
                        "data-buildertype": "container",
                        "children": [
                          {
                            "key": "header_2",
                            "data-buildertype": "header",
                            "content": "Invalid Rows Detail",
                            "size": "medium",
                            "other-visibleConition": ""
                          },
                          {
                            "key": "form_2",
                            "data-buildertype": "form",
                            "children": [
                              {
                                "key": "formgroup_1",
                                "data-buildertype": "formgroup",
                                "widths": "equal",
                                "orientation": "grouped",
                                "children": [
                                  {
                                    "key": "container_3",
                                    "data-buildertype": "container",
                                    "style-float": "",
                                    "children": [
                                      {
                                        "key": "invalidRowsDetail",
                                        "data-buildertype": "collectioneditor",
                                        "idField": "Id",
                                        "parentIdField": "ParentId",
                                        "columns": [
                                          {
                                            "key": "RowNo",
                                            "name": "Row No",
                                            "control": "span",
                                            "width": ""
                                          },
                                          {
                                            "key": "ErrField",
                                            "name": "Field",
                                            "control": "span",
                                            "width": ""
                                          },
                                          {
                                            "key": "ErrMsg",
                                            "name": "Error Message",
                                            "control": "span",
                                            "width": ""
                                          }
                                        ],
                                        "disableAdd": false,
                                        "disableDelete": false,
                                        "other-visibleConition": "",
                                        "header": false,
                                        "headerTitle": "Pre-Populate Fields",
                                        "events": {},
                                        "readOnly": true
                                      }
                                    ],
                                    "style-width": "",
                                    "style-marginBottom": "",
                                    "events": {},
                                    "other-visibleConition": "",
                                    "style-customcss": "",
                                    "style-source": "overflow-y: scroll;\nmax-height: 300px;\noverflow-x: hidden;",
                                    "style-marginTop": ""
                                  }
                                ],
                                "events": {}
                              }
                            ]
                          }
                        ],
                        "style-source": "",
                        "style-customcss": "ui negative message",
                        "style-float": "",
                        "style-width": "",
                        "other-visibleConition": "(data.invalidRowsDetail!= undefined || data.invalidRowsDetail!= null)",
                        "events": {},
                        "style-hidden": true
                      },
                      {
                        "key": "btnImportClose",
                        "data-buildertype": "button",
                        "content": "Close",
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
                        "other-visibleConition": "(data.sampleAdded != null && data.sampleAdded != undefined)",
                        "style-source": "float: right;",
                        "style-hidden": true,
                        "style-marginBottom": "20px",
                        "secondary": true
                      }
                    ],
                    "style-source": "float:left",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "content": "Import",
                    "primary": false,
                    "size": "",
                    "secondary": true,
                    "compact": false,
                    "other-customValidation": "",
                    "other-visibleConition": ""
                  }
                ],
                "style-marginRight": ""
              },
              {
                "key": "container_3",
                "data-buildertype": "container",
                "style-float": "left",
                "children": [
                  {
                    "key": "btnExportSamples",
                    "data-buildertype": "button",
                    "content": "Export",
                    "primary": false,
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "exportSample"
                        ],
                        "targets": [
                          "gridviewSample"
                        ],
                        "parameters": []
                      }
                    },
                    "style-source": "float:left",
                    "secondary": true,
                    "other-visibleConition": ""
                  }
                ]
              },
              {
                "key": "inputSearch",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "300px",
                "size": "",
                "labelPosition": "",
                "style-source": "float: left;",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setFilter",
                      "applyFilter"
                    ],
                    "targets": [
                      "gridviewSample"
                    ],
                    "parameters": [
                      {
                        "name": "column",
                        "value": "Name, UID"
                      }
                    ]
                  }
                },
                "placeholder": "Search by Name or UID"
              }
            ],
            "style-width": "100%",
            "style-float": "",
            "style-marginRight": "1em",
            "style-source": "",
            "style-marginBottom": "1em",
            "style-marginTop": "",
            "events": {},
            "other-visibleConition": "data.Id?true:false"
          }
        ]
      }
    ],
    "style-hidden": false,
    "events": {},
    "other-visibleConition": "data.Id!=null"
  },
  {
    "key": "gridviewSample",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": ""
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": ""
      },
      {
        "key": "ActiveYN",
        "name": "Active",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Email",
        "name": "Email",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": ""
      }
    ],
    "autoHeight": false,
    "offSet": "",
    "multiselect": true,
    "rowKey": "Id",
    "defaultSort": "UID ASC",
    "events": {
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowDblClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "pagerType": "server",
    "editFormShowType": "",
    "minHeight": "",
    "style-marginTop": "",
    "editForm": "QNN_LIST_SAMPLE",
    "style-hidden": false,
    "rowHeight": "80",
    "pageSize": "80",
    "other-visibleConition": "data.Id!=null"
  }
]' WHERE [Id]='715ce353-26d4-4c0f-8b65-57db2da22232';

UPDATE [dwMetadata] SET
[Id]='adf598e9-17a9-4b69-bfa2-cd7b938d2472', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST_SAMPLE-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.433', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-14 14:27:31.883', 
[Data]=N'{
   init: function (args){
        var getParameterByName = function(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '''';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        };
        var getListId = function() {
            var url = window.location.href;
            var parts = url.split(''/'');
            return parts.pop() || parts.pop();  // handle potential trailing slash
        };        
       return () => {
            var listId = args.data.DictionaryListName
            var url = ''/list/genListprop/'' + listId+ ''/'' + args.data.Id;
            if(args.data.Id==undefined || args.data.Id==null){
                //listId = getParameterByName(''listId'');
                listId = getListId();
                url = ''/list/genListprop/'' + listId+ ''/''
            }
            if(listId==null || listId==undefined) return Promise.resolve();
            Utils.loadingStart();
            return Utils.getRequest(url).then(
                response => {
                if (!response.success) {
                    CloverApp.API.redirect(''form'', "SwzListList");
                }
                var item = JSON.parse(response.item);
                if(args.data.Id==undefined || args.data.Id==null) item.data[''DictionaryListName''] = listId;
                if(item.model.length==0) return Promise.resolve(
                    {
                        stateDelta: {
                            app: {
                                form: {
                                    data: {
                                        modified: {
                                            DictionaryListName: listId
                                        }
                                    }
                                },                                
                                
                                extra: {
                                    spData: item
                                }
                            },

                            
                        }
                    }
                ); 
                args.state.app.form.models.model[0].children[0].children[5].source =JSON.stringify(item.model);  

                var readOnlyArray = args.state.app.form.models.readOnlyControls;
                var rule = item.rule;
                for (var key in rule) {
                    if(rule[key]["readOnly"] =="true"){
                        readOnlyArray.push(key);
                    } 
                }                  
                
                return Promise.resolve({
                    stateDelta: {
                        app: {
                            form: {
                                data: {
                                    modified: item.data
                                },
                                models:{
                                    readOnlyControls: readOnlyArray
                                }
                            },
                            extra: {
                                spData: item
                            }
                        },
                    }
                });             
                
            	}, reason => {
            		alertify.error(reason);
            	}
            ).finally( Utils.loadingStop );
           /*return fetch(url)
            .then(function(response) {
                return response.json();
               })
            .then(response => {
                if (!response.success) {
                    CloverApp.API.redirect(''form'', "SwzListList");
                }
                var item = JSON.parse(response.item);
                if(args.data.Id==undefined || args.data.Id==null) item.data[''DictionaryListName''] = listId;
                if(item.model.length==0) return Promise.resolve(
                    {
                        stateDelta: {
                            app: {
                                form: {
                                    data: {
                                        modified: {
                                            DictionaryListName: listId
                                        }
                                    }
                                },                                
                                
                                extra: {
                                    spData: item
                                }
                            },

                            
                        }
                    }
                ); 
                args.state.app.form.models.model[0].children[0].children[5].source =JSON.stringify(item.model);  

                var readOnlyArray = args.state.app.form.models.readOnlyControls;
                var rule = item.rule;
                for (var key in rule) {
                    if(rule[key]["readOnly"] =="true"){
                        readOnlyArray.push(key);
                    } 
                }                  
                
                return Promise.resolve({
                    stateDelta: {
                        app: {
                            form: {
                                data: {
                                    modified: item.data
                                },
                                models:{
                                    readOnlyControls: readOnlyArray
                                }
                            },
                            extra: {
                                spData: item
                            }
                        },
                    }
                });             
                
            })
            .catch(function(ex) {
                //alertify.error("");
            });*/
        };
    },
    saveProp: function(args){
        var hasError = false;
        var errors = {main: {}};    
        var messages = [];
        
        if(args.data.DictionaryListName == null || args.data.DictionaryListName == Utils.EMPTY_GUID){
            hasError = true;
            messages.push("List Title is required");
            errors.main["DictionaryListName"] = true;
        }
        
        if(args.data["dictionarySample"] == null || args.data["dictionarySample"] == Utils.EMPTY_GUID) {
            hasError = true;
            messages.push("Sample is required");
            errors.main["dictionarySample"] = true;
        }
            
        if(!hasError){
            var data = args.state.app.extra.spData.data;
            var model = args.state.app.extra.spData.model;
            var rule = args.state.app.extra.spData.rule;
            
            //List Sample Properties validation
            if(model.length>0){
                for (var key in data) {
                    //if (data.hasOwnProperty(key)) {
                    //    data[key] =  $("input[name=''"+key+"''], textarea[name=''"+key+"'']").val();
                    //    args.data[key] = data[key];
                    //}
                    if((args.data[key]==null || args.data[key]=="") && rule[key]!=null && rule[key]["reqd"].toLowerCase()=="true"){
                        hasError = true;
                        messages.push("<br />" + key + " is required");
                        errors.main[key] = true;
                        //errors.ADDRESS1 = key + " " + "required";
                        //args.state.app.form.errors.main = {ADDRESS1: true};
                        //$("input[name=''"+key+"''], textarea[name=''"+key+"'']").parent().addClass(''error'');
                    }
                    
                    if(rule[key]!=null && rule[key]["txtRegExp"]!=null && rule[key]["txtRegExp"]!=""){
                        
                        let funcArgs = ''value, data'';
                        let body = ''return '' + rule[key]["txtRegExp"];
                        let isValid = new Function(funcArgs, body)(args.data[key], args.data);
                        if (typeof isValid === ''boolean''){
                            if (isValid === false) {
                                hasError = true;
                                messages.push("<br />" + key + " " + rule[key]["txtRegExpErr"]);
                                errors.main[key] = true;
                            }
                        }
                        else{
                            error = isValid;
                        }
                    }
                }
                //args.component.forceUpdate();
                //console.log("saveProp args: ", args);
            }
        
        }

        if(hasError){
            throw {
                level: 1,
                message: messages,
                formerrors: errors
            };
        }
        

        return ()=> {
            var listSampleId = args.data.Id;
            var listId = args.data.DictionaryListName;
            var formData = new FormData();
            formData.append(''listSampleId'', listSampleId);
            formData.append(''listId'', listId);        
            formData.append(''listSampleProp'', JSON.stringify(args.data));
            var url = ''/list/savelistprop'';
            Utils.loadingStart();
            return Utils.postFormRequest(url, formData).then(
            	response => {
            		if (response.success) {
                        alertify.success("List sample changed");
                        CloverApp.API.redirectToForm(''QNN_LIST'',response.item);
                    } else {
                        alertify.error(response.message);
                    }
            	}, reason => {
            		alertify.error(reason);
            	}
            ).finally( Utils.loadingStop );
        };
    },
   
    goBack: function(args) {
        if(args.data.DictionaryListName !== Utils.EMPTY_GUID){
            CloverApp.API.redirectToForm(''QNN_LIST'', args.data.DictionaryListName);
        }else{
            CloverApp.API.redirectToForm(''SwzListList'');
        }
    },
    //Do not delete. Is required by list property fields
    propertyOnChange: function(args){
        
    }

}' WHERE [Id]='adf598e9-17a9-4b69-bfa2-cd7b938d2472';

UPDATE [dwMetadata] SET
[Id]='93a53d80-5afe-4eba-9b6c-b635ea424879', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST_SAMPLE-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.480', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-10 13:41:38.100', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "QNN_LIST_SAMPLE",
  "lastUpdate": "2022-03-10T13:41:38.0992295+08:00",
  "entityId": "0d20b68d-1ca2-42ca-a6bc-aafb14a1008a",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "d3fcd0a7-f271-1814-0bdb-4d49b32326eb",
      "attributeId": "79245942-f97d-4d6a-b3a1-0d2dbdfd57d8",
      "control": "ActiveYN",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "be26f972-5122-f200-8d78-e74fb5cd55fa",
      "attributeId": "e20b8f8b-bf7b-4e68-8954-17682f29f3a8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a565d76f-79a8-3bed-ce96-e787ad4164d3",
      "attributeId": "de101582-7962-4a76-a707-a849e4e12d24",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a70f3313-0c44-6e58-37a3-9425445e7281",
      "attributeId": "1ad5922d-a88f-4f09-a1c3-75c1b2fece7b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "622e9be6-151f-9edc-9937-e0607e2af60b",
      "attributeId": "98039f88-493b-42e6-9130-c060f8514b69",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e2bc23b6-3714-e347-819c-edda82506012",
      "attributeId": "5723662d-4af8-4861-a079-98880f6ca7b0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d27d197c-c3dc-6813-4789-68a10910e391",
      "attributeId": "af09e234-5b40-4d0e-9200-5963747f01a8",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6a4ca1d8-ab14-3695-3d70-e5d4d4437190",
      "attributeId": "c8c2baf0-e53f-46ef-ab1e-ba8d864f8895",
      "control": "DictionaryListName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9df4d633-6819-b137-7dfa-f5284b394b99",
      "attributeId": "31d22ca8-d782-4351-a401-4f8d5a40f8e5",
      "parentId": "6a4ca1d8-ab14-3695-3d70-e5d4d4437190",
      "isEditable": false,
      "isLoadable": true
    },
    {
      "id": "a0d749d9-08c8-bdd7-449a-f584627b6cfd",
      "attributeId": "0804faae-6203-4764-9752-93b86a82c513",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d9f967df-5b61-c0b0-fb87-a8011db68bb8",
      "attributeId": "dcfaa7a1-164c-4c4d-a135-de834309c262",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a762c4ec-c806-6933-d52c-a63e364d6fff",
      "attributeId": "e7666721-b415-43a5-a524-4922fa12ce97",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c0a1060c-64f1-1dc2-3e95-24b262c1f211",
      "attributeId": "68dd8ed9-176e-44c7-845e-a28f61b75b57",
      "control": "dictionarySample",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f6b56a50-4df1-08d6-47de-f2c839f12ac5",
      "attributeId": "0c91fef3-e53e-4824-be9d-60fecb8cb087",
      "control": "dictionarySamplePeer",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "List"
}' WHERE [Id]='93a53d80-5afe-4eba-9b6c-b635ea424879';

UPDATE [dwMetadata] SET
[Id]='3d71b17c-19aa-4e2d-b1c0-632992eefb96', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST_SAMPLE.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.530', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-03-10 13:41:37.890', 
[Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Manage Sample",
            "size": "large",
            "events": {}
          },
          {
            "key": "DictionaryListName",
            "data-buildertype": "dictionary",
            "label": "List Title",
            "fluid": true,
            "selection": true,
            "columns": "Name ASC",
            "dataModel": "QNN_LIST",
            "events": {},
            "other-required": true,
            "other-readOnlyConition": "true",
            "paging": true,
            "pageSize": "20",
            "filters": ""
          },
          {
            "key": "dictionarySample",
            "data-buildertype": "dictionary",
            "label": "Sample",
            "fluid": true,
            "selection": true,
            "columns": "UID ASC",
            "dataModel": "vSP_QnnSampleActive",
            "events": {},
            "other-required": false,
            "other-readOnlyConition": "data.Id!=null",
            "search": true,
            "paging": true,
            "pageSize": "20",
            "other-customValidation": "value!=''00000000-0000-0000-0000-000000000000'' ?true:''Sample is requried''",
            "filters": ""
          },
          {
            "key": "dictionarySamplePeer",
            "data-buildertype": "dictionary",
            "label": "Sample Peer",
            "fluid": true,
            "selection": true,
            "columns": "UID ASC",
            "dataModel": "vSP_QnnSampleActive",
            "events": {},
            "other-required": false,
            "other-readOnlyConition": "data.Id!=null",
            "search": true,
            "paging": true,
            "pageSize": "20",
            "clearable": true
          },
          {
            "key": "ActiveYN",
            "data-buildertype": "checkbox",
            "label": "Status",
            "toggle": true
          },
          {
            "key": "customBlockSampleProps",
            "data-buildertype": "customblock",
            "sourceType": "source",
            "source": "[]",
            "style-marginBottom": "1em"
          }
        ]
      },
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "btnSave",
            "data-buildertype": "button",
            "content": "Save",
            "events": {
              "onClick": {
                "actions": [
                  "saveProp"
                ],
                "active": true,
                "targets": [],
                "parameters": []
              }
            },
            "primary": true
          },
          {
            "key": "btnExit",
            "data-buildertype": "button",
            "content": "Cancel",
            "events": {
              "onClick": {
                "actions": [
                  "goBack"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "target",
                    "value": "/form/SwzListList"
                  }
                ]
              }
            },
            "primary": false,
            "secondary": true
          }
        ],
        "style-float": "left",
        "events": {},
        "style-source": "",
        "style-marginBottom": "1em"
      }
    ],
    "style-width": "700px",
    "style-source": "clear: both;\nmaxWidth: 1050;\n",
    "style-marginTop": "10px",
    "style-customcss": ""
  }
]' WHERE [Id]='3d71b17c-19aa-4e2d-b1c0-632992eefb96';

