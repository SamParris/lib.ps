#Region Profile.ps1

<#
.SYNOPSIS
    Profile.ps1
    Loads all my custom PS Items.
.DESCRIPTION
    This is the 'Master' loader for the lib.ps PowerShell Environment.


.EXAMPLE

.NOTES

#>

#Parameters
$ErrorActionPreference = "Continue"

#Region ---- Configure PSDrives ----
$LibPath = (Split-Path $PSScriptRoot -Parent)
New-PSDrive -Name LibPath -PSProvider FileSystem -Root $LibPath | Out-Null
#EndRegion ---- Configure PSDrives ----

#Region ---- Import Custom Function Libraries ----
$PublicFunctionFiles = [System.IO.Path]::Combine($LibPath,"Function Libraries","*.ps1")

Get-ChildItem -Path $PublicFunctionFiles |
    ForEach-Object {
        Try {
            . $_.FullName
        } Catch {
            Write-Warning "$($_.Exception.Message)"
        }
    }
#EndRegion ---- Import Custom Function Libraries ----

#EndRegion Profile.ps1