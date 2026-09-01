{
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
       
        var filters = args.data.filter !== "" && args.data.filter !== undefined ? args.data.filter : [];
        var filterType = "Segment";
        
        if(qnType == "II" || qnType == "MI")
            filterType = "Sector";
            
        return () => {
            _loadingStart();
            var formData = new FormData();
            formData.append('dplyId', deployment);
            formData.append('filterType', filterType);
            if(filters.length > 0)
                formData.append('filters', filters);
                
            if(companyType.length > 0)
                formData.append('filtersWeightGroup', companyType);
    
            var url = '/report/dashboard/sectorsegmentresponse';
            
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
                        var options = response.options;
                        var items = response.items;
                        
                        var tableStart =  '<table style="width:100%;text-align:center;border-collapse:inherit;border-radius:10px;background-color:rgba(230, 247, 255,0.1);" border="1" bordercolor="#808080" cellpadding="15"><tbody style="border-color:#cccccc;">';
                        var tableEnd = '</tbody></table>';
                        var tableContent = `<tr><td><h4>No response found.</h4></td></tr>`

                        var rowHeader = '<td></td>';
                        var rowS = '<tr>';
                        var rowE = '</tr>';
                        var tableKeys = response.tableKeys;
                        var keyOrderObj = {};
                        var i = 0;
                            
                        if(Object.keys(items).length > 0){
                            tableContent = '';
                            if(tableKeys !== undefined && tableKeys.length > 0){
                                while(i < tableKeys.length){
                                    keyOrderObj[tableKeys[i]] = i;
                                    rowHeader += `<td style="padding:5px;font-size:16px;width:20%;"><h4>` + tableKeys[i] + '</h4></td>'
                                    i++;
                                }
                            }
                            rowheader = rowS + rowHeader + rowE;
                            
                            for(var item in items){
                                
                                let rowS = '<tr>';
                                let rowE = '</tr>';
                                let firstColumn = '<td style="padding:5px;font-size:16px;width:20%;">' + item + '</td>'
                                var columnsData = '';
                        
                               if(Object.keys(items[item]).length === 0 && items[item].constructor === Object && Object.keys(items).length <= 1)
                                    firstColumn += `<tr><td><h4>No response found.</h4></td></tr>`;


                                var arr = [];
                                for(var wg in keyOrderObj){
                                    var obj = {};
                                    if(items[item][wg] !== undefined){
                                        obj['content'] = '<td style="padding:5px;font-size:16px">' + items[item][wg] + '%</td>'
                                        obj['order'] = keyOrderObj[wg]; 
                                    }else{
                                        obj['content'] = `<td style="padding:5px;font-size:16px">0%</td>`
                                        obj['order'] = keyOrderObj[wg]; 
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
                        var htmlOverall = '<div class="field"><label>Result</label></div><div>' + html + '</div>'
               
                        CloverApp.API.setDataField("result", htmlOverall);
                        CloverApp.API.setDataField("response", response);
                        var _hideControls = args.state.app.form.models.hideControls;
                        _removeElement(_hideControls, "companyType");
                        _removeElement(_hideControls, "filter");
                        CloverApp.API.setDataField("onOverallResponse", true);

                        var filterTypeRewrite = function (model) {
                            model['label'] = filterType;
                            model['data-elements'] = options;
                            model['search'] = true;
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
}