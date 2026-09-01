-- Will UPDATE existing row(s) in dwMetadata for the following:
-- respdashboard-code.js

UPDATE dwMetadata SET
[Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:23.760', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2020-12-17 18:35:14.987', 
[Data]=N'{

    init: function(args){
        var innerArgs = args;            
            var url = ''/swzdata/getmultiple?type=RespDashboard'';
               
            var gridModelRewriter = function (model) {
                if (Array.isArray(model.columns)) {
                    model.columns[1].customFormatter = function (p) {
                        if(p.row.Type=="Offline"){
                            
                            var strTokens = p.row.Tokens;
                            var strOfflineLanguages = p.row.OfflineLanguages;
                            var tokens = strTokens.split(''||'');
                            var offlineLanguages = strOfflineLanguages.split(''||'');      
                            var elements = [];
    
                            tokens.forEach(genOfflineFormLinks.bind(null, p, elements, offlineLanguages));                            
                            return CloverApp.API.createElement("div", {}, elements);
                            
                            //return CloverApp.API.createElement("a", { href: url}, p.value); 
                        }
                        else if(p.row.Type=="Online"){
                            
                            var strFormNames = p.row.FormNames;
                            var strLanguages = p.row.Languages;
                            var formNames = strFormNames.split(''||'');
                            var languages = strLanguages.split(''||'');      
                            var elements = [];
    
                            formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                            return CloverApp.API.createElement("div", {}, elements);                            
                            
                        }
                        else{
                            return CloverApp.API.createElement("div", {}, p.value); 
                        }
                    };
                    
                    //model.columns[model.columns.length-1].customFormatter = function (p) {
                    //    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    //    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Get Password");
                    //};               
                 
                }
                return model;
            };
            
            var gridviewModelRewriter = function (model) {
                if (Array.isArray(model.columns)) {
                    model.columns[1].customFormatter = function (p) {
                        if(p.row.Type=="Offline"){
                            var strTokens = p.row.Tokens;
                            var strOfflineLanguages = p.row.OfflineLanguages;
                            var tokens = strTokens.split(''||'');
                            var offlineLanguages = strOfflineLanguages.split(''||'');      
                            var elements = [];
    
                            tokens.forEach(genOfflineFormLinkButtons.bind(null, p, elements, offlineLanguages));                            
                            return CloverApp.API.createElement("div", {}, elements);
                            
                            //return CloverApp.API.createElement("a", { href: url}, p.value); 
                        }
                        else if(p.row.Type=="Online"){
                            var strFormNames = p.row.FormNames;
                            var strLanguages = p.row.Languages;
                            var formNames = strFormNames.split(''||'');
                            var languages = strLanguages.split(''||'');      
                            var elements = [];
    
                            formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));
                            return CloverApp.API.createElement("div", {}, elements);  
                        }
                        else{
                            return CloverApp.API.createElement("div", {}, p.value); 
                        }
                    };
                    
                    //model.columns[model.columns.length-1].customFormatter = function (p) {
                    //    //args.state.app.form.data.modified.sampleInfoId = p.row.Id;
                    //    return CloverApp.API.createElement("button", { onClick: () => showModal(innerArgs, p.row.Id), className: "ui button mini secondary invert" }, "Get Password");
                    //};                  
                    
                }
                return model;
            };      
            

            
           /* var genFormLinks = function(p, elements, languages, value, index){
                var linkUrl = ''/form/'' + value + "/?dlsi=" + p.row.Id;
                var element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, languages[index]);
                elements.push(element);
                element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                elements.push(element);
            };*/
            var genOfflineFormLinks = function(p, elements, languages, value, index){
                var linkUrl = "/respondent/download/survey/" + p.row.Id + "/"  + value + "/" + p.row.RespId;
                var element = (p.row.IpAllowed || p.row.IpAllowed==undefined)?
                CloverApp.API.createElement("a", { href: linkUrl}, languages[index]):
                CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
                elements.push(element);
                element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                elements.push(element);
            };    
            
            var genFormLinkButtons = function(p, elements, languages, value, index){
                var linkUrl = ''/form/'' + value + "/dlsi/" + p.row.Id;
                var element = (p.row.IpAllowed || p.row.IpAllowed==undefined)?
                CloverApp.API.createElement("span", { onClick: () =>  {
                    CloverApp.API.redirect(''form'', value, ''dlsi/''+ p.row.Id)
                }, className: "link-style" }, languages[index]):
                CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, languages[index]);
                elements.push(element);
                element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                elements.push(element);
            };           
            
            var showModal = function (args, id) {
                return getPasswordAsync(args, id);
            }; 
            
            var getPasswordAsync = function (args, id) {
                var formData = new FormData();
                formData.append(''id'', id);
                var url = ''/respondent/getpassword'';
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
                            //console.log("getPasswordAsync args", args);
                            args.controlRef.refs.passwordModal.openModal();
                            args.component.state.data.password = response.item;
                            args.component.refs.password.forceUpdate();
                            //console.log(''response.item'', response.item);
    
                        } else {
                            alertify.error(response.message);
                        }
                    })
                    .catch(error => {
                        alertify.error(error.message);;
                    });
    
    
            };        
            
            
            $.get(url).done(function (data) {
            if(data.success){
                
                var htmlData = [];
                for (var i=0; i<data.data.length; i++){
                            htmlData.push(data.data[i].editorState);
                }
                CloverApp.API.setDataField("respDashboardHtmlView", htmlData);
            }
            else
              console.log(data.message);
            }).fail(function (jqxhr, textStatus, error) {
             console.log(textStatus);
            }); 
            
            CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
            CloverApp.API.rewriteControlModel("gridview", gridviewModelRewriter);

            //$(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
            
            //args.component.refs.grid.refresh();
            //args.component.refs.gridview.refresh();
        
    },
    
    closeModal: function (args) {

        args.component.refs.passwordModal.close();
        return {
        };

    }
    
    
}' WHERE [Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df';

