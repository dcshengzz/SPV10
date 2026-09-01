-- Will UPDATE existing row(s) in dwMetadata for the following:
-- AccessReportSchedule-code.js
-- AuditTrail-code.js
-- ChoiceCount-code.js
-- DashboardOverall-code.js
-- DashboardSectorSegmentResponse-code.js
-- DashboardStatus-code.js
-- DashboardWeekly-code.js
-- DataEditorDeployment-code.js
-- DataEditorDeploymentList-code.js
-- dplyListSample-code.js
-- dplyMaintenance-code.js
-- dplyMessage-code.js
-- dplyMessages-code.js
-- dplyRecurrence-code.js
-- dplysampleowner-code.js
-- dplyScheduledExport-code.js
-- dplyValidation-code.js
-- header-code.js
-- MaintenanceTests-code.js
-- QNN_DPLY-code.js
-- QNN_DPLY_PRE_POPULATE-code.js
-- QNN_LIST-code.js
-- QNN_LIST_SAMPLE-code.js
-- QNN_QNN-code.js
-- QNN_SAMPLE-code.js
-- QNN_TRK_LIST-code.js
-- RespAccountChangePassword-code.js
-- respdashboard-code.js
-- RespondentParticipationReport-code.js
-- SampleStimulsoftReport-code.js
-- ResponseReport-code.js
-- ShortLink-code.js
-- SurveyResponseReport-code.js
-- SwzDplyList-code.js
-- SwzGlobalMailer-code.js
-- SwzGlobalMailerMessage-code.js
-- SwzListList-code.js
-- SwzQnnList-code.js
-- SwzTags-code.js
-- UserAccessMatrix-code.js
-- WordCloudReport-code.js

UPDATE [dwMetadata] SET
[Id]='727e8793-3bbf-4779-9d5b-ec7f123d83b7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AccessReportSchedule-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-08-04 18:37:43.117', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 01:57:47.217', 
[Data]=N'{
    cancelSetting: function(args){
        CloverApp.API.setDataField(''structDivision'', null);
        
        let _hideControls = args.state.app.form.models.hideControls;
        _hideControls.push(''form_1'');
        return {
            app: {
                form: {
                    models:{
                        hideControls: _hideControls
                    }
                }
            }
        }
        
    },
    
    getSchedule: function(id){
        const url = ''/setting/accessreportschedule/'' + encodeURIComponent(id);
        Utils.loadingStart();
        return Utils.getRequest(url).then(
            response => {
                return response.item;
            }, reason => {
                console.error("getSchedule", reason);
                alertify.error( Utils.encodeHTML("Unable to load schedule details: " + reason) );
                return null;
            }
        ).finally(Utils.loadingStop);
    },
    
    initSchedule: async function(args){
        if(args.data.structDivision !== undefined || args.data.structDivision !== ''''){
            const schedule = await accessreportscheduleUserActions.getSchedule(args.data.structDivision);
            if(schedule !== undefined && schedule !== null){
                CloverApp.API.setDataField("schedule", schedule.ScheduleType);
                CloverApp.API.setDataField("isEnable", schedule.IsEnabled);
                CloverApp.API.setDataField("receiver", schedule.Email);
            }else{
                CloverApp.API.setDataField("schedule", '''');
                CloverApp.API.setDataField("isEnable", false);
                CloverApp.API.setDataField("receiver", '''');
            }    
        }else{
            accessreportscheduleUserActions.cancelSetting(args);
        }
    },
    
    getStruct: function(){
        const url = ''/setting/organization'';
        Utils.loadingStart();
        return Utils.getRequest(url).then(
            response => {
                return response.item;
            }, reason => {
                console.error("getStruct", reason);
                alertify.error( Utils.encodeHTML("Unable to load organisation list: " + reason) );
                return [];
            }
        ).finally(Utils.loadingStop);
    },
    
    init: async function(args){
        console.log(''init'',args.data.structDivision);
        const organizationList = await accessreportscheduleUserActions.getStruct();
        if(organizationList != null) {
            await CloverApp.API.changeModelControl(args, "structDivision",''data-elements'', organizationList);
            CloverApp.API.setDataField("structDivision", '''');
        }
    },
    
    validateInput: function(data){
        let isValid = true;
        if(data.schedule === undefined || data.schedule.trim() === ''''){
            alertify.error(''Please select a schedule.'');
            isValid = false;
        }
        
        if(data.receiver === undefined || data.receiver.trim() === ''''){
            alertify.error(''Please provide receiver email address.'');
            isValid = false;
        }else{
            
            let emailValid
            let emailArr = data.receiver.split('','');
            if(emailArr.length > 1){
                for( var key in emailArr){
                    var email = emailArr[key];
                    emailValid = email.trim().match(/^([\w.%+-]+)@([\w-]+\.)+([\w]{2,})$/i)
                    if(!emailValid) {break;}
                }
            }else{
                emailValid = data.receiver.match(/^([\w.%+-]+)@([\w-]+\.)+([\w]{2,})$/i)  
            }
             
            if(!emailValid){
                alertify.error(''Please provide valid email address.'');
                isValid = false;
            }
        }
        
        return isValid;
    },
    
    saveSetting: function(args){
        if(accessreportscheduleUserActions.validateInput(args.data)){
            let formData = new FormData();
            formData.append(''structDivisionId'', args.data.structDivision);
            formData.append(''scheduleType'', args.data.schedule);
            formData.append(''isEnabled'', Utils.isSelected(args.data.isEnable));
            formData.append(''email'', args.data.receiver);
            const url = ''/setting/saveaccessreportschedule/'';
            return Utils.postFormRequest(url, formData).then(
                response => {
                    alertify.success(''Saved successfully.'');
                }, reason => {
                    console.error(reason);
                    alertify.error(Utils.encodeHTML(reason));
                }
            ).finally( Utils.loadingStop );
        }else{
            console.log(''saveSetting is not valid.'');
        }
    }
    
}' WHERE [Id]='727e8793-3bbf-4779-9d5b-ec7f123d83b7';

UPDATE [dwMetadata] SET
[Id]='17feec00-b037-4302-b630-328e430e7d1f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'AuditTrail-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-06-30 17:35:20.063', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 12:29:12.033', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
    },
    
    
    purgeData: function (args){
        const gridView = args.controlRef;

        var formData = new FormData();

        if(args.data.dateArchive != null){
            formData.append(''dateArchive'', args.data.dateArchive);
        }

        formData.append(''isArchive'', args.data.checkboxArchive);
        formData.append(''dataCreatedBefore'', args.data.dataCreatedBefore);

        Utils.loadingStart();
        Utils.postFormRequest("/audit/purgeauditlog",formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                args.component.refs.purgeModal.close();
            }, reason => {
                console.error("purgeData failed:", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    //disable dimmer click because the model will be close when user select date in modal.
    //this issue is due to old react modal version.
    disableDimmerClick: function(args) {
        args.component.refs.purgeModal.state.dimmerClick = false;
    },
    
    closePurgeModal: function(args) {
        args.component.refs.purgeModal.close();
    },
  
}' WHERE [Id]='17feec00-b037-4302-b630-328e430e7d1f';

UPDATE [dwMetadata] SET
[Id]='bbe4b066-f1b6-4bb0-85a8-6d474bdb7945', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ChoiceCount-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-12-02 15:17:19.097', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 12:32:16.633', 
[Data]=N'{
    
    getCounts: function(args) {
        
        if(!args.data.dplyId){ 
            CloverApp.API.setDataField("dplychoiceqnns", null);
            return;
        }
        
        CloverApp.API.setDataField("dplychoiceqnns", args.data.dplyId);
        
    },
    
    onExport: function(args) {
        const formData = new FormData();
        formData.append(''dplyId'', args.data.dplyId);
        Utils.loadingStart();
        Utils.postFormRequest("/report/exportanswerchoicecount", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Export error:", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

}' WHERE [Id]='bbe4b066-f1b6-4bb0-85a8-6d474bdb7945';

UPDATE [dwMetadata] SET
[Id]='2637d0de-aa76-4343-a03c-7bb415c2a71d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardOverall-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-14 17:32:43.053', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 13:03:12.010', 
[Data]=N'{
 
    changeQnType: function (args){
        
       if(args.data.deployment == undefined || args.data.deployment == "")
            return;

        var getCompanyTypes = function(qnnType){
            if(qnnType == "II"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 2, value: "TS", text: "TS"}];
            }else if(qnnType == "IU"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 3, value: "MTS", text: "MTS"}, {text: "STS", value: "STS"}];
            }else if(qnnType == "MI"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 2, value: "TS", text: "TS"}];
            }else if(qnnType == "MP"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 3, value: "MTS", text: "MTS"}, {text: "STS", value: "STS"}];
            }
        }
        
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
        
        var _modified = {};
        var deployment = args.data.deployment;
        var dplyId = args.data.Id;
        var qnType = args.data.qnType;
        var companyType = args.data.companyType;
        var industryType = args.data.industryType;
    
        return () => {
            _loadingStart();
            var formData = new FormData();
            formData.append(''dplyId'', deployment);     
            var url = ''/report/dashboard/overallresponse'';
            
            return fetch(url,
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
                        var items = response.items;
                        var totalActive = response.totalActive;
                        var totalSampleAftRemoval = response.totalSampleAftRemoval;
                        var editorLabel = [''Completed Response'',''Total Response''];
                        var barData = [totalActive, totalSampleAftRemoval];
                        var value = {
                                    labels: editorLabel,
                                    datasets: [
                                      {
                                        data: barData,
                                        backgroundColor:["#E91E63","#2196F3"],
                                        label: "Count",
                                      }
                                    ]
                        };
                        
                        var html = '''';         
                        var totalResponseRate = totalActive/totalSampleAftRemoval * 100;
                            totalResponseRate = totalResponseRate.toFixed(2) + "%";

                        var onCompanyTypeFilter = (companyType !== undefined && companyType.length > 0);
                        var onIndustryTypeFilter = (industryType !== undefined && industryType.length > 0);

                        if(items !== undefined && items.length > 0){
                            for(var i = 0; i < items.length; i++){
                            
                                if(!((onCompanyTypeFilter && companyType.includes(items[i]["CompanyType"])) || onCompanyTypeFilter == false))
                                    continue;
                                if(!((onIndustryTypeFilter && industryType.includes(items[i]["IndustryType"])) || onIndustryTypeFilter == false))
                                    continue;
                                    
                                    var responseRate = items[i]["ResponseNumber"] / totalSampleAftRemoval * 100;
                                        responseRate = responseRate.toFixed(2);
                                        
                                    var text = responseRate + ''%'';
                                        
                                    html = html + `<div class="swz-block-item"><div class="swz-block-item1-number"><div class="swz-block-item1-header">` +
                                       items[i]["CompanyType"] + "_" + items[i]["IndustryType"] + "&nbsp" + ":" + "&nbsp" +
                                    `</div><div class="ui input">
                                        <input type="text" readOnly value=` + text  + `>
                                    </div>` +
                                        `</div></div>`;
                                    
                                }
                            
                        }
                        
                        html = html + `<div class="swz-block-item"><div class="swz-block-item1-number"><div class="swz-block-item1-header">` +
                                      "Total" + "&nbsp" + ":" + "&nbsp" +
                                    `</div><div class="ui input">
                                        <input type="text" readOnly value=` + totalResponseRate  + `>
                                    </div>` +
                                        `</div></div>`;
                                    
                        var htmlOverall = ''<div class="field"><label>Result</label></div><div class="swz-block">'' + html + ''</div>''
               
                        CloverApp.API.setDataField("result", htmlOverall);
                        CloverApp.API.setDataField("PieChart", value);
                        CloverApp.API.setDataField("response", response);
                        var _hideControls = args.state.app.form.models.hideControls;
                        _removeElement(_hideControls, "companyType");
                        _removeElement(_hideControls, "industryType");
                        
                        CloverApp.API.setDataField("onOverallResponse", true);
                        
                      /*  var companyTypeRewrite = function (model) {
                            model[''data-elements''] = getCompanyTypes(qnType);
                        };
                        CloverApp.API.rewriteControlModel("companyType", companyTypeRewrite);
                        */
                        return Promise.resolve(
                           
                            {
                                stateDelta: {
                                    app: {
                                        form: {
                                            models:{
                                                hideControls: _hideControls
                                            }
                                        }
                                    }
                                }
                        });
                    } else {
                        console.error(response.message);
                        alertify.error( Utils.encodeHTML(response.message) );
                    }
    
                })
                .catch(error => {
                    console.error(error.message);
                    alertify.error( Utils.encodeHTML(error.message) );
                });
        }
        
    },
  
    onChangeDeployment: function(args){
        
        if(args.data.qnType == undefined || args.data.qnType == "")
            return;
        
        CloverApp.API.setDataField("qnType", null);
        CloverApp.API.setDataField("onOverallResponse", false);
        CloverApp.API.setDataField("companyType", []);
        CloverApp.API.setDataField("industryType", []);

    },
    
    onChangeFilter: function(args){
       
        var companyType = args.data.companyType;
        var industryType = args.data.industryType;
        var response = args.data.response;
        
        if(response == undefined || response == "")
            return;
        
        var items = response.items;
        var totalActive = response.totalActive;
        var totalSampleAftRemoval = response.totalSampleAftRemoval;
        var editorLabel = [''Completed Response'',''Total Response''];
        var barData = [totalActive, totalSampleAftRemoval];
        var value = {
                    labels: editorLabel,
                    datasets: [
                      {
                        data: barData,
                        backgroundColor:["#E91E63","#2196F3"],
                        label: "Count",
                      }
                    ]
        };
        
        var html = '''';         
        var totalResponseRate = totalActive/totalSampleAftRemoval * 100;
            totalResponseRate = totalResponseRate.toFixed(2);

        var onCompanyTypeFilter = (companyType !== undefined && companyType.length > 0);
        var onIndustryTypeFilter = (industryType !== undefined && industryType.length > 0);

        if(items !== undefined && items.length > 0){
            for(var i = 0; i < items.length; i++){
            
                if(!((onCompanyTypeFilter && companyType.includes(items[i]["CompanyType"])) || onCompanyTypeFilter == false))
                    continue;
                if(!((onIndustryTypeFilter && industryType.includes(items[i]["IndustryType"])) || onIndustryTypeFilter == false))
                    continue;
                    
                    var responseRate = items[i]["ResponseNumber"] / totalSampleAftRemoval * 100;
                        responseRate = responseRate.toFixed(2);
                        
                        
                    var text = responseRate + ''%'';
                        
                    html = html + `<div class="swz-block-item"><div class="swz-block-item1-number"><div class="swz-block-item1-header">` +
                                       items[i]["CompanyType"] + "_" + items[i]["IndustryType"] + "&nbsp" + ":" + "&nbsp" +
                                    `</div><div class="ui input">
                                        <input type="text" readOnly value=` + text  + `>
                                    </div>` +
                                        `</div></div>`;
                                    
                }
        }
        
        html = html + `<div class="swz-block-item"><div class="swz-block-item1-number"><div class="swz-block-item1-header">` +
                                      "Total" + "&nbsp" + ":" + "&nbsp" +
                                    `</div><div class="ui input">
                                        <input type="text" readOnly value=` + totalResponseRate  + "%" +  `>
                                    </div>` +
                                        `</div></div>`;
                    
        var htmlOverall = ''<div class="field"><label>Result</label></div><div class="swz-block">'' + html + ''</div>''
        CloverApp.API.setDataField("result", htmlOverall);
        
    },
    
    changeHeader: function(args){
              
            var dicValue = args.sourceControlValue;
            var options = args.sourceControlRef.state.options;
            
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == dicValue){
                        CloverApp.API.setDataField("dplyHeader", options[i]["text"]);
                        break;
                    }
                }
            }
    }
}' WHERE [Id]='2637d0de-aa76-4343-a03c-7bb415c2a71d';

UPDATE [dwMetadata] SET
[Id]='059364f1-17ad-4a10-8c74-b3227caa455c', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardSectorSegmentResponse-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-03-11 13:27:14.953', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 13:07:59.033', 
[Data]=N'{
    onClickSearch: function (args){
               // Implement function to remove element from array
        
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };
       var _hideControls = args.state.app.form.models.hideControls;
        
        CloverApp.API.setDataField("showSearchBtn", false);
        _addUniqueElement(_hideControls, "searchBtn");
         return {
             app: {
                form: {
                    models:{
                        hideControls: _hideControls
                    }
                }
            }
         }
    },
    
    onChangeFilter: function (args){
         var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
      
       var _hideControls = args.state.app.form.models.hideControls;
        
        CloverApp.API.setDataField("showSearchBtn", false);
        _removeElement(_hideControls, "searchBtn");
         return {
             app: {
                form: {
                    models:{
                        hideControls: _hideControls
                    }
                }
            }
         }
    },
    
    changeQnType: function (args){
        
       if(args.data.deployment == undefined || args.data.deployment == "")
            return;

        var getCompanyTypes = function(qnnType){
            if(qnnType == "II"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 2, value: "TS", text: "TS"}];
            }else if(qnnType == "IU"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 3, value: "MTS", text: "MTS"}, {text: "STS", value: "STS"}];
            }else if(qnnType == "MI"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 2, value: "TS", text: "TS"}];
            }else if(qnnType == "MP"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 3, value: "MTS", text: "MTS"}, {text: "STS", value: "STS"}];
            }
        }
         
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
    
        var deployment = args.data.deployment;
        var dplyId = args.data.Id;
        var qnType = args.data.qnType;
        var companyType = args.data.companyType !== "" && args.data.companyType !== undefined ? args.data.companyType : [];
       
        var filters = args.data.filter !== "" && args.data.filter !== undefined ? args.data.filter : [];
        var filterType = "Segment";
        
        if(qnType == "II" || qnType == "MI")
            filterType = "Sector";
            
        return () => {
            _loadingStart();
            var formData = new FormData();
            formData.append(''dplyId'', deployment);
            formData.append(''filterType'', filterType);
            if(filters.length > 0)
                formData.append(''filters'', filters);
                
            if(companyType.length > 0)
                formData.append(''filtersWeightGroup'', companyType);
    
            var url = ''/report/dashboard/sectorsegmentresponse'';
            
            return fetch(url,
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
                        var options = response.options;
                        var items = response.items;
                        
                        var tableStart =  ''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;background-color:rgba(230, 247, 255,0.1);" border="1" bordercolor="#808080" cellpadding="15"><tbody style="border-color:#cccccc;">'';
                        var tableEnd = ''</tbody></table>'';
                        var tableContent = `<tr><td><h4>No response found.</h4></td></tr>`

                        var rowHeader = ''<td></td>'';
                        var rowS = ''<tr>'';
                        var rowE = ''</tr>'';
                        var tableKeys = response.tableKeys;
                        var keyOrderObj = {};
                        var i = 0;
                            
                        if(Object.keys(items).length > 0){
                            tableContent = '''';
                            if(tableKeys !== undefined && tableKeys.length > 0){
                                while(i < tableKeys.length){
                                    keyOrderObj[tableKeys[i]] = i;
                                    rowHeader += `<td style="padding:5px;font-size:16px;width:20%;"><h4>` + tableKeys[i] + ''</h4></td>''
                                    i++;
                                }
                            }
                            rowheader = rowS + rowHeader + rowE;
                            
                            for(var item in items){
                                
                                let rowS = ''<tr>'';
                                let rowE = ''</tr>'';
                                let firstColumn = ''<td style="padding:5px;font-size:16px;width:20%;">'' + item + ''</td>''
                                var columnsData = '''';
                        
                               if(Object.keys(items[item]).length === 0 && items[item].constructor === Object && Object.keys(items).length <= 1)
                                    firstColumn += `<tr><td><h4>No response found.</h4></td></tr>`;


                                var arr = [];
                                for(var wg in keyOrderObj){
                                    var obj = {};
                                    if(items[item][wg] !== undefined){
                                        obj[''content''] = ''<td style="padding:5px;font-size:16px">'' + items[item][wg] + ''%</td>''
                                        obj[''order''] = keyOrderObj[wg]; 
                                    }else{
                                        obj[''content''] = `<td style="padding:5px;font-size:16px">0%</td>`
                                        obj[''order''] = keyOrderObj[wg]; 
                                    }
                                    arr.push(obj);
                                }
                                
                                arr.sort(function(a, b) { 
                                    return obj.order - b.order;
                                })
                                
                                for(var i in arr){
                                    columnsData += arr[i].content;
                                }
                                
                                let rowData = firstColumn + columnsData;
                                tableContent += rowS + rowData + rowE;
                            }
                        }
                       
                        var html = tableStart + rowHeader + tableContent + tableEnd;
                        var htmlOverall = ''<div class="field"><label>Result</label></div><div>'' + html + ''</div>''
               
                        CloverApp.API.setDataField("result", htmlOverall);
                        CloverApp.API.setDataField("response", response);
                        var _hideControls = args.state.app.form.models.hideControls;
                        _removeElement(_hideControls, "companyType");
                        _removeElement(_hideControls, "filter");
                        CloverApp.API.setDataField("onOverallResponse", true);

                        var filterTypeRewrite = function (model) {
                            model[''label''] = filterType;
                            model[''data-elements''] = options;
                            model[''search''] = true;
                        };
                        CloverApp.API.rewriteControlModel("filter", filterTypeRewrite);

                        return Promise.resolve(
                           
                            {
                                stateDelta: {
                                    app: {
                                        form: {
                                            models:{
                                                hideControls: _hideControls
                                            }
                                        }
                                    }
                                }
                        });
                    } else {
                        console.error(response.message);
                        alertify.error( Utils.encodeHTML(response.message) );
                    }
    
                })
                .catch(error => {
                    console.error(error.message);
                    alertify.error( Utils.encodeHTML(error.message) );
                });
        }
        
    },
  
    onChangeDeployment: function(args){
        if(args.data.qnType == undefined || args.data.qnType == "")
            return;
            
        if(args.data.result !== "")
            CloverApp.API.setDataField("result", "");
        
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
        
        var _hideControls = args.state.app.form.models.hideControls;
        
        CloverApp.API.setDataField("qnType", null);
        CloverApp.API.setDataField("onOverallResponse", false);
        CloverApp.API.setDataField("companyType", []);
        CloverApp.API.setDataField("filter", []);
        
        _addUniqueElement(_hideControls, "companyType");
        _addUniqueElement(_hideControls, "filter");
        _addUniqueElement(_hideControls, "searchBtn");
        
         return {
             app: {
                form: {
                    models:{
                        hideControls: _hideControls
                    }
                }
            }
         }

    },
    
    changeHeader: function(args){
              
            var dicValue = args.sourceControlValue;
            var options = args.sourceControlRef.state.options;
            
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == dicValue){
                        CloverApp.API.setDataField("dplyHeader", options[i]["text"]);
                        break;
                    }
                }
            }
    }
}' WHERE [Id]='059364f1-17ad-4a10-8c74-b3227caa455c';

