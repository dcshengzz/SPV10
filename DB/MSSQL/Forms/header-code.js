{
    init: function(args){
        headerUserActions.SetupAlternativeAcc(args);
        headerUserActions.LoadBrandingImagePath(args);
    },
    
    SetupAlternativeAcc: function(args){
        Utils.loadingStart();
        Utils.getRequest("/account/getalternativeacc/").then(
            response => {
                if(response.success && response.item && response.item.length > 0){
                    let options = [];
                    let logoutItem = {target: '/account/logoff', title: 'Logout'};
                    for(let i in response.item){
                        let item = {target: '/account/switchacc/' + response.item[i].id, title: response.item[i].name};
                        options.push(item);
                    }
                    options.push(logoutItem);
                    args.controlRef.refs.currentUser.props.items = options;
                    CloverApp.API.changeModelControlByModel(args.component.state.model,'currentUser','items',options);
                    args.component.refs["currentUser"].forceUpdate();
                }
            }, reason => {
                console.log('SetupAlternativeAcc', reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    onMenuItemClick: function(args){
        console.log('onMenuItemClick',args);
        if(args.parameters.target === '/account/logoff'){
            CloverApp.API.redirect('account','logoff',undefined);
        }else{
            Utils.loadingStart('Switching Account...');
            Utils.postFormRequest(args.parameters.target).then(
                response => {
                    if(response.success){
                        document.location.href = window.location.origin;
                    }else{
                        alertify.error( Utils.encodeHTML(response.message) );
                    }
                }, reason => {
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally( Utils.loadingStop );
        }
    },
    
    LoadBrandingImagePath: function(args){
        Utils.getRequest("/ui/brandingImagePath").then(
            response => {
                if(response.success && response.item && Object.keys(response.item).length > 0){
                    let path = '/' + response.item.BrandingImagePath + '/logo.png'
                    args.controlRef.refs.logo.props.src = path;
                    CloverApp.API.changeModelControlByModel(args.component.state.model,'logo','src',path);
                    args.component.refs["logo"].forceUpdate();
                }
            }, reason => {
                console.log('Error load branding image');
            }
        );
    }
}