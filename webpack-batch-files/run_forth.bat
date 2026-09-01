REM Build the clientside app for InternetWeb

xcopy %SURVEYPLUS_PROJECT_ROOT%\swz-app\build\swz-app.js %SURVEYPLUS_PROJECT_ROOT%\swz.SurveyPlus.InternetWeb\wwwroot\scripts /Y &
xcopy %SURVEYPLUS_PROJECT_ROOT%\swz-survey-admin\build\swz-survey-admin.js %SURVEYPLUS_PROJECT_ROOT%\swz.SurveyPlus.InternetWeb\wwwroot\scripts /Y &
xcopy %SURVEYPLUS_PROJECT_ROOT%\swz-help\build\swz-help.js %SURVEYPLUS_PROJECT_ROOT%\swz.SurveyPlus.InternetWeb\wwwroot\scripts /Y

start webpack_internetweb.bat
