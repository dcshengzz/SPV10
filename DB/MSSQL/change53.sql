-- Open a new tab after clicking the download link in SwzDplyList form; parent window remains same

UPDATE TOP(1) [dbo].[dwMetadata] SET [Id]='4D440057-891C-4FE7-AA60-47B67638B311', [Folder]=N'metadata/forms', [Filename]=N'SwzDplyList-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:25.280', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='B9D69BA9-282B-D3D2-8F23-EFC2596A082C', [UpdatedDate]='2020-04-10 11:05:51.893', [Data]=N'{
     init: function (args) {
        var innerArgs = args;
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[model.columns.length-2].customFormatter = function (p) {
                    
                    //return CloverApp.API.createElement(''input'',{type: ''checkbox'', className: ''ui checkbox'', id: p.row.Id, defaultChecked: p.row.Status, onChange: () => showModal(innerArgs, p.row.Id)});
                    var url = "/deployment/download/resp/" + p.row.Id + "/" + p.row.QnnId;
                    if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
                    return CloverApp.API.createElement("a", {href: url, target: "_blank", onClick: (e)=>{e.stopPropagation()}}, p.row.RespCount + " / " + p.row.SampleCount);
                    //return CloverApp.API.createElement("a", {href: url}, "Export");  
                };
                model.columns[model.columns.length-1].customFormatter = function (p) {
                    //return CloverApp.API.createElement("div", {}, p.row.RespCount + " / " + p.row.SampleCount); 
                    if(p.row.RespCount==0) return CloverApp.API.createElement("div", {}, "");
                    return CloverApp.API.createElement("span", {onClick: ()=> swzdplylistUserActions.scheduleZipFileDownload(p.row.Id), className: ''link-style''}, ''Download Zip''); 
                };                

            }
            return model;
        };

        var activateDeploymentAsync = function (args, id) {
            
            if(!$(''#''+id).is('':checked'')){
                $(''#''+id).prop(''checked'', true);
                args.controlRef.refs.swzmodalNotAllowed.props.swzData.isOpen = true;
                args.controlRef.refs.swzmodalNotAllowed.openModal();
            }
            else{
                $(''#''+id).prop(''checked'', false);
                args.state.app.extra.dplyId = id;
                args.controlRef.refs.confirmModal.props.swzData.isOpen = true;
                args.controlRef.refs.confirmModal.openModal();
            }
  
            return {};
        };

        var showModal = function (args, id) {

            return activateDeploymentAsync(args, id);

        };

        CloverApp.API.rewriteControlModel("gridview_1", gridModelRewriter);

    },
    closeModal: function (args){
        //console.log("closeModal args:", args);
        args.component.refs.swzmodalNotAllowed.close();
    },


    activateDeployment: function (args) {
        
        var changeStatusAsync = function (id) {
            var formData = new FormData();
            formData.append(''id'', id);
            var url = ''/deployment/activate'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        alertify.success(response.message);
                         $(''#''+id).prop(''checked'', true);

                    } else {
                        alertify.error(response.message);
                    }
                })
                .catch(error => {
                    alertify.error(error.message);;
                });
                 args.component.refs.confirmModal.close();


        };
        console.log("activateDeployment args:", args);
        let id =  args.state.app.extra.dplyId;
        $(''#''+id).prop(''checked'', false);   
        changeStatusAsync(id);
        return {


        };

    },
    
    scheduleZipFileDownload: function (dplyId) {

        var url = ''/deployment/schedule/zipfiledownload/'' + dplyId;
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                if (response.success) {
                    alertify.success(response.message);

                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                alertify.error(error.message);;
            });
    }

}
', [StructDivisionId]='F6E34BDF-B769-42DD-A2BE-FEE67FAF9045' WHERE ([Id]='4D440057-891C-4FE7-AA60-47B67638B311');
GO