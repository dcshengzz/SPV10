webpack
copy build/swz-useradmin.js ../swz.Clover.StarterApplication/wwwroot/scripts/swz-useradmin.js

$loc = Get-Location

Set-Location -Path "../swz.Clover.StarterApplication/"

webpack

Set-Location -Path $loc
