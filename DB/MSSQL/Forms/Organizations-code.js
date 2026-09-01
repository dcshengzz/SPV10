{
    init: function(args) {
        let hasRootOrg = args.data.collectioneditor_1.some(organization => organization.ParentId === null)
        if(!CloverApp.API.checkRole('Admins') || hasRootOrg){
            const rewriter = function(model) {
                model.disableAdd = true;
            }
            CloverApp.API.rewriteControlModel("collectioneditor_1", rewriter);
        }
    },
    
    onChangeOrg: function (args){
        const rewriter = function(model) {
            if(!args.data.collectioneditor_1.some(organization => organization.ParentId === null) && 
                args.data.collectioneditor_1.every(organization => 'ParentId' in organization)    &&
                CloverApp.API.checkRole('Admins'))
            {
                model.disableAdd = false;
            }
            else
            {
                model.disableAdd = true;
            }

        }
        CloverApp.API.rewriteControlModel("collectioneditor_1", rewriter);
    },
}