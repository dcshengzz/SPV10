{
    init: function (args){
        var gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Tags.customFormatter = tagsColumnFormatter;
                cols.Name.customFormatter = nameFormatter;
            }
            return model;
        };
        const nameFormatter = function(p) {
            var url = "/form/DataEditorDeployment/" + p.row.DplyId;
            return CloverApp.API.createElement("span", { onClick: () =>  {
                CloverApp.API.redirect('form', 'DataEditorDeployment', p.row.Id)
                }, className: "link-style" }, p.value);
        }
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();
            let tagsLimit = 3; //For tags which is more then 3, it will shows number of tags.
            if(tags.length > tagsLimit) {
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                tags.forEach((item) => tagsLabel.push(CloverApp.API.createElement("label", {title: item, className:"ui label small"}, item)))
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
            
        };
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    }
}
