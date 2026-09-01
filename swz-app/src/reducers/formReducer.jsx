import { jsonEqual, mergeDeep, uuid, cloneDataObject } from '../utils.jsx'
import initialState from '../state.jsx'

const formReducer = {
    CLEAR: (state) => ({
        ...state,
        form: {
            ...initialState.app.form
        }
    }),
    MODEL:
    {
        FETCH:
        {
            BEGIN: (state) => (
                {
                    ...state,
                    fetchCount: state.fetchCount + 1
                }),
            SUCCESS: (state, { payload: { model, name, ischild, formParams, mapping, customCss } }) => {
                if (!ischild) {
                    return ({
                        ...state,
                        fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1),
                        form: {
                            ...state.form,
                            models: {
                                ...state.form.models,
                                model: model,
                                mapping: mapping
                            },
                            formParams: formParams,
                            customCss: customCss
                        }
                    });
                } else {
                    let newState = { ...state,
                        fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1)
                    };
                    if (newState.form.models.children) {
                        newState.form.models.children[name] = {model: model, mapping: mapping};
                    } else {
                        newState.form.models.children = {};
                        newState.form.models.children[name] = {model: model, mapping: mapping};

                    };
                    return newState;
                }
            },
            FAILURE: (state, { payload: { error, details } }) => ({
                ...state,
                fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1),
                error: error,
                errorDetails: details
            })
        }
    },
    DATA:
    {
        FETCH: {
            BEGIN: (state) => (
                {
                    ...state,
                    fetchCount: state.fetchCount + 1
                }),
            SUCCESS: (state, { payload: { data, name, index, ischild, isNew } }) => {
                if (ischild && state.form.data.children)
                {
                    let exData = state.form.data.children[name + "_" + index];
                    if (exData && exData.isNew)
                        isNew = true;
                }

                if (isNew)
                    data.__id = 'CLIENT__' + uuid();

                if (!ischild) {
                    return ({
                        ...state,
                        fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1),
                        form: {
                            ...state.form,
                            data: {
                                ...state.form.data,
                                isDirty: false,
                                isNew: isNew === undefined ? false : isNew,
                                original: data,
                                modified: cloneDataObject(data),
                                displayed : data
                            },
                            errors: {
                                children: null,
                                main: null
                            }
                        }
                    });
                } else {
                    let newState = { 
                        ...state,
                        fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1)
                    };
                    if (newState.form.errors.children)
                    {
                        newState.form.errors.children[name + '_' + index] = undefined;
                    }
                    if (!newState.form.data)
                        return newState;
                    if (newState.form.data.children) {
                        let child = newState.form.data.children[name + '_' + index];
                        if (!child) {
                            newState.form.data.children[name + '_' + index] = {
                                isDirty: false,
                                isNew: false,
                                original: data,
                                modified: cloneDataObject(data),
                                displayed: data
                            };
                        } else {
                            child.isDirty= false;
                            child.isNew= false;
                            child.original= data;
                            child.modified= cloneDataObject(data);
                            child.displayed = data;
                        }
                    } else {
                        newState.form.data.children = {};
                        newState.form.data.children[name + '_' + index] = {
                            isDirty: false,
                            isNew: false,
                            original: data,
                            modified: cloneDataObject(data),
                            displayed: data
                        };
                    };
                    return newState;
                }
            },
            FAILURE: (state, { payload: { error, details } }) => {
                return {
                ...state,
                fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1),
                error: error,
                errorDetails: details
            }}

        },
        UPDATE: (state, { payload: { key, value, name, index, ischild, updateDisplayed } }) => {
            let data = null;
            let delta = {};
            delta[key] = value;
            // if (!Array.isArray(value)) {
            //    delta[key] = value;
            // } else {
            //     delta[key] = new Array();
            //     let existingArray = !ischild ? state.form.data.modified[key] : state.form.children[name].modified[key];
            //     existingArray.forEach((item) => {
            //         let updated = value.find((updated) => item.__id === updated.__id);
            //         if (updated) {
            //             if (!updated.__deleted)
            //                 delta[key].push(mergeDeep(item, updated));
            //         } else {
            //             delta[key].push(item);
            //         }
            //     });
            // }

            let childName = name + '_' + index;

            if (!ischild) {
                data = mergeDeep(state.form.data.modified, delta);
            } else {
                data = mergeDeep(state.form.data.children[childName].modified, delta);
            }

            if (!ischild) {
                let newState;
                if (jsonEqual(data, state.form.data.original)) {
                   
                    newState = {
                        ...state,
                        form: {
                            ...state.form,
                            data: {
                                ...state.form.data,
                                isDirty: state.form.data.isNew ? state.form.data.isDirty : false,
                                modified: data
                            },
                            errors: {
                                ...state.form.errors,
                                main: null
                            }
                        }
                    };
                }
                else {newState= {
                    ...state,
                    form: {
                        ...state.form,
                        data: {
                            ...state.form.data,
                            isDirty: true,
                            modified: data
                        }
                    }
                };
                }
                if (updateDisplayed)
                    newState.form.data.displayed = data;

                return newState;
            } else {
                let newState = { ...state };

                if (!newState.form.data.children) {
                    newState.form.data.children = {};
                }

                let child = newState.form.data.children[childName];
                if (child) {
                    let original = newState.form.data.children[childName].original;
                    if (jsonEqual(data, original)) {
                        child.isDirty = child.isNew ? child.isDirty : false;
                        child.modified = data;
                    } else {
                        child.isDirty = true;
                        child.modified = data;
                        child.displayed = updateDisplayed ? data : child.displayed;
                        child.isNew = !child.original;
                    }
                } else {
                    child = new {
                        original: null,
                        modified: data,
                        displayed: data,
                        isDirty: true,
                        isNew: true
                    };
                    newState.form.data.children[childName] = child;
                }
                return newState;
            }
        },
        SAVE : {
            BEGIN: (state) => (
                {
                    ...state,
                    fetchCount: state.fetchCount + 1
                }),
            SUCCESS: (state, { payload: { data, name, ischild, index } }) => {
                 let newState = {
                    ...state,
                    fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1),
                    form: {
                        ...state.form,
                    }
                };
                
                if (!ischild) {
                    newState.form.errors.main = null;
                    newState.form.data.isNew = false;
                    newState.form.data.isDirty = false;
                    if (data !== null) {
                        newState.form.data.modified = data;
                    }
                    newState.form.data.original = newState.form.data.modified;
                    newState.form.data.displayed = newState.form.data.modified;
                    if (newState.form.data.children) {
                        for (let property in newState.form.data.children) {
                            if (object.hasOwnProperty(property)) {
                                let child = newState.form.data.children[property];
                                child.isNew = false;
                                child.isDirty = false;
                                child.original = cloneDataObject(child.modified);
                                child.displayed = child.modified;
                            }
                        }
                    }
                } else {
                    if (newState.form.errors.children)
                    {
                        newState.form.errors.children[name + '_' + index] = undefined;
                    }
                    if (newState.form.data.children && newState.form.data.children[name]) {
                        let child = newState.form.data.children[name];
                        child.isNew = false;
                        child.isDirty = false;
                        if (data !== null) {
                            child.modified = data;
                        }
                        child.displayed = child.modified;
                    }
                }
                return newState;
            },
            FAILURE: (state, { payload: { error, details, level, formerrors } }) => ({
                ...state,
                fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1),
                error: error,
                errorLevel: level, 
                errorDetails: details,
                form: {
                    ...state.form,
                    errors: formerrors == undefined ? {} : formerrors // == null ? state.form.errors : mergeDeep(state.form.errors, formerrors)
                }
            })
        },
        DELETE : {
            BEGIN: (state) => (
            {
                ...state,
                fetchCount: state.fetchCount + 1
            }),
            SUCCESS: (state, { payload }) => ({ 
                ...state,
                fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1)
            }),
            FAILURE: (state, { payload: { error, details, level, formerrors } }) => ({
                ...state,
                fetchCount: (state.fetchCount <= 0 ? 0 : state.fetchCount - 1),
                error: error,
                errorLevel: level, 
                errorDetails: details,
                form: {
                    ...state.form,
                    errors: formerrors == undefined ? {} : formerrors // == null ? state.form.errors : mergeDeep(state.form.errors, formerrors)
                }
            })
        }
    }
}


export default formReducer;
