-- Implementation step:
-- 1. execute this script
-- 2. follow the steps in change55.sql.docx



ALTER TABLE [dbo].[QNN_DPLY] ADD [RestrictIp] bit NULL  
GO

ALTER TABLE [dbo].[QNN_DPLY] ADD [IpCountry] nvarchar(1000) NULL 
GO

ALTER TABLE [dbo].[QNN_DPLY] ADD [RestrictIpInclusive] bit NULL 
GO

ALTER TABLE [dbo].[QNN_DPLY] ADD [IpRange] nvarchar(1000) NULL 
GO

----------------------
-- ---------------------------
-- Add d.IpCountry, d.RestrictIp
ALTER VIEW [dbo].[vSP_ListSampleInfo] AS 
select lsi.Id, lsi.NumberId, lsi.DplyId, lsi.ListSampleId, lsi.Remarks, lsi.StatusModifyBy, lsi.StatusModifyOn, lsi.RemarksModifyBy, lsi.RemarksModifyOn, lsi.DispatchInd, lsi.ReturnInd, lsi.ProcessValidInd, lsi.ProcessEditInd, lsi.Status, lsi.PdfPassword, lsi.CreatedBy, lsi.CreatedDate, s.UID, s.Id as SampleId, 
Concat(s.UID, ' (', s.Name, ')') as UIDName, 

CASE
	WHEN s1.UID is null THEN null   
	WHEN s1.UID is not null THEN Concat(s1.UID, ' (', s1.Name, ')')
END 
as PeerName,

qs.Title as StatusTitle,
s1.UID as UIDPeer, d.CreatedDate as DplyCreatedDate, d.Name as DplyName, d.IpCountry, d.RestrictIp, d.RestrictIpInclusive, d.IpRange,
d.DateStart as DplyDateStart, d.DateEnd as DplyDateEnd, d.QnnId, d.IsDeleted as DplyIsDeleted, d.Status as DplyStatus, d.CompleteAction, d.CompleteURL, d.DaysUpdate, d.MaxResponse, d.VisibleToRespondent,

CASE
when due.DueDate is null then d.DateEnd
when due.DueDate > d.DateEnd then due.DueDate
else d.DateEnd
END 
as DueDate, 

q.Title as QnnTitle, q.IsDeleted as QnnIsDeleted, q.Status as QnnStatus, q.Type as QnnType,
--f.Name as FormName,  
CASE
	WHEN q.Type='P' THEN 'Offline'   
	WHEN q.Type='O' THEN 'Online'   
END 
as Type,

ls.ListId,

SUBSTRING(
        (
            SELECT '||'+qqf.Name  AS [text()]
            FROM QNN_QNN_FORM qqf
            WHERE qqf.QnnId = q.Id
            ORDER BY qqf.Name
            FOR XML PATH ('')
        ), 3, 1000) [FormNames], 

SUBSTRING(
		(
				SELECT '||'+qqf.[Language]  AS [text()]
				FROM QNN_QNN_FORM qqf
				WHERE qqf.QnnId = q.Id
				ORDER BY qqf.Name
				FOR XML PATH ('')
		), 3, 1000) [Languages],

SUBSTRING(
        (
            SELECT '||'+qqe.Token  AS [text()]
            FROM QNN_QNN_ENTITY qqe
            WHERE qqe.QnnId = q.Id
            ORDER BY qqe.[Language]
            FOR XML PATH ('')
        ), 3, 1000) [Tokens], 

SUBSTRING(
		(
				SELECT '||'+qqe.[Language]  AS [text()]
				FROM QNN_QNN_ENTITY qqe
				WHERE qqe.QnnId = q.Id
				ORDER BY qqe.[Language]
				FOR XML PATH ('')
		), 3, 1000) [OfflineLanguages],

r.Id as RespId, r.DateStart as RespDateStart, d.StructDivisionId,
r.DateComplete as RespDateEnd from QNN_DPLY_SAMPLE_INFO lsi
left join QNN_LIST_SAMPLE ls on lsi.ListSampleId = ls.Id
left join QNN_SAMPLE s on ls.SampleId = s.Id
left join QNN_SAMPLE s1 on ls.SamplePeerId = s1.Id
inner join QNN_DPLY d on lsi.DplyId = d.Id
left join QNN_RESP r on lsi.DplyId = r.DplyId and lsi.ListSampleId = r.ListSampleId and r.QnnId = d.QnnId
left join QNN_QNN q on d.QnnId = q.Id
--left join QNN_QNN_FORM f on f.QnnId = q.Id
left join vSP_DplySampleDueDate due on lsi.DplyId = due.DplyId and lsi.ListSampleId = due.ListSampleId
left join QNN_STATUS qs on qs.Id = lsi.Status
where d.IsDeleted = 0 and d.Status = 1

GO
---------------------
UPDATE TOP(1) [SIMSProduction].[dbo].[dwMetadata] SET [Id]='6518A592-09CD-4B6F-8235-DEEEBB8B81CF', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.290', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-14 22:02:20.000', [Data]=N'{
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

    }

}', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='6518A592-09CD-4B6F-8235-DEEEBB8B81CF');

GO

