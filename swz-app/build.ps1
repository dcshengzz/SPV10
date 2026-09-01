webpack
copy build/swz-app.js ../swz.Clover.StarterApplication/wwwroot/scripts/swz-app.js

$loc = Get-Location

Set-Location -Path "../swz.Clover.StarterApplication/"

webpack

Set-Location -Path $loc
