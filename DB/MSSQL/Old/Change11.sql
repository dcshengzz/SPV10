UPDATE TOP(1) [surveyplus.net].[dbo].[dwMetadata] SET [Id]='6E6BB37C-97CD-4C89-BFE2-4688E9D89E2F', [Folder]=N'metadata/forms', [Filename]=N'DataEditorDeployment.json', [IsDeleted]='0', [CreatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [CreatedDate]='2019-03-28 21:49:18.507', [DeletedBy]=NULL, [DeletedDate]=NULL, [UpdatedBy]='540E514C-911F-4A03-AC90-C450C28838C5', [UpdatedDate]='2019-09-14 07:51:44.997', [Data]=N'[
  {
    "key": "form_1",
    "data-buildertype": "form",
    "children": [
      {
        "key": "Name",
        "data-buildertype": "header",
        "content": "Deployment: {Name}",
        "size": "medium"
      }
    ],
    "style-marginBottom": "10px",
    "events": {}
  },
  {
    "key": "modalDiv",
    "data-buildertype": "container",
    "children": [
      {
        "key": "remarksModal",
        "data-buildertype": "swzmodal",
        "children": [
          {
            "key": "form_2",
            "data-buildertype": "form",
            "children": [
              {
                "key": "remarks",
                "data-buildertype": "input",
                "label": "Remarks",
                "fluid": true,
                "onChangeTimeout": 200,
                "other-required": true,
                "transparent": false,
                "inverted": false,
                "events": {
                  "onChange": {
                    "active": false,
                    "actions": [],
                    "targets": [
                      "remarksModal"
                    ],
                    "parameters": []
                  }
                }
              },
              {
                "key": "button_1",
                "data-buildertype": "button",
                "content": "Submit",
                "primary": false,
                "secondary": true,
                "inverted": true,
                "events": {
                  "onClick": {
                    "active": true,
                    "actions": [
                      "validate",
                      "submitRemarks"
                    ],
                    "targets": [
                      "grid"
                    ],
                    "parameters": []
                  }
                }
              }
            ]
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "",
        "style-hidden": false,
        "isOpen": ""
      },
      {
        "key": "statusModal",
        "data-buildertype": "swzmodal",
        "children": [
          {
            "key": "dropdownStatus",
            "data-buildertype": "dropdown",
            "label": "Dropdown",
            "fluid": true,
            "selection": true,
            "data-elements": [],
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setStatusAsync",
                  "gridRefresh"
                ],
                "targets": [
                  "grid"
                ],
                "parameters": []
              }
            }
          }
        ],
        "style-display": "block",
        "secondary": true,
        "inverted": true,
        "events": {},
        "style-source": "",
        "style-hidden": false,
        "isOpen": ""
      }
    ],
    "style-hidden": true,
    "events": {}
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "children": [
      {
        "key": "button_2",
        "data-buildertype": "button",
        "content": "Cancel",
        "secondary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirect"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "target",
                "value": "/form/DataEditorDeploymentList"
              }
            ]
          }
        },
        "primary": false
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Refresh",
        "secondary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "gridRefresh"
            ],
            "targets": [
              "grid"
            ],
            "parameters": []
          }
        },
        "primary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "10px"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "input_1",
        "data-buildertype": "input",
        "label": "",
        "fluid": true,
        "onChangeTimeout": 200,
        "placeholder": "Enter case number to search.....",
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
                "value": "UID"
              }
            ]
          }
        }
      }
    ],
    "style-float": "left",
    "events": {},
    "style-width": "100%"
  },
  {
    "key": "grid",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 120,
        "type": ""
      },
      {
        "key": "FormNames",
        "name": "Form",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 220
      },
      {
        "key": "PeerUID",
        "name": "Peer UID (Name)",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "width": 120
      },
      {
        "key": "DateStart",
        "name": "Date Start",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 120,
        "type": "datetime"
      },
      {
        "key": "DateComplete",
        "name": "Date Complete",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "width": 120,
        "type": "datetime"
      },
      {
        "key": "Remarks",
        "type": "custom",
        "sortable": true,
        "filterable": false,
        "resizable": true,
        "name": "Remarks",
        "width": 120
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "type": "custom",
        "width": 120
      },
      {
        "key": "Actions",
        "name": "Actions",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "width": 120
      },
      {
        "name": "",
        "type": "custom",
        "resizable": true,
        "sortable": true,
        "filterable": false,
        "key": "Actions2",
        "width": 120
      }
    ],
    "rowKey": "Id",
    "pageSize": "20",
    "pagerType": "server",
    "defaultSort": "UID ASC",
    "style-marginBottom": "20px",
    "multiselect": false
  }
]', [StructDivisionId]=NULL WHERE ([Id]='6E6BB37C-97CD-4C89-BFE2-4688E9D89E2F');

GO

ALTER VIEW [dbo].[vSP_DataEditorDeployment] AS 
select o.DplyId AS Id, o.DplyId, o.UserId, d.Name, d.CategoryId,
CASE
	WHEN d.Status=1 THEN 'Active'   
	WHEN d.Status=0 THEN 'Design'   
END 
as StatusText, d.Status,

q.Title, q.Type as QnnType,  d.DateEnd, d.UpdatedBy, d.CreatedDate, d.UpdatedDate, c.Name as Category, sc.SampleCount, rc.RespCount,

ISNULL(CAST(rc.RespCount as varchar(10)),0)  + '/' + CAST(sc.SampleCount as varchar(10)) as Responses, d.StructDivisionId, 

u.Name as UpdatedByUsername

from vSP_DeploymentOwner o
left join QNN_DPLY d on o.DplyId=d.Id
left join QNN_QNN q on d.QnnId = q.Id
left join dwSecurityUser u on u.Id = d.UpdatedBy
left join QNN_CATEGORY c on d.CategoryId = c.Id
left join vSP_DeploymentSampleCount sc on sc.DplyId = o.DplyId
left join vSP_DeploymentRespCount rc on rc.DplyId = o.DplyId


where d.IsDeleted=0 and q.IsDeleted=0 
GO

