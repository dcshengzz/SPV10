import React from 'react'
import store from './store.jsx'
import actions from './actions.jsx'
import {defaultActions, formHelper} from './thunks/useractioninvoker.jsx'
import { Popup } from 'semantic-ui-react'
import moment from 'moment';
import confirm from './components/confirmcomponent';

let api = {
    getModelConrol: function(model, controlKey){
        for(let i in model){
            let control = model[i];
            if(control.key == controlKey){
                return control;
            }

            if(control.children != undefined && control.children.length > 0){
                let c = api.getModelConrol(control.children, controlKey);
                if(c != undefined){
                    return c;
                }
            }
        }

        return undefined;
    },
    changeModelControl: function(args, key, name, value){
        return api.changeModelControls(args, [{key, name, value}]);
    },
    changeModelControls: function(args, controlsParameters){
        return api.changeModelControlsByModel(args.state.app.form.models.model, controlsParameters);
    },
    changeModelControlByModel(model, key, name, value){
        return api.changeModelControlsByModel(model, [{key, name, value}]);
    },
    changeModelControlsByModel: function(model, controlsParameters){
        let changesParameters = function(control, controlsParameters){
            for(let i=0; i < controlsParameters.length; i++){
                let cp = controlsParameters[i];
                if(control.key == cp.key){
                    control[cp.name] = cp.value;
                }
            }

            if(control.children != undefined && control.children.length > 0){
                for(let i in control.children){
                    let child = control.children[i];
                    changesParameters(child, controlsParameters);
                }
            }
        };

        for(let i in model){
            let control = model[i];
            changesParameters(control, controlsParameters);
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
    setDataField(key, value){
        store.dispatch(actions.app.form.data.update(key, value));
    },

    rewriteControlModel(controlkey, rewriter){
        let state = store.getState();
        let model = state.app.form.models.model;
        let control = api.getModelConrol(model, controlkey);
        let newControl = rewriter(control);
        if(newControl !== control){
            for(let p in newControl){
                control[p] = newControl[p];
            }
        }
        store.dispatch(actions.updatestate({}));
        let newModel = store.getState().app.form.models.model;

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
    clearErrors(){
        store.dispatch(actions.app.clearerrors());
    },

    forceUpdate(){
        store.dispatch(actions.updatestate({}));
    },

    redirectToForm(name, parameters){
        api.redirect('form', name, parameters);
    },
    redirectToFlow(name, parameters){
        api.redirect('flow', name, parameters);
    },
    redirectToPage(name, parameters){
        api.redirect('page', name, parameters);
    },
    redirect(type, name, parameters){
        var url = '/' + type + '/' + name;
        if(parameters !== undefined && parameters !== null){
            url += '/' + parameters;
        }

        store.dispatch(actions.router.push(url));
    },

    formValidate(args){
        return defaultActions.validate(args);
    },

    createElement(type, props, children){
        return React.createElement(type, props, children);
    },

    createElementWithPopup(popupText, props, children){
        return <Popup {...props} content={popupText} trigger={children}/>;
    },

    checkRole(role){
        return formHelper.checkRole(role, store.getState());
    },

    checkPermission(permission){
        return formHelper.checkPermission(permission, store.getState())
    },

    //format - Please refer to window.CloverLang.common.dateFormat
    formatDatetime(datetimeValue, format){
        var value = moment(datetimeValue);
        if(value.isValid()){
            return value.format(format);
        }
        return datetimeValue;
    },

    confirm({parameters}){
        const messages = {};

        function setDefault(key, value) {
            if (!messages[key]) {
                if (window.CloverAdminLang) {
                    messages[key] = window.CloverAdminLang.confirm[key];
                }else{
                    messages[key] = value;
                }
            }
        }

        console.log("parameters ", parameters);
        console.log("Windows CloverAdminLang ", window.CloverAdminLang);
        console.log("Windows CloverLang ", window.CloverLang);

        if (parameters && window.CloverLang && window.CloverLang.msg) {
            messages.title = window.CloverLang.msg[parameters.confirmTitle];
            messages.text = window.CloverLang.msg[parameters.confirmText];
            messages.ok = window.CloverLang.msg[parameters.confirmOk];
            messages.cancel = window.CloverLang.msg[parameters.confirmCancel];
        }

        setDefault('title', "Confirm");
        setDefault('text', "Please confirm the action");
        setDefault('ok', "Ok");
        setDefault('cancel', "Cancel");

        return confirm(messages);
    },

    printForm(form,data,IsIncludeUnansweredSection){
        return new Promise(function(resolve, reject) {
            var htmlContent = defaultActions.swzPrintForm(form, data, IsIncludeUnansweredSection);
            resolve(htmlContent);
        });
    }
};

export default api;