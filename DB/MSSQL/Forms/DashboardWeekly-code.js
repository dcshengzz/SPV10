{
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
            $('body').loadingModal({
                text: 'Loading...',
                animation: 'foldingCube',
                backgroundColor: '#1262E2'
            });
        };
        
        var _loadingStop = function() {
            $('body').loadingModal('destroy');
        };
        
        var deployment = args.data.deployment;
        var dplyId = args.data.Id;
        var qnType = args.data.qnType;
        var companyType = args.data.companyType !== "" && args.data.companyType !== undefined ? args.data.companyType : [];
       
        return () => {
            _loadingStart();
            var formData = new FormData();
            formData.append('dplyId', deployment);
             if(companyType.length > 0)
                formData.append('filtersWeightGroup', companyType);
    
            var url = '/report/dashboard/weeklyresponse';     
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
                        var totalActive = response.totalActiveCompanies;
                        var totalSampleAftRemoval = response.totalSampleAftRemoval[0]['Number'];
                    
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
                            model['data-elements'] = getCompanyTypes(qnType);
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
                            model['data-elements'] = getCompanyTypes(qnType);
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
}