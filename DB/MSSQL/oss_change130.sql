-- Will INSERT row(s) into dwMetadata for the following:
-- UserAccessMatrix-settings.json
-- UserAccessMatrix.json
-- UserAccessMatrix-code.js

-- Will UPDATE existing row(s) in dwMetadata for the following:
-- sidemenu-settings.json
-- sidemenu.json

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'a5429522-1a5d-4cfb-b902-73c4a0611b2d', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'UserAccessMatrix-settings.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-07-23 12:18:10.310', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-07-28 13:18:31.653', 
N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "lastUpdate": "2021-07-28T13:18:31.6547281+08:00",
  "isTemplate": false,
  "securityGroup": "Reports"
}');

INSERT INTO [dwMetadata] (
[Id], [StructDivisionId],
[Folder], [FileName], [IsDeleted],
[CreatedBy], [CreatedDate],
[DeletedBy], [DeletedDate],
[UpdatedBy], [UpdatedDate],
[Data]
) VALUES (
'8192e808-5af8-4759-acac-ccf130460ef0', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'UserAccessMatrix.json', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-07-23 12:18:10.250', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-07-28 13:18:31.607', 
N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "User Access Matrix",
    "size": "huge",
    "style-marginBottom": "20px",
    "textAlign": "left"
  },
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "container_2",
        "data-buildertype": "container",
        "children": [
          {
            "key": "Aspect",
            "data-buildertype": "dropdown",
            "label": "User Access Aspect",
            "fluid": false,
            "selection": true,
            "data-elements": [
              {
                "key": 1,
                "value": "Permission",
                "text": "Permission"
              },
              {
                "key": 2,
                "value": "Role",
                "text": "Role"
              }
            ],
            "placeholder": "Permission or Role",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "onChangeAspect",
                  "apply"
                ],
                "targets": [
                  "Download"
                ],
                "parameters": []
              }
            },
            "style-source": "",
            "style-marginBottom": "12px",
            "style-marginRight": "12px"
          },
          {
            "key": "Download",
            "data-buildertype": "button",
            "content": "Download",
            "primary": true,
            "floated": "",
            "other-visibleConition": "data.Aspect!== undefined && data.Aspect!= \"\" ? true : false",
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "onDownload"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-hidden": false,
            "style-marginLeft": "",
            "style-marginTop": "",
            "fluid": false,
            "style-source": "",
            "style-marginBottom": "12px",
            "style-marginRight": "12px"
          }
        ],
        "style-width": "100%",
        "style-source": "",
        "style-marginBottom": ""
      },
      {
        "key": "container_1",
        "data-buildertype": "container",
        "children": [
          {
            "key": "result",
            "data-buildertype": "staticcontent",
            "content": "",
            "isHtml": true,
            "isPre": true,
            "fetchData": true
          }
        ],
        "style-float": "",
        "style-marginTop": "40px"
      },
      {
        "key": "static_result",
        "data-buildertype": "staticcontent",
        "content": "",
        "isHtml": true,
        "isPre": false,
        "fetchData": false,
        "style-hidden": true,
        "events": {}
      }
    ],
    "style-marginBottom": "10px"
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
'1f5aea78-5462-4cd5-994e-87c233f0cdd6', 'f6e34bdf-b769-42dd-a2be-fee67faf9045', 
N'metadata/forms', N'UserAccessMatrix-code.js', 0, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-07-26 15:58:32.583', 
NULL, NULL, 
'b9d69ba9-282b-d3d2-8f23-efc2596a082c', '2021-07-28 13:09:58.857', 
N'{
    onChangeAspect: function(args){
        console.log(''onChangeAspeect'', args);
        
        if(args.data.Aspect == undefined || args.data.Aspect == "")
            return;

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
        
        _loadingStart();
        
        function getStyle(){
            var cssStyle = ''<style>'';
                cssStyle += ''table.user-access-matrix{ width: 100%; text-align: center; border-collapse: inherit; background-color: rgba(230, 247, 255,0.1); border-spacing: 0; margin-bottom: 20px}''
                cssStyle += ''table.user-access-matrix tbody{ border-color: #cccccc; }'';
                cssStyle += ''table.user-access-matrix tr td{ padding: 8px 4px; }'';
                cssStyle += ''table.user-access-matrix tr td.bold{font-weight: bold;}'';
                cssStyle += ''table.user-access-matrix tr td .center{display: flex; justify-content: center; flex-direction: column;}'';
                cssStyle += ''table.report-info tr td { padding: 0px 4px;}'';
                cssStyle += ''div.user-access-matrix { margin-bottom:12px;}'';
                cssStyle += ''div.user-access-matrix .report-header {margin-bottom:12px;}'';
                cssStyle += ''div.user-access-matrix .report-footer {text-align: right;}</style>'';
                return cssStyle;
        }
        
        function getReportHeader(isBegin, printDate, recordStart, totalRecords, pageCount, pageMax, recordPerPage ){
            console.log(''getReportHeader'',isBegin);
            var reportHeader = '''';
            if(isBegin){
                reportHeader += getStyle();
                reportHeader += ''<div class="user-access-matrix">'';
            }else{
                reportHeader += ''<div class="user-access-matrix" style="page-break-before: always;">''
            }
            
            var maxRecordCount = pageCount * recordPerPage;
            if(pageCount * recordPerPage > totalRecords){
                maxRecordCount -= recordPerPage - (totalRecords % recordPerPage);
            }
            
            reportHeader += ''<div class="report-header"><table class="report-info">'';
            reportHeader += ''<tr><td>User Access Matrix</td><td>:</td><td>By '' + args.data.Aspect + ''</td></tr>'';
            reportHeader += ''<tr><td>Date Generated</td><td>:</td><td>'' + printDate + ''</td></tr>'';
            reportHeader += ''<tr><td>Record(s)</td><td>:</td><td>'' + recordStart + '' - '' + maxRecordCount + '' of '' + totalRecords + ''</td></tr>'';
            reportHeader += ''<tr><td>Page(s)</td><td> : </td><td>'' + pageCount + '' of '' + pageMax + ''</td></tr></table></div>'';
            
            return reportHeader;
        }
        
        function getPermissionTableHeader(permissionList, permissionSet){
            var permissionGroupSet = new Set();
            var tableHeader = ''<tr><td class="bold" rowspan="3">User</td><td class="bold" '' + (permissionList.length > 1 ? (''colspan="'' + permissionList.length + ''"'') : '''') + ''>''+args.data.Aspect+''</td></tr><tr>'';
            for(var key in permissionList){
                var setKey = permissionList[key].groupCode;
                if(!permissionGroupSet.has(setKey)){
                    permissionGroupSet.add(setKey);
                    if(permissionSet[setKey] !== undefined && permissionSet[setKey].length > 1){
                        tableHeader += ''<td class="bold" colspan="''+ permissionSet[setKey].length+ ''">'' + permissionList[key].groupName + ''</td>''  
                    }else{
                        tableHeader += ''<td class="bold">'' + permissionList[key].groupName + ''</td>''   
                    } 
                }
            }
            tableHeader += ''</tr><tr>'';
            permissionGroupSet.clear();
            for(var key in permissionList){
                var setKey = permissionList[key].groupCode;
                if(!permissionGroupSet.has(setKey)){
                    permissionGroupSet.add(setKey);
                    if(permissionSet[setKey] !== undefined && permissionSet[setKey].length > 0){
                        for(var index in permissionSet[setKey]){
                            tableHeader += ''<td>'' + permissionSet[setKey][index].name + ''</td>''   ;
                        }
                    }
                }
            }
            tableHeader += ''</tr>'';
            return tableHeader;
        }
        
        function getPermissionTableRow(permissionList, userPermissionList, user, xMark){
            var rowContent = '''';
            for(var permissionKey in permissionList){
                var permissionCode = permissionList[permissionKey].code + permissionList[permissionKey].groupCode;
                var userPermission = userPermissionList.filter(function(v, i) {
                  return v.userId == user.id && v.permissionCode + v.permissionGroupCode == permissionCode;
                })
                if(userPermission !== undefined && userPermission.length > 0){
                    rowContent += ''<td> ''+ xMark + '' </td>'';    
                }else{
                    rowContent += ''<td></td>'';
                }
                
            }
            return rowContent;
        }
        
        function getRoleTableHeader(roleList){
            console.log(''getRoleTableHeader'');
            var roleSet = new Set();
            var tableHeader = ''<tr><td class="bold" rowspan="2">User</td><td class="bold" '' + (roleList.length > 1 ? (''colspan="'' + roleList.length + ''"'') : '''') + ''">'' + args.data.Aspect +''</td></tr><tr>'';
            for(var key in roleList){
                var setKey = roleList[key].id;
                if(!roleSet.has(setKey)){
                    roleSet.add(setKey);
                    tableHeader += ''<td class="bold">'' + roleList[key].name + ''</td>''   
                }
            }
            tableHeader += ''</tr>'';
            return tableHeader;
        }
        
        function getRoleTableRow(roleList, userRoleList, user, xMark){
            console.log(''getRoleTableRow'');
            var rowContent = '''';
            
            for(var roleKey in roleList){
                var roleId = roleList[roleKey].id;
                var userRole = userRoleList.filter(function(v, i) {
                  return v.userId == user.id && v.roleId == roleId;
                })
                if(userRole !== undefined && userRole.length > 0){
                    rowContent += ''<td> ''+xMark+'' </td>'';    
                }else{
                    rowContent += ''<td></td>'';
                }
                
            }
            return rowContent;
        }
        
        var url = ''/report/useraccessmatrix'';
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post''
            })
            .then(response => response.json())
            .then(response => {
                _loadingStop();
                console.log(''useraccessmatrix response'',response);
                if (response.success) {
                    var userList = response.userList;
                    
                    var tableStart =  ''<table class="user-access-matrix" border="1" bordercolor="#808080" cellpadding="15"><tbody>'';
                    var tableEnd = ''</tbody></table>'';
                    var tableHeader = '''';
                    var tableContent = '''';
                    var xMarkBold = ''&#10006;'';
                    var xMark = ''&#10005;'';
                    var rotate = '' style="transform: rotate(270deg);" ''
                    //595 pixels x 842 pixels (screen resolution)
                    var reportHeader = '''';
                    var reportHtml = '''';
                    var intRowCount = 1;
                    var intPageCount = 1;
                    var recordPerPage = 10;
                    var totalPageCount = Math.trunc(userList.length / 10) + (userList.length % 10 > 0 ? 1 : 0);
                    
                    var dateGenerated = new Date(response.generateDate);
                    var printDate = dateGenerated.getDate() + '' '' + new Intl.DateTimeFormat(undefined, { month: ''short'' }).format(dateGenerated) + '' '' + dateGenerated.getFullYear() + '' '' + dateGenerated.getHours() + '':'' + dateGenerated.getMinutes() + '':'' + dateGenerated.getSeconds();
                    
                    if(args.data.Aspect === ''Permission''){
                        var permissionList = response.permissionList;
                        var permissionSet = response.permissionSet;
                        
                        if(permissionList.length > 0){
                            tableHeader += getPermissionTableHeader(permissionList, permissionSet);
                            if(userList.length > 0)
                            {  
                                for(var key in userList){
                                    var rowContent = ''<tr>'' + ''<td>'' + userList[key].name + ''</td>'';
                                    rowContent += getPermissionTableRow(permissionList, response.userPermissionList, userList[key], xMarkBold);
                                    rowContent += ''</tr>'';
                                    
                                    if(intRowCount == 1){
                                        reportHtml += getReportHeader(reportHtml === '''', printDate, (parseInt(key) + 1), userList.length, intPageCount, totalPageCount, recordPerPage) + tableStart + tableHeader;
                                    }
                                    
                                    reportHtml += rowContent;
                                    
                                    if(intRowCount == recordPerPage){
                                        reportHtml+=  tableEnd +''</div>'';
                                        intRowCount = 1;
                                        intPageCount += 1;
                                    }else{
                                        intRowCount += 1;    
                                    }
                                }
                                reportHtml+=  tableEnd +''</div>'';
                            }else{
                                tableContent = ''<tr><td colspan="'' + permission.length + 1 + ''"><h4>No record found.</h4></td></tr>'';
                            }
                        }else{
                            alertify.error(''No permission record is found, please check security setting.'');
                        }
                    }else{
                        var roleList = response.roleList;
                        if(roleList.length > 0){
                            tableHeader = getRoleTableHeader(roleList);
                            if(userList.length > 0)
                            {
                                for(var key in userList){
                                    var rowContent = ''<tr>'' + ''<td>'' + userList[key].name + ''</td>'';
                                    rowContent += getRoleTableRow(roleList, response.userRoleList, userList[key], xMarkBold);
                                    rowContent += ''</tr>'';
                                    
                                    if(intRowCount == 1){
                                        reportHtml += getReportHeader(reportHtml === '''', printDate, (parseInt(key) + 1), userList.length, intPageCount, totalPageCount, recordPerPage) + tableStart + tableHeader;
                                    }
                                    
                                    reportHtml += rowContent;
                                    
                                    if(intRowCount == recordPerPage){
                                        reportHtml+=  tableEnd +''</div>'';
                                        intRowCount = 1;
                                        intPageCount += 1;
                                    }else{
                                        intRowCount += 1;    
                                    }
                                }
                                reportHtml+=  tableEnd +''</div>'';
                            }else{
                               tableContent = ''<tr><td colspan="'' + roleList.length + 1 + ''"><h4>No record found.</h4></td></tr>'';
                            }
                        }else{
                            alertify.error(''No role record is found, please check security setting.'');
                        }
                        
                    }

                    var html = getStyle()+tableStart + tableHeader + tableContent + tableEnd;
                    var htmlOverall = ''<div class="field"><label>Result</label></div><div>'' + reportHtml + ''</div>''
           
                    CloverApp.API.setDataField("result", htmlOverall);
                    CloverApp.API.setDataField("static_result", reportHtml === '''' ? ''<h2>User '' + args.data.Aspect + '' Access Matrix</h2><div>'' + html + ''</div>'' : reportHtml);
                    
                } else {
                    alertify.error(response.message);
                }
            })
            .catch(error => {
                _loadingStop();
                alertify.error(error.message);;
            });
    },
    
    onDownload: function(args){
        
        if(args.data.static_result == undefined || args.data.static_result == ""){
            alertify.error(''Nothing to download.'');
            return;
        }
            
        if(args.data.Aspect == undefined || args.data.Aspect == "")
            return;

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
        
        _loadingStart();
        
        var formData = new FormData();
        formData.append(''aspect'', args.data.Aspect);   
        formData.append(''content'', args.data.static_result);   
        console.log(''onChangeAspeect aspect'', args.data.static_result);
        console.log(''onChangeAspeect content'', args.data.static_result);
        
        var url = ''/report/useraccessmatrix/download'';
        
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.blob())
            .then(blob => {
                _loadingStop();
                var url = window.URL.createObjectURL(blob);
                var a = document.createElement(''a'');
                a.href = url;
                a.download = ''User '' + args.data.Aspect + '' Access Matrix.pdf'';
                document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
                a.click();    
                a.remove();  //afterwards we remove the element again   
                
                console.log(''download success'');
            })
            .catch(error => {
                _loadingStop();
                alertify.error(''useraccessmatrix:'' + error.message);;
            });

    }
}');

