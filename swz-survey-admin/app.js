import React from "react";
import ReactDOM from "react-dom";
import CloverAdmin from "./src/admin";

var actions = [
  "validate",
  "refresh",
  "save",
  "saveandexit",
  "cancel",
  "recalc",
  "add",
  "edit",
  "delete",
  "confirm",
  "gridEdit",
  "gridDelete",
  "gridCopy",
  "gridAdd",
];

ReactDOM.render(
  <CloverAdmin
    surveyApi="/resp/data"
    apiUrl="http://localhost:48800/configapiuseradmin"
    workflowApi="http://localhost:48800/workflow/designerapi"
    ruleApi="http://localhost:48800/datavalidationrule/getrulelist"
    cssStyleApi="http://localhost:48800/customcssstyle/getstylelist"
    surveyFormApi="http://localhost:48800/surveyform/getsurveyformlist"
    surveyFormNameApi="http://localhost:48800/surveyform/issurveyformnameexist"
    fileStorageApi="http://localhost:48800/fileStorage/getUploadedFilelist"
    downloadFileUrl="/data/file/download/"
    viewFileUrl="/data/file/view/"
    imageFolder="/images/"
    localizationFolder="/localization/"
    /*locale="ru"*/
    deltaWidth={0}
    deltaHeight={0}
    controlActions={actions}
    returnToAppUrl="/"
    /*userName="Ben"*/
  />,
  document.getElementById("formadmin")
);

$(document).ajaxStart(function () {
  Pace.restart();
});
