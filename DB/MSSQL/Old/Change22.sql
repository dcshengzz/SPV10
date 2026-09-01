CREATE VIEW [dbo].[vSP_DeploymentRespCompleteCount] AS 
select d.Id as DplyId, count(*) as RespCount from QNN_Resp r
inner join QNN_DPLY d on d.Id = r.DplyId
where r.DateComplete <> ''
group by d.Id

GO

CREATE VIEW [dbo].[vSP_DeploymentWithRespCompleteCount] AS 
select d.Id, d.Status, ISNULL(drc.RespCount, 0 ) as RespCount, 
ISNULL(sc.SampleCount,0) as SampleCount,
d.StructDivisionId from QNN_DPLY d
left join vSP_DeploymentRespCompleteCount drc on d.Id = drc.DplyId
left join vSP_DeploymentSampleCount sc on d.Id = sc.DplyId
where d.Status=1
GO

CREATE PROCEDURE [dbo].[spSP_GetDeploymentStatistics]
		@ChildrenStructDivisionIds NVARCHAR(MAX)

	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @NotCompleted  AS INT = (select count(*) from vSP_DeploymentWithRespCompleteCount where RespCount < SampleCount and StructDivisionId IN( SELECT Item FROM dbo.splitIds(@ChildrenStructDivisionIds, ',')));
		DECLARE @Completed  AS INT = (select count(*) from vSP_DeploymentWithRespCompleteCount where RespCount = SampleCount and StructDivisionId IN( SELECT Item FROM dbo.splitIds(@ChildrenStructDivisionIds, ',')));
		SELECT @Completed AS Completed, @NotCompleted AS NotCompleted

	END
	


GO

