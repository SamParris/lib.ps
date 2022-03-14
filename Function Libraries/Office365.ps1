#Region Office365.ps1

<#
.SYNOPSIS
    Office365.ps1
.DESCRIPTION
    This file holds all of my custom Office365 functions.
    This is imported into the PowerShell session when Profile.ps1 runs.
.NOTES

#>

## - Initial Startup Commands.
# - PSScriptAnalyzer - Ignore use of Unapproved Verbs for the contents of this file.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param()

# - Connect to Exchange Online
Function Sam.Office365-Connect {
	[CmdletBinding()]
	Param()
	Process {
		Connect-ExchangeOnline -UserPrincipalName 'Sam.Parris@amphenol-invotec.com'
	}
}

#EndRegion Office365.ps1