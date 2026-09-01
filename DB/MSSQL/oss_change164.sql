-- Will UPDATE existing row(s) in dwMetadata for the following:
-- base.json
-- QNN_DPLY.json
-- QNN_DPLY-settings.json

UPDATE [dwMetadata] SET
[Id]='cb82c0f3-8ea8-42a5-aad7-cc6f3e07053a', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/localization', [FileName]=N'base.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:10.700', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-28 20:38:12.137', 
[Data]=N'{
  "common": {
    "dateFormat": "DD MMM YYYY",
    "timeFormat": "HH:mm"
  },
  "msg": {
    "addSampleConfirmTitle": "Add List Samples",
    "addSampleConfirmText": "Are you so sure you want to add new samples from the list to this deployment?",
    "submitSurveyConfirmTitle": "Survey Submission",
    "submitSurveyConfirmText": "Are you so sure you want to submit survey?",
    "deleteListSamplesConfirmTitle": "Remove List Samples from Sample List",
    "deleteListSamplesConfirmText": "WARNING: Removing the samples from this list will also delete all their related data in deployments that use this list INCLUDING RESPONSE DATA. Are you absolutely sure you want to continue?",    
    "deletionConfirmTitle": "Deletion Confirmation",
    "deletionConfirmText": "All the data related with selected records will be deleted. Are you so sure you want to continue?",
    "deleteSampleConfirmTitle": "Delete Samples",
    "deleteSampleConfirmText": "WARNING: ALL the data related with selected samples will be deleted, INCLUDING RESPONSE DATA, sample list properties and etc. Are you absolutely sure you want to continue?",    
    "disableSamplesConfirmTitle": "Disable Samples",
    "disableSamplesConfirmText": "The selected sample''s status will be set to inactive in this list, making them inactive in deployments using this list (existing response data will NOT be deleted and you can re-enable them later). Continue?",  
    "createDplyConfirmTitle": "Create deployment?",
    "createDplyConfirmText": "Please confirm that you are ready to continue with the deployment record creation now. (Note: Certain deployment settings may only be specified before creating the deployment record and are not subsequently adjustable)"

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
[Id]='655275cf-8202-4438-b66b-874eab315889', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.393', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-29 16:32:01.927', 
[Data]=N'[
  {
    "key": "container_6",
    "data-buildertype": "container",
    "children": [
      {
        "key": "cntDeploymentTitle",
        "data-buildertype": "container",
        "children": [
          {
            "key": "header_1",
            "data-buildertype": "header",
            "content": "Deployment",
            "size": "huge",
            "textAlign": "left",
            "subheader": ""
          }
        ],
        "style-float": ""
      },
      {
        "key": "container_23",
        "data-buildertype": "container",
        "children": [
          {
            "key": "workflowbar_1",
            "data-buildertype": "workflowbar",
            "events": {
              "onCommandClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowExecuteCommand",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              },
              "onSetStateClick": {
                "active": true,
                "actions": [
                  "validate",
                  "save",
                  "workflowSetState",
                  "refresh"
                ],
                "targets": [],
                "parameters": []
              }
            },
            "blockSetState": true,
            "other-visibleConition": ""
          },
          {
            "key": "container_21",
            "data-buildertype": "container",
            "children": [
              {
                "key": "staticcontent_1",
                "data-buildertype": "staticcontent",
                "content": "<strong>State:</strong> {StateName}",
                "isHtml": true
              }
            ]
          },
          {
            "key": "form_3",
            "data-buildertype": "form",
            "children": [
              {
                "key": "Remarks",
                "data-buildertype": "textarea",
                "label": "",
                "fluid": true,
                "style-width": "",
                "reference": "Remarks",
                "events": {},
                "placeholder": "Please append your remarks",
                "style-customcss": "ui fluid input",
                "other-required": false
              }
            ]
          },
          {
            "key": "formgroup_9",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": []
          }
        ],
        "style-source": "",
        "style-customcss": "ui message",
        "other-visibleConition": "data.Id && data.EnableWorkflow"
      },
      {
        "key": "formgroup_10",
        "data-buildertype": "formgroup",
        "widths": "equal",
        "children": [
          {
            "key": "container_22",
            "data-buildertype": "container",
            "style-float": "right",
            "children": [
              {
                "key": "cntImportModal",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "importModal",
                    "data-buildertype": "swzmodal",
                    "style-source": "float: right;",
                    "secondary": true,
                    "content": "Import Response",
                    "style-display": "none",
                    "children": [
                      {
                        "key": "importModalForm",
                        "data-buildertype": "form",
                        "children": [
                          {
                            "key": "header_3",
                            "data-buildertype": "header",
                            "content": "Import Response",
                            "size": "medium",
                            "events": {},
                            "other-visibleConition": ""
                          },
                          {
                            "key": "listFile",
                            "data-buildertype": "input",
                            "label": "",
                            "fluid": true,
                            "onChangeTimeout": 200,
                            "type": "file",
                            "style-marginTop": "10px"
                          },
                          {
                            "key": "totalRows",
                            "data-buildertype": "header",
                            "content": "Total rows: {totalRows}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalRows!= null && data.totalRows!= undefined)"
                          },
                          {
                            "key": "totalSampleResponseAdded",
                            "data-buildertype": "header",
                            "content": "Rows added: {totalSampleResponseAdded}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalSampleResponseAdded!= null && data.totalSampleResponseAdded!= undefined)"
                          },
                          {
                            "key": "totalSampleNoResponse",
                            "data-buildertype": "header",
                            "content": "Rows not added (No response): {totalSampleNoResponse}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                          },
                          {
                            "key": "totalInvalidUIDs",
                            "data-buildertype": "header",
                            "content": "Rows not added (Invalid UID): {totalInvalidUIDs}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidUIDs!= null && data.totalInvalidUIDs!= undefined)"
                          },
                          {
                            "key": "totalInvalidQnnColumns",
                            "data-buildertype": "header",
                            "content": "Total invalid columns: {totalInvalidQnnColumns}",
                            "size": "small",
                            "events": {},
                            "other-visibleConition": "(data.totalInvalidQnnColumns!= null && data.totalInvalidQnnColumns!= undefined)"
                          },
                          {
                            "key": "moreModal",
                            "data-buildertype": "swzmodal",
                            "style-source": "",
                            "secondary": true,
                            "content": "More information",
                            "style-display": "none",
                            "children": [
                              {
                                "key": "invalidQnnColumnsForm",
                                "data-buildertype": "form",
                                "children": [
                                  {
                                    "key": "innerInvalidQnnColumnsForm",
                                    "data-buildertype": "form",
                                    "children": [
                                      {
                                        "key": "cntInvalidQnnColumns",
                                        "data-buildertype": "container",
                                        "style-float": "right",
                                        "children": [
                                          {
                                            "key": "invalidQnnColumns",
                                            "data-buildertype": "header",
                                            "content": "Invalid columns:  {totalInvalidQnnColumns}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_1",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidColumns"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "(data.invalidQnnColumns!= undefined && data.invalidQnnColumns.length > 0)"
                                          },
                                          {
                                            "key": "invalidUIDs",
                                            "data-buildertype": "header",
                                            "content": "Invalid rows (UID): {totalInvalidRows}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_2",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidUIDs"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "(data.invalidUIDs!= undefined && data.invalidUIDs.length > 0)"
                                          },
                                          {
                                            "key": "totalInvalidDates_Updated",
                                            "data-buildertype": "header",
                                            "content": "Total invalid date start and complete: {totalInvalidDates_Updated}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "(data.totalInvalidDates_Updated!= undefined && data.totalInvalidDates_Updated.length > 0)",
                                            "style-hidden": true
                                          },
                                          {
                                            "key": "invalidDates_Updated",
                                            "data-buildertype": "header",
                                            "content": "Invalid date start and complete : {totalInvalidDates_Updated}",
                                            "size": "small",
                                            "events": {},
                                            "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                          },
                                          {
                                            "key": "breadcrumb_3",
                                            "data-buildertype": "breadcrumb",
                                            "items": [
                                              {
                                                "text": "Download",
                                                "url": ""
                                              }
                                            ],
                                            "events": {
                                              "onItemClick": {
                                                "active": true,
                                                "actions": [
                                                  "downloadInvalidDates"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "( data.invalidDates_Updated!= undefined && data.invalidDates.length > 0)"
                                          },
                                          {
                                            "key": "button_1",
                                            "data-buildertype": "button",
                                            "content": "Cancel",
                                            "style-customcss": "",
                                            "primary": false,
                                            "events-onClick": true,
                                            "events-onClick-actions": [
                                              "gridAdd"
                                            ],
                                            "events": {
                                              "onClick": {
                                                "active": true,
                                                "actions": [
                                                  "closeMoreModal"
                                                ],
                                                "targets": [],
                                                "parameters": []
                                              }
                                            },
                                            "other-visibleConition": "",
                                            "style-source": "float: right;",
                                            "inverted": false,
                                            "secondary": true
                                          }
                                        ],
                                        "style-marginRight": "",
                                        "style-width": "100%",
                                        "style-marginBottom": "",
                                        "style-source": ""
                                      }
                                    ],
                                    "style-source": "overflow-y: auto;\noverflow-x: auto;"
                                  }
                                ],
                                "style-source": "overflow-y: auto;\noverflow-x: auto;"
                              }
                            ],
                            "size": "",
                            "events": {
                              "onClick": {
                                "active": false,
                                "actions": [],
                                "targets": [],
                                "parameters": []
                              }
                            },
                            "other-customValidation": "",
                            "other-visibleConition": "(data.invalidUIDs != null && data.invalidUIDs != undefined)"
                          },
                          {
                            "key": "container_17",
                            "data-buildertype": "container"
                          },
                          {
                            "key": "formgroup_7",
                            "data-buildertype": "formgroup",
                            "widths": "equal"
                          },
                          {
                            "key": "cntImportDialogButtons",
                            "data-buildertype": "container",
                            "style-float": "right",
                            "children": [
                              {
                                "key": "btnImportCancel",
                                "data-buildertype": "button",
                                "content": "Cancel",
                                "style-customcss": "",
                                "primary": false,
                                "events-onClick": true,
                                "events-onClick-actions": [
                                  "gridAdd"
                                ],
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "closeModal"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                },
                                "other-visibleConition": "",
                                "style-source": "float: right;",
                                "inverted": false,
                                "secondary": true
                              },
                              {
                                "key": "btnImportSave",
                                "data-buildertype": "button",
                                "content": "Save",
                                "style-customcss": "",
                                "primary": true,
                                "events-onClick": true,
                                "events-onClick-actions": [
                                  "gridAdd"
                                ],
                                "events": {
                                  "onClick": {
                                    "active": true,
                                    "actions": [
                                      "submitFile"
                                    ],
                                    "targets": [],
                                    "parameters": []
                                  }
                                },
                                "other-visibleConition": "",
                                "style-source": "float: right;"
                              }
                            ],
                            "style-marginRight": "",
                            "style-width": "100%",
                            "style-marginBottom": "10px"
                          }
                        ],
                        "style-source": "overflow-y: auto;\noverflow-x: auto;"
                      }
                    ],
                    "size": "",
                    "events": {
                      "onClick": {
                        "active": false,
                        "actions": [],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-visibleConition": "data.Id && CloverApp.API.checkRole(''Admins'')",
                    "style-marginLeft": ""
                  }
                ],
                "style-float": "right",
                "style-marginLeft": "",
                "other-visibleConition": ""
              },
              {
                "key": "container_8",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "buttonManageMessageHistory",
                    "data-buildertype": "button",
                    "content": "Manage Message History",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
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
                            "value": "dplyMessages"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  },
                  {
                    "key": "buttonManageListSamples",
                    "data-buildertype": "button",
                    "content": "Manage List Samples",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
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
                            "value": "dplyListSample"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  }
                ],
                "style-float": "right",
                "style-marginLeft": "",
                "style-marginRight": "3.5px"
              },
              {
                "key": "container_12",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "buttonManageDataEditors",
                    "data-buildertype": "button",
                    "content": "Manage Data Editors",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirectToForm"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "dplySampleOwner"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
                    "floated": "right"
                  },
                  {
                    "key": "buttonManagePrePopulate",
                    "data-buildertype": "button",
                    "content": "Manage Pre-Populate",
                    "events": {
                      "onClick": {
                        "actions": [
                          "redirectToForm"
                        ],
                        "active": true,
                        "targets": [],
                        "parameters": [
                          {
                            "name": "formName",
                            "value": "QNN_DPLY_PRE_POPULATE"
                          }
                        ]
                      }
                    },
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null && CloverApp.API.checkRole(''PrePopulate'')",
                    "floated": "right"
                  },
                  {
                    "key": "button_5",
                    "data-buildertype": "button",
                    "content": "Manage Validation Data",
                    "secondary": true,
                    "other-visibleConition": "data.Id!=null",
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
                            "value": "dplyValidation"
                          }
                        ]
                      }
                    },
                    "floated": "right"
                  },
                  {
                    "key": "btnManageRecurringDeployments",
                    "data-buildertype": "button",
                    "content": "Manage Recurring Deployments",
                    "secondary": true,
                    "floated": "right",
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
                            "value": "dplyRecurrence"
                          }
                        ]
                      }
                    },
                    "other-visibleConition": "data.Id!=null"
                  }
                ],
                "style-float": "right",
                "style-width": "100%",
                "style-marginTop": "15px"
              }
            ]
          }
        ]
      }
    ],
    "style-width": "100%",
    "style-float": "right"
  },
  {
    "key": "container_1",
    "data-buildertype": "container",
    "style-width": "100%",
    "style-source": "clear: both;",
    "style-marginTop": "",
    "style-marginBottom": "20px"
  },
  {
    "key": "cntMainContainer",
    "data-buildertype": "container",
    "children": [
      {
        "key": "MainForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "cntBasicProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerBasicProperties",
                "data-buildertype": "header",
                "content": "Basic Properties",
                "size": "medium"
              },
              {
                "key": "formgroup_BasicPropertiesMain",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "textName",
                    "data-buildertype": "input",
                    "label": "Deployment Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": true,
                    "events": {},
                    "reference": "Deployment Name"
                  },
                  {
                    "key": "SurveyName",
                    "data-buildertype": "input",
                    "label": "Displayed Survey Name",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "other-customValidation": "",
                    "other-required": true,
                    "events": {},
                    "reference": "Survey Name"
                  },
                  {
                    "key": "dictCategory",
                    "data-buildertype": "dictionary",
                    "label": "Category",
                    "fluid": true,
                    "selection": true,
                    "dataModel": "QNN_CATEGORY",
                    "placeholder": "Select category...",
                    "columns": "Name ASC",
                    "search": true,
                    "other-required": false,
                    "other-readOnlyConition": "",
                    "clearable": true,
                    "filters": "[{\"column\":\"Type\", \"value\":\"D\", \"term\":\"=\"}]"
                  },
                  {
                    "key": "dictQuestionnaire",
                    "data-buildertype": "dictionary",
                    "label": "Form Properties (Questionnaire) ~",
                    "fluid": true,
                    "selection": true,
                    "search": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "dropdownQuestionnaireOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "onChangeTimeout": "",
                    "dataModel": "QNN_QNN",
                    "columns": "Title ASC",
                    "placeholder": "Select a form properties...",
                    "other-required": true,
                    "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                    "other-readOnlyConition": "(data.Id?true:false)",
                    "reference": "Form Properties"
                  },
                  {
                    "key": "dictList",
                    "data-buildertype": "dictionary",
                    "label": "Sample List ~",
                    "fluid": true,
                    "selection": true,
                    "dataModel": "QNN_LIST",
                    "columns": "Name ASC",
                    "search": true,
                    "events": {},
                    "placeholder": "Select a sample list...",
                    "other-required": true,
                    "style-source": "",
                    "other-customValidation": "value!=\"00000000-0000-0000-0000-000000000000\"?true:''is required!''",
                    "other-readOnlyConition": "(data.Id?true:false)",
                    "other-visibleConition": "",
                    "reference": "Sample List"
                  }
                ]
              },
              {
                "key": "container_5",
                "data-buildertype": "container",
                "events": {},
                "style-source": "clear:both;"
              }
            ],
            "style-marginBottom": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
          },
          {
            "key": "cntResponseProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "headerResponseProperties",
                "data-buildertype": "header",
                "content": "Response Properties",
                "size": "medium"
              },
              {
                "key": "formGroupStartEndDate",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "DateStart",
                    "data-buildertype": "input",
                    "label": "Start On",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "datetime",
                    "style-width": "100%",
                    "events": {},
                    "style-source": "z-index: 1000;",
                    "style-marginLeft": "32px",
                    "other-readOnlyConition": "",
                    "other-required": true
                  },
                  {
                    "key": "DateEnd",
                    "data-buildertype": "input",
                    "label": "End On",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "datetime",
                    "other-readOnlyConition": "",
                    "other-required": true,
                    "style-source": "z-index: 1000;"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_5",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "VisibleToRespondent",
                    "data-buildertype": "checkbox",
                    "label": "Visible to Respondent",
                    "defaultValue": "True",
                    "toggle": false,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "slider": false,
                    "fitted": false
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_1",
                "data-buildertype": "formgroup",
                "widths": "custom",
                "widthsCustom": "2",
                "children": [
                  {
                    "key": "MaxResponse",
                    "data-buildertype": "input",
                    "label": "Maximum Number of Respondents (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "events": {},
                    "defaultValue": "-1",
                    "style-width": "10em",
                    "reference": "Maximum Number of Respondents"
                  },
                  {
                    "key": "DaysUpdate",
                    "data-buildertype": "input",
                    "label": "Days for Update after Submission (-1 is unlimited)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "type": "number",
                    "defaultValue": "0",
                    "events": {},
                    "style-width": "10em",
                    "reference": "Days for Update"
                  }
                ],
                "orientation": "inline"
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "fg_RecurrenceInfo",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "events": {},
            "children": [
              {
                "key": "staticcontent_2",
                "data-buildertype": "staticcontent",
                "content": "This is a recurring deployment."
              },
              {
                "key": "RecurrenceNextDate",
                "data-buildertype": "input",
                "label": "Next Deployment Start On",
                "fluid": true,
                "onChangeTimeout": 200,
                "type": "datetime",
                "style-width": "100%",
                "events": {},
                "style-source": "z-index: 1000;",
                "style-marginLeft": "32px",
                "other-readOnlyConition": "",
                "other-required": false,
                "readOnly": true
              }
            ],
            "style-width": "",
            "widthsCustom": "3",
            "orientation": "grouped",
            "other-visibleConition": "data.RecurrenceEnabled"
          },
          {
            "key": "cntSurveyFeatures",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_6",
                "data-buildertype": "header",
                "content": "Survey Features",
                "size": "medium"
              },
              {
                "key": "formgroup_IsExcelEnabled",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsExcelEnabled",
                    "data-buildertype": "checkbox",
                    "label": "Enable Online Excel Support",
                    "defaultValue": "",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_RequireAccessCode",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "RequireAccessCode",
                    "data-buildertype": "checkbox",
                    "label": "Require Delegation Access Code",
                    "defaultValue": "",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    }
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_EnableWorkflow",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "EnableWorkflow",
                    "data-buildertype": "checkbox",
                    "label": "Use Workflow ~",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "setDplyState",
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": "data.Id",
                    "reference": "Enable Workflow"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "formgroup_IsMultipleResponse",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "IsMultipleResponse",
                    "data-buildertype": "checkbox",
                    "label": "Allow Multiple Responses ~",
                    "defaultValue": "0",
                    "toggle": true,
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "updateFeatureInteraction"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-required": false,
                    "other-readOnlyConition": "data.Id"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3"
              },
              {
                "key": "IsAnonymous",
                "data-buildertype": "checkbox",
                "label": "Anonymous Survey ~",
                "defaultValue": "0",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "toggleCompletionUrl",
                      "updateFeatureInteraction"
                    ],
                    "targets": [
                      "textCompleteURL"
                    ],
                    "parameters": []
                  }
                },
                "other-required": false,
                "style-width": "50%",
                "other-readOnlyConition": "data.Id"
              },
              {
                "key": "fgCompletionUrl",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "events": {},
                "children": [
                  {
                    "key": "formgroup_IsAnonymous",
                    "data-buildertype": "formgroup",
                    "widths": "equal",
                    "events": {},
                    "children": [],
                    "style-width": "",
                    "widthsCustom": "3"
                  },
                  {
                    "key": "textCompleteURL",
                    "data-buildertype": "input",
                    "label": "Completion URL (required for Anonymous surveys)",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "placeholder": "",
                    "other-visibleConition": "data.IsAnonymous== ''1'' ? true : false",
                    "events": {},
                    "style-marginLeft": "",
                    "other-customValidation": "!(data.IsAnonymous== ''1''  && !value)? true : '' - Please provide completion URL for anonymous survey''",
                    "style-width": "",
                    "reference": "Completion URL"
                  }
                ],
                "style-width": "",
                "widthsCustom": "3",
                "orientation": "grouped"
              },
              {
                "key": "staticcontent_3",
                "data-buildertype": "staticcontent",
                "content": "<i>(Above options marked with <strong>~</strong> may only be selected before creating the deployment and cannot be enabled later)</i>",
                "isHtml": true
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "headerCompletionProperties",
            "data-buildertype": "header",
            "content": "Completion  Properties",
            "size": "medium",
            "style-hidden": true
          },
          {
            "key": "formgroup_2",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "orientation": "grouped",
            "children": [
              {
                "key": "radioCompletionAction",
                "data-buildertype": "radiogroup",
                "label": "Action",
                "data-elements": [
                  {
                    "key": 1,
                    "value": "C",
                    "text": "Do nothing"
                  },
                  {
                    "key": 2,
                    "value": "R",
                    "text": "Redirect to URL"
                  }
                ],
                "direction": "v",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "radioCompletionActionOnChange"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "defaultValue": "C"
              },
              {
                "key": "textCompleteURL-3",
                "data-buildertype": "input",
                "label": "",
                "fluid": true,
                "onChangeTimeout": 200,
                "placeholder": "Specify redirect url (http://www.google.com)",
                "other-visibleConition": "data.radioCompletionAction== ''R'' ? true : false",
                "events": {},
                "style-marginLeft": "24px"
              }
            ],
            "style-hidden": true
          },
          {
            "key": "container_11",
            "data-buildertype": "container",
            "children": [
              {
                "key": "hedderNavigationProperties",
                "data-buildertype": "header",
                "content": "Navigation Properties",
                "size": "medium"
              },
              {
                "key": "fromGroupNavigationProperties",
                "data-buildertype": "formgroup",
                "widths": "equal",
                "orientation": "grouped",
                "children": [
                  {
                    "key": "radioNavBack",
                    "data-buildertype": "radiogroup",
                    "label": "Back Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "0",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "1",
                        "text": "Show"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavBackOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-marginBottom": "8px",
                    "defaultValue": "0"
                  },
                  {
                    "key": "radioNavCancel",
                    "data-buildertype": "radiogroup",
                    "label": "Cancel Button",
                    "data-elements": [
                      {
                        "key": 1,
                        "value": "N",
                        "text": "Do not show"
                      },
                      {
                        "key": 2,
                        "value": "Y",
                        "text": "Show"
                      },
                      {
                        "key": 3,
                        "value": "YURL",
                        "text": "Show and redirect to URL"
                      }
                    ],
                    "direction": "v",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "radioCompletionNavCancelOnChange"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "defaultValue": "N"
                  },
                  {
                    "key": "textNavCancelUrl",
                    "data-buildertype": "input",
                    "label": "",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "size": "",
                    "placeholder": "Specify redirect url (http://www.google.com)",
                    "style-marginLeft": "24px",
                    "events": {},
                    "other-visibleConition": "data.radioNavCancel == ''YURL'' ? true : false"
                  }
                ]
              }
            ],
            "style-hidden": true
          },
          {
            "key": "cntRestrictionProperties",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_5",
                "data-buildertype": "header",
                "content": "Restriction Properties",
                "size": "medium",
                "style-marginTop": "",
                "style-marginBottom": ""
              },
              {
                "key": "RestrictIp",
                "data-buildertype": "checkbox",
                "label": "IP Restriction",
                "toggle": true,
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "setIpRestriction"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                },
                "reference": "Ip Restriction",
                "style-marginBottom": "20px",
                "defaultValue": "0"
              },
              {
                "key": "RestrictIpInclusive",
                "data-buildertype": "radiogroup",
                "label": "",
                "data-elements": [
                  {
                    "text": "Inclusive",
                    "value": "1"
                  },
                  {
                    "value": "0",
                    "text": "Exclusive"
                  }
                ],
                "defaultValue": "1",
                "other-visibleConition": "data.RestrictIp==1",
                "events": {
                  "onChange": {
                    "active": false,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "countryOrIpRange",
                "data-buildertype": "radiogroup",
                "label": "",
                "data-elements": [
                  {
                    "text": "Countries",
                    "value": "1"
                  },
                  {
                    "text": "IP Ranges",
                    "value": "0"
                  }
                ],
                "defaultValue": "1",
                "other-visibleConition": "data.RestrictIp==1",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [
                      "clearContent"
                    ],
                    "targets": [],
                    "parameters": []
                  }
                }
              },
              {
                "key": "IpCountry",
                "data-buildertype": "dropdown",
                "label": "IpCountry",
                "fluid": true,
                "selection": true,
                "data-elements": [
                  {
                    "key": 1,
                    "value": "SG",
                    "text": "Singapore"
                  },
                  {
                    "value": "MY",
                    "text": "Malaysia"
                  }
                ],
                "multiple": true,
                "reference": "Respondent Country",
                "placeholder": "Select countries",
                "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange==1)",
                "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==1 && data.IpCountry && data.IpCountry!=\"[]\") || (data.countryOrIpRange==0))) || (data.RestrictIp!=1))?true:\"is required\"",
                "events": {}
              },
              {
                "key": "IpRange",
                "data-buildertype": "dropdown",
                "label": "",
                "fluid": true,
                "selection": true,
                "data-elements": [],
                "multiple": true,
                "search": true,
                "allowAddItems": true,
                "reference": "Ip Ranges",
                "placeholder": "192.168.0.0/24 or 192.168.0.0/255.255.255.0 or 192.168.0.0-192.168.0.255",
                "other-customValidation": "(((data.RestrictIp==1) && ( (data.countryOrIpRange==0 && data.IpRange && data.IpRange!=\"[]\") || (data.countryOrIpRange==1))) || (data.RestrictIp!=1) )?true:\"is required\"",
                "other-visibleConition": "(data.RestrictIp==1) && (data.countryOrIpRange!=1)",
                "events": {
                  "onChange": {
                    "active": true,
                    "actions": [],
                    "targets": [],
                    "parameters": []
                  }
                }
              }
            ],
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "style-marginBottom": "20px"
          },
          {
            "key": "cntInitialNotification",
            "data-buildertype": "container",
            "children": [
              {
                "key": "header_2",
                "data-buildertype": "header",
                "content": "Initial Notification Type",
                "size": "medium"
              },
              {
                "key": "staticcontent_4",
                "data-buildertype": "staticcontent",
                "content": "<i>(Initial notification will be sent to all samples in the selected Sample List when the deployment is created)</i>",
                "isHtml": true
              },
              {
                "key": "container_10",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "cbMailMerge",
                    "data-buildertype": "checkbox",
                    "label": "Mail Merge",
                    "slider": true,
                    "toggle": true,
                    "style-marginRight": "20px",
                    "defaultValue": ""
                  },
                  {
                    "key": "cbEmail",
                    "data-buildertype": "checkbox",
                    "label": "Email",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "cbProfile",
                    "data-buildertype": "checkbox",
                    "label": "Generate Profile",
                    "events": {},
                    "toggle": true,
                    "slider": true,
                    "defaultValue": "",
                    "style-marginRight": "20px"
                  },
                  {
                    "key": "breadcrumb_4",
                    "data-buildertype": "breadcrumb",
                    "items": [
                      {
                        "text": "Download Template",
                        "active": false
                      }
                    ],
                    "events": {
                      "onItemClick": {
                        "active": true,
                        "actions": [
                          "downloadEmailTemplate"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "style-width": "100%",
                    "style-source": "padding-top: 20px;"
                  }
                ],
                "style-marginTop": "20px"
              },
              {
                "key": "container_4",
                "data-buildertype": "container",
                "children": [
                  {
                    "key": "emailFrom",
                    "data-buildertype": "input",
                    "label": "From",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "(!data.cbEmail || ( value ? value : \"\" ) !== \"\" ) ? true : ''is required!''",
                    "reference": "Email From"
                  },
                  {
                    "key": "subject",
                    "data-buildertype": "input",
                    "label": "Subject",
                    "fluid": true,
                    "onChangeTimeout": 200,
                    "style-width": "100%",
                    "other-visibleConition": "data.cbEmail",
                    "style-marginBottom": "20px",
                    "other-customValidation": "(!data.cbEmail || ( value ? value : \"\" ) !== \"\" ) ? true : ''is required!''",
                    "reference": "Email Subject"
                  },
                  {
                    "key": "htmlEditor",
                    "data-buildertype": "swzhtml",
                    "hideOutput": "block",
                    "other-visibleConition": "data.cbMailMerge||data.cbEmail",
                    "events": {
                      "onChange": {
                        "active": true,
                        "actions": [
                          "parseHtml"
                        ],
                        "targets": [],
                        "parameters": []
                      }
                    },
                    "other-customValidation": ""
                  }
                ],
                "style-marginTop": "20px",
                "style-marginBottom": "20px"
              }
            ],
            "other-visibleConition": "data.Id==null",
            "style-marginBottom": "20px",
            "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;",
            "events": {}
          }
        ],
        "style-source": ""
      },
      {
        "key": "cntInfoBeforeCreating",
        "data-buildertype": "container",
        "style-marginBottom": "20p",
        "style-source": "",
        "style-customcss": "ui info message",
        "children": [
          {
            "key": "staticcontent_5",
            "data-buildertype": "staticcontent",
            "content": "<i>(After creating the deployment you can perform additional deployment management functions such as assigning data editors, configuring recurrence settings, setting snapshot report options, performing pre-population, etc)</i>",
            "isHtml": true,
            "fetchData": false
          }
        ],
        "other-visibleConition": "(data.Id?false:true)"
      }
    ],
    "style-float": "",
    "style-width": "100%",
    "style-source": "",
    "style-marginTop": "20px",
    "style-marginBottom": "20px"
  },
  {
    "key": "cntReportProperties",
    "data-buildertype": "container",
    "children": [
      {
        "key": "header_4",
        "data-buildertype": "header",
        "content": "Report Properties",
        "size": "medium",
        "style-marginTop": "",
        "style-marginBottom": ""
      },
      {
        "key": "chkScheduler",
        "data-buildertype": "checkbox",
        "label": "Save Snap Shot Daily",
        "toggle": true,
        "events": {
          "onChange": {
            "active": true,
            "actions": [],
            "targets": [],
            "parameters": []
          }
        }
      },
      {
        "key": "container_9",
        "data-buildertype": "container",
        "style-marginTop": "30px",
        "style-marginBottom": "30px"
      },
      {
        "key": "dailySsForm",
        "data-buildertype": "form",
        "children": [
          {
            "key": "ddlEmailReceipients",
            "data-buildertype": "dictionary",
            "label": "Email Recipient/s",
            "fluid": true,
            "selection": true,
            "dataModel": "vSP_dataEditors",
            "columns": "Name ASC",
            "clearable": true,
            "multiple": true,
            "events": {},
            "style-marginTop": "",
            "style-marginBottom": "",
            "other-visibleConition": "",
            "paging": true,
            "search": true
          },
          {
            "key": "container_15",
            "data-buildertype": "container",
            "style-marginTop": "30px",
            "style-marginBottom": "30px"
          },
          {
            "key": "formgroup_4",
            "data-buildertype": "formgroup",
            "widths": "equal",
            "children": [
              {
                "key": "chkEmailSuccess",
                "data-buildertype": "checkbox",
                "label": "Email Success",
                "toggle": true
              },
              {
                "key": "chkEmailFail",
                "data-buildertype": "checkbox",
                "label": "Email Fail",
                "toggle": true
              }
            ],
            "style-marginTop": "30px",
            "style-marginBottom": "30px",
            "orientation": "inline"
          }
        ],
        "other-visibleConition": "(data.chkScheduler != null && data.chkScheduler != 0 ? true: false)",
        "events": {},
        "other-customValidation": "",
        "other-readOnlyConition": ""
      }
    ],
    "other-visibleConition": "data.Id != null",
    "style-marginTop": "",
    "style-marginBottom": "20px",
    "style-source": "border: 1px solid rgba(34,36,38,.15);\npadding: 10px;"
  },
  {
    "key": "container_2",
    "data-buildertype": "container",
    "children": [
      {
        "key": "btnFirstSave",
        "data-buildertype": "button",
        "content": "Create Deployment",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "confirm",
              "onClickSave",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {
                "name": "confirmTitle",
                "value": "createDplyConfirmTitle"
              },
              {
                "name": "confirmText",
                "value": "createDplyConfirmText"
              }
            ]
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": "(data.Id?false:true)",
        "other-customValidation": ""
      },
      {
        "key": "btnSave",
        "data-buildertype": "button",
        "content": "Update Deployment",
        "events": {
          "onClick": {
            "actions": [
              "validate",
              "onClickSave",
              "save",
              "init"
            ],
            "active": true,
            "targets": [],
            "parameters": []
          }
        },
        "size": "",
        "primary": true,
        "other-visibleConition": "(data.Id?true:false)",
        "other-customValidation": ""
      },
      {
        "key": "button_3",
        "data-buildertype": "button",
        "content": "Cancel",
        "events": {
          "onClick": {
            "actions": [
              "redirect"
            ],
            "active": true,
            "targets": [],
            "parameters": [
              {
                "name": "target",
                "value": "/form/SwzDplyList"
              }
            ]
          }
        },
        "secondary": true
      }
    ],
    "style-float": "left",
    "style-marginBottom": "20px",
    "style-marginTop": "30px"
  }
]' WHERE [Id]='655275cf-8202-4438-b66b-874eab315889';

