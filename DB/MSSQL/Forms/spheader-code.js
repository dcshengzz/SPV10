{
    init: function(args){
        spheaderUserActions.LoadBrandingImagePath(args);
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