UPDATE TOP(1) [surveyplus.net.1609].[dbo].[dwMetadata] SET [Id]='55831859-15D6-47CC-ACCD-FF632CDD1845', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeploymentList.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.683', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-24 17:59:14.007', [Data]=N'[
  {
    "key": "headerDataEditorList",
    "data-buildertype": "header",
    "content": "Data Editor",
    "size": "huge",
    "subheader": "View a list of deployments under you",
    "style-marginTop": "10px"
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
            "key": "editorBarChart",
            "data-buildertype": "doughnutchart",
            "chartType": "doughnut",
            "datasetLabel": "",
            "legendPosition": "bottom",
            "responsive": true,
            "style-width": "500px",
            "style-source": "margin: auto;"
          },
          {
            "key": "refreshChart",
            "data-buildertype": "button",
            "content": "Refresh",
            "events": {
              "onClick": {
                "active": false,
                "actions": [
                  "updateBarChart"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "primary": false,
            "style-width": "100%",
            "style-source": "",
            "secondary": true,
            "compact": false,
            "style-hidden": true,
            "style-marginTop": "5px",
            "style-marginBottom": "5px"
          }
        ],
        "style-width": "50%",
        "style-marginTop": "1em"
      },
      {
        "key": "dictionary_1",
        "data-buildertype": "dictionary",
        "label": "Category",
        "fluid": true,
        "selection": true,
        "dataModel": "QNN_CATEGORY",
        "columns": "Name ASC",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "setFilter",
              "applyFilter"
            ],
            "targets": [
              "grid"
            ],
            "parameters": [
              {
                "name": "column",
                "value": "*"
              }
            ]
          }
        },
        "style-width": "50%",
        "search": true,
        "clearable": true,
        "onChangeTimeout": "200",
        "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
      },
      {
        "key": "input_1",
        "data-buildertype": "input",
        "label": "",
        "fluid": true,
        "onChangeTimeout": "200",
        "events": {
          "onChange": {
            "active": true,
            "actions": [
              "setFilter",
              "applyFilter"
            ],
            "targets": [
              "grid"
            ],
            "parameters": [
              {
                "name": "column",
                "value": "*"
              }
            ]
          }
        },
        "labelPosition": "",
        "inverted": false,
        "transparent": false,
        "style-width": "50%",
        "placeholder": "Search.."
      }
    ],
    "style-source": "",
    "style-marginBottom": "30px"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "custom",
        "width": ""
      },
      {
        "key": "StatusText",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "Title",
        "name": "Questionnaire",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "QnnType",
        "name": "Type",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "Category",
        "name": "Category",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "",
        "width": ""
      },
      {
        "key": "Responses",
        "name": "Responses",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": ""
      },
      {
        "key": "DateEnd",
        "name": "Date End",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "type": "datetime",
        "width": ""
      }
    ],
    "editForm": "QNN_DPLY_SAMPLE_INFO",
    "multiselect": false,
    "pagerType": "",
    "defaultSort": "CreatedDate ASC",
    "autoHeight": false,
    "offSet": "90vh",
    "rowKey": "Id",
    "events": {
      "onRowClick": {
        "active": false,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onSelectionChanged": {
        "active": false,
        "actions": [
          "gridRefresh"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "style-customcss": "",
    "style-source": "",
    "pageSize": "20",
    "minHeight": "350",
    "rowHeight": "50"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='55831859-15D6-47CC-ACCD-FF632CDD1845');

GO

UPDATE TOP(1) [surveyplus.net.1609].[dbo].[dwMetadata] SET [Id]='774BF1E8-60A0-44F9-B942-478CB9ECB120', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeploymentList-code.js', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.560', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-24 17:55:22.230', [Data]=N'{
    viewArgs: function(args){
        //console.log(''View Args'', args);    
    },
    
   /* updateBarChart: function (args){
        
        console.log("Update Bar Chart!");
        var count = args.component.refs.grid.state.rowsCount;
        var counter = 0;
        var gridData = args.component.refs.grid.state.items;
        
         for(var i=0; i<gridData.length;i++){
        if(gridData[i].RespCount == gridData[i].SampleCount){
            counter++;
        }
    }
    
    var editorLabel = [''Total Deployment'',''Completed Deployment''];
    var barData = [count,counter];
    
    console.log("count is", count);
     var value = {
                        labels: editorLabel,
                        datasets: [
                          {
                            data: barData,
                            backgroundColor:["#1362E2","#ff2052"],
                            label: "Count",
                          }
                        ]
                    };
        CloverApp.API.setDataField("editorBarChart", value);
        
        },*/
    
  init: function (args){
      
    //console.log(''Data Editor'', args);  
    var gridModelRewriter = function (model) {
        if(Array.isArray(model.columns) && model.columns.length > 2){
            model.columns[0].customFormatter = function(p){ 
                var url = "/form/DataEditorDeployment/" + p.row.DplyId;
                //return CloverApp.API.createElement("a", { href: url}, p.value);  
                //return "<a href=''www.google.com''>" +p.value+ "</a>";
                return CloverApp.API.createElement("span", { onClick: () =>  {
                                CloverApp.API.redirect(''form'', ''DataEditorDeployment'', p.row.Id)
                            }, className: "link-style" }, p.value);                
            };
        }
        return model; 
    };
    CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    
    var count = args.component.refs.grid.state.rowsCount;
    var counter = 0;
    var gridData = args.component.refs.grid.state.items;
    
    for(var i=0; i<gridData.length;i++){
        if(gridData[i].RespCount == gridData[i].SampleCount){
            counter++;
        }
    }
    
     
    var url = ''/dataedit/getchartdata/DataEditorDeploymentList'';

    fetch(url,
        {
            credentials: ''same-origin'',
            contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
            method: ''get''
        })
        .then(response => response.json())
        .then(response => {
            if (response.success) {
                console.log("response", response);
                
                var editorLabel = [''Not Completed Deployment'',''Completed Deployment''];
                var barData = [response.item.NotCompleted,response.item.Completed];
                
                var value = {
                                    labels: editorLabel,
                                    datasets: [
                                      {
                                        data: barData,
                                        backgroundColor:["#1262E2","#00ff00"],
                                        label: "Count",
                                      }
                                    ]
                                };
                CloverApp.API.setDataField("editorBarChart", value);               

            } else {
                alertify.error(response.message);
            }

        })
        .catch(error => {
            alertify.error(error.message);;
        });  
    


     
    
  }
}
', [StructDivisionId]=NULL WHERE ([Id]='774BF1E8-60A0-44F9-B942-478CB9ECB120');

GO

UPDATE TOP(1) [surveyplus.net.1609].[dbo].[dwMetadata] SET [Id]='736DB1D2-47C6-4DAF-B3CC-4D49A5BEA55F', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeploymentList-settings.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.617', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-24 17:59:14.140', [Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "DataEditorDeploymentList",
  "lastUpdate": "2019-09-24T17:59:14.1314127+08:00",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [],
  "dataColl": [
    {
      "id": "c4514110-9480-5f81-da9b-554de3d0ee8a",
      "entityId": "6a831ca7-cff1-45bd-9125-ff8aa539e5dc",
      "filter": "FilterAsyncFieldsAndStruct",
      "parameter": "{userId: \"@CurrentUserId\"}",
      "control": "grid",
      "dataMap": [
        {
          "id": "26bedfb2-eb2a-ad98-369d-175f1904ae40",
          "attributeId": "07c8cf9b-89d5-4825-bb30-71e087e8b371",
          "control": "Category",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "aeb7e8bb-e202-83e6-eb0e-fd86128d9e25",
          "attributeId": "12882549-c63b-4bb9-8411-34003b2228fc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "56773340-b9ac-8094-3608-7bd20339bb8c",
          "attributeId": "b3f92a74-318b-46f8-964c-e99c6b3ce1a6",
          "control": "DateEnd",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b8a26c93-c68a-6039-40ef-a7b4df36e9ee",
          "attributeId": "662161e7-61ac-4caa-b5bf-a94e36f99b05",
          "control": "Name",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2f3aef91-5da9-5cf0-b777-00773788fb32",
          "attributeId": "117475f3-1979-4047-922b-751e725aa220",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6099ee9f-5f28-00e6-662c-7a06c3319740",
          "attributeId": "a5175ebf-3842-483d-99cc-23479501c082",
          "control": "Responses",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b97b27d0-a407-d9da-5786-6bc2b718f678",
          "attributeId": "e4488721-c14a-4001-9f86-95547b4fef49",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ddb6e78e-50df-49b5-4fe9-ce95827f2a2e",
          "attributeId": "14b1108f-a4cf-4154-b5af-9e943bc7825a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "14b8feb4-a967-27cc-7009-dd7262910160",
          "attributeId": "9a6b8e15-a962-4512-84fc-906fa79f0ba6",
          "control": "StatusText",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ea662025-1336-29ff-bcde-32326d1e691a",
          "attributeId": "be433204-7b5e-4d48-acd2-bab9ceba06b6",
          "control": "Title",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "074f3cb1-dbbf-51f3-2071-d9f313936f53",
          "attributeId": "560b916d-7b92-43cc-87a2-25eebe01b04e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8876b77d-a26e-e81f-3e6e-99af1a68b2e3",
          "attributeId": "f75b7c08-2bbf-453e-acff-46dfb6d90ca7",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "8a856b69-f546-70a2-504d-fef8614ca005",
          "attributeId": "4def3ea4-668b-4dfd-9c7f-871eb1e461ff",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2f18e44c-2f48-8875-bd41-f97f3976f5ce",
          "attributeId": "ce8b4c4e-43fc-42af-acdf-d1dc9530092b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "793dffa5-906c-7261-b5f5-11656313e10f",
          "attributeId": "3698003c-ad9d-4014-a4d5-dfe14418e377",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "210caea8-d5ab-366c-bab2-08ec967829ff",
          "attributeId": "7b42a4f1-8da8-4e10-aee0-8db424b6d16c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f257d4b5-4127-42ac-c6f2-4e59832b4ebb",
          "attributeId": "b57fb1aa-5502-418c-94cc-0365fbd5cbb0",
          "control": "",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "60f68dfb-d1f3-9c2e-8959-924025772f63",
          "attributeId": "bb884c00-d4b4-4d8b-83c5-a2c424a220db",
          "control": "QnnType",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ce5ea0e4-e19c-a816-ab23-e2d3fb821c09",
          "attributeId": "77adabcb-6e75-4100-b589-873557998506",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "DataEditor"
}', [StructDivisionId]=NULL WHERE ([Id]='736DB1D2-47C6-4DAF-B3CC-4D49A5BEA55F');
GO