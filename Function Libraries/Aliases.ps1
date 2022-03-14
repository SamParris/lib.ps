#Region Aliases.ps1

<#
.SYNOPSIS
    Aliases.ps1
.DESCRIPTION
    This file holds all of my custom PowerShell Aliases.
    This is imported into the PowerShell session when Profile.ps1 runs.
.NOTES

#>

# - Custom PS Aliases.
Set-Alias -Name Notepad -Value "${ENV:ProgramFiles}\Notepad++\notepad++.exe" -Description "Change Notepad alias to open Notepad++"
Set-Alias -Name VS -Value code
Set-Alias -Name Push -Value Push-Location
Set-Alias -Name Pop -Value Pop-Location
Set-Alias -Name Open -Value Sam.Open-Here
Set-Alias -Name SU -Value Sam.PowerShell-RunAs
Set-Alias -Name Ping -Value Sam.Test-Connection
#EndRegion Aliases.ps1