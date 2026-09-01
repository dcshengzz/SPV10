-- Will UPDATE existing row(s) in dwMetadata for the following:
-- sidemenu.json
-- sidemenu-settings.json
-- organizations.json
-- organizations-settings.json
-- organizations-code.js
-- base.json
-- dplySampleOwner.json
-- dplySampleOwner-settings.json
-- dplySampleOwner-code.js

UPDATE [dwMetadata] SET
[Id]='55636648-e5a4-4002-9f59-d597fd167c04', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.787', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-11 13:54:26.453', 
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
            "title": "<b>Forms</b>",
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
          },
          {
            "target": "/surveydesigner?apanel=formlogic",
            "title": "Form Logic",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "title": "File Storage",
            "target": "/surveydesigner?apanel=filestorage",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyDesigner'')"
          },
          {
            "target": "/form/SwzRuleList",
            "title": "Validation Rules",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''SurveyDesigner'')"
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
            "title": "Sample Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/SwzTrkLists",
            "title": "Track Lists",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
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
            "title": "Deployments",
            "target": "/form/SwzDplyList",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ],
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
        "icon": "send",
        "distype": "dropdown"
      },
      {
        "title": "",
        "target": "",
        "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')",
        "icon": "edit",
        "children": [
          {
            "target": "/form/DataEditorDeploymentList",
            "title": "Data Editor",
            "visibleCondition": "CloverApp.API.checkRole(''DataEditor'')"
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
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          },
          {
            "target": "/form/ResponseReport",
            "title": "Response Report",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardOverall",
            "title": "Overall Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardSectorSegmentResponse",
            "title": "Sector/Segment Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/DashboardStatus",
            "title": "Response Status Dashboard",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')",
            "children": []
          },
          {
            "target": "/form/DashboardWeekly",
            "title": "Weekly Response Dashboard",
            "visibleCondition": "false"
          },
          {
            "target": "/form/RespondentParticipationReport",
            "title": "Respondent Participation Report",
            "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'')"
          }
        ]
      },
      {
        "target": "",
        "children": [
          {
            "title": "<b>System</b>",
            "distype": "dropdownheader"
          },
          {
            "title": "Categories",
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
            "target": "/useradmin",
            "title": "Security",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')",
            "icon": ""
          },
          {
            "target": "/form/UserAccessMatrix",
            "title": "User Access Matrix",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "target": "/form/SwzRespAdminList",
            "title": "Respondent Content Management",
            "visibleCondition": "CloverApp.API.checkRole(''HelpEditor'')"
          },
          {
            "target": "/form/swzHelpList",
            "title": "Online Help Content",
            "visibleCondition": "CloverApp.API.checkRole(''HelpEditor'')"
          },
          {
            "target": "/form/organizations",
            "title": "Organisations",
            "visibleCondition": "CloverApp.API.checkRole(''UserAdmin'')"
          },
          {
            "target": "/form/audittrail",
            "title": "Audit Trail",
            "visibleCondition": "CloverApp.API.checkRole(''AuditAdmin'')"
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
        "visibleCondition": "CloverApp.API.checkRole(''SurveyAdmin'') || CloverApp.API.checkRole(''UserAdmin'') || CloverApp.API.checkRole(''HelpEditor'') || CloverApp.API.checkRole(''AuditAdmin'') "
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

UPDATE [dwMetadata] SET
[Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'sidemenu-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:24.490', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-11 13:54:26.553', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "lastUpdate": "2022-06-11T13:54:26.55429+08:00",
  "isTemplate": false
}' WHERE [Id]='82ccc3b1-e283-4da5-9cbb-d5f5622ff62a';

UPDATE [dwMetadata] SET
[Id]='a211ced0-595c-465a-bb8b-93b991246ec4', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Organizations.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-07-16 13:08:11.013', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-05-19 11:19:19.043', 
[Data]=N'[
  {
    "key": "button_1",
    "data-buildertype": "button",
    "content": "Save",
    "primary": true,
    "inverted": false,
    "events": {
      "onClick": {
        "active": true,
        "actions": [
          "validate",
          "save"
        ],
        "targets": [
          "collectioneditor_1"
        ],
        "parameters": []
      }
    },
    "compact": false
  },
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "Organisation Structure",
    "size": "large",
    "textAlign": "left"
  },
  {
    "key": "collectioneditor_1",
    "data-buildertype": "collectioneditor",
    "idField": "Id",
    "parentIdField": "ParentId",
    "columns": [
      {
        "key": "Name",
        "name": "Name",
        "width": "30%"
      }
    ],
    "hierarchical": true,
    "disableAdd": false,
    "disableDelete": false,
    "header": true,
    "draggable": false,
    "collapseAll": false,
    "other-visibleConition": ""
  }
]' WHERE [Id]='a211ced0-595c-465a-bb8b-93b991246ec4';

UPDATE [dwMetadata] SET
[Id]='264a20b1-0b26-44c4-aa48-573103b8fc87', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Organizations-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-07-16 13:08:11.263', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-10-06 11:13:18.320', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "f6e34bdf-b769-42dd-a2be-fee67faf9045",
  "name": "Organizations",
  "lastUpdate": "2021-10-06T11:13:18.3196574+08:00",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "AfterSelect"
      ],
      "codeAction": "NullifyOrganizationParentAsyncTrigger",
      "parameter": "{ParentId: \"@null\"}"
    }
  ],
  "dataMap": [],
  "dataColl": [
    {
      "id": "795fa882-2c29-4a4f-1b1f-fdbc9b3e77fe",
      "entityId": "5c4f1d9c-fb7b-480e-8841-32633dfa8ad7",
      "filter": "ParentAsyncFilter",
      "parameter": "",
      "control": "collectioneditor_1",
      "dataMap": [
        {
          "id": "00f387a3-77b7-72ce-ddfa-5799a92c5c16",
          "attributeId": "07e9391f-c1b3-4ae8-a228-6ea9228ac5be",
          "control": "",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "4720db20-15a8-8cdf-d399-423b6dcac52b",
          "attributeId": "ea2f6e04-bc63-49a6-96c4-5b82420cf5a0",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "20aa074f-54eb-70c8-0bad-3899c0482a48",
          "attributeId": "e2f0469b-086d-4084-be71-2068e006a906",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false
    }
  ],
  "securityGroup": "Organization"
}' WHERE [Id]='264a20b1-0b26-44c4-aa48-573103b8fc87';

UPDATE [dwMetadata] SET
[Id]='2cc2c415-7586-4bad-a1db-81d6da8a2c3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'Organizations-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-09-06 19:50:39.517', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-09-06 19:54:26.663', 
[Data]=N'{
    init: function(args) {
        console.log(args);
        if(!CloverApp.API.checkRole(''Admins'')){
            const rewriter = function(model) {
                console.log("model", model);
                model.disableAdd = true;
            }
            CloverApp.API.rewriteControlModel("collectioneditor_1", rewriter);
        }
    },
}' WHERE [Id]='2cc2c415-7586-4bad-a1db-81d6da8a2c3d';

