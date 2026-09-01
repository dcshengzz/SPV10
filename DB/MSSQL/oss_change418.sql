-- Will UPDATE existing row(s) in dwMetadata for the following:
-- respdashboard-code.js

UPDATE [dwMetadata] SET
[Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2023-08-11 14:25:04.880', 
[Data]=N'{

    init: function(args){
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi))                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------
        

        const innerArgs = args;            
        const PENDING = "A3D01086-40FC-4A7A-BF0C-DE17BDD205FA".toLowerCase();
        const IN_PROGRESS = "0D67932C-62EA-4CD3-A254-0CC63E742C93".toLowerCase();
        
        const iconBtnClass = "ui icon button large inverted";
        const iconBtnDisabledClass = "ui icon button large disabled";
        const popupProps = { size:''mini'', on:''hover'', position:''top right''};
        const styleInlineBlock = { style:{display:"inline-block"}};
        
        const genFormLink = function (p, elements, languages, formName, index) {
          const isMultipleResponse = !!p.row.IsMultipleResponse;
          const ipIsAllowed = p.row.IpAllowed || p.row.IpAllowed === undefined;
          const quotaReached = p.row.MaxResponse !== -1 && p.row.MaxResponse !== null && 
                               p.row.MaxResponse !== undefined && p.row.MaxResponse !== "" &&
                               p.row.MaxResponse <= p.row.TotalComplete;

          if (ipIsAllowed) {
              
            //Render Form link
            const onClickForm = () => {
              checkAccessCode(innerArgs, p, formName, "form");
            };
            const qnnsBtnClass = quotaReached ? "ui teal basic button disabled" : "ui teal basic button";
            const qnnsBtn = CloverApp.API.createElement(
              "span",
              {
                onClick: onClickForm,
                className: qnnsBtnClass,
                style: { width: "150px", height: "40px", marginTop: "10px" },
              },
              languages[index]
            );

            //Render new response button for multiple response surveys
            if (isMultipleResponse) {
              const status = p.row.Status ? p.row.Status.toLowerCase() : "";
              const isCurrentSurvey = new Date(p.row.DueDate) >= Date.now();
              const sampleResponseInProgress = status === IN_PROGRESS;
        
              const showActionAdd = isCurrentSurvey && sampleResponseInProgress;
              if (showActionAdd) {
                const onClickNew = () => {
                  checkAccessCode(innerArgs, p, formName, "new");
                };
                
            
                const btnText = "Add Response";
                const icon = CloverApp.API.createElement("i", {className: "plus icon",ariaHidden: "true" }, "");
                const addBtn = CloverApp.API.createElement("button", { 
                                onClick: onClickNew  , className: iconBtnClass, style: { color: "green", paddingLeft: "0" }
                            },icon);
                const addBtnPopup = CloverApp.API.createElementWithPopup(btnText,popupProps,addBtn); 
        
                const container = CloverApp.API.createElement(
                  "div",
                  { style: { display: "flex", alignItems: "center" } },
                  [qnnsBtn, addBtnPopup]
                );
                elements.push(container);
              } else {
                elements.push(qnnsBtn);
              }
            } else {
              elements.push(qnnsBtn);
            }
          } else {
            elements.push(
              CloverApp.API.createElement(
                "span",
                { title: "This survey is not available in your region", className: "ui red" },
                languages[index]
              )
            );
          }
        };
        
        const createNewResponseAndOpen = function(dlsi, formName) {
            //nb: this is duplicated in submitAccessCode too
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/respondent/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen

        const promptForAccessCode = function(respId, dlsi, formName, p) {
            CloverApp.API.setDataField("AccessCodeRespId", respId);
            CloverApp.API.setDataField("AccessCodeDlsi", dlsi);
            CloverApp.API.setDataField("AccessCodeFormName", formName);
            CloverApp.API.setDataField("AccessCodeRow", p);
            CloverApp.API.setDataField("AccessCode", "");
            innerArgs.component.refs.accessCodeModal.openModal();
            console.log("promptForAccessCode End");
        };
        
        const promptForUpload = function (){
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        const promptForDownload = function (innerArgs, p){
            const dlsi = p.row.Id;
            const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            const fileLanguages = p.row.FileLanguages.split(''||'');
            const items = [];
            if(Array.isArray(fileLanguages) && fileLanguages.length>0) {
                for(var i = 0 ; i < fileLanguages.length; i++){
                    items.push( {
                        key: i,
                        text: fileLanguages[i],
                        value: i,
                    });
                }

                CloverApp.API.setDataField(''fileRow'', p);
                Utils.rewriteDropdown("fileDropDown",items, undefined);
                CloverApp.API.setDataField("fileDropDown", 0);

            }
            else
            {
                Utils.rewriteDropdown("fileDropDown",null, undefined);
                CloverApp.API.setDataField("fileDropDown", null);
            }
            
            innerArgs.component.refs.fileDownloadModal.openModal();  
        };

        //checks access code with server and proceeds to form, upload, or code prompt accordingly
        const checkAccessCode = function(innerArgs, p, formName, control) {
            try {
                const respId = p.row.RespId;
                const dlsi = p.row.Id;
                CloverApp.API.setDataField("AccessCodeControl", control); //submitAccessCode will use this too
                
                if(control == ''upload''){
                    //this is for upload modal to work
                    const qnnId = p.row.QnnId;
                    const dplyId = p.row.DplyId;
                    const listSampleId = p.row.ListSampleId;
                    //rewrite the FileUploadUrl
                    CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                        model.customPostUrl = "/respondent/uploadexcelresponse?" + new URLSearchParams( { qnnId, dplyId, listSampleId, dlsi } );
                        model.onUploadBegin = () => Utils.loadingStart("Uploading response...");
                        model.onUploadEnd = Utils.loadingStop;
                    });
                    
                    CloverApp.API.setDataField("AccessCodeDlsi", dlsi);
                    CloverApp.API.setDataField("UploadQnnId", p.row.QnnId);
                    CloverApp.API.setDataField("UploadDplyId", p.row.DplyId);
                    CloverApp.API.setDataField("UploadListSampleId", p.row.ListSampleId);
                    CloverApp.API.setDataField("UploadDlsi", dlsi);

                    //create the language option
                    const formNames = p.row.FormNames.split(''||'');
                    const languages = p.row.Languages.split(''||'');
                    CloverApp.API.setDataField("UploadFormNames", formNames);
                    
                    if(Array.isArray(formNames) && formNames.length>0) {
                        const options = [];
                        for(var i=0; i<formNames.length; i++) {
                            options.push( {
                                key: i,
                                value: i,
                                text: languages[i],
                            } );
                        }
                        CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                        CloverApp.API.setDataField("UploadFormChoice", 0);
                    } else {
                        CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                        CloverApp.API.setDataField("UploadFormChoice", null);
                    }
                } //end of if control is upload
                
                const performAction = function() {
                    if(control == ''form''){
                        redirectToSurvey(dlsi, formName, respId);
                    }else if(control == ''upload''){
                        promptForUpload();
                    }else if(control == ''new'') {
                        createNewResponseAndOpen(dlsi, formName);
                    }else if(control == ''print'') {
                        openPrintModal(innerArgs,p);
                    }else if(control == ''download''){
                        promptForDownload(innerArgs,p);
                    }
                };
                
                if(p.row.RequireAccessCode) {
                    Utils.loadingStart("Loading");
                    Utils.getRequest("/respondent/accesscode", { dlsi }).then(
                        result => {
                            const codeVerifiedSuccessfully = result.item.validated;
                            if(codeVerifiedSuccessfully) {
                                performAction();
                            } else {
                                promptForAccessCode(respId, dlsi, formName, p);
                            }
                        }, reason => {
                            alertify.error(response.message);
                            console.log(response);
                        }
                    ).finally(Utils.loadingStop); 
                } else { //if dont require access code
                    performAction();
                }
            } catch(e) {
                console.log("Error in checkAccessCode",e);
            }
        }; //end of checkAccessCode
        
        const openDelegateModal = function(innerArgs, p) {
            CloverApp.API.setDataField("DelegateFromName", "");
            CloverApp.API.setDataField("DelegateCode", "");
            CloverApp.API.setDataField("DelegateName", "");
            CloverApp.API.setDataField("DelegateComments", "");
            CloverApp.API.setDataField("DelegateEmail", "");
            CloverApp.API.setDataField("DelegateValidityStart", CloverApp.API.formatDatetime(new Date(),"") );
            CloverApp.API.setDataField("DelegateValidityEnd", CloverApp.API.formatDatetime(p.row.DueDate,""));
            CloverApp.API.setDataField("DelegateDlsi", p.row.Id);
            innerArgs.component.refs.delegateModal.openModal();
        };

        const checkAccessCodeForPrint = function(innerArgs, p) {
            checkAccessCode(innerArgs, p, '''', ''print'');
        };
        
        const openPrintModal = function(innerArgs, p) {
            const languages = p.row.Languages.split(''||'');
            const formNames = p.row.FormNames.split(''||'');
            const items = [];
            
            if(Array.isArray(formNames) && formNames.length>0) {
                for(var i = 0 ; i < formNames.length; i++){
                    items.push( {
                        key: i,
                        text: languages[i],
                        value: formNames[i],
                    });
                }

                CloverApp.API.setDataField(''printRow'', p);
                Utils.rewriteDropdown("formNameDropDown",items, undefined);
                CloverApp.API.setDataField("formNameDropDown", formNames[0]);

            }
            else
            {
                Utils.rewriteDropdown("formNameDropDown",null, undefined);
                CloverApp.API.setDataField("formNameDropDown", null);
            }
            innerArgs.component.refs.printModal.openModal();
        }; 
        
        const getPasswordAsync = function (args, id) {
            const formData = new FormData();
            formData.append(''id'', id);
            fetch("/respondent/getpassword", {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            }).then( response => response.json()
            ).then( response => {
                if (response.success) {
                    args.controlRef.refs.passwordModal.openModal();
                    args.component.state.data.password = response.item;
                    args.component.refs.password.forceUpdate();
                } else {
                    alertify.error(response.message);
                }
            }).catch(error => {
                alertify.error(error.message);
            });
        }; //end of getPasswordAsync 
        
        const formColumnFormatter = function (p) {
          if (p.row.Type === "Online") {
            const formNames = p.row.FormNames.split(''||'');
            const languages = p.row.Languages.split(''||'');
            let elements = [];
        
            formNames.forEach( genFormLink.bind(null, p, elements, languages) );
            return CloverApp.API.createElement("div", { style: { display: "flex", flexDirection: "column" , justifyContent: "center", alignItems: "center" } }, elements);
          } else {
            return CloverApp.API.createElement("div", {}, p.value); 
          }
        };

        const fileColumnFormatter = function(p) {
            const dlsi = p.row.Id;
            const isExcelEnabled = p.row.IsExcelEnabled;
            const isOnlineSurvey = p.row.QnnType=="O";
            const hasOnlineFiles = isOnlineSurvey && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
            //console.log("In fileColumnFormatter for "+p.row.QnnTitle+" for deployment "+p.row.DplyName+". hasOnlineFiles="+hasOnlineFiles+", isExcelEnabled="+isExcelEnabled+", row:", p.row);
            if(hasOnlineFiles && isExcelEnabled){
                const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
                const fileNames = p.row.FileNames.split(''||'');
                const fileLanguages = p.row.FileLanguages.split(''||'');
                const fileTokens = p.row.FileTokens.split(''||'');      
                let elements = [];
                for(let i=0; i < fileNames.length; i++) {
                    let element;
                    if(ipAllowed) {
                        const respId = p.row.RespId ? p.row.RespId : '''';
                        const linkUrl = "/respondent/download/file/" 
                            + encodeURIComponent(dlsi) 
                            + "/"  + encodeURIComponent(fileTokens[i]) 
                            + "/" + encodeURIComponent(respId);
                        element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);
                    } else {
                        element = CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, fileLanguages[i]);
                    }         
                    elements.push(element);
                    elements.push( CloverApp.API.createElement("br") );
                }
                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }
        }; //end of fileColumnFormatter
        
        const fileButtonFormatter = function(p) {
            const dlsi = p.row.Id;
            const isExcelEnabled = p.row.IsExcelEnabled;
            const isOnlineSurvey = p.row.QnnType=="O";
            const hasOnlineFiles = isOnlineSurvey && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
            
            const btnText = "Downloads";
            const icon = CloverApp.API.createElement("i", {className: "download icon",ariaHidden: "true" }, "");
            const downloadBtn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCode(innerArgs, p, '''', ''download''), 
                className: iconBtnClass,
                style: { 
                  color: "teal",
                  padding: "0.1em",
                  fontSize: ''3em'', 
                }
              },
              icon
            );
                    
            if(hasOnlineFiles && isExcelEnabled){
                return CloverApp.API.createElementWithPopup(btnText,popupProps,downloadBtn); 
            }else{
                return CloverApp.API.createElement("div", {}, "");
            }
        } //end of fileButtonFormatter
        
        const excelButtonFormatter = function(p) {
            
            const btnText = "Upload Excel";
            const icon = CloverApp.API.createElement("i", {className: "file excel icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCode(innerArgs, p, '''', ''upload''), 
                className: iconBtnClass,
                style: { 
                  color: "teal",
                  padding: "0.1em",
                  fontSize: ''3em'', 
                }
              },
              icon
            );
                    
            const isExcelEnabled = p.row.IsExcelEnabled;
            const hasOnlineFiles = p.row.QnnType=="O" && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
            const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            const status = p.row.Status ? p.row.Status.toLowerCase() : "";
            if(isExcelEnabled && hasOnlineFiles && ipAllowed && (status===PENDING || status===IN_PROGRESS) ) {
                const formNames = p.row.FormNames.split(''||''); 
                const languages = p.row.Languages.split(''||''); 
                return CloverApp.API.createElementWithPopup(btnText,popupProps,btn); 
            }
            else if(isExcelEnabled && hasOnlineFiles && ipAllowed && !(status===PENDING || status===IN_PROGRESS) ){
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCode(innerArgs, p, '''', ''upload''), 
                className: iconBtnDisabledClass,
                style: { 
                  color: "teal",
                  padding: "0.1em",
                  fontSize: ''3em'', 
                }
              },
              icon
            );
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                return CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }
            else{
                return CloverApp.API.createElement("div", {}, "");
            }
        } //end of excelButtonFormatter

        const actionsColumnFormatter  = function (p) {
            const excelButton = excelButtonFormatter(p);
            return CloverApp.API.createElement("div", {}, [excelButton]);
        }; //end of actionsColumnFormatter

        const delegateColumnFormatter = function (p) {
            const requireAccessCode = p.row.RequireAccessCode;
            const btnText = "Delegate";
            const icon = CloverApp.API.createElement("i", {className: "sitemap icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => openDelegateModal(innerArgs, p), 
                className: iconBtnClass,
                style: { 
                  color: "teal",
                  padding: "0.1em",
                  fontSize: ''3em'',
                }
              },
              icon
            );

            if(requireAccessCode){
                return CloverApp.API.createElementWithPopup(btnText,popupProps,btn); 
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }
        }; //end of delegateFormatter
        
        const printColumnFormatter = function (p) {
            const btnText = "Send print pdf file to email";
            const icon = CloverApp.API.createElement("i", {className: "envelope icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCodeForPrint(innerArgs, p), 
                className: iconBtnClass,
                style: { 
                  color: "teal",
                  padding: "0.1em",
                  fontSize: ''3em'',
                }
              },
              icon
            );
            return CloverApp.API.createElementWithPopup(btnText,popupProps,btn); 
        }; //end of printColumnFormatter 

        //Current surveys card grid
        const currentCardModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
            
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                cols.Form.customFormatter = formColumnFormatter;
                cols.File.customFormatter = fileButtonFormatter;
                cols.Actions.customFormatter = actionsColumnFormatter; //upload
                cols.Delegate.customFormatter = delegateColumnFormatter;

                if(!innerArgs.data.backendPrintEnable) {
                    delete cols["Print"];
                } else {
                    cols.Print.customFormatter = printColumnFormatter;
                }
            }
            return model;
        }; //end of currentCardModelRewriter
            
        //Previous surveys card grid    
        const previousCardModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Form.customFormatter = formColumnFormatter;
                if(!innerArgs.data.puppeteerSharpEnable) {
                    delete cols["Print"];
                } else {
                    cols.Print.customFormatter = printColumnFormatter;
                }
            }
            return model;
        }; //end of previousCardModelRewriter
            
        //fetch and display respondent portal messages
        Utils.getRequest("/swzdata/getmultiple?type=RespDashboard").then(
            response => {
                const htmlData = [];
                for (var i=0; i<response.data.length; i++){
                    htmlData.push(response.data[i].editorState);
                }
                CloverApp.API.setDataField("respDashboardHtmlView", htmlData);
            }, reason => {
                console.log("Unable to fetch respondent content", reason);
            }
        );
        CloverApp.API.rewriteControlModel("currentSurveyCard", currentCardModelRewriter);
        CloverApp.API.rewriteControlModel("previousSurveyCard", previousCardModelRewriter);
        
        //when uncommented it causes scrollbar reset issue
        //$(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
        
        const gridDelegateModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[5].customFormatter = function (p) {
                    if(p.row.Comments){
                        var Comments = p.row.Comments;

                        return CloverApp.API.createElement("div", {title: Comments, className:"react-grid-Cell-Comments"}, Comments); 
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "");                        
                    }
                  
                };
            }
            return model;
        }; //end of gridDelegateModelRewriter
        
        CloverApp.API.rewriteControlModel("gridDelegation", gridDelegateModelRewriter); 
        
    }, //end of init

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    closeAccessCodeModal: function(args) {
        args.component.refs.accessCodeModal.close();
        args.data.AccessCode = null;
        return {};
    },
    
    closeDelegateModal: function(args) {
        args.component.refs.delegateModal.close();
        CloverApp.API.setDataField("DelegateCode", "");
        return {};
    },

    closePrintModal: function(args) {
        args.component.refs.printModal.close();
        CloverApp.API.setDataField("printRow", "");
        return {};
    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        args.data.AccessCode = null;
        return {};
    },
    
    closeFileDownloadModal: function(args) {
        args.component.refs.fileDownloadModal.close();
        args.data.AccessCode = null;
        return {};
    },

    promptForExcelFile: function(args) {
        const file = $("input[name=''ExcelFileUpload'']");
        file.trigger(''click'');
        return {};
    },
    
    excelFileUploaded: function(args) {
        const result = args.sourceControlValue;
        CloverApp.API.setDataField("ExcelFileUpload", null); 
        if("OK"===result) {
            args.component.refs.fileUploadModal.close();
            
            const qnnId = args.data.UploadQnnId;
            const dplyId = args.data.UploadDplyId;
            const listSampleId = args.data.UploadListSampleId;
            if( (!qnnId) || (!dplyId) || (!listSampleId)) {
                console.error("Missing required value for one of qnnId, dplyId, listSampleId", args.data);
                alertify.error("File processed successfully but an error occured opening the form. Try opening the form using the form link instead.", 15000);
                return {};
            }
            
            const uploadFormChoice = args.data.UploadFormChoice;
            const formName = args.data.UploadFormNames[uploadFormChoice];
            const uploadDlsi = args.data.AccessCodeDlsi;
            //args.component.refs.grid.refresh();
            alertify.success("Survey answers uploaded");
            
            if(formName) {
                CloverApp.API.redirect(''form'', formName, ''dlsi/''+ uploadDlsi);
            }
        } else {
            console.log("Excel upload failure code", result);
            let errorMessage = "Excel upload was not successful.";
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
            } else if ("INCORRECT UEN" === result) {
                errorMessage = "This file is for another respondent. The UEN recorded in the spreadsheet does not match your UEN.";
            } else if("RESTRICTED IP" === result) {
                errorMessage = "Your IP Address or Country is restricted from accessing this survey.";
            } else if ("INCORRECT ACCESS CODE" === result) {
                errorMessage = "Access Code is incorrect or has expired.";
            } else if ("INTERNAL ERROR" === result) {
                errorMessage = "Internal Error. Excel upload was not successful.";
            }
            alertify.error(errorMessage, 10000);
        }
        return {};
    },
    
    submitAccessCode: function(args) {
        
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi))                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------
        
        const openPrintModal = function(args) {
            const p = args.data.AccessCodeRow;
            const languages = p.row.Languages.split(''||'');
            const formNames = p.row.FormNames.split(''||'');
            let items = [];
            
            if(Array.isArray(formNames) && formNames.length>0) {
                for(var i = 0 ; i < languages.length; i++){
                    items.push( {
                        key: i,
                        text: languages[i],
                        value: formNames[i],
                    });
                }
                CloverApp.API.setDataField(''printRow'', p);
                Utils.rewriteDropdown("formNameDropDown",items, undefined); 
                CloverApp.API.setDataField("formNameDropDown", formNames[0]);
            }
            else
            {
                Utils.rewriteDropdown("formNameDropDown",null, undefined);
                CloverApp.API.setDataField("formNameDropDown", null);
            }
            innerArgs.component.refs.printModal.openModal();
        };
        
        const promptForDownload = function (innerArgs){
            const p = args.data.AccessCodeRow;
            const dlsi = p.row.Id;
            const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            const fileLanguages = p.row.FileLanguages.split(''||'');
            const items = [];
            if(Array.isArray(fileLanguages) && fileLanguages.length>0) {
                for(var i = 0 ; i < fileLanguages.length; i++){
                    items.push( {
                        key: i,
                        text: fileLanguages[i],
                        value: i,
                    });
                }

                CloverApp.API.setDataField(''fileRow'', p);
                Utils.rewriteDropdown("fileDropDown",items, undefined);
                CloverApp.API.setDataField("fileDropDown", 0);

            }
            else
            {
                Utils.rewriteDropdown("fileDropDown",null, undefined);
                CloverApp.API.setDataField("fileDropDown", null);
            }
            
            innerArgs.component.refs.fileDownloadModal.openModal();  
        };
        
        //--------------------------------------------
        const createNewResponseAndOpen = function(dlsi, formName) {
            //nb: this is duplicated in submitAccessCode too
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/respondent/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen
        //--------------------------------------------
        
        const innerArgs = args;
        
        const promptForUpload = function (){
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        const accessCode = args.data.AccessCode.trim();
        if(accessCode === undefined || accessCode === null || accessCode == "") {
            alertify.error("Please enter an Access Code");
            return {};
        }
        
        const respId = args.data.AccessCodeRespId;
        const dlsi = args.data.AccessCodeDlsi;
        const formName = args.data.AccessCodeFormName;
        const control = args.data.AccessCodeControl;
        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("accessCode", accessCode);
        Utils.loadingStart("Validating Access Code");
        Utils.postFormRequest("/respondent/accesscode", form).then(
            result => {
                if(result.item.validated) {
                    respdashboardUserActions.closeAccessCodeModal(innerArgs);
                    switch(control) {
                        case ''form'':
                            redirectToSurvey(dlsi, formName, respId);
                            break;
                        case ''upload'':
                            promptForUpload();
                            break;
                        case ''new'':
                            createNewResponseAndOpen(dlsi, formName);
                            break;
                        case ''print'':
                            openPrintModal(innerArgs);
                        case ''download'' :
                            promptForDownload(innerArgs);
                        break;
                    }
                } else if(result.item.exceed){
                    alertify.error(result.item.message);
                } else{
                    alertify.error("Access Code is incorrect or has expired");
                }
            }, reason => {
                alertify.error(reason);
                console.log(reason);
            }
        ).finally(Utils.loadingStop);

    },
    
    delegate: function(args) {
        
        const data = args.data;
        
        const dlsi = data.DelegateDlsi;
        const validityStart = data.DelegateValidityStart;
        const validityEnd = data.DelegateValidityEnd;
        const name = data.DelegateName;
        const email = data.DelegateEmail;
        const comments = data.DelegateComments;
        const delegateFromName = data.DelegateFromName;
        const delegateCode = data.DelegateCode.trim();
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        const displayTime = 15000;
        let validated = true;
        if(validityStart===undefined || validityStart===null || validityStart==='''') {
            alertify.error("Validity start date is required", displayTime);
            validated = false;
        }
        if(validityEnd===undefined || validityEnd===null || validityEnd==='''') {
            alertify.error("Validity end date is required", displayTime);
            validated = false;
        }
        if(validityStart >= validityEnd || validityEnd <= new Date()) {
            alertify.error("Invalid validity period", displayTime);
            validated = false;
        }
        if(email===undefined || email===null || email==='''') {
            alertify.error("Email address is required", displayTime);
            validated = false;
        }
        if(!emailRegExr.test(email)){
            alertify.error("Invalid email address", displayTime);
            validated = false;
        }
        if(delegateCode===undefined || delegateCode===null || delegateCode===''''){
            alertify.error("Please provide your delegate code to authorise the delegation", displayTime);
            validated = false;
        }
        if(name===undefined || name===null || name==='''') {
            alertify.error("Delegate''s name is required", displayTime);
            validated = false;
        }
        if(delegateFromName===undefined || delegateFromName===null || delegateFromName==='''') {
            alertify.error("Your name is required", displayTime);
            validated = false;
        }
        if(!validated) {
            return {};
        }
        
        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("validityStart", validityStart);
        form.append("validityEnd", validityEnd);
        form.append("name",name);
        form.append("email", email);
        form.append("delegateFromName", delegateFromName);
        form.append("delegateCode", delegateCode);
        form.append("comments",comments);
        Utils.loadingStart("Delegating...");
        Utils.postFormRequest("/respondent/delegate", form).then(
            result => {
                alertify.success("Delegation recorded. An access code has been generated and sent to " + email, displayTime);
                args.component.refs.delegateModal.close();
            }, reason => {
                console.log(reason);
                alertify.error(reason, displayTime);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    },
    
    openDelegateHistoryModal: function(args){
        const gridDelegationModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
            
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Revoke.customFormatter = RevokeColumnFormatter;                
            }
            return model;
        }; //end of gridDelegationModelRewriter
        
        const RevokeColumnFormatter = function (p) {
            const status = p.row.Status;
            if(status == ''Active'' || status == ''Scheduled'' || status == ''Inactive''){
                return CloverApp.API.createElement(
                    "button", {
                        onClick: () => revokeDelegationById(args, p.row.Id), 
                        className: "ui button secondary invert",
                    }, "Revoke");
            } else {
                return CloverApp.API.createElement("div", {}, ""); 
            }
        };
        
        const revokeDelegationById = function(args, p) {
            const formData = new FormData();
            formData.append("delegateId", p);
            formData.append("dlsi", args.data.DelegateDlsi);
            formData.append("delegateCode", args.data.DelegateCode);
            Utils.loadingStart();
            Utils.postFormRequest("/respondent/revokedelegationbyid",formData).then(
                response => {
                    alertify.success(response.message);
                    // Refresh the grid with new data
                    // Use POST to hide delegateCode in the message body
                    Utils.postFormRequest("/respondent/viewdelegatelist", formData).then( 
                        response => {
                            CloverApp.API.setDataField(''gridDelegation'', response.item);
                            args.component.refs.gridDelegation.refresh();
                        }, reason => {
                            alertify.error(reason);
                            console.log(reason);
                        }
                    );
                }, reason => {
                    alertify.error(reason);
                    console.log(reason);
                }
            ).finally(Utils.loadingStop);
        }; //end of revokeDelegationById
        
        CloverApp.API.setDataField(''gridDelegation'', null);
        
        const delegateCode = args.data.DelegateCode.trim();
        
        const displayTime = 15000;
        if(delegateCode===undefined || delegateCode===null || delegateCode===''''){
            alertify.error("Please provide your delegate code to view delegation history", displayTime);
            return {};
        }
        
        const formData = new FormData();
        formData.append("dlsi", args.data.DelegateDlsi);
        formData.append("delegateCode", delegateCode);
        // Use POST to hide delegateCode in the message body
        Utils.loadingStart();
        Utils.postFormRequest("/respondent/viewdelegatelist", formData).then(
            response => {
                CloverApp.API.setDataField(''gridDelegation'', response.item);
                CloverApp.API.rewriteControlModel("gridDelegation", gridDelegationModelRewriter);
                args.component.refs.delegateHistoryModal.openModal();
                args.component.refs.gridDelegation.refresh();
            }, reason => {
                console.log(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    }, //end of openDelegateHistoryModal
    
    closeDelegateHistoryModal: function(innerArgs){
        CloverApp.API.setDataField(''gridDelegation'', null);
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
    revokeAllDelegation: function(args){
        const formData = new FormData();
        formData.append("dlsi", args.data.DelegateDlsi);
        formData.append("delegateCode", args.data.DelegateCode);
        Utils.loadingStart(); 
        Utils.postFormRequest("/respondent/revokedelegationbydlsi", formData).then(
            response => {
                alertify.success(response.message);
                // Refresh the grid with new data
                // Use POST to hide delegateCode in the message body
                Utils.postFormRequest("/respondent/viewdelegatelist", formData).then(
                    response => {
                        CloverApp.API.setDataField(''gridDelegation'', response.item);
                        args.component.refs.gridDelegation.refresh();
                    }, reason => {
                        console.log(reason);
                        alertify.error(reason);
                    }
                );
            }, reason => {
                console.log(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    onPrintClick: function(args) {
        let validated = true;
        const emails = args.data.inputEmails;
        if(emails==undefined || emails==null || emails.length==0){
            alertify.error("Email is required");
            validated = false;
        }
        
        if(emails
        && emails.trim()!=="" 
        && !(emails.split('','').filter(m => !(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/).test(m.trim())).length==0)) {
                alertify.error("Please enter valid email address");  
                validated = false;
        }
        
        if(!validated){
            return {};
        }
        const p = args.data.printRow;
        const respId = p.row.RespId;
        const dlsi = p.row.Id;
        const formName = args.data.formNameDropDown;
        console.log("formName :",formName);
        const formData = new FormData();
        formData.append(''formName'', formName);
        formData.append(''dlsi'', dlsi);
        formData.append(''respId'', respId ? respId : "");
        Utils.loadingStart();
        fetch("/print/form", {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
            if (response.success) {
                let htmlContent = CloverApp.API.printForm(response.form,response.data);
                const formDataPrint = new FormData();
                const languages = p.row.Languages.split(''||'');
                const formNames = p.row.FormNames.split(''||'');
                formDataPrint.append(''htmlContent'',htmlContent);
                formDataPrint.append(''emails'',emails);
                for(var i = 0 ; i < formNames.length; i++){
                    if(formNames[i] === formName)
                        formDataPrint.append(''surveyName'',p.row.QnnTitle + "_" + languages[i]);
                }
                fetch("/print/download", {
                        credentials: ''same-origin'',
                        contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                        method: ''post'',
                        body: formDataPrint
                    })
                    .then(response => response.json())
                    .then(response => {
                    Utils.loadingStop();
                    if (response.success) {
                        alertify.success(response.message);
                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    Utils.loadingStop();
                    console.log(error);
                    alertify.error(error.message);
                });
            } else {
                alertify.error(response.message);
            }
        })
        .catch(error => {
            Utils.loadingStop();
            console.log(error);
            alertify.error(error.message);
        });
    },
    
    onDownloadClick: function(args) {
        const p = args.data.fileRow;
        const dlsi = p.row.Id;
        const file = args.data.fileDropDown;
        const fileTokens = p.row.FileTokens.split(''||'');
        const fileNames = p.row.FileNames.split(''||'');
        const respId = p.row.RespId ? p.row.RespId : '''';
        const downloadUrl = "/respondent/download/file/" + encodeURIComponent(dlsi) + "/" + encodeURIComponent(fileTokens[file]) + "/" + encodeURIComponent(respId);
    
        Utils.loadingStart("Loading");
        fetch(downloadUrl)
            .then(response => {
                if (!response.ok) {
                    throw new Error(''Network response was not ok'');
                }
                return response.blob();
            })
            .then(blob => {
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement(''a'');
                a.href = url;
                a.download = fileNames[file];
                a.style.display = ''none'';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                window.URL.revokeObjectURL(url);
            })
            .catch(error => {
                console.error(''Error downloading file:'', error);
                alertify.error(''Error downloading file.'');
            })
            .finally(() => {
                Utils.loadingStop();
            });
    }
}








' WHERE [Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df';

