REM Webpack clientside applications for IntranetWeb as per its webpack.config (doesn't compile the .net codes)
cd %SURVEYPLUS_PROJECT_ROOT%\swz.SurveyPlus.IntranetWeb && call npx webpack --progress
cd %SURVEYPLUS_PROJECT_ROOT%\webpack-batch-files

