{
    init: function(args){
        var urlSearchParams = new URLSearchParams(window.location.search);
        var params = Object.fromEntries(urlSearchParams.entries());
        if(params.datavalidation !== undefined){
            CloverApp.API.setDataField("Validation", params.datavalidation);
        }
    },
    goback: function (args){
        const back = args.state.router.history.goBack;
        return back;
    },
    
    clearServerCache: function(args){
        const url = '/datavalidationrule/clearCache';
        return fetch(url,
            {
                credentials: 'same-origin',
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                method: 'post'
            })
        return;
    }
    
}



