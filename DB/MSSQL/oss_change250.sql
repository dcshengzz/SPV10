-- Will UPDATE existing row(s) in dwMetadata for the following:
-- header-code.js

UPDATE [dwMetadata] SET
[Id]='d2b77f0a-b241-4941-8472-cd5071b95f0b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'header-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-11-29 15:29:54.600', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-12-03 14:26:18.360', 
[Data]=N'{
    init: function(args){
        headerUserActions.SetupAlternativeAcc(args);
    },
    SetupAlternativeAcc: function(args){
        Utils.loadingStart();
        Utils.getRequest("/account/getalternativeacc/").then(
            response => {
                if(response.success && response.item && response.item.length > 0){
                    let options = [];
                    let logoutItem = {target: ''/account/logoff'', title: ''Logout''};
                    for(let i in response.item){
                        let item = {target: ''/account/switchacc/'' + response.item[i].id, title: response.item[i].name};
                        options.push(item);
                    }
                    options.push(logoutItem);
                    args.controlRef.refs.currentUser.props.items = options;
                    CloverApp.API.changeModelControlByModel(args.component.state.model,''currentUser'',''items'',options);
                    args.component.refs["currentUser"].forceUpdate();
                }
            }, reason => {
                console.log(''SetupAlternativeAcc'', reason);
            }
        ).finally(Utils.loadingStop);
    },
    onMenuItemClick: function(args){
        console.log(''onMenuItemClick'',args);
        if(args.parameters.target === ''/account/logoff''){
            CloverApp.API.redirect(''account'',''logoff'',undefined);
        }else{
            Utils.loadingStart(''Switching Account...'');
            Utils.postFormRequest(args.parameters.target).then(
                response => {
                    if(response.success){
                        document.location.href = window.location.origin;
                    }else{
                        alertify.error(response.message);
                    }
                }, reason => {
                    alertify.error(reason);
                }
            ).finally( Utils.loadingStop );
        }
    }
}' WHERE [Id]='d2b77f0a-b241-4941-8472-cd5071b95f0b';

