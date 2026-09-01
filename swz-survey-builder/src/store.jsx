var Reflux = require('reflux');
var BuilderActions = require('./actions');
var CloverFormControls = require('./controls');

var _data;

var CloverStore = Reflux.createStore({
  init: function() {
    this.listenTo(BuilderActions.add, this.add);
    this.listenTo(BuilderActions.move, this.move);
    this.listenTo(BuilderActions.remove, this.remove);
    this.listenTo(BuilderActions.save, this.save);
    this.listenTo(BuilderActions.saveData, this._updateOrder);
    this.listenTo(BuilderActions.offScroll, this.swzOffScrollAll);
    this.listenTo(BuilderActions.back, this.swzBack);
    this.listenTo(BuilderActions.next, this.swzNext);

    _data = [];
  },
  move: function(key, el) {
    var findIndex = function (arr, key, isTableIndex) {
      if(arr !== undefined && arr.length > 0){
        if(!isTableIndex){
          for(let i = 0; i < arr.length; i++){
            if(arr[i].key == key)
              return i
          }
        }
        else if(isTableIndex){
          let tableIndex = {};
          for(let i = 0; i < arr.length; i++){
            if(arr[i].tableIndex == key)
              tableIndex['found'] = i;
            if(tableIndex['found'] !== undefined && arr[i].tableIndex !== key)
              return tableIndex['found']
          }
          return tableIndex['found']
        }
      }
      return
    }

    if(el == undefined)
      return;

    var item = this.findItemByKey(key, _data);
    var sortedArray = this._excludeItemByKey(key, _data);
    
    //console.log("The item is", item);
    //console.log("El", el);
    if(el.attributes['name'] != undefined && el.attributes['name'].value == 'dropzone_footer')
    {
      sortedArray.push(item);
    }
    else if(el.attributes['name'] != undefined && el.attributes['name'].value == 'dropzone_header')
    {
      sortedArray.unshift(item);
    }
    else if(el.attributes['elementtoinsert'] != undefined)
    {
        var parentControl;
        var insertIndex = 0;
        var parentKey = el.attributes['elementtoinsert'];

        if(parentKey != undefined)
        {
          parentControl = this.findItemByKey(parentKey.value, sortedArray);
        }

        if(parentControl != undefined){
          var placeholderKey = el.attributes['placeholderkey'];
          let container = undefined;

          if(placeholderKey === undefined){
            if(parentControl.children == undefined) 
              parentControl.children = [];
            container = parentControl.children;
          }
          else{
            if(parentControl.placeholders === undefined) 
              parentControl.placeholders = {};
            if(parentControl.placeholders[placeholderKey.value] == undefined){
              parentControl.placeholders[placeholderKey.value] = [];
            }
            container = parentControl.placeholders[placeholderKey.value];
          }
          
          if(el.attributes['name'] != undefined && el.attributes['name'].value.includes('dropzone_footer'))
          {
            container.push(item);
          }
          else if(el.attributes['name'] != undefined && el.attributes['name'].value.includes('dropzone_header'))
          {
            container.unshift(item);
          }
          
          else
          {
            var afterKey = el.attributes['elementafter'];
            var afterControl;
            if(afterKey != undefined)
            {
              afterControl = this.findItemByKey(afterKey.value, container);
            }
            if(el.attributes['tableindex'] !== undefined){
              if(el.attributes['tableindex'].value !== undefined && el.attributes['name'].value.includes('tableElement')){
                
                item['tableIndex'] = el.attributes['tableindex'].value;
                var res = item;
                let lastElement = el.attributes['elementafter'] !== undefined ? JSON.parse(el.attributes['elementafter'].value) : undefined;
                var index;
                //console.log("The container is", container);
                //console.log("lastElement", lastElement);
                if(lastElement !== undefined && container !== undefined && container.length > 0){
                  if(lastElement.type == 'tablecontrol'){
                    index = findIndex(container, lastElement.value, false);
                  
                    if(index == 0)
                      container.unshift(res);
  
                    if(index > 0)
                      container.splice(index, 0, res);
  
                  }else if(lastElement.type == 'tableindex'){
                    index = findIndex(container, lastElement.value, true);
                    container.splice(index + 1, 0, res);
                  }
                
                }else{
                  container.unshift(res);
                }
              }
            }else{
              container.splice(container.indexOf(afterControl), 0, item);
            }
          }
        }
        else
        {
          console.error("ERROR: element is not found", parentKey, item, el);
        }
    }
    else if(el.attributes['elementafter'] != undefined)
    {
      var control;
      var afterKey = el.attributes['elementafter'];
      if(afterKey != undefined)
      {
        control = this.findItemByKey(afterKey.value, sortedArray);
      }

      if(control != undefined){
        sortedArray.splice(sortedArray.indexOf(control), 0, item);
      }
      else
      {
        console.error("ERROR: element is not found", afterKey, item, el);
      }
    }
    
    this.setData(sortedArray);
  },
  _excludeItemByKey: function(key, data){
    var sortedArray = [];
    for(var i=0; i<data.length; i++){
      if(data[i].key == key)
        continue;

      sortedArray.push(data[i]);

      if(data[i].children){
        sortedArray[sortedArray.length - 1].children = this._excludeItemByKey(key, data[i].children);
      }
      
      if(data[i].placeholders != undefined){
        for(let ph in data[i].placeholders){
          if(Array.isArray(data[i].placeholders[ph])){
            sortedArray[sortedArray.length - 1].placeholders[ph] = this._excludeItemByKey(key, data[i].placeholders[ph]);
          }
        }
      }
    }
    return sortedArray;
  },
  add: function(item, el) {

    var findIndex = function (arr, key, isTableIndex) {
      if(arr !== undefined && arr.length > 0){
        if(!isTableIndex){
          for(let i = 0; i < arr.length; i++){
            if(arr[i].key == key)
              return i
          }
        }
        else if(isTableIndex){
          let tableIndex = {};
          for(let i = 0; i < arr.length; i++){
            if(arr[i].tableIndex == key)
              tableIndex['found'] = i;
            if(tableIndex['found'] !== undefined && arr[i].tableIndex !== key)
              return tableIndex['found']
          }
          return tableIndex['found']
        }
      }
      return
    }

    var res = CloverFormControls.fillDefaultValues({ 
      /* Add to change formgroup name to blockgroup - hard code 251019 Ben */
      key: item.key == 'formgroup' ? this.getDefaultKey('blockgroup') : this.getDefaultKey(item.key), 
      "data-buildertype": item.builderType !== undefined ? item.builderType: item.key
    }, item.defaultValues);
  
    if(el == undefined)
    {
        if(_data.length > 0 && _data[_data.length - 1]["data-buildertype"] == 'form'){
          var p = _data[_data.length - 1]; 
          if(p.children == undefined) 
            p.children = [];
          p.children.push(res);
        }
        else{
          _data.push(res);
        }
    }
    else if(el.attributes['name'] != undefined && el.attributes['name'].value == 'dropzone_footer')
    {
      _data.push(res);
    }
    else if(el.attributes['name'] != undefined && el.attributes['name'].value == 'dropzone_header')
    {
      _data.unshift(res);
    }
    else if(el.attributes['elementtoinsert'] != undefined)
    {
        var parentControl;
        var insertIndex = 0;
        var parentKey = el.attributes['elementtoinsert'];

        if(parentKey != undefined)
        {
          parentControl = this.findItemByKey(parentKey.value, _data);
        }

        if(parentControl != undefined){
         
          var placeholderKey = el.attributes['placeholderkey'];
          let container = undefined;

          if(placeholderKey === undefined){
            if(parentControl.children == undefined)
              parentControl.children = [];
            container = parentControl.children;
          }
          else{
            if(parentControl.placeholders === undefined){
              parentControl.placeholders = {}
            }
            if(parentControl.placeholders[placeholderKey.value] == undefined){
              parentControl.placeholders[placeholderKey.value] = [];
            }
            container = parentControl.placeholders[placeholderKey.value];
          }
           
          if(el.attributes['name'] != undefined && el.attributes['name'].value.includes('dropzone_footer'))
          {
            container.push(res);
          }
          else if(el.attributes['name'] != undefined && el.attributes['name'].value.includes('dropzone_header'))
          {
            container.unshift(res);
          }
          else if(el.attributes['name'] != undefined && el.attributes['name'].value.includes('tableElement'))
          {
  
            res['tableIndex'] = el.attributes['tableIndex'].value;
            let lastElement = el.attributes['elementafter'] !== undefined ? JSON.parse(el.attributes['elementafter'].value) : undefined;
            var index;
            if(res['data-buildertype'] !== 'block' && res['data-buildertype'] !== 'swzDivider' && res['data-buildertype'] !== 'swztable'  && res['data-buildertype'] !== 'menu'){

              if(lastElement !== undefined && container !== undefined && container.length > 0){
                if(lastElement.type == 'tablecontrol'){
                  index = findIndex(container, lastElement.value, false);
                
                  if(index == 0)
                    container.unshift(res);

                  if(index > 0)
                    container.splice(index, 0, res);

                }else if(lastElement.type == 'tableindex'){
                  index = findIndex(container, lastElement.value, true);
                  container.splice(index + 1, 0, res);
                }
              
              }else{
                container.unshift(res);
              }
            }else{
              if(res['data-buildertype'] == 'menu'){
                alert('You cannot place menu control under a table');
              }
              alert('You can only place control elements under table control');
            }
          }
          else
          {
            var afterKey = el.attributes['elementafter'];
            var afterControl;
            if(afterKey != undefined)
            {
              afterControl = this.findItemByKey(afterKey.value, container);
            }
            container.splice(container.indexOf(afterControl), 0, res);
          }
        }
        else
        {
          console.error("ERROR: element is not found", parentKey, item, el);
        }
    }
    else if(el.attributes['elementafter'] != undefined)
    {
      var control;
      var afterKey = el.attributes['elementafter'];
      if(afterKey != undefined)
      {
        control = this.findItemByKey(afterKey.value, _data);
      }

      if(control != undefined){
        _data.splice(_data.indexOf(control), 0, res);
      }
      else
      {
        console.error("ERROR: element is not found", afterKey, buildertype, title, el);
      }
    }
    
     this.trigger(_data);
  },
  swzSwitchType: function(status, type){

    console.log("Status ", status);
    console.log("Type ", type);
    
    var switchFocus = function (model) {
      model.forEach(function(control, i){

        if(control['data-buildertype'] == "radiogroup" || control['data-buildertype'] == "dropdown")
          if(control['onScrollNextControl'] !== undefined && control['onScrollNextControl'] !== '')
            control['onScrollNextControl'] = status;
                
        if(control.children !== undefined && control.children.length > 0)
          switchFocus(control.children);
        
      });
    }

    var switchRequired = function (model) {
      console.log("Switch required");
      model.forEach(function(control, i){
        console.log("Control ", control);
        console.log("isRequiredInput ", CloverStore.isRequiredInput(control['data-buildertype']));  

        if(CloverStore.isRequiredInput(control['data-buildertype'])){
          control['other-required'] = status;
        }
                
        if(control.children && control.children.length > 0)
          switchRequired(control.children);
        
      });
    }
    
    if(type == "focus")
      switchFocus(_data);
    else if(type == "required")
      switchRequired(_data);

  },
  swzClearLogic: function(type){
    
    var clearLogic = function (model, type) {
      model.forEach(function(control, i){

         // if(control['other-visibleConition'] !== undefined && control['other-visibleConition'] !== '')
        if(type == "required"){
          if(control['other-required'] !== undefined && control['other-required'] !== '')
            control['other-required'] = false;
          if(control['other-required-soft'] !== undefined && control['other-required-soft'] !== '')
            control['other-required-soft'] = false;

        }else if(type == "validation"){
          if(control['other-customValidation'] !== undefined && control['other-customValidation'] !== '')
            control['other-customValidation'] = '';
          if(control['other-customValidation-soft'] !== undefined && control['other-customValidation-soft'] !== '')
            control['other-customValidation-soft'] = false;

        }else if(type == "visible"){
          if(control['other-visibleConition'] !== undefined && control['other-visibleConition'] !== '')
           control['other-visibleConition'] = '';
        
        }else if(type == "readonly"){
          if(control['other-readOnlyConition'] !== undefined && control['other-readOnlyConition'] !== '')
            control['other-readOnlyConition'] = '';
        
        }else if(type == "skip"){
          if(control['other-skipConition'] !== undefined && control['other-skipConition'] !== '')
            control['other-skipConition'] = '';
        
        }
        
        if(control.children !== undefined && control.children.length > 0)
          clearLogic(control.children, type);
        
      });
    }

      clearLogic(_data, type);
  },

  swzOffScrollAll: function(){
    this.swzOffScrollItemsByKeys();
    this.trigger(_data);
  },
  swzHideAll: function(){
    this.swzHideAllByKeys();
    this.trigger(_data);
  },
  swzShowAll: function(){
    this.swzShowAllByKeys();
    this.trigger(_data);
  },
  swzOnBuilderMode: function(){
    var items = _data
    for (var i = 0; i < items.length; i++) {
        if(items[i].buildermode == false){
          items[i]['buildermode'] = true;  
      }
    }

    this.trigger(_data);
  },
  swzBefSaveShowAll: function(){
      var items = _data
      var prevOnDis = [];
      var prevOffDis = [];
    
      for (var i = 0; i < items.length; i++) {
        items[i]['buildermode'] = false;
        if(items[i].onpagedisplay == false){
          prevOffDis.push(items[i].key);
        }else if(items[i].onpagedisplay == true){
          items[i]['onpagedisplay'] = false;
          prevOnDis.push(items[i].key);
        }
      }
      items[0]['onpagedisplay'] = true;
      var res = [{prevOnDis: prevOnDis, 
          prevOffDis: prevOffDis}];
      this.trigger(_data);
      return res;
  },
  swzLoadPrevState: function (prevState){
    var prevOn = prevState[0].prevOnDis;
    var items = _data;  
    var offDisMap = {};

    for (let i = 0; i < items.length; i++) {
      items[i]['buildermode'] = true;
      if(prevOn.length > 0){
        for (let j = 0; j < prevOn.length; j++){
          if(items[i].key == prevOn[j]){
            items[i]['onpagedisplay'] = true;
            offDisMap[i] = undefined;
            break;
          }else{
              offDisMap[i] = items[i].key;
          }
        }
        if(offDisMap[i] !== undefined){
          items[i]['onpagedisplay'] = false;
        }
      }
      else{
          items[i]['onpagedisplay'] = false;
      }
    }

    this.trigger(_data);
  },
  swzHide: function(item){
    this.swzHideItemByKey(item.key, _data);
    this.trigger(_data);
  },
  swzShow: function(item){
    this.swzShowItemByKey(item.key, _data);
    this.trigger(_data);
  },
  swzBack: function(){
    var items = _data;
    for (var i = 0; i < items.length; i++) {
      if(items[i].onpagedisplay == true){
        if(items[i-1] != undefined || items[i-1] != null){
          items[i-1]['onpagedisplay'] = true;
          items[i]['onpagedisplay'] = false;
          break;
        }else{
          alert("There is not page before current page");
        }
      }
    }
    
    this.trigger(_data);
  },
  swzNext: function(){
    var items = _data;
    for (var i = 0; i < items.length; i++) {
      if(items[i].onpagedisplay == true){
        if(items[i+1] != undefined || items[i+1] != null){
          items[i + 1]['onpagedisplay'] = true;
          items[i]['onpagedisplay'] = false;
          break;
        }else{
          alert("There is not page after current page");
        }
      }
    }
    
    this.trigger(_data);
  },
  updateTableSpanDictSplit: function (tableIndex, dict, affectedIndexes) {
    if(affectedIndexes == undefined || affectedIndexes.length < 0)
      return dict
 
    dict[tableIndex] = {
      'rowSpan': 1,
      'colSpan': 1 
    }
    for(let i = 0; i < affectedIndexes.length; i++){
      dict[affectedIndexes[i]] = {
        'rowSpan': 1,
        'colSpan': 1
      }
    }
    return dict;
  },
  swzSplit: function(item){
    var items = _data;
    this.splitTableData(items, item);
    this.trigger(items);
  },
  splitTableData: function(items, item){

    /*
    Objective: Split a merged cell
    1. Upon split cell
    2. Look for affected cells - How to determine affected cells?
    3. Overwrite the split cell and it's affected cells - Give rowSpan: 1, colSpan 1.
    */
    //var targetPage = item.props.parent.key;
    var parentKey = item.props.parent.key;
    var targetPage = item.props.parent.parentPage == undefined ? parentKey : item.props.parent.parentPage;
    var targetTable = item.props.model.key;
    
    var tableIndexes = item.props.model.tableindex;
    var tableIndex = item.props.additionalParams.model.tableIndex;
    var rowIndex = tableIndex.substr(0, tableIndex.indexOf('_'));
    
    if(item.props.model.spandict == undefined){
        alert('You can only split a merged cell');
        return
    }
    if(item.props.model.spandict[tableIndex] == undefined){
      alert('You can only split a merged cell');
      return
    }
    var affectedIndexes = item.props.model.spandict[tableIndex].mergedIndexes;
    if(affectedIndexes == undefined){
      alert('You can only split a merged cell');
      return
    }

    var fullTableIndex = this.getFullTableIndex(tableIndexes);
    
    for (let i = 0; i < items.length; i++) {
      if(items[i].key == targetPage){
        var tableModel = this.findTargetTable(items[i].children, targetTable);
        if(tableModel !== undefined){
          var spanDict = tableModel.spandict == undefined ? {} : tableModel.spandict;
          var newSpanDict = this.updateTableSpanDictSplit(tableIndex, spanDict, affectedIndexes); 
          tableModel.spandict = newSpanDict;
          break;
        }
        
      }
    }
  },
  swzMerge: function(item, rowSpan, colSpan){
   
    var items = _data;
    this.mergeRowOrColumnByKey(items, item, parseInt(rowSpan), parseInt(colSpan));
    this.trigger(items);
  },
  getFullTableIndex: function (tableIndexes){
    var indexObj = {};
    var fullTableIndex = [];
    var rowObj = {};
    var locateRowArrayIndex = {}

    /*
      Objective: Compute full table index into respective rows
        1. For every row index,
          1.0.1. Check if it is a new or existing row index from RowArrayIndex

          1.1.0. If new row index, create a RowArray and insert values in relative to new rowIndex
          1.1.1. Push to FullTable
          1.1.2. Keep track of RowArrayIndex
          
          1.2.0. For existing row index, we locate it's RowArrayIndex
          1.2.1  Push to its RowArray accordingly
    */

    for(let j = 0; j < tableIndexes.length; j++){
      let rowIndex = tableIndexes[j].substr(0, tableIndexes[j].indexOf('_'));
    
      if(locateRowArrayIndex[rowIndex] == undefined){
        var rowIndexes = [];
        rowIndexes.push(tableIndexes[j]);
        rowObj = {
          [rowIndex]: rowIndexes
        }
        var rowArrayIndex = fullTableIndex.length;
        locateRowArrayIndex[rowIndex] = rowArrayIndex;
        fullTableIndex.push(rowObj);
      }else{
        var rowArrayIndex = locateRowArrayIndex[rowIndex];
        var key = Object.keys(fullTableIndex[rowArrayIndex]);
        fullTableIndex[rowArrayIndex][key].push(tableIndexes[j]);
      }
    }
    return fullTableIndex
  },
  mergeRowOrColumnByKey: function (items, item, rowSpan, colSpan) {

    var parentKey = item.props.parent.key;
   //var targetPage = item.props.parent.key;
    var targetPage = item.props.parent.parentPage == undefined ? parentKey : item.props.parent.parentPage;
    var targetTable = item.props.model.key;
    var tableIndexes = item.props.model.tableindex;
    var tableIndex = item.props.additionalParams.model.tableIndex;
    var rowIndex = tableIndex.substr(0, tableIndex.indexOf('_'));
    var fullTableIndex = this.getFullTableIndex(tableIndexes);

    //From fullTableIndex, find the row index the element belongs to, find the index it belongs to
    var affectedIndexes = this.indexesAffected(tableIndex, fullTableIndex, rowIndex, colSpan, rowSpan);
    if(!affectedIndexes) return

    for (let i = 0; i < items.length; i++) {
      if(items[i].key == targetPage){
        var tableModel = this.findTargetTable(items[i].children, targetTable);

        if(tableModel !== undefined){
          var newChildren = this.updateTableChildren(tableModel.children, affectedIndexes, tableIndex);
          var spanDict = tableModel.spandict == undefined ? {} : tableModel.spandict;
          var newSpanDict = this.updateTableSpanDictMerge(tableIndex, rowSpan, colSpan, spanDict, affectedIndexes); 
          tableModel.spandict = newSpanDict;
          tableModel.children = newChildren;
          break;
        }

        
       /*  for (let j = 0; j < items[i].children.length; j++){
            if(items[i].children[j].key == targetTable){
              var newChildren = this.updateTableChildren(items[i].children[j].children, affectedIndexes, tableIndex);
              var spanDict = items[i].children[j].spandict == undefined ? {} : items[i].children[j].spandict;
              var newSpanDict = this.updateTableSpanDictMerge(tableIndex, rowSpan, colSpan, spanDict, affectedIndexes); 
              items[i].children[j].spandict = newSpanDict;
              items[i].children[j].children = newChildren;
              break;
            }
          } */
      }
    }
  },
  //Upon merge, bring merged cell's controls to the cell
  updateTableChildren: function(children, affectedIndexes, tableIndex){
    if(children == undefined || children.length < 0)
      return
    for(let i = 0; i < children.length; i++){
      for(let k = 0; k < affectedIndexes.length; k++){
        if(children[i].tableIndex == affectedIndexes[k]){
          children[i]['tableIndex'] = tableIndex;
        }
      }
    }
    return children
  },
  updateTableSpanDictMerge: function (tableIndex, rowSpan, colSpan, dict, affectedIndexes) {
    
    var mergedIndexes = [];
    if(affectedIndexes == undefined || affectedIndexes.length < 0)
      return dict
    
    for(let i = 0; i < affectedIndexes.length; i++){
      dict[affectedIndexes[i]] = {
        'rowSpan': 0,
        'colSpan': 0
      }
      mergedIndexes.push(affectedIndexes[i]);
    }

    dict[tableIndex] = {
      'rowSpan': parseInt(rowSpan),
      'colSpan': parseInt(colSpan),
      'mergedIndexes': mergedIndexes
    }
    return dict;
  },
  indexesAffected: function(tableIndex, fullTableIndex, rowIndex, colSpan, rowSpan){
    var affectedIndexes = [];
    var onLocateElement = {};

    var errMsg = "Insert correct number of columns or rows to merge";

    if(colSpan <= 1 && rowSpan <= 1 || (colSpan <= 0 || rowSpan <= 0)){
      alert(errMsg);
      return false
    }

    var checkColumns = function(m, elementColumnIndexLeftMax, elementColumnIndexRightMax){
      /*
        Logic
        1. Locate row by finding the element index
        2. Take note of the column index as it is the left max
        3. Ensure ([colspan - 1] + current position) is the right max. 
        4. Loop sequence is column level followed by row level
        5. Depending on colSpan and rowSpan to complete sequence
        6. Do not push tableIndex itself 
      */
     if(m >= elementColumnIndexLeftMax && m <= elementColumnIndexRightMax){
       return true
     }else{
       return false
     }
    }

    var checkRows = function(k, elementRowIndexMax){
      /*
        1. When K == row max, it needs to go through a last cycle before breaking
        2. Do not allow entry after row has passed the max
      */
     if(elementRowIndexMax < k){
       return false
     }else{
       return true
     }
    }

    for (var k = 0; k < fullTableIndex.length; k++){
      //Get affected columns within rows
      var rowLevel = fullTableIndex[k][Object.keys(fullTableIndex[k])];

      if(onLocateElement["Found element"]){
        var result = checkRows(k, onLocateElement['elementRowIndexMax']);
        if(!result){
          break
        }
      }
      for (var m = 0; m < rowLevel.length; m++){
          var elementIndex = rowLevel[m];
          //Locate row by finding element index
          if(onLocateElement["Found element"] == undefined && elementIndex == tableIndex){
              onLocateElement["Found element"] = true;
              onLocateElement['elementColumnIndexLeftMax'] = m;
              onLocateElement['elementColumnIndexRightMax'] = m + colSpan - 1;
              onLocateElement['elementRowIndexMax'] = k + rowSpan - 1;
              onLocateElement['elementRowIndexMin'] = k;           
     
            /*
              1. Check if columnSpan or rowSpan exceeds the size
              -Column
              2. Get the current column index onLocateElement['elementColumnIndexLeftMax']
              3. Take the length of rowLevel - currentColumnIndex
              4. ColSpan cannot be > than the amt
              -Row
              2. Get the current row onLocateElement['elementRowIndexMin']
              3. Take total number of rows.length - currentRowIndex
              4. RowSpan cannot be > than the amt
            */
      
            var elementColIndexToMaximum = rowLevel.length - onLocateElement['elementColumnIndexLeftMax'];
            var elementRowIndexToMaximum = fullTableIndex.length - onLocateElement['elementRowIndexMin'];
            
            if(colSpan >  elementColIndexToMaximum || rowSpan > elementRowIndexToMaximum){
              alert(errMsg);
              return false
            }
          };

          if(onLocateElement["Found element"] == true){
            //Pushing column level, do not push current element
            if(elementIndex !== tableIndex){
              var res = checkColumns(m, onLocateElement['elementColumnIndexLeftMax'], onLocateElement['elementColumnIndexRightMax'])
              if(res){
                affectedIndexes.push(elementIndex);
              }
            }
          }
      }
    }
    return affectedIndexes
  },
  mergeColumnRow: function(index, tableIndexes) {
    
    let newTableIndexes = [];
    let newTableIndex;
    let targetIndex;
    let uniqueId = Date.now();

    for(let a = 0;  a < tableIndexes.length ; a++){
        let columnIndex = tableIndexes[a].substr(tableIndexes[a].indexOf('_') + 1, tableIndexes[a].length);
        let rowIndex = tableIndexes[a].substr(0, tableIndexes[a].indexOf('_')); 
        //Generate randomId for new table element
        newTableIndex = rowIndex + uniqueId + "_" + columnIndex; 
        targetIndex = rowIndex;
        if(targetIndex == index){    
          //Add row before the target index
          newTableIndexes.push(newTableIndex);
          newTableIndexes.push(tableIndexes[a]);
        }else{
          newTableIndexes.push(tableIndexes[a]);
        }
      }

    return newTableIndexes
  },
  swzAddColumnBefore: function(item){
  {/*
    1. Find column of the target element
    2. Get all targetted tableIndex of that column
    3. Add in new tableIndex by moving targetted tableIndex forward by 1 column
    4. Ensure that all items belonging to the tableIndex is brought forward as well*/}
    var items = _data;
    this.addRowOrColumnByKey(items, item, "addColumn", "before");
    this.trigger(items);
  },

  swzAddColumnAfter: function(item){
    {/*
      1. Find column of the target element
      2. Get all targetted tableIndex of that column
      3. Add in new tableIndex by moving targetted tableIndex forward by 1 column
      4. Ensure that all items belonging to the tableIndex is brought forward as well*/}
      var items = _data;
      this.addRowOrColumnByKey(items, item, "addColumn", "after");
      this.trigger(items);
  },

  swzAddRowAfter: function(item){

    var items = _data;
    this.addRowOrColumnByKey(items, item, "addRow", "after");
    this.trigger(items);
  },

  swzAddRowBefore: function(item){
    {/*
        1. Find row of the target element
        2. Get all targetted tableIndex of that row
        3. Add in new tableIndex by moving targetted tableIndex forward by 1 row
        4. Ensure that all items belonging to the tableIndex is brought forward as well*/}
        var items = _data;
        this.addRowOrColumnByKey(items, item, "addRow", "before");
        this.trigger(items);
  },
  
  swzDeleteRow: function(item){
    var items = _data;
    this.deleteRowOrColumnByKey(items, item, "deleteRow", undefined);
    this.trigger(items);
  },
  
  swzDeleteColumn: function(item){
    {/*
        1. Find column of the target element
        2. Get all targetted tableIndex of that column
        3. Add in the ones to new array except the targetted columns*/}
        var items = _data;
        this.deleteRowOrColumnByKey(items, item, "deleteColumn", undefined);
        this.trigger(items);
  },

  deleteRowOrColumnByKey: function (items, item, action, timing) {
    var parentKey = item.props.parent.key;
    //var targetPage = item.props.parent.key;
    var targetPage = item.props.parent.parentPage == undefined ? parentKey : item.props.parent.parentPage;
    var targetTable = item.props.model.key;
    var tableIndex = item.props.additionalParams.model.tableIndex;
    var rowOrColumn;
   
    if(action == "deleteColumn"){
      rowOrColumn = tableIndex.substr(tableIndex.indexOf('_') + 1, tableIndex.length);
    }else{
      if(action == "deleteRow"){
        rowOrColumn = tableIndex.substr(0, tableIndex.indexOf('_'));
      }
    }
    for (let i = 0; i < items.length; i++) {
      if(items[i].key == targetPage){
        var tableModel = this.findTargetTable(items[i].children, targetTable);
        if(tableModel !== undefined){
          let tableIndexes = tableModel.tableindex;
          let res = this.deleteColumnRow(rowOrColumn, tableIndexes, action, timing)
          tableModel.tableindex = res['newTableIndexes'];
          //Remove all items that exist in the indexes
          if(tableModel.children !== undefined && tableModel.children.length > 0){
            tableModel.children = this.removeItemsByTableIndex(res['deletedTableIndexes'], tableModel.children);
          }
          break;
        }


          /* for (let j = 0; j < items[i].children.length; j++){
            if(items[i].children[j].key == targetTable){
              let tableIndexes = items[i].children[j].tableindex;
              let res = this.deleteColumnRow(rowOrColumn, tableIndexes, action, timing)
              items[i].children[j].tableindex = res['newTableIndexes'];
              
              //Remove all items that exist in the indexes
              if(items[i].children[j].children !== undefined && items[i].children[j].children.length > 0){
                items[i].children[j].children = this.removeItemsByTableIndex(res['deletedTableIndexes'], items[i].children[j].children);
              }
              break;
            }
          } */
      }
    }
  },
  
  removeItemsByTableIndex: function(deletedTableIndexes, items){   
    var newItems = [];//items;
    var itemPushed = {};
    var deletedObj = {};
    for (var i = 0; i < items.length; i++) {    
      for(let m = 0; m < deletedTableIndexes.length; m++){
        if(itemPushed[items[i].key] == undefined && deletedObj[items[i].key] == undefined){
          if(items[i].tableIndex !== deletedTableIndexes[m]){
            newItems.push(items[i]);
            deletedObj[items[i].key] = "deleted";
          }else{
            itemPushed[items[i].key] = "Checked";
          }
        }
      }
    }
  
    return newItems;
  },

  deleteColumnRow: function(index, tableIndexes, action, timing) {
    
    let newTableIndexes = [];
    let removedTableIndexes = [];
    let targetIndex;
    let res = {};

    for(let a = 0;  a < tableIndexes.length ; a++){ 
        let columnIndex = tableIndexes[a].substr(tableIndexes[a].indexOf('_') + 1, tableIndexes[a].length);
        let rowIndex = tableIndexes[a].substr(0, tableIndexes[a].indexOf('_'));
        if(action == "deleteRow"){
        //Generate randomId for new table element
            targetIndex = rowIndex;
        }else{
          if(action == "deleteColumn")
            targetIndex = columnIndex;
        }
          if(targetIndex !== index){    
            //Exclude row
            newTableIndexes.push(tableIndexes[a]);
          }else{
            removedTableIndexes.push(tableIndexes[a]);
          }
    }
        res['newTableIndexes'] = newTableIndexes;
        res['deletedTableIndexes'] = removedTableIndexes;
   
    return res
  },

  //Return tablemodel
  findTargetTable: function(model, targetTable) {

    var tableModel;

    if(model['key'] == targetTable){
      return model
    }  

    for(var i in model){
      if(model[i]['key'] == targetTable){
        tableModel = model[i];
        break;
      }
      if(model[i].children !== undefined && model[i].children.length > 0){
        tableModel = this.findTargetTable(model[i].children, targetTable); 
        if(tableModel !== undefined)
          return tableModel
      }
    }
    
    return tableModel;
  },

  addRowOrColumnByKey: function (items, item, action, timing) {

    var parentKey = item.props.parent.key;
    //var targetPage = item.props.parent.key;
    var targetPage = item.props.parent.parentPage == undefined ? parentKey : item.props.parent.parentPage;
    var targetTable = item.props.model.key;
    var tableIndex = item.props.additionalParams.model.tableIndex;
    var rowOrColumn;
    var tableModel;
    if(action == "addColumn"){
      rowOrColumn = tableIndex.substr(tableIndex.indexOf('_') + 1, tableIndex.length);
    }else{
      if(action == "addRow"){
        rowOrColumn = tableIndex.substr(0, tableIndex.indexOf('_'));
      }
    }
  
    for (let i = 0; i < items.length; i++) {
      if(items[i].key == targetPage){
        var tableModel = this.findTargetTable(items[i].children, targetTable);
       
        if(tableModel !== undefined){
          let tableIndexes = tableModel.tableindex;
          
          var newTableIndexes = this.addColumnRow(rowOrColumn, tableIndexes, action, timing)
          tableModel['tableindex'] = newTableIndexes;
          break;
        }
        
         /*  for (let j = 0; j < items[i].children.length; j++){
            if(items[i].children[j].key == targetTable){
              let tableIndexes = items[i].children[j].tableindex;
              var newTableIndexes = this.addColumnRow(rowOrColumn, tableIndexes, action, timing)
              items[i].children[j].tableindex = newTableIndexes;
              break;
            }
          } */
      }
    }
  },

  addColumnRow: function(index, tableIndexes, action, timing) {
    
    let newTableIndexes = [];
    let newTableIndex;
    let targetIndex;
    let uniqueId = Date.now();

    for(let a = 0;  a < tableIndexes.length ; a++){   
        let columnIndex = tableIndexes[a].substr(tableIndexes[a].indexOf('_') + 1, tableIndexes[a].length);
        let rowIndex = tableIndexes[a].substr(0, tableIndexes[a].indexOf('_'));

        if(action == "addRow"){
        //Generate randomId for new table element
          newTableIndex = rowIndex + uniqueId + "_" + columnIndex; 
          targetIndex = rowIndex;
        }else{
          if(action == "addColumn")
            newTableIndex = rowIndex + "_" + columnIndex + uniqueId;
            targetIndex = columnIndex;
        }

        if(timing == "before"){
          if(targetIndex == index){    
            //Add row before the target index
            newTableIndexes.push(newTableIndex);
            newTableIndexes.push(tableIndexes[a]);
          }else{
            newTableIndexes.push(tableIndexes[a]);
          }
        }else{
          if(timing == "after"){
            if(targetIndex == index){ 
              //Add row before the target index
              newTableIndexes.push(tableIndexes[a]);
              newTableIndexes.push(newTableIndex);
            }else{
              newTableIndexes.push(tableIndexes[a]);
            }
          }
        }
      }

    return newTableIndexes
  },

  remove: function(item) {
    this.removeItemByKey(item.key, _data);
    this.trigger(_data);
  },

  copy: function(item) {
    
    var newItem = this.copyObj(item);
  
    this.insertAfterKey(newItem, item.key, _data);
    this.makeUniqueKeys(newItem);
    this.trigger(_data);
  },

  copyItems: function (items, key){
   
    var i = 0;
    while(i < items.length){
      for(var item of items[i]){
        var newItem = this.copyObj(item);

        this.insertAfterKey(newItem, key, _data);
        this.makeUniqueKeys(newItem);
      }
      i++;
    }
    
    this.trigger(_data);
  },

  copyCombinedItems: function (items, key){
    var i = 0;

    while(i < items.length){
      for(var page of items[i]){      
        if(page['children'] && page['children'].length > 0){
          for(var child of page['children']){
            
            var newItem = this.copyObj(child);
      
            this.insertInPage(newItem, key, _data);
            this.makeUniqueKeys(newItem);
          }
        }
      }
      i++;
    }
    
    this.trigger(_data);

  },

  copyTemplatesBlock: function (items, key){
    let i = 0;
    while(i < items.length){
      let newItem = this.copyObj(items[i]);
      this.insertAfterKey(newItem, key, _data);
      this.makeUniqueKeys(newItem);
      i++;
    }
    
    this.trigger(_data);
  },

  copyTemplatesBlockContent: function (items, key){
    let i = 0;
    while(i < items.length){
        if(items[i]['children'] && items[i]['children'].length > 0){
          for(var child of items[i]['children']){
            let newItem = this.copyObj(child);
            this.insertInto(newItem, key, _data, 'block');
            this.makeUniqueKeys(newItem);
          }
        }
      i++;
    }
    
    this.trigger(_data);

  },

  getData: function() {
    return _data;
  },

  setData: function(data) {
    _data = data;
    this.trigger(_data);
  },
  
  _updateOrder: function(elements) {
    _data = elements;
    this.trigger(_data);
  },
  
  getDefaultKey: function (name) {

      var index = 1;
      var tmp = name + '_' + index;
      let allKeys = this.getAllKeys(_data);
        for (var i = 0; i < allKeys.length; i++) {
            var item = allKeys[i];
            var tmp = name + '_' + index;
            if (item == tmp) {
                index++;
                i = -1;
            }
        }

        return tmp;
    },
    swzReplaceIndex: function(name){
     
      let res = '';
      for(var i = name.length - 1; i >= 0; i--){
        if(Number(name[i]) || name[i] == '_'){
          res = name[i] + res;
        }else{
          return name.replace(res, '');
        }
      }
      return name.replace(res, '');
    },
    swzGetDefaultKey: function (name) {
     
      var index = 1;//this.swzCheckNumber(name) !== 0 ? this.swzCheckNumber(name) + 1 : 1;
 
      var tmp = name + '_' + index;
      let allKeys = this.getAllKeys(_data);
      
        for (var i = 0; i < allKeys.length; i++) {
            var item = allKeys[i];
            var tmp = this.swzReplaceIndex(name) + '_' + index;
            if (item == tmp) {
                index++;
                i = -1;
            }
        }
  
        return tmp;
    },
    getAllKeys: function(items)
    {
      var res = [];
      if(items != undefined){
        for (var i = 0; i < items.length; i++) {
          var item = items[i];
          res.push(item.key);
          if(item.children != undefined){
            var childkeys = this.getAllKeys(item.children);
            res = res.concat(childkeys);
          }
          else if(item.placeholders != undefined){
            for(let ph in item.placeholders){
              if(Array.isArray(item.placeholders[ph])){
                let phkeys = this.getAllKeys(item.placeholders[ph]);
                res = res.concat(phkeys);
              }
            }
          }
        }
      }
      
      return res;
    },
    getAllNumberKeys: function(items, excludeKey)
    {
  
      var res = [];
      if(items != undefined){
        for (var i = 0; i < items.length; i++) {
          var item = items[i];
          if((item['data-buildertype'] == 'radiogroup' || item['data-buildertype'] == 'dropdown' || item.type == "number") && item.key !== excludeKey ){
            res.push(item.key);
          }
          if(item.children != undefined){
            var childkeys = this.getAllNumberKeys(item.children);
            res = res.concat(childkeys);
          }
        }
      }
      return res;
    },
    getByKey: function(key){
      return this.findItemByKey(key, _data);
    },
    isInput: function (type){
      if(type == "input" || type == "textarea"|| type == "checkbox" || type == "dropdown" || type == "radiogroup" || type =="formgroup" || type == "swztable"){
        return true
      }else{
          return false
      }
    },
    isRequiredInput: function (type){
      if(type == "input" || type == "textarea" || type == "dropdown" || type == "radiogroup"){
        return true
      }else
        return false
      
    },
    findItemByKey: function(key, items){
      for (var i = 0; i < items.length; i++) {
          var item = items[i];
          if(item.key == key)
            return item;
          else if(item.children != undefined){
            var res = this.findItemByKey(key, item.children);
            if(res != undefined)
              return res;
          }
          else if(item.placeholders != undefined){
            for(let ph in item.placeholders){
              if(Array.isArray(item.placeholders[ph])){
                var res = this.findItemByKey(key, item.placeholders[ph]);
                if(res != undefined)
                  return res;
              }
            }
          }
      }
      return undefined;
    },

    insertInto: function(insertItem, key, items, type){
      for (var i = 0; i < items.length; i++) {
          var item = items[i];
          if(item.key == key && item['data-buildertype'] === type)
          {
            if(item['children'] && item['children'].length > 0)
              item['children'].push(insertItem);
            else
              item['children'] = [insertItem];

            return true;
          }
          
          if(item.children !== undefined){
            if(this.insertInto(insertItem, key, item.children, type)){
              return true;
            }
          }
      }
      return undefined;
    },

    insertInPage: function(insertItem, key, items){
      for (var i = 0; i < items.length; i++) {
          var item = items[i];
          if(item.key == key && item['data-buildertype'] == "swzPage")
          {
            if(item['children'] && item['children'].length > 0)
              item['children'].push(insertItem);
            else
              item['children'] = [insertItem];

            return true;
          }
          
          if(item.children !== undefined){
            if(this.insertInPage(insertItem, key, item.children)){
              return true;
            }
          }

      }
      return undefined;
    },

    insertAfterKey: function(insertItem, key, items){
      for (var i = 0; i < items.length; i++) {
          var item = items[i];
          if(item.key == key)
          {
            items.splice(i+1, 0, insertItem);
            return true;
          }
          
          if(item.children !== undefined){
            if(this.insertAfterKey(insertItem, key, item.children)){
              return true;
            }
          }

          if(item.placeholders !== undefined){
            for(let ph in item.placeholders){
              if(Array.isArray(item.placeholders[ph])){
                if(this.insertAfterKey(insertItem, key, item.placeholders[ph])){
                  return true;
                }
              }
            }
          }
      }
      return undefined;
    },
    
    updateItemByKey: function(key, item){
      
      var data = this.getByKey(key);
      for(var i in item){
          data[i] = item[i];
      }
      
      if(key != item.key){
        this.replaceDepensKeys(key, item.key);
      }

      this.trigger(_data);
    },

    replaceDepensKeys: function(oldKey, newKey, items){
      if(items == undefined)
        items = _data;

      for (var i = 0; i < items.length; i++) {
          var item = items[i];
          if(Array.isArray(item["events-onclick-targets"])){
            var targets = item["events-onclick-targets"];
            for (var j = 0; j < targets.length; j++){
              if(targets[j] == oldKey)
                targets[j] = newKey;
            }  
          }

          if(item.children != undefined){
            this.replaceDepensKeys(oldKey, newKey, item.children);
          }

          if(item.placeholders !== undefined){
            for(let ph in item.placeholders){
              if(Array.isArray(item.placeholders[ph])){
                this.replaceDepensKeys(oldKey, newKey, item.placeholders[ph]);
              }
            }
          }
      }
    },
    removeItemByKey: function(key, items){
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        if(item.key == key){
          items.splice(i, 1);
          break;
        }
        
        if(item.children != undefined){
          this.removeItemByKey(key, item.children);
        }

        if(item.placeholders !== undefined){
          for(let ph in item.placeholders){
            if(Array.isArray(item.placeholders[ph])){
              this.removeItemByKey(key, item.placeholders[ph]);
            }
          }
        }
      }
    },

    swzHideAllByKeys: function(){
      var items = _data
      for (var i = 0; i < items.length; i++) {
          if(items[i].onpagedisplay == true){
            items[i]['onpagedisplay'] = false;  
        }
      }
    },

    swzOffScrollItemsByKeys: function(){
      var items = _data
        for (var i = 0; i < items.length; i++) {
          if(items[i].onscrolltoview){
            items[i]['onscrolltoview'] = false;  
        }
      }
    },

    swzHideItemByKey: function(key, items){
    
      for (var i = 0; i < items.length; i++) {
        if(items[i].key == key){
          if(items[i].onpagedisplay == true){
            items[i]['onpagedisplay'] = false;
            break;
          }
        }
      }
    },

    swzShowAllByKeys: function(){
      var items = _data
      for (var i = 0; i < items.length; i++) {
          if(items[i].onpagedisplay == false){
            items[i]['onpagedisplay'] = true;  
        }
      }
    },
    
    swzShowItemByKey: function(key, items){
      
      for (var i = 0; i < items.length; i++) {
        if(items[i].key == key){
          if(items[i].onpagedisplay == false){
            items[i]['onpagedisplay'] = true;
          }
          if(!items[i].onscrolltoview){
            items[i]['onscrolltoview'] = true;
          }
        }
      }
    },
    
    copyObj(obj) {
      if (null == obj || "object" != typeof obj) return obj;
      var copy = obj.constructor();
      
      for (var attr in obj) {
          if (obj.hasOwnProperty(attr)) copy[attr] = this.copyObj(obj[attr]);
      }
      return copy;
    },

    makeUniqueKeys(obj){
      var me = this;
      var key = obj.key;
      let allKey = this.getAllKeys(_data);
      if(key != undefined && allKey != undefined){
        //appear once consider is unique
        if(allKey.indexOf(key) != -1){
          let firstKeyFound = allKey.indexOf(key);
          //appear twice must solve for duplicate
          if(allKey.indexOf(key, firstKeyFound + 1) != -1){
            obj.key = this.swzGetDefaultKey(key);
          }
        }
      }

      if(Array.isArray(obj.children)){
        obj.children.forEach(function(c){
          me.makeUniqueKeys(c);
        });
      }

      if(obj.placeholders !== undefined){
        for(let ph in obj.placeholders){
          if(Array.isArray(obj.placeholders[ph])){
            obj.placeholders[ph].forEach(function(c){
              me.makeUniqueKeys(c);
            });
          }
        }
      }
    },

    print(){
      console.log("Get form data", this.getData());
    }
});

module.exports = CloverStore;