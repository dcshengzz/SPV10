-- Will UPDATE existing row(s) in dwMetadata for the following:
-- QNN_DPLY-settings.json
-- QNN_DPLY-code.js

UPDATE dwMetadata SET
[Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-settings.json', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.340', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-22 18:49:25.217', 
[Data]=N'{
  "isSurvey": false,
  "structDivisionId": "72d461b2-234b-40d6-b410-b261964ba291",
  "name": "QNN_DPLY",
  "lastUpdate": "2021-07-22T18:49:25.2156665+08:00",
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
    }
  ],
  "dataColl": [],
  "securityGroup": "Deployment"
}' WHERE [Id]='98fd848f-df55-4e5a-bbc5-5919f423a1cd';

UPDATE dwMetadata SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2021-07-22 21:45:27.677', 
[Data]=N'{
     checkQnnFields: function(qnnId){
    
        var formData = new FormData();
        formData.append(''qnnId'', qnnId);
        var url = ''/qnn/checkfields'';
    
        fetch(url,
            {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
                if (!response.success) {
                    alertify.alert(response.message);
    
                } 
            })
            .catch(error => {
                alertify.alert(error.message);;
            });
            

    },      
    setDplyState: function(args){
        if(args.data.EnableWorkflow==1){
            if(!args.data.Id){
                CloverApp.API.setDataField("State", "Draft");             
                CloverApp.API.setDataField("StateName", "Draft");                    
            }
        }  
        else{
            CloverApp.API.setDataField("State", "Active");             
            CloverApp.API.setDataField("StateName", "Active");                
        }          
    },
    toggleCompletionUrl: function(args){
        
        if(args.data.IsAnonymous==1){
 
        }  
        else{
            CloverApp.API.setDataField("textCompleteURL", null);              
        }         
    },
    downloadEmailTemplate: function(args){
             var text = '''';
            text += ''ANNUAL SURVEY ON {DplyName} 2020 \n''
            text += ''Purpose of the Survey:\n''
            text +=''The purpose of the Survey is to obtain data of the profile for the period from 1 June to 31 May.\n''
            text +=''Statistics compiled from the collected data will be used to assist in policy-making efforts.\n''
            text +=''Submission of the Questionnaire:\n''
            text +=''We would be grateful if you could return the completed questionnaire by the due date stated above. \n''
            text +='' \n''
            text +=''The following are your login information:\n''
            text +=''Company name: {Name}\n''
            text +=''Username: {UID}\n''
            text +=''Password: {Password}\n''
            text +='' \n''
            
            text +=''Other tokens:\n''
            text +=''Survey Url:{SurveyUrl}\n''            
            text +=''Deployment List Sample Id:{DplySampleInfoId}\n''                
            text +=''UID: {UID}\n''
            text +=''Password: {Password}\n''
            text +=''Questionnaire Name: {DplyQnn}\n''
            text +=''List Name: {DplyList}\n''
            text +=''Deployment Name: {DplyName}\n''
            text +=''Category Name: {DplyCategory}\n''
            text +=''UIDPeer: {UIDPeer}\n''
            text +=''Account Active Status: {ActiveYN}\n''
            text +=''Delegation Code: {DelegationCode} (For deployment that is Required Access Code)\n''
            
             var hiddenElement = document.createElement(''a'');
                hiddenElement.href = ''data:text/csv;charset=utf-8,'' + encodeURI(text);
                hiddenElement.target = ''_blank'';
                hiddenElement.download = ''EmailTemplate.txt'';
                hiddenElement.click();
    },
    downloadInvalidColumns(args){
//        CloverApp.API.setDataField("invalidQnnColumns",[''A11'', ''B22'', ''C33'']);
        
        var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidQnnColumns'');

    },
    downloadInvalidDates(args){

          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidDates_Updated'');
        
    },
    downloadInvalidUIDs(args){

          var downloadFile = function(type) {
            var invalidItems = args.data[type]
            if(invalidItems !== undefined && invalidItems.length > 0){
                var rows = [];
                rows.push(invalidItems);
                let csvContent = "data:text/csv;charset=utf-8,";
            
                rows.forEach(function(rowArray) {
                let row = rowArray.join(",");
                csvContent += row + "\r\n";
                });
        
                var encodedUri = encodeURI(csvContent);
                var link = document.createElement("a");
                link.setAttribute("href", encodedUri);
                link.setAttribute("download", type + ".csv");
                document.body.appendChild(link); // Required for FF
        
                link.click(); 

            }else{
                alert(''No information found'')
            }                 
        } 
        downloadFile(''invalidUIDs'');
        
    },
    viewArgs(args){
      console.log("View Args", args);  
    },
    submitFile(args){
        var token = args.data.listFile;
        var dplyId = args.data.Id;
        var qnnId = args.data.dictQuestionnaire;
        var listId = args.data.dictList;

        var errors = {};
        if (qnnId == null || qnnId == undefined)
         alertify.error("Questionnaire not selected");
        if (listId == null || listId == undefined)    
         alertify.error("List not selected''");
        if (dplyId == null || dplyId == undefined)    
         alertify.error("There is no existing deployment");
         
         if (token == null || token == undefined){
             errors.token = ''Please select csv file'';
                
            if(errors.token){
              throw {
                  level: 1,
                  message: ''Check errors on the form!'',
                  formerrors: {main: errors}
              };
            }
            return {};
        }
        
        var url = ''/deployment/importresponse?token='' + token + ''&qnnId='' + qnnId + ''&listId='' + listId + ''&dplyId='' + dplyId;
        Pace.start();
        $(''body'').loadingModal({
            text: ''Importing...'',
            animation: ''wave'',
            backgroundColor: ''#1262E2''});
            var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
              
                if (response.success) {
                     var _securitySiteIdRewriter = function (model) {
                        model.filters = ''[{"column":"IsDeleted", "value": "0", "term":"="}]'';
                        model.disabled = false;
                    };
                    
                    alertify.success(''The changes have been applied!'');
                    console.log("Response is", response);
                    
                    CloverApp.API.setDataField("totalRows", response.statistics.totalRows);
                    CloverApp.API.setDataField("totalSampleResponseAdded", response.statistics.totalSampleResponseAdded);
                    CloverApp.API.setDataField("totalSampleNoResponse", response.statistics.totalSampleNoResponse);
                    CloverApp.API.setDataField("totalSampleResponseAnsAdded", response.statistics.totalSampleResponseAnsAdded);                    
                    CloverApp.API.setDataField("totalInvalidQnnColumns", response.totalInvalidQnnColumns);
                    CloverApp.API.setDataField("totalInvalidUIDs", response.totalInvalidUIDs);
                    CloverApp.API.setDataField("totalInvalidDates_Updated", response.totalInvalidDates_Updated);
                    CloverApp.API.setDataField("totalInvalidScore_Updated", response.totalInvalidScore_Updated);
                   
                    if(response.statistics.totalSampleResponseAdded !== null && response.statistics.totalSampleResponseAdded != undefined){
                            CloverApp.API.setDataField("invalidQnnColumns", response.invalidQnnColumns);
                            CloverApp.API.setDataField("invalidUIDs", response.invalidUIDs);
                            CloverApp.API.setDataField("invalidDates_Updated", response.invalidDates_Updated);
                        return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: []
                                        }
                                    }
                                },
    
                                
                            }
                        });  
                    }
                } else {
                    alertify.error("Invalid");
                    console.log(response.message);
                }
            })
            .catch(error => {
                Pace.stop();
                $(''body'').loadingModal(''destroy'');
                //alertify.error(error.message);;
                console.log(error.message);
            });
        };
    }, 
    closeModal: function (args){
        console.log("Close modal", args);
        args.component.refs.importModal.close();
        if(args.component.refs.moreModal !== undefined)
            args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []
                }
              }
            }
        }       
    },
    
     closeMoreModal: function (args){
        console.log("Close open modal", args);
            args.component.refs.moreModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                            /*totalRows: null,
                            totalSampleResponseAdded: null,
                            totalSampleResponseAnsAdded: null,
                            totalInvalidQnnColumns: null,
                            totalInvalidUIDs: null,
                            totalInvalidDates_Updated: null,
                            totalInvalidScore_Updated: null,
                            invalidQnnColumns: null,
                            invalidUIDs: null,
                            invalidDates_Updated: null*/
                      }
                  },
                  models:{
                       hideControls: []//[totalSampleResponseAdded, totalSampleResponseAnsAdded, totalInvalidQnnColumns, totalInvalidUIDs, totalInvalidDates_Updated, totalInvalidScore_Updated, invalidQnnColumns, invalidUIDs, invalidDates_Updated]
                  }
              }
            }
        }       
    },
    toggoleIpInclusive: function(args){
        if(args.data.RestrictIpInclusive==1){
            CloverApp.API.setDataField("RestrictIpInclusive", "1");   
        }  
        else{
            CloverApp.API.setDataField("RestrictIpInclusive", "0");              
        }        
    },
    showHideControls: function(args){
        var hideControls = [];
        var showControls = [];
        if(args.data.RestrictIp==1){
            CloverApp.API.setDataField("RestrictIp", "1"); 
            if(args.data.RestrictIpInclusive==1){
                args.data.RestrictIpInclusive=''1'';
                CloverApp.API.setDataField("RestrictIpInclusive", "1");   
            }  
            else{
                args.data.RestrictIpInclusive=''0'';
                CloverApp.API.setDataField("RestrictIpInclusive", "0");              
            }            
            qnn_dplyUserActions.addUniqueElement(showControls, ''RestrictIpInclusive'');
            qnn_dplyUserActions.addUniqueElement(showControls, ''countryOrIpRange'');  

            if(args.data.IpCountry || (!args.data.IpCountry && !args.data.IpRange)){
                args.data.countryOrIpRange=''1'';
            }
            else{
                args.data.countryOrIpRange=''0'';
            }  
         
            
            if(args.data.countryOrIpRange==1){
                CloverApp.API.setDataField("countryOrIpRange", ''1'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpCountry'');                      
            }
            else{
                CloverApp.API.setDataField("countryOrIpRange", ''0'');
                qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');  
                qnn_dplyUserActions.addUniqueElement(showControls, ''IpRange'');                         
            }            
             
            
        }  
        else{
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, ''RestrictIpInclusive'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''countryOrIpRange'');    
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');                
        }        


        return {hideControls: hideControls, showControls: showControls};
    },
    removeElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    },
    addUniqueElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index > -1) return;
        array.push(element);
    },
        
    setIpRestriction: function(args){
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c));
        
        console.log(args)
        return {
            app: {
                form: {
                    models: {
                        hideControls: args.state.app.form.models.hideControls
                    }
                }
            }
        };        
    },
    init: function(args) {
        
        if(!args.data.Id){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
        }
        
        //qnn_dplyUserActions.showHideControls(args);
        var showHideControls = qnn_dplyUserActions.showHideControls(args);
        var hideControls = showHideControls.hideControls;
        var showControls = showHideControls.showControls;
        showControls.forEach(c=>qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, c));
        hideControls.forEach(c=>qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, c)); 
        
        
         // Implement function to remove element from array
        var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };

        CloverApp.API.setDataField("cbMailMerge", false);
        CloverApp.API.setDataField("cbEmail", false);
        CloverApp.API.setDataField("subject", "");
        CloverApp.API.setDataField("msgContent", "");
        
        if(args.data.Id){
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.dictQuestionnaire);                  
            }
            catch{}
        }          

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
 
 
      var dplyId = args.data.Id;

        if (args.data.Id == null) 
            return {
                app: {
                    form: {
                        models: {
                            hideControls: args.state.app.form.models.hideControls
                        }
                    }
                }
            };
    
    
    // Only get category details
    // iff args.data.Id is not null
    
    var url = ''/snapData/get?id='' + dplyId;
        // _loadingStart();
        var d1 = new Date();
        return ()=>{
        return fetch(url,
            {
                credentials: ''same-origin'',
                method: ''get''
            })
            .then(response => response.json())
            .then(response => {
                Pace.stop();
              qnn_dplyUserActions.showHideControls(args);  
              console.log("Response is", response);
                if (response.success) {
                    
                     var _hideControls = args.state.app.form.models.hideControls;
                     var items = response.items;
                    if (items != null)
                    {
                   
                    var obj = typeof items != ''object'' ? JSON.parse(items) : items;
                    var valChkScheduler = obj[0].Id;
                    var EmailRecipients = obj[0].EmailRecipients;
                    var valEmailSuccess ;
                    var valEmailFailure ;
                     
                  if(obj[0].EmailSuccess == true)
                    {
                        valEmailSuccess = ''1'';
                    }
                  else
                       valEmailSuccess = ''0'';
                        
                  if(obj[0].EmailFailure == true)
                  {
                        valEmailFailure = ''1'';
                  }
                   else
                   {
                      valEmailFailure = ''0'';
                    }
                    
                   // var recipients = [];
                    
                     var recipients = [];
                    if(EmailRecipients == "No Recipient")
                    {
                        recipients = [];
                    }
                    else
                    {
                         var breakRecepient = EmailRecipients.split('','');
                         for (let r = 0 ; r < breakRecepient.length ; r++ )
                         {
                        recipients.push(breakRecepient[r]);
                    }
                    
                    }
               
                   /*// alert(items.length);
                    if(items !== undefined && items.length > 0){
                        _removeElement(_hideControls, dailySsForm);
                    }
                   // recipients.push(EmailRecipients);*/
                   
                   
                   
                   
                    CloverApp.API.setDataField("chkScheduler", 1);
                    CloverApp.API.setDataField("ddlEmailReceipients",recipients);
                    CloverApp.API.setDataField("chkEmailSuccess", valEmailSuccess);
                    CloverApp.API.setDataField("chkEmailFail", valEmailFailure);
                    
                    _removeElement(_hideControls, ''dailySsForm'');  
                    _hideControls.concat(hideControls);
                    return Promise.resolve(
                        {
                            stateDelta: {
                                app: {
                                    form: {
                                        models: {
                                            hideControls: _hideControls
                                        }
                                    }
                                },
                            }
                        });  
                        
                    }
                    else
                    {
                        CloverApp.API.setDataField("chkScheduler", 0);
                        CloverApp.API.setDataField("ddlEmailReceipients", []);
                        CloverApp.API.setDataField("chkEmailSuccess", false);
                        CloverApp.API.setDataField("chkEmailFail", false);
                        return {
                            app: {
                                form: {
                                    models: {
                                        hideControls: args.state.app.form.models.hideControls
                                    }
                                }
                            }
                        };                    
                    }
                   
                    //  _loadingStop();
                   
                }
        
            })
   
            .catch(function(ex) {
                alertify.error("Could not Data due to " + ex);
            });
  };
       
    },
    
     onClickSave: function (args){
  
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
        
        var emailFrom = args.data.emailFrom ? args.data.emailFrom : "";
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        if(args.data.Id==null && args.data.cbEmail && !emailRegExr.test(emailFrom)){
            throw alertify.error("Invalid Email address from");
        }
  
      var data = args.data.chkScheduler;
      var dplyId = args.data.Id;
      
      var emailSuccess = args.data.chkEmailSuccess;
      var emailFail = args.data.chkEmailFail;
      var userId = args.data.ddlEmailReceipients;
      console.log(args.data);
      console.log(userId);         
   
            
        var formData = new FormData();
        formData.append(''CheckBox'', data);
        formData.append(''dplyId'',dplyId);
        formData.append(''emailSuccess'',emailSuccess);
        formData.append(''emailFail'',emailFail);
        formData.append(''userId'',userId);
        
      
        var url = ''/report/getJobData'';
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
              
                  //  alertify.success("");
              console.log(data);
              
               } else {
                   // alertify.success(" ");
                }

            })
           .catch(error => {
               alertify.error(error.message);;
            });

 
},
    
    parseHtml: function(args) {

        return {
              app: {
                  form: {
                      data: {
                          modified: {
                             msgContent: args.component.refs.htmlEditor.state.htmlData                            
                            }
                        }
                    }
                }
        };  
    },
    dropdownQuestionnaireOnChange: function(args) {
    },
    radioCompletionActionOnChange: function(args) {
    },
    radioCompletionNavBackOnChange: function(args) {
    },
    radioCompletionNavCancelOnChange: function(args) {
    },
    btnSaveOnClick: function(args) {
        // Insert [QNN_DPLY_SAMPLE_INFO]
    },
    clearContent: function(args){
        if(args.data.countryOrIpRange=="1"){
            CloverApp.API.setDataField("IpRange", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpCountry'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpRange'');             
            
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }
        }
        else{
            CloverApp.API.setDataField("IpCountry", null);
            qnn_dplyUserActions.removeElement(args.state.app.form.models.hideControls, ''IpRange'');
            qnn_dplyUserActions.addUniqueElement(args.state.app.form.models.hideControls, ''IpCountry'');      
            return {
                app: {
                  form: {
                      models:{
                          hideControls: args.state.app.form.models.hideControls
                      }
                  }
                }
            }            
        }

    },

    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            //CloverApp.API.redirectToForm("QNN_DPLY",args.data.RecurrenceOfDplyId);
            location.href = "/form/QNN_DPLY/" + encodeURIComponent(args.data.RecurrenceOfDplyId);
        } else {
            alertify.error("This deployment does not have a parent");
        } 
    },
    
}












' WHERE [Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf';

