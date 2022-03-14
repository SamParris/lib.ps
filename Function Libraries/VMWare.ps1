#Region VMWare.ps1

<#
.SYNOPSIS
    VMWare.ps1
.DESCRIPTION
    This file holds all of my custom VMWare functions.
    This is imported into the PowerShell session when Profile.ps1 runs.
.NOTES

#>

## - Initial Startup Commands.
# - PSScriptAnalyzer - Ignore use of Unapproved Verbs for the contents of this file.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param()

# - Connect to vCenter
Function Sam.VMWare-Connect {
	[CmdletBinding()]
	Param(
		[Parameter()]$ServerName = '10.20.2.30'
	)
	Begin {
		$ErrorActionPreference = 'Stop'
		$VIServerCredentials = Get-Credential
	}
	Process {
		$ConnectionParams = @{
			Server     = $ServerName
			Credential = $VIServerCredentials
		}
		Try {
			Connect-VIServer @ConnectionParams | Out-Null
		}
		Catch {
			Write-Error "[X] $($_.Exception.Message)"
		}
	}
}

#EndRegion VMWare.ps1