UPDATE [dwMetadata] SET
[Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.490', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-28 13:39:46.867', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2021-07-28T13:39:46.8606753+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-28 13:39:46.737', 
[Data]=N'[
  {
    "key": "sidemenu",
    "data-buildertype": "menu",
    "items": [
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')",
        "children": [
          {
            "title": "Questionnaire",
            "target": "",
            "distype": "dropdownheader",
            "visibleCondition": ""
          },
          {
            "title": "Form Designer",
            "target": "/surveydesigner",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')",
            "icon": ""
          },
          {
            "target": "/form/SwzQnnList",
            "title": "Form Properties",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')",
            "icon": ""
          }
        ],
        "icon": "file alternate outline",
        "distype": "dropdown"
      },
      {
        "target": "",
        "title": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "title": "<b>List</b>",
            "distype": "dropdownheader"
          },
          {
            "target": "/form/SwzListList",
            "title": "Sample List",
            "visibleCondition": "",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track List",
            "visibleCondition": "",
            "icon": ""
          }
        ],
        "distype": "dropdown",
        "icon": "list alternate outline"
      },
      {
        "target": "",
        "title": "",
        "children": [
          {
            "title": "Deployment",
            "target": "/form/SwzDplyList",
            "visibleCondition": ""
          }
        ],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "icon": "send",
        "distype": "dropdown"
      },
      {
        "title": "",
        "target": "",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''DataEditor'')",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor"
          }
        ],
        "distype": "dropdown"
      },
      {
        "distype": "dropdown",
        "icon": "database",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "children": [
          {
            "distype": "dropdownheader",
            "title": "<b>Dashboard and Reports</b>"
          },
          {
            "target": "/form/ChoiceCount",
            "title": "Frequency Count Report",
            "visibleCondition": ""
          },
          {
            "target": "/form/ResponseReport",
            "title": "Response Report",
            "visibleCondition": ""
          },
          {
            "target": "/form/DashboardOverall",
            "title": "Overall Response Dashboard",
            "visibleCondition": ""
          },
          {
            "target": "/form/DashboardSectorSegmentResponse",
            "title": "Sector/Segment Response Dashboard",
            "visibleCondition": ""
          },
          {
            "target": "/form/DashboardStatus",
            "title": "Status Response Dashboard",
            "visibleCondition": "",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": ""
          },
          {
            "target": "/form/UserAccessMatrix",
            "title": "User Access Matrix"
          }
        ]
      },
      {
        "target": "",
        "children": [
          {
            "target": "NEW /help",
            "title": "Help..."
          },
          {
            "title": "Category",
            "target": "/form/SwzCategoryList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/swzsamplelist",
            "title": "Samples",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "title": "Data Validation Rules",
            "target": "/form/SwzRuleList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/useradmin",
            "title": "Security",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')",
            "icon": ""
          },
          {
            "title": "Respondent Content Management",
            "target": "/form/SwzRespAdminList",
            "children": [],
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/swzHelpList",
            "title": "Online Help Content",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/organizations",
            "title": "Organizations",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": "",
            "children": []
          },
          {
            "target": "/form/SwzGlobalMailer",
            "title": "Global Mailer",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "distype": "dropdown",
        "title": "",
        "icon": "bars",
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'')"
      }
    ],
    "vertical": true,
    "events": {
      "onItemClick": {
        "active": true,
        "actions": [
          "onItemClick"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "link": true,
    "fluid": false,
    "tabular": false,
    "secondary": false,
    "pointing": false,
    "other-visibleConition": "",
    "icon": false,
    "compact": false,
    "style-width": ""
  }
]' WHERE [Id]='55636648-e5a4-4002-9f59-d597fd167c04';

