-- Will UPDATE existing row(s) in dwMetadata for the following:
-- AuditTrail-code.js
-- ChoiceCount-code.js
-- DataEditorDeployment-code.js
-- dplyListSample-code.js
-- dplyRecurrence-code.js
-- dplyValidation-code.js
-- QNN_DPLY_PRE_POPULATE-code.js
-- QNN_DPLY-code.js
-- QNN_LIST-code.js
-- QNN_QNN-code.js
-- SwzGlobalMailerMessage-code.js
-- SwzQnnList-code.js
-- UserAccessMatrix-code.js

UPDATE [dwMetadata] SET
[Id]='17feec00-b037-4302-b630-328e430e7d1f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-06-30 17:35:20.063', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 14:28:44.157', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
    },
    
    purgeData: function (args){
        const gridView = args.controlRef;
        Utils.loadingStart();
        Utils.postFormRequest("/audit/purgeauditlog").then(
            response => {
                gridView.refresh();
                alertify.success(response.message);
            }, reason => {
                alertify.error(reason);
                console.log("purgeData error", reason);
            }
        ).finally(Utils.loadingStop);
    },
  
}' WHERE [Id]='17feec00-b037-4302-b630-328e430e7d1f';

UPDATE [dwMetadata] SET
[Id]='bbe4b066-f1b6-4bb0-85a8-6d474bdb7945', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ChoiceCount-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-12-02 15:17:19.097', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 14:55:11.487', 
[Data]=N'{
    
    getCounts: function(args) {
        
        if(!args.data.dplyId){ 
            CloverApp.API.setDataField("dplychoiceqnns", null);
            return;
        }
        
        CloverApp.API.setDataField("dplychoiceqnns", args.data.dplyId);
        
    },
    
    onExport: function(args) {
        const formData = new FormData();
        formData.append(''dplyId'', args.data.dplyId);       
        Utils.loadingStart();
        Utils.postFormRequest("/report/answerchoicecount", formData).then(
            response => {
                const items = response.items;
                let qn_name = items[0]["Name"];
                let qn_count = 1;
                let csv = "No.,Question_Title,Answer_No,Text,Count,Percentage\n";
                items.forEach(function(row) {
                    if (qn_name != row["Name"]) {
                        qn_count ++;
                        qn_name = row["Name"];
                    }
                    const answer_text = ''"'' + row["Text"].trim() + ''"'';
                    csv += `${qn_count},${row["Name"]},${row["AnsVal"]},${answer_text.trim()},${row["AnsCount"]},${row["Percentage"]}`;
                    csv += "\n";
                });
                
                const hiddenElement = document.createElement(''a'');
                hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(csv);
                hiddenElement.target = ''_blank'';
                hiddenElement.download = ''ChoiceCount.csv'';
                hiddenElement.click();
                
                alertify.success("Exported successfully");
            }, reason => {
                console.log("Export error",reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },

}' WHERE [Id]='bbe4b066-f1b6-4bb0-85a8-6d474bdb7945';

UPDATE [dwMetadata] SET
[Id]='4af67164-5e60-4905-9885-afd6da24cb3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 15:16:48.520', 
[Data]=N'{
    init: function (args) {
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi));                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------

        const innerArgs = args; //Used in column formatters
        const iconBtnClass = "ui icon button mini secondary";
        const iconBtnDisabledClass = "ui icon button mini disabled";
        
        const popupProps = { size:''mini'', on:''hover'', position:''top right''};
        const styleInlineBlock = { style:{display:"inline-block"}};

        const CLEARED = ''129C7781-536D-42F6-ACA4-33A62F2E2C1F''.toLowerCase();

        const genFormLinkButtons = function(p, elements, languages, formName, index){
            const dlsi = p.row.Id;
            const isMultipleResponse = !!innerArgs.data.IsMultipleResponse;
            //Render new response button for multiple response surveys
            if(isMultipleResponse && p.row.IsLatestResponse) {
                const status = p.row.Status ? p.row.Status.toLowerCase() : "";
                const thisResponseIsComplete = !!p.row.DateComplete;
                const noIncompleteResponses = (p.row.IncompleteCount===0);
                const responseNotCleared = (status!==CLEARED);
                
                // console.log("inMultipleResponse",isMultipleResponse, "status", status, "thisResponseIsComplete", thisResponseIsComplete, "noIncompleteResponses", noIncompleteResponses, "responseNotCleared", responseNotCleared);
                // console.log("respId,", p.row.RespId, "IncompleteCount", p.row.IncompleteCount);
                
                const showActionAdd = responseNotCleared && thisResponseIsComplete && noIncompleteResponses; 
                if( showActionAdd ) {
                    const onClickNew = () => {
                        createNewResponseAndOpen(dlsi, formName);
                    };
                    elements.push(
                        CloverApp.API.createElement("span", { 
                            onClick: onClickNew  , className: "link-style", style: { color: "green", paddingRight: "0.5em" }
                        },''Add |'')
                    );
                }
            }
            
            //Render Form link
            const onClickForm = () => {
                redirectToSurvey(dlsi, formName, p.row.RespId);
            };
            elements.push(
                CloverApp.API.createElement("span", { onClick: onClickForm  , className: "link-style" }, languages[index])
            );
            elements.push( CloverApp.API.createElement("br") );
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
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen
        
        const genOfflineFormLinks = function(p, elements, languages, value, index){
            var linkUrl = "/dataedit/download/survey/" + p.row.Id + "/"  + value + "/" + p.row.RespId;
            var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);
            elements.push(element);
            element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
            elements.push(element);
            elements.push( CloverApp.API.createElement("br") );
        };

        const showRemarksModal = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    //args.component.state.data.remarks = response.item;
                    CloverApp.API.setDataField("remarks", response.item);
                    args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                    args.controlRef.refs.remarksModal.openModal();
                }, reason => {
                    console.log("Failed to retrieve remarks");
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        };
        
        const showRejectResponseModal = function (args, id, respId) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id);
            CloverApp.API.setDataField("RejectResponseRespId", respId); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    CloverApp.API.setDataField("RejectResponseRemarks",response.item);
                    args.controlRef.refs.mdl_RejectResponse.props.swzData.isOpen = true;
                    args.controlRef.refs.mdl_RejectResponse.openModal();
                }, reason => {
                    console.log("Failed to retrieve remarks for Reject Response modal");
                    alertify.error(reason);
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
                      console.log("Upload failed", xhr, msg, err);
                      if(xhr.status=== 400) {
                          alertify.error("Upload Failed - " + xhr.statusText + " - " + xhr.responseText, 15000);
                      } else if(xhr.status===413) {
                          alertify.error("Upload Failed - the selected file is too large to be uploaded here", 15000);
                      } else {
                          alertify.error("Upload Failed - " + msg + " - " + err, 15000);
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
            //console.log(''showTrkListsModal args: '', args);
            CloverApp.API.setDataField("dictionaryTrkList", null);  
            CloverApp.API.setDataField("trkListSample_uid", UID);
            CloverApp.API.setDataField("trkListSample_email", Email);  
            CloverApp.API.setDataField("trkListSample_name", Name);              
            CloverApp.API.setDataField("trkListSample_remarks", Remarks);
            CloverApp.API.setDataField("trkListSample_status", Status);       
            CloverApp.API.setDataField("trkListSample_statusTitle", StatusTitle);

            args.controlRef.refs.trkListModal.props.swzData.isOpen = true;
            args.controlRef.refs.trkListModal.openModal();

            var formData = new FormData();
            formData.append(''uid'', UID);    
            Utils.loadingStart("Retrieving Track List Information");
            Utils.postFormRequest("/dataeditor/gettrklistsbyuid", formData).then(
                response => {
                    if(response.item) {
                        CloverApp.API.setDataField("dictionaryTrkList", response.item);   
                    }
                }, reason => {
                    console.error("Failed to retrieve track list", reason);
                    alertify.error(reason);
                    args.controlRef.refs.trkListModal.close();
                }
            ).finally(Utils.loadingStop);  
        };

        const showStatusModal = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);   
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
                    
                    args.controlRef.refs.statusModal.props.swzData.isOpen = true;
                    args.controlRef.refs.statusModal.openModal();
                    
                    args.controlRef.refs.dropdownStatus.forceUpdate();
                }, reason => {
                    console.error("Failed to get status items", reason);
                    alertify.error(reason);
                    args.controlRef.refs.statusModal.close();
                }
            ).finally(Utils.loadingStop);
        }; 
        
        const openDelegateHistoryModal = function (args, dlsi) {
            CloverApp.API.setDataField(''gridDelegate'', null);
            var url = ''/dataeditor/viewdelegatelist?dlsi='' + dlsi;
            $.get(url).done(function (data) {
            if(data.success){
                CloverApp.API.setDataField(''gridDelegate'', data.item);
                args.controlRef.refs.delegateHistoryModal.openModal();
                args.component.refs.gridDelegate.refresh();
            } else
                alertify.error(data.message);
            }).fail(function (jqxhr, textStatus, error) {
                console.log(textStatus);
            });
        };  
        
        //used by Exempt
        const setStatus = function (args, id, statusId) {
            var formData = new FormData();
            formData.append(''id'', id);        
            formData.append(''selectedStatusId'', statusId);
            Utils.loadingStart("Setting Status");
            Utils.postFormRequest("/dataeditor/setStatus", formData).then(
                response => {
                    args.component.refs.grid.refresh();
                    alertify.success(response.message);
                }, reason => {
                    console.error("Failed to set status", reason);
                    alertify.error(reason);
                }
            ).finally(Utils.loadingStop);
        };
        
        //used by Reset
        const resetStatus = function (args, id, respId) {
            var formData = new FormData();
            formData.append(''id'', id);
            if(respId){
                formData.append(''respId'', respId);                
            }
            Utils.loadingStart("Resetting Status");
            Utils.postFormRequest("/dataeditor/resetStatus", formData).then(
                response => {
                    args.component.refs.grid.refresh();     
                    alertify.success(response.message);
                }, reason => {
                    console.error("Failed to reset status", reason);
                    alertify(reason);
                }
            ).finally(Utils.loadingStop);
        }; 
         
        const remarksFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: (p.row.Remarks!=null? ''comments'':''comment'') +" outline icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { onClick: () => showRemarksModal(innerArgs, p.row.Id), className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup("Remark", popupProps, btn);
        };
        
        const exemptFormatter = function (p) {
            const exemptStatusGUID = ''9731DE1D-2B6A-484C-BF10-44F842A3140E'';
            const icon = CloverApp.API.createElement("i", {className: "ban icon",ariaHidden: "true" }, "");
            const btnText = "Exempt";
            var element;
            if(p.row.StatusCode==''PE''){
                const btn = CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, exemptStatusGUID), className: iconBtnClass }, icon);
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
            const btnText = "Reset";
            var element;
            if(p.row.StatusCode==''DE'' || p.row.StatusCode==''SB'' || p.row.StatusCode==''CL''){
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
            const icon = CloverApp.API.createElement("i", {className: "cancel icon",ariaHidden: "true" }, "");
            const btnText = "Reject";
            var element;
            if(p.row.StatusCode==''SB''){
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
            const icon = CloverApp.API.createElement("i", {className: "list alternate outline icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { 
                onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.Email, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), 
                className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup("Track", popupProps, btn);
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

        const allActionsFormatter = function (p) {
            const elements = [];
            elements.push(trackFormatter(p));
            elements.push(remarksFormatter(p));
            elements.push(delegateHistoryFormatter(p));
            const allBtn = CloverApp.API.createElement("div", {}, elements);
            return allBtn;
        };
        
        const statusTitleFormatter  = function (p) {
            const statusBtn = CloverApp.API.createElement("button", { onClick: () => showStatusModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, p.value);
            
            const elements = [];
            elements.push(exemptFormatter(p));
            elements.push(resetFormatter(p));
            elements.push(rejectFormatter(p));
            const updateStatusDiv = CloverApp.API.createElement("div", {style:{marginTop:"4px"} },elements );
            return [statusBtn, updateStatusDiv];
        }; 
        
        const xlsxActionsFormatter = function (p) {
            const elements = [];
            const isOnlineSurvey = ("O"===p.row.Type) && !!p.row.FormNames;
            const hasFiles = isOnlineSurvey && ( (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null) && (""!==p.row.FileLanguages));
            const alwaysShowForDataEditor = true;
            const showUploadButtonInAppropriateStatus = isOnlineSurvey && (hasFiles || alwaysShowForDataEditor);
            
            
            //Response upload button
            if(showUploadButtonInAppropriateStatus) {
                const uploadIcon = CloverApp.API.createElement("i", {className: "upload icon",ariaHidden: "true" }, "");
                //const excelEnabledForDply = innerArgs.data.IsExcelEnabled;
                const excelEnabledForDply = true; //always for OSS
                const uploadButtonText = "Upload";
                if(!excelEnabledForDply && !alwaysShowForDataEditor) {
                    elements.push( CloverApp.API.createElement("div", {}, "") ); 
                } else if( (p.row.StatusCode=="PE" || p.row.StatusCode=="DE") ) {
                    //Upload option is available for Pending and In-Progress
                    const formNames = p.row.FormNames.split(''||''); //used for form selection after upload
                    const languages = p.row.Languages.split(''||''); 
                    const btn = CloverApp.API.createElement("button", { 
                            onClick: () => showUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id),
                            className: iconBtnClass }, uploadIcon);
                            
                    const popup = CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, btn);
                    const container = CloverApp.API.createElement("div", {},  popup); //For disabled component, require a div to cover in order to show the popup.
                    
                    elements.push(container);
                } else {
                    const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, uploadIcon);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  btn);
                    const popup=CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, container);
                    
                    //Show a disabled button for other status 
                    elements.push(popup);
                }
            }
            
            //Response download link
            if(p.row.IsExcelResponse) {
                // if(elements.length > 0) {
                //     elements.push( CloverApp.API.createElement("br"));
                // }
                const downloadIcon = CloverApp.API.createElement("i", {className: "download icon",ariaHidden: "true" }, "");
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

        const formNamesFormatter = function (p) {
            var elements = [];
            if(p.row.Type=="O"){
                var strFormNames = p.row.FormNames;
                var strLanguages = p.row.Languages;
                var formNames = strFormNames.split(''||'');
                var languages = strLanguages.split(''||'');      
                
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
                    const fileNames = p.row.FileNames.split(''||'');
                    const fileLanguages = p.row.FileLanguages.split(''||'');
                    const fileTokens = p.row.FileTokens.split(''||'');   
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

        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.FormNames.customFormatter = formNamesFormatter;
                cols.FileNames.customFormatter = fileNamesFormatter;
                // cols.Remarks.customFormatter = remarksFormatter;
                cols.StatusTitle.customFormatter = statusTitleFormatter;
                // cols.ExemptActions.customFormatter = exemptFormatter;
                // cols.ResetActions.customFormatter = resetFormatter;
                // cols.RejectActions.customFormatter = rejectFormatter;
                // cols.TrackActions.customFormatter = trackFormatter; 
                // cols.DelegationActions.customFormatter = delegateHistoryFormatter;
                // cols.XlsxActions.customFormatter = xlsxActionsFormatter; 
                cols.ExcelSupport.customFormatter = xlsxActionsFormatter; 
                cols.AllAction.customFormatter = allActionsFormatter; 
            }
            return model;
        }; //end of gridModelRewriter

        args.data.remarks = null;
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    }, //end of init...........................................................
    
    addToTrkList: function (args) {

        var formData = new FormData();
        formData.append(''uid'', args.data.trkListSample_uid);
        formData.append(''email'', args.data.trkListSample_email);
        formData.append(''name'', args.data.trkListSample_name);
        formData.append(''remarks'', args.data.trkListSample_remarks);
        formData.append(''status'', args.data.trkListSample_status);
        formData.append(''trkListIds'', args.data.dictionaryTrkList);

        
        
        var url = ''/dataeditor/settrklists'';
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
                    args.component.refs.grid.refresh();  
                    args.component.refs.trkListModal.close();
                    alertify.success(response.message);
        
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            })
            .finally(()=>{
                CloverApp.API.setDataField("dictionaryTrkList", null);  
                CloverApp.API.setDataField("trkListSample_uid", null);
                CloverApp.API.setDataField("trkListSample_email", null);    
                CloverApp.API.setDataField("trkListSample_name", null);                 
                CloverApp.API.setDataField("trkListSample_remarks", null);
                CloverApp.API.setDataField("trkListSample_status", null);       
                CloverApp.API.setDataField("trkListSample_statusTitle", null);               
            });
            
    
    
    },    
    
    setStatusAsync: function (args) {
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        formData.append(''id'', args.data.dlsi);        
        formData.append(''selectedStatusId'', selectedStatusId);
        
        var url = ''/dataeditor/setStatus'';
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
                    args.component.refs.statusModal.close();
                    args.component.refs.grid.refresh();
    
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            });
    
    
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
                alertify.success(response.message);
                grid.refresh();
            }, reason => {
                console.error("Failed to update remarks.", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    promptForExcelFile: function(args) {
        const file = $("input[name=''ExcelFileUpload'']");
        file.trigger(''click'');
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
                CloverApp.API.redirect("form", formName, ''dlsi/''+ uploadIndex);
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
            alertify.error(errorMessage, 10000);
        }
        return {};
    }, //end of excelFileUploaded
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    rejectResponse: function(args) {
        const remarks = args.data.RejectResponseRemarks ? args.data.RejectResponseRemarks.trim() : ""
        if(""===remarks) {
            alertify.error("Remarks are required here");
            return {};
        }
        
        const modal = args.component.refs.mdl_RejectResponse;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);  
        formData.append("respId", args.data.RejectResponseRespId);
        formData.append("remarks", remarks );
        Utils.loadingStart("Rejecting Response");
        Utils.postFormRequest("/dataeditor/rejectresponse",formData).then(
            response => {
                modal.close();
                grid.refresh();
                alertify.success(response.message, 10000);
            }, reason => {
                console.error("Error rejecting response", reason);
                alertify.error(reason, 15000);
                grid.refresh();
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeDelegateHistoryModal: function(innerArgs){
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
    onChangeDictStatus: function(args){
        var data = args.data;
        var selectedDataEditors = data.dictStatus;
        var filterArr = [];
        
        if(!selectedDataEditors || !selectedDataEditors.length){
            
            return {
                app: {
                    form: {
                        filters: {
                            main: {
                                grid: []
                                }
                        }
                    }
                }
            };
        }
        
        for(var i = 0; i < selectedDataEditors.length; i++){
            filterArr.push(selectedDataEditors[i]);
        };
        
        var filterObj = {
            column: "Status",
            term: "in",
            value: filterArr
        };

        return {
                app: {
                    form: {
                        filters: {
                            main: {
                                grid: [filterObj]
                                }
                        }
                    }
                }
        };
    },
    
    updateFilter: function(args) {
        const data = args.data;
        const filterComplete = data.dropdownComplete ? data.dropdownComplete : "";
        
        const filter = [];

        if("" != filterComplete) {
            filter.push({
               column: "DateComplete",
               nextValue: "",
               term: filterComplete == "true" ? "!=" : "=",
               value: "",
            });
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta);
        return delta;
    },
    
}






' WHERE [Id]='4af67164-5e60-4905-9885-afd6da24cb3d';

UPDATE [dwMetadata] SET
[Id]='6122cf0b-786e-4824-9db3-81870fead8a8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 15:44:37.983', 
[Data]=N'{
    downloadEmailTemplate: function(args){
        let text = '''';
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
        text +=''Survey Name: {SurveyName}\n''
        text +=''Questionnaire Name: {DplyQnn}\n''
        text +=''List Name: {DplyList}\n''
        text +=''Deployment Name: {DplyName}\n''
        text +=''Category Name: {DplyCategory}\n''
        text +=''UIDPeer: {UIDPeer}\n''
        text +=''Account Active Status: {ActiveYN}\n''
        text +=''Delegation Code: {DelegationCode} (Master Delegation Code. Only available for deployments that require AccessCode)\n''
        
        const hiddenElement = document.createElement(''a'');
        hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
        hiddenElement.target = ''_blank'';
        hiddenElement.download = ''EmailTemplate.txt'';
        hiddenElement.click();
    },
    
    addNewSample: function(args){
        const gridListSamples = args.controlRef;
        const dplyId = args.data.Id;
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("listId", listId);   
        Utils.loadingStart("Updating deployment samples from list");
        Utils.postFormRequest("/deployment/addnewsample", formData).then( 
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("addnewSample failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of addNewSample
    
    closeModal: function(args) {
        args.controlRef.close(); //expects modal as event target    
    },
    
    onOpenManageDueDate: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalDueDate = args.component.refs.modalDueDate;
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    changeDueDate: function(args){
		const modalDueDate = args.component.refs.modalDueDate;	
		const gridListSamples = args.controlRef; //expects grid as event target	
		const selectedGridIndices = gridListSamples.state.selectedIndexes;	
		
        const noSamplesSelectedInGrid = (selectedGridIndices.length===0);
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        const dueDate = args.data.dueDate;
        if(dueDate==null || dueDate==='''') {
            alertify.error("Please select the due date");
            return {};
        }
        
        const dplyId = args.data.Id;
        const listSampleIds = selectedGridIndices.map( gridIndex => gridListSamples.state.items[gridIndex].ListSampleId );
        const listId = args.data.ListId;
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("dueDate", dueDate);
        formData.append(''listSampleIds'', listSampleIds);     
        Utils.loadingStart("Updating Due Dates");
        Utils.postFormRequest("/deployment/changeDueDate",formData).then(
            result => {
                gridListSamples.refresh();
                modalDueDate.close();
                alertify.success(result.message);
            }, reason => { 
                console.error("changeDueDate failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of changeDueDate

    onOpenSendMessage: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        if(noSamplesSelectedInGrid){
            modalSendMessage.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    sendMessage: function(args){
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        const dplyId = args.data.Id;
        const mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        const email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        const emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        const scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";
        const profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        if(!mailMerge && !email && !profile){
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        let msgContent = "";
        var msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.component.refs.htmlEditor.state.htmlData;
            msgContentJson = args.component.refs.htmlEditor.state.jsonData;
        }
        const subject = args.data.subject;
        
        if(email && (emailFrom==undefined || emailFrom==null || emailFrom.length==0)){
            alertify.error("Email address from is required");
            validated = false;
        } else if(email && !emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
            validated = false;
        }
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(!validated){
            return {};
        }
                
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].ListSampleId );

        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);        
        formData.append(''listSampleIds'', listSampleIds);     
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resend", formData).then(
            result => {
                modalSendMessage.close();
                alertify.success(result.message);
            }, reason => {
                console.error("sendMessage failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
        
    }, //end of sendMessage
    
    sampleResetPassword: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }
        
        const sampleIds = gridListSamples.state.selectedIndexes.map( gridIndex => gridListSamples.state.items[gridIndex].SampleId);
        const formData = new FormData();
        formData.append("sampleIds", sampleIds);   
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetresppassword", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetPassword failed", reason);
                alertify.error(reason);
            }
        ).then(Utils.loadingStop);
        return {};
    },
        
    sampleResetDelegationCode: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);

        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }        

        const sampleIds = gridListSamples.state.selectedIndexes
            .map( gridIndex => gridListSamples.state.items[gridIndex]) //extract selected grid items
            .map( item => { return { sampleId: item.SampleId, sampleInfoId: item.Id } } ); //extract objects with desired ids

        const formData = new FormData();
        formData.append("sampleIds", JSON.stringify(sampleIds));
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetrespdelegationcode", formData).then(
            result => {
                alertify.success(result.message);
            }, reason => {
                console.error("sampleResetDelegationCode failed", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of sampleResetDelegationCode

}' WHERE [Id]='6122cf0b-786e-4824-9db3-81870fead8a8';

UPDATE [dwMetadata] SET
[Id]='548924d4-bec7-4469-952a-739f7dcf4e77', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyRecurrence-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-10-20 00:43:16.763', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 17:30:18.533', 
[Data]=N'{
    init: function(args) {
        
        const data = args.data;
        if(data.RecurrenceAdvanceDays===undefined || data.RecurrenceAdvanceDays===null || data.RecurrenceAdvanceDays === 0) {
            CloverApp.API.setDataField("IsCreateInAdvance", false);
            CloverApp.API.setDataField("RecurrenceAdvanceDays", 0);
        } else if (data.RecurrenceAdvanceDays > 0) {
            CloverApp.API.setDataField("IsCreateInAdvance", true);
        }
        
        if(!(data.RecurrenceNextDate===undefined || data.RecurrenceNextDate===null)) {
            CloverApp.API.setDataField("msg_NextDeployment", data.RecurrenceNextDate );
        }
        
        CloverApp.API.setDataField("UpdatedDate", new Date()); //for trigger
        
        const customRecurrenceOnFormatter = function(p) {
            if(p.row.CustomFrequencyType !== undefined){
                const CFType = p.row.CustomFrequencyType;
                const CFDayAndWeek = p.row.RecurDay;
                const CFMonth = p.row.RecurMonth;
                const CFYear = p.row.RecurYear;
                let dateValue = new Date(CFYear,CFMonth - 1,CFDayAndWeek);
                let customMonth = 0;
                
                if(dateValue.getMonth()+1 !== CFMonth){
                    dateValue = new Date(CFYear,CFMonth - 1, 1);
                }
                let value = "";
                switch(CFType) {
                    case "EXACT DATE":
                        value = CloverApp.API.formatDatetime(dateValue, window.CloverLang.common.dateFormat);
                        break;
                    case "N DAY N MONTH":
                        value = "Day " + CFDayAndWeek + " of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N LAST DAY N MONTH":
                        value = "Last " + CFDayAndWeek + " Day of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N WEEK N MONTH":
                        value = "Week " + CFDayAndWeek + " of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N LAST WEEK N MONTH":
                        value = "Last " + CFDayAndWeek + " Week of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N DAY EACH MONTH":
                        value = "Day " + CFDayAndWeek + " of Every Month";
                        break;
                    case "N LAST DAY EACH MONTH":
                        value = "Last " + CFDayAndWeek + " Day of Every Month";
                        break;
                    case "N WEEK EACH MONTH":
                        value = "Week " + CFDayAndWeek + " of Every Month";
                        break;
                    case "N LAST WEEK EACH MONTH":
                        value = "Last " + CFDayAndWeek + " Week of Every Month";
                        break;
                    default:
                        console.log("Error: unknown custom frequency type ", CFType);
                        return CloverApp.API.createElement("div", {}, ""); 
                }
                
                return CloverApp.API.createElement("div", {}, value); 
            }
                
            return CloverApp.API.createElement("div", {}, ""); 
            
        }; //end of customFrequencyValueFormatter

        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {   
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                },{}); 
                
                cols.RecurrenceOn.sortable = false;
                cols.RecurrenceOn.customFormatter = customRecurrenceOnFormatter;      

            }
            return model;
        }; //end of gridModelRewriter
        
        CloverApp.API.rewriteControlModel("gdCustomFrequency", gridModelRewriter);

        return {};
    },
    
    addAllFields: function(args){
        var allFields = args.data.PrePopulateFields;
        if(allFields != null) {
            for(var x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = true;
            }
            CloverApp.API.setDataField("PrePopulateFields", allFields);
        }
    },
    
    removeAllFields: function(args){
        var allFields = args.data.PrePopulateFields;
        if(allFields != null) {
            for(var x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = false;
            }
            CloverApp.API.setDataField("PrePopulateFields", allFields);
        }
    },
    
    updateRecurrence: function(args) {
        const data = args.data;
        
        if(data.RecurrenceEnabled) {
            if(data.RecurrenceAdvanceDays > 0 && !Number.isInteger(Number(data.RecurrenceAdvanceDays))) {
                alertify.error("Advance days must be a whole number");
                return {};
            }
        }
        
        if(data.RecurrenceEndDate != null){
            var date = new Date(data.RecurrenceEndDate);
            data.RecurrenceEndDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        }
        
        Utils.loadingStart("Updating deployment");
        Utils.postJsonRequest("/deployment/updaterecurrence", data).then(
            response => {
                alertify.success("Recurrency settings updated");
                window.location = window.location;
            }, reason => {
                console.error(reason);
                Utils.loadingStop();
                alertify.error(reason);
                return {};
            }
        ) //(absent finally is intentional);
        return {};
    },
    
    toggleDaysInAdvance: function(args) {
        var delta = {};
        if(!args.data.IsCreateInAdvance) {
            CloverApp.API.setDataField("RecurrenceAdvanceDays", 0);
            const hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
            if(!hideControls.includes("RecurrenceAdvanceDays")) {
                hideControls.push("RecurrenceAdvanceDays");
                delta = {
                    app: {
                        form: {
                            models: {
                                hideControls,
                            }
                        }
                    }    
                };
            }
        }
        return delta;
    },
    
    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            Utils.redirectToForm("QNN_DPLY", args.data.RecurrenceOfDplyId);
        }    
    },
    
    closeCustomFrequencyModal: function(args){
        args.component.refs.customFrequencyModal.close();
    },
    
    saveCustomFrequency: async function(args){
        //CF = CustomFrequency
        const validateCFInput = function(CFType, CFDay, CFWeek, CFMonth, CFDate) {
            const errMsg = [];
            
            if(!Boolean(CFType)){
                errMsg.push("Please select custom frequency type.");
            }else if(CFType === "N DAY N MONTH" || CFType === "N LAST DAY N MONTH"){
                if(!Boolean(CFDay)){    errMsg.push("Please select a day."); }
                if(!Boolean(CFMonth)){  errMsg.push("Please select a month."); }
                if(errMsg.length === 0){
                    const checkValidDate = new Date("0004",CFMonth - 1,CFDay);
                    if(checkValidDate.getMonth() + 1 !== parseInt(CFMonth)){ errMsg.push("Please select a valid date.");}
                }
            }else if(CFType === "N WEEK N MONTH" || CFType === "N LAST WEEK N MONTH"){
                if(!Boolean(CFWeek)){   errMsg.push("Please select a week."); }
                if(!Boolean(CFMonth)){  errMsg.push("Please select a month."); }
            }else if(CFType === "N DAY EACH MONTH" || CFType === "N LAST DAY EACH MONTH"){
                if(!Boolean(CFDay)){    errMsg.push("Please select a day."); }
            }else if(CFType === "N WEEK EACH MONTH" || CFType === "N LAST WEEK EACH MONTH"){
                if(!Boolean(CFWeek)){   errMsg.push("Please select a week."); }
            }else if(CFType === "EXACT DATE"){
                if(!Boolean(CFDate)){   errMsg.push("Please select a date."); }
            }else{
                errMsg.push("Unknown custom frequency type.");
                console.log("Error: unknown custom frequency type ", CFType);
            }
            
            if(errMsg.length > 0){ errMsg.forEach(function(msg){alertify.error(msg);}); }
            
            return errMsg.length == 0;
        }; 
        
        const saveCFAPI = function(SelectedId, DplyId, CFType, CFDay, CFMonth, CFYear){
            const formData = new FormData();
            formData.append(''SelectedId'', SelectedId);
            formData.append(''dplyId'', DplyId);
            formData.append(''frequencyType'', CFType);
            formData.append(''frequencyDay'', CFDay);
            formData.append(''frequencyMonth'', CFMonth);
            formData.append(''frequencyYear'', CFYear);
            
            const promise = Utils.postFormRequest("/deployment/savedplycustomfrequencyrecurrence/",formData).then(
                response => {
                    alertify.success(''Saved successfully.'');
                        return true;
                }, reason => {
                    alertify.error(response.message);
                    return false;
                }
            );
            return promise;
            
            // return fetch(url,
            //     {
            //         credentials: ''same-origin'',
            //         contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
            //         method: ''post'',
            //         body: formData
            //     })
            //     .then(response => {
            //         return response.json();
            //     })
            //     .then(response => {
            //         if (response.success) {
            //             alertify.success(''Saved successfully.'');
            //             return true;
            //         } else {
            //             alertify.error(response.message);
            //             return false;
            //         }
            //     })
            //     .catch(error => {
            //         alertify.error(error.message);
            //         return false;
            //     });
        };
        
        const recurType = args.data.CustomFrequencyType;
        const isCFValid = validateCFInput(recurType, args.data.CustomFrequencyDay, args.data.CustomFrequencyWeek, args.data.CustomFrequencyMonth, args.data.CustomFrequencyDate);
        
        let recurDay = 1;
        let recurMonth = 1;
        let recurYear = "0004";
        
        if(recurType !== "EXACT DATE"){
            recurDay = args.data.CustomFrequencyDay;
            
            if(recurType.indexOf("WEEK") > -1){
                recurDay = args.data.CustomFrequencyWeek;
            }
            
            if(recurType.indexOf("EACH MONTH") === -1){
                recurMonth = args.data.CustomFrequencyMonth;
            }
            
        }else{
            let recurDate = new Date(args.data.CustomFrequencyDate);
            recurDay = recurDate.getDate();
            recurMonth = recurDate.getMonth() + 1;
            recurYear = recurDate.getFullYear();
        }
        
        if(isCFValid){
            const result = await saveCFAPI(args.data.SelectedCustomFrequencyId, args.data.Id, recurType, recurDay, recurMonth, recurYear);
            if(result){
                args.component.refs.gdCustomFrequency.refresh();   
                args.component.refs.customFrequencyModal.close();     
            }
            
        }
    },
    
    setCustomFrequencyControlsVisibility: function(args){
        args.component.refs.customFrequencyModal.openModal();
        
        const selectedItem = args.component.refs.gdCustomFrequency.state.items[args.parameters.rowIdx];
        const CustomFrequencyType = selectedItem.CustomFrequencyType;
        let hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
        hideControls = hideControls.filter(function(item){ 
            return item !== "CustomFrequencyDay" 
                && item !== "CustomFrequencyWeek" 
                && item !== "CustomFrequencyMonth" 
                && item !== "CustomFrequencyDate" 
                && item !== "customFrequencyDateSpacing"
        });
        
        if(CustomFrequencyType === "N DAY N MONTH" || CustomFrequencyType === "N LAST DAY N MONTH"){
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyDate");
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N WEEK N MONTH" || CustomFrequencyType === "N LAST WEEK N MONTH"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyDate");
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N DAY EACH MONTH" || CustomFrequencyType === "N LAST DAY EACH MONTH"){
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyMonth"); 
            hideControls.push("CustomFrequencyDate"); 
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N WEEK EACH MONTH" || CustomFrequencyType === "N LAST WEEK EACH MONTH"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyMonth"); 
            hideControls.push("CustomFrequencyDate"); 
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "EXACT DATE"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyMonth"); 
        } else{
            alertify.error("Unknown custom frequency type.");
            console.log("Error: unknown custom frequency type ", CustomFrequencyType);
            return {};
        }
        
        delta = {
            app: {
                form: {
                    models: {
                        hideControls,
                    }
                }
            }    
        };
        return delta;
    },
    
    setCustomFrequencyControlsValue:function(args){
        const selectedItem = args.component.refs.gdCustomFrequency.state.items[args.parameters.rowIdx];
        
        let recurYear = selectedItem.RecurYear;
        if(selectedItem.CustomFrequencyType !== "EXACT DATE"){
            recurYear = new Date().getFullYear();
        }
        const dateValue = new Date(recurYear, (selectedItem.RecurMonth - 1), selectedItem.RecurDay);
        CloverApp.API.setDataField("CustomFrequencyType", selectedItem.CustomFrequencyType); 
        CloverApp.API.setDataField("CustomFrequencyDay", String(selectedItem.RecurDay)); 
        CloverApp.API.setDataField("CustomFrequencyWeek", parseInt(selectedItem.RecurDay) > 6 ? ''1'' : String(selectedItem.RecurDay)); 
        CloverApp.API.setDataField("CustomFrequencyMonth", String(selectedItem.RecurMonth)); 
        
        if(selectedItem.CustomFrequencyType === "EXACT DATE"){
            CloverApp.API.setDataField("CustomFrequencyMonth", String(selectedItem.RecurMonth)); 
        }
        CloverApp.API.setDataField("CustomFrequencyDate", dateValue); 
        CloverApp.API.setDataField("SelectedCustomFrequencyId", selectedItem.Id); 
        return {};
    },
    
    resetCustomFrequencyModal: function(args){
        CloverApp.API.setDataField("CustomFrequencyType", ""); 
        CloverApp.API.setDataField("CustomFrequencyDay", ""); 
        CloverApp.API.setDataField("CustomFrequencyWeek", ""); 
        CloverApp.API.setDataField("CustomFrequencyMonth", ""); 
        CloverApp.API.setDataField("CustomFrequencyDate", ""); 
        CloverApp.API.setDataField("SelectedCustomFrequencyId", ""); 
        
        const hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
        hideControls.push("CustomFrequencyDay");
        hideControls.push("CustomFrequencyWeek");
        hideControls.push("CustomFrequencyMonth");
        hideControls.push("CustomFrequencyDate");
        hideControls.push("customFrequencyDateSpacing");
        delta = {
            app: {
                form: {
                    models: {
                        hideControls,
                    }
                }
            }    
        };
        return delta;
    },
        
}




