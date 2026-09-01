REM Build the clientside app for IntranetWeb
call %SURVEYPLUS_PROJECT_ROOT%\webpack-batch-files\copy_admin.bat
call %SURVEYPLUS_PROJECT_ROOT%\webpack-batch-files\copy_app.bat
call %SURVEYPLUS_PROJECT_ROOT%\webpack-batch-files\copy_useradmin.bat
call %SURVEYPLUS_PROJECT_ROOT%\webpack-batch-files\copy_surveyadmin.bat
call %SURVEYPLUS_PROJECT_ROOT%\webpack-batch-files\copy_help.bat

REM Webpack does its best now and is preparing. Please watch warmly until it is ready
start webpack_intranetweb.bat
cd %SURVEYPLUS_PROJECT_ROOT%\webpack-batch-files