UPDATE [dwMetadata] SET
[Id]='91a0e48c-6f5c-4e93-b214-3c0881a9813e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardStatus-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-15 18:14:40.923', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 13:15:27.793', 
[Data]=N'{
    init: function(args) {
        
    },
    
    //not an action handler (used by onChangeDeployment and onChangeFilter)
    reportHtml: function(response, statusType, excludeExempted){
        if(response == undefined || response == "")
            return;
        
        const totalStatus = response.totalStatus;
        let html = '''';
        const items = response.items;
        const statusFilterOn = (statusType !== undefined && statusType.length > 0);
        const isExcludeExempted = !statusFilterOn && excludeExempted;
        const exemptedTypes = [ ''EM'', ''EE'', ''EC'', ''EO''];

        if(items !== undefined && items.length > 0){
            for(let i = 0; i < items.length; i++){
                const itemStatus = items[i]["Status"];
                const itemStatusCode = items[i]["StatusCode"];
                
                const excludeItem 
                    = (statusFilterOn && !statusType.includes(itemStatus))
                    || (isExcludeExempted && exemptedTypes.includes(itemStatusCode));
                
                if(!excludeItem){
                    let responseRate = items[i]["ResponseNumber"] / totalStatus * 100;
                    responseRate = responseRate.toFixed(2);
                        
                    let text = items[i]["ResponseNumber"] + ''/'' + totalStatus;
                    text = text.toString() + "&nbsp" + ''('' + responseRate + ''%)'';
                    
                    html = html 
                        + `<div class="swz-block-item"><div class="swz-block-item1-number"><div class="swz-block-item1-header">` +
                        items[i]["Status"] +  ":" + "&nbsp" +
                        `</div><div class="ui input">
                        <input type="text" readOnly value=` + text  + `>
                        </div>` +
                        
                        `</div></div>`;
                }
            }
        }
        const htmlOverall = ''<div class="field"><label>Result</label></div><div class="swz-block">'' + html + ''</div>''
        return htmlOverall;
    },
    
    onChangeDeployment: function (args){
    
        CloverApp.API.setDataField("statusType", []);
        if(args.data.deployment == undefined || args.data.deployment == "")
            return;

        const statusType = args.data.statusType == undefined ? [] : args.data.statusType ;
        const excludeExempted = args.data.excludeExempted;
        Utils.loadingStart();
        Utils.getRequest("/report/dashboard/statusresponse",{dplyId:args.data.deployment}).then(
            response => {
                const htmlOverall = dashboardstatusUserActions.reportHtml(response.item, statusType, excludeExempted);
                CloverApp.API.setDataField("result", htmlOverall);
                CloverApp.API.setDataField("response", response.item);
                CloverApp.API.setDataField("onOverallResponse", true);
                
                Utils.queueHideControl("statusType", false);
                Utils.queueHideControl("excludeExempted", false);
                Utils.queueHideControl("btnExportDetails", false);
                Utils.queueHideControl("container_addRemoveStatus", false);
                
                const statusOptions = response.item.items.map( (item,index) =>  ({ key: index, value: item["Status"], text: item["Status"] }) );
                Utils.rewriteDropdown("statusType", statusOptions, []);

            }, reason => {
                console.error("failed to fetch statusresponse data, reason=", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
  
    onChangeFilter: function(args){
        console.log("onChangeFilter args=", args);
        const response = args.data.response;
        
        if(response == undefined || response == "")
            return;
        
        const htmlOverall = dashboardstatusUserActions.reportHtml(
            response, 
            args.data.statusType, 
            args.data.excludeExempted);

        CloverApp.API.setDataField("result", htmlOverall);
        CloverApp.API.setDataField("onOverallResponse", true);
    },
    
    changeHeader: function(args){
        const dicValue = args.sourceControlValue;
        const options = args.sourceControlRef.state.options;
        
        if(options !== undefined && options.length > 0){
            for(var i = 0; i < options.length; i++){
                if(options[i].key == dicValue){
                    CloverApp.API.setDataField("dplyHeader", options[i]["text"]);
                    break;
                }
            }
        }
    },
    
    exportDetails: function(args) {
        const dplyId = args.data.deployment;
        const statusType = args.data.statusType ? args.data.statusType : [];
        const isExcludeExempted = (statusType.length > 0) ? false : Boolean(args.data.excludeExempted);
        
        console.log("Requesting export for dplyId=", dplyId, "statusType=",statusType, "isExcludeExempted=", isExcludeExempted);
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("excludeExempted", isExcludeExempted);
        statusType.forEach(status => formData.append("status",status));
        
        Utils.loadingStart();
        Utils.postFormRequest("/report/dashboard/statusresponse/exportdetails", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally( Utils.loadingStop );
    },
    
    actionAddAllStatus: function(args){
        const response = args.data.response;
        const allStatus = response.items.map( item => item["Status"] );
        CloverApp.API.setDataField("statusType", allStatus);
        
        const htmlOverall = dashboardstatusUserActions.reportHtml(
            response, 
            allStatus, 
            args.data.excludeExempted);
        CloverApp.API.setDataField("result", htmlOverall);
        CloverApp.API.setDataField("onOverallResponse", true);
        
        Utils.queueHideControl("excludeExempted", true);
    },
    
    actionRemoveAllStatus: function(args){
        const response = args.data.response;
        
        CloverApp.API.setDataField("statusType", []);
        
        const htmlOverall = dashboardstatusUserActions.reportHtml(
            response, 
            [], 
            args.data.excludeExempted);
        CloverApp.API.setDataField("result", htmlOverall);
        CloverApp.API.setDataField("onOverallResponse", true);
        
        Utils.queueHideControl("excludeExempted", false);
    },
}







' WHERE [Id]='91a0e48c-6f5c-4e93-b214-3c0881a9813e';

UPDATE [dwMetadata] SET
[Id]='0bebe72e-f8b0-47fd-91ed-c997ff5c1299', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DashboardWeekly-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-16 17:23:08.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 13:17:20.563', 
[Data]=N'{
    onClickSearch: function (args){
           
        // Implement function to add elemenbt 
        var _addUniqueElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index > -1) return;
            array.push(element);
        };
       var _hideControls = args.state.app.form.models.hideControls;
        
        CloverApp.API.setDataField("showSearchBtn", false);
        _addUniqueElement(_hideControls, "searchBtn");
         return {
             app: {
                form: {
                    models:{
                        hideControls: _hideControls
                    }
                }
            }
         }
    },
    
    onChangeFilter: function (args){
         var _removeElement = function(array, element) {
            var _index = array.indexOf(element);
            if (_index == -1) return;
            array.splice(_index, 1);
        };
      
       var _hideControls = args.state.app.form.models.hideControls;
        
        CloverApp.API.setDataField("showSearchBtn", false);
        _removeElement(_hideControls, "searchBtn");
         return {
             app: {
                form: {
                    models:{
                        hideControls: _hideControls
                    }
                }
            }
         }
    },
    
    changeQnType: function (args){
        
       if(args.data.deployment == undefined || args.data.deployment == "")
            return;

        var getCompanyTypes = function(qnnType){
            if(qnnType == "II"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 2, value: "TS", text: "TS"}];
            }else if(qnnType == "IU"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 3, value: "MTS", text: "MTS"}, {text: "STS", value: "STS"}];
            }else if(qnnType == "MI"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 2, value: "TS", text: "TS"}];
            }else if(qnnType == "MP"){
                return [{key: 1, value: "TA", text: "TA"}, {key: 3, value: "MTS", text: "MTS"}, {text: "STS", value: "STS"}];
            }
        }
         
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
        
        var deployment = args.data.deployment;
        var dplyId = args.data.Id;
        var qnType = args.data.qnType;
        var companyType = args.data.companyType !== "" && args.data.companyType !== undefined ? args.data.companyType : [];
       
        return () => {
            _loadingStart();
            var formData = new FormData();
            formData.append(''dplyId'', deployment);
             if(companyType.length > 0)
                formData.append(''filtersWeightGroup'', companyType);
    
            var url = ''/report/dashboard/weeklyresponse'';     
            return fetch(url,
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
                        
                        var items = response.items;
                        var totalActive = response.totalActiveCompanies;
                        var totalSampleAftRemoval = response.totalSampleAftRemoval[0][''Number''];
                    
                        var xArray = [];
                        var yArray = [];
                        var backgroundColor = [];
                        
                        for(var key in items){
                            xArray.push("Week " + key);
                            
                            var responseRate = items[key]/totalSampleAftRemoval * 100;
                                responseRate = responseRate.toFixed(2);
                                yArray.push(responseRate);
                            
                            backgroundColor.push("#FFFFFF");
                            
                        }
                        /*var lineChartRewrite = function (model) {
                            model[''data-elements''] = getCompanyTypes(qnType);
                        };
                      
                        CloverApp.API.rewriteControlModel("LineChart", lineChartRewrite);*/
                        
                        
                            console.log("ARgs", args);
                        var value = {
                                    labels: xArray,
                                    datasets: [
                                      {
                                        data: yArray,
                                        backgroundColor: "#2196F3",//#E91E63
                                        //fill: "#1262E2",
                                        label: "Response Rate (%)"
                                      }
                                    ]
                        };
                        
                        CloverApp.API.setDataField("LineChart", value);
               
                        CloverApp.API.setDataField("response", response);
                        var _hideControls = args.state.app.form.models.hideControls;
                        _removeElement(_hideControls, "companyType");
                        CloverApp.API.setDataField("onOverallResponse", true);

/*
                        var companyTypeRewrite = function (model) {
                            model[''data-elements''] = getCompanyTypes(qnType);
                        };
                      
                        CloverApp.API.rewriteControlModel("companyType", companyTypeRewrite);*/
                        
                        return Promise.resolve(
                           
                            {
                                stateDelta: {
                                    app: {
                                        form: {
                                            models:{
                                                hideControls: _hideControls
                                            }
                                        }
                                    }
                                }
                        });
                    } else {
                        console.error(response.message);
                        alertify.error( Utils.encodeHTML(response.message) );
                    }
    
                })
                .catch(error => {
                    console.error(error.message);
                    alertify.error( Utils.encodeHTML(error.message) );
                });
        }
        
    },
  
    onChangeDeployment: function(args){
        if(args.data.qnType == undefined || args.data.qnType == "")
            return;
            
        if(args.data.result !== "")
            CloverApp.API.setDataField("result", "");
        
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
        
        var _hideControls = args.state.app.form.models.hideControls;
        
        CloverApp.API.setDataField("qnType", null);
        CloverApp.API.setDataField("onOverallResponse", false);
        CloverApp.API.setDataField("companyType", []);
        _addUniqueElement(_hideControls, "companyType");
        _addUniqueElement(_hideControls, "searchBtn");
        
         return {
             app: {
                form: {
                    models:{
                        hideControls: _hideControls
                    }
                }
            }
         }

    },
    
    changeHeader: function(args){
              
            var dicValue = args.sourceControlValue;
            var options = args.sourceControlRef.state.options;
            
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == dicValue){
                        CloverApp.API.setDataField("dplyHeader", options[i]["text"]);
                        break;
                    }
                }
            }
    }
}' WHERE [Id]='0bebe72e-f8b0-47fd-91ed-c997ff5c1299';

UPDATE [dwMetadata] SET
[Id]='4af67164-5e60-4905-9885-afd6da24cb3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeployment-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 13:43:56.780', 
[Data]=N'{
    init: function (args) {
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi));                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------

        if(args.data.IsAnonymous){
            dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
        }
        
        const innerArgs = args; //Used in column formatters
        const iconBtnClass = "ui icon button mini secondary";
        const iconBtnDisabledClass = "ui icon button mini disabled";
        
        const popupProps = { size:''mini'', on:''hover'', position:''top right''};
        const styleInlineBlock = { style:{display:"inline-block"}};

        const CLEARED = ''129C7781-536D-42F6-ACA4-33A62F2E2C1F''.toLowerCase();

        const genFormLinkButtons = function(p, elements, languages, formName, index){
            const dlsi = p.row.Id;
            const isMultipleResponse = !!innerArgs.data.IsMultipleResponse;
            const isAnonymous = !!innerArgs.data.IsAnonymous;
            //Render new response button for multiple response surveys
            if(isMultipleResponse || isAnonymous) {
                const status = p.row.Status ? p.row.Status.toLowerCase() : "";
                const responseNotCleared = (status!==CLEARED);
                
                const showActionAdd = responseNotCleared;
                if( showActionAdd ) {
                    const onClickNew = () => {
                        createNewResponseAndOpen(dlsi, formName);
                    };
                    elements.push(
                        CloverApp.API.createElement("span", { 
                            onClick: onClickNew  , className: "link-style", style: { color: "green", paddingRight: "0.5em" }
                        },''Add |'')
                    );
                }
            }
            
            //Render Form link
            const onClickForm = () => {
                redirectToSurvey(dlsi, formName, p.row.RespId);
            };
            elements.push(
                CloverApp.API.createElement("span", { onClick: onClickForm  , className: "link-style" }, languages[index])
            );
            elements.push( CloverApp.API.createElement("br") );
        };

        const createNewResponseAndOpen = function(dlsi, formName) {
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/dataeditor/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen

        const showRemarksModal = function (args, id) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    //args.component.state.data.remarks = response.item;
                    CloverApp.API.setDataField("remarks", response.item);
                    args.controlRef.refs.remarksModal.props.swzData.isOpen = true;
                    args.controlRef.refs.remarksModal.openModal();
                }, reason => {
                    console.error("Failed to retrieve remarks", reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        };
        
        const showRejectResponseModal = function (args, id, respId) {
            var formData = new FormData();
            formData.append(''id'', id);
            CloverApp.API.setDataField("dlsi", id);
            CloverApp.API.setDataField("RejectResponseRespId", respId); 
            Utils.loadingStart("Retrieving remarks");
            Utils.postFormRequest("/dataeditor/getremarks", formData).then(
                response => {
                    CloverApp.API.setDataField("RejectResponseRemarks",response.item);
                    args.controlRef.refs.mdl_RejectResponse.props.swzData.isOpen = true;
                    args.controlRef.refs.mdl_RejectResponse.openModal();
                }, reason => {
                    console.error("Failed to retrieve remarks for Reject Response modal", reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        };
        
        const showUploadModal = function(innerArgs, qnnId, dplyId, listSampleId, formNames, languages, index) {
            CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                model.customPostUrl = "/dataedit/upload/xlsx?" + new URLSearchParams( { qnnId, dplyId, listSampleId } );
                model.onUploadBegin = () => Utils.loadingStart("Uploading response...");
                model.onUploadEnd = (ctrl, success, xhr, msg, err) => {
                  Utils.loadingStop();
                  if(!success) {
                      console.error("Upload failed", xhr, msg, err);
                      if(xhr.status=== 400) {
                          alertify.error( Utils.encodeHTML("Upload Failed - " + xhr.statusText + " - " + xhr.responseText), 15000);
                      } else if(xhr.status===413) {
                          alertify.error("Upload Failed - the selected file is too large to be uploaded here", 15000);
                      } else {
                          alertify.error( Utils.encodeHTML("Upload Failed - " + msg + " - " + err), 15000);
                      }
                  }
                };
                console.log("rewrote model",model);
            });
            
            CloverApp.API.setDataField("UploadQnnId", qnnId);
            CloverApp.API.setDataField("UploadDplyId", dplyId);
            CloverApp.API.setDataField("UploadListSampleId", listSampleId);
            CloverApp.API.setDataField("UploadIndex", index);
            CloverApp.API.setDataField("UploadFormNames", formNames);
            
            if(Array.isArray(formNames) && formNames.length>0) {
                const options = [];
                for(var i=0; i<formNames.length; i++) {
                    options.push( {
                        key: i,
                        value: i,
                        text: languages[i],
                    } );
                }
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                CloverApp.API.setDataField("UploadFormChoice", 0);
            } else {
                CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                CloverApp.API.setDataField("UploadFormChoice", null);
            }
            
            innerArgs.component.refs.fileUploadModal.openModal();
        }; //end of showUploadModal
   
        const showTrkListModal = function (args, UID, Email, Name, Remarks, Status, StatusTitle) {
            //console.log(''showTrkListsModal args: '', args);
            CloverApp.API.setDataField("dictionaryTrkList", null);  
            CloverApp.API.setDataField("trkListSample_uid", Utils.encodeHTML(UID));
            CloverApp.API.setDataField("trkListSample_email", Utils.encodeHTML(Email));  
            CloverApp.API.setDataField("trkListSample_name", Utils.encodeHTML(Name));              
            CloverApp.API.setDataField("trkListSample_remarks", Utils.encodeHTML(Remarks));
            CloverApp.API.setDataField("trkListSample_status", Utils.encodeHTML(Status));       
            CloverApp.API.setDataField("trkListSample_statusTitle", Utils.encodeHTML(StatusTitle));

            args.controlRef.refs.trkListModal.props.swzData.isOpen = true;
            args.controlRef.refs.trkListModal.openModal();

            var formData = new FormData();
            formData.append(''uid'', UID);    
            Utils.loadingStart("Retrieving Track List Information");
            Utils.postFormRequest("/dataeditor/gettrklistsbyuid", formData).then(
                response => {
                    if(response.item) {
                        CloverApp.API.setDataField("dictionaryTrkList", response.item);   
                    }
                }, reason => {
                    console.error("Failed to retrieve track list", reason);
                    alertify.error( Utils.encodeHTML(reason) );
                    args.controlRef.refs.trkListModal.close();
                }
            ).finally(Utils.loadingStop);  
        };

        const openDelegateHistoryModal = function (args, dlsi) {
            CloverApp.API.setDataField(''gridDelegate'', null);
            var url = ''/dataeditor/viewdelegatelist?dlsi='' + dlsi;
            $.get(url).done(function (data) {
            if(data.success){
                CloverApp.API.setDataField(''gridDelegate'', data.item);
                args.controlRef.refs.delegateHistoryModal.openModal();
                args.component.refs.gridDelegate.refresh();
            } else
                alertify.error( Utils.encodeHTML(data.message) );
            }).fail(function (jqxhr, textStatus, error) {
                console.log(textStatus);
            });
        };

        //just used by Exempt button right now
        const setStatus = function (args, id, statusId, message) {
            if(!message) {
                message = { parameters: { 
                    confirmTitle: "setStatusConfirmTitle", 
                    confirmText: "setStatusConfirmText"
                } };
            }
            CloverApp.API.confirm(message?message:args).then(()=> {
                var formData = new FormData();
                formData.append(''id'', id);        
                formData.append(''selectedStatusId'', statusId);
                Utils.loadingStart("Setting Status");
                Utils.postFormRequest("/dataeditor/setStatus", formData).then(
                    response => {
                        args.component.refs.grid.refresh();
                        alertify.success( Utils.encodeHTML(response.message) );
                    }, reason => {
                        console.error("Failed to set status", reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                ).finally(Utils.loadingStop);
            }).catch(()=>{/*Empty catch to avoid error show at the console*/})
        };
        
        //used by Reset
        const resetStatus = function (args, id, respId) {
            const message = { 
                parameters: { 
                    confirmTitle: "resetResponseConfirmTitle", 
                    confirmText: "resetResponseConfirmText", 
                    confirmOk: "resetResponseConfirmOk"
            } };
            CloverApp.API.confirm(message).then(()=> {
                var formData = new FormData();
                formData.append(''id'', id);
                if(respId){
                    formData.append(''respId'', respId);                
                }
                Utils.loadingStart("Resetting Status");
                Utils.postFormRequest("/dataeditor/resetStatus", formData).then(
                    response => {
                        args.component.refs.grid.refresh();     
                        alertify.success( Utils.encodeHTML(response.message) );
                        if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
                            dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
                        }
                    }, reason => {
                        console.error("Failed to reset status", reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                ).finally(Utils.loadingStop);
            }).catch(()=>{ /*Empty catch to avoid error show at the console*/})
        }; 
         
        const remarksPreview = function(text) {
            const previewLength = 32;
            return ''"'' + (text.length<=previewLength ? text : text.substring(0,previewLength)+"...") + ''"'';
        } ;
        
        const remarksFormatter = function (p) {
            const hasRemarks = (p.row.Remarks!=null);
            const iconClass = hasRemarks 
                ? ''comments outline icon'' 
                : ''comment outline icon'';
            const tooltip = hasRemarks 
                ? ''View/Edit Remarks''+remarksPreview(p.row.Remarks)
                : ''Set Remarks'';
            const icon = CloverApp.API.createElement("i", {className: iconClass, ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { onClick: () => showRemarksModal(innerArgs, p.row.Id), className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup(tooltip, popupProps, btn);
        };

        const exemptFormatter = function (p) {
            const exemptStatusGUID = ''9731DE1D-2B6A-484C-BF10-44F842A3140E'';
            const icon = CloverApp.API.createElement("i", {className: "cut icon",ariaHidden: "true" }, "");
            const btnText = "Set Exempt Status";
            let element;
            if(p.row.StatusCode==''PE''){
                const exemptMessage = { parameters: { 
                    confirmTitle: "exemptConfirmTitle", 
                    confirmText: "exemptConfirmText",
                    confirmOk: "exemptConfirmOk"
                } };
                const btn = CloverApp.API.createElement("button", { onClick: () => setStatus(innerArgs, p.row.Id, exemptStatusGUID, exemptMessage), className: iconBtnClass }, icon);
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }      
            
            return element;
        };

        const resetFormatter  = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "undo icon",ariaHidden: "true" }, "");
            const btnText = "Reset Response";
            let element;
            if(p.row.StatusCode==''DE'' || p.row.StatusCode==''SB'' || p.row.StatusCode==''CL''){
                const btn = CloverApp.API.createElement("button", { onClick: () => resetStatus(innerArgs, p.row.Id, p.row.RespId), className: iconBtnClass },icon);
                element = CloverApp.API.createElementWithPopup(btnText,popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass },icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText,popupProps, container);
            }
            return element;
        }; 
        
        const rejectFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "thumbs down outline icon",ariaHidden: "true" }, "");
            const btnText = "Reject Response";
            let element;
            if(p.row.StatusCode==''SB''){
                const btn = CloverApp.API.createElement("button", { onClick: () => showRejectResponseModal(innerArgs, p.row.Id, p.row.RespId), className: iconBtnClass }, icon);
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, btn);
            }
            else{
                const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, icon);
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn);//For disabled component, require a div to cover in order to show the popup.
                element = CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }  
            return element;
        };

        const trackFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "ban icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement("button", { 
                onClick: () => showTrkListModal(innerArgs, p.row.UID, p.row.ToEmails, p.row.Name, p.row.Remarks, p.row.Status, p.row.StatusTitle), 
                className: iconBtnClass }, icon);
            return CloverApp.API.createElementWithPopup("Track List", popupProps, btn);
        };
        
        const delegateHistoryFormatter = function (p) {
            const icon = CloverApp.API.createElement("i", {className: "history icon",ariaHidden: "true" }, "");
            if(innerArgs.data.RequireAccessCode) {
                const btn = CloverApp.API.createElement("button"
                    ,{ onClick: () => openDelegateHistoryModal(innerArgs, p.row.Id), className: iconBtnClass }
                    , icon);
                
                return CloverApp.API.createElementWithPopup("Delegation History", popupProps, btn);
            } else { 
                return CloverApp.API.createElement("span", {}, "");
            }
        }; //end of DelegateHistoryFormatter

        //Excel Response upload button
        const excelUploadFormatter = function (p) {
            const isOnlineSurvey = ("O"===p.row.Type) && !!p.row.FormNames;
            const hasFiles = isOnlineSurvey && ( (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null) && (""!==p.row.FileLanguages));
            const alwaysShowForDataEditor = true;
            const showUploadButtonInAppropriateStatus = isOnlineSurvey && (hasFiles || alwaysShowForDataEditor);
            if(showUploadButtonInAppropriateStatus) {
                const uploadIcon = CloverApp.API.createElement("i", {className: "file excel outline icon",ariaHidden: "true" }, "");
                //const uploadIcon = CloverApp.API.createElement("i", {className: "upload icon",ariaHidden: "true" }, "");
                const excelEnabledForDply = true; //was innerArgs.data.IsExcelEnabled;
                const uploadButtonText = "Upload Response from Excel";
                if(!excelEnabledForDply && !alwaysShowForDataEditor) {
                    const blank = CloverApp.API.createElement("div", {}, "");
                    return blank;
                } else if( (p.row.StatusCode=="PE" || p.row.StatusCode=="DE") ) {
                    //Upload option is available for Pending and In-Progress
                    const formNames = p.row.FormNames.split(''||''); //used for form selection after upload
                    const languages = p.row.Languages.split(''||''); 
                    const btn = CloverApp.API.createElement("button", { 
                            onClick: () => showUploadModal(innerArgs, p.row.QnnId, p.row.DplyId, p.row.ListSampleId, formNames, languages, p.row.Id),
                            className: iconBtnClass, style:{marginBottom:"2.75px"}}, uploadIcon);
                            
                    const popup = CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, btn);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  popup); //For disabled component, require a div to cover in order to show the popup.
                    
                    return container;
                } else {
                    const btn = CloverApp.API.createElement("button", {className: iconBtnDisabledClass }, uploadIcon);
                    const container = CloverApp.API.createElement("div", {...styleInlineBlock},  btn);
                    const popup=CloverApp.API.createElementWithPopup(uploadButtonText, popupProps, container);
                    
                    //Show a disabled button for other status 
                    return popup;
                }
            }     
        }

        const allActionsFormatter = function (p) {
            const elements = [];
            
            elements.push(excelUploadFormatter(p));
            
            if(p.row.UID !== "swzanonymous"){
                elements.push(trackFormatter(p));
            }
            
            elements.push(remarksFormatter(p));
            elements.push(delegateHistoryFormatter(p));
            const allBtn = CloverApp.API.createElement("div", {}, elements);
            return allBtn;
        };
        
        const statusFormatter  = function (p) {
            const isAnonymousRespondent = "swzanonymous"===p.row.UID;
            
            const elements = [];
            elements.push(resetFormatter(p));
            if(!isAnonymousRespondent){elements.push(rejectFormatter(p));}
            if(!isAnonymousRespondent){elements.push(exemptFormatter(p));}
            const updateStatusDiv = CloverApp.API.createElement("div", {style:{marginTop:"4px"} },elements );
            
            if(!isAnonymousRespondent){
                const statusText = p.value;
                const statusBtn = CloverApp.API.createElement("button", { 
                        onClick: () => dataeditordeploymentUserActions.showStatusModal(innerArgs, p.row.Id), 
                        className: "ui button mini secondary invert", 
                        style: { minWidth: "100px" }, 
                    },statusText);
                return [statusBtn, updateStatusDiv];
            }else{
                return [updateStatusDiv];
            }
            
        }; 
        
        const uploadedExcelLinksFormatter = function (p) {
            const elements = [];

            //Response download link
            if(p.row.IsExcelResponse) {
                const responseLinkText = dayjs(p.row.ExcelUploadDate).format("DD MMM YYYY HH:mm");// + (p.row.IsExcelResponseDE ? " (DE)" : "");
                const downloadUrl = "/dataedit/download/response/" + p.row.Id + "/" + p.row.RespId;
                const downloadLinkBtn = [];
                const linkBtn = CloverApp.API.createElement("a", 
                    { href: downloadUrl, target: "_blank", style: {fontStyle: "italic"}},
                    responseLinkText);    
                    downloadLinkBtn.push(linkBtn);
                if(p.row.IsExcelResponseDE){
                    element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                    downloadLinkBtn.push(element);
                    const dataEditorIcon = CloverApp.API.createElement("i",{className: "edit icon",ariaHidden: "true" }, "");
                    element = CloverApp.API.createElementWithPopup("By Data Editor", popupProps, dataEditorIcon);
                    downloadLinkBtn.push(element);
                }
                
                const marginDiv = CloverApp.API.createElement("div", {style:{marginTop:"4px"} },downloadLinkBtn );      
                elements.push(marginDiv);
                
            }
            
            if(elements.length===0) {
                elements.push( CloverApp.API.createElement("div", {}, p.value) );
            }
            return elements;
        }; //end of xlsxActionsFormatter

        const formNamesFormatter = function (p) {
            var elements = [];
            if(p.row.Type=="O"){
                var strFormNames = p.row.FormNames;
                var strLanguages = p.row.Languages;
                var formNames = strFormNames.split(''||'');
                var languages = strLanguages.split(''||'');      
                
                //formNames.forEach(genFormLinks.bind(null, p, elements, languages));
                formNames.forEach(genFormLinkButtons.bind(null, p, elements, languages));

                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, p.value); 
            }    
        }; //end of formNamesFormatter

        const fileNamesFormatter = function(p) {
            //const isExcelEnabled = innerArgs.data.IsExcelEnabled;
            const isExcelEnabled = true;
            if(p.row.Type=="O" && isExcelEnabled){
                var elements = [];
                var element;
                if(p.row.FileLanguages) {
                    const fileNames = p.row.FileNames.split(''||'');
                    const fileLanguages = p.row.FileLanguages.split(''||'');
                    const fileTokens = p.row.FileTokens.split(''||'');   
                    for(var i=0; i < fileNames.length; i++) {
                        const token = fileTokens[i];
                        const linkUrl = "/dataedit/download/xlsx/" + p.row.Id + "/"  + token + "/" + p.row.RespId;
                        element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);            
                        elements.push(element);
                        element = CloverApp.API.createElement("span", {className: "linkPaddingRight"}, " ");
                        elements.push(element);
                        elements.push( CloverApp.API.createElement("br") );
                    }
                }
                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }  
        }; //end of FileNamesFormatter
        
        //origin indicators
        const initialResponseFormatter  = function (p) {
            
            //todo - define style in .css file as a class
            const attrAs =  { className: "ui label tiny", style: { margin: "2px", background: "#defffc" } };
            const attrBy =  { className: "ui label tiny", style: { margin: "2px", background: "#fffae0" } };
            const attrVia = { className: "ui label tiny", style: { margin: "2px", background: "#f0ffab" } };
            
            const elements = [];
            if(p.row.InitialResponseAs !== "Unknown" && p.row.InitialResponseAs !== "PrePopulated" && p.row.InitialResponseAs !== null){
                const iniResponseAs = CloverApp.API.createElement("div", attrAs, p.row.InitialResponseAs);
                elements.push(iniResponseAs);
            }
            
            if(p.row.InitialResponseBy !== "Unknown" && p.row.InitialResponseBy !== null){
                const iniResponseBy = CloverApp.API.createElement("div", attrBy, p.row.InitialResponseBy);
                elements.push(iniResponseBy);
            }
            
            if(p.row.Tags !== null && p.row.Tags !== ''[]'' && p.row.Tags !== undefined && p.row.Tags !== ''undefined'' && p.row.Tags !== ''null''){
                var tags = JSON.parse(p.row.Tags);
                let tagsLabel = new Array();
                if(tags.length > 3) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label tiny", style: {margin: "2px"}}, tags.length));
                } else {
                    for(x=0;x<tags.length;x++) {
                        tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label tiny", style: {margin: "2px"}}, tags[x]));
                    }
                }
                elements.push(CloverApp.API.createElement("div", {title: tags, className:"react-grid-Cell-Comments"}, tagsLabel)); 
            }
            
            // via is hidden since we only have online now
            /*if(p.row.InitialResponseVia !== "Unknown" && p.row.InitialResponseVia !== null){
                const iniResponseVia = CloverApp.API.createElement("div", attrVia, p.row.InitialResponseVia);
                elements.push(iniResponseVia);
            }*/
            return elements;
            
        };  

        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );

                cols.FormNames.customFormatter = formNamesFormatter;
                cols.FileNames.customFormatter = fileNamesFormatter;
                cols.InitialResponse.customFormatter = initialResponseFormatter;
                cols.StatusTitle.customFormatter = statusFormatter;
                cols.ExcelSupport.customFormatter = uploadedExcelLinksFormatter; 
                cols.AllAction.customFormatter = allActionsFormatter; 
                
            }
            return model;
        }; //end of gridModelRewriter

        args.data.remarks = null;
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);

    }, //end of init...........................................................
    
    getAnonymousSampleInfo: function(args){
        var anonymousFormData = new FormData();
        anonymousFormData.append(''dplyid'',args.data.Id);
        Utils.loadingStart();
        Utils.getRequest("/dataeditor/getanonymoussampleinfo", anonymousFormData)
        .then(response => {
            if(response.success){
                CloverApp.API.setDataField("swzAnonymousDplySampleInfoId", response.item.swzAnonymousSampleInfoId);
                CloverApp.API.setDataField("dlsi", response.item.swzAnonymousSampleInfoId); 
                args.component.refs.btnAnonymousStatus.props.additionalParams.model.content = ''Status: '' + response.item.status;
                args.component.refs.btnAnonymousStatus.forceUpdate();
            }
        }, reason => {
            console.error("Failed to get anonymous sample info", reason);
            alertify(reason);
        }).finally(Utils.loadingStop);
    },
    
    showStatusModal: function (args, id) {
        const innerArgs = args; //Used in column formatters
        var formData = new FormData();
        if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
            id = args.data.swzAnonymousDplySampleInfoId;
        }
        
        formData.append(''id'', id);   
        CloverApp.API.setDataField("dlsi", id); 
        Utils.loadingStart("Retrieving Status Options");
        Utils.postFormRequest("/dataeditor/GetStatusItems", formData).then(
            response => {
                //args.state.app.extra.spData = id;
                //args.component.state.model[1].children[1].children[0]["data-elements"] = response.item;
                const options = response.item;
                if(Array.isArray(options) && options.length>0) {
                    CloverApp.API.changeModelControl(innerArgs, "dropdownStatus","data-elements", options);
                    CloverApp.API.setDataField("dropdownStatus", null);
                } else {
                    CloverApp.API.changeModelControl(innerArgs, "dropdownStatus","data-elements", {} );
                    CloverApp.API.setDataField("dropdownStatus", null);
                }
                
                args.component.refs.statusModal.props.swzData.isOpen = true;
                args.component.refs.statusModal.openModal();
                
                args.component.refs.dropdownStatus.forceUpdate();
                
            }, reason => {
                console.error("Failed to get status items", reason);
                alertify.error( Utils.encodeHTML(reason) );
                args.component.refs.statusModal.close();
            }
        ).finally(Utils.loadingStop);
    },
        
    addToTrkList: function (args) {

        var formData = new FormData();
        formData.append(''uid'', args.data.trkListSample_uid);
        formData.append(''email'', args.data.trkListSample_email);
        formData.append(''name'', args.data.trkListSample_name);
        formData.append(''remarks'', args.data.trkListSample_remarks);
        formData.append(''status'', args.data.trkListSample_status);
        formData.append(''trkListIds'', args.data.dictionaryTrkList);
        
        var url = ''/dataeditor/settrklists'';
        
        Utils.loadingStart("Updating Track List");
        Utils.postFormRequest(url, formData).then(
            response => {
                if (response.success) {
                    args.component.refs.grid.refresh();  
                    args.component.refs.trkListModal.close();
                    alertify.success( Utils.encodeHTML(response.message) );
                    CloverApp.API.setDataField("dictionaryTrkList", null);  
                    CloverApp.API.setDataField("trkListSample_uid", null);
                    CloverApp.API.setDataField("trkListSample_email", null);    
                    CloverApp.API.setDataField("trkListSample_name", null);                 
                    CloverApp.API.setDataField("trkListSample_remarks", null);
                    CloverApp.API.setDataField("trkListSample_status", null);       
                    CloverApp.API.setDataField("trkListSample_statusTitle", null);        
                } else {
                    alertify.error( Utils.encodeHTML(response.message) );
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(()=>{       
                Utils.loadingStop();
            });
    },    
    
    setStatusAsync: function (args) {
        var formData = new FormData();
        var selectedStatusId = args.component.refs.dropdownStatus.props.additionalParams.data.dropdownStatus;
        //console.log(''selectedStatusId'', selectedStatusId);
        if(selectedStatusId === undefined || selectedStatusId === null){
            alertify.error(''Please select a status.'');
            return;
        }
        
        formData.append(''id'', args.data.dlsi);        
        formData.append(''selectedStatusId'', selectedStatusId);
        
        var url = ''/dataeditor/setStatus'';
        
        Utils.loadingStart("Updating status...");
        Utils.postFormRequest(url, formData).then(
            response => {
                if (response.success) {
                    args.component.refs.statusModal.close();
                    args.component.refs.grid.refresh();
                    
                    if(args.data.IsAnonymous && args.data.swzAnonymousDplySampleInfoId){
                        dataeditordeploymentUserActions.getAnonymousSampleInfo(args);
                    }
                
                } else {
                    alertify.error( Utils.encodeHTML(response.message) );
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
    },
    
    submitRemarks: function (args) {
        const modal = args.component.refs.remarksModal;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);
        formData.append("remarks", args.data.remarks ? args.data.remarks.trim() : "");
        Utils.loadingStart("Updating Remarks");
        Utils.postFormRequest("/dataeditor/setremarks", formData).then(
            response => {
                modal.close();
                alertify.success( Utils.encodeHTML(response.message) );
                grid.refresh();
            }, reason => {
                console.error("Failed to update remarks.", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        return {};
    },
    
    promptForExcelFile: function(args) {
        const file = $("input[name=''ExcelFileUpload'']");
        file.trigger(''click'');
        return {};
    },
    
    excelFileUploaded: function(args) {
        const result = args.sourceControlValue; //ExcelFileUpload
        CloverApp.API.setDataField("ExcelFileUpload", null); 
        if(result === "OK") {
            args.component.refs.fileUploadModal.close(); 
            const qnnId = args.data.UploadQnnId;
            const dplyId = args.data.UploadDplyId;
            const listSampleId = args.data.UploadListSampleId;
            if( (!qnnId) || (!dplyId) || (!listSampleId)) {
                console.error("Missing required value for one of qnnId, dplyId, listSampleId", args.data);
                alertify.error("File processed successfully but an error occured opening the form. Try opening the form using the form link instead.", 15000);
                return {};
            }
            
            const uploadFormChoice = args.data.UploadFormChoice;
            const formName = args.data.UploadFormNames[uploadFormChoice];
            const uploadIndex = args.data.UploadIndex;
            args.component.refs.grid.refresh();
            alertify.success("Survey answers updated from file");
            if(formName) {
                CloverApp.API.redirect("form", formName, ''dlsi/''+ uploadIndex);
            }
        } else {
            let errorMessage = result;
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
            } else if ("INCORRECT UEN" === result) {
                errorMessage = "This file is for another respondent. The UEN recorded in the spreadsheet does not match your UEN.";
            }
            alertify.error( Utils.encodeHTML(errorMessage), 10000);
        }
        return {};
    }, //end of excelFileUploaded
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    rejectResponse: function(args) {
        const remarks = args.data.RejectResponseRemarks ? args.data.RejectResponseRemarks.trim() : ""
        if(""===remarks) {
            alertify.error("Remarks are required here");
            return {};
        }
        
        const modal = args.component.refs.mdl_RejectResponse;
        const grid = args.component.refs.grid;
        const formData = new FormData();
        formData.append("id", args.data.dlsi);  
        formData.append("respId", args.data.RejectResponseRespId);
        formData.append("remarks", remarks );
        Utils.loadingStart("Rejecting Response");
        Utils.postFormRequest("/dataeditor/rejectresponse",formData).then(
            response => {
                modal.close();
                grid.refresh();
                alertify.success( Utils.encodeHTML(response.message), 10000);
            }, reason => {
                console.error("Error rejecting response", reason);
                alertify.error( Utils.encodeHTML(reason), 15000);
                grid.refresh();
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeDelegateHistoryModal: function(innerArgs){
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
    onChangeSearch: function(args) {
        const caseSearch = args.data.CaseSearch ? args.data.CaseSearch : null;
        const generalSearch = args.data.GeneralSearch ? args.data.GeneralSearch : null;
        const selectedStatus = args.data.dictStatus && args.data.dictStatus.length>0 ? args.data.dictStatus : null;
        const filterComplete = args.data.dropdownComplete ? args.data.dropdownComplete : null;
        var filterArr = [];
        
        if(caseSearch) {
            filterArr.push({
                column: "UID",
                term: "like",
                value: caseSearch
            });
        }
        
        if(generalSearch) {
            filterArr.push({
                column: "UIDName, UpdatedBy, StatusTitle, ToEmails, InitialResponseAs, InitialResponseBy, InitialResponseVia",
                term: "like",
                value: generalSearch
            });
        }
        
        if(selectedStatus) {
            const tempArr = [];
            for(let i = 0; i < selectedStatus.length; i++){
                tempArr.push(selectedStatus[i]);
            };
            
            filterArr.push({
                column: "Status",
                term: "in",
                value: tempArr
            });
        }

        if(filterComplete) {
            filterArr.push({
               column: "DateComplete",
               nextValue: "",
               term: filterComplete == "true" ? "!=" : "=",
               value: "",
            });
        }
        
        return {
            app: {
                form: {
                    filters: {
                        main: {
                            grid: filterArr
                            }
                    }
                }
            }
        };
        
    },

}






' WHERE [Id]='4af67164-5e60-4905-9885-afd6da24cb3d';

UPDATE [dwMetadata] SET
[Id]='774bf1e8-60a0-44f9-b942-478cb9ecb120', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'DataEditorDeploymentList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:18.560', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 13:55:06.577', 
[Data]=N'{
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
      
    var gridModelRewriter = function (model) {
        if (Array.isArray(model.columns)) {
            const cols = model.columns.reduce((idx, column) => {
                if(column.key) { idx[column.key] = column; }
                return idx;
            }, {} );
            
            cols.Tags.customFormatter = tagsColumnFormatter;
            cols.Name.customFormatter = nameFormatter;
        }
        return model;
    };
    const nameFormatter = function(p) {
        var url = "/form/DataEditorDeployment/" + p.row.DplyId;
        //return CloverApp.API.createElement("a", { href: url}, p.value);  
        //return "<a href=''www.google.com''>" +p.value+ "</a>";
        return CloverApp.API.createElement("span", { onClick: () =>  {
            CloverApp.API.redirect(''form'', ''DataEditorDeployment'', p.row.Id)
            }, className: "link-style" }, p.value);
    }
    const tagsColumnFormatter = function (p){
        if(p.row.Tags == null) {
            return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
        }
        let tags = JSON.parse(p.row.Tags);
        let tagsLabel = new Array();

        if(tags.length > 3) {
            tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
        } else {
            for(x=0;x<tags.length;x++) {
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
            }
        }
        return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        
    };
    CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    
    //var count = args.component.refs.grid.state.rowsCount;
    //var counter = 0;
    //var gridData = args.component.refs.grid.state.items;
    //
    //for(var i=0; i<gridData.length;i++){
    //    if(gridData[i].RespCount == gridData[i].SampleCount){
    //        counter++;
    //    }
    //}
     
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
                
                var editorLabel = [''In-Progress Deployment'',''Completed Deployment''];
                var barData = [response.item.NotCompleted,response.item.Completed];
                
                var value = {
                                    labels: editorLabel,
                                    datasets: [
                                      {
                                        data: barData,
                                        backgroundColor:["#E91E63","#2196F3"],
                                        label: "Count",
                                      }
                                    ]
                                };
                CloverApp.API.setDataField("editorBarChart", value);               

            } else {
                alertify.error( Utils.encodeHTML(response.message) );
            }

        })
        .catch(error => {
            alertify.error( Utils.encodeHTML(error.message) );
        });  
    
  }
}
' WHERE [Id]='774bf1e8-60a0-44f9-b942-478cb9ecb120';

UPDATE [dwMetadata] SET
[Id]='6122cf0b-786e-4824-9db3-81870fead8a8', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyListSample-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 14:09:24.810', 
[Data]=N'{
    addNewSample: function(args){
        const gridListSamples = args.controlRef;
        const dplyId = args.data.Id;
        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("listId", listId);   
        Utils.loadingStart("Updating deployment samples from list");
        Utils.postFormRequest("/deployment/addnewsample", formData).then( 
            result => {
                alertify.success( Utils.encodeHTML(result.message) );
            }, reason => {
                console.error("addnewSample failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of addNewSample
    
    closeModal: function(args) {
        args.controlRef.close(); //expects modal as event target    
    },
    
    onOpenManageDueDate: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalDueDate = args.component.refs.modalDueDate;
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    changeDueDate: function(args){
		const modalDueDate = args.component.refs.modalDueDate;	
		const gridListSamples = args.controlRef; //expects grid as event target	
		const selectedGridIndices = gridListSamples.state.selectedIndexes;	
		
        const noSamplesSelectedInGrid = (selectedGridIndices.length===0);
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
        }
        const dueDate = args.data.dueDate;
        if(dueDate==null || dueDate==='''') {
            alertify.error("Please select the due date");
            return {};
        }else if(Date.parse(dueDate) <= Date.parse(args.data.DateStart)){
            alertify.error("Due Date must be after Deployment Start Date (" + CloverApp.API.formatDatetime(args.data.DateStart, window.CloverLang.common.datetimeFormat) + ")");
            return {};
        }
        const dplyId = args.data.Id;
        const listSampleIds = selectedGridIndices.map( gridIndex => gridListSamples.state.items[gridIndex].ListSampleId );
        const listId = args.data.ListId;
        
        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("dueDate", dueDate);
        formData.append(''listSampleIds'', listSampleIds);     
        Utils.loadingStart("Updating Due Dates");
        Utils.postFormRequest("/deployment/changeDueDate",formData).then(
            result => {
                gridListSamples.refresh();
                modalDueDate.close();
                alertify.success( Utils.encodeHTML(result.message) );
            }, reason => { 
                console.error("changeDueDate failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of changeDueDate

    onOpenSendMessage: function(args){
        const noSamplesSelectedInGrid = (args.component.refs.gridListSamples.state.selectedIndexes.length===0);
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        if(noSamplesSelectedInGrid){
            modalSendMessage.close();
            alertify.error("Please select at least one list sample");
        }
        return {};
    },
    
    //previously named sendMessage
    profileMailMergeToSamples: function(args){
        const modalSendMessage = args.component.refs.modalSendMessage;
        
        const dplyId = args.data.Id;
        const mailMerge = (args.data.cbMailMerge==null || args.data.cbMailMerge==undefined)? false : args.data.cbMailMerge;
        const email = (args.data.cbEmail==null || args.data.cbEmail==undefined)? false : args.data.cbEmail;
        const emailFrom = (email && args.data.emailFrom)? args.data.emailFrom : "";
        const scheduledDate = (email && args.data.scheduledDate)? args.data.scheduledDate : "";
        const profile = (args.data.cbProfile==null || args.data.cbProfile==undefined)? false : args.data.cbProfile;
 
        if(!mailMerge && !email && !profile){
            return alertify.error("Check at least one");
        }
        
        let validated = true;
        let msgContent = "";
        let msgContentJson = "";
        if(email || mailMerge){
            msgContent = args.data.UseRawHtml ? args.data.htmlRaw : args.component.refs.htmlEditor.state.htmlData;
            msgContentJson = args.data.UseRawHtml ? null : JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        }
        const subject = args.data.subject;

        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Message content is required");
            validated = false;
        }
        
        if(!validated){
            return {};
        }
                
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].ListSampleId );

        const listId = args.data.ListId;
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''profile'', profile);        
        formData.append(''subject'', subject);
        formData.append(''email'', email);    
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);        
        formData.append(''listSampleIds'', listSampleIds);     
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToSamples", formData).then(
            result => {
                modalSendMessage.close();
                alertify.success( Utils.encodeHTML(result.message) );
                CloverApp.API.setDataField("htmlRaw","");
            }, reason => {
                console.error("sendMessage failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
        return {};
        
    }, //end of sendMessage
    
    sampleResetPassword: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);
        
        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }
        
        const sampleIds = gridListSamples.state.selectedIndexes.map( gridIndex => gridListSamples.state.items[gridIndex].SampleId);
        const formData = new FormData();
        formData.append("sampleIds", sampleIds);   
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetresppassword", formData).then(
            result => {
                alertify.success( Utils.encodeHTML(result.message) );
            }, reason => {
                console.error("sampleResetPassword failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).then(Utils.loadingStop);
        return {};
    },
        
    sampleResetDelegationCode: function(args){
        const gridListSamples = args.component.refs.gridListSamples;
        const noSamplesSelectedInGrid = (gridListSamples.state.selectedIndexes.length===0);

        if(noSamplesSelectedInGrid){
            modalDueDate.close();
            alertify.error("Please select at least one list sample");
            return {};
        }        

        const sampleIds = gridListSamples.state.selectedIndexes
            .map( gridIndex => gridListSamples.state.items[gridIndex]) //extract selected grid items
            .map( item => { return { sampleId: item.SampleId, sampleInfoId: item.Id } } ); //extract objects with desired ids

        const formData = new FormData();
        formData.append("sampleIds", JSON.stringify(sampleIds));
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetrespdelegationcode", formData).then(
            result => {
                alertify.success( Utils.encodeHTML(result.message) );
            }, reason => {
                console.error("sampleResetDelegationCode failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
        return {};
    }, //end of sampleResetDelegationCode

}' WHERE [Id]='6122cf0b-786e-4824-9db3-81870fead8a8';

UPDATE [dwMetadata] SET
[Id]='0c290d6f-5456-4ab4-913f-12cd3a456147', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMaintenance-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-11-02 15:04:38.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 14:12:29.333', 
[Data]=N'{
    init: function(args) {
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("ResponseUpload", model => {
            model.customPostUrl = "/deployment/import/responseupload/" + encodeURIComponent(dplyId);
            model.onUploadBegin = () => Utils.loadingStart("Transferring file...");
            model.onUploadEnd = (ctrl, success, xhr, msg, err) => {
                //console.log("ctrl", ctrl, "success", success, "xhr", xhr, "msg", msg, "err", err);
                Utils.loadingStop();
                if(!success) {
                    console.log("Upload failed", xhr, msg, err);
                    if(xhr.status=== 400) {
                        alertify.error( Utils.encodeHTML("Upload Failed - " + xhr.statusText + " - " + xhr.responseText), 20000);
                    } else if(xhr.status===413) {
                        alertify.error("Upload Failed - the selected file is too large to be uploaded here", 20000);
                    } else {
                        alertify.error( Utils.encodeHTML("Upload Failed - " + msg + " - " + err), 20000);
                    }
                } else {
                    console.error(xhr.message);
                    if("OK" == xhr.message) {
                        alertify.success("File transferred to server, you will be notified by email when processing is complete", 20000);
                    } else if("FAIL" == xhr.message) {
                        alertify.error("Failed to transfer the file to the server.", 20000);
                    } else {
                        alertify.error("This file is not valid. Please check that you have the correct file.", 20000);
                    }
                }
            }
        });  
        
        CloverApp.API.rewriteControlModel("SampleOwnerUpload", model => {
            model.customPostUrl = "/deployment/import/sampleownerupload/" + encodeURIComponent(dplyId);
            model.onUploadBegin = () => Utils.loadingStart("Transferring file...");
            model.onUploadEnd = (ctrl, success, xhr, msg, err) => {
                //console.log("ctrl", ctrl, "success", success, "xhr", xhr, "msg", msg, "err", err);
                Utils.loadingStop();
                if(!success) {
                    console.log("Upload failed", xhr, msg, err);
                    if(xhr.status=== 400) {
                        alertify.error("Upload Failed - " + xhr.statusText + " - " + xhr.responseText, 20000);
                    } else if(xhr.status===413) {
                        alertify.error("Upload Failed - the selected file is too large to be uploaded here", 20000);
                    } else {
                        alertify.error("Upload Failed - " + msg + " - " + err, 20000);
                    }
                } else {
                    console.error(xhr.message);
                    if("OK" == xhr.message) {
                        alertify.success("File transferred to server, you will be notified by email when processing is complete", 20000);
                    } else if("FAIL" == xhr.message) {
                        alertify.error("Failed to transfer the file to the server.", 20000);
                    } else {
                        alertify.error("This file is not valid. Please check that you have the correct file.", 20000);
                    }
                }
            }
        });  
    },
    
    applyDates: function(args) {
        //TODO - ensure correct format
        const dplyId = args.data.Id;
        const dateStart = new Date(args.data.DateStart).toISOString();
        const dateEnd = new Date(args.data.DateEnd).toISOString();
        console.log("dateStart", dateStart, "dateEnd", dateEnd);
        const form = new FormData();
        form.append("dplyId", dplyId);
        form.append("dateStart", dateStart);
        form.append("dateEnd", dateEnd);
        Utils.loadingStart("Saving the date...");
        Utils.postFormRequest("/deployment/maintenance/applyDates", form).then(
            response => { 
                alertify.success("Dates updated",20000);
                window.setTimeout(()=>{window.location=window.location},1000);
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), 20000);
                Utils.loadingStop();
            }
        )
    },
    
    
}' WHERE [Id]='0c290d6f-5456-4ab4-913f-12cd3a456147';

