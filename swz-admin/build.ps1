webpack
copy build/swz-admin.js ../swz.Clover.StarterApplication/wwwroot/scripts/swz-admin.js

$loc = Get-Location

Set-Location -Path "../swz.Clover.StarterApplication/"

webpack

Set-Location -Path $loc
