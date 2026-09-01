--------------------------------------
--when list name or csv file is empty, don't proceed with import
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='FFCA2D82-5E02-4AD0-9A7C-764A6DF7D0A8', [Folder]=N'metadata/forms', [Filename]=N'SwzListList-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:25.420', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-04 11:14:02.133', [Data]=N'{
    viewArgs: function (args){
        console.log("View", args);
    },
    
    submitFile(args){
        var token = args.data.listFile;
        var listName = args.data.listName;
        
        var errors = {};
        if (!listName){
            errors.listName = ''Please enter list name'';
        }
        if(!token){
            errors.listFile = ''Please select csv file'';
        }
        
        if(errors.listName || errors.listFile){
            alertify.error(''List name or file cannot be empty'');
            throw {
                level: 1,
                //message: ''List name or file cannot be empty'',
                formerrors: {main: errors}
            };
          
          //alertify.error(errors);
          return {};
        }        
        

        /*if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };*/

        var url = ''/list/importlistsamples?token='' + token + ''&listName='' + listName;
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

                    //CloverApp.API.setDataField("listFile", null);
                    //CloverApp.API.setDataField("listName", null);
                    CloverApp.API.setDataField("sampleAdded", response.statistics.sampleAdded);
                    CloverApp.API.setDataField("sampleUpdated", response.statistics.sampleUpdated);
                    args.component.refs.grid.refresh();
                    //CloverApp.API.setDataField("listSampleAddedCount", response.statistics.listSampleAdded);
                    //CloverApp.API.setDataField("SampleCount", response.statistics.listSampleAdded);
                    //CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.listSampleUpdated); 
                    
                    if(response.items!=null && response.items!=undefined){
                        //CloverApp.API.setDataField("gvImportSummary", JSON.parse(response.items));  
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
                                            hideControls: []
                                        }
                                    }
                                },
    
                                
                            }
                        });                        
                    }
   
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
    closeModal: function (args){

        args.component.refs.importModal.close();
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
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gvImportSummary'']
                  }
              }
            }
        }       
    }
}', [StructDivisionId]=NULL WHERE ([Id]='FFCA2D82-5E02-4AD0-9A7C-764A6DF7D0A8');
GO

--------------------------------
--if grid has no record, don't proceed with export
UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='EA958DA5-0374-40DD-A53A-A00315A50A3A', [Folder]=N'metadata/forms', [Filename]=N'QNN_TRK_LIST-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-10-04 15:06:37.850', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-04 17:39:19.740', [Data]=N'{
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
        
    },
    onDownloadTemplate(args){
        const filename = "trklistsample_import_template.csv";
        var data = [["UID", "NAME", "EMAIL", "REMARKS", "STATUSCODE"],
        ["UID001", "Albert Einstein", "einstein@softworkz.net", "Cease operation", "PE"]];
        let csvContent = data.map(e => e.join(",")).join("\n");      
        blob = new Blob([csvContent], {type: "octet/stream"}),
        encodedUri = window.URL.createObjectURL(blob);
        if (typeof window.navigator.msSaveBlob !== ''undefined'') {
            window.navigator.msSaveBlob(blob, filename);
        } else {
            var link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", filename);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    },
    newTrkListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_TRK_LIST_SAMPLE'', ''/trklistid/''+ args.data.Id)
    },
    
    exportSample: function (args){

        if(args.controlRef.state.rowsCount==0){
            alertify.error("Nothing to export");
            return;
        }
        var url = ''/trklist/exportsample?trkListId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
},

    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
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

        var url = ''/list/importsamples?token='' + token + ''&listId='' + args.data.Id + ''&password='' + password;
        if(password == null || password == undefined) url = ''/trklist/importsamples?token='' + token + ''&trkListId='' + args.data.Id;
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
                    CloverApp.API.setDataField("inputImportListSample", null);
                    args.component.refs.gridviewSample.refresh();
                    CloverApp.API.setDataField("listSampleAddedCount", response.statistics.trkListSampleAdded);
                    CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.trkListSampleUpdated); 
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
 
   
        
    closeModal: function (args){
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gridviewImportSummary'']
                  }
              }
            }
        }       
    }
    
    
}', [StructDivisionId]='72D461B2-234B-40D6-B410-B261964BA291' WHERE ([Id]='EA958DA5-0374-40DD-A53A-A00315A50A3A');

Go

------------------------------
-- fix when trklistsample record has no status set, record is not selected   
	ALTER PROCEDURE [dbo].[spSP_GetTrkListSample]
		@TrkListId uniqueidentifier
	AS
	BEGIN

		select UID, NAME, EMAIL, REMARKS, s.Code as STATUSCODE, s.Title as STATUS from QNN_TRK_LIST_SAMPLE tls
		left join QNN_STATUS s on s.Id = tls.Status where TrkListId = @TrkListId ORDER BY UID ASC

	END
	GO

-----------------------------------
--Category form, name required, type required

UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='11C92291-9D59-45B1-9322-A28318BB61C2', [Folder]=N'metadata/forms', [Filename]=N'QNN_CATEGORY.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.060', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-02-04 23:00:01.360', [Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "form_1",
        "data-buildertype": "form",
        "children": [
          {
            "key": "Name",
            "data-buildertype": "input",
            "label": "Name",
            "fluid": true,
            "onChangeTimeout": 200,
            "other-required": true,
            "events": {}
          },
          {
            "key": "Description",
            "data-buildertype": "input",
            "label": "Description",
            "fluid": true,
            "onChangeTimeout": 200
          },
          {
            "key": "dropdownType",
            "data-buildertype": "dropdown",
            "label": "Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "L",
                "text": "List"
              },
              {
                "key": 2,
                "value": "Q",
                "text": "Questionnaire"
              },
              {
                "key": 3,
                "value": "D",
                "text": "Deployment"
              }
            ],
            "search": true,
            "placeholder": "Select type...",
            "other-required": true,
            "events": {}
          },
          {
            "key": "dictRoles",
            "data-buildertype": "dictionary",
            "label": "Roles",
            "fluid": true,
            "selection": true,
            "dataModel": "dwSecurityRole",
            "columns": "Name ASC",
            "placeholder": "Select one or more roles...",
            "multiple": true,
            "events": {},
            "filters": "[{\"column\": \"Code\", \"value\":\"Admins\", \"term\":\"!=\"}, {\"column\": \"Code\", \"value\":\"User\", \"term\":\"!=\"}]",
            "paging": false,
            "search": false
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "children": [
              {
                "key": "btnSave",
                "data-buildertype": "button",
                "content": "Save",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "btnSaveOnClick"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "btnExit",
                "data-buildertype": "button",
                "content": "Cancel",
                "events": {
                  "onClick": {
                    "actions": [
                      "goback"
                    ],
                    "active": true,
                    "targets": [],
                    "parameters": []
                  }
                },
                "primary": false,
                "secondary": true
              }
            ],
            "style-float": "left"
          }
        ]
      }
    ]
  }
]', [StructDivisionId]=NULL WHERE ([Id]='11C92291-9D59-45B1-9322-A28318BB61C2');

GO
-----------------