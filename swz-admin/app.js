import React from "react";
import ReactDOM from "react-dom";
import CloverAdmin from "./src/admin";

var actions= ["validate", 
'refresh', 
'save', 
'saveandexit', 
'cancel', 
'recalc',
'add',
'edit',
'delete',
'confirm',
'gridEdit',
'gridDelete',
'gridCopy',
'gridAdd'];


ReactDOM.render(
  <CloverAdmin 
    apiUrl="http://localhost:48800/configapiuseradmin"
    workflowApi="http://localhost:48800/workflow/designerapi"
    imageFolder="/images/"
    localizationFolder="/localization/"
    /*locale="ru"*/
    deltaWidth={0}
    deltaHeight={0}
    controlActions={actions}
    returnToAppUrl="/"
    userName="Dmitry Melnikov" />,
  document.getElementById('formadmin')
)

$(document).ajaxStart(function() { Pace.restart(); });
