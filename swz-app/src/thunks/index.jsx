import fetch from 'isomorphic-fetch'
import actions from '../actions.jsx'
import { encodeQueryData, dateReviver, mergeDeep } from '../utils.jsx'
import store from '../store.jsx'
import {userActionInvoker,defaultActions,formHelper} from './useractioninvoker.jsx';
import appActions from "../actions";
//Thunks have to return f(dispatch)

const defaultFetchOptions = { credentials: 'same-origin' };

//isSaving is use to stop double posting for the first save (without respID)
var isSaving = false;
 
const thunks = {
        configuredFetch: (url, userOptions = {}) => {
            let state = store.getState();
            const globalOptions = (
                window.globalFetchOptions 
                ? window.globalFetchOptions()
                : (state.settings.fetchOptions ? 
                    state.settings.fetchOptions : 
                    {}
                )
            );
        
            const options = {
                ...defaultFetchOptions,
                ...globalOptions,
                ...userOptions
            };
        
            let targetUrl = "";
            let settings = store.getState().settings;
            if(settings.backendUrl != undefined && settings.backendUrl != ""){
                targetUrl = settings.backendUrl;
            }
            targetUrl += url;
            return fetch(targetUrl, options);
        },
        userinfo:
            {
                fetch: (successCallback) => {
                    return (dispatch) => {
                        dispatch(actions.app.userinfo.fetch.begin());
                        return thunks.configuredFetch(store.getState().settings.accountget)
                            .then(response => response.json())
                            .then(response => {
                                if (response.success) {
                                    dispatch(actions.app.userinfo.fetch.success(response.item));
                                    if (successCallback)
                                        successCallback(response.item);
                                }
                                else
                                    dispatch(actions.app.userinfo.fetch.failure(response.message, response.details));
                            })
                            .catch(error => {
                                dispatch(actions.app.userinfo.fetch.failure(error.message, error.stack));
                            });
                    };
                }
            },
        additional:
            {
                fetch: ({type, controlRef, formName, startIndex, pageSize, filters, sort, callback}) => {
                    return (dispatch) => {
                        if(type === "dictionary") {
                            let name = controlRef.props.dataModel;
                            let rawColumns = controlRef.props.columns;
                            // if (!rawColumns)
                            //     rawColumns = " Name ASC,Email "; //TODO for test only
                            let terms = rawColumns.split(",").map(function(item) {
                                return item.trim();
                            });
                            let order = [];
                            let columns = [];
                            for (let i=0; i<terms.length;i++) {
                                let term = terms[i];
                                const splitted = term.split(/\s+/);
                                if (splitted.length === 1) {
                                    columns.push(term);
                                }
                                else if (splitted.length === 2) {
                                    columns.push(splitted[0]);
                                    order.push({
                                        column: splitted[0],
                                        order: splitted[1]
                                    });
                                }
                            }

                            let urlData = {
                                columns: JSON.stringify(columns),
                                sort: JSON.stringify(order),
                                name: name
                            };

                            if(filters != undefined){
                                if(typeof filters === 'string'){
                                    urlData.filter = filters 
                                }
                                else{
                                    urlData.filter = JSON.stringify(filters);
                                }
                            }

                            if(startIndex != undefined && pageSize != undefined){
                                urlData.paging = JSON.stringify({startIndex,pageSize});
                            }

                            return thunks.configuredFetch(store.getState().settings.datadictionary + '?' + encodeQueryData(urlData))
                                .then(response => response.json())
                                .then(response => {
                                    if (response.success) {
                                        let items = response.item.map((i) => {
                                            return {key:i.key,text:i.value,value:i.key };
                                        });
                                        callback({
                                            sIndex: startIndex,
                                            pSize: pageSize,
                                            rowsCount: response.count,
                                            items});
                                    }
                                    else
                                        dispatch(actions.app.form.data.fetch.failure(response.message, response.details));
                                })
                                .catch(error => {
                                    dispatch(actions.app.form.data.fetch.failure(error.message, error.stack));
                                });
                        }
                        else if (type === "gridview" || type === "gridviewwithactions") {
                            let paging = {startIndex,pageSize};
                            let filter = filters;
                            let order = [];
                            if (sort) {
                                let sortItems = sort.split(",");
                                sortItems.forEach((sortItem)=>{
                                    var splitted = sortItem.trim().split(" ");
                                    if (splitted.length > 1) {
                                        order.push({
                                            column: splitted[0].trim(),
                                            Order: splitted[1].trim()
                                        });
                                    }
                                    else {
                                        order.push({
                                            column: splitted[0].trim(),
                                            Order: "ASC"
                                        });
                                    }
                                });
                            }
                            let options = null;
                            let urlFilter = null;
                            let locations = store.getState().router.location.pathname.split("/");
                            if (locations.length > 2 && locations[1] === 'form') { //filter & options from url
                                if (locations.length > 3)
                                    urlFilter = locations[3];
                                if (locations.length > 4)
                                    options = locations[4];
                            }
                            let controlName = controlRef.props.name;
                            let urlData = {
                                control: controlName,
                                paging: JSON.stringify(paging),
                                filter: JSON.stringify(filter),
                                sort: JSON.stringify(order),
                                options: options,
                                urlFilter: urlFilter,
                                name: formName
                            };
                            
                            return thunks.configuredFetch(store.getState().settings.dataget + '?' + encodeQueryData(urlData))
                                .then(response => response.json())
                                .then(response => {
                                    if (response.success) {
                                        callback({
                                            sIndex: startIndex,
                                            pSize: pageSize,
                                            rowsCount: response.item["__" + controlName + "_totalcount"],
                                            items: response.item[controlName]
                                        });
                                    }
                                    else
                                        dispatch(actions.app.form.data.fetch.failure(response.message, response.details));
                                })
                                .catch(error => {
                                    dispatch(actions.app.form.data.fetch.failure(error.message, error.stack));
                                });
                        }
                        else if (type === 'workflowbar')
                        {
                            let urlFilter = null;
                            let locations = store.getState().router.location.pathname.split("/");
                            if (locations.length > 2 && (locations[1] === 'form' || locations[1] === 'flow')) { //filter & options from url
                                if (locations.length > 3)
                                    urlFilter = locations[3];
                            }
                            let urlData = {
                                urlFilter: urlFilter,
                                name: formName
                            };
                            return thunks.configuredFetch('/workflow/get?' + encodeQueryData(urlData))
                                .then(response => response.json())
                                .then(response => {
                                    if (response.success) {
                                      callback(response.item);
                                    }
                                    else
                                        dispatch(actions.app.form.data.fetch.failure(response.message, response.details));
                                })
                                .catch(error => {
                                    dispatch(actions.app.form.data.fetch.failure(error.message, error.stack));
                                });
                            
                        }
                        else
                        {
                            console.log("TODO: implement getAdditionalDataForControl method for "  + type + " control");
                            return Promise.resolve();
                        }
                    }

                }
            },
        licenseexpiry:
            {
                fetch: (successCallback) => {
                    return (dispatch) => {
                        dispatch(actions.app.licenseexpiry.fetch.begin());
                        return thunks.configuredFetch(store.getState().settings.licenseexpiryget)
                            .then(response => response.json())
                            .then(response => {
                                if (response.success) {
                                    dispatch(actions.app.licenseexpiry.fetch.success(response.item));
                                    if (successCallback)
                                        successCallback(response.item);
                                }
                                else
                                    dispatch(actions.app.licenseexpiry.fetch.failure(response.message, response.details));
                            })
                            .catch(error => {
                                dispatch(actions.app.licenseexpiry.fetch.failure(error.message, error.stack));
                            });
                    };
                }
            },
        autosave:
            {
                fetch: (successCallback) => {
                    return (dispatch) => {
                        dispatch(actions.app.autosave.fetch.begin());
                        return thunks.configuredFetch(store.getState().settings.autosaveget)
                            .then(response => response.json())
                            .then(response => {
                                if (response.success) {
                                    dispatch(actions.app.autosave.fetch.success(response.item));
                                    window.autoSaveDelay = response.item.delay;
                                    window.onAutoSave = response.item.autoSaveEnabled;
                                    if (successCallback)
                                        successCallback(response.item);
                                }
                                else
                                    dispatch(actions.app.autosave.fetch.failure(response.message, response.details));
                            })
                            .catch(error => {
                                dispatch(actions.app.autosave.fetch.failure(error.message, error.stack));
                            });
                    };
                },
                fetchIntra: (successCallback) => {
                    return (dispatch) => {
                        dispatch(actions.app.autosave.fetch.begin());
                        return thunks.configuredFetch(store.getState().settings.autosavegetintra)
                            .then(response => response.json())
                            .then(response => {
                                if (response.success) {
                                    dispatch(actions.app.autosave.fetch.success(response.item));
                                        window.autoSaveDelay = response.item.delay;
                                        window.onAutoSave = response.item.autoSaveEnabled;
                                    if (successCallback)
                                        successCallback(response.item);
                                }
                                else
                                    dispatch(actions.app.autosave.fetch.failure(response.message, response.details));
                            })
                            .catch(error => {
                                dispatch(actions.app.autosave.fetch.failure(error.message, error.stack));
                            });
                    };
                }
            },
    form:
        {
            clear: () => {
                return (dispatch) => {
                    dispatch(actions.app.form.clear());
                }
            },
            fetchform: (formname, ischild) => {
                return (dispatch) => {
                    dispatch(actions.app.form.model.fetch.begin());
                    let urlData = {
                        wrapresult: true,
                        enableSecurity: true
                    };
                    return thunks.configuredFetch(store.getState().settings.uiform + '/' + formname + '?' + encodeQueryData(urlData))
                        .then(response => response.json())
                        .then(response => {
                            if (response.success) {
                                let form = response.item;
                                dispatch(actions.app.form.model.fetch.success(JSON.parse(form.source), form.mapping, formname, ischild, form.cssCode, {
                                    schemes: form.schemes,
                                    securityGroup: form.securityGroup,
                                    permissions: form.permissions,
                                    mapping: form.mapping,
                                    name: form.name
                                }));
                            }
                            else
                                dispatch(actions.app.form.model.fetch.failure(response.message, response.details));
                        })
                        .catch(error => {
				if (!error.stack.includes('SyntaxError')){
                            		dispatch(actions.app.form.model.fetch.failure(error.message, error.stack));

				}
				else{
					alertify.error('A timeout has occurred. Please refresh your browser.');
                            		//dispatch(actions.app.form.data.fetch.failure('You have been logged off. Redirecting to login page', null));
					//window.location.href =  '/Account/Login';
				    	//window.setTimeout(function(){
				    	//    window.location.href = "/Account/Login";
				    	//}, 3000);
				}
                        });
                }
            },
            fetchformpreview: (formname, ischild) => {
                return (dispatch) => {
                    dispatch(actions.app.form.model.fetch.begin());
                    let urlData = {
                        wrapresult: true,
                        enableSecurity: true
                    };
                    let state = store.getState();
                    return thunks.configuredFetch(state.settings.uiform + '/' + formname + state.settings.uiformpreview + '?' + encodeQueryData(urlData))
                        .then(response => response.json())
                        .then(response => {
                            if (response.success) {
                                let form = response.item;
                                dispatch(actions.app.form.model.fetch.success(JSON.parse(form.source), form.mapping, formname, ischild, form.cssCode, {
                                    schemes: form.schemes,
                                    securityGroup: form.securityGroup,
                                    permissions: form.permissions,
                                    mapping: form.mapping,
                                    name: form.name
                                }));
                            }
                            else
                                dispatch(actions.app.form.model.fetch.failure(response.message, response.details));
                        })
                        .catch(error => {
                if (!error.stack.includes('SyntaxError')){
                                    dispatch(actions.app.form.model.fetch.failure(error.message, error.stack));

                }
                else{
                    alertify.error('A timeout has occurred. Please refresh your browser.');
                                    //dispatch(actions.app.form.data.fetch.failure('You have been logged off. Redirecting to login page', null));
                    //window.location.href =  '/Account/Login';
                        //window.setTimeout(function(){
                        //    window.location.href = "/Account/Login";
                        //}, 3000);
                }
                        });
                }
            },
            fetchflow: (flowname, urlFilter, ischild) => {
                return (dispatch) => {

                    let urlData = {
                        urlFilter: urlFilter
                    };

                    dispatch(actions.app.form.model.fetch.begin());
                    return thunks.configuredFetch(store.getState().settings.uiflow + "/" + flowname + "?" + encodeQueryData(urlData))
                        .then(response => response.json())
                        .then(response => {
                            if (response.success) {
                                let form = response.item;
                                dispatch(actions.app.form.model.fetch.success(JSON.parse(form.source), form.mapping, form.name, ischild, {
                                    schemes: form.schemes,
                                    securityGroup: form.securityGroup,
                                    permissions: form.permissions,
                                    mapping: form.mapping,
                                    name: form.name
                                }));
                            }
                            else
                                dispatch(actions.app.form.model.fetch.failure(response.message, response.details));
                        })
                        .catch(error => {
                            dispatch(actions.app.form.model.fetch.failure(error.message, error.stack));
                        });
                }
            },
            fetchdata: (filter, urlFilter, formname, index, ischild) => {
                return (dispatch) => {
                    dispatch(actions.app.form.data.fetch.begin());
                    let urlData = {
                        name: formname
                    };
                    if (filter) {
                        urlData.filter = JSON.stringify(filter);
                    }

                    if (urlFilter) {
                        urlData.urlFilter = urlFilter
                    }
                    return thunks.configuredFetch(store.getState().settings.dataget + '?' + encodeQueryData(urlData))
                        .then(response => response.json())
                        .then(response => {
                            if (response.success) {
                                for(var d in response.item){
                                    try {
                                        var item = response.item[d];
                                        if(typeof item === 'string'){
                                            var singleQuotedItem = item.replace(/'/g,"'");
                                            var parsedItem = JSON.parse(singleQuotedItem);
                                            if(Array.isArray(parsedItem)){
                                                response.item[d] = parsedItem;
                                            }
                                        }
                                    } catch (e){
                                    }
                                }
                                let isInternetAndNotSubmited = response.item.isInternetApplication && !response.item.formIsReadOnly;
                                if(isInternetAndNotSubmited && response.item.wogaaEnable && response.item.wogaaTransactionalServiceOn && response.item.wogaaTransactionalTrackingId != null && response.item.wogaaTransactionalTrackingId != '')
                                {
                                    try
                                    {
                                        window.wogaaCustom.startTransactionalService(response.item.wogaaTransactionalTrackingId); 
                                    } catch (e) { }
                                }
                                let isNew = typeof response.item === 'object' && 
                                    !Array.isArray(response.item) &&
                                    response.item.__id === null && !response.item.RespId;
                              
                                dispatch(actions.app.form.data.fetch.success(JSON.parse(JSON.stringify(response.item),dateReviver),
                                    formname,
                                    index,
                                    ischild,
                                    isNew));
                            }
                            else {
                                dispatch(actions.app.form.data.fetch.failure(response.message, response.details));
                            }
                        })
                        .catch(error => {
				if (!error.stack.includes('SyntaxError')){
                            		dispatch(actions.app.form.data.fetch.failure(error.message, error.stack));

				}
				else{
					//alertify.success('You have been logged off. Redirecting to login page');
                            		//dispatch(actions.app.form.data.fetch.failure('You have been logged off. Redirecting to login page', null));
					//window.location.href =  '/Account/Login';
				}

                        });
                }
            },
            savedata: (formname, ischild, index) => {
                return (dispatch) => {
                    let state = store.getState();
                    let data = state.app.form.data;
                    dispatch(actions.app.form.data.save.begin());
                    let urlData = {name: formname};
                    let formData = new FormData();
                    let isNeedRedirect = data.isNew;
                    formData.append('data', JSON.stringify(data.modified));
                    return thunks.configuredFetch(store.getState().settings.datachange + '?' + encodeQueryData(urlData),
                        {
                            method: 'post',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(response => {
                            if (response.success) {
                                let msg = "The changes have been applied!";
                                if(window.CloverAdminLang != undefined){
                                    msg = window.CloverAdminLang.msg.savedatasuccess;
                                }
                                let resp = response.item;
				            if(response.message!=undefined && response.message!=null)
					            msg = response.message;
                                alertify.success(msg);
                                let newData = (resp !== null && resp !== undefined) ? resp.entity : null;
                                let newId = (resp !== null && resp !== undefined) ? resp.entityId : null;
                                const containsData = newData !== null && newData !== undefined;
                                const containsnewId = newId !== null && newId !== undefined;
                                if (containsData)
                                {
                                    dispatch(actions.app.form.data.save.success(newData, formname, ischild, index));
                                }
                                else {
                                    dispatch(actions.app.form.data.save.success(null, formname, ischild, index));
                                }
                                //change Global state if required
                                //console.log("The response is", response);
                                thunksUtils.changeStateWithResult(response);

                                let isSurvey = (resp !== null && resp !== undefined && 
                                resp.entity!=null && resp.entity!=undefined && 
                                resp.entity.isSurvey!=null && resp.entity.isSurvey!=undefined) ? resp.entity.isSurvey : false;
                                            let surveyRedirect = (resp !== null && resp !== undefined && 
                                resp.entity!=null && resp.entity!=undefined && 
                                resp.entity.surveyRedirect!=null && resp.entity.surveyRedirect!=undefined) ? resp.entity.surveyRedirect : false;
                                            let surveyRedirectUrl = (resp !== null && resp !== undefined && 
                                resp.entity!=null && resp.entity!=undefined && 
                                resp.entity.surveyRedirectUrl!=null && resp.entity.surveyRedirectUrl!=undefined) ? resp.entity.surveyRedirectUrl : null;
                                            let urlFilter = (resp !== null && resp !== undefined && 
                                resp.entity!=null && resp.entity!=undefined && 
                                resp.entity.urlFilter!=null && resp.entity.urlFilter!=undefined) ? resp.entity.urlFilter : null;

                                if (isSurvey){
                                    if(surveyRedirect){
                                        dispatch(actions.router.push(surveyRedirectUrl));
                                        //window.location.href =  surveyRedirectUrl;
                                        
                                    }
                                    else{
                                        if (isNeedRedirect){
                                        //dispatch(actions.router.changeurlfilter(urlFilter));
                                        }
                                    }

                                }
                                else{
                                        if (isNeedRedirect){
                                            if (containsnewId)
                                                dispatch(actions.router.changeurlfilter(newId));
                                            else if (containsData)
                                                dispatch(actions.router.changeurlfilter(newData.__id));
                                        }
                                }
                                if (containsData) {
                                    return Promise.resolve({data: newData});
                                }
                                        }
                                else
                                    dispatch(actions.app.form.data.save.failure(response.message, response.details));
                                })
                            .catch(error => {
                                dispatch(actions.app.form.data.save.failure(error.message, error.stack));
                            });
                        }
            },
            swzReturnBackHome:() =>{
                let state = store.getState();
                if(state.router.history !== null && state.router.history.length > 2){
                    history.back();
                }else{
                    var goBackHome = state.settings.home;
                    dispatch(actions.router.push(goBackHome));
                }
                if(window.opener !== undefined && window.opener !== null){
                    window.opener.location.reload(false);
                }
            },
            swzsavedata: (formname, pageName, ischild, index, onAlertify, onSubmit, onHideLoadAnimation) => {
                return (dispatch) => {
                    let state = store.getState();
                    let data = state.app.form.data;		    
                    let model = state.app.form.models.model;
                    let hideControls = state.app.form.models.hideControls;
                    let spHideObj = {};
                    var changedObj = {};

                    if(window.location.pathname.indexOf("dlsi") == -1){
                        throw dispatch(actions.app.clearerrors);
                    }
                    /* 
                    if(data.modified.qnnRespId == undefined && data.modified.RespId == undefined) {
                        if(isSaving) {
                            throw dispatch(actions.app.form.data.save.failure("Previous saving is processing. Please try again later."));
                        } else {
                            isSaving = true;
                            console.log("Save Lock");
                        }
                    }
                    */

                    if(isSaving) {
                        return Promise.resolve();
                    } else {
                        isSaving = true;
                        console.log("Save Lock");
                    }

                    var newData = thunksUtils.changeHiddenControlVal(model, hideControls, data, changedObj, state);
                    newData.modified[state.settings.LastSavedPage] = pageName;
                    
                    if(!onHideLoadAnimation)
                        dispatch(actions.app.form.data.save.begin());
    
                    let urlData = {name: formname};
                    let formData = new FormData();
                    let isNeedRedirect = newData.isNew;
                    let currentTimeStamp = new Date();
                    formData.append('data', JSON.stringify(newData.modified));
                    let header = new Headers({
                        'AutoSave': onAlertify?'False':'True',
                        'SaveDraft': onSubmit?'False':'True',
                        'TimeStamp': currentTimeStamp.toJSON()
                    });
                
                    return thunks.configuredFetch('/data/change?' + encodeQueryData(urlData),
                        {
                            method: 'post',
                            body: formData,
			                headers: header
                        })
                        .then(response => response.json())
                        .then(response => {
                            if (response.success) {			
								if(onSubmit){
									if(data && data.modified && data.modified['isInternetApplication'] && 
									data.modified['wogaaEnable'] && data.modified['wogaaTransactionalServiceOn'] && data.modified['wogaaTransactionalTrackingId']){
										try
                                        {
                                            window.wogaaCustom.addMeta({ "agencyTxnId" : response.item.entity.qnnRespId });
											window.wogaaCustom.completeTransactionalService(data.modified['wogaaTransactionalTrackingId']);
                                        } catch(e){ }
									}
								}
                                let resp = response.item;
                                let isSurvey = (resp !== null && resp !== undefined && 
                                    resp.entity!=null && resp.entity!=undefined && 
                                    resp.entity.isSurvey!=null && resp.entity.isSurvey!=undefined) ? resp.entity.isSurvey : false;
                               
                                let msg = "The changes have been applied!";
                                if(window.CloverAdminLang != undefined)
                                    msg = window.CloverAdminLang.msg.savedatasuccess;
                                
                                if(onAlertify)
                                    alertify.success(msg);

                                thunksUtils.changeStateWithResult(response);  
                                                     

                                let newData = (resp !== null && resp !== undefined) ? resp.entity : null;
                                let newId = (resp !== null && resp !== undefined) ? resp.entityId : null;
    
                                const containsData = newData !== null && newData !== undefined;
                                const containsNewId = newId !== null && newId !== undefined;
                                if (containsData && !isSurvey) {
                                    dispatch(actions.app.form.data.save.success(newData, formname, ischild, index));
                                } else {
                                    if (isSurvey && containsData) {
                                        if (newData.surveyResponseVersion) {
                                            dispatch(actions.app.form.data.update("surveyResponseVersion", newData.surveyResponseVersion, formname, index, ischild, false));
                                        }
                                    }           
                                    dispatch(actions.app.form.data.save.success(null, formname, ischild, index));
                                }
             
                                let surveyRedirect = (resp !== null && resp !== undefined && 
                                resp.entity!=null && resp.entity!=undefined && 
                                resp.entity.surveyRedirect!=null && resp.entity.surveyRedirect!=undefined) ? resp.entity.surveyRedirect : false;
                                            
                                let surveyRedirectUrl = (resp !== null && resp !== undefined && 
                                resp.entity!=null && resp.entity!=undefined && 
                                resp.entity.surveyRedirectUrl!=null && resp.entity.surveyRedirectUrl!=undefined) ? resp.entity.surveyRedirectUrl : null;
                                            
                                let urlFilter = (resp !== null && resp !== undefined && 
                                resp.entity!=null && resp.entity!=undefined && 
                                resp.entity.urlFilter!=null && resp.entity.urlFilter!=undefined) ? resp.entity.urlFilter : null;


                                if(isSurvey){
                                    if(surveyRedirect){
                                        if(Boolean(surveyRedirectUrl)){
                                            //This part is about Anonymous Survey redirect with provided Completion URL
                                            defaultActions.redirect({parameters: {target:surveyRedirectUrl}});

                                            //You will get error in the console "TypeError: state.router.location.pathname is undefined"
                                            //Set it to undefined to stop the react rounting (if any e.g swzExit)
                                            dispatch(actions.router.routechanged([],{pathname: undefined}));
                                        }else{
                                            //Original handling
                                            dispatch(actions.router.push(surveyRedirectUrl));
                                        }
                                    }
                                    else if (isNeedRedirect){
       
                                    }
                                }
                                else{
                                    if(isNeedRedirect){
                                        if(containsNewId)
                                            dispatch(actions.router.changeurlfilter(newId));
                                        else if(containsData)
                                            dispatch(actions.router.changeurlfilter(newData.__id));
                                    }
                                }
                                if(containsData)
                                    return Promise.resolve({data: newData});
                        }
                        else {
                            //change Global state and add validation errors if required
                            thunksUtils.changeStateWithResult(response);
                            throw dispatch(actions.app.form.data.save.failure(response.message !== null ? response.message : undefined,
                                response.details !== null ? response.details : undefined,
                                undefined,
                                response.validationResult !== null && response.validationResult !== undefined
                                    ?  {main:response.validationResult} : undefined
                            ));
                            }
                        })
                        .catch(error => {
                            throw dispatch(actions.app.form.data.save.failure(error.message, error.stack));
                        })
                        .finally(() => {
                            if(isSaving) {
                                isSaving = false;
                                console.log("Save Unlock");
                            }
                        });
                }
            },
            swzpreviewdata: (formname, pageName, ischild, index, onAlertify, onSubmit, onHideLoadAnimation) => {
                return (dispatch) => {
                    let state = store.getState();
                    let data = state.app.form.data;		    
                    let model = state.app.form.models.model;
                    let hideControls = state.app.form.models.hideControls;
                    var changedObj = {};

                    var newData = thunksUtils.changeHiddenControlVal(model, hideControls, data, changedObj);
                    newData.modified[state.settings.LastSavedPage] = pageName;

                    const containsData = newData !== null && newData !== undefined;
                    if(containsData)
                        return Promise.resolve({data: newData});
                }
            },
            swzGetScanValue: (scanValue, propertyName) => {
                if(scanValue == undefined || scanValue == "")
                    return
                    
                store.dispatch(actions.app.form.data.update(propertyName, scanValue));
            },
            swzGetCaptchaValue: (captchaValue, propertyName) => {
                console.log("Captcha Value", captchaValue);
                if(captchaValue == undefined || captchaValue == "")
                    return
                
                store.dispatch(actions.app.form.data.update(propertyName, captchaValue));
            },
            swzGetServerDateTime: (format, propertyName) => {
                return () => {
                    let state = store.getState();
                    let data = state.app.form.data;
                    let url = store.getState().settings.swzGetServerDateTime;

                    let dateTimeFormat = {datetimeformat: format};
                    let formData = new FormData();
                    //formData.append('data', JSON.stringify(ids));
                    // Swzdata/softdelete?
                   
                    return thunks.configuredFetch(url +'?' + encodeQueryData(dateTimeFormat),
                        {
                            method: 'post',
                            body: formData
                        })
                        .then(response => response.json())
                        .then(response => {
                            if (response.success) {
                                store.dispatch(actions.app.form.data.update(propertyName, response.data));
                            }
                            else{
                                alertify.error("Unable to get time")
                                console.log(response.message);
                            }
                        })
                        .catch(error => {
                            alertify.error("Unable to get time");
                            console.log(error.message);
                        });
                }
            },
            updateData: (key, value, name, index, ischild, updateDisplayed) => {
                return (dispatch) => {
                    dispatch(actions.app.form.data.update(key, value, name, index, ischild, updateDisplayed));
                    return Promise.resolve();
                };
            },
            updateSurveyKey: (key, value) =>{
                store.dispatch(actions.app.form.data.update(key, value));
            },
            executeActions: (args) => {
                return (dispatch) => {
                    userActionInvoker(args, dispatch).catch(error => {
                        if (typeof error === "object" ) {
                            var details = error.details;
                            if(error.stack != undefined){
                                details = details == undefined ? 
                                    error.stack:
                                    details + "\nStack: " + error.stack;
                            }

                            if(console != undefined && details != undefined)
                                console.log(details);
                            dispatch(actions.app.form.data.save.failure(error.message, error.details, error.level, error.formerrors));
                        }
                        else{
                            dispatch(actions.app.form.data.save.failure(error, undefined));
                        }
                    });
                }
            }
        },
    common:{
        deleteByIds: (formname, requestingControl, ids, callback) => {
            return (dispatch) => {
                dispatch(actions.app.form.data.delete.begin());
                let urlData = {name: formname, requestingControl};
                let formData = new FormData();

                if (Array.isArray(ids)){
                    formData.append('data', JSON.stringify(ids));
                }
                else{
                    formData.append('data', JSON.stringify([ids]));
                }

                return thunks.configuredFetch(store.getState().settings.datadelete + '?' + encodeQueryData(urlData),
                    {
                        method: 'post',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(response => {
                        if (response.success) {
                            //change Global state if required
                            thunksUtils.changeStateWithResult(response);
                            dispatch(actions.app.form.data.delete.success(formname));
                            if (callback != undefined)
                                callback(response);
                        }
                        else {
                            thunksUtils.changeStateWithResult(response);

                            dispatch(actions.app.form.data.delete.failure(response.message !== null ? response.message : undefined,
                                response.details !== null ? response.details : undefined,
                                undefined,
                                response.validationResult !== null && response.validationResult !== undefined
                                    ?  {main:response.validationResult} : undefined
                            ));

                        }
                    })
                    .catch(error => {
                        dispatch(actions.app.form.data.delete.failure(error.message, error.details));
                    });
            }
        }  
    }
};

const thunksUtils = {
    // changeStateOnFailResult: function (response) {
    //     let stateDelta = {};
    //
    //     let needStateChange = false;
    //     if (response.result !== undefined && response.result !== null) {
    //         stateDelta = response.result;
    //         needStateChange = true;
    //     }
    //
    //     if (response.validationResult !== undefined && response.validationResult !== null) {
    //         stateDelta = mergeDeep(stateDelta, {
    //             app: {
    //                 form: {
    //                     errors: {
    //                         main: response.validationResult
    //                     }
    //                 }
    //             }
    //         });
    //         needStateChange = true;
    //     }
    //
    //     if (needStateChange) {
    //         store.dispatch(appActions.updatestate(stateDelta));
    //     }
    // },
    changeStateWithResult: function (response) {
        if (response.result !== undefined && response.result !== null) {
            store.dispatch(appActions.updatestate(response.result));
        }
    },

    isInput: function (type){
      if(type == "input" || type == "textarea"|| type == "checkbox" || type == "dropdown" || type == "radiogroup"){
        return true
      }else{
          false
      }
    },

    changeHiddenControlChildVal: function (model, data) {
       
        model.forEach(function(control, i){
           
            if(thunksUtils.isInput(control['data-buildertype'])){
                if(data.modified[control['key']] !== undefined && data.modified[control['key']] !== null)
                    data.modified[control['key']] = undefined;           
            }

            if(control.children !== undefined && control.children.length > 0){
                data = thunksUtils.changeHiddenControlChildVal(control.children, data);
            }
            
        });
        
        return data;
    },
    
    // This function is triggered by all save actions (Save, Next, Submit, Autosave) to clean up input values.
    // Input fields within visible conditions at the page, block, or table level will be cleared.
    changeHiddenControlVal: function (model, hideControls, data, changedObj, state) {
        var newData = data;
        var noNeedClearHiddenPageControls;
        model.forEach(function(control, i){
            if(changedObj[control["key"]] == undefined){
                for(let j = 0; j < hideControls.length; j++){
                    //Inputs without conditions but under conditioned containers
                    if(changedObj[hideControls[j]] == undefined){
                        if(control["key"] == hideControls[j]){ 

                            //If you are an input, you do not have a child, hence do not need to check for child hidden values.                                   
                            //Ensure controls under containers are set to undefined.
                            if(thunksUtils.isInput(control['data-buildertype'])){
                                newData.modified[control['key']] = undefined;
                                changedObj[hideControls[j]] = "AnsHidden";
                            }

                            // Check if page should be hidden, if yes , clear all data within that page.
                            noNeedClearHiddenPageControls = true;
                            if(control['data-buildertype'] === "swzPage"){
                                noNeedClearHiddenPageControls = control['other-visibleConition'] !== undefined && control['other-visibleConition'] !== "" 
                                ? formHelper.onHiddenPage(control, state, data.modified) : true;
                            }
                            if(!noNeedClearHiddenPageControls || control["data-buildertype"] === "block" || control["data-buildertype"] === "swzTable"){
                                //Hide all inputs under the container controls or page.
                                if(control.children !== undefined && control.children.length > 0){
                                    newData = thunksUtils.changeHiddenControlChildVal(control.children, newData);
                                }
                            }
                        }
                    }
                }
                //For parent without conditioning. To check for child
                if(control.children !== undefined && control.children.length > 0){
                    newData = thunksUtils.changeHiddenControlVal(control.children, hideControls, newData, changedObj);
                }
                
            }
        });
        return newData
    },
}

export default thunks