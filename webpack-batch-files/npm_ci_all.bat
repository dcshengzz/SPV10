REM instaling modules for swz-admin
cd %SURVEYPLUS_PROJECT_ROOT%\swz-admin && call npm ci
REM installing modules for swz-useradmin
cd %SURVEYPLUS_PROJECT_ROOT%\swz-useradmin && call npm ci
REM installing modules for swz-builder
cd %SURVEYPLUS_PROJECT_ROOT%\swz-builder && call npm ci
REM installing modules for swz-survey-admin
cd %SURVEYPLUS_PROJECT_ROOT%\swz-survey-admin && call npm ci
REM installing modules for swz-survey-builder
cd %SURVEYPLUS_PROJECT_ROOT%\swz-survey-builder && call npm ci
REM installing modules for swz-help
cd %SURVEYPLUS_PROJECT_ROOT%\swz-help && call npm ci
REM installing modules for swz-app
cd %SURVEYPLUS_PROJECT_ROOT%\swz-app && call npm ci
REM installing modules for swz.SurveyPlus.IntranetWeb
cd %SURVEYPLUS_PROJECT_ROOT%\swz.SurveyPlus.IntranetWeb && call npm ci
REM installing modules for swz.SurveyPlus.InternetWeb
cd %SURVEYPLUS_PROJECT_ROOT%\swz.SurveyPlus.InternetWeb && call npm ci
REM Finished installing modules
cd %SURVEYPLUS_PROJECT_ROOT%\webpack-batch-files

