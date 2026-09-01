import React from "react";
import ReactDOM from "react-dom";
import CloverAdmin from "./src/admin";

const superAdminRole = 'Admins';

ReactDOM.render(
  <CloverAdmin 
    apiUrl="http://localhost:48800/configapiuseradmin"
    imageFolder="/images/"
    headerLogo="/images/surveyplus.png"
    superAdminRoles={[superAdminRole]} //Exclude this role in system
    deltaWidth={0}
    deltaHeight={0}
    returnToAppUrl="/"
/>,
  document.getElementById('formadmin')
)

$(document).ajaxStart(function() { Pace.restart(); });
