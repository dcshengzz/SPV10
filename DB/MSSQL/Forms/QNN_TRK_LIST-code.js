{
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
    },
    
    onDownloadTemplate(args){
        const filename = "trklistsample_import_template.csv";
        var data = [["UID", "NAME", "EMAIL", "REMARKS", "STATUSCODE"],
        ["UID001", "Albert Einstein", "einstein@softworkz.net", "Cease operation", "PE"]];
        let csvContent = data.map(e => e.join(",")).join("\n");      
        blob = new Blob([csvContent], {type: "octet/stream"}),
        encodedUri = window.URL.createObjectURL(blob);
        if (typeof window.navigator.msSaveBlob !== 'undefined') {
            window.navigator.msSaveBlob(blob, filename);
        } else {
            var link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", filename);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    },
    
    newTrkListSample: function(args){
        CloverApp.API.redirect('form', 'QNN_TRK_LIST_SAMPLE', '/trklistid/'+ args.data.Id)
    },
    
    exportSample: function (args){
        if(args.controlRef.state.rowsCount==0){
            alertify.error("Nothing to export");
            return;
        }
        var url = '/trklist/exportsample?trkListId=' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },

    selectFile: function (args) {
        var file = $("input[name='inputImportListSamples']")
        file.trigger('click');
    },

    hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        CloverApp.API.setDataField("gridviewImportSummary", null);         
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null 
                      }
                  },
                  models:{
                      hideControls: ['headerListSampleAdded','headerListSampleUpdated','gridviewImportSummary']
                  }
              }
            }
        }        
        
    },
    
    submitFile(args)
    {
        const token = args.data.inputImportListSample;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        const formData = new FormData();
        formData.append("trkListId",args.data.Id);
        formData.append("token", token);

        Utils.loadingStart();
        Utils.postFormRequest("/trklist/importsamples", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                console.log("response", response);
                CloverApp.API.setDataField("inputImportListSample", null);
                args.component.refs.gridviewSample.refresh();
                CloverApp.API.setDataField("listSampleAddedCount", response.statistics.trkListSampleAdded);
                CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.trkListSampleUpdated); 
                Utils.queueHideControl("headerListSampleAdded", false);
                Utils.queueHideControl("headerListSampleUpdated", false);
                const hasErrorMessages = response.items!=null && response.items!=undefined && response.items.length>0;
                if(hasErrorMessages){
                    console.log("items", response.items);
                    CloverApp.API.setDataField("gridviewImportSummary", response.items);  
                    Utils.queueHideControl("gridviewImportSummary", false);
                }
                else{
                    Utils.queueHideControl("gridviewImportSummary", true);                     
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), 15000);
            }
        ).finally(Utils.loadingStop());
    }, 
  
    closeModal: function (args){
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: ['headerListSampleAdded','headerListSampleUpdated', 'gridviewImportSummary']
                  }
              }
            }
        }       
    }
    
}