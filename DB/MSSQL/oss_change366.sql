-- Will INSERT row(s) into dwMetadata for the following:
-- SampleStimulsoftReport.json
-- SampleStimulsoftReport-code.js
-- SampleStimulsoftReportDesigner.json
-- SampleStimulsoftReportDesigner-code.js
-- SampleStimulsoftReportDesigner-settings.json
-- SampleStimulsoftReport-settings.json

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'09c0a106-e222-4e61-a6aa-80dd8e1f6840', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SampleStimulsoftReport.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-10-19 14:47:51.617', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-10-19 15:01:29.030', 
N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Stimulsoft Sample Report",
    "size": "medium"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "ddlReport",
        "data-buildertype": "dropdown",
        "label": "Report Options",
        "fluid": true,
        "selection": true,
        "data-elements": [
          {
            "key": 1,
            "value": "ChartStyles",
            "text": "Chart Styles"
          },
          {
            "key": 2,
            "value": "SimpleList",
            "text": "Simple List"
          },
          {
            "key": 3,
            "value": "MultiColumnList",
            "text": "Multi Column List"
          }
        ],
        "placeholder": "Select a report",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "viewReport"
            ],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "staticcontent_1",
        "data-buildertype": "staticcontent",
        "content": "<div id=''stiReportViewer''></div>",
        "isHtml": true
      }
    ]
  }
]');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'bb7baf67-5196-47d3-926b-f58d1ee9c9d7', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SampleStimulsoftReport-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-10-19 14:50:38.337', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-03-07 15:52:42.447', 
N'{
//  validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
//    var errors = {};
//    //TODO: Insert your code for validation this form
//    if(data.name == undefined || data.name == ''''){
//      errors.name = ''This field is requered!'';
//    }
//    if(errors.name){
//      throw {
//          level: 1,
//          message: ''Check errors on the form!'',
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
        viewer.renderHtml(''stiReportViewer'');
},
    viewReport: function (args){
        
        var report = new Stimulsoft.Report.StiReport();
        console.log("args.data.ddlReport",args.data.ddlReport);
        const path = "/reports/" + args.data.ddlReport + ".json";
        console.log("path",path);
        report.loadFile(path);
        
        var url = ''/report/getreportdata/'' + args.data.ddlReport;
        Utils.loadingStart("Loading Report");
        Utils.getRequest(url).then(
            response => {
                console.log(response);
                var dataSet = new Stimulsoft.System.Data.DataSet("Demo");
                dataSet.readJson(response.data);
                
                report.dictionary.databases.clear();
                report.regData(''Demo'',''Demo'', dataSet);
                report.render();
                // View report in Viewer
                var options = new Stimulsoft.Viewer.StiViewerOptions();
                var viewer = new Stimulsoft.Viewer.StiViewer(null, "StiViewer", false);
                viewer.report = report;
                viewer.renderHtml(''stiReportViewer'');
            }, reason => {
                console.error(reason);
                alertify.error(reason);
            }
        ).finally(()=>{       
                Utils.loadingStop();
        });
        
    }
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'943b9ef6-b422-4c15-ae2e-ed46ac364848', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SampleStimulsoftReportDesigner.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-10-20 14:48:53.670', 
NULL, NULL, 
NULL, NULL, 
N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Stimulsoft Report Designer",
    "size": "medium"
  },
  {
    "key": "staticcontent_1",
    "data-buildertype": "staticcontent",
    "content": "<div id=''stireportdesigner''></div>",
    "isHtml": true
  }
]');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'9a2e5714-e79e-4a19-abfb-8b2207d44e48', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SampleStimulsoftReportDesigner-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-10-20 14:49:55.750', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2022-03-07 16:17:38.760', 
N'{
//  validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
//    var errors = {};
//    //TODO: Insert your code for validation this form
//    if(data.name == undefined || data.name == ''''){
//      errors.name = ''This field is requered!'';
//    }
//    if(errors.name){
//      throw {
//          level: 1,
//          message: ''Check errors on the form!'',
//          formerrors: {main: errors}
//      };
//    }
//    return {};
//  }
    init: function(args){
        console.log(''test'');
        //StiOptions.WebServer.url = "http://localhost:48800";
        var designer = new Stimulsoft.Designer.StiDesigner(null, "StiDesigner", false);
        console.log(''designer'', designer);
        var report = new Stimulsoft.Report.StiReport();
        designer.report = report;
        designer.renderHtml(''stireportdesigner'');
    }
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'8a650b8a-3563-4244-a21a-82c55205a1aa', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SampleStimulsoftReportDesigner-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-10-20 14:48:53.830', 
NULL, NULL, 
NULL, NULL, 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-10-20T14:48:53.8018202+08:00",
  "isTemplate": false
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'b0d7c8cc-9728-4c5a-91c4-56806c3e2198', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SampleStimulsoftReport-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-10-19 14:47:51.877', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-10-19 15:01:29.117', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-10-19T15:01:29.1175511+08:00",
  "isTemplate": false
}');

