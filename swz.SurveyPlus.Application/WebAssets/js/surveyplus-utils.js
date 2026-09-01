/**
 * Shared scripts for SurveyPlus
 */
window.Utils = {

    EMPTY_GUID: "00000000-0000-0000-0000-000000000000",

    isSelected: function (toggleValue) {
        return Boolean(true === toggleValue || 1 === toggleValue || "1" == toggleValue || "true" === String(toggleValue).toLowerCase());
    },

    loadingStart: function (loadingMessage) {
        $('body').loadingModal({
            text: loadingMessage ? loadingMessage : 'Processing...',
            animation: 'wave',
            backgroundColor: '#1262E2'
        });
    },

    loadingStop: function () {
        $('body').loadingModal('destroy');
    },

    /**
     * Returns a promise with common error or json deserialisation handling logic for requests
     * @param promise the promise that makes the request (i.e the fetch)
     * @param httpFailMsg the rejection reason message to use if response.ok is false (http status will be appended)
     * @param url the url being requested
     * @returns promise
     */
    promiseWithCommonHandlingForRequest(promise, url) {
        if (promise === undefined || (promise === null)) {
            throw new Error("promise not specified");
        }
        if (url === undefined || (url === null)) {
            throw new Error("url not specified");
        }
        return promise.then(response => {
            //fetch will return whatever response it got from server,
            //so check the status to see was http success or http failure indicated
            if (response.ok) {
                //common handling assumes the response is json, try to deserialise it here
                return response.json();
            } else {
                //n.b. http error status that are redirected by server will bypass this
                console.warn("Common handling for request: http status " + response.status, url);
                return Promise.reject("The request failed, status: " + response.status);
            }
        }, reason => {
            //fetch API will will reject if it can't contact server
            //or response has bad Access-Control-Allow-Origin headers
            console.warn("Common handling for request: promise was rejected", url, reason);
            return Promise.reject("Failed to issue request to server: " + reason);
        }).then(responseData => {
            //check the deserialised object for application success indicator
            if (responseData.success) {
                return responseData;
            } else {
                console.warn("Application returned a failure response", responseData, url);
                return Promise.reject(responseData.message
                    ? responseData.message
                    : responseData);
            }
        }, reason => {
            if (reason.message && reason.message.includes("Unexpected token")) {
                //failure to parse the json is typically because we got an html response which is usually
                //due to incorrect url, session timeout, or something between client & server returning html error page
                //or the server redirecting error results to html error page
                console.warn(url + " appears to have returned a non JSON response. Is url correct?"
                    + ((!url.startsWith("/") && !url.startsWith("http")) ? " should it start with a / ?" : ""));
            }
            return Promise.reject(reason);
        });
    },

    postFormRequest: function (url, formData) {
        if (url === undefined || (url === null)) {
            throw new Error("url not specified");
        }
        if ((formData === undefined) || (formData === null)) {
            formData = new FormData();
        }
        const postPromise = fetch(url, {
            credentials: "same-origin",
            method: "post",
            body: formData, //fetch will set multipart/form-data Content-Type for this
        });
        console.log("postPromise", postPromise);
        return Utils.promiseWithCommonHandlingForRequest(postPromise, url);
    },

    /**
     * Sends a GET request to the server and expect a json response with a success flag and data value.
     * Will also reject the promise if the response object had a false success value (so dont need to check that in the success block again)
     * Returns a promise.
     * @param url 
     * @param searchParams an instanceof URLSearchParams or an object that will be used to construct an instance of URLSearchParams
     */
    getRequest: function(url, searchParams) {
        if (url === undefined || (url === null)) {
            throw new Error('url not specified');
        }
        if (!(searchParams === undefined || searchParams === null)) {
            if (!(searchParams instanceof URLSearchParams)) {
                searchParams = new URLSearchParams(searchParams);
            }
            url = url + "?" + searchParams.toString();
        }
        const getPromise = fetch(url, {
            credentials: "same-origin",
            method: "get"
        })
        return Utils.promiseWithCommonHandlingForRequest(getPromise, url);
    },

    /**
     * Post json to the server.
     * Returns a promise.
     * @param url 
     * @param data text or an object to convert to json to send
     */
    postJsonRequest: function (url, data) {
        if (url === undefined || (url === null)) {
            throw new Error('url not specified');
        }
        const postPromise = fetch(url, {
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json; charset=UTF-8",
            },
            method: "post",
            body: JSON.stringify(data),
        })
        return Utils.promiseWithCommonHandlingForRequest(postPromise, url);
    },

    deleteRequest: function (url, body) {
        if (url === undefined || (url === null)) {
            throw new Error('url not specified');
        }
        if ((body === undefined) || (body === null)) {
            body = "";
        } else if (!(typeof body == "string")) {
            body = JSON.stringify(body);
        };
        const deletePromise = fetch(url, {
            headers: {
                'Content-Type': 'application/json',
            },
            credentials: 'same-origin',
            method: 'delete',
            body: body,
        });
        return Utils.promiseWithCommonHandlingForRequest(deletePromise, url);
    },

    /**
     * Post a requuest to save form data
     * @param data args.data
     * @param name name of form
     */
    changeData: function (data, name) {
        const url = "/data/change?name=" + encodeURIComponent(name);
        const formData = new FormData();
        formData.append("data", JSON.stringify(data));
        const postPromise = fetch(url, {
            credentials: "same-origin",
            method: "post",
            body: formData, //fetch will set multipart/form-data Content-Type for this
        });
        return Utils.promiseWithCommonHandlingForRequest(postPromise, url);
    },

    /**
     * Performs a zero timeout callback so that the task will be performed 
     * in another execution context.
     * @param {any} callback
     */
    queueTask: function (callback) {
        window.setTimeout(callback, 0);
    },

    /**
     * Convenience method to assemble an UPDATE action with the specified delta and dispatch it to
     * the CloverStore
     * @param {any} delta
     */
    dispatchUpdate: function (delta) {
        if (delta === undefined || delta == null) {
            delta = {};
        }
        const action = {
            type: "UPDATESTATE",
            payload: {
                stateDelta: delta,
            },
        };
        CloverStore.dispatch(action);
    },

    /**
     * Will queue a task to determine a new list of hideControls based on state at time of invocation 
     * that includes / doesnt include the named control and then immediately dispatch an UPDATESTATE 
     * delta to the store to update it accordingly. 
     * nb: This doesnt update visibleConitions, so for the control to stay hidden or revealed as the form
     * is manipulated you will still need its conditions to be set appropriately.
     * @param {any} controlName name of a single control
     * @param {any} optional "show" or "hide" (default is hide). Can also use true for hide, false for show.
     */
    queueHideControl: function (controlName, action = "hide") {
        Utils.queueTask(() => {
            Utils.dispatchHideControl(controlName, action);
        });
    },

    /**
     * Will mutate a state delta object to write the hideControls to it, 
     * creating the necessary nested objects if they are undefined. You may pass either an array
     * or set.
     * @param {any} delta a state delta
     * @param {any} hideControls set of controls to hide (also supports array)
     */
    writeHideControls: function (delta, hideControls) {
        if (hideControls instanceof Set) {
            hideControls = Array.from(hideControls);
        }
        if (delta.app === undefined) {
            delta.app = {};
        }
        if (delta.app.form === undefined) {
            delta.app.form = {};
        }
        if (delta.app.form.models === undefined) {
            delta.app.form.models = {};
        }
        delta.app.form.models.hideControls = hideControls;
    },

    /**
     * nb: you will usually want to call this via queueHideControl so that it can be evaluated independently
     * @param {any} controlName name of a single control
     * @param {any} optional "show" or "hide" (default is hide). Can also use true for hide, false for show.
     */
    dispatchHideControl: function (controlName, action) {
        if (action === undefined || action === null) {
            action = "hide";
        } else if (typeof action == "boolean") {
            action = action ? "hide" : "show";
        }
        const state = CloverStore.getState();
        const hideControls = new Set(state.app.form.models.hideControls);
        action = action.toLowerCase();
        switch (action) {
            case "hide":
                hideControls.add(controlName);
                break;
            case "show":
                hideControls.delete(controlName);
                break;
            default:
                throw new Error("Invalid action " + action);
        }
        const delta = {};
        Utils.writeHideControls(delta, hideControls);
        Utils.dispatchUpdate(delta);
    },
    
    /**
     * Prepare a delta for updating data-elements of a Dropdown and set an initial value.
     * It is caller's responsibility to dispatch the delta (for example by returning it from an action handler)
     * @param {*} args 
     * @param {*} name 
     * @param {*} data 
     * @param {*} initialValue 
     */
    initDropdownDelta: function(args, name, data, initialValue) {
        initialValue = (initialValue===undefined) ? "" : initialValue;
        const delta = CloverApp.API.changeModelControl(args, name, "data-elements", data);
        CloverApp.API.setDataField(name, initialValue); 
        return delta;
    },

    /**
     * Initialise a Dropdown by rewriting its model with the supplied options and setting an intial value.
     * @param {any} name
     * @param {any} data
     * @param {any} initialValue
     */
    rewriteDropdown: function (name, data, initialValue) {
        initialValue = (initialValue === undefined) ? "" : initialValue;
        CloverApp.API.rewriteControlModel(name, (model) => model['data-elements'] = data);
        CloverApp.API.setDataField(name,  initialValue);
    },

    /**
     * Construct a URL to redirect to another form. This version allows for specifying additional url search parameters.
     * Note that redirects won't usually work if in the same chain of events as a formRefresh.
     * If specifying queryParameters with a string it is callers responsibilty to apply url encoding. 
     * For queryParameters specified with an object or URLSearchParameters then url encoding will be applied automaticaly.
     * @param {any} name name of the Clover form to redirect to
     * @param {any} pathParameter (optional) A single Id parameter of the entity to load in the form - will be part of path. Uri encoding is applied automatically.
     * @param {any} queryParameters (optional) URL Search Parameters to pass as URL search params. 
     *                              You may pass an object with string key/value pairs or an instance of URLSearchParams or a plain old string to append.
     */
    redirectToForm: function (name, pathParameter, queryParameters) {
        const encodedPathParameter = pathParameter ? encodeURIComponent(pathParameter) : null;
        if (queryParameters) {
            const path = "/form/" + name + (encodedPathParameter ? "/" + encodedPathParameter : "");
            let queryString = null;
            if(queryParameters instanceof URLSearchParams) {
                queryString = queryParameters.toString();
            } else if(typeof queryParameters == 'string') {
                queryString = queryParameters;
            } else {
                const usp = new URLSearchParams(queryParameters);
                queryString = usp.toString();
            }
            if(queryString.lastIndexOf("?",0)!=0) {
                queryString = "?" + queryString;
            }
            const url = path + queryString;
            const state = CloverStore.getState();
            state.router.history.push(url);
        } else {
            CloverApp.API.redirectToForm(name, encodedPathParameter);
        }        
    },

    /**
     * Convenience function to create an instance of URLSearchParams based on window.location.search
     */
    searchParams: function () {
        const wls = window.location.search;
        const urlParams = new URLSearchParams(wls);
        return urlParams;
    },

    /**
     * Encodes html string by converting certain characters to html entities
     * @param {any} html
     */
    encodeHTML: function (html) {
        const node = document.createElement('div');
        node.textContent = html;
        return node.innerHTML;
    },

    /**
     * Format a date (local timezone) in yyyy-MM-dd HH:mm or yyyy-MM-dd HH:mm:ss.fff if exact is true
     * @param {any} date
     * @returns string
     */
    formatDateTime: function (date, exact) {
        if (date == null) return "";
        //n.b. local time is automatic when using getXXX
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
        const milliseconds = String(date.getMilliseconds()).padStart(3, '0');
        return exact
            ? `${year}-${month}-${day} ${hours}:${minutes}:${seconds}.${milliseconds}`
            : `${year}-${month}-${day} ${hours}:${minutes}`;
    },
};