' WHERE [Id]='548924d4-bec7-4469-952a-739f7dcf4e77';

UPDATE [dwMetadata] SET
[Id]='ec448626-827e-4932-bd3a-bba8de7146dd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyValidation-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-12 13:54:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 17:43:19.417', 
[Data]=N'{
    init: function(args) {
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("UploadDataset", model => {
            model.customPostUrl = "/deployment/dataset/" + dplyId;
            model.onUploadBegin = () => Utils.loadingStart("Uploading data to server");
            model.onUploadEnd = (cmp, ok, data) => { 
                Utils.loadingStop();
                if(ok) {
                    if(data.item) {
                        const importReport = data.item;
                        CloverApp.API.setDataField("ImportReportImportCount", importReport.importCount);
                        CloverApp.API.setDataField("ImportReportInvalidCount", importReport.invalidCount);
                        CloverApp.API.setDataField("ImportReportIgnoredCount", importReport.ignoredCount);
                        CloverApp.API.setDataField("ImportReportDuplicateCount", importReport.duplicateCount);
                    }
                } else {
                    CloverApp.API.setDataField("UploadDataset",null);
                    alertify.error("File upload failed");
                }
            };
        });
    },
    
    onClickUpload: function(args) {
        const file = $("input[name=''UploadDataset'']");
        file.trigger(''click'');
    },
    
    onImport: function(args) {
        const gridview = args.component.refs.gv_Datasets;
        const result = args.sourceControlValue;
        
        //Need to clear the file field so it can be used again
        CloverApp.API.setDataField("UploadDataset",null);
        
        if("FAIL"==result) {
            alertify.error("Data import failed.");
        } else if("NO UID COLUMN"==result) {
            alertify.error("Invalid file. A UID column is required to identify samples.");
        } else if("INCORRECT FILE TYPE"==result) {
            alertify.error("Incorrect file type. Please upload a CSV file.");
        } else if("OK"==result) {
            gridview.refresh();
            args.component.refs.ImportReportModal.openModal();
        } else {
            console.error("CSV import error", result);
            alertify.error("An error occured.");
        }
        
    },
    
    cancelModal: function(args) {
        args.controlRef.close();
    },
    
    clearDatasets: function(args) {
        args.controlRef.close();
        const gridview = args.component.refs.gv_Datasets;
        Utils.loadingStart("Removing uploaded datasets");
        Utils.deleteRequest("/deployment/dataset/"+encodeURIComponent(args.data.Id)).then(
            () => {
                alertify.success("Datasets removed");
                gridview.refresh();
            },
            reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        
    },

}








