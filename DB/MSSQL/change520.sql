-- Will UPDATE existing row(s) in dwMetadata for the following:
-- respdashboard-code.js
-- respdashboard.json

UPDATE [dwMetadata] SET
[Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-08-01 14:42:14.390', 
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
        CloverApp.API.setDataField("IsIncludeUnansweredSectionPDFExport", false);
        const innerArgs = args;            
        const PENDING = "A3D01086-40FC-4A7A-BF0C-DE17BDD205FA".toLowerCase();
        const IN_PROGRESS = "0D67932C-62EA-4CD3-A254-0CC63E742C93".toLowerCase();
        const SUBMITTED = "7C23B23E-23A3-4F04-96EF-89521BABE78D".toLowerCase();
        
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
          const status = p.row.Status ? p.row.Status.toLowerCase() : "";
          const isCurrentSurvey = new Date(p.row.DueDate) >= Date.now();
          const formControls = [];
          
          if (ipIsAllowed) {
            //Render Form link
            const onClickForm = () => {
              checkAccessCode(innerArgs, p, formName, "form");
            };
            const qnnsBtnClass = quotaReached || status === SUBMITTED || !isCurrentSurvey || p.row.RespDateEnd !== null ? "ui teal basic button disabled" : "ui teal basic button";
            const qnnsBtn = CloverApp.API.createElement(
              "span",
              {
                onClick: onClickForm,
                className: qnnsBtnClass,
                style: { width: "150px", height: "40px", marginTop: "10px" },
              },
              languages[index]
            );

            const viewBtn = CloverApp.API.createElementWithPopup("View Submitted Response", popupProps,
                    CloverApp.API.createElement("span", { onClick: onClickForm, className: "link-style", style: { /*color: "red",*/ paddingLeft: "0.5em" } },
                    [
                        CloverApp.API.createElement("i", {className: "eye icon", ariaHidden: "true" }, "")
                    ]));
                    
            //Render new response button for multiple response surveys
            if (isMultipleResponse) {
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
                formControls.push(addBtnPopup);
              }
            }
            formControls.push(qnnsBtn);
            if(status === SUBMITTED || p.row.RespDateEnd !== null ) {
                formControls.push(viewBtn)
            }
            elements.push(
                CloverApp.API.createElement(
                  "div",
                  { style: { display: "flex", alignItems: "center" } },
                  [formControls]
                ));
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
        
        const genFormLinkGrid = function (p, elements, languages, formName, index) {
          const isMultipleResponse = !!p.row.IsMultipleResponse;
          const ipIsAllowed = p.row.IpAllowed || p.row.IpAllowed === undefined;
          const quotaReached = p.row.MaxResponse !== -1 && p.row.MaxResponse !== null && 
                               p.row.MaxResponse !== undefined && p.row.MaxResponse !== "" &&
                               p.row.MaxResponse <= p.row.TotalComplete;
          const status = p.row.Status ? p.row.Status.toLowerCase() : "";
          const isCurrentSurvey = new Date(p.row.DueDate) >= Date.now();
          const formControls = [];
          
          if (ipIsAllowed) {
            //Render new response button for multiple response surveys
            if (isMultipleResponse) {
              const sampleResponseInProgress = status === IN_PROGRESS;
              const showActionAdd = isCurrentSurvey && sampleResponseInProgress;
              if (showActionAdd) {
                const onClickNew = () => {
                  checkAccessCode(innerArgs, p, formName, "new");
                };
                    formControls.push(
                        CloverApp.API.createElementWithPopup("Add New Response", popupProps,
                            CloverApp.API.createElement("span", { onClick: onClickNew, className: "link-style", style: { color: "green"/*, paddingRight: "0.5em"*/ } },
                            [
                                CloverApp.API.createElement("i", {className: "plus icon", ariaHidden: "true" }, "")
                            ]))
                    );
                }
            }
                
                //Render Form link
                const onClickForm = () => {
                    checkAccessCode(innerArgs, p, formName, ''form'');
                };
                /*elements.push(
                    CloverApp.API.createElement("span", { onClick: onClickForm  , className: "link-style" }, languages[index])
                );*/
                
                const formLinkClass = status === SUBMITTED || !isCurrentSurvey ? "disabled-link" : "link-style";
                
                formControls.push( 
                    CloverApp.API.createElementWithPopup("Edit Response", popupProps,
                        CloverApp.API.createElement("span", { onClick: onClickForm, className: formLinkClass }, 
                        [
                            languages[index], 
                            CloverApp.API.createElement("i", {className: "edit icon", ariaHidden: "true", style: { paddingLeft: "0.5em" } }),
                        ])),
                    
                    CloverApp.API.createElementWithPopup("View Response", popupProps,
                        CloverApp.API.createElement("span", { onClick: onClickForm, className: "link-style" , style: { /*color: "red",*/ paddingLeft: "0.5em" } },
                        [
                            CloverApp.API.createElement("i", {className: "eye icon", ariaHidden: "true" }, "")
                        ]))
                );
                
                elements.push(
                    CloverApp.API.createElement("div", { style: { whiteSpace: "normal", margin: "2px 2px 8px 2px" } }, 
                    [
                        formControls
                    ])
                );
            } 
            else {
                elements.push(
                    CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index])    
                );
            }
            elements.push( CloverApp.API.createElement("br") );
        };
        
        const createNewResponseAndOpen = function(dlsi, formName) {
            //nb: this is duplicated in submitAccessCode too
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/respondent/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
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
                            console.error(response);
                            alertify.error( Utils.encodeHTML(response.message) );
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
                if(items.length > 1) {
                    Utils.dispatchHideControl("formNameDropDown", "show");
                    Utils.dispatchHideControl("staticcontent_print", "show");
                }
                else {
                    Utils.dispatchHideControl("formNameDropDown", "hide");
                    Utils.dispatchHideControl("staticcontent_print", "hide");
                }

            }
            else
            {
                Utils.rewriteDropdown("formNameDropDown",null, undefined);
                CloverApp.API.setDataField("formNameDropDown", null);
            }
            let IsIncludeUnansweredSection = p.row.IsIncludeUnansweredSection;
            if(IsIncludeUnansweredSection == null) 
                IsIncludeUnansweredSection = args.data.printAllPage;
            if(IsIncludeUnansweredSection) {
                Utils.dispatchHideControl("IsIncludeUnansweredSectionPDFExport", "show");
            }
            else {
                Utils.dispatchHideControl("IsIncludeUnansweredSectionPDFExport", "hide");
            }
            CloverApp.API.setDataField("inputEmails", p.row.sampleEmails);
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
                    console.error(response.message);
                    alertify.error( Utils.encodeHTML(response.message) );
                }
            }).catch(error => {
                console.error(error.message);
                alertify.error( Utils.encodeHTML(error.message) );
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
        
        const fileButtonFormatter = function(p) {
            const dlsi = p.row.Id;
            const isExcelEnabled = p.row.IsExcelEnabled;
            const isOnlineSurvey = p.row.QnnType=="O";
            const hasOnlineFiles = isOnlineSurvey && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
                    
            const btnText = "Downloads";
            //const icon = CloverApp.API.createElement("i", {className: "download icon",ariaHidden: "true" }, "");
            const downloadBtn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCode(innerArgs, p, '''', ''download''), 
                className: "ui teal secondary button"
              },
              btnText
            );
                    
            if(hasOnlineFiles && isExcelEnabled){
                return CloverApp.API.createElementWithPopup(btnText,popupProps,downloadBtn); 
            }else{
                return CloverApp.API.createElement("div", {}, "");
            }
        } //end of fileButtonFormatter
        
        const excelButtonFormatter = function(p) {
            
            const btnText = "Upload Excel";
            //const icon = CloverApp.API.createElement("i", {className: "file excel icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCode(innerArgs, p, '''', ''upload''), 
                className: "ui teal secondary button"
              },
              btnText
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
                className: "ui teal secondary button disabled"
              },
              btnText
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
            //const icon = CloverApp.API.createElement("i", {className: "sitemap icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => openDelegateModal(innerArgs, p), 
                className: "ui teal secondary button"
              },
              btnText
            );

            if(requireAccessCode){
                return CloverApp.API.createElementWithPopup(btnText,popupProps,btn); 
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }
        }; //end of delegateFormatter
        
        const printColumnFormatter = function (p) {
            if((innerArgs.data.IsPDFExportForSubmittedOnly && p.row.RespDateEnd !== null) || !innerArgs.data.IsPDFExportForSubmittedOnly){
                const btnText = "Email PDF";
                //const icon = CloverApp.API.createElement("i", {className: "envelope icon",ariaHidden: "true" }, "");
                const btn = CloverApp.API.createElement(
                  "button", {
                    onClick: () => checkAccessCodeForPrint(innerArgs, p), 
                    className: "ui teal secondary button"
                  },
                  btnText
                );
                return CloverApp.API.createElementWithPopup(btnText,popupProps,btn); 
            }
            else 
            {
                return CloverApp.API.createElement("div", {className: "" }, "");   
            }

        }; //end of printColumnFormatter
        
        const formGridColumnFormatter = function (p) {
          if (p.row.Type === "Online") {
            const formNames = p.row.FormNames.split(''||'');
            const languages = p.row.Languages.split(''||'');
            let elements = [];
        
            formNames.forEach( genFormLinkGrid.bind(null, p, elements, languages) );
            return CloverApp.API.createElement("div", {}, elements);
          } else {
            return CloverApp.API.createElement("div", {}, p.value); 
          }
        }; //end of formGridColumnFormatter

        const fileGridColumnFormatter = function(p) {
            const dlsi = p.row.Id;
            const isExcelEnabled = p.row.IsExcelEnabled;
            const isOnlineSurvey = p.row.QnnType=="O";
            const hasOnlineFiles = isOnlineSurvey && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
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
        }; //end of fileGridColumnFormatter

        
        const excelGridColummnFormatter = function(p) {
            const isExcelEnabled = p.row.IsExcelEnabled;
            const hasOnlineFiles = p.row.QnnType=="O" && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
            const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            const status = p.row.Status ? p.row.Status.toLowerCase() : "";
            if(isExcelEnabled && hasOnlineFiles && ipAllowed && (status===PENDING || status===IN_PROGRESS) ) {
                const formNames = p.row.FormNames.split(''||''); 
                const languages = p.row.Languages.split(''||''); 
                return CloverApp.API.createElement(
                    "button",{
                        onClick: () => checkAccessCode(innerArgs, p, '''', ''upload''),
                        className: "ui button secondary invert",
                    },"Upload Excel"); 
            }
            else if(isExcelEnabled && hasOnlineFiles && ipAllowed && !(status===PENDING || status===IN_PROGRESS) ){
                return CloverApp.API.createElement("button", {className: "ui button disabled" }, "Upload Excel");
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }
        } //end of excelGridButtonFormatter

        const actionsGridColumnFormatter  = function (p) {
            const excelButton = excelGridColummnFormatter(p);
            return CloverApp.API.createElement("div", {}, [excelButton]);
        }; //end of actionsColumnFormatter

        const delegateGridColumnFormatter = function (p) {
            const requireAccessCode = p.row.RequireAccessCode;
            if(requireAccessCode){
                return CloverApp.API.createElement("button",{ onClick: () => openDelegateModal(innerArgs,p),
                    className: "ui button secondary invert",},"Delegate"); 
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }
        }; //end of actionsGridColumnFormatter
        
        const printGridColumnFormatter = function (p) {
            if((innerArgs.data.IsPDFExportForSubmittedOnly && p.row.RespDateEnd !== null) || !innerArgs.data.IsPDFExportForSubmittedOnly){
                return CloverApp.API.createElement(
                  "button", {
                    onClick: () => checkAccessCodeForPrint(innerArgs, p), 
                    className: "ui button secondary invert"
                  },
                  "Email PDF"
                );
            }
            else 
            {
                return CloverApp.API.createElement("div", {className: "" }, "");   
            }

        }; //end of printGridColumnFormatter
        
        //Current surveys grid
        const currentGridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
            
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                cols.Form.customFormatter = formGridColumnFormatter;
                cols.File.customFormatter = fileGridColumnFormatter;
                cols.Actions.customFormatter = actionsGridColumnFormatter;
                cols.Delegate.customFormatter = delegateGridColumnFormatter;

                if(!innerArgs.data.backendPrintEnable) {
                    delete cols["Print"];
                } else {
                    cols.Print.customFormatter = printGridColumnFormatter;
                }
            }
            return model;
        }; //end of currentGridModelRewriter
            
        //Previous surveys grid    
        const previousGridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Form.customFormatter = formGridColumnFormatter;
                if(!innerArgs.data.backendPrintEnable) {
                    delete cols["Print"];
                } else {
                    cols.Print.customFormatter = printGridColumnFormatter;
                }
            }
            return model;
        }; //end of previousGridModelRewriter
        
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
                if(!innerArgs.data.backendPrintEnable) {
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
        CloverApp.API.rewriteControlModel("currentSurveyGrid", currentGridModelRewriter);
        CloverApp.API.rewriteControlModel("previousSurveyGrid", previousGridModelRewriter);
        CloverApp.API.rewriteControlModel("currentSurveyCard", currentCardModelRewriter);
        CloverApp.API.rewriteControlModel("previousSurveyCard", previousCardModelRewriter);
        
        //when uncommented it causes scrollbar reset issue
        //$(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
        
        args.component.refs.currentSurveyGrid.refresh();
        args.component.refs.previousSurveyGrid.refresh();
        
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
        CloverApp.API.setDataField("gridToggle", localStorage.getItem(''gridToggle''));
        
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
        CloverApp.API.setDataField("IsIncludeUnansweredSectionPDFExport", false);
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
            alertify.error( Utils.encodeHTML(errorMessage), 10000);
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
            const items = [];
            
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
                if(items.length > 1) {
                    Utils.dispatchHideControl("formNameDropDown", "show");
                    Utils.dispatchHideControl("staticcontent_print", "show");
                }
                else {
                    Utils.dispatchHideControl("formNameDropDown", "hide");
                    Utils.dispatchHideControl("staticcontent_print", "hide");
                }
            }
            else
            {
                Utils.rewriteDropdown("formNameDropDown",null, undefined);
                CloverApp.API.setDataField("formNameDropDown", null);
            }
            
            let IsIncludeUnansweredSection = p.row.IsIncludeUnansweredSection;
            if(IsIncludeUnansweredSection == null) 
                IsIncludeUnansweredSection = args.data.printAllPage;
            if(IsIncludeUnansweredSection) {
                Utils.dispatchHideControl("IsIncludeUnansweredSectionPDFExport", "show");
            }
            else {
                Utils.dispatchHideControl("IsIncludeUnansweredSectionPDFExport", "hide");
            }
            CloverApp.API.setDataField("inputEmails", p.row.sampleEmails);
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
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
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
                            break;
                        case ''download'' :
                            promptForDownload(innerArgs);
                            break;
                    }
                } else if(result.item.exceed){
                    alertify.error( Utils.encodeHTL(result.item.message) );
                } else{
                    alertify.error("Access Code is incorrect or has expired");
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
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
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), displayTime);
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
                    // Refresh the grid with new data, use POST to keep delegateCode out of the URL itself
                    Utils.postFormRequest("/respondent/viewdelegatelist", formData).then( 
                        response => {
                            CloverApp.API.setDataField(''gridDelegation'', response.item);
                            args.component.refs.gridDelegation.refresh();
                        }, reason => {
                            console.error("request to viewdelegatelistfailed", reason);
                            alertify.error( Utils.encodeHTML(reason) );
                        }
                    );
                }, reason => {
                    console.error("request to revokedelegationbyid failed", reason);
                    alertify.error( Utils.encodeHTML(reason) );
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
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
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
                        console.error("call to viewdelegatelist faield", reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                );
            }, reason => {
                console.log("call to revokedelegationbydlsi failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    onPrintClick: function(args) {
        let validated = true;
        const emails = args.data.inputEmails;
        const IsIncludeUnansweredSection = args.data.IsIncludeUnansweredSectionPDFExport;
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
                CloverApp.API.printForm(response.form, response.data, IsIncludeUnansweredSection)
                    .then(function(htmlContent) {
                        const formDataPrint = new FormData();
                        formDataPrint.append(''htmlContent'',htmlContent);
                        formDataPrint.append(''emails'',emails);
                        formDataPrint.append(''surveyName'',p.row.QnnTitle);
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
                                alertify.success( Utils.encodeHTML(response.message) );
                                CloverApp.API.setDataField("printRow", "");
                                CloverApp.API.setDataField("inputEmails", "");
                                CloverApp.API.setDataField("IsIncludeUnansweredSectionPDFExport", false);
                                args.component.refs.printModal.close();
                            } else {
                                alertify.error( Utils.encodeHTML(response.message) );
                            }
                        })
                        .catch(error => {
                            Utils.loadingStop();
                            console.error(error);
                            alertify.error( Utils.encodeHTML(error.message) );
                        });
                    })
                    .catch(function(error) {
                        // Handle error if printFormDiv fails
                        console.error("Error:", error);
                    });

            } else {
                Utils.loadingStop();
                alertify.error( Utils.encodeHTML(response.message) );
            }
        })
        .catch(error => {
            console.error(error);
            Utils.loadingStop();
            alertify.error( Utils.encodeHTML(error.message) );
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
    },
    onToggleGridClick: function(args) {
        const gridToggle = args.data.gridToggle;
        localStorage.setItem(''gridToggle'', gridToggle);
    }
}' WHERE [Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df';

UPDATE [dwMetadata] SET
[Id]='d6e12e1d-3384-4352-bf68-8210aa75d406', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-08-01 07:00:08.347', 
[Data]=N'[
  {
    "key": "container_3",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Respondent Home",
        "size": "huge",
        "style-customcss": "",
        "style-source": "color: rgb(19, 98, 226);"
      },
      {
        "key": "respDashboardHtmlView",
        "data-buildertype": "swzhtmlview",
        "hideOutput": "block",
        "events": {}
      }
    ],
    "style-source": "padding: 10px;"
  },
  {
    "key": "container_19",
    "data-buildertype": "container",
    "children": [
      {
        "key": "gridToggle",
        "data-buildertype": "checkbox",
        "label": "Grid View",
        "toggle": true,
        "style-customcss": "cbShowDropzones",
        "style-marginLeft": "",
        "events": {
          "onClick": {
            "active": false,
            "actions": [
              "onToggleGridClick"
            ],
            "targets": [],
            "parameters": []
          },
          "onChange": {
            "active": true,
            "actions": [
              "onToggleGridClick"
            ],
            "targets": [],
            "parameters": []
          }
        },
        "defaultValue": "",
        "other-visibleConition": ""
      }
    ],
    "style-float": "right",
    "style-customcss": "",
    "style-marginBottom": "5px",
    "style-marginRight": "20px"
  },
  {
    "key": "container_15",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "Current Surveys",
        "size": "medium",
        "style-source": "color: rgb(19, 98, 226);"
      },
      {
        "key": "currentSurveyGrid",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "QnnTitle",
            "name": "Survey Name",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "Form",
            "name": "Questionnaire",
            "sortable": false,
            "filterable": false,
            "resizable": true,
            "type": "custom",
            "width": 190
          },
          {
            "key": "File",
            "name": "File",
            "sortable": false,
            "filterable": false,
            "resizable": true,
            "type": "custom"
          },
          {
            "key": "DplyDateStart",
            "name": "Launched On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "DueDate",
            "name": "Due On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "RespDateStart",
            "name": "Started On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "RespDateUpdate",
            "name": "Updated On",
            "type": "datetime",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "RespDateEnd",
            "name": "Submitted On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "Actions",
            "name": "Actions",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "Delegate",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "Print",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false
          }
        ],
        "rowKey": "Id",
        "defaultSort": "Hardcoded",
        "rowHeight": "80",
        "minHeight": "200px",
        "events": {}
      }
    ],
    "style-source": "margin: auto;\npadding: 10px;\nmargin-bottom: 1em;",
    "style-customcss": "hrm-block",
    "style-width": "100%",
    "events": {},
    "other-visibleConition": "data.gridToggle == 1 || (data.gridToggle == null && localStorage.getItem(''gridToggle'')) == 1 ? true : false"
  },
  {
    "key": "container_17",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_9",
        "data-buildertype": "header",
        "content": "Previous Surveys",
        "size": "medium",
        "style-source": "color: rgb(19, 98, 226);"
      },
      {
        "key": "previousSurveyGrid",
        "data-buildertype": "gridview",
        "columns": [
          {
            "key": "QnnTitle",
            "name": "Survey Name",
            "sortable": true,
            "filterable": false,
            "resizable": true
          },
          {
            "key": "Form",
            "name": "Questionnaire",
            "sortable": false,
            "filterable": false,
            "resizable": true,
            "type": "custom",
            "width": 190
          },
          {
            "key": "DplyDateStart",
            "name": "Launched On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "DueDate",
            "name": "Due On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "RespDateStart",
            "name": "Started On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "RespDateEnd",
            "name": "Submitted On",
            "type": "datetime",
            "resizable": true,
            "sortable": true,
            "filterable": false
          },
          {
            "key": "Print",
            "type": "custom",
            "resizable": true,
            "sortable": true,
            "filterable": false,
            "name": "Print"
          }
        ],
        "rowKey": "Id",
        "defaultSort": "Hardcoded",
        "rowHeight": "80",
        "minHeight": "200px"
      }
    ],
    "style-source": "padding: 10px",
    "style-customcss": "hrm-block",
    "style-width": "100%",
    "other-visibleConition": "data.gridToggle == 1 || (data.gridToggle == null && localStorage.getItem(''gridToggle'')) == 1 ? true : false"
  },
  {
    "key": "container_18",
    "data-buildertype": "container",
    "children": [
      {
        "key": "currentAndPreviousTab",
        "data-buildertype": "tab",
        "items": [
          {
            "title": "Current"
          },
          {
            "title": "Previous"
          }
        ],
        "children": [
          {
            "key": "container_1",
            "data-buildertype": "container",
            "style-width": "100%",
            "style-customcss": "",
            "style-source": "margin: auto;\nmargin-bottom: 1em;\nbackground: #f2f5f9;\n",
            "children": [
              {
                "key": "currentSurveyCard",
                "data-buildertype": "cardgrid",
                "columns": [
                  {
                    "key": "QnnTitle",
                    "name": "Survey Name",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "",
                    "group": "header"
                  },
                  {
                    "key": "Form",
                    "name": "Questionnaire",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "custom",
                    "group": "body-left",
                    "icon": ""
                  },
                  {
                    "key": "RespDateStart",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Started On",
                    "group": "body-right",
                    "icon": ""
                  },
                  {
                    "key": "RespDateUpdate",
                    "name": "Updated On",
                    "type": "datetime",
                    "group": "body-right"
                  },
                  {
                    "key": "RespDateEnd",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Submitted On",
                    "group": "body-right",
                    "icon": ""
                  },
                  {
                    "key": "DplyDateStart",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Launched On",
                    "group": "body-bottom-left",
                    "icon": ""
                  },
                  {
                    "key": "DueDate",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Due On",
                    "group": "body-bottom-right",
                    "icon": ""
                  },
                  {
                    "key": "Print",
                    "name": "Print",
                    "type": "custom",
                    "group": "footer"
                  },
                  {
                    "key": "File",
                    "name": "File",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "custom",
                    "group": "footer",
                    "icon": ""
                  },
                  {
                    "key": "Actions",
                    "type": "custom",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Actions",
                    "group": "footer"
                  },
                  {
                    "key": "Delegate",
                    "type": "custom",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Delegate",
                    "group": "footer"
                  }
                ],
                "editFormShowType": "",
                "events": {},
                "style-hidden": false
              }
            ]
          },
          {
            "key": "container_2",
            "data-buildertype": "container",
            "style-width": "100%",
            "style-customcss": "",
            "style-source": "margin: auto;\nmargin-bottom: 1em;\nbackground: #f2f5f9;",
            "children": [
              {
                "key": "previousSurveyCard",
                "data-buildertype": "cardgrid",
                "columns": [
                  {
                    "key": "QnnTitle",
                    "name": "Survey Name",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "",
                    "group": "header"
                  },
                  {
                    "key": "Form",
                    "name": "Questionnaire",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "type": "custom",
                    "group": "body-left",
                    "icon": ""
                  },
                  {
                    "key": "RespDateStart",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Started On",
                    "group": "body-right",
                    "icon": ""
                  },
                  {
                    "key": "RespDateUpdate",
                    "name": "Updated On",
                    "type": "datetime",
                    "group": "body-right"
                  },
                  {
                    "key": "RespDateEnd",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Submitted On",
                    "group": "body-right",
                    "icon": ""
                  },
                  {
                    "key": "DplyDateStart",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Launched On",
                    "group": "body-bottom",
                    "icon": ""
                  },
                  {
                    "key": "DueDate",
                    "type": "datetime",
                    "sortable": true,
                    "filterable": false,
                    "resizable": false,
                    "name": "Due On",
                    "group": "body-bottom",
                    "icon": ""
                  },
                  {
                    "key": "Print",
                    "name": "Print",
                    "type": "custom",
                    "group": "footer"
                  }
                ],
                "editFormShowType": "",
                "events": {},
                "style-hidden": false
              }
            ]
          }
        ],
        "pointing": false,
        "secondary": false,
        "tabular": false,
        "vertical": false
      }
    ],
    "style-hidden": false,
    "other-visibleConition": "data.gridToggle == 0 || (data.gridToggle == null && localStorage.getItem(''gridToggle'') == null) || (data.gridToggle == null && localStorage.getItem(''gridToggle'') == 0) ? true : false",
    "style-marginBottom": "-15px"
  },
  {
    "key": "modalsContainer",
    "data-buildertype": "container",
    "style-float": "",
    "style-hidden": true,
    "children": [
      {
        "key": "printModal",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "style-display": "block",
        "content": "printModal",
        "children": [
          {
            "key": "header_8",
            "data-buildertype": "header",
            "content": "PDF Export",
            "size": "medium",
            "subheader": ""
          },
          {
            "key": "formgroup_3",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "staticcontent_print",
                "data-buildertype": "staticcontent",
                "content": "<br/>\nPlease select the form to export (with responses).",
                "isHtml": true,
                "other-visibleConition": ""
              },
              {
                "key": "formNameDropDown",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": true,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": 1,
                    "text": "Item 1"
                  },
                  {
                    "key": 2,
                    "value": 2,
                    "text": "Item 2"
                  },
                  {
                    "key": 3,
                    "value": 3,
                    "text": "Item 3"
                  }
                ],
                "placeholder": "",
                "other-visibleConition": ""
              },
              {
                "key": "staticcontent_5",
                "data-buildertype": "staticcontent",
                "content": "<br/>\nPlease enter the email address(es) to receive the exported PDF file (separated by comma):\n<br/>\n<i>eg: exampleA@example.com, exampleB@example.com)</i>",
                "isHtml": true,
                "events": {}
              },
              {
                "key": "inputEmails",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "example@gmail.com",
                "events": {},
                "style-marginTop": "10px"
              },
              {
                "key": "IsIncludeUnansweredSectionPDFExport",
                "data-buildertype": "checkbox",
                "label": "Include unanswered sections in exported file",
                "toggle": true,
                "events": {},
                "defaultValue": "0",
                "style-marginTop": "20px",
                "other-visibleConition": ""
              },
              {
                "key": "container_12",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "printButton",
                    "data-buildertype": "button",
                    "content": "Export",
                    "floated": "",
                    "secondary": false,
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "onPrintClick"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "printCancelButton",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closePrintModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "floated": "",
                    "secondary": true
                  }
                ],
                "style-marginTop": "20px",
                "events": {},
                "style-source": "text-align: right;"
              }
            ],
            "widthsCustom": "4",
            "orientation": "grouped",
            "style-marginTop": "",
            "events": {},
            "style-height": "270px"
          }
        ]
      },
      {
        "key": "delegateModal",
        "data-buildertype": "swzmodal",
        "content": "delegateModal",
        "secondary": true,
        "style-display": "block",
        "children": [
          {
            "key": "header_6",
            "data-buildertype": "header",
            "content": "Delegate Survey",
            "size": "medium",
            "subheader": "Delegate access to answer the survey to another user in your organisation."
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "DelegateName",
                "data-buildertype": "input",
                "label": "Delegate''s name",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px"
              },
              {
                "key": "DelegateEmail",
                "data-buildertype": "input",
                "label": "Delegate''s email address",
                "fluid": true,
                "onChangeTimeout": 200
              },
              {
                "key": "AccessCodeNote",
                "data-buildertype": "input",
                "label": "Survey access code for delegate to use",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px",
                "readOnly": true,
                "placeholder": "(Will be generated automatically by the system)"
              },
              {
                "key": "DelegateValidityStart",
                "data-buildertype": "input",
                "label": "Valid from",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "defaultValue": ""
              },
              {
                "key": "DelegateValidityEnd",
                "data-buildertype": "input",
                "label": "Valid until",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime"
              },
              {
                "key": "DelegateComments",
                "data-buildertype": "textarea",
                "label": "Comments  (optional)",
                "fluid": true,
                "rows": "3",
                "autoHeight": true,
                "style-width": "100%"
              },
              {
                "key": "staticcontent_4",
                "data-buildertype": "staticcontent",
                "content": "<hr/>",
                "isHtml": true
              },
              {
                "key": "message_1",
                "data-buildertype": "message",
                "header": "Delegation Code Required",
                "content": "Please provide your delegation code to authorise the delegation or view the delegation history. Please note that this is the delegation code you were previously sent and NOT your CorpPass or SingPass password and NOT the access code the delegate will use to answer the survey.",
                "info": false,
                "positive": false,
                "negative": true
              },
              {
                "key": "DelegateFromName",
                "data-buildertype": "input",
                "label": "Your name",
                "fluid": true,
                "onChangeTimeout": 200,
                "style-width": "400px"
              },
              {
                "key": "DelegateCode",
                "data-buildertype": "input",
                "label": "Your delegation code",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "password",
                "style-width": "400px"
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btnDelegate",
                    "data-buildertype": "button",
                    "content": "Delegate",
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "delegate"
                        ],
                        "targets": [
                          "delegateModal"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btnCancelDelegate",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeDelegateModal"
                        ],
                        "targets": [
                          "delegateModal"
                        ],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btnDelegationHistory",
                    "data-buildertype": "button",
                    "content": "Delegation History",
                    "floated": "right",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "openDelegateHistoryModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": false,
                    "secondary": true
                  }
                ],
                "style-marginTop": "20px"
              }
            ]
          }
        ],
        "primary": false
      },
      {
        "key": "accessCodeModal",
        "data-buildertype": "swzmodal",
        "style-display": "block",
        "content": "accessCodeModal",
        "secondary": true,
        "children": [
          {
            "key": "formgroup_1",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Access Code Required",
                "size": "medium",
                "textAlign": "left"
              },
              {
                "key": "staticcontent_3",
                "data-buildertype": "staticcontent",
                "content": "This survey is protected. Please enter the survey specific access or delegation code to access this survey. ",
                "style-marginBottom": "20px"
              },
              {
                "key": "AccessCode",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "password",
                "style-width": "400px",
                "style-marginTop": "",
                "style-marginBottom": "20px"
              },
              {
                "key": "container_9",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "btn_SubmitAccessCode",
                    "data-buildertype": "button",
                    "content": "Ok",
                    "primary": true,
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "submitAccessCode"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  },
                  {
                    "key": "btn_CancelAccessCode",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeAccessCodeModal"
                        ],
                        "targets": [
                          "accessCodeModal"
                        ],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginTop": "",
                "style-marginBottom": ""
              }
            ]
          }
        ]
      },
      {
        "key": "container_8",
        "data-buildertype": "container",
        "children": [
          {
            "key": "ExcelFileUpload",
            "data-buildertype": "input",
            "label": "",
            "fluid": true,
            "onChangeTimeout": 200,
            "type": "file",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "excelFileUploaded"
                ],
                "targets": [],
                "parameters": []
              },
              "onClick": {
                "active": false,
                "actions": [],
                "targets": [],
                "parameters": []
              }
            },
            "customPostUrl": ""
          }
        ],
        "style-hidden": true
      },
      {
        "key": "fileUploadModal",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "content": "fileUploadModal",
        "children": [
          {
            "key": "container_4",
            "data-buildertype": "container",
            "style-marginTop": "",
            "style-marginBottom": "",
            "style-source": "",
            "children": [
              {
                "key": "header_4",
                "data-buildertype": "header",
                "content": "Upload survey response as an Excel file",
                "size": "medium",
                "subheader": "",
                "textAlign": "left"
              },
              {
                "key": "container_5",
                "data-buildertype": "container",
                "style-marginBottom": "20px",
                "children": [
                  {
                    "key": "staticcontent_1",
                    "data-buildertype": "staticcontent",
                    "content": "After upload the survey will open for validation and editing. <br/>\n<br/>\nPlease select the form in which to open the survey:",
                    "isHtml": true
                  },
                  {
                    "key": "UploadFormChoice",
                    "data-buildertype": "dropdown",
                    "label": "Dropdown",
                    "fluid": true,
                    "selection": true,
                    "data-elements": []
                  }
                ]
              },
              {
                "key": "container_6",
                "data-buildertype": "container",
                "style-marginBottom": "",
                "children": [
                  {
                    "key": "staticcontent_2",
                    "data-buildertype": "staticcontent",
                    "content": "Click \"Upload Excel Response\" below to select a file to upload. <br/>\nUpload will commence immediately and if successful the survey will open for you to finalise and submit.\n<br/>\n<br/>",
                    "isHtml": true
                  }
                ]
              },
              {
                "key": "container_7",
                "data-buildertype": "container",
                "style-marginTop": "20px",
                "style-source": "text-align: right;",
                "children": [
                  {
                    "key": "UploadExcelButton",
                    "data-buildertype": "button",
                    "content": "Upload Excel Response",
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "promptForExcelFile"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "btn_CancelUpload",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeFileUploadModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginBottom": ""
              }
            ]
          }
        ]
      },
      {
        "key": "fileDownloadModal",
        "data-buildertype": "swzmodal",
        "secondary": true,
        "content": "fileDownloadModal",
        "children": [
          {
            "key": "container_13",
            "data-buildertype": "container",
            "style-marginTop": "",
            "style-marginBottom": "",
            "style-source": "",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Downloads",
                "size": "medium",
                "subheader": "",
                "textAlign": "left"
              },
              {
                "key": "container_14",
                "data-buildertype": "container",
                "style-marginBottom": "20px",
                "children": [
                  {
                    "key": "staticcontent_6",
                    "data-buildertype": "staticcontent",
                    "content": "Please select a file to download:",
                    "isHtml": true
                  },
                  {
                    "key": "fileDropDown",
                    "data-buildertype": "dropdown",
                    "label": "Dropdown",
                    "fluid": true,
                    "selection": true,
                    "data-elements": []
                  }
                ]
              },
              {
                "key": "container_16",
                "data-buildertype": "container",
                "style-marginTop": "20px",
                "style-source": "text-align: right;",
                "children": [
                  {
                    "key": "btnDownload",
                    "data-buildertype": "button",
                    "content": "Download",
                    "style-marginRight": "20px",
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "onDownloadClick"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "primary": true
                  },
                  {
                    "key": "button_2",
                    "data-buildertype": "button",
                    "content": "Cancel",
                    "secondary": true,
                    "events": {
                      "onClick": {
                        "active": true,
                        "actions": [
                          "closeFileDownloadModal"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-marginBottom": ""
              }
            ]
          }
        ],
        "events": {}
      },
      {
        "key": "delegateHistoryModal",
        "data-buildertype": "swzmodal",
        "content": "delegateHistoryModal",
        "style-display": "block",
        "events": {},
        "children": [
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_7",
                "data-buildertype": "header",
                "content": "Delegation History",
                "size": "medium",
                "textAlign": "left",
                "style-source": "float:left;"
              },
              {
                "key": "buttonCloseDelegateListModal",
                "data-buildertype": "button",
                "content": "Close",
                "primary": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "closeDelegateHistoryModal"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "right",
                "style-marginLeft": "10px"
              },
              {
                "key": "RevokeAllDelegation",
                "data-buildertype": "button",
                "content": "Revoke All Delegation",
                "primary": false,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "confirm",
                      "revokeAllDelegation"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "floated": "right",
                "secondary": true,
                "style-hidden": false
              }
            ]
          },
          {
            "key": "gridDelegation",
            "data-buildertype": "gridview",
            "columns": [
              {
                "key": "CreatedDate",
                "name": "Delegation Date",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "FromName",
                "name": "From",
                "resizable": true,
                "sortable": true,
                "filterable": false,
                "width": 100
              },
              {
                "key": "Name",
                "name": "Delegate To",
                "sortable": true,
                "filterable": false,
                "resizable": true
              },
              {
                "key": "ValidityStart",
                "name": "Validity Start",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "ValidityEnd",
                "name": "Validity End",
                "sortable": true,
                "filterable": false,
                "resizable": true,
                "type": "datetime"
              },
              {
                "key": "Comments",
                "name": "Comments",
                "resizable": true,
                "sortable": true,
                "filterable": false,
                "type": "custom",
                "width": 100
              },
              {
                "key": "Status",
                "name": "Status",
                "sortable": true,
                "filterable": false,
                "resizable": false,
                "width": "",
                "type": ""
              },
              {
                "key": "Revoke",
                "name": "Revoke",
                "type": "custom",
                "sortable": false,
                "filterable": false,
                "resizable": false,
                "width": ""
              }
            ],
            "autoHeight": false,
            "events": {},
            "pagerType": "",
            "defaultSort": "CreatedDate DESC",
            "rowKey": "CreatedDate",
            "style-marginTop": "80px",
            "rowHeight": "80"
          }
        ],
        "compact": true,
        "secondary": true
      }
    ],
    "events": {}
  }
]' WHERE [Id]='d6e12e1d-3384-4352-bf68-8210aa75d406';