---------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.340', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-13 11:12:27.703', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2020-04-13T11:12:27.7042749+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"Status\": 1, \"Target\": \"N\",  \"Type\": \"E\",  \"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": " {\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyListSampleAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyMessageAsync"
    }
  ],
  "dataMap": [
    {
      "id": "49dc498b-862f-8db6-c96b-436359c1fe8f",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "control": "dictCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09c51019-6736-b903-ba90-49c6648aed13",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "control": "radioCompletionAction",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "000c5d4f-1fd1-8038-2591-0d619c11d8ee",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "control": "textCompleteURL",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2438929-3329-c80c-347b-9da9c989eff3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9dec37ab-922a-3546-4a78-d6b6dbfbf2a9",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3da35281-aa29-eddf-9e7b-286819c16b08",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "control": "DateEnd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa74d157-9a98-478e-d389-68f6e93d0118",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "control": "DateStart",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b3dfd15-2fbb-ba91-0671-7a9e60427bc3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bdf7e66-15d8-b585-644a-c8ab8460baba",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c1b23718-7f5e-a000-e54d-d928be553567",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1fddbcc0-83cb-119d-8e03-374668bb8854",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "319c8862-be47-1e69-a018-f83506cfa587",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "textName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "97cf1d53-28c5-46a1-0570-4988a6104d89",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce20b9d-22e3-cdc0-5b10-313082777c45",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2636b43a-a3ea-062a-574f-85d081788a96",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3190228d-0386-0414-b011-49465dd5116f",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d61f2305-3c49-14f0-6874-50ec12c9ce67",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09a1c46f-5fa4-537b-0d2c-25485bd76070",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e30afa8-b7b8-876c-4373-81d1d7060dc7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bf95ec-8916-105b-2c75-aae713335918",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "control": "DaysUpdate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d067751-8f32-8b30-efae-13ca8d1128f7",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "control": "dictList",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15c4e305-59f8-430d-e37b-fddc34f0480b",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "control": "MaxResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9f046ca8-9da9-3947-464b-7b854ef030bd",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f16cb492-4407-54c3-d6b7-c7e2d65135c2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "control": "dictQuestionnaire",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "548a8469-7142-e4f2-83f4-ac0fcbc365f4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "control": "radioNavBack",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e736758a-1122-7948-e429-0308aa9d6fb1",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "control": "textNavCancelUrl",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72f8e742-b794-320f-5dca-aea702eff73e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "control": "radioNavCancel",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8cc321aa-0522-d13a-b458-8a1398b903dd",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ff5bbc4-a456-559e-c4a0-97641498a8ad",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d83ffc30-3bdf-e7ea-b4c9-1558ca68fe64",
      "attributeId": "61efc3ab-da8f-4f99-9a25-e8def3b07d04",
      "control": "IpCountry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fa8de95a-5658-8c71-52fa-22895c42574e",
      "attributeId": "387717a8-f539-4041-83aa-ef01ba86d3cf",
      "control": "RestrictIp",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5149b114-140f-a6c8-5fa5-cc0226199856",
      "attributeId": "1fa1d233-e032-4358-a362-f4195dabcab4",
      "control": "IpRange",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ee6480d-c110-2dd8-2a3a-fe6ddfd7c775",
      "attributeId": "3bf4fa0d-e6b8-42cd-b2a9-db55fe71694c",
      "control": "RestrictIpInclusive",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='98FD848F-DF55-4E5A-BBC5-5919F423A1CD');
GO

---------------------------------------
UPDATE TOP(1) [SIMSProduction].[dbo].[dwMetadata] SET [Id]='655275CF-8202-4438-B66B-874EAB315889', [Folder]=N'metadata/forms', [Filename]=N'QNN_DPLY.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:21.393', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-14 16:12:27.000', [Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "container_7",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left"
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_13",
        "data-buildertype": "container",
        "children": [
          {
            "key": "importModal",
            "data-buildertype": "swzmodal",
            "style-source": "float: right;",
            "secondary": true,
            "content": "Import Response",
            "style-display": "none",
            "children": [
              {
                "key": "form_1",
                "data-buildertype": "form",
                "children": [
                  {
                    "key": "header_3",
                    "data-buildertype": "header",
                    "content": "Import Response",
                    "size": "medium",
                    "events": {},
                    "other-visibleConition": ""
                  },
                  {
                    "key": "listFile",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "file",
                    "style-marginTop": "10px"
                  },
                  {
                    "key": "totalRows",
                    "data-buildertype": "header",
                    "content": "Total rows: {totalRows}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalRows!= null && data.totalRows!= undefined)"
                  },
                  {
                    "key": "totalSampleResponseAdded",
                    "data-buildertype": "header",
                    "content": "Rows added: {totalSampleResponseAdded}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalSampleResponseAdded!= null && data.totalSampleResponseAdded!= undefined)"
                  },
                  {
                    "key": "totalSampleNoResponse",
                    "data-buildertype": "header",
                    "content": "Rows not added (No response): {totalSampleNoResponse}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                  },
                  {
                    "key": "totalInvalidUIDs",
                    "data-buildertype": "header",
                    "content": "Rows not added (Invalid UID): {totalInvalidUIDs}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                  },
                  {
                    "key": "totalInvalidQnnColumns",
                    "data-buildertype": "header",
                    "content": "Total invalid columns: {totalInvalidQnnColumns}",
                    "size": "small",
                    "events": {},
                    "other-visibleConition": "(data.totalInvalidQnnColumns!= null && data.totalInvalidQnnColumns!= undefined)"
                  },
                  {
                    "key": "moreModal",
                    "data-buildertype": "swzmodal",
                    "style-source": "",
                    "secondary": true,
                    "content": "More information",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "form_2",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "form_2",
                            "data-buildertype": "form",
                            "children": [
                              {
                                "key": "container_13",
                                "data-buildertype": "container",
                                "style-float": "right",
                                "children": [
                                  {
                                    "key": "invalidQnnColumns",
                                    "data-buildertype": "header",
                                    "content": "Invalid columns:  {totalInvalidQnnColumns}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_1",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidColumns"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                  },
                                  {
                                    "key": "invalidUIDs",
                                    "data-buildertype": "header",
                                    "content": "Invalid rows (UID): {totalInvalidRows}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_2",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidUIDs"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                  },
                                  {
                                    "key": "totalInvalidDates_Updated",
                                    "data-buildertype": "header",
                                    "content": "Total invalid date start and complete: {totalInvalidDates_Updated}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "(data.totalInvalidDates_Updated!= undefined && data.totalInvalidDates_Updated.length > 0)",
                                    "style-hidden": true
                                  },
                                  {
                                    "key": "invalidDates_Updated",
                                    "data-buildertype": "header",
                                    "content": "Invalid date start and complete : {totalInvalidDates_Updated}",
                                    "size": "small",
                                    "events": {},
                                    "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                  },
                                  {
                                    "key": "breadcrumb_3",
                                    "data-buildertype": "breadcrumb",
                                    "items": [
                                      {
                                        "text": "Download",
                                        "url": ""
                                      }
                                    ],
                                    "events": {
                                      "onItemClick": {
                                        "active": true,
                                        "actions": [
                                          "downloadInvalidDates"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                  },
                                  {
                                    "key": "button_1",
                                    "data-buildertype": "button",
                                    "content": "Cancel",
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
                                          "closeMoreModal"
                                        ],
                                        "targets": [],
                                        "parameters": []
                                      }
                                    },
                                    "other-visibleConition": "",
                                    "style-source": "float: right;",
                                    "inverted": false,
                                    "secondary": true
                                  }
                                ],
                                "style-marginRight": "",
                                "style-width": "100%",
                                "style-marginBottom": "",
                                "style-source": ""
                              }
                            ],
                            "style-source": "overflow-y: auto;\noverflow-x: auto;"
                          }
                        ],
                        "style-source": "overflow-y: auto;\noverflow-x: auto;"
                      }
                    ],
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-customValidation": "",
                    "other-visibleConition": "(data.invalidUIDs != null && data.invalidUIDs != undefined)"
                  },
                  {
                    "key": "container_17",
                    "data-buildertype": "container"
                  },
                  {
                    "key": "container_7",
                    "data-buildertype": "container",
                    "style-float": "right",
                    "children": [
                      {
                        "key": "btnImportCancel",
                        "data-buildertype": "button",
                        "content": "Cancel",
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
                        "other-visibleConition": "",
                        "style-source": "float: right;",
                        "inverted": false,
                        "secondary": true
                      },
                      {
                        "key": "btnImportSave",
                        "data-buildertype": "button",
                        "content": "Save",
                        "style-customcss": "",
                        "primary": true,
                        "events-onClick": true,
                        "events-onClick-actions": [
                          "gridAdd"
                        ],
                        "events": {
                          "onClick": {
                            "active": true,
                            "actions": [
                              "submitFile"
                            ],
                            "targets": [],
                            "parameters": []
                          }
                        },
                        "other-visibleConition": "",
                        "style-source": "float: right;"
                      }
                    ],
                    "style-marginRight": "",
                    "style-width": "100%",
                    "style-marginBottom": "10px"
                  }
                ],
                "style-source": "overflow-y: auto;\noverflow-x: auto;"
              }
            ],
            "size": "",
            "events": {
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "other-visibleConition": "data.Id!=null",
            "style-marginLeft": ""
          }
        ],
        "style-float": "right",
        "style-marginLeft": ""
      },
      {
        "key": "container_8",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonManageMessageHistory",
            "data-buildertype": "button",
            "content": "Manage Message History",
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirectToForm"
                ],
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyMessages"
                  }
                ]
              }
            },
            "floated": "right"
          },
          {
            "key": "buttonManageListSamples",
            "data-buildertype": "button",
            "content": "Manage List Samples",
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "redirectToForm"
                ],
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyListSample"
                  }
                ]
              }
            },
            "floated": "right"
          }
        ],
        "style-float": "right",
        "style-marginLeft": "",
        "style-marginRight": "3.5px"
      },
      {
        "key": "container_12",
        "data-buildertype": "container",
        "children": [
          {
            "key": "buttonManageDataEditors",
            "data-buildertype": "button",
            "content": "Manage Data Editors",
            "events": {
              "onClick": {
                "actions": [
                  "redirectToForm"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplySampleOwner"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "data.Id!=null",
            "floated": "right"
          },
          {
            "key": "buttonManageImputation",
            "data-buildertype": "button",
            "content": "Manage Imputation",
            "events": {
              "onClick": {
                "actions": [
                  "redirectToForm"
                ],
                "active": true,
                "targets": [],
                "parameters": [
                  {
                    "name": "formName",
                    "value": "dplyImputation"
                  }
                ]
              }
            },
            "secondary": true,
            "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''Imputation'')",
            "floated": "right"
          }
        ],
        "style-float": "right",
        "style-width": "100%",
        "style-marginTop": "15px"
      }
    ],
    "style-width": "100%",
    "style-float": "right"
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
            "key": "headerBasicProperties",
            "data-buildertype": "header",
            "content": "Basic Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "textName",
                "data-buildertype": "input",
                "label": "Name",
                "fluid": true,
                "onChangeTimeout": 200,
                "other-customValidation": "",
                "other-required": true,
                "events": {}
              },
              {
                "key": "dictCategory",
                "data-buildertype": "dictionary",
                "label": "Category",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_CATEGORY",
                "placeholder": "Select category...",
                "columns": "Name ASC",
                "search": true,
                "other-required": false,
                "other-readOnlyConition": "",
                "clearable": true,
                "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
              },
              {
                "key": "dictQuestionnaire",
                "data-buildertype": "dictionary",
                "label": "Questionnaire",
                "fluid": true,
                "selection": true,
                "search": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "dropdownQuestionnaireOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "onChangeTimeout": "",
                "dataModel": "QNN_QNN",
                "columns": "Title ASC",
                "placeholder": "Select a questionnaire...",
                "other-required": true,
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:false",
                "other-readOnlyConition": ""
              },
              {
                "key": "dictList",
                "data-buildertype": "dictionary",
                "label": "List",
                "fluid": true,
                "selection": true,
                "dataModel": "QNN_LIST",
                "columns": "Name ASC",
                "search": true,
                "events": {},
                "placeholder": "Select a list...",
                "other-required": true,
                "style-source": "",
                "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:false",
                "other-readOnlyConition": ""
              }
            ]
          },
          {
            "key": "container_5",
            "data-buildertype": "container",
            "events": {},
            "style-source": "clear:both;"
          },
          {
            "key": "formGroupStartEndDate",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "DateStart",
                "data-buildertype": "input",
                "label": "Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "z-index: 1000;",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": true
              },
              {
                "key": "DateEnd",
                "data-buildertype": "input",
                "label": "End On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "other-readOnlyConition": "",
                "other-required": true,
                "style-source": "z-index: 1000;"
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "formgroup_5",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "VisibleToRespondent",
                "data-buildertype": "checkbox",
                "label": "Visible to Respondent",
                "defaultValue": "True",
                "toggle": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium",
            "style-hidden": true
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "radioCompletionAction",
                "data-buildertype": "radiogroup",
                "label": "Action",
                "data-elements": [
                  {
                    "key": 1,
                    "value": "C",
                    "text": "Do nothing"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Redirect to URL"
                  }
                ],
                "direction": "v",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "radioCompletionActionOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "C"
              },
              {
                "key": "textCompleteURL",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ],
            "style-hidden": true
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "hedderNavigationProperties",
                "data-buildertype": "header",
                "content": "Navigation Properties",
                "size": "medium"
              },
              {
                "key": "fromGroupNavigationProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "radioNavBack",
                    "data-buildertype": "radiogroup",
                    "label": "Back Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "0",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "1",
                        "text": "Show"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavBackOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "8px",
                    "defaultValue": "0"
                  },
                  {
                    "key": "radioNavCancel",
                    "data-buildertype": "radiogroup",
                    "label": "Cancel Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "N",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "Y",
                        "text": "Show"
                      },
                      {
                        "key": 3,
                        "value": "YURL",
                        "text": "Show and redirect to URL"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavCancelOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "defaultValue": "N"
                  },
                  {
                    "key": "textNavCancelUrl",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "size": "",
                    "placeholder": "Specify redirect url (http://www.google.com)",
                    "style-marginLeft": "24px",
                    "events": {},
                    "other-visibleConition": "data.radioNavCancel == ''YURL'' ? true : false"
                  }
                ]
              }
            ],
            "style-hidden": true
          },
          {
            "key": "headerResponseProperties",
            "data-buildertype": "header",
            "content": "Response Properties",
            "size": "medium"
          },
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "custom",
            "widthsCustom": "2",
            "children": [
              {
                "key": "MaxResponse",
                "data-buildertype": "input",
                "label": "Maximum Number of Responses",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "events": {},
                "defaultValue": "-1"
              },
              {
                "key": "DaysUpdate",
                "data-buildertype": "input",
                "label": "Days for Update",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "number",
                "defaultValue": "0",
                "events": {}
              }
            ]
          },
          {
            "key": "container_3",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "cbMailMerge",
                    "data-buildertype": "checkbox",
                    "label": "Mail Merge",
                    "slider": true,
                    "toggle": true,
                    "style-marginRight": "20px",
                    "defaultValue": ""
                  },
                  {
                    "key": "cbEmail",
                    "data-buildertype": "checkbox",
                    "label": "Email",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": ""
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": ""
                  },
                  {
                    "key": "breadcrumb_4",
                    "data-buildertype": "breadcrumb",
                    "items": [
                      {
                        "text": "Download Template",
                        "active": false
                      }
                    ],
                    "events": {
                      "onItemClick": {
                        "active": true,
                        "actions": [
                          "downloadEmailTemplate"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-width": "100%",
                    "style-source": "padding-top: 20px;"
                  }
                ]
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "emailFrom",
                    "data-buildertype": "input",
                    "label": "From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "parseHtml"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px"
          }
        ]
      }
    ],
    "style-float": "left",
    "style-width": "100%"
  },
  {
    "key": "container_18",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_5",
        "data-buildertype": "header",
        "content": "Restriction Properties",
        "size": "medium",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "RestrictIp",
        "data-buildertype": "checkbox",
        "label": "Ip Restriction",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "setIpRestriction"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "reference": "Ip Restriction",
        "style-marginBottom": "20px",
        "defaultValue": "0"
      },
      {
        "key": "RestrictIpInclusive",
        "data-buildertype": "radiogroup",
        "label": "",
        "data-elements": [
          {
            "text": "Inclusive",
            "value": "1"
          },
          {
            "value": "0",
            "text": "Exclusive"
          }
        ],
        "defaultValue": "1",
        "other-visibleConition": "data.RestrictIp==1",
        "events": {
          "onChange": {
            "active": false,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "countryOrIpRange",
        "data-buildertype": "radiogroup",
        "label": "",
        "data-elements": [
          {
            "text": "Countries",
            "value": "1"
          },
          {
            "text": "IP Ranges",
            "value": "0"
          }
        ],
        "defaultValue": "1",
        "other-visibleConition": "data.RestrictIp==1",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "clearContent"
            ],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "IpCountry",
        "data-buildertype": "dropdown",
        "label": "IpCountry",
        "fluid": true,
        "selection": true,
        "data-elements": [
          {
            "key": 1,
            "value": "SG",
            "text": "Singapore"
          },
          {
            "value": "MY",
            "text": "Malaysia"
          }
        ],
        "multiple": true,
        "reference": "Respondent Country",
        "placeholder": "Select countries",
        "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange==1)",
        "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==1 && data.IpCountry && data.IpCountry!=\"[]\") || (data.countryOrIpRange==0))) || (data.RestrictIp!=1))?true:\"is required\"",
        "events": {}
      },
      {
        "key": "IpRange",
        "data-buildertype": "dropdown",
        "label": "",
        "fluid": true,
        "selection": true,
        "data-elements": [],
        "multiple": true,
        "search": true,
        "allowAddItems": true,
        "reference": "Ip Ranges",
        "placeholder": "192.168.0.0/24 or 192.168.0.0/255.255.255.0 or 192.168.0.0-192.168.0.255",
        "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==0 && data.IpRange && data.IpRange!=\"[]\") || (data.countryOrIpRange==1))) || (data.RestrictIp!=1) )?true:\"is required\"",
        "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange!=1)",
        "events": {
          "onChange": {
            "active": true,
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
        "key": "container_16",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px",
        "children": []
      },
      {
        "key": "header_4",
        "data-buildertype": "header",
        "content": "Report Properties",
        "size": "medium",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "chkScheduler",
        "data-buildertype": "checkbox",
        "label": "Save Snap Shot Daily",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "container_9",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "dailySsForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlEmailReceipients",
            "data-buildertype": "dictionary",
            "label": "Email Recipient/s",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_dataEditors",
            "columns": "Name ASC",
            "clearable": true,
            "multiple": true,
            "events": {},
            "style-marginTop": "",
            "style-marginBottom": "",
            "other-visibleConition": "",
            "paging": true,
            "search": true
          },
          {
            "key": "container_15",
            "data-buildertype": "container",
            "style-marginTop": "30px",
            "style-marginBottom": "30px"
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "chkEmailSuccess",
                "data-buildertype": "checkbox",
                "label": "Email Success",
                "toggle": true
              },
              {
                "key": "chkEmailFail",
                "data-buildertype": "checkbox",
                "label": "Email Fail",
                "toggle": true
              }
            ],
            "style-marginTop": "30px",
            "style-marginBottom": "30px",
            "orientation": "inline"
          }
        ],
        "other-visibleConition": "(data.chkScheduler != null && data.chkScheduler != 0 ? true: false)",
        "events": {},
        "other-customValidation": "",
        "other-readOnlyConition": ""
      }
    ],
    "other-visibleConition": "data.Id != null",
    "style-marginTop": "30px",
    "style-marginBottom": "30px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Save",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "onClickSave",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": ""
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Cancel",
        "events": {
          "onClick": {
            "actions": [
              "goBack"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px",
    "style-marginTop": "30px"
  }
]', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='655275CF-8202-4438-B66B-874EAB315889');

GO

---------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='4D440057-891C-4FE7-AA60-47B67638B311', [Folder]=N'metadata/forms', [Filename]=N'SwzDplyList-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:25.280', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-10 11:05:51.893', [Data]=N'{
     init: function (args) {
        var innerArgs = args;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[model.columns.length-2].customFormatter = function (p) {
                    
                    //return CloverApp.API.createElement(''input'',{type: ''checkbox'', className: ''ui checkbox'', id: p.row.Id, defaultChecked: p.row.Status, onChange: () => showModal(innerArgs, p.row.Id)});
                    var url = "/deployment/download/resp/" + p.row.Id + "/" + p.row.QnnId;
                    if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
                    return CloverApp.API.createElement("a", {href: url, target: "_blank", onClick: (e)=>{e.stopPropagation()}}, p.row.RespCount + " / " + p.row.SampleCount);
                    //return CloverApp.API.createElement("a", {href: url}, "Export");  
                };
                model.columns[model.columns.length-1].customFormatter = function (p) {
                    //return CloverApp.API.createElement("div", {}, p.row.RespCount + " / " + p.row.SampleCount); 
                    if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
                    return CloverApp.API.createElement("span", {onClick: ()=> swzdplylistUserActions.scheduleZipFileDownload(p.row.Id), className: ''link-style''}, ''Download Zip''); 
                };                

            }
            return model;
        };

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

    },
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
    }

}
', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='4D440057-891C-4FE7-AA60-47B67638B311');
GO
---------------------------------------------

UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='7479ADC7-5164-48A5-B4C6-2EB01ECA68DF', [Folder]=N'metadata/forms', [Filename]=N'respdashboard-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:23.760', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-03 12:40:24.760', [Data]=N'{

    init: function(args){

        var innerArgs = args;            
            var url = ''/swzdata/getmultiple?type=RespDashboard'';
               
            var gridModelRewriter = function (model) {
                if (Array.isArray(model.columns)) {
                    model.columns[1].customFormatter = function (p) {
                        if(p.row.Type=="Offline"){
                            
                            var strTokens = p.row.Tokens;
                            var strOfflineLanguages = p.row.OfflineLanguages;
                            var tokens = strTokens.split(''||'');
                            var offlineLanguages = strOfflineLanguages.split(''||'');      
                            var elements = [];
    
                            tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));                            
                            return CloverApp.API.createElement("div", {}, elements);
                            
                            //return CloverApp.API.createElement("a", { href: url}, p.value); 
                        }
                        else if(p.row.Type=="Online"){
                            
                            var strFormNames = p.row.FormNames;
                            var strLanguages = p.row.Languages;
                            var formNames = strFormNames.split(''||'');
                            var languages = strLanguages.split(''||'');      
                            var elements = [];
    
                            formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                            return CloverApp.API.createElement("div", {}, elements);                            
                            
                        }
                        else{
                            return CloverApp.API.createElement("div", {}, p.value); 
                        }
                    };
                    
                    //model.columns[model.columns.length-1].customFormatter = function (p) {
                    //    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    //    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Get Password");
                    //};               
                    
                }
                return model;
            };
            
            var gridviewModelRewriter = function (model) {
                if (Array.isArray(model.columns)) {
                    model.columns[1].customFormatter = function (p) {
                        if(p.row.Type=="Offline"){
                            var strTokens = p.row.Tokens;
                            var strOfflineLanguages = p.row.OfflineLanguages;
                            var tokens = strTokens.split(''||'');
                            var offlineLanguages = strOfflineLanguages.split(''||'');      
                            var elements = [];
    
                            tokens.forEach(genOfflineFormLinkButtons.bind(null, p, elements, offlineLanguages));                            
                            return CloverApp.API.createElement("div", {}, elements);
                            
                            //return CloverApp.API.createElement("a", { href: url}, p.value); 
                        }
                        else if(p.row.Type=="Online"){
                            var strFormNames = p.row.FormNames;
                            var strLanguages = p.row.Languages;
                            var formNames = strFormNames.split(''||'');
                            var languages = strLanguages.split(''||'');      
                            var elements = [];
    
                            formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                            return CloverApp.API.createElement("div", {}, elements);  
                        }
                        else{
                            return CloverApp.API.createElement("div", {}, p.value); 
                        }
                    };
                    
                    //model.columns[model.columns.length-1].customFormatter = function (p) {
                    //    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    //    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Get Password");
                    //};                  
                    
                }
                return model;
            };      
            

            
           /* var genFormLinks = function(p, elements, languages, value, index){
                var linkUrl = ''/form/'' + value + "/?dlsi=" + p.row.Id;
                var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);
                elements.push(element);
                element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                elements.push(element);
            };*/
            var genOfflineFormLinks = function(p, elements, languages, value, index){
                var linkUrl = "/respondent/download/survey/" + p.row.Id + "/"  + value + "/" + p.row.RespId;
                var element = (p.row.IpAllowed || p.row.IpAllowed==undefined)?
                CloverApp.API.createElement("a", { href: linkUrl}, languages[index]):
                CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
                elements.push(element);
                element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                elements.push(element);
            };    
            
            var genFormLinkButtons = function(p, elements, languages, value, index){
                var linkUrl = ''/form/'' + value + "/dlsi/" + p.row.Id;
                var element = (p.row.IpAllowed || p.row.IpAllowed==undefined)?
                CloverApp.API.createElement("span", { onClick: () =>  {
                    CloverApp.API.redirect(''form'', value, ''dlsi/''+ p.row.Id)
                }, className: "link-style" }, languages[index]):
                CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
                elements.push(element);
                element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                elements.push(element);
            };           
            
            var showModal = function (args, id) {
                return getPasswordAsync(args, id);
            }; 
            
            var getPasswordAsync = function (args, id) {
                var formData = new FormData();
                formData.append(''id'', id);
                var url = ''/respondent/getpassword'';
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
                            //console.log("getPasswordAsync args", args);
                            args.controlRef.refs.passwordModal.openModal();
                            args.component.state.data.password = response.item;
                            args.component.refs.password.forceUpdate();
                            //console.log(''response.item'', response.item);
    
                        } else {
                            alertify.error(response.message);
                        }
                    })
                    .catch(error => {
                        alertify.error(error.message);;
                    });
    
    
            };        
            
            
            $.get(url).done(function (data) {
            if(data.success){
                
                var htmlData = [];
                for (var i=0; i<data.data.length; i++){
                            htmlData.push(data.data[i].editorState);
                }
                CloverApp.API.setDataField("respDashboardHtmlView", htmlData);
            }
            else
              console.log(data.message);
            }).fail(function (jqxhr, textStatus, error) {
             console.log(textStatus);
            }); 
            
            CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
            CloverApp.API.rewriteControlModel("gridview", gridviewModelRewriter);

            $(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
            
            //args.component.refs.grid.refresh();
            //args.component.refs.gridview.refresh();
        
    },
    
    closeModal: function (args) {

        args.component.refs.passwordModal.close();
        return {
        };

    }
    
    
}', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='7479ADC7-5164-48A5-B4C6-2EB01ECA68DF');
GO

