UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='04A7DE41-735C-48DB-A303-C38007356800', [Folder]=N'metadata/forms', [Filename]=N'SwzRespAdminList.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:25.787', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-04-01 14:14:44.930', [Data]=N'[
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-float": "left",
    "style-width": "",
    "style-marginBottom": "1em",
    "children": [
      {
        "key": "header_1",
        "data-buildertype": "header",
        "content": "Respondent Content Management",
        "size": "huge",
        "textAlign": "left",
        "events": {}
      }
    ],
    "style-source": "width: 100%;\nfloat:left;"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "left",
    "style-marginRight": "20px",
    "children": [
      {
        "key": "btnCreate",
        "data-buildertype": "button",
        "content": "Create",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridCreate"
            ],
            "targets": [
              "grid_respadmin"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "btnDelete",
        "data-buildertype": "button",
        "content": "Delete",
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridDelete"
            ],
            "targets": [
              "grid_respadmin"
            ],
            "parameters": []
          }
        },
        "secondary": true
      }
    ],
    "style-marginBottom": "10px"
  },
  {
    "key": "grid_respadmin",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Type",
        "name": "Type",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "StartDate",
        "name": "Start Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime",
        "width": ""
      },
      {
        "key": "EndDate",
        "name": "End Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime",
        "width": ""
      },
      {
        "key": "Status",
        "name": "Status",
        "type": "checkbox",
        "sortable": true,
        "filterable": false,
        "resizable": false
      }
    ],
    "rowKey": "Id",
    "defaultSort": "NumberId ASC",
    "pagerType": "server",
    "editForm": "QNN_RESP_ADMIN",
    "autoHeight": false,
    "offSet": "285px",
    "events": {
      "onRowClick": {
        "active": true,
        "actions": [
          "gridEdit"
        ],
        "targets": [],
        "parameters": []
      },
      "onRowDblClick": {
        "parameters": [],
        "active": false,
        "actions": [],
        "targets": []
      }
    },
    "editFormShowType": "",
    "multiselect": true,
    "style-marginTop": "10px",
    "minHeight": "250px"
  }
]', [StructDivisionId]=NULL WHERE ([Id]='04A7DE41-735C-48DB-A303-C38007356800');
