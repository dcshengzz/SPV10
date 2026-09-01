import appActions from '../actions.jsx';
import store from '../store.jsx';
import thunks from '../thunks/index.jsx';
import { jsonEqual, isEmptyObject, findFormElement, dateReviver, mergeDeep, uuid, encodeQueryData, isNull } from '../utils.jsx';
import confirm from '../components/confirmcomponent';
import { Promise } from 'es6-promise';
import JSON5 from 'json5';
import Papa from 'papaparse';
import { detectlocationapi } from '../detectlocationapi.jsx'
import { PrintActions } from "../../../swz-survey-builder/build/swz-form"

const userActionInvoker = ({actions, controlRef, sourceControlRef,sourceControlValue, parameters, component, formName, index, isChild}, dispatchFunc) => {
    if (!actions || actions.length < 1)
        return Promise.resolve();

    var formNameLower = formName === undefined || formName === null ? "" : formName.toLowerCase();
    
    let globalActions = window['globalUserActions'];
    let formActions = window[formNameLower + 'UserActions'];
    let originalState = store.getState();
    let state = { ...originalState };
    let data = !isChild ?
        (state.app.form.data.modified === null ? null : { ...state.app.form.data.modified }):
        (state.app.form.data.children[formName + "_" + index].modified == null ? null : { ...state.app.form.data.children[formName + "_" + index].modified });
    
    let originalData = !isChild ? 
        (state.app.form.data.original === null ? null : { ...state.app.form.data.original }): 
        (state.app.form.data.children[formName + "_" + index].original === null ? null : { ...state.app.form.data.children[formName + "_" + index].original }); //TODO subforms
    
    let promise = null;
    let stateDeltaAcc = {};

    for (let idx in actions){
        let action = actions[idx];
        if (!promise) {
            promise = actionToPromise(action, globalActions, formActions, controlRef, sourceControlRef, sourceControlValue, parameters, data, originalData, state, component, formName, index, isChild, dispatchFunc);
        } else {
            promise = promise.then(({data, stateDelta}) => {
                if (stateDelta) {
                    stateDeltaAcc = mergeDeep(stateDeltaAcc, stateDelta);
                    state = mergeDeep(state,stateDelta);
                }
                return actionToPromise(action, globalActions, formActions, controlRef, sourceControlRef,sourceControlValue, parameters, data, originalData, state, component, formName, index,  isChild, dispatchFunc);
            });
        }
    }
    
    promise = promise.then(({ data, stateDelta }) => {
        
        if (stateDelta)
            stateDeltaAcc = mergeDeep(stateDeltaAcc, stateDelta);
        if (!isChild) {
            if (!jsonEqual(originalState.app.form.data.modified, data)) {
                stateDeltaAcc = mergeDeep(stateDeltaAcc, {app: {
                    form:{
                        data:{
                            modified: data, 
                            displayed: data}
                        }
                    }
                });
            }
        }
        else
        {
            if (!jsonEqual(originalState.app.form.data.children[formName + "_" + index].modified, data)) {
                let delta = {app: {form: {data: {children :{}}}}};
                delta.app.form.data.children[formName + "_" + index] = {modified: data, displayed: data};
                stateDeltaAcc = mergeDeep(stateDeltaAcc, delta);
            }
        }

        if (!isEmptyObject(stateDeltaAcc))
            dispatchFunc(appActions.updatestate(stateDeltaAcc));
    });

    return promise;
};

const actionToPromise =
    (action, globalActions, formActions, controlRef, sourceControlRef, sourceControlValue, parameters, data, originalData, state, component, formName, index, isChild, dispatchFunc) => {
    let actionFunc = null;
        if (formActions)
            actionFunc = formActions[action];
        if (!actionFunc && globalActions)
            actionFunc = globalActions[action];
        if (!actionFunc)
            actionFunc = defaultActions[action];
        if (!actionFunc)
            return Promise.reject('Action ' + action + ' is not defined.');
        let production = null;
        try {
            production = actionFunc({
                data: data,
                originalData: originalData,
                state: state,
                component: component,
                formName: formName,
                index: index,
                controlRef: controlRef,
                sourceControlRef: sourceControlRef,
                sourceControlValue: sourceControlValue,
                parameters: parameters, 
                isChild: isChild
            });
        } catch (err) {
            return Promise.reject(err);
        }

        if (production instanceof Function) {

            return production(dispatchFunc).then((result) => {
                return Promise.resolve({
                    data: (result && result.data) ? result.data : data,
                    stateDelta: (result && result.stateDelta) ? result.stateDelta : null
                });
            });
        }
        
        return Promise.resolve({ data: data, stateDelta: production });
    };
/* 
Model properties and its usage.
    items - Copies the entire model. This is used for rendering page menu
    validatedPages - Identify which page has been validated
*/

