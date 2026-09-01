{
    init: function (args) {
        
        Utils.getRequest("/dataeditor/mydeployments").then(
            response => {
                const deploymentList = response.item.map(
                    dply => ({ key: dply.dplyId, value: dply.dplyId, text: dply.name }));
                Utils.rewriteDropdown("SelectDeployment", deploymentList, args.data.Id);
            }, reason => {
                console.error("Failed to load deployment list for editor", reason);
            }
        );
        
        const redirectToSurvey = function(dlsi, formName, respId, viewMode) {
            const pathPrefix = viewMode ? "view/" : "";
            const path = (respId)
                ? pathPrefix + "respid/" + encodeURIComponent(respId) + "/dlsi/"+ encodeURIComponent(dlsi)
                : pathPrefix + "dlsi/"+ encodeURIComponent(dlsi);
            CloverApp.API.redirect("form", formName, path);    
        };

        if(args.data.IsAnonymous){
            dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
        }
        
        const innerArgs = args; //Used in column formatters
        const iconBtnClass = "ui icon button mini secondary";
        const iconBtnDisabledClass = "ui icon button mini disabled";
        
        const popupProps = { size:'mini', on:'hover', position:'top right'};
        const styleInlineBlock = { style:{display:"inline-block"}};

        const CLEARED = '129C7781-536D-42F6-ACA4-33A62F2E2C1F'.toLowerCase();

        const genFormLinkButtons = function(p, elements, languages, formName, index){
            const dlsi = p.row.Id;
            const isMultipleResponse = !!innerArgs.data.IsMultipleResponse;
            const isAnonymous = !!innerArgs.data.IsAnonymous;
            
            const formControls = [];
            
            //Render new response button for multiple response surveys
            if(isMultipleResponse || isAnonymous) {
                const status = p.row.Status ? p.row.Status.toLowerCase() : "";
                const responseNotCleared = (status!==CLEARED);
                
                const showActionAdd = responseNotCleared;
                if( showActionAdd ) {
                    const addResponseAction = () => { createNewResponseAndOpen(dlsi, formName); };
                    formControls.push(
                        CloverApp.API.createElementWithPopup("Add New Response", popupProps,
                            CloverApp.API.createElement("span", { onClick: addResponseAction, className: "link-style", style: { color: "green"/*, paddingRight: "0.5em"*/ } },
                            [
                                CloverApp.API.createElement("i", {className: "plus icon", ariaHidden: "true" }, "")
                            ]))
                    );
                }
            }
            
            //Render Form link
            const editSurveyAction = () => { redirectToSurvey(dlsi, formName, p.row.RespId, false); };
            const viewSurveyAction = () => { redirectToSurvey(dlsi, formName, p.row.RespId, true); };
            
            formControls.push( 
                CloverApp.API.createElementWithPopup("Edit Response", popupProps,
                    CloverApp.API.createElement("span", { onClick: editSurveyAction, className: "link-style" }, 
                    [
                        languages[index], 
                        CloverApp.API.createElement("i", {className: "edit icon", ariaHidden: "true", style: { paddingLeft: "0.5em" } }),
                    ])),
                
                CloverApp.API.createElementWithPopup("View Response", popupProps,
                    CloverApp.API.createElement("span", { onClick: viewSurveyAction, className: "link-style", style: { /*color: "red",*/ paddingLeft: "0.5em" } },
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
        };

        const createNewResponseAndOpen = function(dlsi, formName) {
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/dataeditor/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen

        const showRemarksModal = function (args, id) {
            var formData = new FormData();
            formData.append('id', id);
            CloverApp.API.setDataField("dlsi", id); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    //args.component.state.data.remarks = response.item;
                    CloverApp.API.setDataField("remarks", response.item);
                    args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                    args.controlRef.refs.remarksModal.openModal();
                }, reason => {
                    console.error("Failed to retrieve remarks", reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        };
        
        const showRejectResponseModal = function (args, id, respId) {
            var formData = new FormData();
            formData.append('id', id);
            CloverApp.API.setDataField("dlsi", id);
            CloverApp.API.setDataField("RejectResponseRespId", respId); 
            CloverApp.API.setDataField("RejectResponseIsSendEmail", 1);
            CloverApp.API.setDataField("RejectResponseMessage","");
            Utils.queueHideControl("RejectResponseMessage","show");
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    CloverApp.API.setDataField("RejectResponseRemarks",response.item);
                    args.controlRef.refs.mdl_RejectResponse.props.swzData.isOpen = true;
                    args.controlRef.refs.mdl_RejectResponse.openModal();
                }, reason => {
                    console.error("Failed to retrieve remarks for Reject Response modal", reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        };
        
        const showUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                model.customPostUrl = "/dataedit/upload/xlsx?" + new URLSearchParams( { qnnId, dplyId, listSampleId } );
                model.onUploadBegin = () => Utils.loadingStart("Uploading response...");
                model.onUploadEnd = (ctrl, success, xhr, msg, err) => {
                  Utils.loadingStop();
                  if(!success) {
                      console.error("Upload failed", xhr, msg, err);
                      if(xhr.status=== 400) {
                          alertify.error( Utils.encodeHTML("Upload Failed - " + xhr.statusText + " - " + xhr.responseText), 15000);
                      } else if(xhr.status===413) {
                          alertify.error("Upload Failed - the selected file is too large to be uploaded here", 15000);
                      } else {
                          alertify.error( Utils.encodeHTML("Upload Failed - " + msg + " - " + err), 15000);
                      }
                  }
                };
                console.log("rewrote model",model);
            });
            
            CloverApp.API.setDataField("UploadQnnId", qnnId);
            CloverApp.API.setDataField("UploadDplyId", dplyId);
            CloverApp.API.setDataField("UploadListSampleId", listSampleId);
            CloverApp.API.setDataField("UploadIndex", index);
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
            
            innerArgs.component.refs.fileUploadModal.openModal();
        }; //end of showUploadModal
   
        const showTrkListModal = function (args, UID, Email, Name, Remarks, Status, StatusTitle) {
            //console.log('showTrkListsModal args: ', args);
            CloverApp.API.setDataField("dictionaryTrkList", null);  
            CloverApp.API.setDataField("trkListSample_uid", Utils.encodeHTML(UID));
            CloverApp.API.setDataField("trkListSample_email", Utils.encodeHTML(Email));  
            CloverApp.API.setDataField("trkListSample_name", Utils.encodeHTML(Name));              
            CloverApp.API.setDataField("trkListSample_remarks", Utils.encodeHTML(Remarks));
            CloverApp.API.setDataField("trkListSample_status", Utils.encodeHTML(Status));       
            CloverApp.API.setDataField("trkListSample_statusTitle", Utils.encodeHTML(StatusTitle));

            args.controlRef.refs.trkListModal.props.swzData.isOpen = true;
            args.controlRef.refs.trkListModal.openModal();

            var formData = new FormData();
            formData.append('uid', UID);    
            Utils.loadingStart("Retrieving Track List Information");
            Utils.postFormRequest("/dataeditor/gettrklistsbyuid", formData).then(
                response => {
                    if(response.item) {
                        CloverApp.API.setDataField("dictionaryTrkList", response.item);   
                    }
                }, reason => {
                    console.error("Failed to retrieve track list", reason);
                    alertify.error( Utils.encodeHTML(reason) );
                    args.controlRef.refs.trkListModal.close();
                }
            ).finally(Utils.loadingStop);  
        };

        const openDelegateHistoryModal = function (args, dlsi) {
            CloverApp.API.setDataField('gridDelegate', null);
            var url = '/dataeditor/viewdelegatelist?dlsi=' + dlsi;
            $.get(url).done(function (data) {
            if(data.success){
                CloverApp.API.setDataField('gridDelegate', data.item);
                args.controlRef.refs.delegateHistoryModal.openModal();
                args.component.refs.gridDelegate.refresh();
            } else
                alertify.error( Utils.encodeHTML(data.message) );
            }).fail(function (jqxhr, textStatus, error) {
                console.log(textStatus);
            });
        };

        //just used by Exempt button right now
        const setStatus = function (args, id, statusId, message) {
            if(!message) {
                message = { parameters: { 
                    confirmTitle: "setStatusConfirmTitle", 
                    confirmText: "setStatusConfirmText"
                } };
            }
            CloverApp.API.confirm(message?message:args).then(()=> {
                var formData = new FormData();
                formData.append('id', id);        
                formData.append('selectedStatusId', statusId);
                Utils.loadingStart("Setting Status");
                Utils.postFormRequest("/dataeditor/setStatus", formData).then(
                    response => {
                        args.component.refs.grid.refresh();
                        alertify.success( Utils.encodeHTML(response.message) );
                    }, reason => {
                        console.error("Failed to set status", reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                ).finally(Utils.loadingStop);
            }).catch(()=>{/*Empty catch to avoid error show at the console*/})
        };
        
        //used by Reset
        const resetStatus = function (args, id, respId) {
            const message = { 
                parameters: { 
                    confirmTitle: "resetResponseConfirmTitle", 
                    confirmText: "resetResponseConfirmText", 
                    confirmOk: "resetResponseConfirmOk"
            } };
            CloverApp.API.confirm(message).then(()=> {
                var formData = new FormData();
                formData.append('id', id);
                if(respId){
                    formData.append('respId', respId);                
                }
                Utils.loadingStart("Resetting Status");
                Utils.postFormRequest("/dataeditor/resetStatus", formData).then(
                    response => {
                        args.component.refs.grid.refresh();     
                        alertify.success( Utils.encodeHTML(response.message) );
                        if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
                            dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
                        }
                    }, reason => {
                        console.error("Failed to reset status", reason);
                        alertify.error( Utils.encodeHTML(reason), 20000 );
                    }
                ).finally(Utils.loadingStop);
            }).catch(()=>{ /*Empty catch to avoid error show at the console*/})
        }; 
         
        const remarksPreview = function(text) {
            const previewLength = 32;
            return '"' + (text.length<=previewLength ? text : text.substring(0,previewLength)+"...") + '"';
        } ;
        
        const remarksFormatter = function (p) {
            const hasRemarks = (p.row.Remarks!=null);
            const iconClass = hasRemarks 
                ? 'comments outline icon' 
                : 'comment outline icon';
            const tooltip = hasRemarks 
                ? 'View/Edit Remarks'+remarksPreview(p.row.Remarks)
                : 'Set Remarks';
            const icon = CloverApp.API.createElement("i", {className: iconClass, ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { onClick: () => showRemarksModal(innerArgs, p.row.Id), className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup(tooltip, popupProps, btn);
        };

        const exemptFormatter = function (p) {
            const exemptStatusGUID = '9731DE1D-2B6A-484C-BF10-44F842A3140E';
            const icon = CloverApp.API.createElement("i", {className: "cut icon",ariaHidden: "true" }, "");
            const btnText = "Set Exempt Status";
            let element;
            if(p.row.StatusCode=='PE'){
                const exemptMessage = { parameters: { 
                    confirmTitle: "exemptConfirmTitle", 
                    confirmText: "exemptConfirmText",
                    confirmOk: "exemptConfirmOk"
                } };
                const btn = CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, exemptStatusGUID, exemptMessage), className: iconBtnClass }, icon);
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }      
            
            return element;
        };

        const resetFormatter  = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "undo icon",ariaHidden: "true" }, "");
            const btnText = "Reset Response";
            let element;
            if(p.row.StatusCode=='DE' || p.row.StatusCode=='SB' || p.row.StatusCode=='CL' || (p.row.DateStart != null && p.row.StatusCode=='PE')){
                const btn = CloverApp.API.createElement("button", { onClick: () => resetStatus(innerArgs, p.row.Id, p.row.RespId), className: iconBtnClass },icon);
                element = CloverApp.API.createElementWithPopup(btnText,popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass },icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText,popupProps, container);
            }
            return element;
        }; 
        
        const rejectFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "thumbs down outline icon",ariaHidden: "true" }, "");
            const btnText = "Reject Response";
            let element;
            if(p.row.StatusCode=='SB'){
                const btn = CloverApp.API.createElement("button", { onClick: () => showRejectResponseModal(innerArgs, p.row.Id, p.row.RespId), className: iconBtnClass }, icon);
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn);//For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }  
            return element;
        };

        const trackFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "ban icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { 
                onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.ToEmails, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), 
                className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup("Track List", popupProps, btn);
        };
        
        const delegateHistoryFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "history icon",ariaHidden: "true" }, "");
            if(innerArgs.data.RequireAccessCode) {
                const btn = CloverApp.API.createElement("button"
                    ,{ onClick: () => openDelegateHistoryModal(innerArgs, p.row.Id), className: iconBtnClass }
                    , icon);
                
                return CloverApp.API.createElementWithPopup("Delegation History", popupProps, btn);
            } else { 
                return CloverApp.API.createElement("span", {}, "");
            }
        }; //end of DelegateHistoryFormatter

        //Excel Response upload button
        const excelUploadFormatter = function (p) {
            const isOnlineSurvey = ("O"===p.row.Type) && !!p.row.FormNames;
            const hasFiles = isOnlineSurvey && ( (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null) && (""!==p.row.FileLanguages));
            const alwaysShowForDataEditor = true;
            const showUploadButtonInAppropriateStatus = isOnlineSurvey && (hasFiles || alwaysShowForDataEditor);
            if(showUploadButtonInAppropriateStatus) {
                const uploadIcon = CloverApp.API.createElement("i", {className: "file excel outline icon",ariaHidden: "true" }, "");
                //const uploadIcon = CloverApp.API.createElement("i", {className: "upload icon",ariaHidden: "true" }, "");
                const excelEnabledForDply = true; //was innerArgs.data.IsExcelEnabled;
                const uploadButtonText = "Upload Response from Excel";
                if(!excelEnabledForDply && !alwaysShowForDataEditor) {
                    const blank = CloverApp.API.createElement("div", {}, "");
                    return blank;
                } else if( (p.row.StatusCode=="PE" || p.row.StatusCode=="DE") ) {
                    //Upload option is available for Pending and In-Progress
                    const formNames = p.row.FormNames.split('||'); //used for form selection after upload
                    const languages = p.row.Languages.split('||'); 
                    const btn = CloverApp.API.createElement("button", { 
                            onClick: () => showUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id),
                            className: iconBtnClass, style:{marginBottom:"2.75px"}}, uploadIcon);
                            
                    const popup = CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, btn);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  popup); //For disabled component, require a div to cover in order to show the popup.
                    
                    return container;
                } else {
                    const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, uploadIcon);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  btn);
                    const popup=CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, container);
                    
                    //Show a disabled button for other status 
                    return popup;
                }
            }     
        }

        const allActionsFormatter = function (p) {
            const statusText = p.row.StatusTitle;
            const isAnonymousRespondent = ("swzanonymous"===p.row.UID);
            
            const elements = [];
            //Status actions
            
            if(!isAnonymousRespondent) {
                const statusBtn = CloverApp.API.createElement("button", { 
                        onClick: () => dataeditordeploymentUserActions.showStatusModal(innerArgs, p.row.Id), 
                        className: "ui button mini secondary invert", 
                        style: { minWidth: "100px" }, 
                    },statusText);
                elements.push(statusBtn);
            }
            
            const statusActions = [];
            statusActions.push(resetFormatter(p));
            if(!isAnonymousRespondent) {
                statusActions.push(rejectFormatter(p));
                statusActions.push(exemptFormatter(p));
            }
            elements.push( CloverApp.API.createElement("div", {style:{marginTop:"4px"} },statusActions ) );
            
            //console.log("elements", elements, isAnonymousRespondent);
            
            
            //Other actions
            const otherActions = [];
            otherActions.push(excelUploadFormatter(p));
            if(!isAnonymousRespondent){
                otherActions.push(trackFormatter(p));
            }
            otherActions.push(remarksFormatter(p));
            otherActions.push(delegateHistoryFormatter(p));
            elements.push( CloverApp.API.createElement("div", {style:{marginTop:"4px"} },otherActions ) );
            
            return elements;
        };
        
        const uploadedExcelLinksFormatter = function (p) {
            const elements = [];

            //Response download link
            if(p.row.IsExcelResponse) {
                const responseLinkText = dayjs(p.row.ExcelUploadDate).format("DD MMM YYYY HH:mm");// + (p.row.IsExcelResponseDE ? " (DE)" : "");
                const downloadUrl = "/dataedit/download/response/" + p.row.Id + "/" + p.row.RespId;
                const downloadLinkBtn = [];
                const linkBtn = CloverApp.API.createElement("a", 
                    { href: downloadUrl, target: "_blank", style: {fontStyle: "italic"}},
                    responseLinkText);    
                    downloadLinkBtn.push(linkBtn);
                if(p.row.IsExcelResponseDE){
                    element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                    downloadLinkBtn.push(element);
                    const dataEditorIcon = CloverApp.API.createElement("i",{className: "edit icon",ariaHidden: "true" }, "");
                    element = CloverApp.API.createElementWithPopup("By Data Editor", popupProps, dataEditorIcon);
                    downloadLinkBtn.push(element);
                }
                
                const marginDiv = CloverApp.API.createElement("div", {style:{marginTop:"4px"} },downloadLinkBtn );      
                elements.push(marginDiv);
                
            }
            
            if(elements.length===0) {
                elements.push( CloverApp.API.createElement("div", {}, p.value) );
            }
            return elements;
        }; //end of xlsxActionsFormatter

        const uidNameFormatter = function(p) {
            //console.log(p.row);
            if(p.row.RespId) {
                const popupProps = { size:'mini', on:'hover', position:'top right'};
                const respSummaryAction = () => { CloverApp.API.redirectToForm("RespSummary", p.row.RespId); };
                return CloverApp.API.createElementWithPopup("View response details", popupProps,
                    CloverApp.API.createElement("span", { onClick: respSummaryAction, className: "link-style" }, 
                    [
                        p.value, 
                        CloverApp.API.createElement("i", {className: "search icon", ariaHidden: "true", style: { paddingLeft: "0.5em" } }),
                    ]));
            } else {
                return CloverApp.API.createElement("div", {}, p.value ); 
            }
        };
        const formNamesFormatter = function (p) {
            var elements = [];
            if(p.row.Type=="O"){
                var strFormNames = p.row.FormNames;
                var strLanguages = p.row.Languages;
                var formNames = strFormNames.split('||');
                var languages = strLanguages.split('||');      
                
                //formNames.forEach(genFormLinks.bind(null, p, elements, languages));
                formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));

                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, p.value); 
            }    
        }; //end of formNamesFormatter

        const fileNamesFormatter = function(p) {
            //const isExcelEnabled = innerArgs.data.IsExcelEnabled;
            const isExcelEnabled = true;
            if(p.row.Type=="O" && isExcelEnabled){
                var elements = [];
                var element;
                if(p.row.FileLanguages) {
                    const fileNames = p.row.FileNames.split('||');
                    const fileLanguages = p.row.FileLanguages.split('||');
                    const fileTokens = p.row.FileTokens.split('||');   
                    for(var i=0; i < fileNames.length; i++) {
                        const token = fileTokens[i];
                        const linkUrl = "/dataedit/download/xlsx/" + p.row.Id + "/"  + token + "/" + p.row.RespId;
                        element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);            
                        elements.push(element);
                        element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                        elements.push(element);
                        elements.push( CloverApp.API.createElement("br") );
                    }
                }
                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }  
        }; //end of FileNamesFormatter
        
        //origin indicators
        const initialResponseFormatter  = function (p) {
            
            //todo - define style in .css file as a class
            const attrAs =  { className: "ui label tiny", style: { margin: "2px", background: "#defffc" } };
            const attrBy =  { className: "ui label tiny", style: { margin: "2px", background: "#fffae0" } };
            const attrVia = { className: "ui label tiny", style: { margin: "2px", background: "#f0ffab" } };
            
            const elements = [];
            if(p.row.InitialResponseAs !== "Unknown" && p.row.InitialResponseAs !== "PrePopulated" && p.row.InitialResponseAs !== null){
                const iniResponseAs = CloverApp.API.createElement("div", attrAs, p.row.InitialResponseAs);
                elements.push(iniResponseAs);
            }
            
            if(p.row.InitialResponseBy !== "Unknown" && p.row.InitialResponseBy !== null){
                const iniResponseBy = CloverApp.API.createElement("div", attrBy, p.row.InitialResponseBy);
                elements.push(iniResponseBy);
            }
            
            if(p.row.Tags !== null && p.row.Tags !== '[]' && p.row.Tags !== undefined && p.row.Tags !== 'undefined' && p.row.Tags !== 'null'){
                var tags = JSON.parse(p.row.Tags);
                let tagsLabel = new Array();
                if(tags.length > 3) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label tiny", style: {margin: "2px"}}, tags.length));
                } else {
                    for(x=0;x<tags.length;x++) {
                        tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label tiny", style: {margin: "2px"}}, tags[x]));
                    }
                }
                elements.push(CloverApp.API.createElement("div", {title: tags, className:"react-grid-Cell-Comments"}, tagsLabel)); 
            }
            
            // via is hidden since we only have online now
            /*if(p.row.InitialResponseVia !== "Unknown" && p.row.InitialResponseVia !== null){
                const iniResponseVia = CloverApp.API.createElement("div", attrVia, p.row.InitialResponseVia);
                elements.push(iniResponseVia);
            }*/
            return elements;
            
        };  

        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                cols.UIDName.customFormatter = uidNameFormatter;
                cols.FormNames.customFormatter = formNamesFormatter;
                cols.FileNames.customFormatter = fileNamesFormatter;
                cols.InitialResponse.customFormatter = initialResponseFormatter;
                cols.ExcelSupport.customFormatter = uploadedExcelLinksFormatter; 
                cols.StatusTitle.customFormatter = allActionsFormatter; 
                
            }
            return model;
        }; //end of gridModelRewriter

        args.data.remarks = null;
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    }, //end of init...........................................................
    
    getAnonymousSampleInfo: function(args){
        var anonymousFormData = new FormData();
        anonymousFormData.append('dplyid',args.data.Id);
        Utils.loadingStart();
        Utils.getRequest("/dataeditor/getanonymoussampleinfo", anonymousFormData)
        .then(response => {
            if(response.success){
                CloverApp.API.setDataField("swzAnonymousDplySampleInfoId", response.item.swzAnonymousSampleInfoId);
                CloverApp.API.setDataField("dlsi", response.item.swzAnonymousSampleInfoId); 
                args.component.refs.btnAnonymousStatus.props.additionalParams.model.content = 'Status: ' + response.item.status;
                args.component.refs.btnAnonymousStatus.forceUpdate();
            }
        }, reason => {
            console.error("Failed to get anonymous sample info", reason);
            alertify(reason);
        }).finally(Utils.loadingStop);
    },
    
    showStatusModal: function (args, id) {
        const innerArgs = args; //Used in column formatters
        var formData = new FormData();
        if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
            id = args.data.swzAnonymousDplySampleInfoId;
        }
        
        formData.append('id', id);   
        CloverApp.API.setDataField("dlsi", id); 
        Utils.loadingStart("Retrieving Status Options");
        Utils.postFormRequest("/dataeditor/GetStatusItems", formData).then(
            response => {
                //args.state.app.extra.spData = id;
                //args.component.state.model[1].children[1].children[0]["data-elements"] = response.item;
                const options = response.item;
                if(Array.isArray(options) && options.length>0) {
                    CloverApp.API.changeModelControl(innerArgs, "dropdownStatus","data-elements", options);
                    CloverApp.API.setDataField("dropdownStatus", null);
                } else {
                    CloverApp.API.changeModelControl(innerArgs, "dropdownStatus","data-elements", {} );
                    CloverApp.API.setDataField("dropdownStatus", null);
                }
                
                args.component.refs.statusModal.props.swzData.isOpen = true;
                args.component.refs.statusModal.openModal();
                
                args.component.refs.dropdownStatus.forceUpdate();
                
            }, reason => {
                console.error("Failed to get status items", reason);
                alertify.error( Utils.encodeHTML(reason) );
                args.component.refs.statusModal.close();
            }
        ).finally(Utils.loadingStop);
    },
        
    addToTrkList: function (args) {

        var formData = new FormData();
        formData.append('uid', args.data.trkListSample_uid);
        formData.append('email', args.data.trkListSample_email);
        formData.append('name', args.data.trkListSample_name);
        formData.append('remarks', args.data.trkListSample_remarks);
        formData.append('status', args.data.trkListSample_status);
        formData.append('trkListIds', args.data.dictionaryTrkList);
        
        var url = '/dataeditor/settrklists';
        
        Utils.loadingStart("Updating Track List");
        Utils.postFormRequest(url, formData).then(
            response => {
                if (response.success) {
                    args.component.refs.grid.refresh();  
                    args.component.refs.trkListModal.close();
                    alertify.success( Utils.encodeHTML(response.message) );
                    CloverApp.API.setDataField("dictionaryTrkList", null);  
                    CloverApp.API.setDataField("trkListSample_uid", null);
                    CloverApp.API.setDataField("trkListSample_email", null);    
                    CloverApp.API.setDataField("trkListSample_name", null);                 
                    CloverApp.API.setDataField("trkListSample_remarks", null);
                    CloverApp.API.setDataField("trkListSample_status", null);       
                    CloverApp.API.setDataField("trkListSample_statusTitle", null);        
                } else {
                    alertify.error( Utils.encodeHTML(response.message) );
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(()=>{       
                Utils.loadingStop();
            });
    },    
    
    setStatusAsync: function (args) {
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        //console.log('selectedStatusId', selectedStatusId);
        if(selectedStatusId === undefined || selectedStatusId === null){
            alertify.error('Please select a status.');
            return;
        }
        
        formData.append('id', args.data.dlsi);        
        formData.append('selectedStatusId', selectedStatusId);
        
        var url = '/dataeditor/setStatus';
        
        Utils.loadingStart("Updating status...");
        Utils.postFormRequest(url, formData).then(
            response => {
                if (response.success) {
                    args.component.refs.statusModal.close();
                    args.component.refs.grid.refresh();
                    
                    if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
                        dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
                    }
                
                } else {
                    alertify.error( Utils.encodeHTML(response.message) );
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
    },
    
    submitRemarks: function (args) {
        const modal = args.component.refs.remarksModal;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);
        formData.append("remarks", args.data.remarks ? args.data.remarks.trim() : "");
        Utils.loadingStart("Updating Remarks");
        Utils.postFormRequest("/dataeditor/setremarks", formData).then(
            response => {
                modal.close();
                alertify.success( Utils.encodeHTML(response.message) );
                grid.refresh();
            }, reason => {
                console.error("Failed to update remarks.", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    promptForExcelFile: function(args) {
        const file = $("input[name='ExcelFileUpload']");
        file.trigger('click');
        return {};
    },
    
    excelFileUploaded: function(args) {
        const result = args.sourceControlValue; //ExcelFileUpload
        CloverApp.API.setDataField("ExcelFileUpload", null); 
        if(result === "OK") {
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
            const uploadIndex = args.data.UploadIndex;
            args.component.refs.grid.refresh();
            alertify.success("Survey answers updated from file");
            if(formName) {
                CloverApp.API.redirect("form", formName, 'dlsi/'+ uploadIndex);
            }
        } else {
            let errorMessage = result;
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
            } else if ("INCORRECT UEN" === result) {
                errorMessage = "This file is for another respondent. The UEN recorded in the spreadsheet does not match your UEN.";
            }
            alertify.error( Utils.encodeHTML(errorMessage), 10000);
        }
        return {};
    }, //end of excelFileUploaded
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    rejectResponse: function(args) {
        const isSendEmail = Boolean(args.data.RejectResponseIsSendEmail);
        const messageToRespondent = (isSendEmail && args.data.RejectResponseMessage) ? args.data.RejectResponseMessage.trim() : "";

        const remarks = args.data.RejectResponseRemarks ? args.data.RejectResponseRemarks.trim() : "";
        // if(""===remarks) {
        //     alertify.error("Remarks are required here", 15000);
        //     return {};
        // }
        
        const modal = args.component.refs.mdl_RejectResponse;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);  
        formData.append("respId", args.data.RejectResponseRespId);
        formData.append("isSendEmail", isSendEmail)
        formData.append("messageToRespondent", messageToRespondent );
        formData.append("remarks", remarks );
        console.log("isSendEmail",isSendEmail);
        Utils.loadingStart("Rejecting Response");
        Utils.postFormRequest("/dataeditor/rejectresponse",formData).then(
            response => {
                modal.close();
                grid.refresh();
                alertify.success( Utils.encodeHTML(response.message), 10000);
            }, reason => {
                console.error("Error rejecting response", reason);
                alertify.error( Utils.encodeHTML(reason), 15000);
                grid.refresh();
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeDelegateHistoryModal: function(innerArgs){
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
    onChangeSearch: function(args) {
        const caseSearch = args.data.CaseSearch ? args.data.CaseSearch : null;
        const generalSearch = args.data.GeneralSearch ? args.data.GeneralSearch : null;
        const selectedStatus = args.data.dictStatus && args.data.dictStatus.length>0 ? args.data.dictStatus : null;
        const filterComplete = args.data.dropdownComplete ? args.data.dropdownComplete : null;
        var filterArr = [];
        
        if(caseSearch) {
            filterArr.push({
                column: "UID",
                term: "like",
                value: caseSearch
            });
        }
        
        if(generalSearch) {
            filterArr.push({
                column: "UIDName, UpdatedBy, StatusTitle, ToEmails, InitialResponseAs, InitialResponseBy, InitialResponseVia",
                term: "like",
                value: generalSearch
            });
        }
        
        if(selectedStatus) {
            const tempArr = [];
            for(let i = 0; i < selectedStatus.length; i++){
                tempArr.push(selectedStatus[i]);
            };
            
            filterArr.push({
                column: "Status",
                term: "in",
                value: tempArr
            });
        }

        if(filterComplete) {
            filterArr.push({
               column: "DateComplete",
               nextValue: "",
               term: filterComplete == "true" ? "!=" : "=",
               value: "",
            });
        }
        
        return {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filterArr
                            }
                    }
                }
            }
        };
        
    },
    
    onSelectDeployment: function(args) {
        const dplyId = args.data.SelectDeployment;
        //Utils.redirectToForm("DataEditorDeployment", dplyId);
        location.href = "/form/DataEditorDeployment/" + encodeURIComponent(dplyId);
    },
    
}






