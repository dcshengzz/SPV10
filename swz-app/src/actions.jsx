import { createActions } from 'redux-actions'

const actions = createActions({
    UPDATESTATE: (stateDelta) => ({ stateDelta: stateDelta }),
    APP: {
        USERINFO: {
            FETCH: {
                BEGIN: undefined, // parameterless
                SUCCESS: (user) => ({ user: user }),
                FAILURE: (error, details) => ({ error: error, details: details })
            }
        },
        LICENSEEXPIRY: {
            FETCH: {
                BEGIN: undefined,
                SUCCESS: (licenseexpiry) => ({ licenseexpiry: licenseexpiry }),
                FAILURE: (error, details) => ({ error: error, details: details })
            }
        },
        AUTOSAVE: {
            FETCH: {
                BEGIN: undefined,
                SUCCESS: (autosave) => ({ autosave: autosave }) ,
                FAILURE: (error, details) => ({ error: error, details: details })
            }
        },
        CLEARERRORS: undefined,
        FAILURE: (error, details, level) => ({ error: error, details: details, level: level }),
        FETCHBEGIN: undefined,
        RESETFETCHCOUNT: undefined,
        FORM:
        {
            MODEL:
            {
                FETCH:
                {
                    BEGIN: undefined, // parameterless
                    SUCCESS: (model, mapping, name, ischild, customCss, formParams) => ({
                        model: model, 
                        name: name, 
                        ischild: ischild,
                        formParams: formParams,
                        mapping: mapping,
                        customCss: customCss
                    }),
                    FAILURE: (error, details) => ({ error: error, details: details })
                }
            },
            DATA:
            {
                FETCH:
                {
                    BEGIN: undefined, // parameterless
                    SUCCESS: (data, name, index, ischild, isNew) =>
                        ({ data: data, name: name, index: index, ischild: ischild, isNew: isNew }),
                    FAILURE: (error, details) => ({ error: error, details: details })
                },
                UPDATE: (key, value, name, index, ischild, updateDisplayed) => ({ key: key, value: value, name: name, index: index, ischild: ischild, updateDisplayed: updateDisplayed}),
                SAVE: {
                    BEGIN: undefined,
                    SUCCESS: (data, name, ischild, index, url) => ({ data: data, name: name, ischild: ischild,index:index, url: url}),
                    FAILURE: (error, details, level, formerrors) => ({ error: error, details: details, level: level, formerrors: formerrors })
                },
                DELETE: {
                    BEGIN: undefined,
                    SUCCESS: (name, ischild) => ({ name: name, ischild: ischild }),
                    FAILURE: (error, details,  level, formerrors) => ({ error: error, details: details, level: level, formerrors: formerrors })
                }
            },
            CLEAR: undefined
        }
    },
    ROUTER: {
        PUSH: (newurl) => ({ newurl: newurl }),
        REDIRECT: (newurl) => ({ newurl: newurl }),
        REFRESH: () => ({ newurl: "refresh" }),
        ROUTECHANGED: (history, location) => ({ history: history, location: location }),
        CHANGEURLFILTER: (newfilter) => ({newfilter: newfilter})
    }
});

export default actions;
