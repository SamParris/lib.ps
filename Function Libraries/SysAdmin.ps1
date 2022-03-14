#Region SysAdmin.ps1

<#
.SYNOPSIS
    SysAdmin.ps1
.DESCRIPTION
    This file holds all of my custom SysAdmin functions.
    This is imported into the PowerShell session when Profile.ps1 runs.
.NOTES

#>

## - Initial Startup Commands.
# - PSScriptAnalyzer - Ignore use of Unapproved Verbs for the contents of this file.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param()

# - Create New Folder in Current Location.
Function Sam.New-Folder {
	[CmdletBinding()]
	Param(
		[Parameter()]$FolderName = "MyNewFolder",
		[Switch]$MoveToLocation
	)
	Process {
		New-Item -ItemType Directory -Name $FolderName
		If ($MoveToLocation.IsPresent) {
			Set-Location -Path (Join-Path $PWD $FolderName)
		}
	}
}

# - Create New File in Current Location.
Function Sam.New-File {
	[CmdletBinding()]
	Param(
		[Parameter()]$FileName = "MyNewFile.txt",
		[Switch]$OpenFile
	)
	Process {
		New-Item -ItemType File -Name "$FileName"
		If ($OpenFile.IsPresent) {
			Code $FileName
		}
	}
}

# - Open Current Working Directory.
Function Sam.Open-Here {
	[CmdletBinding()]
	Param()
	Process {
		Invoke-Item $PWD
	}
}

# - Open New PowerShell (or Core) Terminal as Admin.
Function Sam.PowerShell-RunAs {
	[CmdletBinding()]
	Param(
		[Switch] $WindowsPowerShell,
		[switch] $NotAdmin
	)
	Begin {
		$Params = @{
			FilePath = 'pwsh'
			Verb     = 'RunAs'
		}
		If ($WindowsPowerShell.IsPresent) {
			$Params['FilePath'] = 'PowerShell'
		}
		If ($NotAdmin.IsPresent) {
			$Params.Remove('Verb')
		}
	}
	Process {
		Start-Process @Params
	}
}

# - Test RDP Connection.
Function Sam.Test-Connection {
	[CmdletBinding()]
	Param(
		[Parameter()] $ServerName,
		[Parameter()] $Port = 'RDP',
		[Parameter()] [int] $Count = 5
	)
	Begin {
		$ErrorActionPreference = 'Stop'
		$Port = Switch ($Port) {
			'RDP' { 3389 }
		}
		$Params = @{
			ComputerName = $ServerName
			Port         = $Port
		}
	}
	Process {
		Write-Host "[-] Testing Connection to $ServerName on $Port" -ForegroundColor Cyan
		$Loop = 0
		Do {
			Try {
				$Connection = Test-NetConnection @Params
				$Loop ++
				If ($Connection.TcpTestSucceeded -eq $true) {
					Write-Host "[+] Test Connection Successful" -ForegroundColor Green
				}
				Else {
					Write-Host "[X] Test Connection Failed" -ForegroundColor Red
				}
			}
			Catch {
				Write-Error "[X] $($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)."
			}
			Start-Sleep -Seconds 2
		} Until ($Loop -eq $Count)
	}
}

#EndRegion SysAdmin.ps1