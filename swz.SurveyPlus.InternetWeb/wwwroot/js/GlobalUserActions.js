var globalUserActions = {
    //exit: function ({ data, originalData, state, component, formName }) {
    //    return {
    //        router : {
    //            push : '/'
    //        }
    //    }

    //    //return {
    //    //    router_push : '/'
    //    //    }
    //    }

    goBack: function (args) {
        args.state.router.history.goBack();
    },
    redirectToForm: function (args) {
        //console.log('redirectoToForm args', args)
        var id = args.data.Id;
        var formName = args.parameters.formName;
        CloverApp.API.redirectToForm(formName, id);
    },
    printSurvey: function (form,data,IsIncludeUnansweredSection) {
        CloverApp.API.printForm(form,data,IsIncludeUnansweredSection);
    } 
    
}
