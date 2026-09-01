{
//  validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
//    var errors = {};
//    //TODO: Insert your code for validation this form
//    if(data.name == undefined || data.name == ''){
//      errors.name = 'This field is requered!';
//    }
//    if(errors.name){
//      throw {
//          level: 1,
//          message: 'Check errors on the form!',
//          formerrors: {main: errors}
//      };
//    }
//    return {};
//  },
init : function (args) {
    
        //var options = new Stimulsoft.Viewer.StiViewerOptions();
        var viewer = new Stimulsoft.Viewer.StiViewer(null, "StiViewer", false);
        var report = new Stimulsoft.Report.StiReport();
        viewer.report = report;
        viewer.renderHtml('stiReportViewer');
},
    viewReport: function (args){
        
        var report = new Stimulsoft.Report.StiReport();
        console.log("args.data.ddlReport",args.data.ddlReport);
        const path = "/reports/" + args.data.ddlReport + ".json";
        console.log("path",path);
        report.loadFile(path);
        
        var url = '/report/getreportdata/' + args.data.ddlReport;
        Utils.loadingStart("Loading Report");
        Utils.getRequest(url).then(
            response => {
                console.log(response);
                var dataSet = new Stimulsoft.System.Data.DataSet("Demo");
                dataSet.readJson(response.data);
                
                report.dictionary.databases.clear();
                report.regData('Demo','Demo', dataSet);
                report.render();
                // View report in Viewer
                var options = new Stimulsoft.Viewer.StiViewerOptions();
                var viewer = new Stimulsoft.Viewer.StiViewer(null, "StiViewer", false);
                viewer.report = report;
                viewer.renderHtml('stiReportViewer');
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(()=>{       
                Utils.loadingStop();
        });
        
    }
}