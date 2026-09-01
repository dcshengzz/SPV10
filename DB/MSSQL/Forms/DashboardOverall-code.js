{
 
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
            $('body').loadingModal({
                text: 'Loading...',
                animation: 'foldingCube',
                backgroundColor: '#1262E2'
            });
        };
        
        var _loadingStop = function() {
            $('body').loadingModal('destroy');
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
            formData.append('dplyId', deployment);     
            var url = '/report/dashboard/overallresponse';
            
            return fetch(url,
                {
                    credentials: 'same-origin',
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    method: 'post',
                    body: formData
                })
                .then(response => response.json())
                .then(response => {
                    _loadingStop();
                    if (response.success) {
                        var items = response.items;
                        var totalActive = response.totalActive;
                        var totalSampleAftRemoval = response.totalSampleAftRemoval;
                        var editorLabel = ['Completed Response','Total Response'];
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
                        
                        var html = '';         
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
                                        
                                    var text = responseRate + '%';
                                        
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
                                    
                        var htmlOverall = '<div class="field"><label>Result</label></div><div class="swz-block">' + html + '</div>'
               
                        CloverApp.API.setDataField("result", htmlOverall);
                        CloverApp.API.setDataField("PieChart", value);
                        CloverApp.API.setDataField("response", response);
                        var _hideControls = args.state.app.form.models.hideControls;
                        _removeElement(_hideControls, "companyType");
                        _removeElement(_hideControls, "industryType");
                        
                        CloverApp.API.setDataField("onOverallResponse", true);
                        
                      /*  var companyTypeRewrite = function (model) {
                            model['data-elements'] = getCompanyTypes(qnType);
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
        var editorLabel = ['Completed Response','Total Response'];
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
        
        var html = '';         
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
                        
                        
                    var text = responseRate + '%';
                        
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
                    
        var htmlOverall = '<div class="field"><label>Result</label></div><div class="swz-block">' + html + '</div>'
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
}