---------------------------------------
UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='50A76E5A-98F3-44BF-A161-003ED4FB2F3B', [Folder]=N'metadata/forms', [Filename]=N'respdashboard-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:23.807', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-01 15:28:06.527', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "respdashboard",
  "lastUpdate": "2020-04-01T15:28:06.4314608+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "ee290857-7d9d-2279-3c90-6a3c7e43dd0a",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{UID:\"@UID\", DplyDateStart: \"<=@NOW\",  DueDate: \">=@NOW\", VisibleToRespondent:1}",
      "control": "grid",
      "dataMap": [
        {
          "id": "2c47907c-aa19-c201-7f1a-77167860f312",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "11f589c2-05e7-2a32-4f4d-83d960dd0cb0",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7edf9385-6e02-d115-762c-6d9038638568",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4f0f5962-1b59-4f87-3e5e-8f19ff902409",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "62a46b8a-ed2e-102c-0d63-fdd8df24eb2d",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8201ffea-ece8-038b-2683-d46c77a1e46a",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2d07c7bd-e02e-f4a9-f60e-b70e78a365bc",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f79ce41-b73e-07dd-aeeb-1d1ed251ae16",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "cab04562-b8cf-e61d-ef4d-2f544cb78c8c",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "469d27b4-e0a8-801a-68f2-c0ec0e6e14af",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2d965334-15f2-516a-58cb-48b7266dc7db",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "33eb2bce-b538-0b44-bc3b-89d2a40b1626",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "400c511d-a24d-9e60-3289-661ec1eb146d",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "85c7647c-34e0-9d3d-f170-8ca1c21c2ea4",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "dd39aaea-5157-30c7-10f1-50422bcf6c5a",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "830f8133-1268-1ef3-1d63-48893663ee7f",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b1b5eee2-7dec-78a8-84a1-3d1e8463c037",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b451aea9-e6dc-6878-055e-f3c676195b00",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6526b948-f332-8273-f664-f6165eda3ad9",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "36f01f84-926d-0f56-311f-3451f1e72c26",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "fc0bc8bb-66aa-37a8-9e6a-91aad3236606",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "81fbcb41-92f7-41c1-bf35-d531fff38728",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "896558f3-b726-1e96-e083-240b213b330a",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "98b48d4c-dd53-eea5-e575-d226c7d5d25b",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eef8657b-fa91-32db-74f6-068e49a403e1",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "209f2db1-f603-2676-ef4d-5c70cc1618b1",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "affee0d0-4f89-dd9c-9b00-1c5153082017",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3348cfe2-b3dc-5331-8190-525139fd2044",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ad46c62d-32cb-4905-1b11-5293ef6b14e8",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6313f004-9086-c0a1-99b6-eeb4469db504",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9934ce50-5b90-f388-905c-8ce429967485",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7663a9cc-e912-b849-1e35-e3199a22e89f",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20033a00-e7b0-095e-2339-a38e54fca73c",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "91ea6eb6-f90c-76d3-6708-c139b659960a",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9707b198-3172-3e85-04e9-1afc89366b9e",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4c078237-080a-ceb8-5ffb-9bb0f7b36143",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b8b84c38-eadc-47b3-df63-181d60180d35",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2df64e6f-678c-ddbc-d0e3-ec0f53000a99",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "10f14e69-604d-0ec6-fada-bf8582881d22",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c4adbd26-9c00-45ad-f447-ffa3f90f0e91",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b68abba1-547f-4aac-21bd-fd15b192ea14",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "db3afac5-e792-1271-f5d6-d038827907df",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7fbba967-0ec3-ddc9-fd57-0d85e303cf22",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b61c0453-2747-a283-14b7-02b768b6ee60",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b90ae358-c136-d958-b7dd-2ddcbc68668e",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "86fc073f-f004-b6bc-de5b-6903197bbe19",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2eec3fab-3af8-23b0-cb71-47376426f0dc",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "96e09b14-03ee-ff2e-1992-596a83a6da5c",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "64aec786-6856-56b9-c67e-ff5d6cfd21d7",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ee45e436-4b34-06f0-b133-afeb339aa0ee",
          "attributeId": "f1d308cf-3049-4b01-b505-bec0a993aefb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "023a1366-b16d-1e0c-1271-e9e5e5f4a496",
          "attributeId": "3ec7960b-65ce-4e38-a537-81383a504d01",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "22b32dff-3c22-8c4d-52ba-62cb881e5427",
          "attributeId": "995def99-93f3-4266-abd1-689e4425c20b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d2dfb0a-4372-ad06-b0b3-135a27c6720e",
          "attributeId": "f247c9e7-f683-44a3-80fc-9e8c4a81d2ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f8b1c46a-973d-1d02-b731-db9f01760088",
          "attributeId": "6ff3e509-5319-47ab-9891-3b53da36e395",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    },
    {
      "id": "fc1769be-53f6-2708-3c8b-9ce8fe01560b",
      "entityId": "edbdfede-d121-45a3-b291-77c85f18e4dd",
      "filter": "DplySampleAsyncFilter",
      "parameter": "{UID:\"@UID\",  DueDate:\"<=@NOW\", VisibleToRespondent:1}",
      "control": "gridview",
      "dataMap": [
        {
          "id": "37b3d171-4289-902e-37e1-0269e02f630d",
          "attributeId": "fb1995a9-d5b0-41b0-8bba-de1f198a2ade",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "254c1313-aefa-a548-e7c5-979c0058575c",
          "attributeId": "9708f58f-4391-4f2d-8ce5-3e3f705e0567",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7ad4ab55-275b-7968-fc66-5291f6de6720",
          "attributeId": "05aca3b9-1ff1-4224-af56-e1e7b40d2ea7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3c2a4fb2-96d0-7bfa-301e-d46dab52a0f4",
          "attributeId": "4a05dc25-64a0-4bc1-ab63-cd8eb47388cc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "35def3d8-e33e-3ce6-060a-43e77dce53ed",
          "attributeId": "ba2edc74-4779-4dfa-b077-6171c7e5728a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e6064b5e-2817-a7ba-68b3-8a5736158722",
          "attributeId": "fed57935-d235-4978-8e32-740704d0a4e6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2e8ae1ab-f1ea-365c-99e0-2004fc185efd",
          "attributeId": "0cbfca89-19a5-42af-85e5-a2924c73965b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f25c06b0-74cd-6a5c-814a-bfa259682bd5",
          "attributeId": "0406153b-14c8-40fa-9c0f-8da423c1bf9c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2305c962-2497-d015-4507-201247932839",
          "attributeId": "87142dff-3c44-4b2e-adf3-dbe6902929e3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "33d9f7ef-f80e-4407-2aa9-b373ec98b753",
          "attributeId": "eaf65e44-d8b3-41e2-8ea3-7fa371c24df7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5e36f79f-39f7-b5ea-6e45-b8af274f9d22",
          "attributeId": "3742bb4c-1d36-43e9-91ca-7c9b06a7a387",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1ffbae71-fa5c-fb47-6b17-e1e740102066",
          "attributeId": "25fb86e0-cd5c-4827-bb81-b95c606c76a2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "476ec478-a554-ce99-8a3e-83101096b023",
          "attributeId": "1778d9cd-e976-41a5-94d0-f58118650e78",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6db04129-2b60-5418-1674-d9f0a04b2e33",
          "attributeId": "934eb22d-26ab-46df-affb-34b9ca4279bd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f2453f4-cb18-514f-5279-50c07678e91a",
          "attributeId": "da266418-6f9d-49c6-8cd0-b848b7b1865d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c646ae36-9a34-c827-e6f2-361396f7f547",
          "attributeId": "fae8d036-d2f9-4122-9788-5a836fde5f14",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "362a62db-25f4-cf72-17bd-3f5cae1dbc31",
          "attributeId": "d8c56aaa-a66c-4c11-885b-63b48132a4ae",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6de5ff64-e223-1dfe-1ff2-ba678b13871c",
          "attributeId": "b78e3a71-0a01-4252-9f6d-dedcd79b7a4a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "67518526-7a96-53dc-c1dc-faeab93a61ef",
          "attributeId": "79e48f5b-600c-4e8f-93e2-3cba618395df",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8bbfb419-eb74-665a-9aa2-6f8aec037c49",
          "attributeId": "628f5950-57f7-4bff-a55e-387c81d3e3ca",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "98cb492f-ebb7-6338-d011-03707bb09bf4",
          "attributeId": "bce4dc52-69b3-4f24-8085-76201ed4b669",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aad9a577-ebbe-7e60-c296-c60f537c7139",
          "attributeId": "1a3f9d0d-db31-4d8c-a2d8-2667ff9fd2a3",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1dc591b5-ea15-374a-eb3c-19a6833a2301",
          "attributeId": "26c17cdf-0e95-42bb-945a-9cc3fea7d591",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "affa5a82-9586-68c4-93f0-bd56cbab9f4c",
          "attributeId": "64ec9ca0-1500-4533-8754-59ebff95a686",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1150e8fe-b6f3-bf7d-75b7-0c9928f50bb3",
          "attributeId": "dda35caf-327b-47f8-91ee-106063c882d4",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1989f42a-fb33-8407-1a72-4647e31140d3",
          "attributeId": "c7c38d0a-36b8-4de5-ae08-96b66d3b9181",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "16fb7e95-be61-3385-1120-6c1361d9dd64",
          "attributeId": "118adb3e-82fd-4fca-aa90-6d282910ed7c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ad39f718-b0a1-84a4-b403-cd09b8087cd4",
          "attributeId": "394be317-66d0-4ab6-81d7-98d2f10beb29",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2039d889-95e9-6360-9ff4-87a7d72b7abb",
          "attributeId": "74097b74-c031-4848-af9c-c3e58c34e232",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7489d5b6-6874-8408-17a9-5eb636b480e2",
          "attributeId": "91423d5e-f275-4f21-ab84-7a9d5d46db97",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "bdec1b8e-a3a3-72c1-e1db-7f1e40576143",
          "attributeId": "94071c82-1934-4dcd-aeb4-d43a67baf751",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8ddecb24-8dcc-d45b-e579-24c957403576",
          "attributeId": "762c021b-e51e-41d9-b041-050e239514a6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "01fb9843-6d3f-768e-67d9-7c704abbf912",
          "attributeId": "a1df9b41-0552-444b-afc4-853c61a4df92",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6ebce0fa-b0e1-d2ff-13c7-1cbe70a59bf8",
          "attributeId": "9aca7958-c280-41a7-a3c2-97cc64a4c0d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "850c96b1-0b9a-4392-0a5c-c3420b308b96",
          "attributeId": "34331077-922d-4518-b1d7-c44f32c7b4d7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b9898766-c9bc-5915-8472-0710b899806c",
          "attributeId": "d9bc0fa8-2830-44ca-98b0-b090b8a4bd43",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "84179341-403c-ca9d-a86c-5432cb72e01b",
          "attributeId": "7d379f52-c607-44ff-82b4-c168d11cbf2c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e9456374-1b25-243b-4b7a-95c251e42f3a",
          "attributeId": "224bbbad-f587-4987-99d5-213d1433a56f",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7b02fe81-8087-7111-1772-417c12e9d46e",
          "attributeId": "6de55289-ed7b-41bc-b92b-699842f92021",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "92832494-78f1-84b2-332e-d329206a9522",
          "attributeId": "ecf63c07-775f-474a-9b1f-2251837b724b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9b178125-dbe8-b52a-2e48-43cc74e1720e",
          "attributeId": "9c821347-256e-4c35-8597-ce5c8a897c91",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d4acb99f-279f-f68b-5b6b-3323e656f78d",
          "attributeId": "b6c47371-3c29-4e79-a364-2f50a8ecdaa6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "32aa7dbc-473e-fab0-80d0-e8498e183ddd",
          "attributeId": "282d8a24-a404-45f5-adee-7d75cf038f5b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d4f03b3-45ff-11a9-230c-45313117fc02",
          "attributeId": "b06863c1-1413-45b2-a3b4-d503a2e203eb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d3de4fb4-6473-14be-c5d9-9f5f6e13f42c",
          "attributeId": "f61b2ba6-ffaf-4a12-9e20-3a12eea2b2d6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "89192b80-4e20-0c04-d193-54f225e727cb",
          "attributeId": "fa13edb9-6903-448c-a613-0e3bdbb1cffd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "eaac75be-1f00-5567-b507-4c996a1f48cd",
          "attributeId": "472c9ac3-a86f-4844-9b0d-5344b6ff8c90",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0bb3beeb-ff41-a2cd-8229-0f5dcec51272",
          "attributeId": "a110fd38-22b6-4212-9dd0-ff44e6971d58",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "69ffd8f9-ed6d-cb73-bce5-c334bc74df5b",
          "attributeId": "0072df17-5baa-460b-8cd6-4e0a63d44ed0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "39b1dcaf-ddf7-48ae-39e9-e72697d94a77",
          "attributeId": "f1d308cf-3049-4b01-b505-bec0a993aefb",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3d1f22bd-9343-15d5-d865-18075503886c",
          "attributeId": "3ec7960b-65ce-4e38-a537-81383a504d01",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60a6c794-16df-ad28-34cb-5da156bf6742",
          "attributeId": "995def99-93f3-4266-abd1-689e4425c20b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6c6aa2bf-b6a4-3398-79d3-b4d7001e0ea4",
          "attributeId": "f247c9e7-f683-44a3-80fc-9e8c4a81d2ad",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "086b49cd-e128-cce4-3e27-cae5d642dd8f",
          "attributeId": "6ff3e509-5319-47ab-9891-3b53da36e395",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ]
}', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='50A76E5A-98F3-44BF-A161-003ED4FB2F3B');
GO
--------------------

-------------------------------------

ALTER TABLE dwSecurityUser
ALTER COLUMN GaSalt varchar(256) NULL