UPDATE [dwMetadata] SET
[Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.340', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-08-29 16:32:02.000', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2021-08-29T16:32:01.999927+08:00",
  "entityId": "95d26a40-bf59-4aef-b578-12b2535f7789",
  "isTemplate": false,
  "triggers": [
    {
      "triggers": [
        "BeforeInsert"
      ],
      "codeAction": "SetFields",
      "parameter": "{\"Status\": 1, \"Target\": \"N\",  \"Type\": \"E\",  \"CreatedDate\": \"@DateNow\", \"CreatedBy\":\"@CurrentUserId\", \"StructDivisionId\": \"@StructDivisionId\"}"
    },
    {
      "triggers": [
        "BeforeUpdate"
      ],
      "codeAction": "SetFields",
      "parameter": " {\"UpdatedDate\": \"@DateNow\", \"UpdatedBy\": \"@CurrentUserId\"}"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyListSampleAsync"
    },
    {
      "triggers": [
        "AfterInsert"
      ],
      "codeAction": "InsertDplyMessageAsync"
    },
    {
      "triggers": [
        "BeforeInsert",
        "BeforeUpdate"
      ],
      "codeAction": "ValidateQnnDplyTrigger"
    }
  ],
  "schemes": [
    "DeploymentRequest"
  ],
  "dataMap": [
    {
      "id": "49dc498b-862f-8db6-c96b-436359c1fe8f",
      "attributeId": "15ce36dc-1fe5-43e2-bf80-2fa1a874e5d9",
      "control": "dictCategory",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09c51019-6736-b903-ba90-49c6648aed13",
      "attributeId": "a5f6d25c-ed79-44b1-9483-9c7b97b3cda2",
      "control": "radioCompletionAction",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "000c5d4f-1fd1-8038-2591-0d619c11d8ee",
      "attributeId": "0b439a8e-8ee5-4c3a-ae08-fa38d90d8aee",
      "control": "textCompleteURL",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d2438929-3329-c80c-347b-9da9c989eff3",
      "attributeId": "b3f0d547-7fc9-4f00-89e8-3b52f41929f5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9dec37ab-922a-3546-4a78-d6b6dbfbf2a9",
      "attributeId": "2bd6090e-c303-478d-b362-89c9191d052a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3da35281-aa29-eddf-9e7b-286819c16b08",
      "attributeId": "494c42e8-0492-4176-ac75-c689a8f5bbc1",
      "control": "DateEnd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "aa74d157-9a98-478e-d389-68f6e93d0118",
      "attributeId": "4d7e5b0e-6dc9-4f0d-831a-dfb3ebdd2ec2",
      "control": "DateStart",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2b3dfd15-2fbb-ba91-0671-7a9e60427bc3",
      "attributeId": "f12f1d43-75f2-42a5-926b-06aedc741df0",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3bdf7e66-15d8-b585-644a-c8ab8460baba",
      "attributeId": "a7b4eb64-b959-4195-aa6a-45ee3824d693",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "c1b23718-7f5e-a000-e54d-d928be553567",
      "attributeId": "c9bb3d9e-52f4-476f-805f-156488685dc2",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "1fddbcc0-83cb-119d-8e03-374668bb8854",
      "attributeId": "db1a037f-f2b1-402f-8a2c-69efb7d43c1f",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "319c8862-be47-1e69-a018-f83506cfa587",
      "attributeId": "4b7eee04-18b0-4153-9c9e-bb32f2fb42e5",
      "control": "textName",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "97cf1d53-28c5-46a1-0570-4988a6104d89",
      "attributeId": "429a264c-e4bc-4db0-bec0-03467deed005",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7ce20b9d-22e3-cdc0-5b10-313082777c45",
      "attributeId": "44907ef9-0d57-4a97-9be2-d58120934253",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2636b43a-a3ea-062a-574f-85d081788a96",
      "attributeId": "56e2dbe8-24fe-4a41-bf0f-820df81ac755",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3190228d-0386-0414-b011-49465dd5116f",
      "attributeId": "783f55a8-aa37-4c72-bf51-fd523e85585a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d61f2305-3c49-14f0-6874-50ec12c9ce67",
      "attributeId": "17b1b7b7-a1f9-4a5f-bcf5-606cf45a8cac",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09a1c46f-5fa4-537b-0d2c-25485bd76070",
      "attributeId": "455e5598-3db3-484c-84a6-148758489688",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3e30afa8-b7b8-876c-4373-81d1d7060dc7",
      "attributeId": "c3ed9b5a-56f8-45dd-846f-af4bfbc3f83c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "09bf95ec-8916-105b-2c75-aae713335918",
      "attributeId": "9b064d69-3d5c-43c6-bfa4-55f931a6328c",
      "control": "DaysUpdate",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9d067751-8f32-8b30-efae-13ca8d1128f7",
      "attributeId": "f69d9378-db54-4893-8e04-fd8ac05a750c",
      "control": "dictList",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "15c4e305-59f8-430d-e37b-fddc34f0480b",
      "attributeId": "639da28f-dca1-4941-863f-131a30734e71",
      "control": "MaxResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9f046ca8-9da9-3947-464b-7b854ef030bd",
      "attributeId": "cef5e883-b266-4f28-8018-cce3605bd68b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "f16cb492-4407-54c3-d6b7-c7e2d65135c2",
      "attributeId": "f3a042c7-e093-4d79-a90c-84030f45c4a4",
      "control": "dictQuestionnaire",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "548a8469-7142-e4f2-83f4-ac0fcbc365f4",
      "attributeId": "0bfc96e9-2108-47a5-9ef5-c98b27673188",
      "control": "radioNavBack",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e736758a-1122-7948-e429-0308aa9d6fb1",
      "attributeId": "f1fac614-5d61-45a3-bb62-35a9219a8609",
      "control": "textNavCancelUrl",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "72f8e742-b794-320f-5dca-aea702eff73e",
      "attributeId": "0c05d708-e49a-4ed3-a5a0-70a3a7f52bea",
      "control": "radioNavCancel",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "8cc321aa-0522-d13a-b458-8a1398b903dd",
      "attributeId": "a3e3f5c2-1c65-4438-b372-c814f2edce5c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "5ff5bbc4-a456-559e-c4a0-97641498a8ad",
      "attributeId": "30375b7a-d4f1-48b1-ae4a-bfdb4a5bdf11",
      "control": "VisibleToRespondent",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "9aabe66a-0436-b54f-3375-aafdfb544635",
      "attributeId": "a32dd165-85de-40f5-879a-d6a7aad5b56d",
      "control": "IpCountry",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "77c80616-2cc4-8e3a-47a1-916e3b253c0a",
      "attributeId": "2fcd5d29-8dab-4bc9-8432-d476be6935a7",
      "control": "IpRange",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "3ed9480e-d106-52bf-6f5b-6055e9675044",
      "attributeId": "36fbf2b4-fdcb-41b7-8f51-6804ff4f6c5a",
      "control": "RestrictIp",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "48323722-f032-b2b1-15ba-2346b03eeaeb",
      "attributeId": "cfe07a04-7fd2-42ab-b5a3-ea8fac6edfb9",
      "control": "RestrictIpInclusive",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "68dd1fb3-a7ba-4da3-e29e-c3c86dc56c1b",
      "attributeId": "471ebb93-a2aa-48fa-9f9f-7af05632750a",
      "control": "IsMultipleResponse",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a2a6881-7799-8e4a-eba7-95a661d41d68",
      "attributeId": "1f9e2803-a0d1-44bd-91a6-79fc4170f63b",
      "control": "IsAnonymous",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "a52af75b-5993-3104-55da-3834eb95fe46",
      "attributeId": "ef8220b1-ac43-47ee-9035-4f7050e1bf1d",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "91a4529a-a930-e58f-8e1f-5267bb706693",
      "attributeId": "389ae941-1466-42de-af26-9f3936a456ad",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "6bac7e8b-eff4-6235-3446-46309d7b5fcd",
      "attributeId": "04cbdcfd-c188-496f-8e63-b0643d1f99c0",
      "control": "EnableWorkflow",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "7d6ec65c-7e41-b878-d192-16e9432da0dd",
      "attributeId": "44d55954-c577-4260-8272-2c97e213c22a",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "e9a73050-00ea-672f-b10e-3138c1b79ab6",
      "attributeId": "5095a227-7c26-4d25-a38d-89c7705bafbc",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "bc809a51-2fad-044b-d321-9454cfe8f0db",
      "attributeId": "8ca2e0c2-a78e-4628-911d-c7b763e99510",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27cb805c-a635-c840-2433-1a87616a5dc0",
      "attributeId": "a340221f-730d-46dd-a258-3bd194e584c7",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "257bf9f6-6af8-0f42-932b-e42a6016483f",
      "attributeId": "257703e3-fba0-4c41-ac90-4b4c35c8727e",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "936d7192-b817-1a15-9916-e032d4e77277",
      "attributeId": "d04c168f-120b-4c27-93db-5aa212bc302b",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "0a647292-82ca-62ea-4608-e916df1a54b9",
      "attributeId": "ebe8dfa3-ca3e-4727-800b-1dab267da292",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "27ecd879-7354-02b8-c642-b8cce602dc9e",
      "attributeId": "9c004ca5-ab2d-49f9-a674-853a7bfd05cd",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "d3fdfdd8-c4ff-5d98-c555-f77268ec9990",
      "attributeId": "4fc894fc-7191-46b4-a60b-eda4c81d4cd5",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "df1e19f4-7444-56ff-da28-26cdb1423e59",
      "attributeId": "5bed353c-44ab-464f-bf21-648f4e487a30",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "cf01c628-9c75-0af4-9cbc-33ebb397e66e",
      "attributeId": "992b4f36-55a1-45ac-b937-026d657af01c",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "163ac591-1545-9b80-cbb1-44eefe356dd0",
      "attributeId": "d9bf0a77-04ba-4fb3-9f6c-34135e8fac25",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "2f7fadb0-ee58-46a1-d654-57eca28fd426",
      "attributeId": "c0e2eee0-7f5f-42ea-878b-8930f0af94e0",
      "control": "IsExcelEnabled",
      "isEditable": true,
      "isLoadable": true
    },
    {
      "id": "020f9a28-e54d-750b-cb60-045ce9ed0c05",
      "attributeId": "d48ad824-a141-47fa-91dc-b5d6f040e879",
      "control": "SurveyName",
      "isEditable": true,
      "isLoadable": true
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}' WHERE [Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd';

