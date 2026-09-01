-- removed_SurveyResponseReport_20240318.sql
-- Feeling cautious, may delete later 
-- SurveyResponseReport (not to be confused with ResponseReport) seems to be an unused lava flow
-- so is being removed by change456.sql, but if I'm wrong and we need it back soon then this script can
-- un-remove it a little more conveniently than trawling git history.

-- Will INSERT row(s) into dwMetadata for the following:
-- SurveyResponseReport.json
-- SurveyResponseReport-settings.json
-- SurveyResponseReport-code.js

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'94096565-cc22-4149-8bd6-5bc4672003ea', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SurveyResponseReport.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2020-01-16 10:48:50.983', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2020-01-16 18:51:59.940', 
N'[
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "hdrIMDASurveyResp",
        "data-buildertype": "header",
        "content": "IMDA Survey Response Report for Deployment",
        "size": "large",
        "subheader": "",
        "textAlign": "left",
        "style-marginBottom": "20px"
      },
      {
        "key": "form_2",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlDeployment",
            "data-buildertype": "dictionary",
            "label": "Deployment",
            "fluid": true,
            "selection": true,
            "dataModel": "QNN_DPLY",
            "columns": "Name ASC",
            "paging": false,
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "getCounts"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "clearable": true
          }
        ],
        "style-marginTop": "20px",
        "style-marginBottom": "20px"
      },
      {
        "key": "form_3",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlSurveyType",
            "data-buildertype": "dropdown",
            "label": "Survey Type",
            "fluid": true,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "MP",
                "text": "MP"
              },
              {
                "key": 2,
                "value": "MI",
                "text": "MI"
              },
              {
                "key": 3,
                "value": "II",
                "text": "II"
              },
              {
                "value": "IU",
                "text": "IU"
              }
            ]
          }
        ],
        "style-marginTop": "20px",
        "style-marginBottom": "20px"
      },
      {
        "key": "form_4",
        "data-buildertype": "form",
        "children": [
          {
            "key": "btnExport",
            "data-buildertype": "button",
            "content": "Export",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "onExport"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "primary": true
          }
        ],
        "style-marginTop": "20px",
        "style-marginBottom": "20px"
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
'727337df-25e9-4014-b608-e2ff98040857', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SurveyResponseReport-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2020-01-16 10:48:51.413', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2020-01-16 18:52:00.183', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2020-01-16T18:52:00.1831995+08:00",
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
'0694e109-8d21-462a-bb2c-f5af6735ea95', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'SurveyResponseReport-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2020-01-16 10:49:42.977', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2024-03-17 00:09:51.987', 
N'{
    
   getCounts: function(args){
        
        //console.log(args);
        if(!args.data.dplyId){ 
            CloverApp.API.setDataField("dplychoiceqnns", null);
            return;
        }
        //console.log("args.data.dplyId", args.data.dplyId);
        CloverApp.API.setDataField("dplychoiceqnns", args.data.dplyId);
        
    },


  onExport: function (args){
   //CloverApp.API.setDataField(''deployment'', ''123'');
   
  var _loadingStart = function() {
            $(''body'').loadingModal({
                text: ''Loading...'',
                animation: ''foldingCube'',
                backgroundColor: ''#1262E2''
            });
        };
   
          var _loadingStop = function() {
            $(''body'').loadingModal(''destroy'');
        };
   
   var dplyId = args.data.ddlDeployment;
   var surveyType = args.data.ddlSurveyType;
  
   
   var week = args.data.ddlWeek;
   
   console.log(dplyId);
   console.log(surveyType);
   console.log(week);
   
    var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''flag'',surveyType);
     var url = ''/report/imdaresponsereport'';
   _loadingStart();
     fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                
                _loadingStop();
                if (response.success) {
                    //debugger;
                    
                    
                    
                  var JSON1 = response.UpperTableData;
                  var JSON2 = response.LowerTableData;
                  console.log(JSON1);
                  var objArray = JSON1.concat(JSON2);
                  
                  
                 // var objArray = response.LowerTableData;
                  console.log(objArray);
                  
                  
           
       
        var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                      var str = '' '';
                      
                      for (var i = 0; i< array.length; i++)
                      {
                          var line = '' '';
                          
                          for (var index in array[i])
                          {
                              line += '' ''+ array[i][index] + '','';
                              
                          }
                          
                          line.slice(0,line.length-1);
                          str += line + ''\r\n'';
                      }
                      
                      //window.open("data:text/csv;charset=utf-8," + escape(str))
   
                  
                 // debugger;
                  
                  var today = new Date();
                var dd = String(today.getDate()).padStart(2, ''0'');
                var mm = String(today.getMonth() + 1).padStart(2, ''0''); 
                var yyyy = today.getFullYear();

                    today = mm  + dd + yyyy;
                 var filename = "IMDAResponseReport_"+surveyType+"_"+today;
                 var downloadLink = document.createElement("a");
                 var blob = new Blob(["\ufeff", str]);
                 var url = URL.createObjectURL(blob);
                    downloadLink.href = url;
                    downloadLink.download = filename+".csv"; 
                    document.body.appendChild(downloadLink);
                    downloadLink.click();
                    document.body.removeChild(downloadLink);
            
        
                  
                 
               } else {
                    alertify.error( Utils.encodeHTML(response.message) );
                }

            })
           .catch(error => {
               alertify.error( Utils.encodeHTML(error.message) );
            });
 
  },
  
  
  
  showData: function(args){
      console.log("show data", args);
  }
  
}

');