UPDATE [dwMetadata] SET
[Id]='cb82c0f3-8ea8-42a5-aad7-cc6f3e07053a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/localization', [FileName]=N'base.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:10.700', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-12 18:34:38.243', 
[Data]=N'{
  "common": {
    "dateFormat": "DD MMM YYYY",
    "timeFormat": "HH:mm",
    "datetimeFormat": "DD MMM YYYY HH:mm"
  },
  "msg": {
    "deleteAllSampleAssignmentTitle": "Remove ALL Sample Assignments",
    "deleteAllSampleAssignmentText": "This will delete ALL the DataEditor assignments for this deployment. Proceed?",
      
    "addSampleConfirmTitle": "Add List Samples",
    "addSampleConfirmText": "Are you sure you want to add new samples from the list to this deployment?",
    
    "submitSurveyConfirmTitle": "Survey Submission",
    "submitSurveyConfirmText": "Are you sure you want to submit survey?",
    
    "deleteListSamplesConfirmTitle": "Remove List Samples from Sample List",
    "deleteListSamplesConfirmText": "WARNING: Removing the samples from this list will also delete all their related data in deployments that use this list INCLUDING RESPONSE DATA. Are you absolutely sure you want to continue?", 
    
    "deleteSampleListConfirmTitle": "Delete Sample List & Associated Records",
    "deleteSampleListConfirmText": "WARNING: Deleting a Sample List will also immediately delete all deployments that use it INCLUDING RESPONSE DATA",
    "deleteSampleListConfirmOk": "Delete List",
    
    "deletionConfirmTitle": "Deletion Confirmation",
    "deletionConfirmText": "All the data related with selected records will be deleted. Are you sure you want to continue?",
    
    "deleteSampleConfirmTitle": "Delete Samples",
    "deleteSampleConfirmText": "WARNING: ALL the data related with selected samples will be deleted, INCLUDING RESPONSE DATA, sample list properties and etc. Are you absolutely sure you want to continue?",    
    
    "disableSamplesConfirmTitle": "Disable Samples",
    "disableSamplesConfirmText": "The selected sample''s status will be set to inactive in this list, making them inactive in deployments using this list (existing response data will NOT be deleted and you can re-enable them later). Continue?",  
    
    "createDplyConfirmTitle": "Create deployment?",
    "createDplyConfirmText": "Please confirm that you are ready to continue with the deployment record creation now. (Note: Certain deployment settings may only be specified before creating the deployment record and are not subsequently adjustable)",
    
    "resetResponseConfirmTitle": "Confirm Reset Response",
    "resetResponseConfirmText": "Click Reset to delete the answers for this response and set its status back to Pending",
    "resetResponseConfirmOk": "Reset",
    
    "setStatusConfirmTitle": "Confirm Change Status",
    "setStatusConfirmText": "This will change the response status. Continue?",
    
    "exemptConfirmTitle": "Set Exempted Status",
    "exemptConfirmText": "This will change the response status to Exempted. (The respondent will still be able to access the survey if it is visible to respondents)",
    "exemptConfirmOk": "Exempt"
  },
  "forms": {
    "CategoryList": {
      "pageHeader_content": "List",
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete",
      "searchField_label": ""
    },
    "DataEditorDeployment": {
      "Name_content": "{Name}",
      "remarks_label": "Remarks",
      "button_1_content": "Submit",
      "grid_UID": "UID (Name)",
      "grid_DateStart": "Date Start",
      "grid_DateComplete": "Date Complete",
      "grid_ActiveYN": "Active",
      "grid_CreatedDate": "",
      "grid_Remarks": "Remarks",
      "dropdownStatus_label": "Dropdown",
      "button_2_content": "Cancel",
      "grid_PeerUID": "Peer UID (Name)",
      "grid_StatusTitle": "Status",
      "grid_Actions": "Actions",
      "grid_Actions2": ""
    },
    "DataEditorDeploymentList": {
      "headerDataEditorList_content": "Data Editor",
      "headerDataEditorList_subheader": "View a list of deployments under you",
      "dictionary_1_label": "Category",
      "input_1_label": "Filter",
      "grid_Name": "Name",
      "grid_StatusText": "Status",
      "grid_Title": "Questionnaire",
      "grid_Category": "Category",
      "grid_DateEnd": "Date End",
      "grid_Responses": "Responses",
      "grid_CategoryId": "",
      "refreshChart_content": "Refresh",
      "grid_QnnType": "Type"
    },
    "DEDplys": {
      "gridview_1_Id": "ID",
      "gridview_1_Name": "Name",
      "gridview_1_ListId_Name": "List"
    },
    "DocumentEdit": {
      "btnOpenWorkflowDesigner_content": "Open in Workflow Designer",
      "name_label": "Name",
      "managerId_label": "Manager",
      "number_label": "Number",
      "amount_label": "Money amount (Must be more 0!)",
      "author_label": "Author",
      "stateName_label": "State",
      "comment_label": "Comment",
      "header_1_content": "Document''s Transition History",
      "gridHistory_from": "From",
      "gridHistory_to": "To",
      "gridHistory_command": "Command",
      "gridHistory_executor": "Executor",
      "gridHistory_TransitionTime": "Date",
      "gridHistory_availiablefor": "Availiable for",
      "save_content": "Save",
      "saveexit_content": "Save & Exit"
    },
    "Documents": {
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete",
      "btnRefresh_content": "Refresh",
      "button_1_content": "Export",
      "inputSearch_label": "",
      "grid_number": "#",
      "grid_stateName": "State",
      "grid_name": "Name",
      "grid_comment": "Comment",
      "grid_author": "Author",
      "grid_manager": "Manager",
      "grid_amount": "Amount"
    },
    "footer": {
      "staticcontent_1_content": "<b>Please contact <a href=\"mailto:sales@softworkz.net\">sales@softworkz.net</a>.</b>\nOfficial site - <a href=\"http://softworkz.net\">http://softworkz.net</a>"
    },
    "header": {
      "currentUser_/admin": "Admin panel",
      "currentUser_/form/settings": "Settings",
      "currentUser_/account/logoff": "Logout"
    },
    "qnns": {},
    "QNN_AUDIT_TRAIL": {
      "AuditAction_label": "AuditAction",
      "ChangeDate_label": "ChangeDate",
      "ModuleCode_label": "ModuleCode",
      "NumberId_label": "NumberId",
      "Ref_Id_label": "Ref_Id",
      "Ref_Name_label": "Ref_Name",
      "UserId_label": "UserId",
      "UserName_label": "UserName",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "qnn_categories": {
      "button_1_content": "Delete"
    },
    "QNN_CATEGORY": {
      "Name_label": "Name",
      "Description_label": "Description",
      "dropdownType_label": "Type",
      "dictRoles_label": "Roles",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_CATEGORY2": {
      "Name_label": "Name",
      "Description_label": "Description",
      "ParentId_label": "ParentId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel",
      "gridview_1_Id": "ID",
      "gridview_1_Name": "Name"
    },
    "QNN_CATEGORY_ROLE": {
      "CategoryId_label": "CategoryId",
      "RoleId_label": "RoleId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY": {
      "header_1_content": "Deployments",
      "buttonManageListSamples_content": "Manage List Samples",
      "buttonManageDataEditors_content": "Manage Data Editors",
      "btnCancel_content": "Cancel",
      "btnSave_content": "Save",
      "headerBasicProperties_content": "Basic Properties",
      "textName_label": "Name",
      "dictCategory_label": "Category",
      "dictQuestionnaire_label": "Questionnaire",
      "dictList_label": "List",
      "DateStart_label": "Start On",
      "DateEnd_label": "End On",
      "headerCompletionProperties_content": "Completion  Properties",
      "textCompleteURL_label": "",
      "hedderNavigationProperties_content": "Navigation Properties",
      "textNavCancelUrl_label": "",
      "headerResponseProperties_content": "Response Properties",
      "MaxResponse_label": "Maximum Number of Responses",
      "DaysUpdate_label": "Days for Update",
      "button_1_content": "Manage List Samples",
      "button_2_content": "Manage Data Editors",
      "button_3_content": "Cancel",
      "button_4_content": "Save",
      "buttonManageMessageHistory_content": "Manage Message History",
      "header_2_content": "Initial Notification Type",
      "cbMailMerge_label": "Mail Merge",
      "cbEmail_label": "Email",
      "cbProfile_label": "Generate Profile",
      "subject_label": "Subject"
    },
    "QNN_DPLY_MSG": {
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "DplyId_label": "DplyId",
      "DplyStep_label": "DplyStep",
      "EmailBCC_label": "EmailBCC",
      "EmailCC_label": "EmailCC",
      "EmailFrom_label": "EmailFrom",
      "EmailSubj_label": "EmailSubj",
      "GenerateDateTime_label": "GenerateDateTime",
      "GenerateQnnYN_label": "GenerateQnnYN",
      "IsDeleted_label": "IsDeleted",
      "MsgContent_label": "MsgContent",
      "NotifyEmail_label": "NotifyEmail",
      "NotifyGenerate_label": "NotifyGenerate",
      "NotifyMerge_label": "NotifyMerge",
      "NumberId_label": "NumberId",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_MSG_SAMPLE": {
      "CreatedDate_label": "CreatedDate",
      "DplyMsgId_label": "DplyMsgId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_DUEDATE": {
      "DplyId_label": "DplyId",
      "DueDate_label": "DueDate",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_INFO": {
      "DispatchInd_label": "DispatchInd",
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "ProcessEditInd_label": "ProcessEditInd",
      "ProcessValidInd_label": "ProcessValidInd",
      "Remarks_label": "Remarks",
      "RemarksModifyBy_label": "RemarksModifyBy",
      "RemarksModifyOn_label": "RemarksModifyOn",
      "ReturnInd_label": "ReturnInd",
      "Status_label": "Status",
      "StatusModifyBy_label": "StatusModifyBy",
      "StatusModifyOn_label": "StatusModifyOn",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_DPLY_SAMPLE_OWNER": {
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "UserId_label": "UserId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_LIST": {
      "bcList_1": "List",
      "bcList_2": "Manage List",
      "headerName_content": "Manage {nameInput}",
      "headerName_subheader": "",
      "headerProperties_content": "Properties",
      "nameInput_label": "List Title",
      "headerDescription_label": "List Description",
      "dictionaryCategory_label": "Category Name",
      "toggleStatus_label": "Status",
      "headerUser_content": "Records User Control",
      "toggleEditName_label": "Edit Name",
      "toggleEditEmail_label": "Edit Email",
      "togglePassword_label": "Edit Password",
      "btnSaveR_content": "Save & Review",
      "btnSave_content": "Save",
      "btnCancel_content": "Cancel",
      "headerRecords_content": "Records ",
      "btnCreate2_content": "Create",
      "btnDelete_content": "Delete",
      "header_5_content": "Import Sample",
      "header_5_subheader": "CSV Format.. ",
      "button_7_content": "Create",
      "button_8_content": "Cancel",
      "button_1_content": "Export",
      "btnRefresh_content": "Refresh",
      "headerCount_content": "Total Count: {__collectioneditor_sample_totalcount}",
      "gridviewSample_Id": "ID",
      "gridviewSample_Name": "Title",
      "gridviewSample_Email": "Email",
      "collectioneditor_sample_UID": "UID",
      "collectioneditor_sample_Name": "Name",
      "collectioneditor_sample_Email": "Email",
      "collectioneditor_sample_NumRetry": "NumRetry",
      "collectioneditor_sample_Pwd": "Password",
      "collectioneditor_sample_ActiveYN": "Active",
      "collectioneditor_sample_PwdResetYN": "PwdResetYN",
      "collectioneditor_1_Alias": "Alias",
      "collectioneditor_1_ReqdYN": "Reqd",
      "collectioneditor_1_UsrEditYN": "UsrEdit",
      "collectioneditor_1_TxtRow": "TxtRow",
      "collectioneditor_1_TxtRegExp": "TxtRegExp",
      "collectioneditor_1_TxtRegExpErr": "TxtRegExpErr",
      "inputPassword_label": "Password",
      "inputImportListSample_label": "",
      "headerSampleAdded_content": "Sample Added: {sampleAddedCount}",
      "headerSampleUpdated_content": "Sample Updated: {sampleUpdatedCount}",
      "headerListSampleAdded_content": "List Sample Added: {listSampleAddedCount}",
      "headerListSampleUpdated_content": "List Sample Updated: {listSampleUpdatedCount}",
      "gridviewSample_UID": "UID",
      "gridviewSample_PeerUID": "Peer UID",
      "gridviewSample_PeerName": "Peer Name"
    },
    "QNN_LIST2": {
      "Name_label": "Name",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "qnn_lists": {
      "button_1_content": "Delete"
    },
    "QNN_LIST_REVIEW": {
      "dictionary_1_label": "List Name",
      "Notes_label": "Notes",
      "Consent_label": "Consent",
      "btnSave_content": "Save",
      "button_1_content": "Cancel",
      "searchField2_label": ""
    },
    "QNN_LIST_SAMPLE": {
      "header_1_content": "Manage Sample",
      "DictionaryListName_label": "List Title",
      "Name_label": "Name",
      "Email_label": "Email",
      "UID_label": "Username",
      "UIDPeer_label": "UIDPeer",
      "Pwd_label": "Password",
      "ActiveYN_label": "Status",
      "PwdResetYN_label": "Password Reset",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel",
      "dictionarySample_label": "Sample",
      "dictionarySamplePeer_label": "Sample Peer"
    },
    "QNN_QNN": {
      "Alias_label": "Alias",
      "CategoryId_label": "CategoryId",
      "Status_label": "Status",
      "Title_label": "Title",
      "collectioneditor_1_Name": "Name",
      "collectioneditor_1_Token": "File",
      "collectioneditor_1_Language": "Language",
      "collectioneditor_1_Remarks": "Remarks",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel",
      "button_1_content": "Generate Qnn Fields",
      "header_1_content": "Questionnaire",
      "Type_label": "Type",
      "collectioneditor_2_Name": "Form Name",
      "collectioneditor_2_Language": "Language",
      "collectioneditor_2_Remarks": "Remarks"
    },
    "QNN_QNN_ENTITY": {
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "IsDeleted_label": "IsDeleted",
      "Language_label": "Language",
      "NumberId_label": "NumberId",
      "QnnId_label": "QnnId",
      "Remarks_label": "Remarks",
      "Token_label": "Token",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_FIELD": {
      "Name_label": "Name",
      "QnnId_label": "QnnId",
      "ReadOnly_label": "ReadOnly",
      "Required_label": "Required",
      "Type_label": "Type",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_REVIEW": {
      "QnnId_label": "QnnId",
      "Notes_label": "Notes",
      "Consent_label": "Consent",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_QNN_REVIEW_FILES": {
      "Name_label": "Name",
      "NumberId_label": "NumberId",
      "ReviewId_label": "ReviewId",
      "Size_label": "Size",
      "token_label": "token",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_RESP": {
      "DateComplete_label": "DateComplete",
      "DateStart_label": "DateStart",
      "DplyId_label": "DplyId",
      "ListSampleId_label": "ListSampleId",
      "NumberId_label": "NumberId",
      "QnnId_label": "QnnId",
      "RespIp_label": "RespIp",
      "Score_label": "Score",
      "TimeTook_label": "TimeTook",
      "UpdatedDate_label": "UpdatedDate",
      "UserId_label": "UserId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_RESP_ADMIN": {
      "Name_label": "Title",
      "Type_label": "Type",
      "StartDate_label": "StartDate",
      "EndDate_label": "EndDate",
      "Status_label": "Status",
      "btnSave_content": "Save",
      "button_2_content": "Save Editor",
      "button_1_content": "Fetch Editor State",
      "btnExit_content": "Cancel",
      "header_2_content": "Respondent Content Management"
    },
    "QNN_RESP_ANS": {
      "AnsBin_label": "AnsBin",
      "AnsVal_label": "AnsVal",
      "NumberId_label": "NumberId",
      "QnnFieldId_label": "QnnFieldId",
      "RespId_label": "RespId",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "QNN_STATUS": {
      "Active_label": "Active",
      "Code_label": "Code",
      "CreatedBy_label": "CreatedBy",
      "CreatedDate_label": "CreatedDate",
      "DeletedBy_label": "DeletedBy",
      "DeletedDate_label": "DeletedDate",
      "Description_label": "Description",
      "HasRespYN_label": "HasRespYN",
      "NumberId_label": "NumberId",
      "Title_label": "Title",
      "UpdatedBy_label": "UpdatedBy",
      "UpdatedDate_label": "UpdatedDate",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "respdashboard": {
      "gridview_1_DplyName": "Name",
      "gridview_1_QnnTitle": "Questionnaire",
      "gridview_1_DplyDateStart": "Survey Start",
      "gridview_1_DplyDateEnd": "Survey End",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Response Complete",
      "header_1_content": "Respondent Home",
      "header_2_content": "Current Surveys",
      "grid_QnnTitle": "Survey Name",
      "grid_Type": "Type",
      "grid_PeerName": "Peer",
      "grid_DplyDateStart": "Launched On",
      "grid_DueDate": "Due On",
      "grid_RespDateStart": "Responded On",
      "grid_RespDateEnd": "Submitted On",
      "grid_Password": "Password",
      "header_3_content": "Previous Surveys",
      "gridview_QnnTitle": "Survey Name",
      "gridview_Type": "Type",
      "gridview_PeerName": "Peer",
      "gridview_DplyDateStart": "Launched On",
      "gridview_DueDate": "Due On",
      "gridview_RespDateStart": "Responded On",
      "gridview_RespDateEnd": "Submitted On",
      "gridview_Password": "Password",
      "password_label": "",
      "btnClose_content": "OK"
    },
    "resplogin": {
      "login_label": "Respondent Login",
      "password_label": "Password",
      "remember_label": "Remember",
      "btnLogin_content": "Login",
      "breadcrumb_1_1": "Forgot Password"
    },
    "Settings": {
      "header_1_content": "Workflow",
      "button_1_content": "Manage workflow schemes",
      "header_3_content": "Roles",
      "btnRoles_content": "Manage roles",
      "header_2_content": "StructDivisions",
      "structdivision_name": "Name",
      "structdivision_roles": "Roles"
    },
    "sidemenu": {
      "sidemenu_/form/SwzQnnList": "Questionaires",
      "sidemenu_/form/SwzListList": "List",
      "sidemenu_/form/SwzDplyList": "Deployment",
      "sidemenu_/form/DataEditorDeploymentList": "Data Editor",
      "sidemenu_/form/SwzCategoryList": "Category",
      "sidemenu_/form/SwzQnnList/": "Questionaires",
      "sidemenu_/surveydesigner": "Survey Designer",
      "sidemenu_/form/SwzRespAdminList": "Respondent Content Management"
    },
    "spfooter": {
      "staticcontent_1_content": "<b>Please contact <a href=\"mailto:sales@softworkz.net\">sales@softworkz.net</a>.</b>\nOfficial site - <a href=\"http://softworkz.net\">http://softworkz.net</a>"
    },
    "spheader": {
      "currentUser_/form/respsettings": "Settings",
      "currentUser_/resp/logoff": "Logout",
      "currentUser_/form/respdashboard": "Home",
      "currentUser_/form/RespAccountChangePassword": "Settings"
    },
    "sptop": {},
    "SwzCategoryList": {
      "header_1_content": "Categories",
      "buttonAdd_content": "Add",
      "buttonDelete_content": "Delete",
      "gridCategory_Name": "Name"
    },
    "SwzDataEditor": {
      "header_1_content": "Samples",
      "buttonCancel_content": "Cancel",
      "buttonSave_content": "Save",
      "gridviewListSamples_ReturnInd": "Return",
      "gridviewListSamples_ProcessValidInd": "Validation",
      "gridviewListSamples_ProcessEditInd": "Editing"
    },
    "SwzDataEditorList": {
      "headerDataEditorList_content": "Data Editor",
      "headerDataEditorList_subheader": "View a list of deployments under you",
      "buttonDelete_content": "Delete",
      "buttonAddDataEditor_content": "Add",
      "gridviewDeployments_Name": "Name",
      "gridviewDeployments_Status": "Status",
      "gridviewDeployments_QnnId_Title": "Questionnaire",
      "gridviewDeployments_ListId_Name": "List",
      "gridviewDeployments_CategoryId_Name": "Category"
    },
    "SwzDplyList": {
      "header_2_content": "Deployments",
      "buttonAdd_content": "Add",
      "buttonDelete_content": "Delete",
      "gridview_1_Name": "Name",
      "gridview_1_Status": "Status",
      "gridview_1_QnnId_Title": "Questionnaire",
      "gridview_1_ListId_Name": "List",
      "gridview_1_CategoryId_Name": "Category",
      "gridview_1_QnnId_Type": "Type",
      "gridview_1_CreatedDate": "Date Created"
    },
    "SwzListList": {
      "pageHeader_content": "List",
      "button_3_content": "Export",
      "btnCreate_content": "Create",
      "header_1_content": "Are you sure?",
      "button_1_content": "Confirm",
      "button_2_content": "Cancel",
      "inputSearch_label": "",
      "grid_Name": "Name",
      "grid_Category": "Category",
      "grid_SampleCount": "No. Of Records",
      "grid_UpdatedDate": "Date Modified",
      "grid_Status": "Status"
    },
    "SwzQnnList": {
      "header_1_content": "Questionnaire",
      "btnCreate2_content": "Create",
      "header_2_content": "Are you sure?",
      "button_1_content": "Confirm",
      "button_2_content": "Cancel",
      "button_3_content": "Delete",
      "gridview_1_Title": "Name",
      "gridview_1_Type": "Type",
      "gridview_1_Status": "Status"
    },
    "SwzRespAdminList": {
      "header_1_content": "Respondent Content Management",
      "btnCreate_content": "Create",
      "btnDelete_content": "Delete"
    },
    "SwzReviewList": {
      "pageHeader_content": "Reviews",
      "List_content": "List Name: {Listname}",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "Save_content": "Save",
      "cancelbu_content": "Cancel",
      "button_1_content": "Export",
      "header_1_content": "Total Count: {__review_gridview_totalcount}"
    },
    "SwzReviewQnn": {
      "header_1_content": "Reviews",
      "Questionnaire_content": "Questionnaire: {Title}",
      "collectioneditor_1_Notes": "Notes",
      "collectioneditor_1_Consent": "Consent",
      "button_2_content": "Save",
      "button_3_content": "Cancel",
      "button_1_content": "Export",
      "header_2_content": "Total Count: {__swzgridview_1_totalcount}"
    },
    "test": {
      "button_1_content": "Button"
    },
    "top": {},
    "login": {
      "login_label": "Login",
      "password_label": "Password",
      "remember_label": "Remember",
      "btnLogin_content": "Login"
    },
    "Job": {
      "Arguments_label": "Arguments",
      "CreatedAt_label": "CreatedAt",
      "ExpireAt_label": "ExpireAt",
      "InvocationData_label": "InvocationData",
      "StateId_label": "StateId",
      "StateName_label": "StateName",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplyListSample": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Manage list of samples specific to this deployment",
      "txtFilter_label": "",
      "input_1_label": "Filter Due Date  >=",
      "input_5_label": "Filter Due Date  <=",
      "dueDate_label": "Due Date",
      "button_5_content": "Submit",
      "input_2_label": "Filter Generated Date  >=",
      "input_3_label": "Filter Generated Date  <=",
      "btnResetPassword_content": "Reset Password",
      "cbMailMerge_label": "Mail Merge",
      "cbEmail_label": "Email",
      "cbProfile_label": "Generate Profile",
      "subject_label": "Subject",
      "button_2_content": "Submit",
      "gridview_1_UIDName": "UID (Name)",
      "gridview_1_PeerName": "Peer UID (Name)",
      "gridview_1_StatusTitle": "Status",
      "gridview_1_DueDate": "Due Date",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Respponse End",
      "gridview_1_CreatedDate": "Generated On",
      "button_1_content": "Add New List Sample",
      "button_4_content": "Manage Message History",
      "button_3_content": "Back"
    },
    "TestControllsForSurveyForm": {
      "header_1_content": "Name: {input_1}",
      "input_1_label": "Input",
      "textarea_1_label": "TextArea",
      "dropdown_1_label": "Dropdown",
      "checkbox_1_label": "Checkbox",
      "input_2_label": "Input",
      "input_3_label": "Input",
      "input_4_label": "Input",
      "input_6_label": "Input",
      "button_1_content": "Button"
    },
    "TestControllsForSurveyForm_table": {
      "input_1_label": "Input",
      "textarea_1_label": "TextArea",
      "dropdown_1_label": "Dropdown",
      "checkbox_1_label": "Checkbox",
      "input_2_label": "Input",
      "input_3_label": "Input",
      "button_1_content": "Button"
    },
    "Server": {
      "Data_label": "Data",
      "LastHeartbeat_label": "LastHeartbeat",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "test123": {},
    "RespAccountChangePassword": {
      "header_1_content": "Please enter your new password",
      "oldPassword_label": "Old Password",
      "newPassword_label": "New Password",
      "confirmPassword_label": "Confirm Password",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "tableForm": {},
    "AggregatedCounter": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "testCustom2": {
      "input_112_label": "Input",
      "button_1_content": "Button"
    },
    "RespResetPasswordSuccess": {
      "header_1_content": "Check email for reset password link.",
      "btnSubmit_content": "Resend",
      "button_1_content": "Cancel"
    },
    "testForm": {
      "input_1_label": "Input"
    },
    "Hash": {
      "ExpireAt_label": "ExpireAt",
      "Field_label": "Field",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "testrequired": {
      "input_1_label": "Input",
      "button_1_content": "Button"
    },
    "testCustom": {},
    "RespResetPassword": {
      "resetPwdHeader_content": "Enter login to receive reset password link in email",
      "resetPwdHeader_subheader": "",
      "UID_label": "Respondent Login",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "sysdiagrams": {
      "definition_label": "definition",
      "name_label": "name",
      "principal_id_label": "principal_id",
      "version_label": "version",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplyMessages": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Manage message history of this deployment",
      "grid_DplyStep": "Step",
      "grid_NotifyMerge": "Mail Merge?",
      "grid_NotifyEmail": "Email?",
      "grid_NotifyGenerate": "Generate Profile?",
      "grid_SampleCount": "Number of Samples",
      "grid_CreatedDate": "Created On",
      "grid_UserName": "Created By",
      "button_3_content": "Back"
    },
    "testText": {
      "input_1_label": "Input"
    },
    "State": {
      "CreatedAt_label": "CreatedAt",
      "Data_label": "Data",
      "JobId_label": "JobId",
      "Name_label": "Name",
      "Reason_label": "Reason",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "JobQueue": {
      "FetchedAt_label": "FetchedAt",
      "JobId_label": "JobId",
      "Queue_label": "Queue",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "MP2015_Questionnaire": {
      "header_1_content": "Header",
      "input_1_label": "Input"
    },
    "JobParameter": {
      "JobId_label": "JobId",
      "Name_label": "Name",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "vSP_ListSampleCount": {
      "ListId_label": "ListId",
      "SampleCount_label": "SampleCount",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Schema": {
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Counter": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "dplysampleowner": {
      "header_1_content": "{Name}",
      "header_1_subheader": "Assign Data Editors for Deployment Samplers",
      "DataEditor_label": "Data Editor",
      "gridview_1_UIDName": "UID (Name)",
      "gridview_1_PeerName": "Peer UID (Name)",
      "gridview_1_StatusTitle": "Status",
      "gridview_1_RespDateStart": "Response Start",
      "gridview_1_RespDateEnd": "Response Complete",
      "gridview_1_DueDate": "Due Date",
      "button_1_content": "Save",
      "button_2_content": "Cancel"
    },
    "RespChangePassword": {
      "header_1_content": "Please enter your new password",
      "newPassword_label": "New Password",
      "confirmPassword_label": "Confirm Password",
      "btnSubmit_content": "Confirm",
      "button_1_content": "Cancel"
    },
    "deletethis": {
      "header_4_content": "Attemp to hide container",
      "button_1_content": "Show Args",
      "toggle_label": "Toggle",
      "input_2_label": "Show = true",
      "input_3_label": "Show = false",
      "header_1_content": "Container A",
      "input_1_label": "1st"
    },
    "RespChangePasswordSuccess": {
      "header_1_content": "Change password successful",
      "btnSubmit_content": "Home"
    },
    "ResendTemplateOne": {
      "subject_content": "SP7: Resend",
      "body_content": "Dear {Name}!<br/><br/>\n\n<br />DplyName:  {DplyName}, <br />\n<br />DplyQnn: {DplyQnn}, <br /> \n<br />DplyList: {DplyList}, <br />\n<br />DplyCategory: {DplyCategory}, <br />\n<br />Name: {Name}, <br /> \n<br />Email: {Email}, <br /> \n<br />UID: {UID}, <br /> \n<br />UIDPeer: {UIDPeer}, <br /> \n<br />ActiveYN: {ActiveYN}, <br />\n<br />Password: {Password}, <br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<br />More Lines<br />\n<p>&nbsp;</p>\n"
    },
    "TestWorkflow": {
      "input_1_label": "Input",
      "button_1_content": "Button"
    },
    "LitterCount": {
      "Name_label": "Name",
      "Observer _label": "I am an Observer ",
      "dropdown_1_label": "Location"
    },
    "testreg": {
      "input_1_label": "Input"
    },
    "ThankYou": {
      "header_1_content": "Completion of Survey"
    },
    "List": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    },
    "Set": {
      "ExpireAt_label": "ExpireAt",
      "Key_label": "Key",
      "Score_label": "Score",
      "Value_label": "Value",
      "btnSave_content": "Save",
      "btnExit_content": "Cancel"
    }
  }
}' WHERE [Id]='cb82c0f3-8ea8-42a5-aad7-cc6f3e07053a';

UPDATE [dwMetadata] SET
[Id]='b2c5fd29-64a3-4d9a-8cc2-5a3c9c739089', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplysampleowner.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.740', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-12 21:37:20.193', 
[Data]=N'[
  {
    "key": "header_1",
    "data-buildertype": "header",
    "content": "{Name}",
    "size": "huge",
    "subheader": "Assignment of Data Editors"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "container_3",
        "data-buildertype": "container",
        "style-width": "100%",
        "children": [
          {
            "key": "DataEditor",
            "data-buildertype": "dictionary",
            "label": "Data Editors",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_dataEditors",
            "columns": "Name ASC",
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "onChangeDataEditor"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "style-customcss": "",
            "clearable": true,
            "multiple": true,
            "search": true,
            "style-marginBottom": "",
            "style-width": "400px"
          }
        ],
        "style-float": "left",
        "style-marginBottom": "20px"
      },
      {
        "key": "container_8",
        "data-buildertype": "container",
        "children": [
          {
            "key": "deleteBtn",
            "data-buildertype": "button",
            "content": "Delete Selected Assignments",
            "secondary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "deleteDplySampleOwner"
                ],
                "targets": [
                  "dataEditorGv"
                ],
                "parameters": []
              }
            },
            "floated": "left"
          },
          {
            "key": "deleteAllBtn",
            "data-buildertype": "button",
            "content": "Delete ALL Assignments",
            "secondary": true,
            "events": {
              "onClick": {
                "active": true,
                "actions": [
                  "confirm",
                  "deleteAllAssignment"
                ],
                "targets": [],
                "parameters": [
                  {
                    "name": "confirmTitle",
                    "value": "deleteAllSampleAssignmentTitle"
                  },
                  {
                    "name": "confirmText",
                    "value": "deleteAllSampleAssignmentText"
                  }
                ]
              }
            },
            "floated": "right",
            "style-marginLeft": "",
            "other-visibleConition": ""
          }
        ],
        "style-width": "100%",
        "style-marginTop": ""
      }
    ],
    "style-width": "100%",
    "style-marginBottom": "20px"
  },
  {
    "key": "container_4",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "header_2",
        "data-buildertype": "header",
        "content": "Samples Assignment:",
        "size": "medium"
      }
    ],
    "style-marginBottom": "20px",
    "style-marginTop": "",
    "style-width": "100%"
  },
  {
    "key": "dataEditorGv",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "Username",
        "name": "User",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Segment",
        "name": "Segment",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "RespDateStart",
        "name": "Response Start",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "RespDateEnd",
        "name": "Response Complete",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "DueDate",
        "name": "Due Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      }
    ],
    "defaultSort": "Username ASC, UID ASC",
    "rowKey": "PK",
    "multiselect": true,
    "events": {
      "onSelectionChanged": {
        "active": false,
        "actions": [
          "onChangeSegment"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "minHeight": "300px",
    "pagerType": "server",
    "pageSize": "500",
    "rowHeight": "80",
    "style-marginTop": "20px",
    "other-visibleConition": ""
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "header_3",
        "data-buildertype": "header",
        "content": "All Samples:",
        "size": "medium"
      },
      {
        "key": "container_5",
        "data-buildertype": "container",
        "style-width": "400px",
        "children": [
          {
            "key": "inputSearch",
            "data-buildertype": "input",
            "label": "",
            "fluid": false,
            "onChangeTimeout": 200,
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setFilter",
                  "applyFilter"
                ],
                "targets": [
                  "allSamplesGv"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "Name, UID"
                  }
                ]
              }
            },
            "style-marginTop": "10px",
            "style-width": "100%",
            "style-marginRight": "",
            "style-source": "float: left;",
            "style-marginBottom": "",
            "style-hidden": false,
            "placeholder": "Search by Name or UID"
          },
          {
            "key": "segmentSearch",
            "data-buildertype": "input",
            "label": "",
            "fluid": false,
            "onChangeTimeout": 200,
            "events": {
              "onChange": {
                "active": true,
                "actions": [
                  "setFilter",
                  "applyFilter"
                ],
                "targets": [
                  "allSamplesGv"
                ],
                "parameters": [
                  {
                    "name": "column",
                    "value": "Segment"
                  }
                ]
              }
            },
            "style-marginTop": "10px",
            "style-width": "100%",
            "style-marginRight": "",
            "style-source": "float: left;",
            "style-marginBottom": "",
            "style-hidden": false,
            "placeholder": "Search by Segment"
          }
        ]
      }
    ],
    "style-marginBottom": "20px",
    "style-marginTop": "40px",
    "style-width": "100%"
  },
  {
    "key": "allSamplesGv",
    "data-buildertype": "gridview",
    "columns": [
      {
        "key": "UID",
        "name": "UID",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Name",
        "name": "Name",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "StatusTitle",
        "name": "Status",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "Segment",
        "name": "Segment",
        "sortable": true,
        "filterable": false,
        "resizable": false
      },
      {
        "key": "RespDateStart",
        "name": "Response Start",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "RespDateEnd",
        "name": "Response Complete",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      },
      {
        "key": "DueDate",
        "name": "Due Date",
        "sortable": true,
        "filterable": false,
        "resizable": false,
        "type": "datetime"
      }
    ],
    "defaultSort": "UID ASC",
    "rowKey": "ListSampleId",
    "multiselect": true,
    "events": {
      "onSelectionChanged": {
        "active": false,
        "actions": [
          "onChangeSegment"
        ],
        "targets": [],
        "parameters": []
      }
    },
    "minHeight": "300px",
    "pagerType": "",
    "pageSize": "1000",
    "rowHeight": "80",
    "style-marginBottom": "20px"
  },
  {
    "key": "container_6",
    "data-buildertype": "container",
    "style-float": "left",
    "children": [
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Assign",
        "primary": true,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "saveDplySampleOwner"
            ],
            "targets": [
              "allSamplesGv"
            ],
            "parameters": []
          }
        }
      },
      {
        "key": "button_4",
        "data-buildertype": "button",
        "content": "Cancel",
        "primary": false,
        "events": {
          "onClick": {
            "active": true,
            "actions": [
              "redirectToForm"
            ],
            "targets": [],
            "parameters": [
              {
                "name": "formName",
                "value": "QNN_DPLY"
              }
            ]
          }
        },
        "secondary": true,
        "inverted": false
      }
    ],
    "style-marginBottom": "20px",
    "style-marginTop": "40px",
    "style-width": "100%"
  }
]' WHERE [Id]='b2c5fd29-64a3-4d9a-8cc2-5a3c9c739089';

