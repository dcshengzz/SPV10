const initialState = {
    app: {
        user : null,
        impersonatedUserId: null,
        fetchCount: 0,
        error: undefined,
        errorDetails: undefined,
        form : {
            models: {
                model: null, //main form model
                mapping: null, // main mapping (use fro modal popups)
                children: null, //children[childForm] == {model,mapping,hideControls,readOnlyControls}
                hideControls: null,
                readOnlyControls: null,
                readOnly: null
            },
            filters: {
                main: null,// grid1 : {column: 'columnName', value: value, term: 'like'}
                children: null //same object as a filter
            },
            modals: new Array(),
            data : {
                isDirty: false,
                isNew : false, //fase if this data were obtained from the server
                original: null,
                modified: null,
                displayed: null, 
                children: null //Предполагаю объект - хэш таблицу children[childForm_index] == {isDirty:isDirty,original:original,modified:modified,filter:{}} index берется из modals
            },
            errors:{
                main: null,
                children: null
            },
            formParams: {
                schemes: null,
                securityGroup: undefined,
                permissions: null,
                children: null,
                name: null
            },
            customCss: null
        }
    },
    router:
    {
        history: null,
        redirect: null,
        location: null,
        push: null,
        filter: null
    },
    settings: {
        backendUrl: "", //"http://domain.com"
        fetchOptions : undefined,
        form: "form",
        flow: "flow",
        home: "/",
        accountget: "/account/get",
        uiform: "/ui/form",
        uiformpreview: "/preview",
        uiflow: "/ui/flow",
        dataget: "/data/get",
        datachange: "/data/change",
        datadelete: "/data/delete",
        datadictionary: "/data/dictionary",
        dataupload: '/data/upload/',
        datadownload: '/data/download/',
        workflowexecute: "/workflow/execute",
        workflowset: "/workflow/set",
        notificationhub: "/hubs/notifications",
        swzGetServerDateTime: "/swzdata/getserverdatetime",
        onLastSavedKey: "OnSwzSurveyLastSaved",
        LastSavedPage: "LastSavedPage",
        licenseexpiryget : "/account/getlicenseexpiry",
        autosaveget : "/resp/autosavesettings",
        autosavegetintra : "/setting/autosavesettings"
    }
};

export default initialState;