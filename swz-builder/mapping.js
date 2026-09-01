import React from "react";
import ReactDOM from "react-dom";
import CloverFormTestMappging from "./src/testmapping";

function getform(formname)
{
  var formurl = "/" + formname + ".json";
  var source = $.ajax({
    url: formurl,
    async: false,
  }).responseJSON;
  return source;
}

function eventProcess(obj, p)
{
  console.log("Event from form:", obj, p);
}

function eventErrProcess(obj, message){
  alert("Error from the form: " + message);
}

var formurl = "/testmapping.json";
var dataurl = "/testmapping-data.json";

ReactDOM.render(
  <CloverFormTestMappging 
    modelurl={formurl} 
    dataurl={dataurl} 
    eventFunc={eventProcess} 
    eventErrFunc={eventErrProcess}
    getFormFunc={getform} />,
  document.getElementById('container')
);