UPDATE [dwMetadata] SET
[Id]='62be1681-cb69-4112-ba0b-9cfb32724b58', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplysampleowner-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.687', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-12 21:37:20.300', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "dplysampleowner",
  "lastUpdate": "2022-06-12T21:37:20.2995706+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [],
  "dataMap": [
    {
      "id": "34391a2b-1065-a24c-92d0-85d7735bfec8",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "80c4025d-a1b5-5d93-5825-279725028d24",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "901c16d0-fc25-1b61-376d-23fb0270d404",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f68a406e-8da0-3479-796a-8034e07ab61d",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ee1f9e69-af87-3801-92f7-984865afd1f2",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ec31d1c7-abab-ee75-1ea1-d5a4346af1dc",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "494fd8af-a728-ec33-85f6-0af37d245a95",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5f351be5-0f67-0a8b-6371-2b6c853a14c9",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8611ba8b-fbe4-d5de-9f6c-0f2da88957e0",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "582e7cf7-a157-58ea-0a32-d4cdf3d6e93e",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2eb47227-6587-2c5e-5ba0-8eba482acbbf",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e15f706b-222a-69d6-74d9-87f010610132",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2a936e4-8700-3413-e949-d295f795d7c3",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4bbacc00-08b7-1a35-0816-8a811350d70e",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "529dd847-2c5f-e16f-314e-2a9656ad132a",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "305bf785-7173-fcaa-20ae-5df19a961475",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "327346e6-06cc-4bd5-afd1-b254444eca88",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "616c46b2-cd55-c8c1-2123-e074381efaaa",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8e08ced6-654c-10b7-e3b9-25ff194e095d",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6cea3e31-785d-665a-031f-d4a8503decd6",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ec1adc3-17cd-5f4d-99ce-ab681ea403b6",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b273e574-cf6a-fa2e-58ff-3abaf5673ffd",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a2a96cb8-ab98-3c5e-30b6-af24cac00789",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "32d4e95b-0618-3fbc-7442-25198e6ef924",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a7da9872-3d06-d7b8-e9c4-82e7236aa0e8",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a12c806-22e9-0f25-bdc3-3c857901e249",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8928f0c8-f551-a819-8d91-5d2a91ef0866",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "b6b6da2e-3c1b-1dde-97cb-933734f8df6c",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2bb247d9-656f-67af-0b35-43adf04bfdeb",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "506dc64a-746b-87c8-e5fe-371de29ef82e",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ad33eaa-9824-b038-915c-a4df2b4d830d",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "13150b13-0d45-bd6d-5dd4-d879689d3d79",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "54e9d9d4-b1a8-5f3f-bd39-a96d7be510e3",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e96d833-4957-cd10-f586-f75aa8ffb37a",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4040f278-5916-ed95-b802-c811002bbbbd",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f38f9500-2322-2115-1841-736523cf5af9",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "fdaf4c32-aca9-d483-a117-6c2b8ea2261c",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e0bdca9d-5e7b-73c6-8e26-f03dde3a1217",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "4e06c910-cc36-c093-f646-2320378a3dc2",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "38be3a79-f383-c763-2935-7f6a313294cb",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ef758958-77a4-025b-2dd8-916e1361618d",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0e65662c-3fb6-0f60-64a2-779ec1323a80",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "24a77797-abf2-d920-5b82-de61d9c99498",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "88109494-aae6-b1bb-9d3a-97042849ba53",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2ed5b9f7-2bde-51c0-18dc-4ad5a90c5cc2",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aac70eda-94a7-5f99-e02e-3000669c6390",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "67119abd-97a2-adaf-c2a9-28fb3359ec6e",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ce8a0908-29b2-5b13-487b-8e6563000310",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "ea175f7a-7e3d-57c2-4c24-1c42bf7bd774",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "69935918-6f30-b098-6cb4-9859e5448f31",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e5cc2a93-560e-0658-580b-de5321f96ec5",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "111923d6-c888-2568-6f10-ec57c5a05add",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [
    {
      "id": "aaa3da2f-c61a-be36-b038-4a75685a31aa",
      "entityId": "38c282f1-ed5f-4147-b1ec-15672887b2a6",
      "filter": "FilterByModelId",
      "parameter": "{\"DplyId\": \"@Id\"}",
      "control": "allSamplesGv",
      "dataMap": [
        {
          "id": "2ac3de9b-b838-4348-f65a-9a13e63494b2",
          "attributeId": "81ed3e34-35d5-4293-83c1-7cbfe68e3bfc",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3e75a3e8-92e3-f620-4d9f-a430b6bbe8ea",
          "attributeId": "0cad3427-e00d-4091-a837-4fbe369037d2",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f603f242-573d-7ad5-c8d1-ee2c71dcb01e",
          "attributeId": "31ff9d95-c8fe-4436-bd9f-3148f7964eef",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f94e43e-5975-8b9d-d7d8-a18964901beb",
          "attributeId": "21df80a6-9380-4992-8b9c-1bc040ffdc09",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "099dd1e0-c573-7395-e2ae-51409af019b6",
          "attributeId": "c0daca23-832d-4543-ab20-85d7b2a2dd11",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7237b376-742d-b56d-661b-a1344961df2d",
          "attributeId": "46efd4ac-7393-4398-9de4-b37f5676d776",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0a24f795-ebdf-5eb0-fe3d-c9f52a40ceba",
          "attributeId": "fa66bc60-0745-40c3-8497-7219b9e4ac9d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c56e202c-8bd2-693c-83b1-12d58583c076",
          "attributeId": "7c4704bb-1c10-48de-a8cc-ba14213ced08",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "09f39cb0-167d-ee6b-40d1-ff7d7e4d2297",
          "attributeId": "093acf4e-c585-4857-9ce1-2e2a3bd40bd1",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "3d66f304-1a43-841a-bf47-17bf830baf22",
          "attributeId": "334c1eb4-621a-4fd4-b42c-a0c09b1d485e",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "ecb54863-49ab-1f20-bcad-af4ebf88f2ba",
          "attributeId": "8519f434-3b1f-4630-8e85-73f9e9df1e3a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b2a7a2d4-e369-c980-fe7e-e5e81b4033d1",
          "attributeId": "36f65289-3b9c-4acf-94d8-a24d202347f8",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "f5417f5e-56a6-2b7a-467c-866a527ce8af",
          "attributeId": "ae54d6ea-63a0-46b1-a710-7f4face4d54c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "45b6ad5f-f6b9-bb80-29b1-a54dfc576631",
          "attributeId": "98a16621-02c1-40e2-99ed-2caa2dc87896",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5a2470d8-1a97-fb43-c960-fb467fc17000",
          "attributeId": "37449e09-0d4f-460b-b5f1-a9136d721637",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "d2fc8498-3c58-5824-4735-cba9bc491d34",
          "attributeId": "09fa3e73-1950-4266-b5d3-201ee2746355",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__allSamplesGv_totalcount"
    },
    {
      "id": "f4b1abdd-32c6-e4c4-c8fb-313b0cbead9e",
      "entityId": "c87f2169-d643-4f6e-b3e2-f78161f6b524",
      "filter": "FilterByModelId",
      "parameter": "{\"DplyId\": \"@Id\"}",
      "control": "dataEditorGv",
      "dataMap": [
        {
          "id": "49bd8372-da50-0b02-8885-7572ac6a5b58",
          "attributeId": "6fb2bd3a-8e4d-4d9e-be37-981ac7e01b39",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0ac05402-159a-647d-754b-941b8e9fa9d8",
          "attributeId": "d71416f5-6203-4cbb-b6bb-82016dce1ac6",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9504c229-638a-6084-a623-dd821437b641",
          "attributeId": "2950cd56-0353-4684-818e-87e637f534ef",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1fc40af5-8075-d06d-52b3-63966c0a7de4",
          "attributeId": "6c9b6ff0-837b-492d-8ead-7ae8f580e603",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "21c5fb99-aa69-b882-c7e6-884bdfd80a97",
          "attributeId": "b2a042de-ca11-4db3-bab5-787935fd227c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "9d01919c-cb4e-faad-3e75-f8ac71134e67",
          "attributeId": "be8725e3-d9e8-4903-a536-ab3db65b4a47",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1d60b106-b204-737c-00f3-746ef6f3536b",
          "attributeId": "12628804-e355-41ac-bf17-f250d0c24c5d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "5f732bd2-a960-3654-605c-c8d530319a6f",
          "attributeId": "9641e443-8ea5-4530-a8cc-152dea2c2f9d",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "7daf3399-57a9-c29e-50c2-67907347001c",
          "attributeId": "d844c2aa-50d5-410c-97d4-4f4d3921f87a",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "c7e43ece-3eed-cb32-0c45-e47f77fbcab8",
          "attributeId": "6f6c4c1c-ecad-459a-8d90-e6e1106eee07",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "b47c6161-2c61-dc1a-f94a-9750787c1796",
          "attributeId": "135e83e8-f029-483e-8abd-03d84938595b",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "2380e3be-276a-1c6a-f4b1-5438d5706650",
          "attributeId": "b094760f-ce22-4dfc-bd5d-e1a7de893b69",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "db33cfcb-3def-8ce9-d4be-2389f0f6a070",
          "attributeId": "451a89eb-980d-4524-811c-ab10bf56af3c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1bb8aa12-8695-0418-014b-6f15682c1913",
          "attributeId": "fc29b4df-54fe-427f-8158-fede2f29c3d5",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "6cb03d2f-59f0-4a9e-d1c7-06fed12441ce",
          "attributeId": "ecb87cef-ee39-4339-9372-0504ef38d63c",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "10498e3b-0a9d-94fe-f8a9-335ed544c62a",
          "attributeId": "31adbd84-3b88-47f9-b9a2-d7f2ec621697",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "1019b069-f084-b48e-b385-f3c77f6d7b80",
          "attributeId": "d2a4d876-ff9c-4e91-9679-35d20b585580",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "0610a92b-86c1-3557-d587-63996c019694",
          "attributeId": "0ec2deb7-88ed-4fab-8233-9a8f8547cd51",
          "isEditable": true,
          "isLoadable": true
        },
        {
          "id": "e85b321b-1d3b-1995-697c-ca214ce35d0c",
          "attributeId": "4d5db008-b458-41d3-b0bf-013783623181",
          "isEditable": true,
          "isLoadable": true
        }
      ],
      "readOnly": false,
      "totalCountPropertyName": "__dataEditorGv_totalcount"
    }
  ],
  "securityGroup": "SetDataEditor"
}' WHERE [Id]='62be1681-cb69-4112-ba0b-9cfb32724b58';

UPDATE [dwMetadata] SET
[Id]='a6712791-65c1-463b-bd07-3a2bdac69c68', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplysampleowner-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.640', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2022-06-12 22:47:50.793', 
[Data]=N'{   
    logToConsole: function(args){
        $(".react-grid-Canvas").trigger(''click'');
        console.log(''logToConsole args'', args.component.refs.allSamplesGv);
        console.log("Assigned samples ", args);
    },
    
    deleteAllAssignment: function(args){
        const dplyId = args.data.Id;
        const dataEditorGv = args.component.refs.dataEditorGv;
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append("dplyId", dplyId);  
        Utils.postFormRequest("/deployment/deleteAllDataEditors", formData).then(
            response => {
                dataEditorGv.refresh();
                alertify.success(response.message);
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    deleteDplySampleOwner: function(args){
        //expects the assignment grid as control ref
        const dataEditorGv = args.component.refs.dataEditorGv;
        const dplyId = args.data.Id;
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        if(gridSelectedIndexes.length===0){
            alertify.error("No assignments selected"); 
            return {};
        }
        
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''sampleOwnerIds'', gridSelectedIndexes.map( i => gridItems[i].lsoId ) );  
        Utils.postFormRequest("/deployment/deleteDataEditor", formData).then(
            response => {
                dataEditorGv.refresh();
                alertify.success(response.message);
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    saveDplySampleOwner: function(args){
        if(!args.data.DataEditor) {
            alertify.error("No Data Editor selected");  
            return {};
        }
        const dataEditorGv = args.component.refs.dataEditorGv;
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        if(gridSelectedIndexes.length===0){
            alertify.error("No assignments selected"); 
            return {};
        }
        const listSampleIds = gridSelectedIndexes.map(i => gridItems[i].ListSampleId);
        const formData = new FormData();
        formData.append("userId", args.data.DataEditor); //array
        formData.append("dplyId", args.data.Id);
        formData.append("listSampleIds", listSampleIds);
        Utils.loadingStart("Assigning Data Editors...");
        Utils.postFormRequest("/deployment/setDataEditor", formData).then(
            response => {
                dataEditorGv.refresh();
                alertify.success(response.message);
            }, reason => {
                console.error("Failed to save assignments", reason);
                alertify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },

    onChangeDataEditor: function(args){
        
        var data = args.data;
        var selectedDataEditors = data.DataEditor;
        var filterArr = [];
        
        if(!selectedDataEditors || !selectedDataEditors.length){
            
            return {
                app: {
                    form: {
                        filters: {
                            main: {
                                    dataEditorGv: []
                                }
                        }
                    }
                }
            };
        }
        
        for(var i = 0; i < selectedDataEditors.length; i++){
            filterArr.push(selectedDataEditors[i]);
        };
        
        var filterObj = {
            column: "UserId",
            term: "in",
            value: filterArr
        };
        
       return {
                app: {
                    form: {
                        filters: {
                            main: {
                                    dataEditorGv: [filterObj]
                                }
                        }
                    }
                }
            };
    },
    
    closeModal: function(args){
         args.component.refs.filterModal.close();
    },
    
    clearGridCheckboxes: function(args){
         args.controlRef.state.selectedIndexes = [];
    }
    
}' WHERE [Id]='a6712791-65c1-463b-bd07-3a2bdac69c68';