UPDATE [dwMetadata] SET
[Id]='87ead053-54cb-4735-8cbc-e812f3344ab3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-23 12:29:26.007', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 14:17:16.990', 
[Data]=N'{
    init: function(args){
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format(''DD MMM YYYY HH:mm'');
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    $("span[name=''StatusStatic''] > p[name=''status'']").append("<a class=''ui label''>" + entry.ForStatus_Title + "</a>");
                });
        }
    },
    
    cancelJob: function(args){
        Utils.loadingStart();
        const formData = new FormData();
        formData.append(''dplyMsgId'', args.data.Id);
        Utils.postFormRequest("/deployment/canceljob",formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                Utils.queueHideControl("cancelJob");
                Utils.queueHideControl("swzmodal_2");
            }, reason => {
                console.log("Cancel job failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
       return{};
    },
    
    //renamed from editEmailToStatus
    updateProfileMailMerge: function(args){
        const dplyMsgId = args.data.Id;
        const dplyId = args.data.DplyId;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        
        //lowercase msg would be used after onHtmlChange was invoked
        const msgContentJson = args.data.UseRawHtml 
            ? "" 
            : (args.data.msgContentJson) ? args.data.msgContentJson : args.data.MsgContentJson;
        const msgContent = args.data.UseRawHtml
            ? args.data.htmlRaw
            : args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        
        const subject = args.data.emailSubj;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        const listSampleIds = args.data.targetSamples ? args.data.targetSamples : "";

        let validated = true;
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent==undefined || msgContent==null){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(!args.data.UseRawHtml) {
            if(msgContentJson==undefined || msgContentJson==null){
                alertify.error("Email content is required");
                validated = false;
            }
        }

        if(status.length==0 && listSampleIds.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        const listId = args.data.ListId;
        const formData = new FormData();
        
        let url = "";
        if(status.length !== 0 && listSampleIds.length ==0){
            url = "/deployment/profileMailMergeToStatus";
            formData.append(''status'', status);
        } 
        if(listSampleIds.length !== 0 && status.length ==0){
            url = "/deployment/profileMailMergeToSamples";
            formData.append(''listSampleIds'',listSampleIds);
            formData.append(''mailMerge'', args.data.NotifyMerge);
            formData.append(''email'', args.data.NotifyEmail);
            formData.append(''profile'', args.data.NotifyGenerate);
        }

        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''dplyMsgId'', dplyMsgId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? "");
        formData.append(''scheduledDate'', scheduledDate);
        
        if(validated){
            Utils.loadingStart();
            Utils.postFormRequest(url,formData).then(
                response => {
                    args.component.refs.swzmodal_2.close();
                    const reloadUrl = "/form/dplyMessage/" + encodeURIComponent(dplyMsgId);
                    window.setTimeout( () => window.location=reloadUrl, 500); //hard reload
                    alertify.success( Utils.encodeHTML(response.message) );
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        }

        return {};
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    
    onEditClick: function (args) {
        var statuslist = [];
        var samplelist = [];
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
            CloverApp.API.setDataField("dictionaryStatus",statuslist);
        }
        if(args.data.SampleCollection.length > 0){
            args.data.SampleCollection.forEach(
                (entry) => {
                    samplelist.push(entry.ListSampleId);
                });
            CloverApp.API.setDataField("targetSamples",samplelist);
        }

        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        if(args.data.MsgContentJson && args.data.MsgContentJson && args.data.MsgContentJson != '''') {
            CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
            CloverApp.API.setDataField("UseRawHtml",false);
            Utils.queueHideControl("msgContentEditor","show");
            Utils.queueHideControl("htmlRaw","hide");
        } else {
            CloverApp.API.setDataField("msgContentEditor","");
            CloverApp.API.setDataField("UseRawHtml",true);
            CloverApp.API.setDataField("htmlRaw",args.data.MsgContent);
            Utils.queueHideControl("msgContentEditor","hide");
            Utils.queueHideControl("htmlRaw","show");
        }
        return { app:{} }
    },
    
    onHtmlChange: function (args){
        var contentDataJson =  JSON.stringify(args.component.refs.msgContentEditor.state.jsonData);
        var contentData =  args.component.refs.msgContentEditor.state.htmlData;
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            msgContentJson: contentDataJson,
                            msgContent: contentData
                        }
                    }
                }
            }
        }
    },
    
}' WHERE [Id]='87ead053-54cb-4735-8cbc-e812f3344ab3';

UPDATE [dwMetadata] SET
[Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyMessages-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.507', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 15:22:56.627', 
[Data]=N'{
    init: function(args) { 
        const innerArgs = args;
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[1].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyMerge){
                        var url = "/deployment/downloadMailMerge/" + p.row.MergeOutputToken;
                        if(p.row.MergeDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Pending");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                model.columns[2].customFormatter = function (p) {

                    if(p.row.NotifyEmail){
                        return CloverApp.API.createElement("span", {onClick: (e)=> {e.stopPropagation();CloverApp.API.redirectToForm("dplyMessage", p.row.Id)}, className: ''link-style''}, ''Yes'');
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                  
                };
                
                model.columns[3].customFormatter = function (p) {
                    //console.log("p: ", p);
                    if(p.row.NotifyGenerate){
                        var url = "/deployment/downloadProfile/" + p.row.GenerateProfileOutputToken;
                        if(p.row.GenerateProfileDone)
                            return CloverApp.API.createElement("a", {onClick: (e)=>{e.stopPropagation()}, href: url, className: "ui button mini secondary invert"}, "Download");
                        return CloverApp.API.createElement("button", {className: "ui button mini disabled" }, "Pending");
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "No");                        
                    }
                };              
            }
            return model;
        }; //end of gridModelRewriter
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    },
  
    goBack: function(args) {
        args.state.router.history.goBack();
    },
 
    //renamed from emailToStatus
    profileMailMergeToStatus: function(args){

        const dplyId = args.data.Id;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContent =  args.data.UseRawHtml
            ? args.data.htmlRaw
            : args.component.refs.htmlEditor.state.htmlData;
        const msgContentJson = args.data.UseRawHtml
            ? ""
            : JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        const subject = args.data.subject;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        
        let validated = true;
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if(status.length==0){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            return {};
        }

        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? "");
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToStatus",formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                alertify.success( Utils.encodeHTML(response.message) );
                args.controlRef.refresh();
                CloverApp.API.setDataField("htmlRaw","");
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    //renamed from msgToStatus
    profileMailMergeToStatusImmediate: function(args){
        const dplyId = args.data.Id;
        const mailMerge = (args.data.msgMailMerge==null || args.data.msgMailMerge==undefined)? false : args.data.msgMailMerge;
        const email = (args.data.msgEmail==null || args.data.msgEmail==undefined)? false : args.data.msgEmail;
        const profile = (args.data.msgProfile==null || args.data.msgProfile==undefined)? false : args.data.msgProfile;
        const emailFrom = (email && args.data.msgEmailFrom)? args.data.msgEmailFrom : "";
        const subject = args.data.msgSubject;
        const status = args.data.msgStatus ? args.data.msgStatus : "";

        let validated = true;
        let msgContent = "";
        let msgContentJson = "";
        if(email || mailMerge){
            if(args.data.msgUseRawHtml) {
                msgContent = args.data.msgHtmlRaw;
                msgContentJson = "";
            } else {
                msgContent = args.component.refs.msgContent.state.htmlData;
                msgContentJson = args.component.refs.msgContent.state.jsonData;
            }
            
        }
        
        if(email && (subject==undefined || subject==null || subject.length==0)){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if((email || mailMerge) && msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }
        
        if((email || mailMerge || profile) && (status==undefined || status==null || status.length==0)){
            alertify.error("Status is required");
            validated = false;
        }

        if(!validated){
            return {};
        }
        
        const formData = new FormData();
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''dplyId'', dplyId);
        formData.append(''mailMerge'', mailMerge);
        formData.append(''email'', email);    
        formData.append(''profile'', profile);       
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ?? ""); 
        formData.append(''status'', status);
        
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/profileMailMergeToStatusImmediate", formData).then(
            response => {
                args.component.refs.swzmodal_1.close();
                alertify.success( Utils.encodeHTML(response.message) );
                args.controlRef.refresh();
                CloverApp.API.setDataField("msgHtmlRaw","");
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },

    actionAddAllFields: function(args){
        var options = args.component.refs.msgStatus.state.options;
        var keys = [];
        if(options != null) {
            for(var x = 0 ; x < options.length ; x++){
                    keys.push(options[x].key);
                }
        }
        CloverApp.API.setDataField("msgStatus", keys);
        
    },
    
    actionRemoveAllFields: function(args){
        CloverApp.API.setDataField("msgStatus", []);
    },
    
    actionAddAllFieldsSchedule: function(args){
        var options = args.component.refs.dictionaryStatus.state.options;
        var keys = [];
        if(options != null) {
            for(var x = 0 ; x < options.length ; x++){
                    keys.push(options[x].key);
                }
        }
        CloverApp.API.setDataField("dictionaryStatus", keys);
        
    },
    
    actionRemoveAllFieldsSchedule: function(args){
        CloverApp.API.setDataField("dictionaryStatus", []);
    },

}' WHERE [Id]='179e2ea8-3e6a-4abc-b861-c582873ed86f';

UPDATE [dwMetadata] SET
[Id]='548924d4-bec7-4469-952a-739f7dcf4e77', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyRecurrence-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-10-20 00:43:16.763', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 15:31:56.790', 
[Data]=N'{
    init: function(args) {
        
        const data = args.data;
        if(data.RecurrenceAdvanceDays===undefined || data.RecurrenceAdvanceDays===null || data.RecurrenceAdvanceDays === 0) {
            CloverApp.API.setDataField("IsCreateInAdvance", false);
            CloverApp.API.setDataField("RecurrenceAdvanceDays", 0);
        } else if (data.RecurrenceAdvanceDays > 0) {
            CloverApp.API.setDataField("IsCreateInAdvance", true);
        }
        
        if(!(data.RecurrenceNextDate===undefined || data.RecurrenceNextDate===null)) {
            CloverApp.API.setDataField("msg_NextDeployment", data.RecurrenceNextDate );
        }
        
        CloverApp.API.setDataField("UpdatedDate", new Date()); //for trigger
        
        const customRecurrenceOnFormatter = function(p) {
            if(p.row.CustomFrequencyType !== undefined){
                const CFType = p.row.CustomFrequencyType;
                const CFDayAndWeek = p.row.RecurDay;
                const CFMonth = p.row.RecurMonth;
                const CFYear = p.row.RecurYear;
                let dateValue = new Date(CFYear,CFMonth - 1,CFDayAndWeek);
                let customMonth = 0;
                
                if(dateValue.getMonth()+1 !== CFMonth){
                    dateValue = new Date(CFYear,CFMonth - 1, 1);
                }
                let value = "";
                switch(CFType) {
                    case "EXACT DATE":
                        value = CloverApp.API.formatDatetime(dateValue, window.CloverLang.common.dateFormat);
                        break;
                    case "N DAY N MONTH":
                        value = "Day " + CFDayAndWeek + " of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N LAST DAY N MONTH":
                        value = "Last " + CFDayAndWeek + " Day of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N WEEK N MONTH":
                        value = "Week " + CFDayAndWeek + " of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N LAST WEEK N MONTH":
                        value = "Last " + CFDayAndWeek + " Week of " + CloverApp.API.formatDatetime(dateValue, "MMM");
                        break;
                    case "N DAY EACH MONTH":
                        value = "Day " + CFDayAndWeek + " of Every Month";
                        break;
                    case "N LAST DAY EACH MONTH":
                        value = "Last " + CFDayAndWeek + " Day of Every Month";
                        break;
                    case "N WEEK EACH MONTH":
                        value = "Week " + CFDayAndWeek + " of Every Month";
                        break;
                    case "N LAST WEEK EACH MONTH":
                        value = "Last " + CFDayAndWeek + " Week of Every Month";
                        break;
                    default:
                        console.log("Error: unknown custom frequency type ", CFType);
                        return CloverApp.API.createElement("div", {}, ""); 
                }
                
                return CloverApp.API.createElement("div", {}, value); 
            }
                
            return CloverApp.API.createElement("div", {}, ""); 
            
        }; //end of customFrequencyValueFormatter

        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {   
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                },{}); 
                
                cols.RecurrenceOn.sortable = false;
                cols.RecurrenceOn.customFormatter = customRecurrenceOnFormatter;      

            }
            return model;
        }; //end of gridModelRewriter
        
        CloverApp.API.rewriteControlModel("gdCustomFrequency", gridModelRewriter);

        return {};
    },
    
    addAllFields: function(args){
        var allFields = args.data.PrePopulateFields;
        if(allFields != null) {
            for(var x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = true;
            }
            CloverApp.API.setDataField("PrePopulateFields", allFields);
        }
    },
    
    removeAllFields: function(args){
        var allFields = args.data.PrePopulateFields;
        if(allFields != null) {
            for(var x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = false;
            }
            CloverApp.API.setDataField("PrePopulateFields", allFields);
        }
    },
    
    updateRecurrence: function(args) {
        const data = args.data;
        
        if(data.RecurrenceEnabled) {
            if(data.RecurrenceAdvanceDays > 0 && !Number.isInteger(Number(data.RecurrenceAdvanceDays))) {
                alertify.error("Advance days must be a whole number");
                return {};
            }
        }
        
        if(data.RecurrenceEndDate != null){
            const date = new Date(data.RecurrenceEndDate);
            
            if(isNaN(date)) {
                alertify.error("Value specified for ''Do not recur on or after'' is not a valid date");
                return {};
            }
            
            const now = new Date();
            if(date < now) {
                alertify.error("Date specified for ''Do not recur on or after'' may not be in the past");
                return {};
            }
            data.RecurrenceEndDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        }
        
        Utils.loadingStart("Updating deployment");
        Utils.postJsonRequest("/deployment/updaterecurrence", data).then(
            response => {
                alertify.success("Recurrency settings updated");
                window.location = window.location;
            }, reason => {
                console.error(reason);
                Utils.loadingStop();
                alertify.error( Utils.encodeHTML(reason) );
                return {};
            }
        ) //(absent finally is intentional);
        return {};
    },
    
    toggleDaysInAdvance: function(args) {
        var delta = {};
        if(!args.data.IsCreateInAdvance) {
            CloverApp.API.setDataField("RecurrenceAdvanceDays", 0);
            const hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
            if(!hideControls.includes("RecurrenceAdvanceDays")) {
                hideControls.push("RecurrenceAdvanceDays");
                delta = {
                    app: {
                        form: {
                            models: {
                                hideControls,
                            }
                        }
                    }    
                };
            }
        }
        return delta;
    },
    
    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            Utils.redirectToForm("QNN_DPLY", args.data.RecurrenceOfDplyId);
        }    
    },
    
    closeCustomFrequencyModal: function(args){
        args.component.refs.customFrequencyModal.close();
    },
    
    saveCustomFrequency: async function(args){
        //CF = CustomFrequency
        const validateCFInput = function(CFType, CFDay, CFWeek, CFMonth, CFDate) {
            const errMsg = [];
            
            if(!Boolean(CFType)){
                errMsg.push("Please select custom frequency type.");
            }else if(CFType === "N DAY N MONTH" || CFType === "N LAST DAY N MONTH"){
                if(!Boolean(CFDay)){    errMsg.push("Please select a day."); }
                if(!Boolean(CFMonth)){  errMsg.push("Please select a month."); }
                if(errMsg.length === 0){
                    const checkValidDate = new Date("0004",CFMonth - 1,CFDay);
                    if(checkValidDate.getMonth() + 1 !== parseInt(CFMonth)){ errMsg.push("Please select a valid date.");}
                }
            }else if(CFType === "N WEEK N MONTH" || CFType === "N LAST WEEK N MONTH"){
                if(!Boolean(CFWeek)){   errMsg.push("Please select a week."); }
                if(!Boolean(CFMonth)){  errMsg.push("Please select a month."); }
            }else if(CFType === "N DAY EACH MONTH" || CFType === "N LAST DAY EACH MONTH"){
                if(!Boolean(CFDay)){    errMsg.push("Please select a day."); }
            }else if(CFType === "N WEEK EACH MONTH" || CFType === "N LAST WEEK EACH MONTH"){
                if(!Boolean(CFWeek)){   errMsg.push("Please select a week."); }
            }else if(CFType === "EXACT DATE"){
                if(!Boolean(CFDate)){   errMsg.push("Please select a date."); }
            }else{
                errMsg.push("Unknown custom frequency type.");
                console.log("Error: unknown custom frequency type ", CFType);
            }
            
            if(errMsg.length > 0){ 
                errMsg.forEach( function(msg){
                    alertify.error( Utils.encodeHTML(msg) );
                }); 
            }
            
            return errMsg.length == 0;
        }; 
        
        const saveCFAPI = function(SelectedId, DplyId, CFType, CFDay, CFMonth, CFYear){
            const formData = new FormData();
            formData.append(''SelectedId'', SelectedId);
            formData.append(''dplyId'', DplyId);
            formData.append(''frequencyType'', CFType);
            formData.append(''frequencyDay'', CFDay);
            formData.append(''frequencyMonth'', CFMonth);
            formData.append(''frequencyYear'', CFYear);
            
            const promise = Utils.postFormRequest("/deployment/savedplycustomfrequencyrecurrence/",formData).then(
                response => {
                    alertify.success(''Saved successfully.'');
                    return true;
                }, reason => {
                    alertify.error( Utils.encodeHTML(response.message) );
                    return false;
                }
            );
            return promise;
        };
        
        const recurType = args.data.CustomFrequencyType;
        const isCFValid = validateCFInput(recurType, args.data.CustomFrequencyDay, args.data.CustomFrequencyWeek, args.data.CustomFrequencyMonth, args.data.CustomFrequencyDate);
        
        let recurDay = 1;
        let recurMonth = 1;
        let recurYear = "0004";
        
        if(recurType !== "EXACT DATE"){
            recurDay = args.data.CustomFrequencyDay;
            
            if(recurType.indexOf("WEEK") > -1){
                recurDay = args.data.CustomFrequencyWeek;
            }
            
            if(recurType.indexOf("EACH MONTH") === -1){
                recurMonth = args.data.CustomFrequencyMonth;
            }
            
        }else{
            let recurDate = new Date(args.data.CustomFrequencyDate);
            recurDay = recurDate.getDate();
            recurMonth = recurDate.getMonth() + 1;
            recurYear = recurDate.getFullYear();
        }
        
        if(isCFValid){
            const result = await saveCFAPI(args.data.SelectedCustomFrequencyId, args.data.Id, recurType, recurDay, recurMonth, recurYear);
            if(result){
                args.component.refs.gdCustomFrequency.refresh();   
                args.component.refs.customFrequencyModal.close();     
            }
            
        }
    },
    
    setCustomFrequencyControlsVisibility: function(args){
        args.component.refs.customFrequencyModal.openModal();
        
        const selectedItem = args.component.refs.gdCustomFrequency.state.items[args.parameters.rowIdx];
        const CustomFrequencyType = selectedItem.CustomFrequencyType;
        let hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
        hideControls = hideControls.filter(function(item){ 
            return item !== "CustomFrequencyDay" 
                && item !== "CustomFrequencyWeek" 
                && item !== "CustomFrequencyMonth" 
                && item !== "CustomFrequencyDate" 
                && item !== "customFrequencyDateSpacing"
        });
        
        if(CustomFrequencyType === "N DAY N MONTH" || CustomFrequencyType === "N LAST DAY N MONTH"){
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyDate");
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N WEEK N MONTH" || CustomFrequencyType === "N LAST WEEK N MONTH"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyDate");
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N DAY EACH MONTH" || CustomFrequencyType === "N LAST DAY EACH MONTH"){
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyMonth"); 
            hideControls.push("CustomFrequencyDate"); 
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "N WEEK EACH MONTH" || CustomFrequencyType === "N LAST WEEK EACH MONTH"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyMonth"); 
            hideControls.push("CustomFrequencyDate"); 
            hideControls.push("customFrequencyDateSpacing");
        } else if(CustomFrequencyType === "EXACT DATE"){
            hideControls.push("CustomFrequencyDay");
            hideControls.push("CustomFrequencyWeek");
            hideControls.push("CustomFrequencyMonth"); 
        } else{
            alertify.error("Unknown custom frequency type.");
            console.log("Error: unknown custom frequency type ", CustomFrequencyType);
            return {};
        }
        
        delta = {
            app: {
                form: {
                    models: {
                        hideControls,
                    }
                }
            }    
        };
        return delta;
    },
    
    setCustomFrequencyControlsValue:function(args){
        const selectedItem = args.component.refs.gdCustomFrequency.state.items[args.parameters.rowIdx];
        
        let recurYear = selectedItem.RecurYear;
        if(selectedItem.CustomFrequencyType !== "EXACT DATE"){
            recurYear = new Date().getFullYear();
        }
        const dateValue = new Date(recurYear, (selectedItem.RecurMonth - 1), selectedItem.RecurDay);
        CloverApp.API.setDataField("CustomFrequencyType", selectedItem.CustomFrequencyType); 
        CloverApp.API.setDataField("CustomFrequencyDay", String(selectedItem.RecurDay)); 
        CloverApp.API.setDataField("CustomFrequencyWeek", parseInt(selectedItem.RecurDay) > 6 ? ''1'' : String(selectedItem.RecurDay)); 
        CloverApp.API.setDataField("CustomFrequencyMonth", String(selectedItem.RecurMonth)); 
        
        if(selectedItem.CustomFrequencyType === "EXACT DATE"){
            CloverApp.API.setDataField("CustomFrequencyMonth", String(selectedItem.RecurMonth)); 
        }
        CloverApp.API.setDataField("CustomFrequencyDate", dateValue); 
        CloverApp.API.setDataField("SelectedCustomFrequencyId", selectedItem.Id); 
        return {};
    },
    
    resetCustomFrequencyModal: function(args){
        CloverApp.API.setDataField("CustomFrequencyType", ""); 
        CloverApp.API.setDataField("CustomFrequencyDay", ""); 
        CloverApp.API.setDataField("CustomFrequencyWeek", ""); 
        CloverApp.API.setDataField("CustomFrequencyMonth", ""); 
        CloverApp.API.setDataField("CustomFrequencyDate", ""); 
        CloverApp.API.setDataField("SelectedCustomFrequencyId", ""); 
        
        const hideControls = args.state.app.form.models.hideControls ? args.state.app.form.models.hideControls : [];
        hideControls.push("CustomFrequencyDay");
        hideControls.push("CustomFrequencyWeek");
        hideControls.push("CustomFrequencyMonth");
        hideControls.push("CustomFrequencyDate");
        hideControls.push("customFrequencyDateSpacing");
        delta = {
            app: {
                form: {
                    models: {
                        hideControls,
                    }
                }
            }    
        };
        return delta;
    },
        
}




' WHERE [Id]='548924d4-bec7-4469-952a-739f7dcf4e77';

UPDATE [dwMetadata] SET
[Id]='a6712791-65c1-463b-bd07-3a2bdac69c68', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplysampleowner-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:19.640', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 15:46:23.197', 
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
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
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
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
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
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.error("Failed to save assignments", reason);
                alertify.error( Utils.encodeHtml(reason) );
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

UPDATE [dwMetadata] SET
[Id]='43f69974-3cd4-4b15-9a41-0aa1e252163c', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyScheduledExport-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-07-11 19:10:40.683', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 15:52:12.343', 
[Data]=N'{
    init: function(args) {
        //console.log("args to init", args);
        const data = args.data;
        if(!data.Id) {
            alertify.error("No deployment. Returning to deployment form");
            window.setTimeout(()=>{ window.location = "/form/QNN_DPLY"; }, 500);
        } else {
            //Populate the recipients dropdown options
            const selectedRecipients = data.__selectedRecipients.map(r => r.SecurityUserId);
            Utils.loadingStart();
            Utils.getRequest("/deployment/dataowners/" + encodeURIComponent(data.Id)).then(
                response => {
                    const options = response.item.map( (owner) => ({ key: owner.Id, text: owner.Name, value: owner.Id }) );
                    const currentlyValidSelectedRecipients = options.filter(o => selectedRecipients.indexOf(o.value) !=-1).map(o => o.value);
                    //console.log("options", options, "selectedRecipients",selectedRecipients, "currentlyValidSelectedRecipients", currentlyValidSelectedRecipients);
                    Utils.rewriteDropdown("Recipients",options, currentlyValidSelectedRecipients);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop); 
        }
    },
    
    updateScheduledExport: function(args) {
        //console.log("args to updateScheduledExport", args);
        const data = args.data;
        
        const dplyId = data.Id;
        const scheduledExportEnabled = (data.ScheduledExportEnabled==1);
        const scheduledExportFrequency = data.ScheduledExportFrequency;
        const scheduledExportStartDate = data.ScheduledExportStartDate ? new Date(data.ScheduledExportStartDate) : null;
        const scheduledExportEndDate = data.ScheduledExportEndDate ? new Date(data.ScheduledExportEndDate) : null;
        const recipients = data.Recipients ? data.Recipients : [];
        
        //console.log("dplyId", dplyId, "scheduledExportEnabled", scheduledExportEnabled, "scheduledExportFrequency", scheduledExportFrequency,"scheduledExportStartDate", scheduledExportStartDate, "scheduledExportEndDate", scheduledExportEndDate, "recipients", recipients );

        const formData = new FormData();
        formData.append("dplyId", dplyId);
        formData.append("scheduledExportEnabled", scheduledExportEnabled);
        formData.append("scheduledExportFrequency", scheduledExportFrequency);
        formData.append("scheduledExportStartDate", scheduledExportStartDate ? scheduledExportStartDate.toISOString() : "");
        formData.append("scheduledExportEndDate", scheduledExportEndDate ? scheduledExportEndDate.toISOString() : "");
        recipients.forEach(r => formData.append("recipients", r));
        
        Utils.loadingStart("Updating deployment");
        Utils.postFormRequest("/deployment/updatescheduledexport", formData).then(
            response => {
                alertify.success("Export settings updated");
                window.setTimeout(()=>{window.location = window.location;}, 500);
            }, reason => {
                console.error(reason);
                Utils.loadingStop();
                alertify.error( Utils.encodeHTML(reason) );
                return {};
            }
        ) //(no loadingStop in finally - this is to keep the animation going while we navigate on success);
        return {};
    },
}' WHERE [Id]='43f69974-3cd4-4b15-9a41-0aa1e252163c';

UPDATE [dwMetadata] SET
[Id]='ec448626-827e-4932-bd3a-bba8de7146dd', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'dplyValidation-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-09-12 13:54:21.950', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 16:21:25.673', 
[Data]=N'{
    init: function(args) {
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("UploadDataset", model => {
            model.customPostUrl = "/deployment/dataset/" + dplyId;
            model.onUploadBegin = () => Utils.loadingStart("Uploading data to server");
            model.onUploadEnd = (cmp, ok, data) => { 
                Utils.loadingStop();
                if(ok) {
                    if(data.item) {
                        const importReport = data.item;
                        CloverApp.API.setDataField("ImportReportImportCount", importReport.importCount);
                        CloverApp.API.setDataField("ImportReportInvalidCount", importReport.invalidCount);
                        CloverApp.API.setDataField("ImportReportIgnoredCount", importReport.ignoredCount);
                        CloverApp.API.setDataField("ImportReportDuplicateCount", importReport.duplicateCount);
                    }
                } else {
                    CloverApp.API.setDataField("UploadDataset",null);
                    alertify.error("File upload failed");
                }
            };
        });
    },
    
    onClickUpload: function(args) {
        const file = $("input[name=''UploadDataset'']");
        file.trigger(''click'');
    },
    
    onImport: function(args) {
        const gridview = args.component.refs.gv_Datasets;
        const result = args.sourceControlValue;
        
        //Need to clear the file field so it can be used again
        CloverApp.API.setDataField("UploadDataset",null);
        
        if("FAIL"==result) {
            alertify.error("Data import failed.");
        } else if("NO UID COLUMN"==result) {
            alertify.error("Invalid file. A UID column is required to identify samples.");
        } else if("INCORRECT FILE TYPE"==result) {
            alertify.error("Incorrect file type. Please upload a CSV file.");
        } else if("OK"==result) {
            gridview.refresh();
            args.component.refs.ImportReportModal.openModal();
        } else {
            console.error("CSV import error", result);
            alertify.error("An error occured.");
        }
        
    },
    
    cancelModal: function(args) {
        args.controlRef.close();
    },
    
    clearDatasets: function(args) {
        args.controlRef.close();
        const gridview = args.component.refs.gv_Datasets;
        Utils.loadingStart("Removing uploaded datasets");
        Utils.deleteRequest("/deployment/dataset/"+encodeURIComponent(args.data.Id)).then(
            () => {
                alertify.success("Datasets removed");
                gridview.refresh();
            },
            reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
    },

}








' WHERE [Id]='ec448626-827e-4932-bd3a-bba8de7146dd';

UPDATE [dwMetadata] SET
[Id]='d2b77f0a-b241-4941-8472-cd5071b95f0b', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'header-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-11-29 15:29:54.600', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 16:24:05.107', 
[Data]=N'{
    init: function(args){
        headerUserActions.SetupAlternativeAcc(args);
    },
    
    SetupAlternativeAcc: function(args){
        Utils.loadingStart();
        Utils.getRequest("/account/getalternativeacc/").then(
            response => {
                if(response.success && response.item && response.item.length > 0){
                    let options = [];
                    let logoutItem = {target: ''/account/logoff'', title: ''Logout''};
                    for(let i in response.item){
                        let item = {target: ''/account/switchacc/'' + response.item[i].id, title: response.item[i].name};
                        options.push(item);
                    }
                    options.push(logoutItem);
                    args.controlRef.refs.currentUser.props.items = options;
                    CloverApp.API.changeModelControlByModel(args.component.state.model,''currentUser'',''items'',options);
                    args.component.refs["currentUser"].forceUpdate();
                }
            }, reason => {
                console.log(''SetupAlternativeAcc'', reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    onMenuItemClick: function(args){
        console.log(''onMenuItemClick'',args);
        if(args.parameters.target === ''/account/logoff''){
            CloverApp.API.redirect(''account'',''logoff'',undefined);
        }else{
            Utils.loadingStart(''Switching Account...'');
            Utils.postFormRequest(args.parameters.target).then(
                response => {
                    if(response.success){
                        document.location.href = window.location.origin;
                    }else{
                        alertify.error( Utils.encodeHTML(response.message) );
                    }
                }, reason => {
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally( Utils.loadingStop );
        }
    }
}' WHERE [Id]='d2b77f0a-b241-4941-8472-cd5071b95f0b';

UPDATE [dwMetadata] SET
[Id]='9ec429b4-65c7-4b46-b828-6d17ac19ad1e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'MaintenanceTests-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2023-12-11 14:01:24.710', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 16:28:39.487', 
[Data]=N'{
    performSmtpTest: function(args) {
        const behaviour = args.parameters.behaviour;
        const msgDuration = 30000; //Longer alert time on screen makes it easier to screenshot
        const url = "/maintenance/tests/smtp/" + encodeURIComponent(behaviour);
        const waitMessage = "Performing " + behaviour + " SMTP Test...";
        console.log(waitMessage);
        Utils.loadingStart(waitMessage);
        Utils.postFormRequest(url).then(
            response => {
                console.log( response.message );
                alertify.success(Utils.encodeHTML(response.message), msgDuration);
            }, reason => {
                console.error(reason);
                alertify.error(Utils.encodeHTML(reason), msgDuration);
            }
        ).finally(Utils.loadingStop);
    },
}' WHERE [Id]='9ec429b4-65c7-4b46-b828-6d17ac19ad1e';

UPDATE [dwMetadata] SET
[Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.290', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 16:39:34.147', 
[Data]=N'{
    init: function(args) {
        if(!args.data.Id){
            CloverApp.API.setDataField("State", "Active");   
            CloverApp.API.setDataField("StateName", "Active");     
            CloverApp.API.setDataField("RecurrenceFrequency", "");      
            CloverApp.API.setDataField("IsIncludeUnansweredSection",args.data.printAllPage);
        }
        
        if(args.data.IsIncludeUnansweredSection == null ){
            CloverApp.API.setDataField("IsIncludeUnansweredSection",args.data.printAllPage);
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
            catch(error) {
                //ignore
            }
        }          

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
    
        if(args.data.IsAnonymous){
            qnn_dplyUserActions.getAnonymousSurveyLink(args);
        }

        //Tags init
        if(args.data.Tags !== null) {
            //parse json return data after a save
            if(!Array.isArray(args.data.Tags)) {
                args.data.Tags = JSON.parse(args.data.Tags);
                CloverApp.API.setDataField("Tags", args.data.Tags);
            } 
            qnn_dplyUserActions.rewriteActiveTags(args);
        } else {
            CloverApp.API.setDataField("Tags", new Array());
        }
        
        
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
                    
                    } // end if response.success        
                }) // end then => response
   
            .catch(function(ex) {
                console.error("Failed to fetch snapshot settings", ex);
                alertify.error("Failed to fetch snapshot settings");
            });
        }; //end return  
    }, //end of init

    //Called from init
    checkQnnFields: function(qnnId){    
        const formData = new FormData();
        formData.append(''qnnId'', qnnId);
        loadingStart("Verifying survey field alias");
        postFormRequest("/qnn/checkfields",formData).then(
            response => {
               //No action 
            }, reason => {
                console.error("check fields failed", reason);
                alertify.alert( Utils.encodeHTML(reason) );
            }
        ).finally(loadingStop);
    }, //end of checkQnnFields
    
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
        if(!Utils.isSelected(args.data.IsAnonymous)){
            CloverApp.API.setDataField("textCompleteURL", null);              
        }         
    },
    
    toggleAnonymousSurvey: function(args){
        if(!Utils.isSelected(args.data.IsAnonymous)){
            CloverApp.API.setDataField("textCompleteURL", null);
        }else{
            CloverApp.API.setDataField("IsMultipleResponse", 0);
        }
    },
    
    downloadInvalidColumns(args) {
        //CloverApp.API.setDataField("invalidQnnColumns",[''A11'', ''B22'', ''C33'']);
        
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
    }, // end of downloadInvalidColumns
    
    downloadInvalidDates(args) {
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
    }, //end of downloadInvalidDates
    
    downloadInvalidUIDs(args) {
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
    }, //end of downloadInvalidUIDS
    
    viewArgs(args){
      console.log("View Args", args);  
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
        } else {
            //if not restricting IP
            CloverApp.API.setDataField("RestrictIp", "0");
            qnn_dplyUserActions.addUniqueElement(hideControls, ''RestrictIpInclusive'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''countryOrIpRange'');    
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpRange'');  
            qnn_dplyUserActions.addUniqueElement(hideControls, ''IpCountry'');                
        }        

        return {hideControls: hideControls, showControls: showControls};
    },
    
    //TODO - refactoe
    removeElement: function(array, element) {
        var _index = array.indexOf(element);
        if (_index == -1) return;
        array.splice(_index, 1);
    },
    
    //TODO - refactor
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
    }, //end of setIpRestriction
    
    onClickSave: function (args){
        const data = args.data.chkScheduler;
        const dplyId = args.data.Id;
        
        const emailSuccess = args.data.chkEmailSuccess;
        const emailFail = args.data.chkEmailFail;
        const userId = args.data.ddlEmailReceipients;
   
        const formData = new FormData();
        formData.append(''CheckBox'', data);
        formData.append(''dplyId'',dplyId);
        formData.append(''emailSuccess'',emailSuccess);
        formData.append(''emailFail'',emailFail);
        formData.append(''userId'',userId);       
        
        Utils.loadingStart();
        //update (job data) (word ''get'' in url is legacy)
        Utils.postFormRequest("/report/getJobData",formData).then(
            response => {
                console.log(data);
            }, reason => {
                console.error("post to getJobData failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    }, //end of onClickSave
    
    parseHtml: function(args) {
        return {
              app: {
                  form: {
                      data: {
                          modified: {
                             msgContent: args.component.refs.htmlEditor.state.htmlData,
                             msgContentJson: args.component.refs.htmlEditor.state.jsonData
                            }
                        }
                    }
                }
        };  
    },
    
    dropdownQuestionnaireOnChange: function(args) {
        var qnnId = args.sourceControlValue;
        var options = args.sourceControlRef.state.options;
        console.log("Args is", args);
        if(args.data.SurveyName=="" || args.data.SurveyName ==null){
            if(options !== undefined && options.length > 0){
                for(var i = 0; i < options.length; i++){
                    if(options[i].key == qnnId){
                        CloverApp.API.setDataField("SurveyName", options[i]["text"]);
                        break;
                    }
                }
            }
        }   
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
    }, //end of clearContent

    navigateParentDeployment: function(args) {
        if(args.data.RecurrenceOfDplyId) {
            //CloverApp.API.redirectToForm("QNN_DPLY",args.data.RecurrenceOfDplyId);
            location.href = "/form/QNN_DPLY/" + encodeURIComponent(args.data.RecurrenceOfDplyId);
        } else {
            alertify.error("This deployment does not have a parent");
        } 
    },
    
    updateFeatureInteraction: function(args) {
        const isExcelEnabled = Utils.isSelected(args.data.IsExcelEnabled);
        const isDelegationEnabled = Utils.isSelected(args.data.RequireAccessCode);
        const isAnonymous = Utils.isSelected(args.data.IsAnonymous);
        const isMultipleResponse = Utils.isSelected(args.data.IsMultipleResponse);
        const isDirectAccessEnabled = Utils.isSelected(args.data.IsDirectAccessEnabled);
        
        if(isAnonymous) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for anonymous surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
            
            if(isDelegationEnabled) {
                alertify.error("Delegation Access Code is not supported for anonymous surveys");
                CloverApp.API.setDataField("RequireAccessCode", 0);
            }
            
            if(isDirectAccessEnabled) {
                alertify.error("Direct Access feature is not applicable for anonymous surveys (use anonymous survey links)");
                CloverApp.API.setDataField("IsDirectAccessEnabled",0);
                Utils.queueHideControl("IsDirectAccessForComplete","hide");
            }
        }
        
        if(isMultipleResponse) {
            if(isExcelEnabled) {
                alertify.error("Online Excel forms are not supported for multiple response surveys");
                CloverApp.API.setDataField("IsExcelEnabled",0);
            }
            
            if(isDirectAccessEnabled) {  
                alertify.error("Direct Access is not supported for multiple response surveys");
                CloverApp.API.setDataField("IsDirectAccessEnabled",0);
                Utils.queueHideControl("IsDirectAccessForComplete","hide");
            }
        }
        
    },
    
    validateSampleList: function (args){
        const listId =  args.data.dictList;
        
        if(listId !== ''00000000-0000-0000-0000-000000000000''){
            Utils.loadingStart("Verifying list has samples...");
            Utils.getRequest("/deployment/CheckListHasSample/" + encodeURIComponent(listId)).then(
                response => {
                    if(!response.result) {
                        CloverApp.API.setDataField("dictList", "");
                        const selectedList = args.component.refs.dictList.state.options[args.component.refs.dictList.state.options.map(e=> e.value).indexOf(listId)].text;
                        alertify.error( Utils.encodeHTML("Sample List " + selectedList + " is empty."), 10000);
                    }else if(Utils.isSelected(args.data.IsAnonymous) && !response.isAnonymousSampleOnly){
                        CloverApp.API.setDataField("dictList", "");
                        alertify.error("Anonymous Survey requires list with only the anonymous sample.")
                    }
                }, reason => {
                    console.log(''validateSampleList'', reason);
                }
            ).finally(Utils.loadingStop);
        }
    },
    
    getAnonymousSurveyLink: function (args){
        const dplyId =  args.data.Id;
        const qnnId =  args.data.dictQuestionnaire;
        const iconClass = "copy outline icon";
        const iconBtnClass = "ui icon button mini secondary";
        const surveyLinkKey = ''anonymous-survey-'';
        let htmlLink = "";
        Utils.loadingStart();
        Utils.getRequest("/deployment/GenerateAnonymousSurveyURL/" + encodeURIComponent(dplyId) +"/"+ encodeURIComponent(qnnId))
        .then(response => {
                if(response.success && response.result) {
                    htmlLink += ''<div><i style="display:block;margin-bottom:14px;">Click the copy button to get Anonymous Survey URL:</i>'';
                    response.result.forEach(function(item, index){
                        //Does not show as hyperlink due to access anonymous survey will attempt to logout.
                        //let urlLink = ''<li><a href="'' + item.link +''" target="_blank">'' + item.link + ''&nbsp<i>(''+ item.lang +'')</i></a></li>'';
                        let iconBtn = ''<button id="btn-''+surveyLinkKey+index+''" name="btnCopy-anonymous-survey-link" title="Copy" data-link-id="''+surveyLinkKey+index+''" class="''+iconBtnClass+''"><i data-link-id="''+surveyLinkKey+index+''" class="''+iconClass+''" ariahidden="true"></i></button>'';
                        //this urlText is required for the copy action.
                        let urlText = ''<span id="link-''+surveyLinkKey+index+''" style="display:none;">''+item.url +''</span>'';
                        let headerDiv = ''<div style="margin:18px 18px 0px 18px; word-break: break-word;">''+iconBtn +'' '' +item.language + '' '' +urlText+''</div>'';
                        let qrCodeImg = ''<img style="display:block; margin-left:auto; margin-right:auto; margin-bottom:9px; width:200px; height:200px" src="data:image/png;base64,'' + item.qrCode +''"  alt="''+item.url+''"/>'';
                        let listItem = ''<div style="width:210px;margin-bottom:14px;margin-right:14px;float:left;border:1px solid rgba(34, 36, 38, 0.15);">''+ headerDiv + qrCodeImg + ''</div>'';
                        htmlLink += listItem;
                    });
                    
                    htmlLink += "</div>"
                    
                    CloverApp.API.setDataField("anonymousSurveyLink", htmlLink);
                    
                    //Due to security issue does not allow "unsafe inline", bind separately
                    document.getElementsByName("btnCopy-anonymous-survey-link").forEach(function(btn){
                       btn.addEventListener("click",function(e){
                           e.preventDefault();
                           const copyText = document.getElementById("link-" + e.target.getAttribute(''data-link-id'')).innerText
                           navigator.clipboard.writeText(copyText);
                           alertify.success(''Copied to clipboard!'');
                       })
                    });
                }else{
                    CloverApp.API.setDataField("anonymousSurveyLink", "");
                }
            }, reason => {
                console.log(''getAnonymousSurveyLink'', reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    openTagsModal: function(args){
        try{
            let tagsData = args.data.Tags;
            let NumberOfUniqueTagsShows = 10;
            if(Array.isArray(tagsData)){
                NumberOfUniqueTagsShows = NumberOfUniqueTagsShows + tagsData.length;
            }
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        args.data.TagsSearched = result;
                        CloverApp.API.setDataField("TagsSearched", result);
                        let tagsSearched = result;
                        if(Array.isArray(tagsData)){
                            tagsSearched = tagsSearched.filter(x => !tagsData.includes(x));
                        }
                        qnn_dplyUserActions.rewriteSearchedTags(tagsSearched);
                        qnn_dplyUserActions.rewriteDdTags(args);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        qnn_dplyUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error("failed to get active tags", reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsSearch);
            let tagsData = args.data.Tags;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        if(Array.isArray(tagsData)){
                            result = result.filter(x => !tagsData.includes(x));
                        }
                        qnn_dplyUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        qnn_dplyUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error( Utils.encodeHTML(reason) );
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(data){
        const divTagsSearchResult = function (model) {
            model.children.splice(2);
            if(data.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<data.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(data[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    closeTagsModal: function (args){
        args.component.refs.mdlTag.close();
        
        var originalTags = args.data.Tags;
        if(args.data.addedTags != null && originalTags != null){
            originalTags = args.data.Tags.filter(x => !args.data.addedTags.includes(x));
        }
        args.data.Tags = originalTags;
        args.data.addedTags = null;
        CloverApp.API.setDataField("ddTags", null);
        CloverApp.API.setDataField("Tags", originalTags);
    },
    
    saveActiveTags: function(args){
        args.data.addedTags = null;
        //remove duplicate tags
        let newTags = args.data.ddTags;
        newTags = newTags.filter((newTags) => newTags != '' '');
        newTags = newTags.map(newTags => {return newTags.trim()});
        
        var unique = [...new Set(newTags)];
        args.data.ddTags = unique;
        args.data.Tags = unique;
        CloverApp.API.setDataField("ddTags", unique);
        CloverApp.API.setDataField("Tags", unique);
        
        qnn_dplyUserActions.rewriteActiveTags(args);
        args.component.refs.mdlTag.close();
    },
    
    rewriteActiveTags: function(args){
        let divActiveTags = function (model) {
            model.children.splice(2);
            for (x=0;x<args.data.Tags.length;x++){
                var tag = window.globalUserActions.createTagsButton(args.data.Tags[x]);
                model.children[x+2] = tag;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divActiveTags", divActiveTags);
        CloverApp.API.setDataField("divActiveTags", null);
    },
    
    rewriteDdTags: function(args){
        let ddTags = args.data.Tags;
        const ddTagsRewrite = function (model) {
            model[''data-elements''] = new Array();
            return model;
        };
        CloverApp.API.rewriteControlModel("ddTags", ddTagsRewrite);
        CloverApp.API.setDataField("ddTags", ddTags);
    },
    
    addTagToDropdown: function (args){
        var tagsName = args.sourceControlRef.props.additionalParams.model.content;
        let ddTags = args.data.ddTags;
        
        //this is use to remove the added tags when cancel
        if(Array.isArray(args.data.addedTags)) {
            if(!args.data.addedTags.includes(tagsName)) {
                args.data.addedTags.push(tagsName);
            }
        } else {
            args.data.addedTags = new Array(tagsName);
        }
        
        if(ddTags!=null){
            if(!ddTags.includes(tagsName)) {
                ddTags.push(tagsName);
                CloverApp.API.setDataField("ddTags", ddTags);
            }
        } else {
            args.data.ddTags = new Array(tagsName);
        }
        args.component.refs.ddTags.forceUpdate();
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearchResult = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    addTagsSession: function(args){
        let tagsName = args.sourceControlRef.props.additionalParams.model.content;
        sessionStorage.setItem("tagsName", tagsName);
    },
}' WHERE [Id]='6518a592-09cd-4b6f-8235-deeebb8b81cf';

UPDATE [dwMetadata] SET
[Id]='d31cbc75-a3e9-46fc-9176-7ada5ecd7c09', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_DPLY_PRE_POPULATE-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-31 13:51:04.643', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 17:25:21.727', 
[Data]=N'{
    init: function(args){
        const dplyId = args.data.Id;
        CloverApp.API.rewriteControlModel("CsvFileUploaded", model => {
            model.customPostUrl = "/deployment/prepopulatecsv?" + new URLSearchParams( { dplyId } );
            model.onUploadBegin = () => Utils.loadingStart("Pre-populating...");
            model.onUploadEnd = Utils.loadingStop;
        });
    },
    
    getDeploymentFields: function(args){
        const dplyId = args.controlRef.props.value;
        if(!dplyId || dplyId.length==0){
            alertify.error("Please select at least one deployment");
            return;
        }
        
        
        const formData = new FormData();
        formData.append(''dplyId'', dplyId);   
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/getDeploymentFields", formData).then(
            response => {
                CloverApp.API.setDataField("DeploymentQnnFields", response.item);
            }, reason => {
                console.log("failed ot get deployment fields", reason);
                alterify.error(reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    addAllFields: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(allFields != null) {
            for(let x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = true;
            }
            CloverApp.API.setDataField("DeploymentQnnFields", allFields);
        }
    },
    
    removeAllFields: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(allFields != null) {
            for(let x = 0 ; x < allFields.length ; x++){
                allFields[x].PrePopulate = false;
            }
            CloverApp.API.setDataField("DeploymentQnnFields", allFields);
        }
    }, 
    
    prePopulate: function(args){
        const allFields = args.data.DeploymentQnnFields;
        if(!allFields || allFields.length==0){
            alertify.error("Please select source deployment");
            return;
        }
        
        const fieldIds = [];
        for(let x = 0 ; x < allFields.length ; x++){
            if(allFields[x].PrePopulate == true){
                fieldIds.push(allFields[x].Id);
            }
        }
        
        if(!fieldIds || fieldIds.length==0){
            alertify.error("Please select at least one field");
            return;
        }
              
        const formData = new FormData();
        formData.append(''dplyId'', args.data.Id);
        formData.append(''fieldIds'', fieldIds); 
        formData.append(''sourceDplyId'', args.data.Deployment);   
        Utils.loadingStart(); 
        Utils.postFormRequest("/deployment/prepopulate", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    csvFileUploaded: function(args) {
        const result = args.sourceControlValue;
        console.log(result);
        CloverApp.API.setDataField("CsvFileUploaded", null); 
        if("OK"===result) {
            alertify.success("Pre-populate has been scheduled. An email will be sent to you once it is completed.");
        } else {
            let errorMessage = result;
            if("FAIL" == result){
                errorMessage = "Pre-populate failed."
            } else if ("DUPLICATE HEADER DETECTED" == result){
                errorMessage = "Uploaded file contains duplicate header. Please remove duplicate and try again."
            } else if ("NO ALIAS COLUMN" == result){
                errorMessage = "Uploaded file does not have valid alias for this deployment. Did you select the correct CSV file?"
            }  else if ("NO UID COLUMN" == result){
                errorMessage = "Invalid file. A UID column is required to identify samples."
            } else if("INCORRECT FILE TYPE"==result) {
                errorMessage = "Incorrect file type. Please upload a CSV file.";
            }
            alertify.error( Utils.encodeHTML(errorMessage), 10000);
        }
        return {};
    },
    
    clickFileUpload: function(args){
        const file = $("input[name=''CsvFileUploaded'']");
        file.trigger(''click'');
        return {};
    },
 
}' WHERE [Id]='d31cbc75-a3e9-46fc-9176-7ada5ecd7c09';

UPDATE [dwMetadata] SET
[Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:21.910', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 17:35:06.490', 
[Data]=N'{   
    init: function(args){
        console.log("QNNLIST Args",args);
        
        //Tags init
        if(args.data.Tags !== null) {
            //parse json return data after a save
            if(!Array.isArray(args.data.Tags)) {
                args.data.Tags = JSON.parse(args.data.Tags);
                CloverApp.API.setDataField("Tags", args.data.Tags);
            } 
            qnn_listUserActions.rewriteActiveTags(args);
        } else {
            CloverApp.API.setDataField("Tags", new Array());
        }
    }, 
    
    processTrkList: function(args){
        var trkListIds = args.data.TrkListIds;
        if(trkListIds==null || trkListIds==undefined) return {};   
        try {
            var arr = JSON.parse(trkListIds);
            var sourceArray = args.component.refs.TrkListIds.state.options;
        
            let newArray = [];
            arr.map((currentValue, index, array) => {
                // return element to new Array
                if (sourceArray.filter(function(e) { return e.key === currentValue; }).length > 0) {
                      /* contains the element we''re looking for */
                      newArray.push(currentValue);
                }

            });
            CloverApp.API.setDataField("TrkListIds", JSON.stringify(newArray));
            
        } catch (e) {
            return {};
        }
        return {};   

    },
    
    deleteListSample: function(args){
        if(args.controlRef.state.selectedIndexes.length==0){
             alertify.error("Please select at least one list sample");
             return {};
        }

        const listId = args.data.Id;
        const listSampleIds = [];
        for (let i = 0; i < args.controlRef.state.selectedIndexes.length; i++) {
            const gridIndex = args.controlRef.state.selectedIndexes[i];
            const listSampleId = args.controlRef.state.items[gridIndex].Id;
            listSampleIds.push(listSampleId);
        }

        const formData = new FormData();
        formData.append(''listId'', listId);
        formData.append(''listSampleIds'', listSampleIds);      
        Utils.loadingStart();
        Utils.postFormRequest("/list/deletelistsample",formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                args.controlRef.refresh();
            }, reason => {
                console.error("Error deleting list samples", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },   
    
    toggleListSamplesActive: function(args) {
        const listSampleIds = args.controlRef.state.selectedIndexes.map( gridIndex => args.controlRef.state.items[gridIndex].Id);
        if(listSampleIds.length==0){
             alertify.error("Please select at least one list sample");
             return {};
        }

        const grid = args.component.refs.gridviewSample;
        const action = args.parameters.action;
        let waitMessage;
        let url;
        if("enable"===action) {
            url = "/list/enablelistsamples";
            waitMessage = "Enabling selected samples...";
        } else if("disable"===action) {
            url = "/list/disablelistsamples";
            waitMessage = "Disabling selected samples...";
        } else {
            throw "INTERNAL ERROR (UI): Invalid action";
        }
        const listId = args.data.Id;
        const formData = new FormData();
        formData.append("listId", listId);
        formData.append("listSampleIds", listSampleIds);    
        Utils.loadingStart(waitMessage);
        Utils.postFormRequest(url, formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                grid.refresh()
            }, reason => {
                console.error("toggleListSamplesActive failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        
        return {};
    },
    
    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },
    
    exportSample: function (args){
        let defaultFormName = args.originalData.nameInput + ".csv";
        let inputName = null;
        while(inputName == null){
          inputName = prompt(CloverLang.forms.QNN_LIST.provideNameToDownload, defaultFormName);
          if(inputName == null || inputName == undefined){
            return;
          }else if(inputName.trim().length == 0 ){
            inputName = null;
            alert(CloverLang.forms.QNN_LIST.provideName);
          }
        }
        var url = ''/list/exportsample?listId='' + args.data.Id + ''&fileName='' + encodeURIComponent(inputName);
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },
    
    submitFile(args)
    {
        var token = args.data.inputImportListSample;
        var password = args.data.inputPassword;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please", 15000);
            return {};
        };

        if(password){
            var errors = {};
            var req = new RegExp(/^[a-zA-Z0-9]{12,100}$/);
            var countChars = function(str, type) {
                var count=0,len=str.length;
                    for(var i=0;i<len;i++) {
                        if(type==0){
                            if(/[A-Z]/.test(str.charAt(i))) count++;                    
                        }
                        else if(type==1){
                            if(/[a-z]/.test(str.charAt(i))) count++;                    
                        }
                        else if(type==2){
                            if(/[0-9]/.test(str.charAt(i))) count++;                    
                        }                
                    }
                return count;
            };                
            if(!req.test(password)){
                errors.inputPassword = true;
                errors.passwordComplex = "Password must contain alphanumeric characters only; password must be between 12 and 100 characters)";            
            }
    
            if(countChars(password, 0)<3 || countChars(password, 1)<3 || countChars(password, 2)<3){
                errors.inputPassword = true;
                errors.passwordStrength = "Password must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";            
            }
            
    
            if(errors.passwordComplex){
              throw {
                  level: 1,
                  message: errors.passwordComplex,
                  formerrors: {main: errors}
              };
            }
            if(errors.passwordStrength){
              throw {
                  level: 1,
                  message: errors.passwordStrength,
                  formerrors: {main: errors}
              };
            }    
        }

        const url = "/list/" + encodeURIComponent(args.data.Id) + "/import";
        const formData = new FormData();
        formData.append("token", token);
        if(password) {
            formData.append("password", password);
        }
        Utils.loadingStart();
        Utils.postFormRequest(url, formData).then(
            response => {
                CloverApp.API.setDataField("inputImportListSample", null);
                CloverApp.API.setDataField("inputPassword", null);
                alertify.success( Utils.encodeHTML(response.message), 10000);
                args.component.refs.modalImportSample.close();
                args.component.refs.gridviewSample.refresh();
                qnn_listUserActions.closeModal(args); 
            }, reason => {
                console.error(reason);
                CloverApp.API.setDataField("inputImportListSample", null);
                alertify.error( Utils.encodeHTML(reason), 15000);
            }
        ).finally( Utils.loadingStop );
    }, 

    //called by btnSave
    goRecords: function(args){
        var modelArray = args.state.app.form.models.model; 
        var recordsCont= args.state.app.form.models.model[4];
        var isHidden = false;
        
        var newModal= {''key'': recordsCont[''key''], ''data-buildertype'': recordsCont[''data-buildertype''], ''children'': recordsCont[''children''],
        ''style-customcss'': recordsCont[''style-customcss''], ''style-float'':recordsCont[''style-float''], ''style-width'': recordsCont[''style-width''],
        ''style-hidden'': isHidden,};
    
        modelArray.splice(4,1,newModal); //Replace item in whole model series
    
        return {
            app:{
                form:{
                    models:{
                        model: modelArray
                    }
                }
            }
        }
    },
    
    newListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_LIST_SAMPLE'', ''/listId/''+ args.data.Id);
    },
    
    closeModal: function (args){
        CloverApp.API.setDataField("inputImportListSample", null);
        CloverApp.API.setDataField("inputPassword", null);
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          //sampleAddedCount:null,
                          //sampleUpdatedCount:null,
                          listFile:null,
                          listName:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: []
                  }
              }
            }
        }       
    },  

    openTagsModal: function(args){
        try{
            let tagsData = args.data.Tags;
            let NumberOfUniqueTagsShows = 10;
            if(Array.isArray(tagsData)){
                NumberOfUniqueTagsShows = NumberOfUniqueTagsShows + tagsData.length;
            }
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        args.data.TagsSearched = result;
                        CloverApp.API.setDataField("TagsSearched", result);
                        let tagsSearched = result;
                        if(Array.isArray(tagsData)){
                            tagsSearched = tagsSearched.filter(x => !tagsData.includes(x));
                        }
                        qnn_listUserActions.rewriteSearchedTags(tagsSearched);
                        qnn_listUserActions.rewriteDdTags(args);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        qnn_listUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsSearch);
            let tagsData = args.data.Tags;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        if(Array.isArray(tagsData)){
                            result = result.filter(x => !tagsData.includes(x));
                        }
                        qnn_listUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        qnn_dplyUserActions.rewriteSearchedTags("");
                    } else {
                        console.error(reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(data){
        const divTagsSearchResult = function (model) {
            model.children.splice(2);
            if(data.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<data.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(data[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    closeTagsModal: function (args){
        args.component.refs.mdlTag.close();
        
        var originalTags = args.data.Tags;
        if(args.data.addedTags != null){
            originalTags = args.data.Tags.filter(x => !args.data.addedTags.includes(x));
        }
        args.data.Tags = originalTags;
        args.data.addedTags = null;
        CloverApp.API.setDataField("ddTags", null);
        CloverApp.API.setDataField("Tags", originalTags);
    },
    
    saveActiveTags: function(args){
        args.data.addedTags = null;
        //remove duplicate tags
        let newTags = args.data.ddTags;
        newTags = newTags.filter((newTags) => newTags != '' '');
        newTags = newTags.map(newTags => {return newTags.trim()});
        
        var unique = [...new Set(newTags)];
        args.data.ddTags = unique;
        args.data.Tags = unique;
        CloverApp.API.setDataField("ddTags", unique);
        CloverApp.API.setDataField("Tags", unique);
        
        qnn_listUserActions.rewriteActiveTags(args);
        args.component.refs.mdlTag.close();
    },
    
    rewriteActiveTags: function(args){
        let divActiveTags = function (model) {
            model.children.splice(2);
            for (x=0;x<args.data.Tags.length;x++){
                var tag = window.globalUserActions.createTagsButton(args.data.Tags[x]);
                model.children[x+2] = tag;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divActiveTags", divActiveTags);
        CloverApp.API.setDataField("divActiveTags", null);
    },
    
    rewriteDdTags: function(args){
        let ddTags = args.data.Tags;
        const ddTagsRewrite = function (model) {
            model[''data-elements''] = new Array();
            return model;
        };
        CloverApp.API.rewriteControlModel("ddTags", ddTagsRewrite);
        CloverApp.API.setDataField("ddTags", ddTags);
    },
    
    addTagToDropdown: function (args){
        var tagsName = args.sourceControlRef.props.additionalParams.model.content;
        let ddTags = args.data.ddTags;
        
        //this is use to remove the added tags when cancel
        if(Array.isArray(args.data.addedTags)) {
            if(!args.data.addedTags.includes(tagsName)) {
                args.data.addedTags.push(tagsName);
            }
        } else {
            args.data.addedTags = new Array(tagsName);
        }
        
        if(ddTags!=null){
            if(!ddTags.includes(tagsName)) {
                ddTags.push(tagsName);
                CloverApp.API.setDataField("ddTags", ddTags);
            }
        } else {
            CloverApp.API.setDataField("ddTags", new Array(tagsName));
        }
        args.component.refs.ddTags.forceUpdate();
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearchResult = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    addTagsSession: function(args){
        let tagsName = args.sourceControlRef.props.additionalParams.model.content;
        sessionStorage.setItem("tagsName", tagsName);
    },
}' WHERE [Id]='c7d7bd7e-1766-4ab2-81f4-2a69a3b3d082';

UPDATE [dwMetadata] SET
[Id]='adf598e9-17a9-4b69-bfa2-cd7b938d2472', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_LIST_SAMPLE-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.433', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 17:44:03.267', 
[Data]=N'{
    init: function (args){
       
        var getParameterByName = function(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '''';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        };
        
        var getListId = function() {
            var url = window.location.href;
            var parts = url.split(''/'');
            return parts.pop() || parts.pop();  // handle potential trailing slash
        };   
        
        return () => {
            var listId = args.data.DictionaryListName
            var url = ''/list/genListprop/'' + listId+ ''/'' + args.data.Id;
            if(args.data.Id==undefined || args.data.Id==null){
                //listId = getParameterByName(''listId'');
                listId = getListId();
                url = ''/list/genListprop/'' + listId+ ''/''
            }
            if(listId==null || listId==undefined) return Promise.resolve();
            Utils.loadingStart();
            return Utils.getRequest(url).then(
                response => {
                if (!response.success) {
                    CloverApp.API.redirect(''form'', "SwzListList");
                }
                var item = JSON.parse(response.item);
                if(args.data.Id==undefined || args.data.Id==null) item.data[''DictionaryListName''] = listId;
                if(item.model.length==0) return Promise.resolve(
                    {
                        stateDelta: {
                            app: {
                                form: {
                                    data: {
                                        modified: {
                                            DictionaryListName: listId
                                        }
                                    }
                                },                                
                                
                                extra: {
                                    spData: item
                                }
                            },

                            
                        }
                    }
                ); 
                args.state.app.form.models.model[0].children[0].children[5].source =JSON.stringify(item.model);  

                var readOnlyArray = args.state.app.form.models.readOnlyControls;
                var rule = item.rule;
                for (var key in rule) {
                    if(rule[key]["readOnly"] =="true"){
                        readOnlyArray.push(key);
                    } 
                }                  
                
                return Promise.resolve({
                    stateDelta: {
                        app: {
                            form: {
                                data: {
                                    modified: item.data
                                },
                                models:{
                                    readOnlyControls: readOnlyArray
                                }
                            },
                            extra: {
                                spData: item
                            }
                        },
                    }
                });             
                
            	}, reason => {
            		alertify.error( Utils.encodeHTML(reason) );
            	}
            ).finally( Utils.loadingStop );
        };
    },
    
    saveProp: function(args){
        var hasError = false;
        var errors = {main: {}};    
        var messages = [];
        
        if(args.data.DictionaryListName == null || args.data.DictionaryListName == Utils.EMPTY_GUID){
            hasError = true;
            messages.push("List Title is required");
            errors.main["DictionaryListName"] = true;
        }
        
        if(args.data["dictionarySample"] == null || args.data["dictionarySample"] == Utils.EMPTY_GUID) {
            hasError = true;
            messages.push("Sample is required");
            errors.main["dictionarySample"] = true;
        }
            
        if(!hasError){
            var data = args.state.app.extra.spData.data;
            var model = args.state.app.extra.spData.model;
            var rule = args.state.app.extra.spData.rule;
            
            //List Sample Properties validation
            if(model.length>0){
                for (var key in data) {
                    if((args.data[key]==null || args.data[key]=="") && rule[key]!=null && rule[key]["reqd"].toLowerCase()=="true"){
                        hasError = true;
                        messages.push("<br />" + key + " is required");
                        errors.main[key] = true;
                    }
                    
                    if(rule[key]!=null && rule[key]["txtRegExp"]!=null && rule[key]["txtRegExp"]!=""){
                        
                        let funcArgs = ''value, data'';
                        let body = ''return '' + rule[key]["txtRegExp"];
                        let isValid = new Function(funcArgs, body)(args.data[key], args.data);
                        if (typeof isValid === ''boolean''){
                            if (isValid === false) {
                                hasError = true;
                                messages.push("<br />" + key + " " + rule[key]["txtRegExpErr"]);
                                errors.main[key] = true;
                            }
                        }
                        else{
                            error = isValid;
                        }
                    }
                }
            }
        }

        if(hasError){
            throw {
                level: 1,
                message: messages,
                formerrors: errors
            };
        }
        

        return ()=> {
            var listSampleId = args.data.Id;
            var listId = args.data.DictionaryListName;
            var formData = new FormData();
            formData.append(''listSampleId'', listSampleId);
            formData.append(''listId'', listId);        
            formData.append(''listSampleProp'', JSON.stringify(args.data));
            var url = ''/list/savelistprop'';
            Utils.loadingStart();
            return Utils.postFormRequest(url, formData).then(
            	response => {
        	        alertify.success("List sample changed");
            	}, reason => {
            		alertify.error( Utils.encodeHTML(reason) );
            	}
            ).finally( Utils.loadingStop );
        };
    },
   
    goBack: function(args) {
        if(args.data.DictionaryListName !== Utils.EMPTY_GUID){
            CloverApp.API.redirectToForm(''QNN_LIST'', args.data.DictionaryListName);
        }else{
            CloverApp.API.redirectToForm(''SwzListList'');
        }
    },
    
    //Do not delete. Is required by list property fields
    propertyOnChange: function(args){
        
    }

}' WHERE [Id]='adf598e9-17a9-4b69-bfa2-cd7b938d2472';

UPDATE [dwMetadata] SET
[Id]='927fc400-e371-4fbb-b866-cb020fff46db', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_QNN-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:22.580', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 17:54:43.720', 
[Data]=N'{
    init: function(args){
      //console.log(''View Args'', args);    
      //args.component.refs.collectioneditor_2.props.placeholders.Name["0"][""data-elements""]
        if(args.data.Id){
            CloverApp.API.setDataField("UpdatedDate", new Date());
            try{
                qnn_dplyUserActions.checkQnnFields(args.data.Id);                  
            }
            catch(err) {
                ;
        	}
        } else {
            CloverApp.API.setDataField("Type","O");
        }
        CloverApp.API.setDataField("ErrorText", "");
        
        //Tags init
        if(args.data.Tags !== null) {
            //parse json return data after a save
            if(!Array.isArray(args.data.Tags)) {
                args.data.Tags = JSON.parse(args.data.Tags);
                CloverApp.API.setDataField("Tags", args.data.Tags);
            } 
            qnn_qnnUserActions.rewriteActiveTags(args);
        } else {
            CloverApp.API.setDataField("Tags", new Array());
        }
    },  

    customSave: function(args) {
        args.data.UpdatedDate = new Date(); //trigger triggers
        const innerArgs = args;
        Utils.loadingStart("Saving...");
        Utils.changeData(args.data,"QNN_QNN").then(
            responseData => {
                alertify.success("The changes have been applied!");
                const reloadUrl = "/form/QNN_QNN/" + encodeURIComponent(responseData.item.entity.Id);
                window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
                //nb: leave loading animation on
            }, reason => {
                console.error(reason);
                CloverApp.API.setDataField("ErrorText", reason);
                innerArgs.component.refs.errorModal.openModal();
                Utils.loadingStop();
            }
        ); //(absent finally is intentional for continuing loading animation)
    }, //end of customSave
    
    viewArgs: function(args){
        console.log(''View Args'', args);    
    },
    
    GenFormFields:function(args){
        console.dir(args);
        var qnnId = args.data.Id;
        var token = args.data.collectioneditor_1[0].Token;
        var url = ''/qnn/genfields?qnnId='' + args.data.Id + ''&token='' + token;
        $.post(url).done(function (data) {
            if(data.success)
                alertify.success( Utils.encodeHTML(data.message) );
            else
                alertify.error( Utils.encodeHTML(data.message) );
        }).fail(function (jqxhr, textStatus, error) {
           alertify.error( Utils.encodeHTML(textStatus) );
        }); 
        return {};
    },
  
    validate: function (args){
        var errorMessages = [];
        var hasError = false;
        var errors = {main: {}};    
        
        if(args.data.Title==undefined || args.data.Title==null || args.data.Title.trim() == ''''){
            errorMessages.push(''Please enter questionnaire title'');
            errors.main.Title = true;
            hasError= true;
        } 
        if(args.data.Type==undefined || args.data.Type==null){
            errorMessages.push(''<br />Please select questionnaire type!'');
            errors.main.Type = true;
            hasError= true;
        }        
        else{
            if(args.data.collectioneditor_2 == undefined || args.data.collectioneditor_2.length == 0){
                errorMessages.push(''<br />Please insert an online form!'');
                errors.main.collectioneditor_2 = true;
                hasError = true;
            }            
        }
        
        if(hasError){
          throw {
              level: 1,
              message: errorMessages,
              formerrors: errors
          };
        }
        return {};
    },
    
    cancelModal: function(args) {
        args.controlRef.close();
        return {};
    },
    
    convertToOnlineForm: function(args) {
        //nb: it is assumed this is only called for an already saved entity
        CloverApp.API.setDataField("Type","O");
        alertify.success("Type changed to Online. Add an Online form and click Save to apply this change");
        const hideControls = [ "Warning_Type_P", "Type", "Excel_Files_After_Save_Message", "btnConvertToOnlineForm" ];
        return {
            app: {
                form: {
                    models: {
                        hideControls: hideControls,
                    },
                },
            },
        }; //end of state delta
    }, // end of convertToOnlineForm
    
    showLangWarning: function(args) {
        Utils.queueHideControl("Warning_nolanguage_file",''show'');
    },
    
    openTagsModal: function(args){
        try{
            let tagsData = args.data.Tags;
            let NumberOfUniqueTagsShows = 10;
            if(Array.isArray(tagsData)){
                NumberOfUniqueTagsShows = NumberOfUniqueTagsShows + tagsData.length;
            }
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        args.data.TagsSearched = result;
                        CloverApp.API.setDataField("TagsSearched", result);
                        let tagsSearched = result;
                        if(Array.isArray(tagsData)){
                            tagsSearched = tagsSearched.filter(x => !tagsData.includes(x));
                        }
                        qnn_qnnUserActions.rewriteSearchedTags(tagsSearched);
                        qnn_qnnUserActions.rewriteDdTags(args);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        qnn_qnnUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.error(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsSearch);
            let tagsData = args.data.Tags;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        if(Array.isArray(tagsData)){
                            result = result.filter(x => !tagsData.includes(x));
                        }
                        qnn_qnnUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        qnn_qnnUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.error(e);
        }
    },
    
    rewriteSearchedTags:function(data){
        const divTagsSearchResult = function (model) {
            model.children.splice(2);
            if(data.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<data.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(data[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    closeTagsModal: function (args){
        args.component.refs.mdlTag.close();
        
        var originalTags = args.data.Tags;
        if(args.data.addedTags != null){
            originalTags = args.data.Tags.filter(x => !args.data.addedTags.includes(x));
        }
        args.data.Tags = originalTags;
        args.data.addedTags = null;
        CloverApp.API.setDataField("ddTags", null);
        CloverApp.API.setDataField("Tags", originalTags);
    },
    
    saveActiveTags: function(args){
        args.data.addedTags = null;
        //remove duplicate tags
        let newTags = args.data.ddTags;
        newTags = newTags.filter((newTags) => newTags != '' '');
        newTags = newTags.map(newTags => {return newTags.trim()});
        
        var unique = [...new Set(newTags)];
        args.data.ddTags = unique;
        args.data.Tags = unique;
        CloverApp.API.setDataField("ddTags", unique);
        CloverApp.API.setDataField("Tags", unique);
        
        qnn_qnnUserActions.rewriteActiveTags(args);
        args.component.refs.mdlTag.close();
    },
    
    rewriteActiveTags: function(args){
        let divActiveTags = function (model) {
            model.children.splice(2);
            for (x=0;x<args.data.Tags.length;x++){
                var tag = window.globalUserActions.createTagsButton(args.data.Tags[x]);
                model.children[x+2] = tag;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divActiveTags", divActiveTags);
        CloverApp.API.setDataField("divActiveTags", null);
    },
    
    rewriteDdTags: function(args){
        let ddTags = args.data.Tags;
        const ddTagsRewrite = function (model) {
            model[''data-elements''] = new Array();
            return model;
        };
        CloverApp.API.rewriteControlModel("ddTags", ddTagsRewrite);
        CloverApp.API.setDataField("ddTags", ddTags);
    },
    
    addTagToDropdown: function (args){
        var tagsName = args.sourceControlRef.props.additionalParams.model.content;
        let ddTags = args.data.ddTags;
        
        //this is use to remove the added tags when cancel
        if(Array.isArray(args.data.addedTags)) {
            if(!args.data.addedTags.includes(tagsName)) {
                args.data.addedTags.push(tagsName);
            }
        } else {
            args.data.addedTags = new Array(tagsName);
        }
        
        if(ddTags!=null){
            if(!ddTags.includes(tagsName)) {
                ddTags.push(tagsName);
                CloverApp.API.setDataField("ddTags", ddTags);
            }
        } else {
            CloverApp.API.setDataField("ddTags", new Array(tagsName));
        }
        args.component.refs.ddTags.forceUpdate();
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearchResult = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearchResult", divTagsSearchResult);
        CloverApp.API.setDataField("divTagsSearchResult", null);
    },
    
    addTagsSession: function(args){
        let tagsName = args.sourceControlRef.props.additionalParams.model.content;
        sessionStorage.setItem("tagsName", tagsName);
    },
}







' WHERE [Id]='927fc400-e371-4fbb-b866-cb020fff46db';

UPDATE [dwMetadata] SET
[Id]='ef95ed35-6b68-4a52-8433-f85554dbd1fe', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'QNN_SAMPLE-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-02-11 20:33:31.493', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 18:13:42.753', 
[Data]=N'{
    customSave: function(args) {
        args.data.UpdatedDate = new Date(); //trigger triggers
        const innerArgs = args;
        Utils.loadingStart("Saving...");
        Utils.changeData(args.data,"QNN_SAMPLE").then(
            responseData => {
                alertify.success("The changes have been applied!");
                const reloadUrl = "/form/QNN_SAMPLE/" + encodeURIComponent(responseData.item.entity.Id);
                window.setTimeout( () => window.location=reloadUrl, 1000); //hard reload
                //nb: leave loading animation on
            }, reason => {
                CloverApp.API.setDataField("ErrorText", reason);
                innerArgs.component.refs.errorModal.openModal();
                Utils.loadingStop();
            }
        ); //(absent finally is intentional for continuing loading animation)
    }, //end of customSave
    
    resetPassword: function(args){
        if(!args.data.Id){
            alertify.error("The sample must exist");
            return;
        } 
        
        const formData = new FormData();
        formData.append(''sampleIds'', args.data.Id);
        Utils.loadingStart();
        Utils.postFormRequest("/deployment/resetresppassword", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message), 15000 );
            }, reason => {
                console.error("resetPassword failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    validate: function(args){
        var countChars = function(str, type) {
            var count=0,len=str.length;
                for(var i=0;i<len;i++) {
                    if(type==0){
                        if(/[A-Z]/.test(str.charAt(i))) count++;                    
                    }
                    else if(type==1){
                        if(/[a-z]/.test(str.charAt(i))) count++;                    
                    }
                    else if(type==2){
                        if(/[0-9]/.test(str.charAt(i))) count++;                    
                    }                
                }
            return count;
        }    
        CloverApp.API.formValidate(args);
        
        var errors = {};
        
        if(args.data.Pwd){
            if(countChars(args.data.Pwd, 0)<3 || countChars(args.data.Pwd, 1)<3 || countChars(args.data.Pwd, 2)<3){
                errors.Pwd = true;
                errors.passwordStrength = "must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";            
            }    
            if(errors.passwordStrength){
                throw {
                  level: 1,
                  message: errors.passwordStrength,
                  formerrors: {main: errors}
                };
            }             
        }
        
        if(args.originalData.ActiveYN === false && args.data.ActiveYN == 1){
            CloverApp.API.setDataField("NumRetry", " 0");
        }
       
    },
    
    validateAddressBook: function(value) {
        const errors = [];
        for(const sampleAddress of value) {
            
            const organisation = sampleAddress.StructDivisionName;
            
            if(sampleAddress.ToEmails 
                && sampleAddress.ToEmails.trim()!==""
                && !(sampleAddress.ToEmails.split('','').filter(m => !(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/).test(m.trim())).length==0)) {
                errors.push("Invalid ''To Emails'' for " + organisation);  
            }
            
            if(sampleAddress.CcEmails 
                && sampleAddress.CcEmails.trim()!==""
                && !(sampleAddress.CcEmails.split('','').filter(m => !(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/).test(m.trim())).length==0)) {
                errors.push("Invalid ''CC Emails'' for " + organisation);  
            }
        }
        return errors.length >0 ? errors.join(", ") : true;
    },
    
    cancelModal: function(args) {
        console.log("cancelModal", args, args.controlRef);
        args.controlRef.close();
        return {};
    },
    
}' WHERE [Id]='ef95ed35-6b68-4a52-8433-f85554dbd1fe';

UPDATE [dwMetadata] SET
[Id]='ea958da5-0374-40dd-a53a-a00315a50a3a', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'QNN_TRK_LIST-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-10-04 15:06:37.850', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 18:21:28.013', 
[Data]=N'{
    init: function(args){
        args.data.listSampleAddedCount = null;
        args.data.listSampleUpdatedCount = null;
    },
    
    onDownloadTemplate(args){
        const filename = "trklistsample_import_template.csv";
        var data = [["UID", "NAME", "EMAIL", "REMARKS", "STATUSCODE"],
        ["UID001", "Albert Einstein", "einstein@softworkz.net", "Cease operation", "PE"]];
        let csvContent = data.map(e => e.join(",")).join("\n");      
        blob = new Blob([csvContent], {type: "octet/stream"}),
        encodedUri = window.URL.createObjectURL(blob);
        if (typeof window.navigator.msSaveBlob !== ''undefined'') {
            window.navigator.msSaveBlob(blob, filename);
        } else {
            var link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", filename);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    },
    
    newTrkListSample: function(args){
        CloverApp.API.redirect(''form'', ''QNN_TRK_LIST_SAMPLE'', ''/trklistid/''+ args.data.Id)
    },
    
    exportSample: function (args){
        if(args.controlRef.state.rowsCount==0){
            alertify.error("Nothing to export");
            return;
        }
        var url = ''/trklist/exportsample?trkListId='' + args.data.Id;
        var downloadLink = document.createElement("a");
        downloadLink.href = url;
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);  
    },

    selectFile: function (args) {
        var file = $("input[name=''inputImportListSamples'']")
        file.trigger(''click'');
    },

    hideMessages: function (args){
        CloverApp.API.setDataField("listSampleAddedCount", null);
        CloverApp.API.setDataField("listSampleUpdatedCount", null);  
        CloverApp.API.setDataField("gridviewImportSummary", null);         
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null 
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'',''gridviewImportSummary'']
                  }
              }
            }
        }        
        
    },
    
    submitFile(args)
    {
        const token = args.data.inputImportListSample;
        if (token == null || token == undefined){
            alertify.error("Select a csv file please");
            return {};
        };

        const formData = new FormData();
        formData.append("trkListId",args.data.Id);
        formData.append("token", token);

        Utils.loadingStart();
        Utils.postFormRequest("/trklist/importsamples", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                console.log("response", response);
                CloverApp.API.setDataField("inputImportListSample", null);
                args.component.refs.gridviewSample.refresh();
                CloverApp.API.setDataField("listSampleAddedCount", response.statistics.trkListSampleAdded);
                CloverApp.API.setDataField("listSampleUpdatedCount", response.statistics.trkListSampleUpdated); 
                Utils.queueHideControl("headerListSampleAdded", false);
                Utils.queueHideControl("headerListSampleUpdated", false);
                if(response.items!=null && response.items!=undefined){
                    CloverApp.API.setDataField("gridviewImportSummary", JSON.parse(response.items));  
                    Utils.queueHideControl("gridViewImportSummary", false);
                }
                else{
                    Utils.queueHideControl("gridViewImportSummary", true);                     
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), 15000);
            }
        ).finally(Utils.loadingStop());
    }, 
  
    closeModal: function (args){
        args.component.refs.modalImportSample.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''headerListSampleAdded'',''headerListSampleUpdated'', ''gridviewImportSummary'']
                  }
              }
            }
        }       
    }
    
}' WHERE [Id]='ea958da5-0374-40dd-a53a-a00315a50a3a';

UPDATE [dwMetadata] SET
[Id]='dd9ae999-1e15-4f09-8114-10e64df4003e', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespAccountChangePassword-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-05-08 20:14:18.343', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 18:27:03.530', 
[Data]=N'{
    
    changePassword: function (args){
     
     var data = args.data;
     
      if(data.oldPassword === "" || data.newPassword === "" || data.confirmPassword === ""){
        CloverApp.API.setDataField("oldPassword", "");
        CloverApp.API.setDataField("newPassword", "");
        CloverApp.API.setDataField("confirmPassword", "");
        return;
      }
        var oldPassword = args.data.oldPassword;
        var newPassword = args.data.newPassword;
      
        var formData = new FormData();
        formData.append(''oldPassword'', oldPassword);
        formData.append(''newPassword'', newPassword);        
        var url = ''/RespChangePassword/RespChangePassword'';
    
        fetch(url, {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            } )
        .then(response => response.json())
        .then(response => {
            if (response.success) {
                alertify.success( Utils.encodeHTML(response.message) );
                CloverApp.API.redirectToForm("respdashboard");
            } 
            else {
                CloverApp.API.setDataField("oldPassword", "");
                CloverApp.API.setDataField("newPassword", "");
                CloverApp.API.setDataField("confirmPassword", "");
                alertify.error( Utils.encodeHTML(response.message) );
            }
        })
        .catch(error => {
            CloverApp.API.setDataField("oldPassword", "");
            CloverApp.API.setDataField("newPassword", "");
            CloverApp.API.setDataField("confirmPassword", "");
            alertify.error( Utils.encodeHTML(error.message) );
        });
    },
    
    init: function(args){
        CloverApp.API.setDataField("oldPassword", "");
        CloverApp.API.setDataField("newPassword", "");
        CloverApp.API.setDataField("confirmPassword", "");
    },
    
    validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
    
        var countChars = function(str, type) {
            var count=0,len=str.length;
                for(var i=0;i<len;i++) {
                    if(type==0){
                        if(/[A-Z]/.test(str.charAt(i))) count++;                    
                    }
                    else if(type==1){
                        if(/[a-z]/.test(str.charAt(i))) count++;                    
                    }
                    else if(type==2){
                        if(/[0-9]/.test(str.charAt(i))) count++;                    
                    }                
                }
            return count;
        };    
      
        var errors = {};
        
        if(data.oldPassword === "" || data.newPassword === "" || data.confirmPassword === ""){
            errors.newPassword = true;
            errors.passwordRequirement = "Password cannot be empty";
        }
          
        var req = new RegExp(/^[a-zA-Z0-9]{12,100}$/);
        //TODO: Insert your code for validation this form
        if(!req.test(data.newPassword)){
            errors.newPassword = true;
            errors.passwordComplex = "Password must contain alphanumeric characters only; password must be between 12 and 100 characters)";            
        }

        if(countChars(data.newPassword, 0)<3 || countChars(data.newPassword, 1)<3 || countChars(data.newPassword, 2)<3){
            errors.newPassword = true;
            errors.passwordStrength = "Password must contain at least 3 characters from each category (lowercase letter, uppercase letter, numeric digit)";            
        }
        
        if(data.newPassword != data.confirmPassword){
            errors.match = ''Confirm Password did not match the new password!'';
            errors.confirmPassword = true;
        }
        
        if(data.oldPassword == data.newPassword){
            errors.samePassword = ''New password must not match old password!'';
            errors.newPassword = true;            
        }

        if(errors.passwordRequirement){
          throw {
              level: 1,
              message: errors.passwordRequirement,
              formerrors: {main: errors}
          };
        }
 
         if(errors.passwordComplex){
          throw {
              level: 1,
              message: errors.passwordComplex,
              formerrors: {main: errors}
          };
        }
 
        if(errors.passwordStrength){
          throw {
              level: 1,
              message: errors.passwordStrength,
              formerrors: {main: errors}
          };
        }        
        
        if(errors.match){
          throw {
              level: 1,
              message: errors.match,
              formerrors: {main: errors}
          };
        }
        if(errors.samePassword){
          throw {
              level: 1,
              message: errors.samePassword,
              formerrors: {main: errors}
          };
        
        }
        return {};
    },
    
    
    cancel: function (args){
    //TODO: Insert your code
    },
    
}' WHERE [Id]='dd9ae999-1e15-4f09-8114-10e64df4003e';

UPDATE [dwMetadata] SET
[Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'respdashboard-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:00.000', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 18:54:45.557', 
[Data]=N'{

    init: function(args){
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi))                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------
        
        CloverApp.API.setDataField("IsIncludeUnansweredSectionPDFExport", false);
        const innerArgs = args;            
        const PENDING = "A3D01086-40FC-4A7A-BF0C-DE17BDD205FA".toLowerCase();
        const IN_PROGRESS = "0D67932C-62EA-4CD3-A254-0CC63E742C93".toLowerCase();
        
        const iconBtnClass = "ui icon button large inverted";
        const iconBtnDisabledClass = "ui icon button large disabled";
        const popupProps = { size:''mini'', on:''hover'', position:''top right''};
        const styleInlineBlock = { style:{display:"inline-block"}};
        
        const genFormLink = function (p, elements, languages, formName, index) {
          const isMultipleResponse = !!p.row.IsMultipleResponse;
          const ipIsAllowed = p.row.IpAllowed || p.row.IpAllowed === undefined;
          const quotaReached = p.row.MaxResponse !== -1 && p.row.MaxResponse !== null && 
                               p.row.MaxResponse !== undefined && p.row.MaxResponse !== "" &&
                               p.row.MaxResponse <= p.row.TotalComplete;

          if (ipIsAllowed) {
              
            //Render Form link
            const onClickForm = () => {
              checkAccessCode(innerArgs, p, formName, "form");
            };
            const qnnsBtnClass = quotaReached ? "ui teal basic button disabled" : "ui teal basic button";
            const qnnsBtn = CloverApp.API.createElement(
              "span",
              {
                onClick: onClickForm,
                className: qnnsBtnClass,
                style: { width: "150px", height: "40px", marginTop: "10px" },
              },
              languages[index]
            );

            //Render new response button for multiple response surveys
            if (isMultipleResponse) {
              const status = p.row.Status ? p.row.Status.toLowerCase() : "";
              const isCurrentSurvey = new Date(p.row.DueDate) >= Date.now();
              const sampleResponseInProgress = status === IN_PROGRESS;
        
              const showActionAdd = isCurrentSurvey && sampleResponseInProgress;
              if (showActionAdd) {
                const onClickNew = () => {
                  checkAccessCode(innerArgs, p, formName, "new");
                };
                
            
                const btnText = "Add Response";
                const icon = CloverApp.API.createElement("i", {className: "plus icon",ariaHidden: "true" }, "");
                const addBtn = CloverApp.API.createElement("button", { 
                                onClick: onClickNew  , className: iconBtnClass, style: { color: "green", paddingLeft: "0" }
                            },icon);
                const addBtnPopup = CloverApp.API.createElementWithPopup(btnText,popupProps,addBtn); 
        
                const container = CloverApp.API.createElement(
                  "div",
                  { style: { display: "flex", alignItems: "center" } },
                  [qnnsBtn, addBtnPopup]
                );
                elements.push(container);
              } else {
                elements.push(qnnsBtn);
              }
            } else {
              elements.push(qnnsBtn);
            }
          } else {
            elements.push(
              CloverApp.API.createElement(
                "span",
                { title: "This survey is not available in your region", className: "ui red" },
                languages[index]
              )
            );
          }
        };
        
        const createNewResponseAndOpen = function(dlsi, formName) {
            //nb: this is duplicated in submitAccessCode too
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/respondent/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen

        const promptForAccessCode = function(respId, dlsi, formName, p) {
            CloverApp.API.setDataField("AccessCodeRespId", respId);
            CloverApp.API.setDataField("AccessCodeDlsi", dlsi);
            CloverApp.API.setDataField("AccessCodeFormName", formName);
            CloverApp.API.setDataField("AccessCodeRow", p);
            CloverApp.API.setDataField("AccessCode", "");
            innerArgs.component.refs.accessCodeModal.openModal();
        };
        
        const promptForUpload = function (){
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        const promptForDownload = function (innerArgs, p){
            const dlsi = p.row.Id;
            const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            const fileLanguages = p.row.FileLanguages.split(''||'');
            const items = [];
            if(Array.isArray(fileLanguages) && fileLanguages.length>0) {
                for(var i = 0 ; i < fileLanguages.length; i++){
                    items.push( {
                        key: i,
                        text: fileLanguages[i],
                        value: i,
                    });
                }

                CloverApp.API.setDataField(''fileRow'', p);
                Utils.rewriteDropdown("fileDropDown",items, undefined);
                CloverApp.API.setDataField("fileDropDown", 0);

            }
            else
            {
                Utils.rewriteDropdown("fileDropDown",null, undefined);
                CloverApp.API.setDataField("fileDropDown", null);
            }
            
            innerArgs.component.refs.fileDownloadModal.openModal();  
        };

        //checks access code with server and proceeds to form, upload, or code prompt accordingly
        const checkAccessCode = function(innerArgs, p, formName, control) {
            try {
                const respId = p.row.RespId;
                const dlsi = p.row.Id;
                CloverApp.API.setDataField("AccessCodeControl", control); //submitAccessCode will use this too
                
                if(control == ''upload''){
                    //this is for upload modal to work
                    const qnnId = p.row.QnnId;
                    const dplyId = p.row.DplyId;
                    const listSampleId = p.row.ListSampleId;
                    //rewrite the FileUploadUrl
                    CloverApp.API.rewriteControlModel("ExcelFileUpload", model => {
                        model.customPostUrl = "/respondent/uploadexcelresponse?" + new URLSearchParams( { qnnId, dplyId, listSampleId, dlsi } );
                        model.onUploadBegin = () => Utils.loadingStart("Uploading response...");
                        model.onUploadEnd = Utils.loadingStop;
                    });
                    
                    CloverApp.API.setDataField("AccessCodeDlsi", dlsi);
                    CloverApp.API.setDataField("UploadQnnId", p.row.QnnId);
                    CloverApp.API.setDataField("UploadDplyId", p.row.DplyId);
                    CloverApp.API.setDataField("UploadListSampleId", p.row.ListSampleId);
                    CloverApp.API.setDataField("UploadDlsi", dlsi);

                    //create the language option
                    const formNames = p.row.FormNames.split(''||'');
                    const languages = p.row.Languages.split(''||'');
                    CloverApp.API.setDataField("UploadFormNames", formNames);
                    
                    if(Array.isArray(formNames) && formNames.length>0) {
                        const options = [];
                        for(var i=0; i<formNames.length; i++) {
                            options.push( {
                                key: i,
                                value: i,
                                text: languages[i],
                            } );
                        }
                        CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", options);
                        CloverApp.API.setDataField("UploadFormChoice", 0);
                    } else {
                        CloverApp.API.changeModelControl(innerArgs, "UploadFormChoice","data-elements", {} );
                        CloverApp.API.setDataField("UploadFormChoice", null);
                    }
                } //end of if control is upload
                
                const performAction = function() {
                    if(control == ''form''){
                        redirectToSurvey(dlsi, formName, respId);
                    }else if(control == ''upload''){
                        promptForUpload();
                    }else if(control == ''new'') {
                        createNewResponseAndOpen(dlsi, formName);
                    }else if(control == ''print'') {
                        openPrintModal(innerArgs,p);
                    }else if(control == ''download''){
                        promptForDownload(innerArgs,p);
                    }
                };
                
                if(p.row.RequireAccessCode) {
                    Utils.loadingStart("Loading");
                    Utils.getRequest("/respondent/accesscode", { dlsi }).then(
                        result => {
                            const codeVerifiedSuccessfully = result.item.validated;
                            if(codeVerifiedSuccessfully) {
                                performAction();
                            } else {
                                promptForAccessCode(respId, dlsi, formName, p);
                            }
                        }, reason => {
                            console.error(response);
                            alertify.error( Utils.encodeHTML(response.message) );
                        }
                    ).finally(Utils.loadingStop); 
                } else { //if dont require access code
                    performAction();
                }
            } catch(e) {
                console.log("Error in checkAccessCode",e);
            }
        }; //end of checkAccessCode
        
        const openDelegateModal = function(innerArgs, p) {
            CloverApp.API.setDataField("DelegateFromName", "");
            CloverApp.API.setDataField("DelegateCode", "");
            CloverApp.API.setDataField("DelegateName", "");
            CloverApp.API.setDataField("DelegateComments", "");
            CloverApp.API.setDataField("DelegateEmail", "");
            CloverApp.API.setDataField("DelegateValidityStart", CloverApp.API.formatDatetime(new Date(),"") );
            CloverApp.API.setDataField("DelegateValidityEnd", CloverApp.API.formatDatetime(p.row.DueDate,""));
            CloverApp.API.setDataField("DelegateDlsi", p.row.Id);
            innerArgs.component.refs.delegateModal.openModal();
        };

        const checkAccessCodeForPrint = function(innerArgs, p) {
            checkAccessCode(innerArgs, p, '''', ''print'');
        };
        
        const openPrintModal = function(innerArgs, p) {
            const languages = p.row.Languages.split(''||'');
            const formNames = p.row.FormNames.split(''||'');
            const items = [];
            
            if(Array.isArray(formNames) && formNames.length>0) {
                for(var i = 0 ; i < formNames.length; i++){
                    items.push( {
                        key: i,
                        text: languages[i],
                        value: formNames[i],
                    });
                }

                CloverApp.API.setDataField(''printRow'', p);
                Utils.rewriteDropdown("formNameDropDown",items, undefined);
                CloverApp.API.setDataField("formNameDropDown", formNames[0]);
                if(items.length > 1) {
                    Utils.dispatchHideControl("formNameDropDown", "show");
                    Utils.dispatchHideControl("staticcontent_print", "show");
                }
                else {
                    Utils.dispatchHideControl("formNameDropDown", "hide");
                    Utils.dispatchHideControl("staticcontent_print", "hide");
                }

            }
            else
            {
                Utils.rewriteDropdown("formNameDropDown",null, undefined);
                CloverApp.API.setDataField("formNameDropDown", null);
            }
            let IsIncludeUnansweredSection = p.row.IsIncludeUnansweredSection;
            if(IsIncludeUnansweredSection == null) 
                IsIncludeUnansweredSection = args.data.printAllPage;
            if(IsIncludeUnansweredSection) {
                Utils.dispatchHideControl("IsIncludeUnansweredSectionPDFExport", "show");
            }
            else {
                Utils.dispatchHideControl("IsIncludeUnansweredSectionPDFExport", "hide");
            }
            CloverApp.API.setDataField("inputEmails", p.row.sampleEmails);
            innerArgs.component.refs.printModal.openModal();
        }; 
        
        const getPasswordAsync = function (args, id) {
            const formData = new FormData();
            formData.append(''id'', id);
            fetch("/respondent/getpassword", {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            }).then( response => response.json()
            ).then( response => {
                if (response.success) {
                    args.controlRef.refs.passwordModal.openModal();
                    args.component.state.data.password = response.item;
                    args.component.refs.password.forceUpdate();
                } else {
                    console.error(response.message);
                    alertify.error( Utils.encodeHTML(response.message) );
                }
            }).catch(error => {
                console.error(error.message);
                alertify.error( Utils.encodeHTML(error.message) );
            });
        }; //end of getPasswordAsync 
        
        const formColumnFormatter = function (p) {
          if (p.row.Type === "Online") {
            const formNames = p.row.FormNames.split(''||'');
            const languages = p.row.Languages.split(''||'');
            let elements = [];
        
            formNames.forEach( genFormLink.bind(null, p, elements, languages) );
            return CloverApp.API.createElement("div", { style: { display: "flex", flexDirection: "column" , justifyContent: "center", alignItems: "center" } }, elements);
          } else {
            return CloverApp.API.createElement("div", {}, p.value); 
          }
        };

        const fileColumnFormatter = function(p) {
            const dlsi = p.row.Id;
            const isExcelEnabled = p.row.IsExcelEnabled;
            const isOnlineSurvey = p.row.QnnType=="O";
            const hasOnlineFiles = isOnlineSurvey && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
            //console.log("In fileColumnFormatter for "+p.row.QnnTitle+" for deployment "+p.row.DplyName+". hasOnlineFiles="+hasOnlineFiles+", isExcelEnabled="+isExcelEnabled+", row:", p.row);
            if(hasOnlineFiles && isExcelEnabled){
                const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
                const fileNames = p.row.FileNames.split(''||'');
                const fileLanguages = p.row.FileLanguages.split(''||'');
                const fileTokens = p.row.FileTokens.split(''||'');      
                let elements = [];
                for(let i=0; i < fileNames.length; i++) {
                    let element;
                    if(ipAllowed) {
                        const respId = p.row.RespId ? p.row.RespId : '''';
                        const linkUrl = "/respondent/download/file/" 
                            + encodeURIComponent(dlsi) 
                            + "/"  + encodeURIComponent(fileTokens[i]) 
                            + "/" + encodeURIComponent(respId);
                        element = CloverApp.API.createElement("a", { href: linkUrl, target: "_blank"}, fileLanguages[i]);
                    } else {
                        element = CloverApp.API.createElement("span", {title: "This survey is not available in your region", className: "ui red"}, fileLanguages[i]);
                    }         
                    elements.push(element);
                    elements.push( CloverApp.API.createElement("br") );
                }
                return CloverApp.API.createElement("div", {}, elements);
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }
        }; //end of fileColumnFormatter
        
        const fileButtonFormatter = function(p) {
            const dlsi = p.row.Id;
            const isExcelEnabled = p.row.IsExcelEnabled;
            const isOnlineSurvey = p.row.QnnType=="O";
            const hasOnlineFiles = isOnlineSurvey && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
                    
            const btnText = "Downloads";
            //const icon = CloverApp.API.createElement("i", {className: "download icon",ariaHidden: "true" }, "");
            const downloadBtn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCode(innerArgs, p, '''', ''download''), 
                className: "ui teal secondary button"
              },
              btnText
            );
                    
            if(hasOnlineFiles && isExcelEnabled){
                return CloverApp.API.createElementWithPopup(btnText,popupProps,downloadBtn); 
            }else{
                return CloverApp.API.createElement("div", {}, "");
            }
        } //end of fileButtonFormatter
        
        const excelButtonFormatter = function(p) {
            
            const btnText = "Upload Excel";
            //const icon = CloverApp.API.createElement("i", {className: "file excel icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCode(innerArgs, p, '''', ''upload''), 
                className: "ui teal secondary button"
              },
              btnText
            );
                    
            const isExcelEnabled = p.row.IsExcelEnabled;
            const hasOnlineFiles = p.row.QnnType=="O" && (p.row.FileLanguages!==undefined && p.row.FileLanguages!==null && ""!==p.row.FileLanguages.trim());
            const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            const status = p.row.Status ? p.row.Status.toLowerCase() : "";
            if(isExcelEnabled && hasOnlineFiles && ipAllowed && (status===PENDING || status===IN_PROGRESS) ) {
                const formNames = p.row.FormNames.split(''||''); 
                const languages = p.row.Languages.split(''||''); 
                return CloverApp.API.createElementWithPopup(btnText,popupProps,btn); 
            }
            else if(isExcelEnabled && hasOnlineFiles && ipAllowed && !(status===PENDING || status===IN_PROGRESS) ){
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => checkAccessCode(innerArgs, p, '''', ''upload''), 
                className: "ui teal secondary button disabled"
              },
              btnText
            );
                const container = CloverApp.API.createElement("div", {...styleInlineBlock}, btn); //For disabled component, require a div to cover in order to show the popup.
                return CloverApp.API.createElementWithPopup(btnText, popupProps, container);
            }
            else{
                return CloverApp.API.createElement("div", {}, "");
            }
        } //end of excelButtonFormatter

        const actionsColumnFormatter  = function (p) {
            const excelButton = excelButtonFormatter(p);
            return CloverApp.API.createElement("div", {}, [excelButton]);
        }; //end of actionsColumnFormatter

        const delegateColumnFormatter = function (p) {
            const requireAccessCode = p.row.RequireAccessCode;
            const btnText = "Delegate";
            //const icon = CloverApp.API.createElement("i", {className: "sitemap icon",ariaHidden: "true" }, "");
            const btn = CloverApp.API.createElement(
              "button", {
                onClick: () => openDelegateModal(innerArgs, p), 
                className: "ui teal secondary button"
              },
              btnText
            );

            if(requireAccessCode){
                return CloverApp.API.createElementWithPopup(btnText,popupProps,btn); 
            }
            else{
                return CloverApp.API.createElement("div", {}, ""); 
            }
        }; //end of delegateFormatter
        
        const printColumnFormatter = function (p) {
            if((innerArgs.data.IsPDFExportForSubmittedOnly && p.row.RespDateEnd !== null) || !innerArgs.data.IsPDFExportForSubmittedOnly){
                const btnText = "Email PDF";
                //const icon = CloverApp.API.createElement("i", {className: "envelope icon",ariaHidden: "true" }, "");
                const btn = CloverApp.API.createElement(
                  "button", {
                    onClick: () => checkAccessCodeForPrint(innerArgs, p), 
                    className: "ui teal secondary button"
                  },
                  btnText
                );
                return CloverApp.API.createElementWithPopup(btnText,popupProps,btn); 
            }
            else 
            {
                return CloverApp.API.createElement("div", {className: "" }, "");   
            }

        }; //end of printColumnFormatter 

        //Current surveys card grid
        const currentCardModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
            
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                cols.Form.customFormatter = formColumnFormatter;
                cols.File.customFormatter = fileButtonFormatter;
                cols.Actions.customFormatter = actionsColumnFormatter; //upload
                cols.Delegate.customFormatter = delegateColumnFormatter;

                if(!innerArgs.data.backendPrintEnable) {
                    delete cols["Print"];
                } else {
                    cols.Print.customFormatter = printColumnFormatter;
                }
            }
            return model;
        }; //end of currentCardModelRewriter
            
        //Previous surveys card grid    
        const previousCardModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Form.customFormatter = formColumnFormatter;
                if(!innerArgs.data.backendPrintEnable) {
                    delete cols["Print"];
                } else {
                    cols.Print.customFormatter = printColumnFormatter;
                }
            }
            return model;
        }; //end of previousCardModelRewriter
            
        //fetch and display respondent portal messages
        Utils.getRequest("/swzdata/getmultiple?type=RespDashboard").then(
            response => {
                const htmlData = [];
                for (var i=0; i<response.data.length; i++){
                    htmlData.push(response.data[i].editorState);
                }
                CloverApp.API.setDataField("respDashboardHtmlView", htmlData);
            }, reason => {
                console.log("Unable to fetch respondent content", reason);
            }
        );
        CloverApp.API.rewriteControlModel("currentSurveyCard", currentCardModelRewriter);
        CloverApp.API.rewriteControlModel("previousSurveyCard", previousCardModelRewriter);
        
        //when uncommented it causes scrollbar reset issue
        //$(''.react-grid-Cell__value'').trigger("click"); //force refreshing grid
        
        const gridDelegateModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                model.columns[5].customFormatter = function (p) {
                    if(p.row.Comments){
                        var Comments = p.row.Comments;

                        return CloverApp.API.createElement("div", {title: Comments, className:"react-grid-Cell-Comments"}, Comments); 
                    }
                    else{
                        return CloverApp.API.createElement("div", {className: "" }, "");                        
                    }
                  
                };
            }
            return model;
        }; //end of gridDelegateModelRewriter
        
        CloverApp.API.rewriteControlModel("gridDelegation", gridDelegateModelRewriter); 
        
    }, //end of init

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    closeAccessCodeModal: function(args) {
        args.component.refs.accessCodeModal.close();
        args.data.AccessCode = null;
        return {};
    },
    
    closeDelegateModal: function(args) {
        args.component.refs.delegateModal.close();
        CloverApp.API.setDataField("DelegateCode", "");
        return {};
    },

    closePrintModal: function(args) {
        args.component.refs.printModal.close();
        CloverApp.API.setDataField("printRow", "");
        CloverApp.API.setDataField("IsIncludeUnansweredSectionPDFExport", false);
        return {};
    },
    
    closeFileUploadModal: function(args) {
        args.component.refs.fileUploadModal.close();
        args.data.AccessCode = null;
        return {};
    },
    
    closeFileDownloadModal: function(args) {
        args.component.refs.fileDownloadModal.close();
        args.data.AccessCode = null;
        return {};
    },

    promptForExcelFile: function(args) {
        const file = $("input[name=''ExcelFileUpload'']");
        file.trigger(''click'');
        return {};
    },
    
    excelFileUploaded: function(args) {
        const result = args.sourceControlValue;
        CloverApp.API.setDataField("ExcelFileUpload", null); 
        if("OK"===result) {
            args.component.refs.fileUploadModal.close();
            
            const qnnId = args.data.UploadQnnId;
            const dplyId = args.data.UploadDplyId;
            const listSampleId = args.data.UploadListSampleId;
            if( (!qnnId) || (!dplyId) || (!listSampleId)) {
                console.error("Missing required value for one of qnnId, dplyId, listSampleId", args.data);
                alertify.error("File processed successfully but an error occured opening the form. Try opening the form using the form link instead.", 15000);
                return {};
            }
            
            const uploadFormChoice = args.data.UploadFormChoice;
            const formName = args.data.UploadFormNames[uploadFormChoice];
            const uploadDlsi = args.data.AccessCodeDlsi;
            //args.component.refs.grid.refresh();
            alertify.success("Survey answers uploaded");
            
            if(formName) {
                CloverApp.API.redirect(''form'', formName, ''dlsi/''+ uploadDlsi);
            }
        } else {
            console.log("Excel upload failure code", result);
            let errorMessage = "Excel upload was not successful.";
            if("INCORRECT FILE TYPE" === result) {
                errorMessage = "Invalid file. Please select an Excel file.";
            } else if ("MISSING RANGES" === result) {
                errorMessage = "The spreadsheet is missing named ranges for one or more answers. Did you upload the correct file?";
            } else if ("INCORRECT UEN" === result) {
                errorMessage = "This file is for another respondent. The UEN recorded in the spreadsheet does not match your UEN.";
            } else if("RESTRICTED IP" === result) {
                errorMessage = "Your IP Address or Country is restricted from accessing this survey.";
            } else if ("INCORRECT ACCESS CODE" === result) {
                errorMessage = "Access Code is incorrect or has expired.";
            } else if ("INTERNAL ERROR" === result) {
                errorMessage = "Internal Error. Excel upload was not successful.";
            }
            alertify.error( Utils.encodeHTML(errorMessage), 10000);
        }
        return {};
    },
    
    submitAccessCode: function(args) {
        
        //--------------------------------------------
        const redirectToSurvey = function(dlsi, formName, respId) {
            if(respId){
                    CloverApp.API.redirect(''form'', formName, ''respid/'' + encodeURIComponent(respId) + ''/dlsi/''+ encodeURIComponent(dlsi))                         
                }
                else{
                    CloverApp.API.redirect(''form'', formName, ''dlsi/''+ encodeURIComponent(dlsi));                        
                }
        };
        //--------------------------------------------
        
        const openPrintModal = function(args) {
            const p = args.data.AccessCodeRow;
            const languages = p.row.Languages.split(''||'');
            const formNames = p.row.FormNames.split(''||'');
            const items = [];
            
            if(Array.isArray(formNames) && formNames.length>0) {
                for(var i = 0 ; i < languages.length; i++){
                    items.push( {
                        key: i,
                        text: languages[i],
                        value: formNames[i],
                    });
                }
                CloverApp.API.setDataField(''printRow'', p);
                Utils.rewriteDropdown("formNameDropDown",items, undefined); 
                CloverApp.API.setDataField("formNameDropDown", formNames[0]);
                if(items.length > 1) {
                    Utils.dispatchHideControl("formNameDropDown", "show");
                    Utils.dispatchHideControl("staticcontent_print", "show");
                }
                else {
                    Utils.dispatchHideControl("formNameDropDown", "hide");
                    Utils.dispatchHideControl("staticcontent_print", "hide");
                }
            }
            else
            {
                Utils.rewriteDropdown("formNameDropDown",null, undefined);
                CloverApp.API.setDataField("formNameDropDown", null);
            }
            
            let IsIncludeUnansweredSection = p.row.IsIncludeUnansweredSection;
            if(IsIncludeUnansweredSection == null) 
                IsIncludeUnansweredSection = args.data.printAllPage;
            if(IsIncludeUnansweredSection) {
                Utils.dispatchHideControl("IsIncludeUnansweredSectionPDFExport", "show");
            }
            else {
                Utils.dispatchHideControl("IsIncludeUnansweredSectionPDFExport", "hide");
            }
            CloverApp.API.setDataField("inputEmails", p.row.sampleEmails);
            innerArgs.component.refs.printModal.openModal();
        };
        
        
        const promptForDownload = function (innerArgs){
            const p = args.data.AccessCodeRow;
            const dlsi = p.row.Id;
            const ipAllowed = (p.row.IpAllowed || p.row.IpAllowed===undefined);
            const fileLanguages = p.row.FileLanguages.split(''||'');
            const items = [];
            if(Array.isArray(fileLanguages) && fileLanguages.length>0) {
                for(var i = 0 ; i < fileLanguages.length; i++){
                    items.push( {
                        key: i,
                        text: fileLanguages[i],
                        value: i,
                    });
                }

                CloverApp.API.setDataField(''fileRow'', p);
                Utils.rewriteDropdown("fileDropDown",items, undefined);
                CloverApp.API.setDataField("fileDropDown", 0);

            }
            else
            {
                Utils.rewriteDropdown("fileDropDown",null, undefined);
                CloverApp.API.setDataField("fileDropDown", null);
            }
            
            innerArgs.component.refs.fileDownloadModal.openModal();  
        };
        
        //--------------------------------------------
        const createNewResponseAndOpen = function(dlsi, formName) {
            //nb: this is duplicated in submitAccessCode too
            const formData = new FormData();
            formData.append("id",dlsi);
            Utils.loadingStart();
            Utils.postFormRequest("/respondent/newresponse", formData).then(
                response => {
                    const respId = response.item;
                    console.log("New response added", respId);
                    redirectToSurvey(dlsi, formName, respId);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally( Utils.loadingStop );
        }; //end of createNewResponseAndOpen
        //--------------------------------------------
        
        const innerArgs = args;
        
        const promptForUpload = function (){
            innerArgs.component.refs.fileUploadModal.openModal();
        };
        
        const accessCode = args.data.AccessCode.trim();
        if(accessCode === undefined || accessCode === null || accessCode == "") {
            alertify.error("Please enter an Access Code");
            return {};
        }
        
        const respId = args.data.AccessCodeRespId;
        const dlsi = args.data.AccessCodeDlsi;
        const formName = args.data.AccessCodeFormName;
        const control = args.data.AccessCodeControl;
        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("accessCode", accessCode);
        Utils.loadingStart("Validating Access Code");
        Utils.postFormRequest("/respondent/accesscode", form).then(
            result => {
                if(result.item.validated) {
                    respdashboardUserActions.closeAccessCodeModal(innerArgs);
                    switch(control) {
                        case ''form'':
                            redirectToSurvey(dlsi, formName, respId);
                            break;
                        case ''upload'':
                            promptForUpload();
                            break;
                        case ''new'':
                            createNewResponseAndOpen(dlsi, formName);
                            break;
                        case ''print'':
                            openPrintModal(innerArgs);
                            break;
                        case ''download'' :
                            promptForDownload(innerArgs);
                            break;
                    }
                } else if(result.item.exceed){
                    alertify.error( Utils.encodeHTL(result.item.message) );
                } else{
                    alertify.error("Access Code is incorrect or has expired");
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);

    },
    
    delegate: function(args) {
        
        const data = args.data;
        
        const dlsi = data.DelegateDlsi;
        const validityStart = data.DelegateValidityStart;
        const validityEnd = data.DelegateValidityEnd;
        const name = data.DelegateName;
        const email = data.DelegateEmail;
        const comments = data.DelegateComments;
        const delegateFromName = data.DelegateFromName;
        const delegateCode = data.DelegateCode.trim();
        const emailRegExr = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        const displayTime = 15000;
        let validated = true;
        if(validityStart===undefined || validityStart===null || validityStart==='''') {
            alertify.error("Validity start date is required", displayTime);
            validated = false;
        }
        if(validityEnd===undefined || validityEnd===null || validityEnd==='''') {
            alertify.error("Validity end date is required", displayTime);
            validated = false;
        }
        if(validityStart >= validityEnd || validityEnd <= new Date()) {
            alertify.error("Invalid validity period", displayTime);
            validated = false;
        }
        if(email===undefined || email===null || email==='''') {
            alertify.error("Email address is required", displayTime);
            validated = false;
        }
        if(!emailRegExr.test(email)){
            alertify.error("Invalid email address", displayTime);
            validated = false;
        }
        if(delegateCode===undefined || delegateCode===null || delegateCode===''''){
            alertify.error("Please provide your delegate code to authorise the delegation", displayTime);
            validated = false;
        }
        if(name===undefined || name===null || name==='''') {
            alertify.error("Delegate''s name is required", displayTime);
            validated = false;
        }
        if(delegateFromName===undefined || delegateFromName===null || delegateFromName==='''') {
            alertify.error("Your name is required", displayTime);
            validated = false;
        }
        if(!validated) {
            return {};
        }
        
        const form = new FormData();
        form.append("dlsi", dlsi);
        form.append("validityStart", validityStart);
        form.append("validityEnd", validityEnd);
        form.append("name",name);
        form.append("email", email);
        form.append("delegateFromName", delegateFromName);
        form.append("delegateCode", delegateCode);
        form.append("comments",comments);
        Utils.loadingStart("Delegating...");
        Utils.postFormRequest("/respondent/delegate", form).then(
            result => {
                alertify.success("Delegation recorded. An access code has been generated and sent to " + email, displayTime);
                args.component.refs.delegateModal.close();
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason), displayTime);
            }
        ).finally(Utils.loadingStop);
        
        return {};
    },
    
    openDelegateHistoryModal: function(args){
        const gridDelegationModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
            
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                
                cols.Revoke.customFormatter = RevokeColumnFormatter;                
            }
            return model;
        }; //end of gridDelegationModelRewriter
        
        const RevokeColumnFormatter = function (p) {
            const status = p.row.Status;
            if(status == ''Active'' || status == ''Scheduled'' || status == ''Inactive''){
                return CloverApp.API.createElement(
                    "button", {
                        onClick: () => revokeDelegationById(args, p.row.Id), 
                        className: "ui button secondary invert",
                    }, "Revoke");
            } else {
                return CloverApp.API.createElement("div", {}, ""); 
            }
        };
        
        const revokeDelegationById = function(args, p) {
            const formData = new FormData();
            formData.append("delegateId", p);
            formData.append("dlsi", args.data.DelegateDlsi);
            formData.append("delegateCode", args.data.DelegateCode);
            Utils.loadingStart();
            Utils.postFormRequest("/respondent/revokedelegationbyid",formData).then(
                response => {
                    alertify.success(response.message);
                    // Refresh the grid with new data, use POST to keep delegateCode out of the URL itself
                    Utils.postFormRequest("/respondent/viewdelegatelist", formData).then( 
                        response => {
                            CloverApp.API.setDataField(''gridDelegation'', response.item);
                            args.component.refs.gridDelegation.refresh();
                        }, reason => {
                            console.error("request to viewdelegatelistfailed", reason);
                            alertify.error( Utils.encodeHTML(reason) );
                        }
                    );
                }, reason => {
                    console.error("request to revokedelegationbyid failed", reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        }; //end of revokeDelegationById
        
        CloverApp.API.setDataField(''gridDelegation'', null);
        
        const delegateCode = args.data.DelegateCode.trim();
        
        const displayTime = 15000;
        if(delegateCode===undefined || delegateCode===null || delegateCode===''''){
            alertify.error("Please provide your delegate code to view delegation history", displayTime);
            return {};
        }
        
        const formData = new FormData();
        formData.append("dlsi", args.data.DelegateDlsi);
        formData.append("delegateCode", delegateCode);
        // Use POST to hide delegateCode in the message body
        Utils.loadingStart();
        Utils.postFormRequest("/respondent/viewdelegatelist", formData).then(
            response => {
                CloverApp.API.setDataField(''gridDelegation'', response.item);
                CloverApp.API.rewriteControlModel("gridDelegation", gridDelegationModelRewriter);
                args.component.refs.delegateHistoryModal.openModal();
                args.component.refs.gridDelegation.refresh();
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    }, //end of openDelegateHistoryModal
    
    closeDelegateHistoryModal: function(innerArgs){
        CloverApp.API.setDataField(''gridDelegation'', null);
        innerArgs.component.refs.delegateHistoryModal.close();
    },
    
    revokeAllDelegation: function(args){
        const formData = new FormData();
        formData.append("dlsi", args.data.DelegateDlsi);
        formData.append("delegateCode", args.data.DelegateCode);
        Utils.loadingStart(); 
        Utils.postFormRequest("/respondent/revokedelegationbydlsi", formData).then(
            response => {
                alertify.success(response.message);
                // Refresh the grid with new data
                // Use POST to hide delegateCode in the message body
                Utils.postFormRequest("/respondent/viewdelegatelist", formData).then(
                    response => {
                        CloverApp.API.setDataField(''gridDelegation'', response.item);
                        args.component.refs.gridDelegation.refresh();
                    }, reason => {
                        console.error("call to viewdelegatelist faield", reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                );
            }, reason => {
                console.log("call to revokedelegationbydlsi failed", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    onPrintClick: function(args) {
        let validated = true;
        const emails = args.data.inputEmails;
        const IsIncludeUnansweredSection = args.data.IsIncludeUnansweredSectionPDFExport;
        if(emails==undefined || emails==null || emails.length==0){
            alertify.error("Email is required");
            validated = false;
        }
        
        if(emails
        && emails.trim()!=="" 
        && !(emails.split('','').filter(m => !(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/).test(m.trim())).length==0)) {
                alertify.error("Please enter valid email address");  
                validated = false;
        }
        
        if(!validated){
            return {};
        }
        const p = args.data.printRow;
        const respId = p.row.RespId;
        const dlsi = p.row.Id;
        const formName = args.data.formNameDropDown;
        const formData = new FormData();
        formData.append(''formName'', formName);
        formData.append(''dlsi'', dlsi);
        formData.append(''respId'', respId ? respId : "");
        Utils.loadingStart();
        fetch("/print/form", {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            })
            .then(response => response.json())
            .then(response => {
            if (response.success) {
                CloverApp.API.printForm(response.form, response.data, IsIncludeUnansweredSection)
                    .then(function(htmlContent) {
                        const formDataPrint = new FormData();
                        formDataPrint.append(''htmlContent'',htmlContent);
                        formDataPrint.append(''emails'',emails);
                        formDataPrint.append(''surveyName'',p.row.QnnTitle);
                        fetch("/print/download", {
                                credentials: ''same-origin'',
                                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                                method: ''post'',
                                body: formDataPrint
                            })
                            .then(response => response.json())
                            .then(response => {
                            Utils.loadingStop();
                            if (response.success) {
                                alertify.success( Utils.encodeHTML(response.message) );
                                CloverApp.API.setDataField("printRow", "");
                                CloverApp.API.setDataField("inputEmails", "");
                                CloverApp.API.setDataField("IsIncludeUnansweredSectionPDFExport", false);
                                args.component.refs.printModal.close();
                            } else {
                                alertify.error( Utils.encodeHTML(response.message) );
                            }
                        })
                        .catch(error => {
                            Utils.loadingStop();
                            console.error(error);
                            alertify.error( Utils.encodeHTML(error.message) );
                        });
                    })
                    .catch(function(error) {
                        // Handle error if printFormDiv fails
                        console.error("Error:", error);
                    });

            } else {
                Utils.loadingStop();
                alertify.error( Utils.encodeHTML(response.message) );
            }
        })
        .catch(error => {
            console.error(error);
            Utils.loadingStop();
            alertify.error( Utils.encodeHTML(error.message) );
        });
    },
    
    onDownloadClick: function(args) {
        const p = args.data.fileRow;
        const dlsi = p.row.Id;
        const file = args.data.fileDropDown;
        const fileTokens = p.row.FileTokens.split(''||'');
        const fileNames = p.row.FileNames.split(''||'');
        const respId = p.row.RespId ? p.row.RespId : '''';
        const downloadUrl = "/respondent/download/file/" + encodeURIComponent(dlsi) + "/" + encodeURIComponent(fileTokens[file]) + "/" + encodeURIComponent(respId);
    
        Utils.loadingStart("Loading");
        fetch(downloadUrl)
            .then(response => {
                if (!response.ok) {
                    throw new Error(''Network response was not ok'');
                }
                return response.blob();
            })
            .then(blob => {
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement(''a'');
                a.href = url;
                a.download = fileNames[file];
                a.style.display = ''none'';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                window.URL.revokeObjectURL(url);
            })
            .catch(error => {
                console.error(''Error downloading file:'', error);
                alertify.error(''Error downloading file.'');
            })
            .finally(() => {
                Utils.loadingStop();
            });
    }
}








' WHERE [Id]='7479adc7-5164-48a5-b4c6-2eb01eca68df';

UPDATE [dwMetadata] SET
[Id]='4d879db0-1a88-4b78-80f7-03229fb983b0', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'RespondentParticipationReport-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-04-05 13:38:21.357', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 19:04:03.193', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);

        //init run
        Utils.queueTask( respondentparticipationreportUserActions.gridFilter );
    },
    
    onExport: function(args) {
        const formData = new FormData();
        if(args.data.UID != undefined){
            formData.append(''UID'', args.data.UID);
        }
        if(args.data.RespName != undefined){
            formData.append(''RespName'', args.data.RespName);
        }
        
        if(args.data.Status != undefined){
            formData.append(''StatusId'', args.data.Status);
        }
        
        if(args.data.DeploymentName != undefined){
            formData.append(''DplyId'', args.data.DeploymentName);
        }

        Utils.loadingStart();
        Utils.postFormRequest("/report/respondentparticipation",formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
            }, reason => {
                console.log(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },

    //gridview must not in any container
    gridFilter: function() {
        
        //nb: args is not available in this function
        
        const data = CloverStore.getState().app.form.data.modified; //get from store to facilitate use in queued callback task
        const searchUID = data.UID ? data.UID : "";
        const searchRespName = data.RespName ? data.RespName : "";
        const filterDeploymentName = data.DeploymentName ? data.DeploymentName : [];
        const filterStatus = data.Status ? data.Status : [];

        const searchParams = new URLSearchParams({
            UID: searchUID,
            RespName: searchRespName,
            StatusIds: filterStatus,
            DplyIds: filterDeploymentName
        });
        const searchUrl = "/report/respondentparticipationgridfilter?" + searchParams;

        Utils.loadingStart("Fetching data...");
        Utils.getRequest(searchUrl).then(response => {
                if(response.success && response.item !== null) {
                    CloverApp.API.setDataField("gridview_1", response.item);
                }
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    actionAddAllFields: function(args){
        var options = args.component.refs.Status.state.options;
        var keys = [];
        if(options != null) {
            for(var x = 0 ; x < options.length ; x++){
                    keys.push(options[x].key);
                }
        }
        CloverApp.API.setDataField("Status", keys);
        
        //update grid
        Utils.queueTask( respondentparticipationreportUserActions.gridFilter );
    },
    
    actionRemoveAllFields: function(args){
        CloverApp.API.setDataField("Status", []);
        
        //update grid
        Utils.queueTask( respondentparticipationreportUserActions.gridFilter );
    },
    
}' WHERE [Id]='4d879db0-1a88-4b78-80f7-03229fb983b0';

UPDATE [dwMetadata] SET
[Id]='bb7baf67-5196-47d3-926b-f58d1ee9c9d7', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SampleStimulsoftReport-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-10-19 14:50:38.337', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 19:12:36.393', 
[Data]=N'{
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
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(()=>{       
                Utils.loadingStop();
        });
        
    }
}' WHERE [Id]='bb7baf67-5196-47d3-926b-f58d1ee9c9d7';

UPDATE [dwMetadata] SET
[Id]='057924ab-2b2b-4f40-a90a-28506e9c12ce', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ResponseReport-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2020-01-17 14:32:42.590', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 19:08:19.987', 
[Data]=N'{
    
   getCount: function(args){
        

 var htmlTable = ''<table style="border-color: black; width: 100px; height: 100px;" border="1"><tbody><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></tbody></table>'';

 CloverApp.API.setDataField(''HTMLTable'',htmlTable);
        
    },

  onSearch: function (args){

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
    
    var _getNumOfWeeks = function(totweeks){
            var arr = [];
            
            if(totweeks == 1)
            {
                var obj = { key : 1 ,
                value : 1 };
                
                arr.push(obj);
            }
           /* if(totweeks == 1)
            {
                var obj = { key : 1 ,
                value : 1 ,
                text : "Latest Week"};
                
                arr.push(obj);
            }*/
            else
            {
                 for(let k = 1; k <= totweeks; k++)
                 {
               var obj = {
                        key: k, 
                        value:k,
                        text: "Week " + k
                     };
                     arr.push(obj);
                }
            }
           
            return arr;
        }
    var dplyId = args.data.ddlDeployment;
    var surveyType = args.data.ddlSurveyType;
    var weeks = args.data.ddlWeek;
    
    if(dplyId == undefined || dplyId == '''' && surveyType == undefined || surveyType == "")
       return alertify.error(''Invalid input'');
    
    var formData = new FormData();
        formData.append(''dplyId'', dplyId);
        formData.append(''rType'',surveyType);
        formData.append(''weekNumber'',weeks);
        
     var url = ''/report/dailyereport'';
     
     var _loadingPromise = new Promise(function(resolve, reject) {
            _loadingStart();

            setTimeout(() => {
                resolve({});
            }, 2000);
        });
        
    var _hideControls = args.state.app.form.models.hideControls;
    return () => {
    _loadingStart();
     return fetch(url,
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
                    var totweeks = response.count;
                    var UpperTable = response.UpperTable;
                    var active = response.Active;
                    var LowerTable = response.LowerTable;
                    var htmlTables = '''';
                    var weeksVal = 0;
                     
                     
                     
                   if(weeks !== null && weeks !== undefined)
                   {
                        weeksVal = Object.keys(weeks).length;
                   }
                   
                      if(totweeks == 0)
                       {
                        htmlTables = ''<br>''+''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;" border="1" bordercolor="#808080" cellpadding="15" background-color="rgba(230, 247, 255,0.1)"><tbody><tr><td><h4>There is no report snapshot saved for this survey.''+''</h4></td></tr></tbody></table>''+''<br>''+''<hr>'';
                       }
                      else if(weeks === null || weeks === undefined || weeksVal === 0 )
                      {
                        upperRows = UpperTable[totweeks];
                        middleRows = active[totweeks];
                        lowerRows = LowerTable[totweeks];
                        if(upperRows.length == 0 || middleRows.length == 0 || lowerRows.length == 0)
                       {
                         htmlTable = ''<br>''+''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;" border="1" bordercolor="#808080" cellpadding="15" background-color="rgba(230, 247, 255,0.1)"><tbody><tr><td><h4>There is no report snapshot saved for week : ''+ totweeks + ''</h4></td></tr></tbody></table>''+''<br>''+''<hr>'';
                       }
                        else
                        {
                            
                        var tableStart =  ''<br>''+''<br>'' +''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;background-color:rgba(230, 247, 255,0.1);" border="1" bordercolor="#808080" cellpadding="15"><tbody style="border-color:#cccccc;">'';
                        var tableContent = '''';
                        var tableContent2 = '''';
                        var tableContent3 = '''';
                        var tableEnd = ''</tbody></table>'';
                    
                       
                       var preResponse;
                       if(totweeks !== null && totweeks !== 0 && totweeks !== 1)
                       {
                             preResponse = UpperTable[totweeks - 1];
                       }
                      
                   
                        for(let h = 0 ; h < upperRows.length; h++){
                           
                            if(totweeks == null || totweeks == 0 || totweeks == 1 )
                            {
                                if(h == 0)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[h].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px"  colspan="5">'' + upperRows[h].ActiveCases + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if ( h == 1)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[h].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[h].ActiveCases + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[h].InactiveCases + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[h].SampleSize + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[h].ResponseRate + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if (h == upperRows.length-1)
                                {
                                    let rowS = ''<tr bgcolor="#ffad33">'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[h].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                                else
                                {
                                     let rowS = ''<tr>'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[h].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
  
                         
                            }
                            else 
                            {
                                
                                  if(h == 0)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[h].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px"  colspan="6">'' + upperRows[h].ActiveCases + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if ( h == 1)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[h].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[h].ActiveCases + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[h].InactiveCases + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[h].SampleSize + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[h].ResponseRate + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[h].ResponseRateforPweek + ''</th>'';//+''<th style="padding:5px;font-size:16px">'' + preResponse[h].ResponseRate + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if (h == upperRows.length-1)
                                {
                                    let rowS = ''<tr bgcolor="#ffad33">'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[h].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRate + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRateforPweek + ''</td>'';//+''<td style="padding:5px">'' + preResponse[h].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                                else
                                {
                                     let rowS = ''<tr>'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[h].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[h].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[h].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRate + ''</td>''+''<td style="padding:5px">'' + upperRows[h].ResponseRateforPweek + ''</td>'';//+''<td style="padding:5px">'' + preResponse[h].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
  
                    
                            }
                                    
                         
                            
                       }
                    
                        for(let g = 0 ; g < middleRows.length; g++){
                            let rowSU = ''<tr>'';
                            let rowEU = ''</tr>'';
                             let MrowData = '''';
                            
                            if( surveyType == ''MP'' || surveyType == ''IU'')
                            
                            {
                               if(g == 0)
                               {
                                   MrowData = ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].ResponseCategory + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].Status + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].TA + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].MTS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].STS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].Total + ''</th>''+''<th></th>'';                    
                               }
                               else if (g == middleRows.length-1)
                               {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[g].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + middleRows[g].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[g].MTS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].STS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].Total + ''</td>''+''<td></td>'';                              
                               }
                               else
                               {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[g].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[g].MTS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].STS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].Total + ''</td>''+''<td></td>'';                                                   
                               }
                         
                            }
                            else
                            {
                                
                                if(g == 0)
                                {
                                   MrowData = ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].ResponseCategory + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].Status + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[g].TA + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].TS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[g].Total + ''</th>''+''<th style="padding:5px;font-size:16px;"> </th>''+''<th style="padding:5px;font-size:16px;"> </th>'' ;                                    
                                }
                                else if (g == middleRows.length-1)
                                {
                                    MrowData = ''<td style="padding:5px">'' + middleRows[g].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + middleRows[g].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[g].TS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'' ;                                    
                                }
                                else
                                {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[g].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[g].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[g].TS + ''</td>''+''<td style="padding:5px">'' + middleRows[g].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'' ;                                                                       
                                }
                         
                            }
                           
                            tableContent2 = tableContent2 + rowSU + MrowData + rowEU;
                            
                       }
                   
                        for(let k = 0 ; k < lowerRows.length; k++){
                            let rowSL = ''<tr>'';
                            let rowEL = ''</tr>'';
                            let LrowData = '''';
                            if( surveyType == ''MP'' || surveyType == ''IU'')
                            {
                             
                                if( k == lowerRows.length-2 )
                                {
                              
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px;font-size:16px;">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[k].MTS + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[k].STS + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[k].Total + ''</td>''+''<td></td>'';
                                }
                                else if( k == lowerRows.length-5 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td></td>'';
                                }
                                else if ( k == lowerRows.length-10 )
                                {
                                   LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td></td>'';                                
                                }
                                else
                                {
                                   LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td></td>'';                                    
                                }
                                
                            }
                            else
                            {
                                if( k == lowerRows.length-2 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'';
                                }
                                else if( k == lowerRows.length-5 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'';
                                }
                                else if ( k == lowerRows.length-10 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'';
                                }
                                else
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[k].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[k].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[k].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td style="padding:5px"> </td>'';
                                }
                         
                        
                            }
                                tableContent3 = tableContent3 + rowSL + LrowData + rowEL;
                            
                       }
                       
                       
                       
                        var htmlTable = tableStart + tableContent + tableContent2 + tableContent3 + tableEnd;
                        
                        }
                        htmlTables = htmlTables + htmlTable;
                   }
                      else
                      {
                        
                      var weekFilterCount = Object.keys(weeks).length;
                      var htmlTables = '''';
                      
                      for (var v = 0 ; v < weekFilterCount; v++)
                        {
                         
                        
                        var tableContent = '''';
                        var tableContent2 = '''';
                        var tableContent3 = '''';
                        
                        var filterWeek = weeks[v];
                           
                             upperRows = UpperTable[filterWeek];
                             middleRows = active[filterWeek];
                             lowerRows = LowerTable[filterWeek];
                             
                             if(upperRows.length == 0 || middleRows.length == 0 || lowerRows.length == 0)
                             {
                                 htmlTable = ''<br>''+''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;" border="1" bordercolor="#808080" cellpadding="15" background-color="rgba(230, 247, 255,0.1)"><tbody><tr><td><h4> There is no report snapshot saved for week : ''+ filterWeek + ''</h4></td></tr></tbody></table>''+''<br>''+''<hr>'';
                             }
                             else
                             {
                                 
                            
                           
                        var tableStart =  ''<br>''+''<br>''+''<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;" border="1" bordercolor="#808080" cellpadding="15" background-color="rgba(230, 247, 255,0.1)"><tbody style="border-color:#cccccc;">'';
                        var tableEnd = ''</tbody></table>''+''<br>''+''<br>''+''<hr>'';
 
                       var preResponse;
                  
                       if(filterWeek !== null && filterWeek !== 0 && filterWeek !== 1)
                       {
                           preResponse = UpperTable[filterWeek - 1];
                       }
                     
                      
                           
                     for(let p = 0 ; p < upperRows.length; p++){
           
           
                     if(filterWeek == null || filterWeek == 0 || filterWeek == 1)
                        
                        {
                            let rowS = ''<tr>'';
                            let rowE = ''</tr>'';
                            let UrowData = ''<td style="padding:5px">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td>'' + upperRows[p].ActiveCases + ''</td>'' + ''<td>'' + upperRows[p].InactiveCases + ''</td>''+''<td>'' + upperRows[p].SampleSize + ''</td>''+''<td>'' + upperRows[p].SampleSizeAft + ''</td>''+''<td>'' + upperRows[p].ResponseRate + ''</td>'' ;
                            //tableContent = tableContent + rowS + UrowData + rowE;



                                     if(p == 0)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[p].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px"  colspan="5">'' + upperRows[p].ActiveCases + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if ( p == 1)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[p].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[p].ActiveCases + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[p].InactiveCases + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[p].SampleSize + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[p].ResponseRate + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if (p == upperRows.length-1)
                                {
                                    let rowS = ''<tr bgcolor="#ffad33">'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                                else
                                {
                                     let rowS = ''<tr>'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }


                         }
                         else
                         {
                                if(p == 0)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:15%;">'' + upperRows[p].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px"  colspan="6">'' + upperRows[p].ActiveCases + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if ( p == 1)
                                {
                                 let rowS = ''<tr>'';
                                 let rowE = ''</tr>'';
                                 let UrowData = ''<th style="padding:5px;font-size:16px;width:20%;">'' + upperRows[p].EnterpriseType + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[p].ActiveCases + ''</th>'' + ''<th style="padding:5px;font-size:16px">'' + upperRows[p].InactiveCases + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[p].SampleSize + ''</th>''+''<th style="padding:5px;font-size:16px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[p].ResponseRate +''</th>''+''<th style="padding:5px;font-size:16px">'' + upperRows[p].ResponseRateforPweek + ''</th>'';//+''<th style="padding:5px;font-size:16px">'' + preResponse[p].ResponseRate + ''</th>'';
                                 tableContent = tableContent + rowS + UrowData + rowE;
                                }
                                else if (p == upperRows.length-1)
                                {
                                     let rowS = ''<tr bgcolor="#ffad33">'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRate + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRateforPweek + ''</td>'';//+''<td style="padding:5px">'' + preResponse[p].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                                else
                                {
                                     let rowS = ''<tr>'';
                                     let rowE = ''</tr>'';
                                     let UrowData = ''<td style="padding:5px;width:20%;">'' + upperRows[p].EnterpriseType + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].ActiveCases + ''</td>'' + ''<td style="padding:5px">'' + upperRows[p].InactiveCases + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSize + ''</td>''+''<td style="padding:5px;width:10%;">'' + upperRows[p].SampleSizeAft + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRate + ''</td>''+''<td style="padding:5px">'' + upperRows[p].ResponseRateforPweek + ''</td>'';//+''<td style="padding:5px">'' + preResponse[p].ResponseRate + ''</td>'';
                                     tableContent = tableContent + rowS + UrowData + rowE;  
                                }
                         }
           
                            
                       }
                       
                      
                     for(let q = 0 ; q < middleRows.length; q++){
                            let rowSU = ''<tr>'';
                            let rowEU = ''</tr>'';
                            let MrowData = '''';
                            
                            if( surveyType == ''MP'' || surveyType == ''IU'')
                            
                            {
                               if(q == 0)
                               {
                                   MrowData = ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].ResponseCategory + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].Status + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].TA + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].MTS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].STS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].Total + ''</th>''+''<th></th>'';                    
                               }
                               else if (q == middleRows.length-1)
                               {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[q].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + middleRows[q].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[q].MTS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].STS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].Total + ''</td>''+''<td></td>'';                              
                               }
                               else
                               {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[q].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[q].MTS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].STS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].Total + ''</td>''+''<td></td>'';                                                   
                               }
                         
                            }
                            else
                             {
                                
                                if(q == 0)
                                {
                                   MrowData = ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].ResponseCategory + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].Status + ''</th>'' + ''<th style="padding:5px;font-size:16px;">'' + middleRows[q].TA + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].TS + ''</th>''+''<th style="padding:5px;font-size:16px;">'' + middleRows[q].Total + ''</th>''+''<th style="padding:5px;font-size:16px;"> </th>''+''<th> </th>'';                                    
                                }
                                else if (q == middleRows.length-1)
                                {
                                    MrowData = ''<td style="padding:5px">'' + middleRows[q].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + middleRows[q].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[q].TS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'' ;                                    
                                }
                                else
                                {
                                   MrowData = ''<td style="padding:5px">'' + middleRows[q].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].Status + ''</td>'' + ''<td style="padding:5px">'' + middleRows[q].TA + ''</td>''+''<td style="padding:5px">'' + middleRows[q].TS + ''</td>''+''<td style="padding:5px">'' + middleRows[q].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'' ;                                                                       
                                }
                         
                            }
                           
                            tableContent2 = tableContent2 + rowSU + MrowData + rowEU;
                            
                       }
                       
                     for(let r = 0 ; r < lowerRows.length; r++){
                            let rowSL = ''<tr>'';
                            let rowEL = ''</tr>'';
                            let LrowData = '''';
                            if( surveyType == ''MP'' || surveyType == ''IU'')
                            {
                             
                                if( r == lowerRows.length-2 )
                                {
                              
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px" bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px;font-size:16px;">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[r].MTS + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[r].STS + ''</td>''+''<td style="padding:5px;font-size:16px;">'' + lowerRows[r].Total + ''</td>''+''<td></td>'';
                                }
                                else if( r == lowerRows.length-5 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td></td>'';
                                }
                                else if ( r == lowerRows.length-10 )
                                {
                                   LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td></td>'';                                
                                }
                                else
                                {
                                   LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].MTS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].STS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td></td>'';                                    
                                }
                                
                            }
                            else
                            {
                                if( r == lowerRows.length-2 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'';
                                }
                                else if( r == lowerRows.length-5 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'';
                                }
                                else if ( r == lowerRows.length-10 )
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px"  bgcolor="#b3d9ff">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'';
                                }
                                else
                                {
                                    LrowData = ''<td style="padding:5px">'' + lowerRows[r].ResponseCategory + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].Status + ''</td>'' + ''<td style="padding:5px">'' + lowerRows[r].TA + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].TS + ''</td>''+''<td style="padding:5px">'' + lowerRows[r].Total + ''</td>''+''<td style="padding:5px"> </td>''+''<td></td>'';
                                }
                        
                            }
                                tableContent3 = tableContent3 + rowSL + LrowData + rowEL;
                        
                       }
                          
                        var htmlTable = tableStart + tableContent + tableContent2 + tableContent3 + tableEnd;
                }
                             htmlTables = htmlTables + htmlTable;
                        }

                    }
                   
                    var exportData = response;
                    CloverApp.API.setDataField(''HTMLTable'',htmlTables);
                    CloverApp.API.setDataField(''exportData'', exportData);
                    CloverApp.API.setDataField(''ddlData'',exportData);
                    CloverApp.API.setDataField(''btnSearch'', true);
                    var ddlRewrite = function (model) {
                        model[''data-elements''] = _getNumOfWeeks(totweeks);
                    }
                    CloverApp.API.rewriteControlModel("ddlWeek", ddlRewrite);
                    _removeElement(_hideControls, ''ddlWeek'');
                    
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
                        
               } else {
                    alertify.error( Utils.encodeHTML(response.message) );
                }

            })
           .catch(error => {
               alertify.error( Utils.encodeHTML(error.message) );
            });
    };
  },
  
   onExport : function(args){
      
      
      
                     var exportData = args.data.exportData;
                     var Length = exportData.count;
                     var weeks = args.data.ddlWeek;
    
                    var active = exportData.Active;
                    var LowerTable = exportData.LowerTable;
                    var UpperTable = exportData.UpperTable;
                     var LowerRows;
                     var MiddleRows;
                     var UpperRows;
                   var weeksVal;
                   if(weeks !== null && weeks !== undefined)
                   {
                        weeksVal = Object.keys(weeks).length;
                   }
                     if(weeks === null || weeks === undefined || weeksVal === 0 )
                    {
                             LowerRows = LowerTable[Length];
                             MiddleRows = active[Length];
                             UpperRows = UpperTable[Length];
             
                            var objArray; 
                            var str = '' '';
             
                            var UTable = UpperRows.concat(MiddleRows);
                            objArray = UTable.concat(LowerRows);
              
               
              
                            var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                         
                          
                          for (var n = 0; n< array.length; n++)
                          {
                              var line = '' '';
                              
                              for (var index in array[n])
                              {
                                  line += '' ''+ array[n][index] + '','';
                                  
                              }
                              
                              line.slice(0,line.length-1);
                              str += line + ''\r\n'';
                          }
              
            
                            var surveyType = args.data.ddlSurveyType;
                            var filename = "IMDADailyResponseReport_"+surveyType+"_Week"+ Length ;
                   
                             var downloadLink = document.createElement("a");
                             var blob = new Blob(["\ufeff",str]);
                             var url = URL.createObjectURL(blob);
                            downloadLink.href = url;
                            downloadLink.download = filename+".csv"; 
                            document.body.appendChild(downloadLink);
                            downloadLink.click();
                            document.body.removeChild(downloadLink);
      
                           
                           
                       }
                    else
                    {
                            var weekFilterCount = Object.keys(weeks).length;
                            
                           for (var z = 0 ; z < weekFilterCount; z++)
                           {
                           
                               
                                var filterWeek = weeks[z];
                               
                                 UpperRows = UpperTable[filterWeek];
                                 MiddleRows = active[filterWeek];
                                 LowerRows = LowerTable[filterWeek];
                                  var objArray; 
                            var str = '' '';
             
                            var FilterTable = UpperRows.concat(MiddleRows);
                            objArray = FilterTable.concat(LowerRows);
              
               
              
                            var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                         
                          
                          for (var n = 0; n< array.length; n++)
                          {
                              var line = '' '';
                              
                              for (var index in array[n])
                              {
                                  line += '' ''+ array[n][index] + '','';
                                  
                              }
                              
                              line.slice(0,line.length-1);
                              str += line + ''\r\n'';
                          }
              
                            var surveyType = args.data.ddlSurveyType;
                            var filename = "IMDADailyResponseReport_"+surveyType+"_Week"+ filterWeek ;
                             var downloadLink = document.createElement("a");
                             var blob = new Blob(["\ufeff",str]);
                             var url = URL.createObjectURL(blob);
                            downloadLink.href = url;
                            downloadLink.download = filename+".csv"; 
                            document.body.appendChild(downloadLink);
                            downloadLink.click();
                            document.body.removeChild(downloadLink);
          
                           }
                           
                       }
                   
  },
  
   onChange : function(args){
       
     CloverApp.API.setDataField("ddlWeek",[]); 
            var ddlRewrite = function (model) {
                  
                            model[''data-elements''] = 0;
                        }
          
          CloverApp.API.setDataField(''btnSearch'',undefined);
          CloverApp.API.rewriteControlModel("ddlWeek",ddlRewrite); 
          //CloverApp.API.setDataField("ddlWeek",false);
          CloverApp.API.setDataField("ddlSurveyType", []);
          CloverApp.API.setDataField(''HTMLTable'','' '');

               
       
   },
   
   
   
   
   btnCSV : function(args){
    
                     var exportData = args.data.exportData;
                     var Length = exportData.count;
                     var weeks = args.data.ddlWeek;
    
                     var active = exportData.Active;
                     var LowerTable = exportData.LowerTable;
                     var UpperTable = exportData.UpperTable;
                     var LowerRows;
                     var MiddleRows;
                     var UpperRows;
                     
                        if(weeks !== null && weeks !== undefined)
                   
                   {
                        weeksVal = Object.keys(weeks).length;
                   }
               
                   if(weeks === null || weeks === undefined || weeksVal === 0 )
                   
                   
                   {
                         LowerRows = LowerTable[Length];
                         MiddleRows = active[Length];
                         UpperRows = UpperTable[Length];
         
                        var objArray; 
                        var str = '' '';
         
                        var UTable = UpperRows.concat(MiddleRows);
                        objArray = UTable.concat(LowerRows);
          
           
          
                        var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                     
                      
                      for (var n = 0; n< array.length; n++)
                      {
                          var line = '' '';
                          
                          for (var index in array[n])
                          {
                              line += '' ''+ array[n][index] + '','';
                              
                          }
                          
                          line.slice(0,line.length-1);
                          str += line + ''\r\n'';
                      }
          
        
                        var surveyType = args.data.ddlSurveyType;
                        var filename = "IMDADailyResponseReport_"+surveyType+"_Week"+ Length ;
               
                         var downloadLink = document.createElement("a");
                         var blob = new Blob(["\ufeff",str]);
                         var url = URL.createObjectURL(blob);
                        downloadLink.href = url;
                        downloadLink.download = filename+".csv"; 
                        document.body.appendChild(downloadLink);
                        downloadLink.click();
                        document.body.removeChild(downloadLink);
  
                   }
                   
                   
                else
                   {
                        var weekFilterCount = Object.keys(weeks).length;
                        
                       
                          
                        var objArray1 = []; //array
                        var str = '' '';
                        
                        for (var z = 0 ; z < weekFilterCount; z++)
                       {
                       
                           
                         var filterWeek = weeks[z];
                           
                         UpperRows = UpperTable[filterWeek];
                         MiddleRows = active[filterWeek];
                         LowerRows = LowerTable[filterWeek];
         
                         var FilterTable = UpperRows.concat(MiddleRows);
                         second = FilterTable.concat(LowerRows);
                         
                         objArray1.push(second);
                         
                         
          
                       }
                       
                        var objArray = [];
                       for (let l = 0 ; l < objArray1.length ; l++)
                       {
                            objArray = objArray.concat(objArray1[l]);
                       }
          
                      var array = typeof objArray != ''object'' ? JSON.parse(objArray) : objArray;
                      for (var n = 0; n< array.length; n++)
                      {
                          var line = '' '';
                          
                          for (var index in array[n])
                          {
                              line += '' ''+ array[n][index] + '','';
                              
                          }
                          
                          line.slice(0,line.length-1);
                          str += line + ''\r\n'';
                      }
          
                        var surveyType = args.data.ddlSurveyType;
                        var filename = "IMDADailyResponseReport_"+surveyType+"_Week"+ filterWeek ;
                         var downloadLink = document.createElement("a");
                         var blob = new Blob(["\ufeff",str]);
                         var url = URL.createObjectURL(blob);
                        downloadLink.href = url;
                        downloadLink.download = filename+".csv"; 
                        document.body.appendChild(downloadLink);
                        downloadLink.click();
                        document.body.removeChild(downloadLink);
      
                       }
                       

  },
  
  
}

' WHERE [Id]='057924ab-2b2b-4f40-a90a-28506e9c12ce';

UPDATE [dwMetadata] SET
[Id]='d046330a-51b1-40e2-bdea-fba77e12c3be', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'ShortLink-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-10-20 14:32:54.637', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-16 19:15:18.727', 
[Data]=N'{
    init: function(args) {
        console.log("args to init",args);
        shortlinkUserActions.updateFormChoices(args);
        shortlinkUserActions.getShortLinkQrCode(args);
    },
    
    updateFormChoices: function(args) {
        const dplyId = args.data.DplyId;
        const formName = args.data.FormName;
        
        if(dplyId) {
            Utils.loadingStart();
            Utils.getRequest("/deployment/getForms", { dplyId }).then(
                response => {
                    const forms = response.item;
                    const items = [];
                    for(const form of forms) {
                        items.push( {
                           key: form.Id,
                           text: form.Name + " / " + form.Language,
                           value: form.Name,
                        });
                    }
                    Utils.rewriteDropdown("FormName",items, formName);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        } else {
            Utils.rewriteDropdown("FormName",[]);
        }
        
        
    },
    
    cleanup: function(args) {
        const data = args.data;
        
        if(data.LinkType=="Anonymous") {
            CloverApp.API.setDataField("Url",null);
        } else {
            CloverApp.API.setDataField("DplyId",null);
        }
      
        
    },
    
    getShortLinkQrCode: function (args){
        const id =  args.data.Id;
        if(id==null) {
            console.log("Not saved yet", id);
            CloverApp.API.setDataField("shortLinkQrCode", "");
            return {};
        }
        
        const iconClass = "copy outline icon";
        const iconBtnClass = "ui icon button mini secondary";
        let htmlLink = "";
        Utils.loadingStart();
        Utils.getRequest("/shortlink/info",{id}).then(
            response => {
                console.log("response",response);
                const item = response.item;
                    
                //html here is based on the anonymous qr html used in qnn_dply
                htmlLink += ''<div><i style="display:block;margin-bottom:14px;">Click the copy button to get Short Link URL:</i>'';
    
                const iconBtn = 
                     ''<button id="btnCopy-shortlink" name="btnCopy-shortlink" title="Copy" data-link-id="shortLink" class="''
                     +iconBtnClass+''"><i data-link-id="shortLink" class="''+iconClass+''" ariahidden="true"></i></button>'';
                const urlText = ''<span id="shortlinkText" style="display:none;">''+item.url +''</span>'';
                const headerDiv = ''<div style="margin:18px 18px 0px 18px; word-break: break-word;">''+iconBtn +'' '' +urlText+''</div>'';
                const qrCodeImg = ''<img style="display:block; margin-left:auto; margin-right:auto; margin-bottom:9px; width:200px; height:200px" src="data:image/png;base64,'' + item.qrCode +''"  alt="''+item.url+''"/>'';
                const linkItem = ''<div style="width:210px;margin-bottom:14px;margin-right:14px;float:left;border:1px solid rgba(34, 36, 38, 0.15);">''+ headerDiv + qrCodeImg + ''</div>'';
                htmlLink += linkItem;
                
                htmlLink += "</div>"
                
                CloverApp.API.setDataField("shortLinkQrCode", htmlLink);
                
                //Due to security issue does not allow "unsafe inline", bind separately (but will only be one here)
                document.getElementsByName("btnCopy-shortlink").forEach(function(btn){
                   btn.addEventListener("click",function(e){
                       e.preventDefault();
                       navigator.clipboard.writeText(item.url);
                       alertify.success( Utils.encodeHTML("Copied to clipboard: " + item.url) );
                   })
                });
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML("Failed to load QR Code: " +  reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
}' WHERE [Id]='d046330a-51b1-40e2-bdea-fba77e12c3be';

UPDATE [dwMetadata] SET
[Id]='0694e109-8d21-462a-bb2c-f5af6735ea95', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SurveyResponseReport-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2020-01-16 10:49:42.977', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 00:09:51.987', 
[Data]=N'{
    
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

' WHERE [Id]='0694e109-8d21-462a-bb2c-f5af6735ea95';

UPDATE [dwMetadata] SET
[Id]='4d440057-891c-4fe7-aa60-47b67638b311', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzDplyList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.280', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 00:18:03.560', 
[Data]=N'{
    init: function (args) {
        const isDataOwner = CloverApp.API.checkRole("DataOwner");
        
        //used by button rendere by respCOuntFormatter and actionsFormatter
        const prepareExport = function (baseUrl, dplyId) {
            Utils.loadingStart();
            Utils.postFormRequest(baseUrl + encodeURIComponent(dplyId)).then(
                response => {
                    alertify.success( Utils.encodeHTML(response.message), 20000);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason), 20000);
                }
            ).finally(Utils.loadingStop);
        };
        
        const respCountFormatter = function (p) {
            const dplyId = p.row.Id;
            const hasAnyResponses = p.row.RespCount > 0;
            return CloverApp.API.createElement(
                "button", 
                {
                    style: {
                        width: "100%",
                        color: (hasAnyResponses ? "black" : "red"),
                    },
                    onClick: hasAnyResponses
                        ? isDataOwner 
                            ? ((e)=>{e.stopPropagation(); prepareExport("/deployment/exportresponse/prepare/",dplyId);}) 
                            : ((e)=>{e.stopPropagation(); alertify.error("You need DataOwner role to export the responses",10000);})
                        : ((e)=>{e.stopPropagation(); alertify.error("This deployment has no responses yet",10000);}),
                    className: "small ui button secondary invert",
                }, 
                p.row.RespCount + " / " + p.row.SampleCount);
        }; //end of respCountFormatter
                
        const actionsFormatter = function (p) {
            const dplyId = p.row.Id;
            const hasAnyResponses = p.row.RespCount > 0;
            if(!hasAnyResponses || !isDataOwner) {
                return CloverApp.API.createElement("div", {}, "");
            } else {
                return CloverApp.API.createElement(
                    "button", 
                    {
                        style: {
                            width: "100%",
                            color: "black",
                        },
                        onClick: isDataOwner
                            ? ((e)=> {e.stopPropagation(); prepareExport("/deployment/exportuploadedfiles/prepare/", dplyId)})
                            : ((e)=>{e.stopPropagation(); alertify.error("You need DataOwner role to export the respondent uploaded files",10000)}),
                        className: "small ui button secondary invert",
                    }, 
                    "Export Files"); 
            }
        }; //end of actionsFormatter     
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();
            if(tags.length > 3) {
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: tags, className:"react-grid-Cell-Comments"}, tagsLabel); 
        }; //end of tagsColumnFormatter
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                
                //index columns by name for convenience
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }); 
                cols.RespCount.customFormatter = respCountFormatter;
                cols.Action.customFormatter = actionsFormatter;          
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        }; //end of gridModelRewriter

        var activateDeploymentAsync = function (args, id) {
            
            if(!$(''#''+id).is('':checked'')){
                $(''#''+id).prop(''checked'', true);
                args.controlRef.refs.swzmodalNotAllowed.props.swzData.isOpen = true;
                args.controlRef.refs.swzmodalNotAllowed.openModal();
            }
            else{
                $(''#''+id).prop(''checked'', false);
                args.state.app.extra.dplyId = id;
                args.controlRef.refs.confirmModal.props.swzData.isOpen = true;
                args.controlRef.refs.confirmModal.openModal();
            }
  
            return {};
        };

        var showModal = function (args, id) {

            return activateDeploymentAsync(args, id);

        };

        CloverApp.API.rewriteControlModel("gridview_1", gridModelRewriter);

        return {};
    }, //end of init
    
    closeModal: function (args){
        //console.log("closeModal args:", args);
        args.component.refs.swzmodalNotAllowed.close();
    },


    activateDeployment: function (args) {
        
        var changeStatusAsync = function (id) {
            var formData = new FormData();
            formData.append(''id'', id);
            var url = ''/deployment/activate'';
            fetch(url,
                {
                    credentials: ''same-origin'',
                    contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                    method: ''post'',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    if (response.success) {
                        alertify.success( Utils.encodeHTML(response.message) );
                         $(''#''+id).prop(''checked'', true);

                    } else {
                        alertify.error( Utils.encodeHTML(response.message) );
                    }
                })
                .catch(error => {
                    alertify.error( Utils.encodeHTML(error.message) );
                });
                 args.component.refs.confirmModal.close();


        };
        console.log("activateDeployment args:", args);
        let id =  args.state.app.extra.dplyId;
        $(''#''+id).prop(''checked'', false);   
        changeStatusAsync(id);
        return {


        };

    },
    
    updateFilter: function(args) {
        console.log("args to updateFilter", args);
        const data = args.data;
        
        const search = data.FilterSearch ? data.FilterSearch : null;
        const filterAnonymousType = data.FilterAnonymous ? data.FilterAnonymous : "AllAnonymous";
        const filterMultipleType = data.FilterMultiple ? data.FilterMultiple : "AllMultiple";
        const filterRecurrenceType = data.FilterRecurrenceType ? data.FilterRecurrenceType : "AllRecurrenceType";
        
        const filter = [];
        if(search) {
            filter.push({
               column: "Name, QnnTitle, QnnType, ListName, Tags, CreatedDate",
               nextValue: search,
               term: "like",
               value: search,
            });
        }
        if("AllAnonymous" != filterAnonymousType) {
            filter.push({
               column: "IsAnonymous",
               nextValue: filterAnonymousType,
               term: "=",
               value: filterAnonymousType,
            });
        }
        if("AllMultiple" != filterMultipleType) {
            filter.push({
               column: "IsMultipleResponse",
               nextValue: filterMultipleType,
               term: "=",
               value: filterMultipleType,
            });
        }
        if("AllRecurrenceType" != filterRecurrenceType) {
            if(filterRecurrenceType=="IR") {
                filter.push({
                    column: "RecurrenceType",
                    nextValue: ["I","R"],
                    term: "IN",
                    value: ["I","R"],
                });
            } else {
                filter.push({
                    column: "RecurrenceType",
                    nextValue: filterRecurrenceType,
                    term: "=",
                    value: filterRecurrenceType,
                });
            }
        }
        
        const delta = {
            app: {
                form: {
                    filters: {
                        main: {
                            gridview_1: filter,
                        }
                    }
                }
            }    
        };
        console.log("delta", delta, "filter", filter);
        return delta;
    },
    
    test: function(args,foo,bar) {
        console.log(args,foo,bar);
    },
}
' WHERE [Id]='4d440057-891c-4fe7-aa60-47b67638b311';

UPDATE [dwMetadata] SET
[Id]='2be1956f-f237-4c65-b9bc-d216eb524f0d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailer-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-19 15:24:14.453', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 01:13:42.313', 
[Data]=N'{
    init: function(args){
        CloverApp.API.setDataField("UserStructId", args.state.app.user.structDivisionId);
    },
    
    createEmail: function(args){
        console.log("resend args", args);

        const organization = args.data.organization;
        const target = args.data.target;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContent = args.component.refs.htmlEditor.state.htmlData;
        const msgContentJson = JSON.stringify(args.component.refs.htmlEditor.state.jsonData);
        const subject = args.data.subject;
        const status = args.data.dictionaryStatus ? args.data.dictionaryStatus : "";
        
        let validated = true;
        
        if(organization==undefined || organization==null || organization.length==0){
            alertify.error("Organization is required");
            validated = false;
        }
        
        if(target==undefined || target==null || target.length==0){
            alertify.error("Target is required");
            validated = false;
        } else if(target=="activeSamples" && status.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent.length==0){
            alertify.error("Email content is required");
            validated = false;
        }

        if(!validated){
            return {};
        }

        const formData = new FormData();
        formData.append(''organization'', organization);
        formData.append(''target'', target);
        formData.append(''status'', status);
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom ? emailFrom : "");
        formData.append(''scheduledDate'', scheduledDate);
        
        Utils.loadingStart();
        Utils.postFormRequest("/globalmailer/email", formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                    alertify.success( Utils.encodeHTML(response.message) );
                    args.controlRef.refresh();
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally( Utils.loadingStop );
  
    },
    
    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
}' WHERE [Id]='2be1956f-f237-4c65-b9bc-d216eb524f0d';

UPDATE [dwMetadata] SET
[Id]='17fd460f-81b6-4cb6-9ccd-778ab927441c', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzGlobalMailerMessage-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-25 22:13:14.040', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 01:19:27.860', 
[Data]=N'{
    init: function(args){
        if(args.data.ScheduledDate)
            args.data.ScheduledDate = dayjs(new Date(args.data.ScheduledDate)).format(''DD MMM YYYY HH:mm'')
        if(args.data.StatusCollection.length > 0){
            args.data.StatusCollection.forEach(
                (entry) => {
                    //var element = CloverApp.API.createElement("a", {className: "ui label"}, entry.ForStatus_Title);
                    $("p[name=''status'']").append("<a class=''ui label''>" + entry.ForStatus_Title + "</a>");
                });
        }
        
        console.log(args);
    },
    
    cancelJob: function(args){
        const formData = new FormData();
        formData.append(''globalMsgId'', args.data.Id);
        Utils.loadingStart("Cancelling mail job");
        Utils.postFormRequest("/globalmailer/canceljob", formData).then(
            response => {
                alertify.success( Utils.encodeHTML(response.message) );
                Utils.queueHideControl("cancelJob");
                Utils.queueHideControl("swzmodal_2");
            }, reason => {
                alertify.error( Utils.encodeHTML(reason) );
                console.log("cancelJob error", reason);
            }
        ).finally(Utils.loadingStop);
    },
    
    editEmail: function(args){
        
        const globalMsgId = args.data.Id;
        const organization = args.data.organization;
        const target = args.data.target;
        const emailFrom = args.data.emailFrom;
        const scheduledDate = args.data.scheduledDate;
        const msgContentJson = args.data.msgContentJson ? args.data.msgContentJson : args.data.MsgContentJson;
        const msgContent = args.data.msgContent ? args.data.msgContent : args.data.MsgContent;
        const subject = args.data.emailSubj;
        const status = args.data.dictionaryStatus ? target=="intranetUsers" ? "" :  args.data.dictionaryStatus : "";
        
        let validated = true;
        if(organization==undefined || organization==null || organization.length==0){
            alertify.error("Organization is required");
            validated = false;
        }
        
        if(target==undefined || target==null || target.length==0){
            alertify.error("Target is required");
            validated = false;
        } else if(target=="activeSamples" && status.length==0){
            alertify.error("Status is required");
            validated = false;
        }
        
        if(subject==undefined || subject==null || subject.length==0){
            alertify.error("Email subject is required");
            validated = false;
        }
        
        if(scheduledDate==undefined || scheduledDate==null){
            alertify.error("Start From is required");
            validated = false;
        }
        
        if(msgContent==undefined || msgContent==null || msgContentJson==undefined || msgContentJson==null){
            alertify.error("Email content is required");
            validated = false;
        }

        if(!validated){
            $(''body'').loadingModal(''destroy'');
            return {};
        }

        const formData = new FormData();
        formData.append(''organization'', organization);
        formData.append(''target'', target);
        formData.append(''msgContent'', msgContent);
        formData.append(''msgContentJson'', msgContentJson);
        formData.append(''globalMsgId'', globalMsgId);
        formData.append(''subject'', subject);
        formData.append(''emailFrom'', emailFrom);
        formData.append(''scheduledDate'', scheduledDate);  
        formData.append(''status'', status);
        
        Utils.loadingStart();
        Utils.postFormRequest("/globalmailer/email", formData).then(
            response => {
                args.component.refs.swzmodal_2.close();
                alertify.success("Message updated");
                const reloadUrl = "/form/SwzGlobalMailerMessage/" + encodeURIComponent(globalMsgId);
                window.setTimeout( () => window.location=reloadUrl, 500); //hard reload
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    }, //end of editEmail
    

    closeModal: function(args) {
        const modal = args.controlRef;
        modal.close();
    },
    
    onEditClick: function (args) {
        var statuslist = [];
        if(args.data.StatusCollection.length > 0){
            CloverApp.API.setDataField("target","activeSamples");
            args.data.StatusCollection.forEach(
                (entry) => {
                    statuslist.push(entry.ForStatus);
                });
        }
        CloverApp.API.setDataField("dictionaryStatus",statuslist);
        CloverApp.API.setDataField("msgContentEditor",args.data.MsgContentJson);
        CloverApp.API.setDataField("emailFrom",args.data.EmailFrom);
        CloverApp.API.setDataField("emailSubj",args.data.EmailSubj);
        CloverApp.API.setDataField("scheduledDate",args.data.ScheduledDate);
        CloverApp.API.setDataField("organization",args.data.StructDivisionId);
        CloverApp.API.setDataField("target",args.data.IsTargetUsers ? "intranetUsers" : "activeSamples" );
        return { 
            app:{}
        }
    },
    
    onHtmlChange: function (args){
        var contentDataJson =  JSON.stringify(args.component.refs.msgContentEditor.state.jsonData);
        var contentData =  args.component.refs.msgContentEditor.state.htmlData;
        return { 
            app:{
                form: {
                    data:{
                        modified:{
                            msgContentJson: contentDataJson,
                            msgContent: contentData
                        }
                    }
                }
            }
        }
    },
}' WHERE [Id]='17fd460f-81b6-4cb6-9ccd-778ab927441c';

UPDATE [dwMetadata] SET
[Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8', [StructDivisionId]=NULL, 
[Folder]=N'metadata/forms', [FileName]=N'SwzListList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.420', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 01:26:56.883', 
[Data]=N'{
    init: function(args) {
        console.log("args to init", args);
        const innerArgs = args;
        const hasEditPermission = CloverApp.API.checkPermission("Edit");
        console.log("hasEditPermission", hasEditPermission);
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("newSampleListName", "");
            CloverApp.API.setDataField("copySampleListId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            if(hasEditPermission) {
                return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
            } else {
                return null;
            }
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_LIST'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 3){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Name.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("grid", gridModelRewriter);
    }, //end of int
    
    //called by Copy button in modal
    copySampleList: function(args) {
        const data = args.data;
        const id = data.copySampleListId;
        const title = (data.newSampleListName===undefined) ? "" : data.newSampleListName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("sampleListId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating SampleList");
        Utils.postFormRequest("/list/duplicate", formData).then(
            result => {
                args.component.refs.grid.refresh();
                args.component.refs.copyModal.close();
                alertify.success( Utils.encodeHTML("Created " + title) );
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    }, //end of copySampleList
    
    viewArgs: function (args){
        console.log("View", args);
    },
    
    submitFile(args){
        var token = args.data.listFile;
        var listName = args.data.listName;
        
        var errors = {};
        if (!listName){
            errors.listName = ''Please enter list name'';
        }
        if(!token){
            errors.listFile = ''Please select csv file'';
        }
        
        if(errors.listName || errors.listFile){
            alertify.error(''List name or file cannot be empty'');
            throw {
                level: 1,
                //message: ''List name or file cannot be empty'',
                formerrors: {main: errors}
            };
          
          return {};
        }      
        
        Utils.loadingStart("Importing...");
        const formData = new FormData();
        formData.append("token", token);
        formData.append("listName", listName);
        Utils.postFormRequest("/list/importnew", formData).then(
            response => {
                CloverApp.API.setDataField("listFile", null);
                CloverApp.API.setDataField("listName", null);
                args.component.refs.importModal.close();
                args.component.refs.grid.refresh();
                alertify.success( Utils.response.message,10000);
            }, reason => {
                CloverApp.API.setDataField("listFile", null);
                alertify.error( Utils.encodeHTML(reason), 15000);
            }
        ).finally( Utils.loadingStop );
    }, 
    
    closeModal: function (args){
        CloverApp.API.setDataField("listFile", null);
        CloverApp.API.setDataField("listName", null);
        args.component.refs.importModal.close();
        return {
            app: {
              form: {
                  data: {
                      modified: {
                          inputImportListSample:null,
                          inputPassword:null,
                          listFile:null,
                          listName:null,
                          listSampleAddedCount:null,
                          listSampleUpdatedCount:null,
                          gridviewImportSummary:null
                          
                      }
                  },
                  models:{
                      hideControls: [''importSummaryStatic'',''sampleListImportHeader'',''btnImportClose'',''containerInvalidDetails'']
                  }
              }
            }
        }       
    },
    
    closeCopyModal: function(args) {
        args.controlRef.close();  
    },
}' WHERE [Id]='ffca2d82-5e02-4ad0-9a7c-764a6df7d0a8';

UPDATE [dwMetadata] SET
[Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzQnnList-code.js', [IsDeleted]=0, 
[CreatedBy]='540e514c-911f-4a03-ac90-c450c28838c5', [CreatedDate]='2019-03-28 21:49:25.607', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 01:31:34.147', 
[Data]=N'{
    init: function(args) {
        const innerArgs = args;
        
        const showCopyModal = function (args, id) {
            CloverApp.API.setDataField("NewQnnName", "");
            CloverApp.API.setDataField("CopyQnnId", id);
            args.controlRef.refs.copyModal.props.swzData.isOpen = true;
            args.controlRef.refs.copyModal.openModal();
        };
        
        const copyFormatter = function (p) {
            return CloverApp.API.createElement("button", { 
                onClick: () => showCopyModal(innerArgs, p.row.Id), 
                className: "ui button secondary invert" }, 
                "Copy");
        };
        
        const nameFormatter = function (p) {
            return CloverApp.API.createElement("span", { onClick: () =>  {
                            CloverApp.API.redirect(''form'', ''QNN_QNN'', p.row.Id)
                        }, className: "link-style" }, p.value);
        };
        
        const tagsColumnFormatter = function (p){
            if(p.row.Tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.Tags);
            let tagsLabel = new Array();

            if(tags.length > 3){
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags, className:"ui label small"}, tags.length));
            } else {
                for(x=0;x<tags.length;x++) {
                    tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
                }
            }
            return CloverApp.API.createElement("div", {title: "", className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                //index columns by name
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} );
                
                cols.Actions.customFormatter = copyFormatter;
                cols.Title.customFormatter = nameFormatter;
                cols.Tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        };
        
      return CloverApp.API.rewriteControlModel("gridQnn", gridModelRewriter);

    },
    
    //called by Copy button in modal
    copyQnn: function(args) {
        const data = args.data;
        const id = data.CopyQnnId;
        const title = (data.NewQnnName===undefined) ? "" : data.NewQnnName.trim();
        if(title === ""){
            alertify.error("Please specify a name");
            return {};
        }
        
        const formData = new FormData();
        formData.append("qnnId", id);
        formData.append("title", title);
        Utils.loadingStart("Duplicating Questionnaire");
        Utils.postFormRequest("/qnn/duplicate", formData).then(
            result => {
                args.component.refs.gridQnn.refresh();
                args.component.refs.copyModal.close();
                alertify.success( Utils.encodeHTML("Created " + title) );
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
        return {};
    },
    
    closeModal: function(args) {
        args.controlRef.close();  
    },
}





' WHERE [Id]='40cc065e-63ce-482a-b1ea-4766b3b5be3d';

UPDATE [dwMetadata] SET
[Id]='d6d4a9c0-8e4b-4142-91a3-aede215ba6d3', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'SwzTags-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-11-17 10:12:22.957', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 01:35:51.507', 
[Data]=N'{
    init: function(args){
        //Grid init
        const gridModelRewriter = function (model) {
            if (Array.isArray(model.columns)) {
                const cols = model.columns.reduce((idx, column) => {
                    if(column.key) { idx[column.key] = column; }
                    return idx;
                }, {} ); 
                cols.name.customFormatter = nameColumnFormatter;
                cols.tags.customFormatter = tagsColumnFormatter;
            }
            return model;
        }; 
        
        const tagsColumnFormatter = function (p){
            if(p.row.tags == null) {
                return CloverApp.API.createElement("div", {title: "", className:""}, ""); 
            }
            let tags = JSON.parse(p.row.tags);
            let tagsLabel = new Array();
            for(x=0;x<tags.length;x++) {
                tagsLabel.push(CloverApp.API.createElement("label", {title: tags[x], className:"ui label small"}, tags[x]));
            }
            return CloverApp.API.createElement("div", {title: tags, className:"react-grid-Cell-Comments"}, tagsLabel); 
        };
        
        const nameColumnFormatter = function (p) {
            let source = p.row.sourceTable;
            let name = p.row.name;
            let url;
            switch (source) {
                case "Deployment" :
                    url = "/form/QNN_DPLY/";
                    break;
                case "List" :
                    url = "/form/QNN_LIST/";
                    break;
                case "Form" :
                    url = "/form/QNN_QNN/";
                    break;
            }
            url = url + p.row.id;
            
            const onClickGoTo = () => { window.location = url };
            return CloverApp.API.createElement("span", { onClick: onClickGoTo, className: "link-style" }, name);
        };
        CloverApp.API.rewriteControlModel("gvTags", gridModelRewriter);
        //Grid init End
        
        //Get tags from session storage
        let tagsName = sessionStorage.getItem("tagsName");
        tagsName = tagsName == null ? "" : tagsName;
        sessionStorage.clear();
        
        if(tagsName !== "") {
            CloverApp.API.setDataField("TagsInSearch", tagsName);
        }
        tagsName = JSON.stringify(new Array(tagsName));
        swztagsUserActions.getTagsData(args,tagsName);
        swztagsUserActions.getPopularTags();
    },
    
    getPopularTags: function(){
        try{
            let NumberOfUniqueTagsShows = 10;
            Utils.loadingStart();
            Utils.getRequest("/tags/getActiveTags?number=" + encodeURIComponent(NumberOfUniqueTagsShows))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        swztagsUserActions.rewriteSearchedTags(result);
                    }
                }, reason => {
                    switch(reason) {
                      case ''TAGS_NOT_FOUND'':
                        swztagsUserActions.rewriteSearchedTags('''');
                        break;
                      default:
                        console.error(reason);
                        alertify.error( Utils.encodeHTML(reason) );
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTags: function(args){
        let tagsSelected = args.data.TagsInSearch;
        let tagsSelectedName = new Array();
        if(tagsSelected!== null){
            tagsSelectedName = JSON.stringify(tagsSelected);
            swztagsUserActions.getTagsData(args,tagsSelectedName);
        }
    },
    
    getTagsData: function(args, tagsSelectedName) {
        try{
            Utils.loadingStart();
            Utils.getRequest("/tags/tagsPanelSearch?tagsSelectedName=" + encodeURIComponent(tagsSelectedName))
            .then(response => {
                    if(response.success && response.item !== null) {
                        //Write to GRID
                        CloverApp.API.setDataField("gvTags", response.item);
                        args.component.refs.gvTags.refresh();
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        alertify.error("Tags not found");
                        CloverApp.API.setDataField("gvTags", null);
                        args.component.refs.gvTags.refresh();
                    } else {
                        alertify.error( Utils.encodeHTML(reason) );
                    }
            }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    searchTagsInDB:function(args){
        try{
            let tagsToSearch = JSON.stringify(args.data.TagsToSearch);
            let tagsInSearch = args.data.TagsInSearch;
            Utils.loadingStart();
            Utils.getRequest("/tags/searchTags?search=" + encodeURIComponent(tagsToSearch))
            .then(response => {
                    if(response.success && response.item !== null) {
                        var result = response.item;
                        let tagsPopular = result;
                        if(Array.isArray(tagsInSearch)){
                            tagsPopular = tagsPopular.filter(x => !tagsInSearch.includes(x));
                        }
                        swztagsUserActions.rewriteSearchedTags(tagsPopular);
                    }
                }, reason => {
                    if(reason == "TAGS_NOT_FOUND"){
                        swztagsUserActions.rewriteSearchedTags("");
                    } else {
                        alertify.error( Utils.encodeHTML(reason) );
                    }
                }
            ).finally(Utils.loadingStop);
        }catch(e){
            console.log(e);
        }
    },
    
    rewriteSearchedTags:function(tags){
        const divTagsSearch = function (model) {
            model.children.splice(2);
            if(tags.length == 0){
                var label = new Array();
                label[''content''] = "Tag Not Found...";
                label[''data-buildertype''] = "staticcontent";
                label[''key''] = "lblNotFound";
                model.children[2] = label;
            }
            for (x=0;x<tags.length;x++){
                var tag = window.globalUserActions.createSearchedTagsButton(tags[x]);
                model.children[x+2] = tag;
                if(x==9){
                    //show only 10 result
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearch", divTagsSearch);
        CloverApp.API.setDataField("divTagsSearch", null);
    },
    
    addTagToDropdown: function (args){
        var tagName = args.sourceControlRef.props.additionalParams.model.content;
        let tagsInSearch = args.data.TagsInSearch;
        
        if(tagsInSearch!=null){
            if(!tagsInSearch.includes(tagName)) {
                tagsInSearch.push(tagName);
                CloverApp.API.setDataField("TagsInSearch", tagsInSearch);
            }
        } else {
            CloverApp.API.setDataField("TagsInSearch", new Array(tagName));
            args.data.TagsInSearch = new Array(tagName);
        }
        args.component.refs.TagsInSearch.forceUpdate();
        swztagsUserActions.searchTags(args);
    },
    
    removeTagInDiv: function(args){
        var tagKeyName = args.sourceControlRef.props.name
        const divTagsSearch = function (model) {
            for(x=0;x<model.children.length;x++){
                if(model.children[x].key == tagKeyName) {
                    model.children.splice(x, 1);
                    break;
                }
            }
            return model;
        };
        CloverApp.API.rewriteControlModel("divTagsSearch", divTagsSearch);
        CloverApp.API.setDataField("divTagsSearch", null);
    },
    
}' WHERE [Id]='d6d4a9c0-8e4b-4142-91a3-aede215ba6d3';

UPDATE [dwMetadata] SET
[Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'UserAccessMatrix-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2021-07-26 15:58:32.583', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 01:39:42.157', 
[Data]=N'{
    init: function(args){
        const initialAspect = "Role";
        Utils.loadingStart();
        Utils.getRequest("/report/useraccessmatrix/options").then(
            response => {
                Utils.rewriteDropdown("Aspect", response.item, initialAspect);
                args.data.Aspect = initialAspect; //make available in onChangeAspect
                useraccessmatrixUserActions.onChangeAspect(args);
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    onChangeAspect: function(args){
        const aspect = args.data.Aspect;
        if(aspect === undefined || aspect === "")
            return;

        const formData = new FormData();
        formData.append(''aspect'', aspect);
        Utils.loadingStart();
        Utils.postFormRequest("/report/useraccessmatrix", formData).then(
            response => {
                const htmlOverall = ''<div class="field"><label>Result</label></div><div>'' + response.item + ''</div>''
                CloverApp.API.setDataField("result", htmlOverall);
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    onDownload: function(args){
        if(args.data.Aspect === undefined || args.data.Aspect === "")
            return;

        const formData = new FormData();
        formData.append(''aspect'', args.data.Aspect);   
        Utils.loadingStart();
        fetch("/report/useraccessmatrix/download", {
                credentials: ''same-origin'',
                contentType: ''application/x-www-form-urlencoded; charset=UTF-8'',
                method: ''post'',
                body: formData
            }
        ).then(
            response => response.blob()
        ).then(blob => {
            Utils.loadingStop();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement(''a'');
            a.href = url;
            a.download = ''User '' + args.data.Aspect + '' Access Matrix.pdf'';
            document.body.appendChild(a); // we need to append the element to the dom -> otherwise it will not work in firefox
            a.click();    
            a.remove();  //afterwards we remove the element again  
        })
        .catch(error => {
            Utils.loadingStop();
            console.error(error);
            alertify.error( Utils.encodeHTML(error.message) );
        });

    }
}' WHERE [Id]='1f5aea78-5462-4cd5-994e-87c233f0cdd6';

UPDATE [dwMetadata] SET
[Id]='811d2d21-9dcd-4182-8835-d11d471461b2', [StructDivisionId]='f6e34bdf-b769-42dd-a2be-fee67faf9045', 
[Folder]=N'metadata/forms', [FileName]=N'WordCloudReport-code.js', [IsDeleted]=0, 
[CreatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [CreatedDate]='2022-10-10 13:31:14.253', 
[DeletedBy]=NULL, [DeletedDate]=NULL, 
[UpdatedBy]='b9d69ba9-282b-d3d2-8f23-efc2596a082c', [UpdatedDate]='2024-03-17 01:43:24.373', 
[Data]=N'{
    getFields: function(args){
        
        CloverApp.API.setDataField("dplyId", null);
        CloverApp.API.setDataField("qnnField", null);
        CloverApp.API.setDataField("dropDown_wordCloudFields", null);
        Utils.loadingStart();
        Utils.getRequest("/report/wordcloudfields/" + encodeURIComponent(args.data.dictDeploymentId)).then(
            response => {
                if(response.success){
                    Utils.rewriteDropdown("dropDown_wordCloudFields", response.item, undefined);
                }
            }, reason => {
                Utils.rewriteDropdown("dropDown_wordCloudFields", null, undefined);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    genWordCloud: function(args){
        if(!args.data.dictDeploymentId || !args.data.dropDown_wordCloudFields){ 
            CloverApp.API.setDataField("dplyId", null);
            CloverApp.API.setDataField("qnnField", null);
            return;
        }
        CloverApp.API.setDataField("dplyId", args.data.dictDeploymentId);
        CloverApp.API.setDataField("qnnField", args.data.dropDown_wordCloudFields);

    }
}' WHERE [Id]='811d2d21-9dcd-4182-8835-d11d471461b2';

