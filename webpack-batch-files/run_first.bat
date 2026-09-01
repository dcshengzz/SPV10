REM webpack the base clientside projects
REM please ensure you have npm ci all sub projects before running this the first time 
start call webpack_admin.bat
start call webpack_useradmin.bat
start call webpack_builder.bat
start call webpack_surveyadmin.bat
start call webpack_surveybuilder.bat
start call webpack_help.bat

