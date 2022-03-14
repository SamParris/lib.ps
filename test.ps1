$PSScriptRoot

Set-Alias -Name watch -Value Set-Location

Split-Path $PSScriptRoot -Parent

 Split-Path (Split-Path $PSScriptRoot)

 $libPath = $PSScriptRoot.Replace("\Profile", "")

 $libPath

 $ConfigProfilePath = [System.IO.Path]::Combine($PSScriptRoot,"Profile","Profile.ps1")

 $ConfigProfilePath