' WHERE [Id]='ec448626-827e-4932-bd3a-bba8de7146dd';

UPDATE [dwMetadata] SET
[Id]='d31cbc75-a3e9-46fc-9176-7ada5ecd7c09', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:51:04.643', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 18:05:41.507', 
[Data]=N'{
    init: function(args){
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("CsvFileUploaded", model => {
            model.customPostUrl = "/deployment/prepopulatecsv?" + new URLSearchParams( { dplyId } );
            model.onUploadBegin = () => Utils.loadingStart("Pre-populating...");
            model.onUploadEnd = Utils.loadingStop;
        });
    },
    
    getDeploymentFields: function(args){
        const dplyId = args.controlRef.props.value;
        if(!dplyId || dplyId.length==0){
            alertify.error("Please select at least one deployment");
            return;
        }
        
        
        const formData = new FormData();
        formData.append(''dplyId'', dplyId);   
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/getDeploymentFields", formData).then(
            response => {
                CloverApp.API.setDataField("DeploymentQnnFields", response.item);
            }, reason => {
                console.log("failed ot get deployment fields", reason);
                alterify.error(reason);
            }
        ).finally(utils.loadingStop);
    },
    
    addAllFields: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(allFields != null) {
            for(let x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = true;
            }
            CloverApp.API.setDataField("DeploymentQnnFields", allFields);
        }
    },
    
    removeAllFields: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(allFields != null) {
            for(let x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = false;
            }
            CloverApp.API.setDataField("DeploymentQnnFields", allFields);
        }
    }, 
    
    prePopulate: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(!allFields || allFields.length==0){
            alertify.error("Please select source deployment");
            return;
        }
        
        const fieldIds = [];
        for(let x = 0 ; x < allFields.length ; x++){
            if(allFields[x].PrePopulate == true){
                fieldIds.push(allFields[x].Id);
            }
        }
        
        if(!fieldIds || fieldIds.length==0){
            alertify.error("Please select at least one field");
            return;
        }
              
        const formData = new FormData();
        formData.append(''dplyId'', args.data.Id);
        formData.append(''fieldIds'', fieldIds); 
        formData.append(''sourceDplyId'', args.data.Deployment);   
        Utils.loadingStart(); 
        Utils.postFormRequest("/deployment/prepopulate", formData).then(
            response => {
                alertify.success(response.message);
            }, reason => {
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    csvFileUploaded: function(args) {
        const result = args.sourceControlValue;
        console.log(result);
        CloverApp.API.setDataField("CsvFileUploaded", null); 
        if("OK"===result) {
            alertify.success("Pre-populate has been scheduled. An email will be sent to you once it is completed.");
        } else {
            let errorMessage = result;
            if("FAIL" == result){
                errorMessage = "Pre-populate failed."
            } else if ("DUPLICATE HEADER DETECTED" == result){
                errorMessage = "Uploaded file contains duplicate header. Please remove duplicate and try again."
            } else if ("NO ALIAS COLUMN" == result){
                errorMessage = "Uploaded file does not have valid alias for this deployment. Did you select the correct CSV file?"
            }  else if ("NO UID COLUMN" == result){
                errorMessage = "Invalid file. A UID column is required to identify samples."
            } else if("INCORRECT FILE TYPE"==result) {
                errorMessage = "Incorrect file type. Please upload a CSV file.";
            }
            alertify.error(errorMessage, 10000);
        }
        return {};
    },
    
    clickFileUpload: function(args){
        const file = $("input[name=''CsvFileUploaded'']");
        file.trigger(''click'');
        return {};
    },
 
}' WHERE [Id]='d31cbc75-a3e9-46fc-9176-7ada5ecd7c09';

UPDATE [dwMetadata] SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 19:46:43.763', 
[Data]=N'{
    downloadEmailTemplate: function(args){
        let text = '''';
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
        text +=''Survey Name: {SurveyName}\n''
        text +=''Questionnaire Name: {DplyQnn}\n''
        text +=''List Name: {DplyList}\n''
        text +=''Deployment Name: {DplyName}\n''
        text +=''Category Name: {DplyCategory}\n''
        text +=''UIDPeer: {UIDPeer}\n''
        text +=''Account Active Status: {ActiveYN}\n''
        text +=''Delegation Code: {DelegationCode} (Master Delegation Code. Only available for deployments that require AccessCode)\n''
        
        const hiddenElement = document.createElement(''a'');
        hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
        hiddenElement.target = ''_blank'';
        hiddenElement.download = ''EmailTemplate.txt'';
        hiddenElement.click();
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
            catch(error) {
                //ignore
            }
        }          

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
                    
                    } // end if response.success        
                }) // end then => response
   
            .catch(function(ex) {
                alertify.error("Could not Data due to " + ex);
            });
        }; //end return       
    }, //end of init

    //Called from init
    checkQnnFields: function(qnnId){    
        const formData = new FormData();
        formData.append(''qnnId'', qnnId);
        loadingStart("Verifying survey field alias");
        postFormRequest("/qnn/checkfields",formData).then(
            response => {
               //No action 
            }, reason => {
                console.log(reason);
                alertify.alert(reason);
            }
        ).finally(loadingStop);
    }, //end of checkQnnFields
    
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
    
    downloadInvalidColumns(args) {
        //CloverApp.API.setDataField("invalidQnnColumns",[''A11'', ''B22'', ''C33'']);
        
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
    }, // end of downloadInvalidColumns
    
    downloadInvalidDates(args) {
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
    }, //end of downloadInvalidDates
    
    downloadInvalidUIDs(args) {
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
    }, //end of downloadInvalidUIDS
    
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

        var d1 = new Date();
        Utils.loadingStart();
        return ()=>{
            return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Utils.loadingStop();
              
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
                Utils.loadingStop();
                //alertify.error(error.message);;
                console.log(error.message);
            });
        };
    }, // end of submitFile
    
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
    }, //end of closeModal
    
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
    }, //end of closeMoreModal
    
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
        } else {
            //if not restricting IP
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, ''RestrictIpInclusive'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''countryOrIpRange'');    
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');                
        }        

        return {hideControls: hideControls, showControls: showControls};
    },
    
    //TODO - refactoe
    removeElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    },
    
    //TODO - refactor
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
    }, //end of setIpRestriction
    
    onClickSave: function (args){
        var emailFrom = args.data.emailFrom ? args.data.emailFrom : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

        if(args.data.Id==null && args.data.cbEmail && !emailRegExr.test(emailFrom)){
            throw alertify.error("Invalid Email address from");
        }
  
        const formData = new FormData();
        formData.append(''CheckBox'', args.data.chkEmailSuccess);
        formData.append(''dplyId'',args.data.Id);
        formData.append(''emailSuccess'',emailSuccess);
        formData.append(''emailFail'',args.data.chkEmailFail);
        formData.append(''userId'',args.data.ddlEmailReceipients);      
        
        Utils.loadingStart();
        Utils.postFormRequest("/report/getJobData",formData).then(
            response => {
                console.log(data);
            }, reason => {
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    }, //end of onClickSave
    
    parseHtml: function(args) {
        return {
              app: {
                  form: {
                      data: {
                          modified: {
                             msgContent: args.component.refs.htmlEditor.state.htmlData,
                             msgContentJson: args.component.refs.htmlEditor.state.jsonData
                            }
                        }
                    }
                }
        };  
    },
    
    dropdownQuestionnaireOnChange: function(args) {
        var qnnId = args.sourceControlValue;
        var options = args.sourceControlRef.state.options;
        console.log("Args is", args);
        if(args.data.SurveyName=="" || args.data.SurveyName ==null){
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == qnnId){
                        CloverApp.API.setDataField("SurveyName", options[i]["text"]);
                        break;
                    }
                }
            }
        }   
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
    }, //end of clearContent

    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            //CloverApp.API.redirectToForm("QNN_DPLY",args.data.RecurrenceOfDplyId);
            location.href = "/form/QNN_DPLY/" + encodeURIComponent(args.data.RecurrenceOfDplyId);
        } else {
            alertify.error("This deployment does not have a parent");
        } 
    },
    
    updateFeatureInteraction: function(args) {
        const isSelected = function(toggleValue) {
            return Boolean(true===toggleValue || 1===toggleValue || "1"==toggleValue || "true"===String(toggleValue).toLowerCase());
        }
        
        const isExcelEnabled = isSelected(args.data.IsExcelEnabled);
        const isDelegationEnabled = isSelected(args.data.RequireAccessCode);
        const isAnonymous = isSelected(args.data.IsAnonymous);
        const isMultipleResponse = isSelected(args.data.IsMultipleResponse);
        
        if(isAnonymous) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for anonymous surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
            
            if(isDelegationEnabled) {
                alertify.error("Delegation Access Code is not supported for anonymous surveys");
                CloverApp.API.setDataField("RequireAccessCode", 0);
            }
        }
        
        if(isMultipleResponse) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for multiple response surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
        }
        
        
    },
    
    validateSampleList: function (args){
        const listId =  args.data.dictList;
        
        Utils.loadingStart("Verifying list has samples...");
        Utils.getRequest("/deployment/CheckListHasSample/" + encodeURIComponent(listId)).then(
            response => {
                if(!response.result) {
                CloverApp.API.setDataField("dictList", "");
                const selectedList = args.component.refs.dictList.state.options[args.component.refs.dictList.state.options.map(e=> e.value).indexOf(''ffea02fd-d8a7-4a46-8bbb-86a8a6180d30'')].text;
                alertify.error("Sample List " + selectedList + " is empty.");
            }
            }, reason => {
                
            }
        ).finally(Utils.loadingStop);
        
        // var url = ''/deployment/CheckListHasSample/'' + encodeURIComponent(listId);
        // const response = await fetch(url,
        //     {
        //         credentials: ''same-origin'',
        //         contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
        //         method: ''get''
        //     })
        //     .then(response => {
        //         return response.json();
        //     });
            
        // if (response.success) {
        //     if(!response.result){
        //         CloverApp.API.setDataField("dictList", "");
        //         const selectedList = args.component.refs.dictList.state.options[args.component.refs.dictList.state.options.map(e=> e.value).indexOf(''ffea02fd-d8a7-4a46-8bbb-86a8a6180d30'')].text;
        //         alertify.error("Sample List " + selectedList + " is empty.");
        //     }
        // }else{
        //     alertify.error(response.message);
        // }
        return args;
    },
}






' WHERE [Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf';

UPDATE [dwMetadata] SET
[Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.910', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 19:03:33.670', 
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
        var d1 = new Date();
        Utils.loadingStart();
        return ()=>{
        const promise = fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Utils.loadingStop();
              
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
                Utils.loadingStop();
                alertify.error(error.message);
            });
 
        };
        return promise;
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

UPDATE [dwMetadata] SET
[Id]='927fc400-e371-4fbb-b866-cb020fff46db', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.580', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 20:18:43.607', 
[Data]=N'{
    init: function(args){
      //console.log(''View Args'', args);    
      //args.component.refs.collectioneditor_2.props.placeholders.Name["0"][""data-elements""]
        if(args.data.Id){
            CloverApp.API.setDataField("UpdatedDate", new Date());
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.Id);                  
            }
            catch(err) {
                ;
        	}
        } else {
            CloverApp.API.setDataField("Type","O");
        }
        CloverApp.API.setDataField("ErrorText", "");
    },  

    customSave: function(args) {
        args.data.UpdatedDate = new Date(); //trigger triggers
        const innerArgs = args;
        Utils.loadingStart("Saving...");
        Utils.changeData(args.data,"QNN_QNN").then(
            responseData => {
                alertify.success("The changes have been applied!");
                const reloadUrl = "/form/QNN_QNN/" + encodeURIComponent(responseData.item.entity.Id);
                window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
                //nb: leave loading animation on
            }, reason => {
                CloverApp.API.setDataField("ErrorText", reason);
                innerArgs.component.refs.errorModal.openModal();
                Utils.loadingStop();
            }
        ); //(absent finally is intentional for continuing loading animation)
    }, //end of customSave
    
    viewArgs: function(args){
        console.log(''View Args'', args);    
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
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    convertToOnlineForm: function(args) {
        //nb: it is assumed this is only called for an already saved entity
        CloverApp.API.setDataField("Type","O");
        alertify.success("Type changed to Online. Add an Online form and click Save to apply this change");
        const hideControls = [ "Warning_Type_P", "Type", "Excel_Files_After_Save_Message", "btnConvertToOnlineForm" ];
        return {
            app: {
                form: {
                    models: {
                        hideControls: hideControls,
                    },
                },
            },
        }; //end of state delta
    }, // end of convertToOnlineForm
    
    showLangWarning: function(args) {
        Utils.queueHideControl("Warning_nolanguage_file",''show'');
    },
}







' WHERE [Id]='927fc400-e371-4fbb-b866-cb020fff46db';

UPDATE [dwMetadata] SET
[Id]='17fd460f-81b6-4cb6-9ccd-778ab927441c', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:13:14.040', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 20:46:10.677', 
[Data]=N'{
    downloadEmailTemplate: function(args){
        let text = '''';
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
        text +=''Survey Name: {SurveyName}\n''
        text +=''Questionnaire Name: {DplyQnn}\n''
        text +=''List Name: {DplyList}\n''
        text +=''Deployment Name: {DplyName}\n''
        text +=''Category Name: {DplyCategory}\n''
        text +=''UIDPeer: {UIDPeer}\n''
        text +=''Account Active Status: {ActiveYN}\n''
        text +=''Delegation Code: {DelegationCode} (Master Delegation Code. Only available for deployments that require AccessCode)\n''
        
        const hiddenElement = document.createElement(''a'');
        hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
        hiddenElement.target = ''_blank'';
        hiddenElement.download = ''EmailTemplate.txt'';
        hiddenElement.click();
    },
    
    init: function(args){
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format(''DD MMM YYYY HH:mm'')
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    //var element = CloverApp.API.createElement("a", {className: "ui label"}, entry.ForStatus_Title);
                    $("p[name=''status'']").append("<a class=''ui label''>" + entry.ForStatus_Title + "</a>");
                });
        }
        
        console.log(args);
    },
    
    cancelJob: function(args){
        const formData = new FormData();
        formData.append(''globalMsgId'', args.data.Id);
        Utils.loadingStart("Cancelling mail job");
        Utils.postFormRequest("/globalmailer/canceljob", formData).then(
            response => {
                alertify.success(response.message);
                Utils.queueHideControl("cancelJob");
                Utils.queueHideControl("swz_modal_2");
            }, reason => {
                alertify.error(reason);
                console.log("cancelJob error", reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    editEmailToStatus: function(args){
        var globalMsgId = args.data.Id;
        var organization = args.data.organization;
        var target = args.data.target;
        var emailFrom = args.data.emailFrom;
        var scheduledDate = args.data.scheduledDate;
        var msgContentJson = args.data.msgContentJson ? args.data.msgContentJson : args.data.MsgContentJson;
        var msgContent = args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        var subject = args.data.emailSubj;
        var status = args.data.dictionaryStatus ? target=="intranetUsers" ? "" :  args.data.dictionaryStatus : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        let validated = true;
        if(organization==undefined || organization==null || organization.length==0){
            alertify.error("Organization is required");
            validated = false;
        }
        
        if(target==undefined || target==null || target.length==0){
            alertify.error("Target is required");
            validated = false;
        } else if(target=="activeSamples" && status.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        if(emailFrom==undefined || emailFrom==null || emailFrom.length==0){
            alertify.error("Email address from is required");
            validated = false;
        } else if(!emailRegExr.test(emailFrom)){
            alertify.error("Invalid Email address from");
            validated = false;
        }
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent==undefined || msgContent==null || msgContentJson==undefined || msgContentJson==null){
            alertify.error("Email content is required");
            validated = false;
        }

        if(!validated){
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        var listId = args.data.ListId;
        var formData = new FormData();
        formData.append(''organization'', organization);
        formData.append(''target'', target);
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''globalMsgId'', globalMsgId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);
        
        Utils.loadingStart();
        Utils.postFormRequest("/globalmailer/emailtostatus", formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                const reloadUrl = "/form/SwzGlobalMailerMessage/" + encodeURIComponent(globalMsgId);
                window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
            }, reason => {
                console.log(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    }, //end of editEmailToStatus
    

    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    
    onEditClick: function (args) {
        var statuslist = [];
        if(args.data.StatusCollection.length > 0){
            CloverApp.API.setDataField("target","activeSamples");
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
        }
        CloverApp.API.setDataField("dictionaryStatus",statuslist);
        CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        CloverApp.API.setDataField("organization",args.data.StructDivisionId);
        CloverApp.API.setDataField("target",args.data.IsTargetUsers ? "intranetUsers" : "activeSamples" );
        return { 
            app:{}
        }
    },
    
    onHtmlChange: function (args){
        var contentDataJson =  JSON.stringify(args.component.refs.msgContentEditor.state.jsonData);
        var contentData =  args.component.refs.msgContentEditor.state.htmlData;
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            msgContentJson: contentDataJson,
                            msgContent: contentData
                        }
                    }
                }
            }
        }
    },
}' WHERE [Id]='17fd460f-81b6-4cb6-9ccd-778ab927441c';

