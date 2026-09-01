import CloverStore from './store';

const helpers = {

  _swzGetData: function() {
    let formData;
    formData = CloverStore.getData();
    return formData
  },

  isInputControl: function(type) {
    if(type == "input" || type == "textarea"|| type == "checkbox" || type == "dropdown" || type == "radiogroup")
      return true
      
    return false
  },
  
  isContainer: function(type) {
    if(type == "swzPage" || type == "block" || type == "swzTable")
      return true
  
      return false  
  },

  newGuid: function() {
    function s4() {
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
      s4() + '-' + s4() + s4() + s4();
  },

  //Get Model Properties
  getModelProperty: function(data, target) {  
    if(!(data !== null && data !== undefined) && data.length > 0)
      return
    var property = {};
   
    var getProperty = function(data, target){
      let found = false;

      for(let control of data){
        if(control['key'] == target){
          found = true
          property = control;
          return property
        }
        if(control.children !== undefined && control.children.length > 0){
          property = getProperty(control.children, target);
          if(found)
            return property
        }
      }
      return property
    }

    var property = getProperty(data, target);
    return property
  },

  //Get Radio Options
  getModelOptions: function(data, target) {  
    if(!(data !== null && data !== undefined) && data.length > 0)
      return

    var getOptions = function(data, target){
      var options = [];
      var found = false;

      for(let control of data){
        if(control['key'] == target){
          found = true;
          return control['data-elements']
        }
        if(control.children !== undefined && control.children.length > 0){
          let cs = getOptions(control.children, target);
          options = options.concat(cs);
          if(found)
            return options
    
        }
      }
      return options
    }

    var options = getOptions(data, target);
    return options
  },

  getModelType: function(control) {
    let type;
        if(control['type'] !== undefined){
          type = control['type']
        }else{
          //hardcode 101019
          if(control['data-buildertype'] == 'radiogroup' || control['data-buildertype'] == 'dropdown'){
            type = 'radiogroup'
          }else{
            type = control['data-buildertype']
          }
        }
        return type
  },

  parse_query_string: function(query) {
    var vars = query.split("&");
    var query_string = {};
    for (var i = 0; i < vars.length; i++) {
      var pair = vars[i].split("=");
      var key = decodeURIComponent(pair[0]);
      var value = decodeURIComponent(pair[1]);
      // If first entry with this name
      if (typeof query_string[key] === "undefined") {
        query_string[key] = decodeURIComponent(value);
        // If second entry with this name
      } else if (typeof query_string[key] === "string") {
        var arr = [query_string[key], decodeURIComponent(value)];
        query_string[key] = arr;
        // If third or later entry with this name
      } else {
        query_string[key].push(decodeURIComponent(value));
      }
    }
    return query_string;
  },
  
  onConfirmedSave: function(applyControls, applyType, applyCond, applyItem ){

    if(applyCond !== null && applyCond !== '' && applyCond !== undefined){
      applyItem[applyType] = applyCond;    
    }else{
      applyItem[applyType] = "";
    }
    CloverStore.updateItemByKey(applyControls, applyItem);
  },
 
  isEmpty: function(obj){
    return !obj || Object.keys(obj).length === 0;
  }
}
  
  export default helpers;