const formHelper = {
    getControlsForValidate: (model) => {
        let controls = [];
        model.forEach(function(control, i){
            if(control["other-required"] === true ||
                (control["other-customValidation"] !== undefined && control["other-customValidation"] !== "")){
                controls.push(control);
            }

            if(control.children !== undefined && control.children.length > 0){
                let cs = formHelper.getControlsForValidate(control.children);
                controls = controls.concat(cs);
            }
            
            /* if(control.placeholders !== undefined){
                for(let ps in control.placeholders){
                    let cs = formHelper.getControlsForValidate(control.placeholders[ps]);
                    controls = controls.concat(cs);
                }
            }
            if(control["data-buildertype"] == "customblock" && control.sourceType == "source" && control.source != undefined){
                var children = JSON5.parse(model[i].source);
                let cs = formHelper.getControlsForValidate(children);
                controls = controls.concat(cs);               
            } */
        });
        
        return controls;
    },
    validate: (control, value, data) => {
        let error = undefined;
        if(data && data['onViewMode']){
            return error;
        }
        if (control["other-required"] === true && (value === undefined || value === null || value === '')){
            error = control.key + ' is required!';
        if(control["reference"] !== undefined && control["reference"] !== null && control["reference"] !== '') error = control["reference"] + ' is required!';
        
            return error
        }
        else if (control["other-customValidation"] !== undefined && control["other-customValidation"] !== ""){
            let args = 'value, data';
            let body = 'return ' + control["other-customValidation"];
            var isValid;
            try{
                isValid = new Function(args, body)(value, data);
            }catch(err){
                console.log('Logic error - validate ', control.key, err);
            }

            if (typeof isValid === 'boolean'){
                if (isValid === false) {
                    error = true;
                    console.log('isValid is false');
                }
            }
            else{
                error = control.key + ' ' + isValid;
                //console.log("Error", error);
	        if(control["reference"] !== undefined && control["reference"] !== null && control["reference"] !== '') error = control["reference"] + ' ' + isValid;
            }
        }
        return error;
    },
    initDefaultState: (model, data) => {
        if(!Array.isArray(model) || data === undefined)
            return;

        for(let i=0; i < model.length; i++){
            if(model[i]["defaultValue"])
                data[model[i].key] = model[i]["defaultValue"];
      
            if(Array.isArray(model[i].children))
                formHelper.initDefaultState(model[i].children, data);

           /*  if(model[i].placeholders !== undefined){
                for(let ps in model[i].placeholders){
                    formHelper.initDefaultState(model[i].placeholders[ps], data);
                }
            } */

            /* if(model[i]["data-buildertype"] == "customblock" && model[i].sourceType == "source" && model[i].source != undefined){
                var children = JSON5.parse(model[i].source);
                formHelper.initDefaultState(children, data);
            } */
        }
    },
    checkPermission: (permission, state) => {
        const permissions = state.app.form.formParams.permissions;
        if(Array.isArray(permissions)){
            for(let i = 0; i < permissions.length; i++){
                if(permissions[i].code === permission){
                    return permissions[i].accessType === 1 || permissions[i].accessType === 0;
                }
            }
        }
        return false;
    },
    checkRole: (role, state) => {
        //ZL Change 130220
        //return (state.app.user === undefined || state.app.user.roles === undefined) ? false : state.app.user.roles.includes(role);
        return (!state.app.user || !state.app.user.roles) ? false : state.app.user.roles.includes(role);
    },
    checkPageCondition:({pageModel, data, state}) =>{
       
        var res = true;
        //True means page is visible
        //False means page is not visible as did not fulfill condition
        if(pageModel === null || data === null)
            return res;

        var model = state.app.form.models.model;
        var pageKey = pageModel['key'];

        var checkSkipConditions = function (model, data, state, pageKey){
            let fullModel = state.app.form.models.model;
        
            for(let i=0; i < model.length; i++){
                let skipCondition = model[i]["other-skipConition"];
                //Swz SkipToPage property addition
                if(skipCondition){
                    let args = 'data';
                    let body = 'return ' + skipCondition;               
                    //If it is false, add it to hidecontrols
                    var startControl = model[i]['key'];
                    var endControl;
                    try{
                        endControl = new Function(args, body)(data);
                    }
                    catch(err){
                        console.log('Logic error - skip ', pageKey, err);
                    }
                    if(endControl){
                        //Add controls that are between this control and targetted control
                        let foundControl = {};
                        let endControlParent = formHelper.swzGetEndControlParent(fullModel, endControl);
                        let onPageSkip = formHelper.swzOnSkipPage(fullModel, startControl, endControl, endControlParent, foundControl, pageKey);
                        return onPageSkip
                    }
                }

                if(Array.isArray(model[i].children)){
                    let onPageSkip = checkSkipConditions(model[i].children, data, state, pageKey);
                    if(!onPageSkip){
                        return false
                    }
                }
            }
            return true;
        }

        var onSkip = checkSkipConditions(model, data, state, pageKey) 
        if(onSkip == false)
            return false
        
        let condition = pageModel["other-visibleConition"];
        if(condition !== undefined && condition !== ""){
            let args = 'data, checkPermission, checkRole';
            let body = 'return ' + condition;
            let bool;
            try{ 
                bool =new Function(args, body)(data,
                    function(permission) { return formHelper.checkPermission(permission, state)}, 
                    function(role) { return formHelper.checkRole(role, state)}); 
            }
            catch(err){
                console.log('Logic error - visible ', pageKey, err);
            }
            if(!bool){
                //res.hideControls.push(pageModel.key);
                return false
            }
        }
      
        return res;
    },
    checkConditions: ({model, data, state}) => {
        let res = {
            hideControls: [],
            readOnlyControls: []
        };
        let onPageDisplayObj = {};
        var fullModel = state.app.form.models.model;

        if(model === null || data === null){
            return res;
        }

        for(let i=0; i < model.length; i++){
            let condition = model[i]["other-visibleConition"];
            let skipCondition = model[i]["other-skipConition"];
            //Swz page property addition
            let isPage = model[i]['data-buildertype'] == "swzPage" ? true : false 
            if(isPage){
                //Put page in hide control if onPageDisplay is false
                if(!model[i]['onpagedisplay']){
                    res.hideControls.push(model[i].key);
                    onPageDisplayObj[i] == "HideControlAdded"
                }
            }
            //Swz SkipToPage property addition
            if(skipCondition){
                let args = 'data';
                let body = 'return ' + skipCondition;
               
                //If it is false, add it to hidecontrols
                var startControl = model[i]['key'];
                var endControl;
                
                try{
                    endControl = new Function(args, body)(data);
                }
                catch(err){
                    console.log('Logic error - skippage ', model[i].key, err);
                }
                if(endControl){
                   //Add controls that are between this control and targetted control
                   let foundControl = {};
                   let endControlParent = formHelper.swzGetEndControlParent(fullModel, endControl);
                   let skipControls = formHelper.swzGetControlsForSkip(fullModel, startControl, endControl, endControlParent, foundControl);
                   res.hideControls = res.hideControls.concat(skipControls);
                }
            }

            if(condition !== undefined && condition !== ""){
                let args = 'data, checkPermission, checkRole';
                let body = 'return ' + condition;
                let bool;
                try{ 
                    bool = new Function(args, body)(data,
                        function(permission) { return formHelper.checkPermission(permission, state)}, 
                        function(role) { return formHelper.checkRole(role, state)}); 
                }
                catch(err){
                    console.log('Logic error - condition ', model[i].key, err);
                }
                if(!bool){
                    //Ensure we do not extra page to hide control
                    if(onPageDisplayObj[i] == undefined && model[i]['data-buildertype'] !== "swzPage"){
                        res.hideControls.push(model[i].key);
                    }
                    //Clear the data if it is survey question
                    if(data.IsSurvey){
                        CloverApp.API.setDataField(model[i].key, '');
                    }

                }
            } 
      
            condition = model[i]["other-readOnlyConition"];
            if(condition !== undefined && condition !== ""){
                let args = 'data, checkPermission, checkRole';
                let body = 'return ' + condition;
                let bool;
                try{
                    bool  = new Function(args, body)(data, 
                        function (permission) { return formHelper.checkPermission(permission, state);}, 
                        function (role) { return formHelper.checkRole(role, state);});
                }
                catch(err){
                    console.log('Logic error - read only ', model[i].key, err);
                }

                if(bool){
                    res.readOnlyControls.push(model[i].key);
                }
            } 

            if(Array.isArray(model[i].children)){
              const c = formHelper.checkConditions({model: model[i].children, data, state});
              res = {
                  hideControls: res.hideControls.concat(c.hideControls),
                  readOnlyControls: res.readOnlyControls.concat(c.readOnlyControls),
              };
            }

            if(model[i].placeholders !== undefined){
                for(let ps in model[i].placeholders){
                    const c = formHelper.checkConditions({model: model[i].placeholders[ps], data, state});
                    res = {
                        hideControls: res.hideControls.concat(c.hideControls),
                        readOnlyControls: res.readOnlyControls.concat(c.readOnlyControls),
                    };
                }
            }

            if(model[i]["data-buildertype"] == "customblock" && model[i].sourceType == "source" && model[i].source != undefined){
                var children = JSON5.parse(model[i].source);
                const c = formHelper.checkConditions({model: children, data, state});
                res = {
                    hideControls: res.hideControls.concat(c.hideControls),
                    readOnlyControls: res.readOnlyControls.concat(c.readOnlyControls),
                };
            }
        }

        return res;
    },
    swzGetControlsForHide: (model, hideControls) => {
        
        let controls = [];
        var changedObj = {};

        var swzGetControlsChildForHide = function (model) {
            let childControls = [];
            model.forEach(function(control, i){
            if(changedObj[control["key"]] == undefined){
                //Add the input controls - Only need to ensure the required prompt and validation does not show up)
                //Add input only if required & validation is checked
               let onValidation = (control["other-required"] == true || (control["other-customValidation"] !== undefined && control["other-customValidation"] !== ""));            
    
              if(formHelper.isInput(control['data-buildertype'])){   
                if(onValidation){
                        childControls.push(control["key"]);
                        changedObj[control["key"]] = "ControlHidden";
                }
              }
    
                if(control.children !== undefined && control.children.length > 0){                  
                    let child = swzGetControlsChildForHide(control.children);
                    childControls = childControls.concat(child);
                } 
            }
            });
            return childControls;
        }

        model.forEach(function(control, i){
            if(changedObj[control["key"]] == undefined){
                for(let j = 0; j < hideControls.length; j++){
                    //Inputs without conditions but under conditioned containers
                    if(changedObj[hideControls[j]] == undefined){
                        if(control["key"] == hideControls[j]){
                            let onValidation = (control["other-required"] == true || (control["other-customValidation"] !== undefined && control["other-customValidation"] !== ""));
            
                            //Check onvalidation ltr
                            if(formHelper.isInput(control['data-buildertype']) || onValidation){
                                controls.push(control["key"]);
                                changedObj[hideControls[j]] = "ControlHidden";
                            }

                            if(formHelper.isContainer(control['data-buildertype'])){
                                if(control.children !== undefined && control.children.length > 0){
                                    //250919 - Just get inputs for the whole page
                                    let cs = swzGetControlsChildForHide(control.children);
                                    controls = controls.concat(cs);
                                }
                            }
                        }
                    }
                }
                if(control.children !== undefined && control.children.length > 0){
                    let cs = formHelper.swzGetControlsForHide(control.children, hideControls);
                    controls = controls.concat(cs);
                }   
            }
        });

        return controls;
    },
    swzPrintModel: (model) => {

        if(model === null)
            return null;
        var newModel = model;
        for(let i=0; i < newModel.length; i++)
        {
            newModel[i]['items'] = newModel;
        }

        return newModel;
    },
    swzGetHiddenControlsForPrint: (model, data, originalModel, IsIncludeUnansweredSection) => {
        var hiddenControls = [];
        var fullModel = originalModel;
        var afterCurrentPage = false;
        let onPageDisplayObj = {};

        //Data is required for checking skip condition.
        if(model === null || data === null)
            return null;
        for(let i=0; i < model.length; i++)
        {
            let isPage = model[i]['data-buildertype'] == "swzPage" ? true : false
            let visibleCondition = model[i]["other-visibleConition"];
            let skipCondition = model[i]["other-skipConition"];

            //IMDA Print Behavior : print and render the print file to be all answered sections (with skip logic)
            if(isPage && !IsIncludeUnansweredSection)
            {          
                //assign first page as the last saved page.
                if(data['LastSavedPage'] === undefined ){
                    data['LastSavedPage'] = model[0].key;
                }

                if(model[i]['key'] !== data['LastSavedPage'] && afterCurrentPage) {
                    hiddenControls.push(model[i].key);
                    onPageDisplayObj[i] == "HideControlAdded"
                }
                else if(model[i]['key'] === data['LastSavedPage'] && !afterCurrentPage)
                {
                    afterCurrentPage = true
                }
            }
            //MPA Print Behavior : print and render the print file to be all answered sections (with skip logic) + unanswered sections (empty)
            // Do nothing. Since it print all pages and check skip, visible, custom conditions.
			
            //SkipCondition
            if(skipCondition)
            {
                let args = 'data';
                let body = 'return ' + skipCondition;          
                var startControl = model[i]['key'];
                var endControl;
                
                try{
                    endControl = new Function(args, body)(data);
                }
                catch(err){
                    console.log('Logic error - skip Condition ', model[i].key, err);
                }
                if(endControl){
                   //Add controls that are between current control and targetted control into hiddenControls
                   let foundControl = {};
                   let endControlParent = formHelper.swzGetEndControlParent(fullModel, endControl);
                   let skipControls = formHelper.swzGetControlsForSkip(fullModel, startControl, endControl, endControlParent, foundControl);
                   hiddenControls = hiddenControls.concat(skipControls);
                }
            }

            //VisibleCondition
            if(visibleCondition !== undefined && visibleCondition !== "")
            {
                let args = 'data';
                let body = 'return ' + visibleCondition;
                let bool;
                try{ 
                    bool = new Function(args, body)(data); 
                }
                catch(err){
                    console.log('Logic error - visible Condition ', model[i].key, err);
                }
                if(!bool){
                    if(onPageDisplayObj[i] == undefined){
                        hiddenControls.push(model[i].key);
                    }
                }
            } 
      
            if(Array.isArray(model[i].children))
            {
              const childHiddenControls = formHelper.swzGetHiddenControlsForPrint(model[i].children, data, originalModel, IsIncludeUnansweredSection);
              hiddenControls = hiddenControls.concat(childHiddenControls);
            }

            if(model[i]["data-buildertype"] == "customblock" && model[i].sourceType == "source" && model[i].source != undefined)
            {
                var children = JSON5.parse(model[i].source);
                const childHiddenControls = formHelper.swzGetHiddenControlsForPrint(children, data, originalModel, IsIncludeUnansweredSection);
                hiddenControls = hiddenControls.concat(childHiddenControls);
            }

            if(model[i].placeholders !== undefined)
            {
                for(let ps in model[i].placeholders)
                {
                    const childHiddenControls = formHelper.swzGetHiddenControlsForPrint(model[i].placeholders[ps], data, originalModel, IsIncludeUnansweredSection);
                    hiddenControls = hiddenControls.concat(childHiddenControls);
                }
            }
        }

        return hiddenControls;
    },
    swzGetControlsForValidate: (model) => {
        let controls = [];
        model.forEach(function(control, i){
            if(control["other-required"] === true ||
                    (control["other-customValidation"] !== undefined && control["other-customValidation"] !== "")){
                            controls.push(control);
            }
            if(control.children !== undefined && control.children.length > 0){
                let cs = formHelper.swzGetControlsForValidate(control.children);
                controls = controls.concat(cs);
            }
            /* if(control.placeholders !== undefined){
                for(let ps in control.placeholders){
                    let cs = formHelper.swzGetControlsForValidate(control.placeholders[ps]);
                    controls = controls.concat(cs);
                }
            }
            if(control["data-buildertype"] == "customblock" && control.sourceType == "source" && control.source != undefined){
                var children = JSON5.parse(model[i].source);
                let cs = formHelper.swzGetControlsForValidate(children);
                controls = controls.concat(cs);               
            } */
        });
        
        return controls;
    },
    swzGetControlsForValidateNonMan: (model) => {
        let controls = [];
        model.forEach(function(control, i){
            if(control["other-required"] === true && control["other-required-soft"] !== true||
                    (control["other-customValidation"] !== undefined && control["other-customValidation"] !== ""
                    && control["other-customValidation-soft"] !== true)){
                            controls.push(control);
            }
            if(control.children !== undefined && control.children.length > 0){
                let cs = formHelper.swzGetControlsForValidateNonMan(control.children);
                controls = controls.concat(cs);
            }
           /*  if(control.placeholders !== undefined){
                for(let ps in control.placeholders){
                    let cs = formHelper.swzGetControlsForValidateNonMan(control.placeholders[ps]);
                    controls = controls.concat(cs);
                }
            }
            if(control["data-buildertype"] == "customblock" && control.sourceType == "source" && control.source != undefined){
                var children = JSON5.parse(model[i].source);
                let cs = formHelper.swzGetControlsForValidateNonMan(children);
                controls = controls.concat(cs);               
            } */
        });
        
        return controls;
    }, 
    swzGetControlsForInputType: (model) => {
        let controls = [];

        model.forEach(function(control, i){
            if(control["data-buildertype"] === "radiogroup" || control["data-buildertype"] === "dropdown" || 
            control["data-buildertype"] === "input" || control["data-buildertype"] === "checkbox" || control["data-buildertype"] === "textarea"){
                controls.push(control);
            }

            if(control.children !== undefined && control.children.length > 0){
                let cs = formHelper.swzGetControlsForInputType(control.children);
                controls = controls.concat(cs);
            }
            
            /* if(control.placeholders !== undefined){
                for(let ps in control.placeholders){
                    let cs = formHelper.swzGetControlsForInputType(control.placeholders[ps]);
                    controls = controls.concat(cs);
                }
            }
            if(control["data-buildertype"] == "customblock" && control.sourceType == "source" && control.source != undefined){
                var children = JSON5.parse(model[i].source);
                let cs = formHelper.swzGetControlsForInputType(children);
                controls = controls.concat(cs);               
            } */
        });
        
        return controls;
    },
    swzGetPageControlForKey: (model, parentControl, pageKey, key) => {
        let controls = [];
        var item = {};
        var pageMasterKey;

        if(parentControl == null || parentControl == undefined){
            var parentControl = null;
        }
        if(pageKey == undefined){
            pageMasterKey = undefined;
        }

        model.forEach(function(control, i){
            if(control["key"] === key){
                item = {
                    childKey: control,
                    parentKey: parentControl,
                    masterKey: pageKey
                }
                controls.push(item);
                return controls;
            }
            
            if(control.children !== undefined && control.children.length > 0){
                if(control['data-buildertype'] == "swzPage"){
                    pageMasterKey = control.key 
                }else{
                    pageMasterKey = pageKey;
                }
              let cs = formHelper.swzGetPageControlForKey(control.children, control.key, pageMasterKey, key);
              controls = controls.concat(cs);
            }
        }
        );
        return controls;
    }, 
    swzFindLastEmptyInput: (data, allControls, hiddenControls) => {
        var key;
        var hideObj = {};
        var controlObj = {};
    
        if(allControls.length > 0 ){
            for(let i=0; i < allControls.length; i++){
                if(hiddenControls !== undefined && hiddenControls !== null){
                    if(hiddenControls.length > 0){
                        for(let j=0; j < hiddenControls.length; j++){
                            if(hideObj[j] == undefined){
                                if(allControls[i].key == hiddenControls[j]){
                                    hideObj[j] = true;
                                    controlObj[i] = allControls[i].key;
                                }
                            }
                        }   
                    }
                }
                if(controlObj[i] !== undefined){
                    allControls[i]['bypass-validation'] = true;
                }else{
                    allControls[i]['bypass-validation'] = false;    
                    let attr = allControls[i].key;
                    if(data[attr] == null || data[attr] == ""){
                        key = allControls[i].key;                
                        return key;
                    }
                }
            }
        }
    },
    swzRemoveHideControls: (controls, spHideControls) => {
        var pageControls = [];
        var noValidObj = {};
        var spHideObj = {};
    
        pageControls = controls;
        for(var x = 0; x < controls.length; x++){        
            if(controls[x]['bypass-validation']){
                pageControls[x]['bypass-validation'] = false;
            }
            if(spHideControls.length > 0){
                for(let q = 0; q < spHideControls.length; q++){
                    if(spHideObj[q] == undefined){
                        if(controls[x]["key"] == spHideControls[q]){
                            noValidObj[x] = controls[x]["key"];
                            spHideObj[q] = spHideControls[q];
                        }
                    }
                } 
                if(noValidObj[x] != undefined){
                    pageControls[x]["bypass-validation"] = true;
                }else{
                    pageControls[x]["bypass-validation"] = false;
                }
            }
        }

        return pageControls
    },
    swzSinglePageValidationStatus: (data, state, formName, isChild, hideControls, pageModel) => {
        //Check if menu exist
        var spHideControls = [];
        var error = 'Page proceed as per normal';
        var spModel = [];

        spModel.push(pageModel);
        //Get Single Page HideControls
        if(hideControls !== undefined && hideControls !== null){
            if(hideControls.length > 0 ){
                spHideControls = formHelper.swzGetControlsForHide(spModel, hideControls);
            }
        }

        //Get Controls that require validation and then remove them.
        var controls = !isChild ? formHelper.swzGetControlsForValidateNonMan(spModel) :
            formHelper.swzGetControlsForValidateNonMan(state.app.form.models.children[formName].model);
    
        var pageControls = formHelper.swzRemoveHideControls(controls, spHideControls);
     
        //Check of controls
        for (let i=0; i < pageControls.length; i++){
            let key = pageControls[i].key;
            if(pageControls[i]["bypass-validation"] == undefined || pageControls[i]["bypass-validation"] == false){
                error = formHelper.validate(pageControls[i], data[key], data);
                if (error){
                    error = pageControls[i];
                    return false
                }
            }   
        }
        return true
    },
    onHiddenPage: (pageModel, state, data) =>{
        /*
        Check if page is part of condition
        True means we can use the page
        False means we cannot use the page
        */
        
        let res = formHelper.checkPageCondition({pageModel, data, state});
        return res
    },
    swzGetCurrentPage: (state) =>{
        var newModel = state.app.form.models.model;
        
        for(let i = 0; i < newModel.length; i++){
            if(newModel[i]['data-buildertype'] == "swzPage" && newModel[i]['onpagedisplay'])
                return newModel[i]['key'];
        }

        return newModel[0]['key'];

    },
    swzGoPage: (state, page, validatedPages, data, hideControls) => {
        var lastSavedKey = state.settings.onLastSavedKey;
        var newModel = state.app.form.models.model;
	var pageExists = false;
	var firstPageIndex;
        if(page){
            if(newModel){
                for(var i=0; i < newModel.length; i++) {
                    //Load items
                    newModel[i]['items'] = newModel;
                    newModel[i]['validatedpages'] = validatedPages;
		    if(newModel[i]['data-buildertype'] == "swzPage" && firstPageIndex==null){
			        firstPageIndex = i;
		    }
                    if(newModel[i].key == page && newModel[i]['data-buildertype'] == "swzPage") {
                        window.scrollTo({ top: 0, behavior: 'smooth' })
                        newModel[i]['onpagedisplay'] = true;
            			pageExists = true;
                    }
                    //Close page if there is one
                    else {
                        if(newModel[i]['onpagedisplay'] == true){
                            newModel[i]['onpagedisplay'] = false;
                        }
                    }
                }
		if(!pageExists && firstPageIndex!=null){
			newModel[firstPageIndex]['onpagedisplay'] = true;
		}
            }
        }else{
            newModel = formHelper.addItemsValidatedPages(newModel, validatedPages);
        }
        var count = 0;
        if(data.FirstHitLastSaved !== undefined){
            count = data.FirstHitLastSaved;
            count += 1
        }else{
            count = 1;
        }
        thunks.form.updateSurveyKey("FirstHitLastSaved", count); //Helps to re render 3x to ensure last saved is loaded
        if(data.FirstHitLastSaved >= 3){
            thunks.form.updateSurveyKey(lastSavedKey, true);
        }
        return {
                app:{
                    form:{
                        models:{
                            hideControls: hideControls,
                            //Add read only later
                            //readOnlyControls: checkConditions.readOnlyControls,
                            model: newModel
                        }
                    }
                }
        }
    },
    addItemsValidatedPages: (newModel, validatedPages) => {
        for (var i=0; i < newModel.length; i++) {
            newModel[i]['items'] = newModel;
            newModel[i]['validatedpages'] = validatedPages;
        }
        return newModel
    },
    swzRedirect: (parameters) => {
        if (parameters === undefined || parameters.target === undefined){
            console.error("For call 'redirect' action you need to set the 'target' parameter!");
            return;
        }

        if (parameters.target.includes("http://") || parameters.target.includes("https://")){
            document.location.href = parameters.target;
        }
        else {
            return {
                router: {
                    push: parameters.target
                }
            };
        }
    },
    isInput: function (type){
        if(type == "input" || type == "textarea"|| type == "checkbox" || type == "dropdown" || type == "radiogroup"){
          return true
        }else{
            return false
        }
    },
    isContainer: function (type){
        if(type == "swzPage" || type == "block" || type == "swzTable"){
            return true
        }else{
            return false
        }
    },
    changeHiddenControlVal: function (model, hideControls, data, changedObj, state , originalData) {
        
        var newData = data;
        var res;

        var changeHiddenControlChildVal = function (model, data) {
            model.forEach(function(control, i){
                if(changedObj[control['key']] == undefined){
                    if(formHelper.isInput(control['data-buildertype'])){
                        if(data.modified[control['key']] !== undefined && data.modified[control['key']] !== null){
                          //  if(control['data-buildertype'] !== "checkbox"){
                                data.modified[control['key']] = undefined;           
                           // }else{
                               // data.modified[control['key']] = 0;           
                           // }
                        }
                            
                            changedObj[control["key"]] = "ControlHidden";
                        }

                    if(control.children !== undefined && control.children.length > 0)
                        data = changeHiddenControlChildVal(control.children, data);
                }
            });
            return data;
        
        }

        model.forEach(function(control, i){
            if(changedObj[control["key"]] == undefined){
                for(let j = 0; j < hideControls.length; j++){
                    //Inputs without conditions but under conditioned containers
                    if(changedObj[hideControls[j]] == undefined){
                        if(control["key"] == hideControls[j]){ 

                            //If you are an input, you do not have a child, hence do not need to chheck for child hidden values.                                   
                            //Ensure controls under containers are set to undefined.
                            if(formHelper.isInput(control['data-buildertype'])){
                                //if(control['data-buildertype'] !== "checkbox"){
                                    newData.modified[control['key']] = undefined;
                               // }else{
                                   // newData.modified[control['key']] = 0;           
                                //}
                                changedObj[hideControls[j]] = "AnsHidden";
                            }
                            res = true;
                            if(control['data-buildertype'] === "swzPage"){
                                //Might need to update this to -> formHelper.onHiddenPage(newModel[i], state, data)
                                res = control['other-visibleConition'] !== undefined && control['other-visibleConition'] !== "" ? 
                                formHelper.onHiddenPage(control, state, data.modified):
                                true;
                            }
                            
                            if(!res ||
                                control["data-buildertype"] === "block" || control["data-buildertype"] === "swzTable"){
                                //Hide all inputs under the container controls
                                if(control.children !== undefined && control.children.length > 0)
                                    newData = changeHiddenControlChildVal(control.children, newData);
                            }
                        }
                    }
                }
                /*
                    1. If checkbox is hidden -> ignore 
                    2. If check box is not hidden,
                        -Check if it exist under "Ans Hidden"
                        -If not change it to 0. 
                */
               //Hide this for awhile to prevent performance issue
                 if(control['data-buildertype'] == "checkbox"){
                    if(changedObj[control['key']] == undefined || changedObj[control['key']] == null){
                        if(newData.modified[control['key']] == undefined || newData.modified[control['key']] == '')
                            newData.modified[control['key']] = 0;
                    }
                } 

                //For parent without conditioning. To check for child
                if(control.children !== undefined && control.children.length > 0)
                    newData = formHelper.changeHiddenControlVal(control.children, hideControls, newData, changedObj, state, originalData);
                
            }
        });
        return newData
    },
    swzGetControlsForSkip: function (model, startControl, endControl, endControlParent, foundControl) {

        let controls = [];
        for(var i in model){
            var cond = foundControl[startControl] !== "Found" && startControl == model[i]['key']; 
            
            if(cond)
               foundControl[startControl] = "Found";            
            
            if(foundControl[endControl] == "Found")
                return controls;

            if(endControl == model[i]['key']){
                foundControl[endControl] = "Found";
                break;
            }

            if (foundControl[startControl]=="Found"&&model[i]['key']!=startControl&&!(endControlParent && endControlParent.includes(model[i].key))){
                controls.push(model[i]['key']);
                CloverApp.API.setDataField(model[i].key, '');
            }
                

            if(model[i].children && model[i].children.length){
                let cs = formHelper.swzGetControlsForSkip(model[i].children, startControl, endControl, endControlParent, foundControl);
                controls = controls.concat(cs);
            }
        };
        
        return controls;
    },
    swzOnSkipPage: function (model, startControl, endControl, endControlParent, foundControl, pageKey) {
        
        let res = true;

        var isEndControlParent = function(key, endControlParent) {
            if(endControlParent && endControlParent.length > 0){
                for(let i = 0; i < endControlParent.length; i++){
                    if(key == endControlParent[i])
                        return true
                }
                return false
            }
        
        }

        for(var i in model){
            if(foundControl[startControl] !== "Found" && model[i]['key'] == startControl)
                foundControl[startControl] = "Found";
            
            
            if(foundControl[endControl] == "Found")
                return true
            

            if(model[i]['key'] == endControl){
                foundControl[endControl] = "Found";
                break;
            }

            if(foundControl[startControl] == "Found" && !isEndControlParent(model[i]['key'], endControlParent)){
                if(model[i]['key'] == pageKey)
                  return false
            }

            if(model[i].children && model[i].children.length > 0){
                res = formHelper.swzOnSkipPage(model[i].children, startControl, endControl, endControlParent, foundControl, pageKey);
                if(!res)
                    return res
            }
        };
        
        return res;
    },
    swzGetEndControlParent: function (model, endControl) {
        var parentControls;
        for(var i in model){ 
            if(model[i]['key'] == endControl){
                //Get it's parent controls here
                return model[i]['parentcontrols'];
            }
            
            if(model[i].children && model[i].children.length){
                parentControls = formHelper.swzGetEndControlParent(model[i].children, endControl);
                if(parentControls)
                    return parentControls
            }
        };
        
        return parentControls;
    },
    previewConfirm: (title, text, cancel) => {
        console.log("Preview confirm");
        const messages = {
        };

        function setDefault(key, value) {
            if (!messages[key]) {
                messages[key] = value;
            }
        }

        setDefault('title', title);
        setDefault('text', text);
        setDefault('ok', null);
        setDefault('cancel', cancel);
        
        return (dispatch) => confirm(messages);
    },


    swzRedirectCompleteURL: (state) => {
        var redirectURL = state.app.form.data.displayed.surveyRedirectUrl;
        if(redirectURL == null) {
            return thunks.configuredFetch('/data/completeurl')
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    let resp = response.item;
                    let surveyRedirectUrl = (resp !== null && resp !== undefined && 
                        resp.surveyRedirectUrl!=null && resp.surveyRedirectUrl!=undefined) ? resp.surveyRedirectUrl : null;
                    if(Boolean(surveyRedirectUrl)){
                        //This part is about Anonymous Survey redirect with provided Completion URL
                        return defaultActions.redirect({parameters: {target:surveyRedirectUrl}});
                        //dispatch(actions.router.routechanged([],{pathname: undefined}));
                    } else {
                        return window.location.href="/public/index";
                    }
                }
                else {
                    alertify.error("Unable to retrieve completion url.");
                }
            })
            .catch(error => {
                console.log(error.message);
            });
        } else {
            if(Boolean(redirectURL)){
                return defaultActions.redirect({parameters: {target:redirectURL}});
            } else {
                return window.location.href="/public/index";
            }
        }
        
    }
};

