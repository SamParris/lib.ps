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

#Region ---- Set Custom Prompt ----
Function Global:Prompt {
    [CmdletBinding()]
    Param()
    Process {
        $LASTSUCCESS = $?
        If ((New-Object Security.Principal.WindowsPrincipal(
                    [Security.Principal.WindowsIdentity]::GetCurrent())
            ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Host "ADMIN::" -ForegroundColor Black -BackgroundColor Red -NoNewline
        }
        Write-Host "$('{0:d4}' -f $MyInvocation.HistoryId)>" -ForegroundColor Black -BackgroundColor Yellow -NoNewline
        If ((Get-History).Count -ge 1) {
            $CommandTimeSpan = (New-TimeSpan -Start (Get-History -Count 1).StartExecutionTime -End (Get-History -Count 1).EndExecutionTime).TotalMilliseconds
            Write-Host ">$CommandTimeSpan>" -ForegroundColor Black -BackgroundColor DarkGray -NoNewline
        }
        If ((Get-Location -Stack).Count -ge 1) {
            $StackLocation = (Get-Location -Stack).Count
            Write-Host ">$StackLocation>" -ForegroundColor Black -BackgroundColor White -NoNewline
        }
        If ((Get-PSSession).Count -ge 1) {
            $PSSessionCount = (Get-PSSession).Count
            Write-Host ">$PSSessionCount>" -ForegroundColor Black -BackgroundColor Green -NoNewline
        }
        If ($DefaultVIServers) {
            Write-Host ">$($DefaultVIServers.Name)>" -ForegroundColor Black -BackgroundColor Green -NoNewline
        }
        If ($LASTSUCCESS -eq $false) {
            $LastSuccessColour = "Red"
        }
        Else {
            $LastSuccessColour = "Cyan"
        }
        Write-Host ">$PWD>" -ForegroundColor Black -BackgroundColor $LastSuccessColour -NoNewline
        Return " "
    }
}
#EndRegion ---- Set Custom Prompt ----

#Region ---- Import Modules ----
Import-Module Terminal-Icons
#EndRegion ---- Import Modules ----

#Region ---- Configure PSDrives ----
$LibPath = (Split-Path $PSScriptRoot -Parent)
New-PSDrive -Name LibPath -PSProvider FileSystem -Root $LibPath | Out-Null
#EndRegion ---- Configure PSDrives ----

#Region ---- Import Custom Function Libraries ----
$PublicFunctionFiles = [System.IO.Path]::Combine($LibPath, "Function Libraries", "*.ps1")

Get-ChildItem -Path $PublicFunctionFiles |
ForEach-Object {
    Try {
        . $_.FullName
    }
    Catch {
        Write-Warning "$($_.Exception.Message)"
    }
}
#EndRegion ---- Import Custom Function Libraries ----

#Region ---- Set PSReadLine Options ----
$PSReadLineOptions = @{
    Colors              = @{
        Default          = "#FFFFFF"
        Comment          = "#696969"
        Keyword          = "#27e797"
        String           = "#caa56d"
        Operator         = "#FFFFFF"
        Variable         = "#86c4ec"
        Command          = "#ec7c7c"
        Parameter        = "#5FB3B3"
        Type             = "#696969"
        Number           = "#696969"
        Member           = "#eeee99"
        InlinePrediction = "#D3D3D3"
    }
    PredictionSource    = "History"
    HistoryNoDuplicates = $true
    ShowToolTips        = $true
}

Set-PSReadLineOption @PSReadLineOptions
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
#EndRegion ---- Set PSReadLine Options ----

#Region ---- Set Working Directory ----
Set-Location LibPath:
#EndRegion ---- Set Working Directory ----

#EndRegion Profile.ps1