UPDATE [dwMetadata] SET
[Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.607', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 20:49:44.860', 
[Data]=N'{
    init: function(args) {
        const innerArgs = args;
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("NewQnnName", "");
            CloverApp.API.setDataField("CopyQnnId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.sortable = false;
                cols.Actions.customFormatter = copyFormatter;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("gridQnn", gridModelRewriter);
    },
    
    //called by Copy button in modal
    copyQnn: function(args) {
        const data = args.data;
        const id = data.CopyQnnId;
        const title = (data.NewQnnName===undefined) ? "" : data.NewQnnName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        var reg = /[!\s@#$%^&*()_+\-=\[\]{};'':"\\|,.<>\/?]/;
        if(reg.test(title)){
            alertify.error("Special symbols not allowed");
            return {};
        }
        
        const formData = new FormData();
        formData.append("qnnId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating Questionnaire");
        Utils.postFormData("/qnn/duplicate", formData).then(
            result => {
                args.component.refs.gridQnn.refresh();
                args.component.refs.copyModal.close();
                alertify.success("Created " + title);
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeModal: function(args) {
        args.controlRef.close();  
    },
}





' WHERE [Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d';

UPDATE [dwMetadata] SET
[Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-26 15:58:32.583', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-09 23:08:55.753', 
[Data]=N'{
    init: function(args){
        const initialAspect = "Role";
        Utils.loadingStart();
        Utils.getRequest("/report/useraccessmatrix/options").then(
            response => {
                Utils.rewriteDropdown("Aspect", response.item, initialAspect);
                args.data.Aspect = initialAspect; //make available in onChangeAspect
                useraccessmatrixUserActions.onChangeAspect(args);
            }, reason => {
                console.log(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    onChangeAspect: function(args){
        const aspect = args.data.Aspect;
        if(aspect === undefined || aspect === "")
            return;

        const formData = new FormData();
        formData.append(''aspect'', aspect);
        Utils.loadingStart();
        Utils.postFormRequest("/report/useraccessmatrix", formData).then(
            response => {
                const htmlOverall = ''<div class="field"><label>Result</label></div><div>'' + response.item + ''</div>''
                CloverApp.API.setDataField("result", htmlOverall);
            }, reason => {
                console.log(reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    onDownload: function(args){
        if(args.data.Aspect === undefined || args.data.Aspect === "")
            return;

        const formData = new FormData();
        formData.append(''aspect'', args.data.Aspect);   
        Utils.loadingStart();
        fetch("/report/useraccessmatrix/download", {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            }
        ).then(
            response => response.blob()
        ).then(blob => {
            Utils.loadingStop();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement(''a'');
            a.href = url;
            a.download = ''User '' + args.data.Aspect + '' Access Matrix.pdf'';
            document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
            a.click();    
            a.remove();  //afterwards we remove the element again  
        })
        .catch(error => {
            Utils.loadingStop();
            console.log(error);
            alertify.error(error.message);
        });

    }
}' WHERE [Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6';