const defaultActions = {
    initSystem: ({state, data}) => 
    {
        const checkConditions = formHelper.checkConditions({
            model: state.app.form.models.model,
            data: data,
            state: state
        });
    
        let readOnly = null;
        if(state.app.form.formParams && state.app.form.formParams.securityGroup){
            var permissions = state.app.form.formParams.permissions;
            if(Array.isArray(permissions)){
                readOnly = true;
                for(let i=0; i< permissions.length; i++){
                    if(permissions[i].code === "Edit"){
                        if(permissions[i].accessType == 1)
                            readOnly = false;
                            break;
                    }
                }
            }
    
        }
        let onPreview = false;
        if(data && data.onPreview) {
            onPreview = data.onPreview;
        }
	    if(data && data.isIntranetApplication && data.isCleared && data.formIsReadOnly)
		    readOnly = true;

        if(data && data.isIntranetApplication && data.onViewMode)
            readOnly = true;
	
        if(state.app.form.data.isNew || onPreview){
            var initData = {};
            formHelper.initDefaultState(state.app.form.models.model, initData);
            
            return {
                app: {
                    form: {
                        data:{
                            original: initData,
                            modified: initData
                        },
                        models: {
                            hideControls: checkConditions.hideControls,
                            readOnlyControls: checkConditions.readOnlyControls,
                            readOnly: readOnly
                        }
                    }
                }
            };
        }
        else{
            return {
                app: {
                    form: {
                        models: {
                            hideControls: checkConditions.hideControls,
                            readOnlyControls: checkConditions.readOnlyControls,
                            readOnly: readOnly
                        }
                    }
                }
            };
        }
    },
    init: (args) => {
        if(args.data){
            var data = args.data;
            if(data.RespId){
                if(args.state.app.form.models.model){
                    if(args.data[args.state.settings.onLastSavedKey] !== true){
                        var state = args.state;
                        const res = formHelper.checkConditions({
                            model: state.app.form.models.model,
                            data: data,
                            state: state
                        });
                        defaultActions.swzInItLastSaved(state, data, res.hideControls);
                    }
                }
            }
	    
                if(args.data.formIsReadOnly){
                    return {
                        app:{
                            form: {
                                models: {
                                    readOnly: true
                                }
                            }
                        }
                    };
                }
        }
    },
    swzPageInit: ({data, state, formName, isChild}) => {
        
        if(data){
            if(state){
                var newModel = state.app.form.models.model;
                var model = state.app.form.models.model;
                //Add all onpagedisplay false to hidecontrol
                
                const res = formHelper.checkConditions({
                    model: state.app.form.models.model,
                    data: data,
                    state: state
                });

                var validatedPages = [];
                //Check for page validation
                for(let i = 0; i < model.length; i++){
                    if(model[i]['data-buildertype'] == 'swzPage'){
                        var status = formHelper.swzSinglePageValidationStatus(data, state, formName, isChild, res.hideControls, model[i]);
                        validatedPages.push(model[i].key);
                        //add pages here
                    
                        if(!status)
                            break;
                    }
                } 
                
                newModel = formHelper.addItemsValidatedPages(newModel, validatedPages);

                //Existing survey
                if(data.RespId){
                    if(data && !data['PageFirstLoad'])
                        thunks.form.updateSurveyKey("PageFirstLoad", true);
                }
                    //if(data[state.settings.LastSavedKey]){        
                        //console.log("In it last saved");
                        //defaultActions.swzInItLastSaved(state, data, validatedPages, res.hideControls); //to add validates pages inside
                    //}
                
                    return {
                        app:{
                            form:{
                                models:{
                                   model: newModel
                                }       
                            }
                        }
                    };
                }
            }
    },
    swzInItLastSaved: (state, data, hideControls, validatedPages) => {  
        var key;
        if(data[state.settings.LastSavedPage])
            key = data[state.settings.LastSavedPage];
        
        if(state){
            formHelper.swzGoPage(state, key, validatedPages, data, hideControls); //Load All Page Items as well
        }
    },
    checkConditions: ({data, state})=>{
        const res = formHelper.checkConditions({
            model: state.app.form.models.model,
            data: data,
            state: state
        });
        return {
                app: {
                    form: {
                        models: {
                            hideControls: res.hideControls,
                            readOnlyControls: res.readOnlyControls
                        }
                    }
                }
            };
    },
    workflowExecuteCommand: ({formName, state, isChild, controlRef, parameters }) =>
    {
        if (isChild) {
            let msg = "Not supported...";
            if(window.CloverAdminLang !== undefined){
                msg = window.CloverAdminLang.msg.notsupported;
            }
            alertify.error(msg);
            return;
        }
        
        return (dispatch) => {
            dispatch(appActions.app.form.data.fetch.begin());
            let id = state.app.form.data.modified.__id ? state.app.form.data.modified.__id : window.location.pathname.split('/')[3];
            let urlData = {
                command: parameters.command.value,
                name: formName,
                id: id
            };
            return thunks.configuredFetch(store.getState().settings.workflowexecute + '?' + encodeQueryData(urlData),
                {
                    method: 'post'
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        let msg = "The command execution has been completed!";
                        if (window.CloverAdminLang !== undefined) {
                            msg = window.CloverAdminLang.msg.commandexecutioncompleted;
                        }
                        dispatch(appActions.app.resetfetchcount());
                        alertify.success(msg);
                    }
                    else
                        dispatch(appActions.app.form.data.save.failure(response.message, response.details));
                })
                .catch(error => {
                    dispatch(appActions.app.form.data.save.failure(error.message, error.stack));
                });
        };
    },
    workflowSetState: ({formName, state, isChild, controlRef, parameters }) =>
    {
        if (isChild) {
            let msg = "Not supported...";
            if(window.CloverAdminLang !== undefined){
                msg = window.CloverAdminLang.msg.notsupported;
            }
            alertify.error(msg);
            return;
        }

        return (dispatch) => {
            dispatch(appActions.app.form.data.fetch.begin());
            let id = state.app.form.data.modified.__id ? state.app.form.data.modified.__id : window.location.pathname.split('/')[3];
            let urlData = {
                state: parameters.state.value,
                name: formName,
                id: id
            };
            return thunks.configuredFetch(store.getState().settings.workflowset + '?' + encodeQueryData(urlData),
                {
                    method: 'post'
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        dispatch(appActions.app.resetfetchcount());
                        let msg = "The new state was set!";
                        if (window.CloverAdminLang !== undefined) {
                            msg = window.CloverAdminLang.msg.newstateset;
                        }
                        alertify.success(msg);
                    }
                    else
                        dispatch(appActions.app.form.data.save.failure(response.message, response.details));
                })
                .catch(error => {
                    dispatch(appActions.app.form.data.save.failure(error.message, error.stack));
                });
        };
    },
    exit: ({state, formName, index, isChild}) => {
        if (!isChild) {
            return {
                router: {
                    push: '/'
                }
            };
        } else {
            let modals = [ ...state.app.form.modals ];
            modals = modals.slice(0, index);
            let children = { ...state.app.form.data.children };
            children[formName + "_" + index] = null;
            return {
                app: {
                    form: {
                        modals: modals,
                        data: {
                            children: children
                        }
                    }
                }
            };
        }
    },
    confirm: ({  parameters }) => {

        const messages = {
        };

        function setFromCloverAdmin(key) {
            if (!messages[key]) {
                messages[key] = window.CloverAdminLang.confirm[paramKey];
            }
        }

        function setDefault(key, value) {
            if (!messages[key]) {
                messages[key] = value;
            }
        }

        // console.log("Paramtrs ", parameters);
        // console.log("Windows loverclang ", window.CloverLang);

        if (parameters && window.CloverLang && window.CloverLang.msg) {
            messages.title = window.CloverLang.msg[parameters.confirmTitle];
            messages.text = window.CloverLang.msg[parameters.confirmText];
            messages.ok = window.CloverLang.msg[parameters.confirmOk];
            messages.cancel = window.CloverLang.msg[parameters.confirmCancel];
        }

        if (window.CloverAdminLang) {
            setFromCloverAdmin('title');
            setFromCloverAdmin('text');
            setFromCloverAdmin('ok');
            setFromCloverAdmin('cancel');
        } else {
            setDefault('title', "Confirm");
            setDefault('text', "Please confirm the action");
            setDefault('ok', "Ok");
            setDefault('cancel', "Cancel");
        }

        return (dispatch) => confirm(messages);
    },
    apply: ({ state, index, isChild, formName }) => {
        
        if (!isChild)
            return {};
        let sourceData = state.app.form.data.children[formName + '_' + index];
        if (!sourceData || !sourceData.isDirty)
            return {};
        let targetData = null;
        let targetIndex = index - 1;
        let targetFormName = targetIndex >= 0 ? state.modals[targetIndex] : null;
        let isTargetChild = targetIndex >= 0;
        if (isTargetChild) {
            targetData = state.app.form.data.children[targetFormName + '_' + targetIndex];
        } else {
            targetData = state.app.form.data;
        }
        let sourceDataModified = sourceData.modified;
        let propertyName = sourceData.property;
        const mappingToData = state.app.form.models.children[formName].mapping.toData;
        const mappingToForm = isTargetChild ? state.app.form.models.children[targetFormName].mapping.toForm[propertyName]
            : state.app.form.models.mapping.toData[propertyName];
        let mergeSingleRecordToArray = function (array, record) {
            record = gridUtils.mapRow(gridUtils.mapRow(record,mappingToData),mappingToForm);
            let indexForUpdate = array.findIndex((r) => r.__id === record.__id);
            if (indexForUpdate >= 0) {
                array[indexForUpdate] = mergeDeep(array[indexForUpdate], record);
                array[indexForUpdate].__loaded = true;
            } else {
                record.__loaded = true;
                array.push(record);
            }
        };
        let resultPropertyValue = null;
        if (propertyName) {
            let isSourceArray = Array.isArray(sourceDataModified);
            let targetPropertyValue = targetData.modified[propertyName];
            let isTargetArray = Array.isArray(targetPropertyValue);
            if (!isSourceArray && isTargetArray) {
                resultPropertyValue = targetPropertyValue;
                mergeSingleRecordToArray(resultPropertyValue, sourceDataModified);
            }
            else if (isSourceArray && isTargetArray) {
                resultPropertyValue = targetPropertyValue;
                for (let i = 0; i < sourceDataModified.length, i++;) {
                    mergeSingleRecordToArray(resultPropertyValue, sourceDataModified[i]);
                }
            }
            else if (isSourceArray && !isTargetArray) {
                throw Error("apply action: source data are array but target data is not array, can not merge");
            }
            else if (!isSourceArray && !isTargetArray) {
                resultPropertyValue = mergeDeep(targetPropertyValue, sourceDataModified); 
            }
        } else {
            throw Error("apply action: propertyName is not defined"); //TODO Merge record to record???
        }


        return (dispatchFunc) => {
            return thunks.form.updateData(propertyName,
                resultPropertyValue,
                targetFormName,
                targetIndex,
                isTargetChild,
                true)(dispatchFunc);
        };
    },
    redirect: ({ parameters}) => {

        if (parameters === undefined || parameters.target === undefined){
            console.error("For call 'redirect' action you need to set the 'target' parameter!");
            return;
        }

        if (parameters.target.includes("http://") || parameters.target.includes("https://")){
            document.location.href = parameters.target;
        }
        else {
            return {
                router: {
                    push: parameters.target
                }
            };
        }
    },
    refresh:() => {
        return {
            router: {
                refresh: 'refresh'
            }
        };
    },
    validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
        let isValid = true;
        let errors = {};
        var messages = [];
        
        let controls = !isChild ? formHelper.swzGetControlsForValidate(state.app.form.models.model) :
            formHelper.swzGetControlsForValidate(state.app.form.models.children[formName].model);
        for (let i=0; i < controls.length; i++){
            let key = controls[i].key;
            let error = formHelper.validate(controls[i], data[key], data);
            if (error){
		if(controls[i]["other-required"]){
			if(controls[i]["other-required-soft"]==true){
					if(typeof error !== 'boolean'){
						messages.push(error + ' (not mandatory)');
					}
			}
			else{
		                	errors[key] = true;
					if(typeof error !== 'boolean'){
						messages.push(error);
					}
					isValid = false;
			}
		}
		else{
			if(controls[i]["other-customValidation-soft"]==true){
					if(typeof error !== 'boolean'){
						messages.push(error + ' (not mandatory)');
					}
			}
			else{
		                	errors[key] = true;
					if(typeof error !== 'boolean'){
						messages.push(error);
					}
					isValid = false;
			}
		}
            }
        }
        let formErrorsDelta = {};
        if (isChild)
        {
            formErrorsDelta.children = {};
            formErrorsDelta.children[formName + '_' + index] = !isValid ?  errors : null;
        }
        else {
            formErrorsDelta.main = !isValid ? errors : null;
        }

        
        if(!isValid){
            let errmsg = "Check errors on the form!";
            if(window.CloverAdminLang !== undefined){
                errmsg = window.CloverAdminLang.msg.checkerrorsonform;
            }
	    
            throw {
             level: 1,
             message: messages,
             formerrors: formErrorsDelta
           };
        }     
	else{
		if(messages.length>0){
			//alertify.error(messages.join('<br />'), 0);
			//alertify.confirm(messages.join('<br />'),formHelper.callback); 
			alertify.alert(messages.join('<br />')); 
		}
	}
        return {};
    },
    createElement: ({data, model, controlRef, state, parameters}) => {
        if(parameters === undefined)
            return {};

        const item = data[controlRef.props.name];
        if(item === undefined){
            throw {
                level: 1,
                message: "Undefined the collection field - " + controlRef.props.name
            };
        }

        const columns = controlRef.props.columns;
        if(Array.isArray(columns)){
            let row = {};
            for(let p in parameters) {
                let isFind = false;
                for(let i=0; i < columns.length; i++){
                    if(columns[i].key.toLowerCase() === p.toLowerCase()){
                        row[columns[i].key] = parameters[p];
                        isFind = true;
                        break;
                    }
                }

                if(isFind === false)
                    row[p] = parameters[p];
            }
            item.push(row);
        }
        else{
            item.push(parameters);
        }

        return {
            app: {
                form : {
                    data : {
                        modified: data,
                    }
                }
            }
        };
    },
    //sets a filter to the global state
    setFilter : ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild, parameters, sourceControlRef,sourceControlValue}) => {
        let filter;
        let controlName = controlRef.props.name;
        let childformid = isChild ? formName + "_" + index : null;
        if (!isChild) {
            if (state.app.form.filters.main !== null && state.app.form.filters.main.hasOwnProperty(controlName)) {
                filter = state.app.form.filters.main[controlName];
            }
            else {
                filter = [];
            }
        }
        else {
            if (state.app.form.filters.children === null || state.app.form.filters.children[childformid] === undefined ||
                !state.app.form.filters.children[childformid].hasOwnProperty(controlName))
                filter = [];
            else
                filter = state.app.form.filters.children[childformid][controlName];
        }

        let existingFilter = filter.find((i)=>i.__controlName === sourceControlRef.props.name);
        if (existingFilter !== undefined) {
            // if (sourceControlValue !== null && sourceControlValue !== undefined && sourceControlValue != "") {
            //     existingFilter.value = sourceControlValue;
            // }
            // else {
            //
            //     const indexOf = filter.indexOf(existingFilter);
            //     if (indexOf > -1) {
            //         filter.splice(indexOf, 1);
            //     }
            // }

            if (sourceControlValue !== null && sourceControlValue !== undefined && sourceControlValue !== "") {
                existingFilter.nextValue = sourceControlValue;
            }
            else {
                existingFilter.nextValue = null;
            }
        }
        else if (sourceControlValue !== null && sourceControlValue !== undefined && sourceControlValue !== "") {
            let newFilterItem = {};
            newFilterItem.column = parameters.column === undefined ? sourceControlRef.props.name : parameters.column.split(",").map(v=>v.trim()).join(",");
            newFilterItem.term = parameters.term === undefined ? "like" : parameters.term;
            newFilterItem.nextValue = sourceControlValue;
            newFilterItem.value = null;
            newFilterItem.__controlName = sourceControlRef.props.name;
            filter.push(newFilterItem);
        }
        if (!isChild) {
            return {
                app: {
                    form: {
                        filters: {
                            main : {
                                [controlName]: filter
                            }
                        }
                    }
                }
            };
        }
        else {
            return {
                app: {
                    form: {
                        filters: {
                            children: {
                                [childformid]: {
                                    [controlName]: filter
                                }
                            }
                        }
                    }
                }
            };
        }
    },
    applyScanValue: ({state, sourceControlRef, controlRef,isChild,formName, index, parameters}) => {
        let propertyName = controlRef.props.name;
        if(propertyName == undefined || propertyName == null)
            return formHelper.previewConfirm("Confirm", "Property control is not set for applying scanned value", "Cancel");

        let scanValue = sourceControlRef.state.value;
        return thunks.form.swzGetScanValue(scanValue, propertyName);
    },
    applyCaptchaValue: ({state, sourceControlRef, controlRef,isChild,formName, index, parameters}) => {
        let propertyName = controlRef.props.name;
        if(propertyName == undefined || propertyName == null)
            return formHelper.previewConfirm("Confirm", "Property control is not set for applying captcha value", "Cancel");
        console.log("Apply captcha value", sourceControlRef.state.value);
        let captchaValue = sourceControlRef.state.value;
        return thunks.form.swzGetCaptchaValue(captchaValue, propertyName);
    },
    applyServerDateTime: ({state, controlRef,isChild,formName, index, parameters}) => {
        //ControlRef will be the props in the grid. I.E property name
        var dateTimeFormat = parameters.format;
        let propertyName = controlRef.props.name;
        if(propertyName == undefined || propertyName == null)
            return formHelper.previewConfirm("Confirm","Property control is not set for applying server datetime", "Cancel");

        return thunks.form.swzGetServerDateTime(dateTimeFormat, propertyName);
    },
    applyIpAddress: ({state, controlRef,isChild,formName, index, parameters}) => {
        //ControlRef will be the props in the grid. I.E property name
        let propertyName = controlRef.props.name;
        if(propertyName == undefined || propertyName == null)
            return formHelper.previewConfirm("Confirm","Property control is not set for applying ip address", "Cancel");
     
        detectlocationapi.ipLookUp(propertyName);
        return {};
    },
    applyLatLong: ({state, controlRef,isChild,formName, index, parameters}) => {
        //ControlRef will be the props in the grid. I.E property name
        let propertyName = controlRef.props.name;
        if(propertyName == undefined || propertyName == null)
            return formHelper.previewConfirm("Confirm","Property control is not set for applying ip address", "Cancel");
    
        detectlocationapi.getCurrentPosition(propertyName);
        return {};
    },
    gridSoftDelete: ({state, controlRef,isChild,formName, index, parameters}) => {
        //ControlRef will be the props in the grid. I.E property name
        let props = controlRef.props;
        let propertyName = controlRef.props.name;
        let data = !isChild ? state.app.form.data.modified[propertyName] : state.app.form.data.children[formName + '_' + index].modified[propertyName];

        let selectedRow = gridUtils.getSelectedRow({parameters, controlRef});
        let selectedId = selectedRow ? selectedRow.__id : undefined;
        
        if (!selectedId){
        alertify.error("Please, select rows for deletion!");
            return {};
        }

        let ids = {
            ids: controlRef.getSeletedRowKeys()
        }; 
        return thunks.form.swzSoftDelete(parameters.model, parameters.url, ids)
    },
    applyFilter : ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild, parameters, sourceControlRef,sourceControlValue}) => {

        let filter = null;
        let controlName = controlRef.props.name;
        let childformid = isChild ? formName + "_" + index : null;
        if (!isChild) {
            if (state.app.form.filters.main !== null && state.app.form.filters.main.hasOwnProperty(controlName)) {
                filter = state.app.form.filters.main[controlName];
            }
        }
        else {
            if (state.app.form.filters.children !== null && state.app.form.filters.children[childformid] !== undefined &&
                state.app.form.filters.children[childformid].hasOwnProperty(controlName))
                filter = state.app.form.filters.children[childformid][controlName];
        }

        if (filter === null)
            return {};

        filter = filter.filter((f) => f.nextValue !== null);
        filter.forEach((f) => f.value = f.nextValue);

        if (!isChild) {
            return {
                app: {
                    form: {
                        filters: {
                            main : {
                                [controlName]: filter
                            }
                        }
                    }
                }

            };
        }
        else {
            return {
                app: {
                    form: {
                        filters: {
                            children: {
                                [childformid]: {
                                    [controlName]: filter
                                }
                            }
                        }
                    }
                }
            };
        }
    },
    gridExport: ({state, controlRef,isChild,formName, index}) => {
        //ControlRef will be the props in the grid. I.E property name
        let props = controlRef.props;
        let propertyName = controlRef.props.name;
        let data = !isChild ? state.app.form.data.modified[propertyName] : state.app.form.data.children[formName + '_' + index].modified[propertyName];
            
        var csv = Papa.unparse(data);
        var downloadLink = document.createElement("a");
        var blob = new Blob(["\ufeff", csv]);
        var url = URL.createObjectURL(blob);
        downloadLink.href = url;
        downloadLink.download = "data.csv";

        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);
    },
    //GRID ACTIONS
    gridCreate: ({state, controlRef, parameters, isChild, formName}) => {   //copy action from a grid
        if (controlRef.isEditFormModal()){
            return gridUtils.create({ state, controlRef, parameters, isChild, formName });
        }
        else{
            let props = controlRef.props;
            if(props.editType === "flow"){
                let flowName = props.editFlow;
                let url = '/flow/' + flowName + '/';
                return {
                    router: {
                        push: url
                    }
                };
            }
            else{
                let formName = props.editForm;
                let url = '/form/' + formName + '/';
                return {
                    router: {
                        push: url
                    }
                };
            }
        }
    },
    gridRefresh: ({ controlRef}) => {  //refresh action from grid
        controlRef.refresh();
        return {};
    },  
    gridCopy: ({state, controlRef, parameters, isChild, formName}) => {   //copy action from a grid
        if (controlRef.isEditFormModal()){
            return gridUtils.copy({ state, controlRef, parameters, isChild, formName });
        }
        else {
            let commingsoonmsg = "Comming soon...";
            if(window.CloverAdminLang !== undefined){
                commingsoonmsg = window.CloverAdminLang.msg.commingsoon;
            }
            alertify.error(commingsoonmsg);
            return {};
        }
    },
    gridDelete: ({ state, controlRef, parameters, isChild, formName, index }) => {   //copy action from a grid
        if (controlRef.isServerMode()){
            let ids = controlRef.getSeletedRowKeys();
            if (ids.length === 0){
                let selectrowsfordelete = "Please, select rows for deletion!";
                if(window.CloverAdminLang !== undefined){
                    selectrowsfordelete = window.CloverAdminLang.msg.selectrowsfordelete;
                }
                alertify.error(selectrowsfordelete);
            }
            else {
                return (dispatchFunc) => {
                    return thunks.common.deleteByIds(formName, controlRef.props.name, ids, function () {
                        let rowsdeleted = "Rows have been deleted!";
                        if (window.CloverAdminLang !== undefined) {
                            rowsdeleted = window.CloverAdminLang.msg.rowsdeleted;
                        }
                        alertify.success(rowsdeleted);
                        controlRef.refresh();
                    })(dispatchFunc);
                };
            }
        }
        else {
            let ids = controlRef.getSeletedRowKeys();
            if (ids.length === 0) {
                let selectrowsfordelete = "Please, select rows for deletion!";
                if(window.CloverAdminLang !== undefined){
                    selectrowsfordelete = window.CloverAdminLang.msg.selectrowsfordelete;
                }
                alertify.error(selectrowsfordelete);
            }
            else {
                let propertyName = controlRef.props.name;
                let data = !isChild ? state.app.form.data.modified[propertyName] : state.app.form.data.children[formName + '_' + index].modified[propertyName];
                let newData = data.filter(i => {
                    return !ids.includes(i.__id);
                });
                return (dispatchFunc) => {
                    return thunks.form.updateData(propertyName,
                        newData,
                        formName,
                        index,
                        isChild,
                        true)(dispatchFunc);
                };
            }
        }

        return {};
    },
    gridEdit: ({state, controlRef, parameters, isChild, formName}) => { //edit action from a grid
        if (controlRef.isEditFormModal()) {
             return gridUtils.edit({ state, controlRef, parameters, isChild, formName });
         }
        else {
            let props = controlRef.props;
            if (!props.editFormShowType || props.editFormShowType === 'Default') {
                let selectedRow = gridUtils.getSelectedRow({parameters, controlRef});
                let selectedId = selectedRow ? selectedRow.__id : undefined;
                if (!selectedId)
                    return {};
                
                if(props.editType === "flow"){
                    let flowName = props.editFlow;
                    let url = '/flow/' + flowName + '/' + selectedId + '/';
                    return {
                        router: {
                            push: url
                        }
                    };
                }
                else{
                    let formName = props.editForm;
                    let url = '/form/' + formName + '/' + selectedId + '/';
                    return {
                        router: {
                            push: url
                        }
                    };
                }
            }
        }
        return {};
    },
    //otherControls
    changeModel: ({controlRef, state, parameters}) => {
        var model = state.app.form.models.model;
        if(parameters === undefined)
            return {};
 
        let targetKey = controlRef.props.name;
        let changesParameters = function(key, control, pars){
            if(control.key == key){
                for(var p in pars){
                    control[p] = pars[p];
                }
                return;
            }

            if(control.children != undefined && control.children.length > 0){
                for(let i in control.children){
                    let child = control.children[i];
                    changesParameters(key, child, pars);
                }
            }
        };

        for(let i in model){
            let control = model[i];
            changesParameters(targetKey, control, parameters);
        }

        return {
            app:{
                form:{
                    models:{
                        model: model
                    }
                }
            }
        };
    },
    save: ({formName,ischild, index }) => {
        return thunks.form.savedata(formName,ischild, index);
    },
    swzItemClick: ({state, data, parameters}) => {

        var pageFound = false;
        var item = parameters.target.name
        var newModel = state.app.form.models.model;
        var updatedModel = state.app.form.models.model;
        var pageObj = {};

        if (parameters === undefined || parameters.target === undefined){
            console.error("For page 'redirect' action you need to set the 'target' parameter!");
            return;
        }

        if(item !== undefined){
            for (var i=0; i < newModel.length; i++) {
                //SWZ addition to compare index of validated pages and menu
                if(newModel[i].key == item){
                    if(newModel[i].key !== newModel[i].validatedpages[i]){
                        if(pageObj['current'] !== undefined){
                            newModel[pageObj['current']]['onpagedisplay'] = true
                        };
                        return formHelper.previewConfirm("Confirm","Not allowed to access page", "Cancel");
                    }else{
                        newModel[i]['onpagedisplay'] = true;
                        pageFound = true;
                        if(pageObj['current'] !== undefined){
                            newModel[pageObj['current']]['onpagedisplay'] = false;
                        }
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    }
                }else{
                    if(newModel[i]['onpagedisplay'] == true){
                        pageObj['current'] = [i];
                        newModel[i]['onpagedisplay'] = false;
                    }
                }
            }
            
            if(!pageFound){
                newModel = updatedModel;
                alert("Confirm","Access to page denied", "Cancel");
            }
        }

        const checkConditions = formHelper.checkConditions({
            model: newModel,
            data: data,
            state: state
        });

        return {
            app:{
                form:{
                    models:{
                        hideControls: checkConditions.hideControls,
                        readOnlyControls: checkConditions.readOnlyControls,
                        model: newModel
                    }
                }
            }
        };  
    },
    swzNext: ({state, data}) => {
        var newModel = state.app.form.models.model;
        var hiddenControls = state.app.form.models.hideControls;
        var currentPageObj = {}; 
       
        for (var i=0; i < newModel.length; i++) {
            if (currentPageObj['currentPage'] !== undefined){
                if(i < newModel.length){
                    if (newModel[i].onpagedisplay == false) {
                           /*  var res = newModel[i]['other-visibleConition'] !== undefined && newModel[i]['other-visibleConition'] !== "" ?
                            formHelper.onHiddenPage(newModel[i], state, data):
                            true; */
                            var res = formHelper.onHiddenPage(newModel[i], state, data);
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        if(res){
                            //If page has visible condition, but fit the condition
                            //Page has no visible condition
                            newModel[currentPageObj['currentPage']]['onpagedisplay'] = false;
                            newModel[i]['onpagedisplay'] = true;
                            
                            /* 
                            Using checkConditions with new models,
                            Add CurrentPageObj from hidecontrols
                            Remove NewPage from hidecontrols
                            Update again
                            */
                            break;
                        }
                    }   
                }
                else{
                    return formHelper.previewConfirm("Confirm", "There is no page after current page", "Cancel");
                }
            }
            if (newModel[i].onpagedisplay == true && currentPageObj['currentPage'] == undefined) {
                currentPageObj['currentPage'] = i;
                if(i == newModel.length - 1){
                    return formHelper.previewConfirm("Confirm", "There is no page after current page", "Cancel");
                }
            }
        }

        const checkConditions = formHelper.checkConditions({
            model: newModel,
            data: data,
            state: state
        });

        return {
            app:{
                form:{
                    models:{
                        hideControls: checkConditions.hideControls,
                        readOnlyControls: checkConditions.readOnlyControls,
                        model: newModel
                    }
                }
            }
        };
    },
    //Capture validation status for the page
    swzPageValidationStatus: ({state, data, formName, isChild}) => {

        var newModel = state.app.form.models.model;
        var model = state.app.form.models.model;
        var validatedPages = [];
        var hiddenControls = state.app.form.models.hideControls;
        /* const res = formHelper.checkConditions({
            model: model,
            data: data,
            state: state
        }); */

        //Check for page validation
        for(let i = 0; i < model.length; i++){
            if(model[i]['data-buildertype'] == 'swzPage'){
                var status = formHelper.swzSinglePageValidationStatus(data, state, formName, isChild, hiddenControls, model[i]);
                var res = formHelper.onHiddenPage(model[i], state, data);
                if(res){
                    validatedPages.push(model[i].key);
                }else{
                    break;
                }
                if(!status){
                    break;
                }
            }
        }//1822

        for (var i=0; i < newModel.length; i++) {
            newModel[i]['validatedpages'] = validatedPages;
        }
        //console.log("The validated pages are", validatedPages);
        return {
            app:{
                form:{
                    models:{
                        model: newModel
                    }
                }
            }
        };
    },
    swzBack: ({state, data}) => {
        var newModel = state.app.form.models.model;
        var hiddenControls = state.app.form.models.hideControls;
        var currentPageObj = {}; 

        for (var i = newModel.length - 1; i >= 0; i--) {
            if (currentPageObj['currentPage'] !== undefined){
                if(i < newModel.length){
                    if (newModel[i].onpagedisplay == false) {
                        /* var res = newModel[i]['other-visibleConition'] !== undefined && newModel[i]['other-visibleConition'] !== ""  ?
                         formHelper.onHiddenPage(newModel[i], state, data): 
                         true; */
                        var res = formHelper.onHiddenPage(newModel[i], state, data);
                        window.scrollTo({ top: 0, behavior: 'smooth' });        
                        if(res){
                            //If page has visible condition, but fit the condition
                            //Page has no visible condition
                            newModel[currentPageObj['currentPage']]['onpagedisplay'] = false;
                            newModel[i]['onpagedisplay'] = true;
                            /* 
                            Using checkConditions with new models,
                            Add CurrentPageObj from hidecontrols
                            Remove NewPage from hidecontrols
                            Update again
                            */
                            break;
                        }
                    }   
                }
                else{
                    return formHelper.previewConfirm("Confirm", "There is no page after current page", "Cancel");
                }
            }
            if(newModel[i].onpagedisplay !== undefined){
                if (newModel[i].onpagedisplay == true && currentPageObj['currentPage'] == undefined) {
                    currentPageObj['currentPage'] = i;
                    if(i == 0){
                        return formHelper.previewConfirm("Confirm", "There is no page BEFORE current page", "Cancel");
                    }
                }
            }
        }

        const checkConditions = formHelper.checkConditions({
            model: newModel,
            data: data,
            state: state
        });
        return {
            app:{
                form:{
                    models:{
                        hideControls: checkConditions.hideControls,
                        readOnlyControls: checkConditions.readOnlyControls,
                        model: newModel
                    }
                }
            }
        };
    },
    swzReturnToStart: ({state, data}) => {
        var newModel = state.app.form.models.model;
        for (var i = newModel.length - 1; i >= 0; i--) {
            if(newModel[i].onpagedisplay !== undefined){
                if (newModel[i].onpagedisplay == true) {
                    var res = formHelper.onHiddenPage(newModel[0], state, data);
                    window.scrollTo({ top: 0, behavior: 'smooth' }); 
                    if(res){
                        newModel[i]['onpagedisplay'] = false;
                        newModel[0]['onpagedisplay'] = true;
                        break;
                    }      
                }
            }
       }

        const checkConditions = formHelper.checkConditions({
            model: newModel,
            data: data,
            state: state
        });
        return {
            app:{
                form:{
                    models:{
                        hideControls: checkConditions.hideControls,
                        readOnlyControls: checkConditions.readOnlyControls,
                        model: newModel
                    }
                }
            }
        };
    },
    swzExit: ({state}) => {
        if(CloverApp.state.uid == "swzanonymous"){
            formHelper.swzRedirectCompleteURL(state);
        }else if(state.router.history !== null && state.router.history.length > 2){
            if(state.app.user === null) {
                window.location = '/form/respdashboard';
            }
            else {
                history.back();
            }
            return{};
        }else{
            var parameters = {
                target: state.settings.home
            }
            if (parameters === undefined || parameters.target === undefined){
                console.error("For call 'redirect' action you need to set the 'target' parameter!");
                return;
            }
    
            if (parameters.target.includes("http://") || parameters.target.includes("https://")){
                document.location.href = parameters.target;
            }
            else {
                return {
                    router: {
                        push: parameters.target
                    }
                };
            }
        }
    },
    swzClearRadio: ({state, parameters, controlRef, data}) => {
        var value = parameters.value;
        var key = controlRef.props.name;
        var stateValue = controlRef.props.value;
        var newValue;

        if(stateValue == undefined || stateValue == null){
            newValue = value;
        }else{
            if(stateValue == value){
                newValue = "";
            }else{
                newValue = value;
            }
        }
        
        data[key] = newValue;
        const checkConditions = formHelper.checkConditions({
            model: state.app.form.models.model,
            data: data,
            state: state
        });

        return {
            app: {
                form: {
                    data: {
                        modified: {
                            [key]: newValue
                        }
                    },
                    models: {
                        hideControls: checkConditions.hideControls,
                        readOnlyControls: checkConditions.readOnlyControls,
                    }
                }
            }
        };
    },
    swzSave: ({formName,ischild, index, state, sourceControlRef, parameters}) => {
        var onAlertify = true;
        var onSubmit = false;
        var pageName = null;



        if(sourceControlRef){
            if(sourceControlRef.props['data-buildertype'] == "swzPage"){
                pageName = sourceControlRef.props.name;
            }else if(sourceControlRef.props.additionalParams.parentItem.parentPage)
                pageName = sourceControlRef.props.additionalParams.parentItem.parentPage;
        }else {
            var newModel = state.app.form.models.model;
            if(newModel != null)
                pageName = formHelper.swzGetCurrentPage(state);
            else
                return;
        }

        let data = state.app.form.data.modified;

        if(parameters.onAutoSave){
            onAlertify = false;
        }

        if(data && data.onPreview)
            if(!parameters.onHideLoadAnimation)
                return formHelper.previewConfirm("Preview mode", "Saving not allowed on preview mode", "Cancel");
            else
                return thunks.form.swzpreviewdata(formName, pageName, ischild, index, onAlertify, onSubmit, parameters.onHideLoadAnimation);
        if(data && data.onViewMode)
            return formHelper.previewConfirm("View mode", "Saving not allowed on view mode", "Cancel");

        return thunks.form.swzsavedata(formName, pageName, ischild, index, onAlertify, onSubmit, parameters.onHideLoadAnimation);
    },
    swzSubmit: ({formName,ischild, index, state, sourceControlRef }) => {
        var onAlertify = true;
        var onSubmit = true;
        var pageName = null;
        
        if(sourceControlRef){
            if(sourceControlRef.props['data-buildertype'] == "swzPage"){
                pageName = sourceControlRef.props.name;
            }else if(sourceControlRef.props.additionalParams.parentItem.parentPage)
                pageName = sourceControlRef.props.additionalParams.parentItem.parentPage;        
        }else
            pageName = formHelper.swzGetCurrentPage(state);
        
        var onHideLoadAnimation = false;
        let data = state.app.form.data.modified;
        if(data && data.onPreview)
            return formHelper.previewConfirm("Preview mode", "Saving not allowed on preview mode", "Cancel");

        if (data && data.onViewMode)
            return formHelper.previewConfirm("View mode", "Saving not allowed on view mode", "Cancel");

        return thunks.form.swzsavedata(formName, pageName, ischild, index, onAlertify, onSubmit, onHideLoadAnimation);
    },
    swzReturnBackHome: ({}) =>{
      return thunks.form.swzReturnBackHome();  
    },
    swzSilentSave: ({formName,ischild, index, state, sourceControlRef }) => {
        var onAlertify = false;
        var onSubmit = false;
        var pageName = null;
        
        if(sourceControlRef){
            if(sourceControlRef.props['data-buildertype'] == "swzPage"){
                pageName = sourceControlRef.props.name;
            }else if(sourceControlRef.props.additionalParams.parentItem.parentPage)
                pageName = sourceControlRef.props.additionalParams.parentItem.parentPage;        
        }else
            pageName = formHelper.swzGetCurrentPage(state);
        
 	    var onHideLoadAnimation = false;

        let data = state.app.form.data.modified;
        if(data && data.onPreview)
            return true

        if (data && data.onViewMode)
            return true
        
        return thunks.form.swzsavedata(formName, pageName, ischild, index, onAlertify, onSubmit, onHideLoadAnimation);
    },
    swzSinglePageValidate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
        var hideControls = state.app.form.models.hideControls;
        var spHideControls = [];
        var model = state.app.form.models.model;
        var spModel = [];
        let isValid = true;
        let errors = {};
        var messages = [];

        //Get active page
        for(let y = 0; y < model.length; y++){
            if(model[y].onpagedisplay){
                spModel.push(model[y])
                break;
            }
        }
        //Get Single Page HideControls
        if(hideControls !== undefined && hideControls !== null){
            if(hideControls.length > 0 ){
                spHideControls = !isChild ? formHelper.swzGetControlsForHide(spModel, hideControls) : null;
            }
        }
       
        //Get Controls that require validation and then remove them.
        var controls = !isChild ? formHelper.swzGetControlsForValidate(spModel) :
            formHelper.swzGetControlsForValidate(state.app.form.models.children[formName].model);
        var pageControls = formHelper.swzRemoveHideControls(controls, spHideControls);
        //Check of controls
        for (let i=0; i < pageControls.length; i++){
            let key = pageControls[i].key;
            if(pageControls[i]["bypass-validation"] == undefined || pageControls[i]["bypass-validation"] == false){
                let error = formHelper.validate(pageControls[i], data[key], data);
                if (error){
            if(pageControls[i]["other-required"] && (data[key] === undefined || data[key] === null || data[key] === '') ){
                if(pageControls[i]["other-required-soft"] == true){
                        if(typeof error !== 'boolean'){
                            messages.push(error + ' (not mandatory)');
                        }
                }
                else{
                                errors[key] = true;
                        if(typeof error !== 'boolean'){
                            messages.push(error);
                        }
                        isValid = false;
                }
            }
            else{
                if(pageControls[i]["other-customValidation-soft"]==true){
                    if(typeof error !== 'boolean'){
                        messages.push(error + ' (not mandatory)');
                    }
                }
                else{
                    errors[key] = true;
                    if(typeof error !== 'boolean'){
                        messages.push(error);
                    }
                    isValid = false;
                }
            }
                }
            }
            
            }

            let formErrorsDelta = {};
            if (isChild)
            {
                formErrorsDelta.children = {};
                formErrorsDelta.children[formName + '_' + index] = !isValid ?  errors : null;
            }
            else {
                formErrorsDelta.main = !isValid ? errors : null;
            }
    
            if(!isValid){
                let errmsg = "Check errors on the form!";
                if(window.CloverAdminLang !== undefined){
                    errmsg = window.CloverAdminLang.msg.checkerrorsonform;
                }
            //console.log("not valid messages: ", messages);
            //console.log("formErrorsDelta: ", formErrorsDelta);
                throw {
                level: 1,
                message: messages,
                formerrors: formErrorsDelta
            };
            }     
        else{
            if(messages.length>0){
                //alertify.error(messages.join('<br />'), 0);
                //alertify.confirm(messages.join('<br />'),formHelper.callback); 
                alertify.alert(messages.join('<br />')); 
            }
        }
            return {};
    },
    swzValidate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
        
        var hideControls = state.app.form.models.hideControls;
        var model = state.app.form.models.model;
        let isValid = true;
        let errors = {};
        var messages = [];
        
        //Get Controls that require validation and then remove them.
        var controls = !isChild ? formHelper.swzGetControlsForValidate(model) :
          formHelper.swzGetControlsForValidate(state.app.form.models.children[formName].model);
      
        var pageControls = controls;
        
        if(hideControls !== undefined && hideControls !== null && hideControls.length > 0){
        //Get controls for hide
            var hiddenControls = formHelper.swzGetControlsForHide(model, hideControls);
            pageControls = formHelper.swzRemoveHideControls(controls, hiddenControls);
            
        }
       
        for (let i=0; i < pageControls.length; i++){
            let key = pageControls[i].key;
        if(pageControls[i]["bypass-validation"] == undefined || pageControls[i]["bypass-validation"] == false){
            let error = formHelper.validate(pageControls[i], data[key], data);
            if (error){
		if(pageControls[i]["other-required"]){
			if(pageControls[i]["other-required-soft"]==true){
					if(typeof error !== 'boolean'){
						messages.push(error + ' (not mandatory)');
					}
			}
			else{
		                	errors[key] = true;
					if(typeof error !== 'boolean'){
						messages.push(error);
					}
					isValid = false;
            }
		}
		else{
			if(pageControls[i]["other-customValidation-soft"]==true){
					if(typeof error !== 'boolean'){
						messages.push(error + ' (not mandatory)');
					}
			}
			else{
		                	errors[key] = true;
					if(typeof error !== 'boolean'){
						messages.push(error);
					}
					isValid = false;
			}
        }
            }
        }

        }
        let formErrorsDelta = {};
        if (isChild)
        {
            formErrorsDelta.children = {};
            formErrorsDelta.children[formName + '_' + index] = !isValid ?  errors : null;
        }
        else {
            formErrorsDelta.main = !isValid ? errors : null;
        }

        
        if(!isValid){
            let errmsg = "Check errors on the form!";
            if(window.CloverAdminLang !== undefined){
                errmsg = window.CloverAdminLang.msg.checkerrorsonform;
            }
	    //console.log("not valid messages: ", messages);
	    //console.log("formErrorsDelta: ", formErrorsDelta);
            throw {
             level: 1,
             message: messages,
             formerrors: formErrorsDelta
           };
        }     
	else{
		if(messages.length>0){
			//alertify.error(messages.join('<br />'), 0);
			//alertify.confirm(messages.join('<br />'),formHelper.callback); 
			alertify.alert(messages.join('<br />')); 
		}
	}
        return {};
    },
    swzReturnToPreviousPage: function({state}){
        if(CloverApp.state.uid == "swzanonymous"){
            formHelper.swzRedirectCompleteURL(state);
        }else if(state.router.history !== null && state.router.history.length > 2){
            if(state.app.user === null) {
                window.location = '/form/respdashboard';
            }
            else {
                history.back();
            }
            return{};
        
        }else{
            var parameters = {
                target: state.settings.home
            }

            if (parameters === undefined || parameters.target === undefined){
                console.error("For call 'redirect' action you need to set the 'target' parameter!");
                return;
            }
    
            if (parameters.target.includes("http://") || parameters.target.includes("https://")){
                document.location.href = parameters.target;
            }
            else {
                return {
                    router: {
                        push: parameters.target
                    }
                };
            }
        }
    },
    swzPrint: function({state, data}){
        var model = state.app.form.models.model;
        const IsIncludeUnansweredSection = data.IsIncludeUnansweredSection !== undefined ? data.IsIncludeUnansweredSection : true;
        var hiddenControlsForPrint = formHelper.swzGetHiddenControlsForPrint(model, data, state.app.form.models.model, IsIncludeUnansweredSection);
        PrintActions.print(model, data, hiddenControlsForPrint, 'clover-application-content');
    },

    swzPrintForm: function(form,data, IsIncludeUnansweredSection){
        var jsonForm = JSON.parse(form);
        var jsonData = JSON.parse(JSON.stringify(data),dateReviver);
        var printModel = formHelper.swzPrintModel(jsonForm);
        var hiddenControlsForPrint = formHelper.swzGetHiddenControlsForPrint(printModel, jsonData, printModel, IsIncludeUnansweredSection);
        return PrintActions.printForm(jsonForm, jsonData, hiddenControlsForPrint, 'clover-application-content');
    }
};
const gridUtils = {
    edit: ({ state, controlRef, parameters, isChild, formName }) => {
        return gridUtils.operation({ state, controlRef, parameters, isChild, formName, op: 'edit' });
    },
    create: ({ state, controlRef, parameters, isChild, formName }) => {
        return gridUtils.operation({ state, controlRef, parameters, isChild, formName, op: 'create' });
    },
    copy: ({ state, controlRef, parameters, isChild, formName }) => {
        return gridUtils.operation({ state, controlRef, parameters, isChild, formName, op: 'copy' });
    },
    operation: ({ state, controlRef, parameters, isChild, formName, op }) => {

        if (controlRef.props.editType === "flow") {
            throw {
                level: 1,
                message: "Comming soon..."
            };
        }

        let props = controlRef.props;
        let isCopy = op === 'copy';
        let isNew = op === 'create';

        let editFormName = props.editForm;
        let child = state.app.form.models.children ? state.app.form.models.children[editFormName] : null;
        let modals = [...state.app.form.modals];

        if (!isChild) {
            modals = [];
            modals.push(editFormName);
        } else {
            let newModals;
            for (let i = 0; i < modals.length; i++) {
                if (modals[i] === formName) {
                    newModals = modals.slice(0, i);
                    newModals.push(editFormName);
                    break;
                }
            }
            if (newModals)
                modals = newModals;
        }

        let index = modals.length - 1;
        let filter = null;
        let existingData = null;
        let selectedRow = gridUtils.getSelectedRow({ parameters, controlRef });
        if (!selectedRow && !isNew)
            return {};

        if (!isNew && selectedRow.__loaded) {
            let ctrlName = controlRef.props.name;
            var mappingToData = isChild ? state.app.form.models.children[formName].mapping.toData[ctrlName]
                : state.app.form.models.mapping.toData[ctrlName];
            var mappingToForm = child.mapping.toForm;
            existingData = gridUtils.mapRow(gridUtils.mapRow(selectedRow, mappingToData), mappingToForm);
            if (isCopy)
                existingData.__id = 'CLIENT__' + uuid();
        }
        else {
            filter = !isNew ? selectedRow.__id : " ";
        }

        let newData = {
            isDirty: false,
            isNew: isCopy || isNew,
            original: existingData,
            modified: existingData,
            filter: filter,
            property: controlRef.props.name
        };

        let children = {};
        let newIndex = !isChild ? 0 : index + 1;
        children[editFormName + '_' + newIndex] = newData;
        let childrenErrors = {};
        childrenErrors[editFormName + '_' + newIndex] = null;

        if (!child) {
            return (dispatch) => {
                return thunks.form.fetchform(editFormName, true)(dispatch)
                    .then(() => {
                        return Promise.resolve({
                            stateDelta: {
                                app: {
                                    form: {
                                        modals: modals,
                                        data: {
                                            children: children
                                        },
                                        errors: {
                                            children: childrenErrors
                                        }

                                    }
                                }
                            }
                        });
                    });
            };

        } else {
            return {
                app: {
                    form: {
                        modals: modals,
                        data: {
                            children: children
                        },
                        errors: {
                            children: childrenErrors
                        }
                    }
                }
            };
        }
    },
    mapRow: (original, mapping) => {
        let res = {};
        for (let propertyName in original) {
            if (propertyName.startsWith("__")) {
                res[propertyName] = original[propertyName];
            }
            if (mapping[propertyName]) {
                res[mapping[propertyName]] = original[propertyName];
            }
        }
        return res;
    },
    getSelectedRow: ({ parameters, controlRef }) => {
        let selectedIdx = -1;
        if (!isNull(parameters.rowIdx)) {
            selectedIdx = parameters.rowIdx;
        }
        else {
            if (controlRef.state.selectedIndexes.length > 0)
                selectedIdx = controlRef.state.selectedIndexes[0];
        }
        if (selectedIdx < 0)
            return undefined;
        return controlRef.state.items[selectedIdx];
    }
};

export {userActionInvoker, defaultActions, formHelper};