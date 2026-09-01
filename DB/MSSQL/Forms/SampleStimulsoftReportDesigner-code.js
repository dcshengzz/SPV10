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
//  }
    init: function(args){
        console.log('test');
        //StiOptions.WebServer.url = "http://localhost:48800";
        var designer = new Stimulsoft.Designer.StiDesigner(null, "StiDesigner", false);
        console.log('designer', designer);
        var report = new Stimulsoft.Report.StiReport();
        designer.report = report;
        designer.renderHtml('stireportdesigner');
    }
}