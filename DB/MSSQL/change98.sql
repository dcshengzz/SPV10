-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_QNN-code.js
-- QNN_DPLY-code.js

UPDATE dwMetadata SET
[Id]='927fc400-e371-4fbb-b866-cb020fff46db', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.580', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-01-15 13:47:10.670', 
[Data]=N'{
    init: function(args){
      //console.log(''View Args'', args);    
      //args.component.refs.collectioneditor_2.props.placeholders.Name["0"][""data-elements""]
        if(args.data.Id){
            CloverApp.API.setDataField("UpdatedDate", new Date());
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.Id);                  
            }
            catch{}
        }

    },  

    viewArgs(args){
        //console.log(''View Args'', args);    
    },
    
    reloadPage(args) {
        window.location = window.location;  
    },
    
  GenFormFields:function(args){
      console.dir(args);
      var qnnId = args.data.Id;
      var token = args.data.collectioneditor_1[0].Token;
          var url = ''/qnn/genfields?qnnId='' + args.data.Id + ''&token='' + token;
    $.post(url).done(function (data) {
        if(data.success)
            alertify.success(data.message);
        else
            alertify.error(data.message);
    }).fail(function (jqxhr, textStatus, error) {
       alertify.error(textStatus);
    }); 
    return {};
      
  },
  
    validate: function (args){
        var errorMessages = [];
        var hasError = false;
        var errors = {main: {}};    
        
        if(args.data.Title==undefined || args.data.Title==null || args.data.Title.trim() == ''''){
                errorMessages.push(''Please enter questionnaire title'');
                errors.main.Title = true;
                hasError= true;
        } 
        if(args.data.Type==undefined || args.data.Type==null){
                errorMessages.push(''<br />Please select questionnaire type!'');
                errors.main.Type = true;
                hasError= true;
        }        
        else if(args.data.Type==''P''){
            if(args.data.collectioneditor_1 == undefined || args.data.collectioneditor_1.length == 0){
                errorMessages.push(''<br />Please insert PDF form!'');
                errors.main.collectioneditor_1 = true;
                hasError = true;
            }
        }
        else{
            if(args.data.collectioneditor_2 == undefined || args.data.collectioneditor_2.length == 0){
                errorMessages.push(''<br />Please insert an online form!'');
                errors.main.collectioneditor_2 = true;
                hasError = true;
            }            
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
}' WHERE [Id]='927fc400-e371-4fbb-b866-cb020fff46db';

UPDATE dwMetadata SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-01-15 13:46:56.787', 
[Data]=N'{
     checkQnnFields: function(qnnId){
    
        var formData = new FormData();
        formData.append(''qnnId'', qnnId);
        var url = ''/qnn/checkfields'';
    
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (!response.success) {
                    alertify.alert(response.message);
    
                } 
            })
            .catch(error => {
                alertify.alert(error.message);;
            });
            

    },      
    setDplyState: function(args){
        if(args.data.EnableWorkflow==1){
            if(!args.data.Id){
                CloverApp.API.setDataField("State", "Draft");             
                CloverApp.API.setDataField("StateName", "Draft");                    
            }
        }  
        else{
            CloverApp.API.setDataField("State", "Active");             
            CloverApp.API.setDataField("StateName", "Active");                
        }          
    },
    toggleCompletionUrl: function(args){
        
        if(args.data.IsAnonymous==1){
 
        }  
        else{
            CloverApp.API.setDataField("textCompleteURL", null);              
        }         
    },
    downloadEmailTemplate: function(args){
             var text = '''';
            text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
            text += ''Purpose of the Survey:\n''
            text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
            text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
            text +=''Submission of the Questionnaire:\n''
            text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
            text +='' \n''
            text +=''The following are your login information:\n''
            text +=''Company name: {Name}\n''
            text +=''Username: {UID}\n''
            text +=''Password: {Password}\n''
            text +='' \n''
            
            text +=''Other tokens:\n''
            text +=''Survey Url:{SurveyUrl}\n''            
            text +=''Deployment List Sample Id:{DplySampleInfoId}\n''                
            text +=''UID: {UID}\n''
            text +=''Password: {Password}\n''
            text +=''Questionnaire Name: {DplyQnn}\n''
            text +=''List Name: {DplyList}\n''
            text +=''Deployment Name: {DplyName}\n''
            text +=''Category Name: {DplyCategory}\n''
            text +=''UIDPeer: {UIDPeer}\n''
            text +=''Account Active Status: {ActiveYN}\n''
            
             var hiddenElement = document.createElement(''a'');
                hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
                hiddenElement.target = ''_blank'';
                hiddenElement.download = ''EmailTemplate.txt'';
                hiddenElement.click();
    },
    downloadInvalidColumns(args){
//        CloverApp.API.setDataField("invalidQnnColumns",[''A11'', ''B22'', ''C33'']);
        
        var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidQnnColumns'');

    },
    downloadInvalidDates(args){

          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidDates_Updated'');
        
    },
    downloadInvalidUIDs(args){

          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidUIDs'');
        
    },
    viewArgs(args){
      console.log("View Args", args);  
    },
    submitFile(args){
        var token = args.data.listFile;
        var dplyId = args.data.Id;
        var qnnId = args.data.dictQuestionnaire;
        var listId = args.data.dictList;

        var errors = {};
        if (qnnId == null || qnnId == undefined)
         alertify.error("Questionnaire not selected");
        if (listId == null || listId == undefined)    
         alertify.error("List not selected''");
        if (dplyId == null || dplyId == undefined)    
         alertify.error("There is no existing deployment");
         
         if (token == null || token == undefined){
             errors.token = ''Please select csv file'';
                
            if(errors.token){
              throw {
                  level: 1,
                  message: ''Check errors on the form!'',
                  formerrors: {main: errors}
              };
            }
            return {};
        }
        
        var url = ''/deployment/importresponse?token='' + token + ''&qnnId='' + qnnId + ''&listId='' + listId + ''&dplyId='' + dplyId;
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
                    
                    alertify.success(''The changes have been applied!'');
                    console.log("Response is", response);
                    
                    CloverApp.API.setDataField("totalRows", response.statistics.totalRows);
                    CloverApp.API.setDataField("totalSampleResponseAdded", response.statistics.totalSampleResponseAdded);
                    CloverApp.API.setDataField("totalSampleNoResponse", response.statistics.totalSampleNoResponse);
                    CloverApp.API.setDataField("totalSampleResponseAnsAdded", response.statistics.totalSampleResponseAnsAdded);                    
                    CloverApp.API.setDataField("totalInvalidQnnColumns", response.totalInvalidQnnColumns);
                    CloverApp.API.setDataField("totalInvalidUIDs", response.totalInvalidUIDs);
                    CloverApp.API.setDataField("totalInvalidDates_Updated", response.totalInvalidDates_Updated);
                    CloverApp.API.setDataField("totalInvalidScore_Updated", response.totalInvalidScore_Updated);
                   
                    if(response.statistics.totalSampleResponseAdded !== null && response.statistics.totalSampleResponseAdded != undefined){
                            CloverApp.API.setDataField("invalidQnnColumns", response.invalidQnnColumns);
                            CloverApp.API.setDataField("invalidUIDs", response.invalidUIDs);
                            CloverApp.API.setDataField("invalidDates_Updated", response.invalidDates_Updated);
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
                    alertify.error("Invalid");
                    console.log(response.message);
                }
            })
            .catch(error => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                //alertify.error(error.message);;
                console.log(error.message);
            });
        };
    }, 
    closeModal: function (args){
        console.log("Close modal", args);
        args.component.refs.importModal.close();
        if(args.component.refs.moreModal !== undefined)
            args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []
                }
              }
            }
        }       
    },
    
     closeMoreModal: function (args){
        console.log("Close open modal", args);
            args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []//[totalSampleResponseAdded, totalSampleResponseAnsAdded, totalInvalidQnnColumns, totalInvalidUIDs, totalInvalidDates_Updated, totalInvalidScore_Updated, invalidQnnColumns, invalidUIDs, invalidDates_Updated]
                  }
              }
            }
        }       
    },
    toggoleIpInclusive: function(args){
        if(args.data.RestrictIpInclusive==1){
            CloverApp.API.setDataField("RestrictIpInclusive", "1");   
        }  
        else{
            CloverApp.API.setDataField("RestrictIpInclusive", "0");              
        }        
    },
    showHideControls: function(args){
        var hideControls = [];
        var showControls = [];
        if(args.data.RestrictIp==1){
            CloverApp.API.setDataField("RestrictIp", "1"); 
            if(args.data.RestrictIpInclusive==1){
                args.data.RestrictIpInclusive=''1'';
                CloverApp.API.setDataField("RestrictIpInclusive", "1");   
            }  
            else{
                args.data.RestrictIpInclusive=''0'';
                CloverApp.API.setDataField("RestrictIpInclusive", "0");              
            }            
            qnn_dplyUserActions.addUniqueElement(showControls, ''RestrictIpInclusive'');
            qnn_dplyUserActions.addUniqueElement(showControls, ''countryOrIpRange'');  

            if(args.data.IpCountry || (!args.data.IpCountry && !args.data.IpRange)){
                args.data.countryOrIpRange=''1'';
            }
            else{
                args.data.countryOrIpRange=''0'';
            }  
         
            
            if(args.data.countryOrIpRange==1){
                CloverApp.API.setDataField("countryOrIpRange", ''1'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpCountry'');                      
            }
            else{
                CloverApp.API.setDataField("countryOrIpRange", ''0'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpRange'');                         
            }            
             
            
        }  
        else{
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, ''RestrictIpInclusive'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''countryOrIpRange'');    
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');                
        }        


        return {hideControls: hideControls, showControls: showControls};
    },
    removeElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    },
    addUniqueElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index > -1) return;
        array.push(element);
    },
        
    setIpRestriction: function(args){
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c));
        
        console.log(args)
        return {
            app: {
                form: {
                    models: {
                        hideControls: args.state.app.form.models.hideControls
                    }
                }
            }
        };        
    },
    init: function(args) {
        
        if(!args.data.Id){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
        }
        
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c)); 
        
        
         // Implement function to remove element from array
        var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };

        CloverApp.API.setDataField("cbMailMerge", false);
        CloverApp.API.setDataField("cbEmail", false);
        CloverApp.API.setDataField("subject", "");
        CloverApp.API.setDataField("msgContent", "");
        
        if(args.data.Id){
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.dictQuestionnaire);                  
            }
            catch{}
        }          

  var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
          var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
 
 
      var dplyId = args.data.Id;

        if (args.data.Id == null) 
            return {
                app: {
                    form: {
                        models: {
                            hideControls: args.state.app.form.models.hideControls
                        }
                    }
                }
            };
    
    
    // Only get category details
    // iff args.data.Id is not null
    
    var url = ''/snapData/get?id='' + dplyId;
        // _loadingStart();
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
              qnn_dplyUserActions.showHideControls(args);  
              console.log("Response is", response);
                if (response.success) {
                    
                     var _hideControls = args.state.app.form.models.hideControls;
                     var items = response.items;
                    if (items != null)
                    {
                   
                    var obj = typeof items != ''object'' ? JSON.parse(items) : items;
                    var valChkScheduler = obj[0].Id;
                    var EmailRecipients = obj[0].EmailRecipients;
                    var valEmailSuccess ;
                    var valEmailFailure ;
                     
                  if(obj[0].EmailSuccess == true)
                    {
                        valEmailSuccess = ''1'';
                    }
                  else
                       valEmailSuccess = ''0'';
                        
                  if(obj[0].EmailFailure == true)
                  {
                        valEmailFailure = ''1'';
                  }
                   else
                   {
                      valEmailFailure = ''0'';
                    }
                    
                   // var recipients = [];
                    
                     var recipients = [];
                    if(EmailRecipients == "No Recipient")
                    {
                        recipients = [];
                    }
                    else
                    {
                         var breakRecepient = EmailRecipients.split('','');
                         for (let r = 0 ; r < breakRecepient.length ; r++ )
                         {
                        recipients.push(breakRecepient[r]);
                    }
                    
                    }
               
                   /*// alert(items.length);
                    if(items !== undefined && items.length > 0){
                        _removeElement(_hideControls, dailySsForm);
                    }
                   // recipients.push(EmailRecipients);*/
                   
                   
                   
                   
                    CloverApp.API.setDataField("chkScheduler", 1);
                    CloverApp.API.setDataField("ddlEmailReceipients",recipients);
                    CloverApp.API.setDataField("chkEmailSuccess", valEmailSuccess);
                    CloverApp.API.setDataField("chkEmailFail", valEmailFailure);
                    
                    _removeElement(_hideControls, ''dailySsForm'');  
                    _hideControls.concat(hideControls);
                    return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: _hideControls
                                        }
                                    }
                                },
                            }
                        });  
                        
                    }
                    else
                    {
                        CloverApp.API.setDataField("chkScheduler", 0);
                        CloverApp.API.setDataField("ddlEmailReceipients", []);
                        CloverApp.API.setDataField("chkEmailSuccess", false);
                        CloverApp.API.setDataField("chkEmailFail", false);
                        return {
                            app: {
                                form: {
                                    models: {
                                        hideControls: args.state.app.form.models.hideControls
                                    }
                                }
                            }
                        };                    
                    }
                   
                    //  _loadingStop();
                   
                }
        
            })
   
            .catch(function(ex) {
                alertify.error("Could not Data due to " + ex);
            });
  };
       
    },
    
     onClickSave: function (args){
  
    var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
          var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
   
  
  
      var data = args.data.chkScheduler;
      var dplyId = args.data.Id;
      
      var emailSuccess = args.data.chkEmailSuccess;
      var emailFail = args.data.chkEmailFail;
      var userId = args.data.ddlEmailReceipients;
      console.log(args.data);
      console.log(userId);         
   
            
        var formData = new FormData();
        formData.append(''CheckBox'', data);
        formData.append(''dplyId'',dplyId);
        formData.append(''emailSuccess'',emailSuccess);
        formData.append(''emailFail'',emailFail);
        formData.append(''userId'',userId);
        
      
        var url = ''/report/getJobData'';
          _loadingStart();
            fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                
                _loadingStop();
                if (response.success) {
              
                  //  alertify.success("");
              console.log(data);
              
               } else {
                   // alertify.success(" ");
                }

            })
           .catch(error => {
               alertify.error(error.message);;
            });

 
},
    
    parseHtml: function(args) {

        return {
              app: {
                  form: {
                      data: {
                          modified: {
                             msgContent: args.component.refs.htmlEditor.state.htmlData                            
                            }
                        }
                    }
                }
        };  
    },
    dropdownQuestionnaireOnChange: function(args) {
    },
    radioCompletionActionOnChange: function(args) {
    },
    radioCompletionNavBackOnChange: function(args) {
    },
    radioCompletionNavCancelOnChange: function(args) {
    },
    btnSaveOnClick: function(args) {
        // Insert [QNN_DPLY_SAMPLE_INFO]
    },
    clearContent: function(args){
        if(args.data.countryOrIpRange=="1"){
            CloverApp.API.setDataField("IpRange", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpCountry'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpRange'');             
            
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }
        }
        else{
            CloverApp.API.setDataField("IpCountry", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpRange'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpCountry'');      
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }            
        }

    },

    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            //CloverApp.API.redirectToForm("QNN_DPLY",args.data.RecurrenceOfDplyId);
            location.href = "/form/QNN_DPLY/" + encodeURIComponent(args.data.RecurrenceOfDplyId);
        } else {
            alertify.error("This deployment does not have a parent");
        } 
    },
}












' WHERE [Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf';

