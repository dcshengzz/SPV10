import React from 'react'
import { render } from 'react-dom'
import CloverAdmin from './../../scripts/swz-survey-admin.js'

let globalActions = [
    'validate',
    'save',
    'redirect',
    'confirm',
    'swzSave',
    'swzPrint',
    'swzReturnBackHome',
    'swzValidate',
    'swzSilentSave',
    'swzExit',
    'swzSinglePageValidate',
    'swzPageInit',
    'swzItemClick',
    'swzNext',
    'swzBack',
    'swzClearRadio',
    'swzPageValidationStatus',
    'applyServerDateTime',
    'applyLatLong',
    'applyIpAddress',
    'swzSubmit',
    'swzReturnToPreviousPage',
    'swzReturnToStart'];
    

//Additional globalActions: 'createElement', 'refresh', 'exit', 'apply', 'save' 

render(
    <CloverAdmin
        surveyApi="/resp/data"
        apiUrl="/ConfigAPIUserAdmin"
        ruleApi="/datavalidationrule/getrulelist"
        cssStyleApi="/customcssstyle/getstylelist"
        surveyFormApi="/surveyform/getsurveyformlist"
        surveyFormNameApi="/surveyform/issurveyformnameexist"
        fileStorageApi="/fileStorage/getUploadedFilelist"
        workflowApi="/workflow/designerapi"
        imageFolder="/images/"
        downloadFileUrl="/data/file/download/"
        viewFileUrl="/data/file/view/"
        localizationFolder="/localization/"
        deltaWidth={0}
        deltaHeight={0}
        controlActions={globalActions}
        returnToAppUrl="/form/SwzQnnList"
    />,
    document.getElementById('content')
);




