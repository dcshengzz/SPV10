import React from "react";
import ReactDOM from "react-dom";
import CloverFormBuider from "./src/builder";
import CloverForm from "./src/form";

var data = {
  title: "Request 1",
  firstname: "Ivan",
  lastname: "Ivanov",
  type: 2,
  comment: "Hello, World!\n\nПривет, Мир!"
}

function getform(formname)
{
  var formurl = "/" + formname + ".json";
  var source = $.ajax({
    url: formurl,
    async: false,
  }).responseJSON;
  return source;
}

function getformlist()
{
  return ['invoiceform', 'projectform'];
}

function getAdditionalDataForControl(control,
    {startIndex, pageSize, filters, sort, model},
    callback)
  {
    var me = this;
    if(control.props["data-buildertype"] == "dictionary"){
      if(model == undefined){
        model = "item";
      }  
      var items = [];
        for(var i = 0 ; i < 3; i++){
          var obj = {};
          obj.key = model + "_" + i;
          obj.text = model + "_" + i;
          obj.value = i;
          items.push(obj);
        }
        callback({items});
    }
    else{
      var rowsCount = 5;
      var items = [];
      for(var i = 0 ; i < pageSize; i++){
        var obj = {};
        control.props.columns.forEach(function(c){
          obj[c.key] = c.key + "_" + (Number(startIndex) + Number(i));
        });
        items.push(obj);
      }
      callback({startIndex, pageSize, rowsCount, items});
    }
  }

function eventProcess(obj, p)
{
  console.log("Event from form:", obj, p);
}

function eventErrProcess(obj, message){
  alert("Error from the form: " + message);
}

if(QueryString.form != undefined){ 

  var formurl = "/" + QueryString.form + ".json";
  var dataurl = "/" + QueryString.form + "-data.json";

  ReactDOM.render(
    <CloverForm 
      modelsrc={formurl} 
      datasrc={dataurl} 
      eventFunc={eventProcess} 
      eventErrFunc={eventErrProcess}
      getFormFunc={getform} />,
    document.getElementById('formbuilder')
  )
}
else{

  var actions= ["validate", 
  'refresh', 
  'save', 
  'saveandexit', 
  'cancel', 
  'recalc',
  'add',
  'edit',
  'delete',
  'gridEdit',
  'gridDelete',
  'gridCopy',
  'gridAdd'];

  var templates = ["template1"];

  //TODO - how to pass this all the way down properly?
  window.RulesModalConfig =  { rulesApi: "http://localhost:48800/rules/get" };

  ReactDOM.render(
    <CloverFormBuider 
      showHeader={true}
      actions={actions} 
      getFormFunc={getform} 
      getFormFist={getformlist}
      getAdditionalDataForControl={getAdditionalDataForControl}
      //defaultForm="invoiceform"
      //downloadUrl="/download.html?file=" 
      //uploadUrl="/upload.html?file="
      downloadUrl="http://localhost:48800/data/download/"
      uploadUrl="http://localhost:48800/data/upload/"
      /*rulesApi="http://localhost:48800/rules/get"*/
      templates={templates} />,
    document.getElementById('formbuilder')
  )
}