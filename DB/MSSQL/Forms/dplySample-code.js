{
    init:function(args){
        Utils.getRequest("/deployment/getDataEditor?dplyId=" + encodeURIComponent(args.data.Id))
        .then(response => {
                if(response.success && response.item !== null) {
                    var result = response.item;
                    const options = [];
                    for(var i=0; i<result.length; i++) {
                        options.push( {
                        value: result[i].id,
                        text: result[i].name,
                        } );
                    }
                    CloverApp.API.changeModelControl(args, "dictDataEditor","data-elements", options);
                }
            }, reason => {
                if(reason == 'NO_DATA_EDITORS'){
                    alertify.error('No data editor found this organisation');
                } else {
                    console.error("Error getDataEditor",reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            }
        ).finally(() => {
            args.component.refs.dictDataEditor.forceUpdate();
        });
    },
    
    onChangeDplySample: function(args){
        const dplyId = args.data.Id
        const dplySample = args.data.DplySample;
        const selectedSample = args.data.SelectedSample;
        const sampleArr = [];
        var sampleToRetrieve = null;
        const tabArray = args.sourceControlRef.state.options;
        
        for(var i = 0; i < dplySample.length; i++){
            sampleArr.push(dplySample[i]);
        };
        
        if(selectedSample !== undefined) {
            //Check is to add or remove
            let difference  = selectedSample.filter(x => !sampleArr.includes(x));
            let symDifference = selectedSample.filter(x => !sampleArr.includes(x))
                        .concat(sampleArr.filter(x => !selectedSample.includes(x)));
            if(difference.length > 0) {
                //To remove from Tab
                var indexToRemove;
                const sampleTabsModel = function (model) {
                    for (x=0;x<model.items.length;x++){
                        if(model.items[x].key == symDifference) {
                            indexToRemove = x;
                            break;
                        }
                    }
                    model.children.splice(indexToRemove, 1)
                    model.items.splice(indexToRemove, 1)
                    return model;
                };
                
                CloverApp.API.rewriteControlModel("SampleTabs", sampleTabsModel);
            } else {
                sampleToRetrieve = symDifference;
            }
        } else {
            sampleToRetrieve = sampleArr;
        }
        
        CloverApp.API.setDataField("SelectedSample", sampleArr);
        
        if(sampleToRetrieve !== null) {
            try{
                var tabTitle;
                var tabKey;
                for (x=0;x<tabArray.length;x++){
                    if(tabArray[x].key == sampleToRetrieve) {
                        tabTitle = tabArray[x].text;
                        tabKey = tabArray[x].key;
                    }
                }
                Utils.loadingStart();
                Utils.getRequest("/deployment/getDplySampleInfo?dplyId=" + encodeURIComponent(dplyId) + "&listSampleInfoId=" + encodeURIComponent(sampleToRetrieve))
                .then(response => {
                        if(response.success && response.item !== null) {
                            var result = response.item;
                            dplysampleUserActions.addSampleInfo(tabTitle,tabKey,result);
                        }
                    }, reason => {
                        console.error(reason);
                        alertify.error( Utils.encodeHTML(reason) );
                }
                ).finally(Utils.loadingStop);
            }catch(e){
                console.log(e);
            }
        }
    },
    
    //Create tabs details for sample
    createSampleInfoTable: function (result) {
        var divArray = new Array();
        var id = result.UID;
        var isMultiResponse = result.multiResponse;
    
        divArray['children'] = new Array();
        divArray['data-buildertype'] = "container";
        divArray['key'] = "container_" + id;
        divArray['style-customcss'] = "ui message";
    
        var sampleInfo = new Array();
        var tableStyle = "style='background-color:#e8e8e8;padding:5px;'";
        var content = "<table class='ui info message'>";
        content += "<tr><td " + tableStyle + ">UID</td><td>" + result.UID + "</td></tr>";
        content += "<tr><td " + tableStyle + ">Name</td><td>" + result.Name + "</td></tr>";
        content += "<tr><td " + tableStyle + ">Status</td><td>" + result.StatusTitle + "</td></tr>";
        var segmentVal = result.Segment !== null ? result.Segment : '';
        content += "<tr><td " + tableStyle + ">Segment</td><td>" + segmentVal + "</td></tr>";
        if(isMultiResponse == false){
            var respDateStartVal = result.RespDateStart !== null ? dayjs(new Date(result.RespDateStart)).format('DD MMM YYYY HH:mm') : '';
            content += "<tr><td " + tableStyle + ">Response Start</td><td>" + respDateStartVal + "</td></tr>";
            var respDateEndVal = result.RespDateEnd !== null ? dayjs(new Date(result.RespDateEnd)).format('DD MMM YYYY HH:mm') : '';
            content += "<tr><td " + tableStyle + ">Response Complete</td><td>" + respDateEndVal + "</td></tr>";
        }
        var dueDateVal = result.DueDate !== null ? dayjs(new Date(result.DueDate)).format('DD MMM YYYY HH:mm') : '';
        content += "<tr><td " + tableStyle + ">Due Date</td><td>" + dueDateVal + "</td></tr>";
        content += "</table>";
    
        sampleInfo['content'] = content;
        sampleInfo['data-buildertype'] = "staticcontent";
        sampleInfo['key'] = "staticContent_" + id;
        sampleInfo['isHtml'] = true;
    
        divArray.children.push(sampleInfo);
    
        var divHr = new Array();
        divHr['content'] = "<hr style='margin-top:20px; margin-bottom:20px'>";
        divHr['data-buildertype'] = "staticcontent";
        divHr['key'] = "scHr_" + id;
        divHr['isHtml'] = true;
    
        divArray.children.push(divHr);
    
        var gvSample = new Array();
        var gvSampleId = "gv_" + id
        gvSample['key'] = gvSampleId;
        gvSample['data-buildertype'] = "gridviewwithactions";
        gvSample['columns'] = new Array();
        gvSample['multiselect'] = true;
        gvSample['rowKey'] = "lsoId";
        gvSample['style-source'] = "margin-top:10px;max-height:200px;max-width:400px;overflow:hidden scroll;";
    
        var gvUsername = new Array();
        gvUsername['key'] = "Username";
        gvUsername['name'] = "Data Editor Name";
        gvUsername['sortable'] = false;
        gvUsername['filterable'] = false;
        gvUsername['resizable'] = false;
        gvSample.columns.push(gvUsername);
        
        var eventAdd = [];
        eventAdd['onClick'] = new Array();
        eventAdd.onClick['active'] = true;
        eventAdd.onClick['actions'] = new Array("openAddDataOwnerModal");
        eventAdd.onClick['parameters'] = new Array();
        
        var param = new Array();
        param['name'] = "UID";
        param['value'] = id;
        eventAdd.onClick.parameters.push(param);
        
        var listSampleId = new Array();
        listSampleId['name'] = "listSampleId";
        listSampleId['value'] = result.ListSampleId;
        eventAdd.onClick.parameters.push(listSampleId);
        
        var gridName = new Array();
        gridName['name'] = "gridName";
        gridName['value'] = gvSampleId;
        eventAdd.onClick.parameters.push(gridName);
        
        var listSampleInfoId = new Array();
        listSampleInfoId['name'] = "listSampleInfoId";
        listSampleInfoId['value'] = result.Id;
        eventAdd.onClick.parameters.push(listSampleInfoId);
    
        var btnAdd = new Array();
        btnAdd['content'] = "Add Assignment";
        btnAdd['primary'] = true;
        btnAdd['data-buildertype'] = "button";
        btnAdd['key'] = "btnAdd_" + id;
        btnAdd['events'] = eventAdd;
    
        var eventDelete = [];
        eventDelete['onClick'] = new Array();
        eventDelete.onClick['active'] = true;
        eventDelete.onClick['actions'] = new Array("confirm","delDataOwner");
        eventDelete.onClick['targets'] = new Array(gvSampleId);
        eventDelete.onClick['parameters'] = new Array();
        
        var eventDeleteParamTitle = [];
        eventDeleteParamTitle['name'] = "confirmTitle";
        eventDeleteParamTitle['value'] = "deleteSampleAssignmentTitle";
        eventDelete.onClick.parameters.push(eventDeleteParamTitle);
        
        var eventDeleteParamText = [];
        eventDeleteParamText['name'] = "confirmText";
        eventDeleteParamText['value'] = "deleteSampleAssignmentText";
        eventDelete.onClick.parameters.push(eventDeleteParamText);
        
        var btnDel = new Array();
        btnDel['content'] = "Remove Selected Assignment";
        btnDel['secondary'] = true;
        btnDel['data-buildertype'] = "button";
        btnDel['key'] = "btnDel_" + id;
        btnDel['events'] = eventDelete;
    
        divArray.children.push(btnAdd);
        divArray.children.push(btnDel);
        divArray.children.push(gvSample);
    
        var dataEditor = result.dataEditor;
        CloverApp.API.setDataField(gvSampleId, dataEditor);
    
        return divArray;
    },
    
    addSampleInfo:function(tabTitle,tabKey,result){
        const sampleTabsModel = function (model) {
            var sampleTable = dplysampleUserActions.createSampleInfoTable(result);
            model.children.push(sampleTable);
            model.items.push({ "title" : tabTitle , "key" : tabKey });
            return model;
        };
        CloverApp.API.rewriteControlModel("SampleTabs", sampleTabsModel);
        CloverApp.API.setDataField("SampleTabs", null);
    },
    
    delDataOwner:function(args){
        const dplyId = args.data.Id;
        const gridViewName = args.controlRef.props.name;
        const gridView = args.component.refs[gridViewName];
        const gridItems = args.controlRef.state.items;
        const gridSelectedIndexes =  args.controlRef.state.selectedIndexes;
        if(gridSelectedIndexes.length===0){
            alertify.error("No assignments selected"); 
            return {};
        }
        const filteredDataEditor = gridItems.filter((value, index) => !gridSelectedIndexes.includes(index));
        
        Utils.loadingStart("Clearing assignments...");
        const formData = new FormData();
        formData.append('dplyId', dplyId);
        formData.append('sampleOwnerIds', gridSelectedIndexes.map(i => gridItems[i].lsoId) );  
        Utils.postFormRequest("/deployment/deleteDataEditor", formData).then(
            response => {
                CloverApp.API.setDataField(gridViewName, filteredDataEditor);
                gridView.refresh();
                alertify.success(Utils.encodeHTML(response.message));
            }, reason => {
                console.error("Failed to delete assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
    closeAddDataOwnerModal: function(args){
        args.component.refs.mdlDataEditor.close();
    },
    
    openAddDataOwnerModal:function(args){
        args.component.refs.mdlDataEditor.openModal();
        CloverApp.API.setDataField("Tabs_UID", args.parameters.UID);
        CloverApp.API.setDataField("Tabs_UID_listSampleId", args.parameters.listSampleId);
        CloverApp.API.setDataField("Tabs_UID_gridName", args.parameters.gridName);
        CloverApp.API.setDataField("Tabs_UID_listSampleInfoId", args.parameters.listSampleInfoId);
    },
    
    addDataEditor:function(args){
        const dplyId = args.data.Id;
        const dataEditor = args.data.dictDataEditor;
        const listSampleId = args.data.Tabs_UID_listSampleId;
        
        if(dataEditor == null || dataEditor.length == 0) {
            alertify.error("No Data Editor selected");  
            return {};
        }
        
        Utils.loadingStart("Adding assignments...");
        const formData = new FormData();
        formData.append('dplyId', dplyId);
        formData.append('userId', dataEditor);
        formData.append('listSampleIds', listSampleId);
        Utils.postFormRequest("/deployment/setDataEditor", formData).then(
            response => {
                alertify.success(Utils.encodeHTML(response.message));
                dplysampleUserActions.refreshDataEditorGV(args)
            }, reason => {
                console.error("Failed to add assignments", reason);
                alertify.error( Utils.encodeHTML(reason) );
            }
        ).finally(() => {
            Utils.loadingStop();
            CloverApp.API.setDataField("dictDataEditor", []);
        });
        
        args.component.refs.mdlDataEditor.close();
    },
    
    refreshDataEditorGV:function(args){
        const dplyId = args.data.Id;
        const gridName = args.data.Tabs_UID_gridName;
        const listSampleInfoId = args.data.Tabs_UID_listSampleInfoId;
        
        Utils.getRequest("/deployment/GetListSampleRespInfo?dplyId=" + encodeURIComponent(dplyId) + "&listSampleInfoId=" + encodeURIComponent(listSampleInfoId))
        .then(response => {
                if(response.success && response.item !== null) {
                    CloverApp.API.setDataField(gridName, response.item);
                }
            }, reason => {
                if(reason == 'NO_DATA_OWNER'){
                    //CloverApp.API.setDataField("dataEditorGv", []);
                } else {
                    console.error(reason);
                    alertify.error(Utils.encodeHTML(reason));
                }
            }
        );
    },
}