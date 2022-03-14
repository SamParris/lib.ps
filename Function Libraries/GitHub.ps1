#Region GitHub.ps1

<#
.SYNOPSIS
    GitHub.ps1
.DESCRIPTION
    This file holds all of my custom Active Directory functions.
    This is imported into the PowerShell session when Profile.ps1 runs.
.NOTES

#>

## - Initial Startup Commands.
# - PSScriptAnalyzer - Ignore use of Unapproved Verbs for the contents of this file.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param()

# - Show Git Log.
Function Sam.Git-ShowLog {
	[CmdletBinding()]
	Param()
	Process {
		#git log --oneline --graph --decorate
		git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
	}
}

# - Show Git Status.
Function Sam.Git-ShowStatus {
	[CmdletBinding()]
	Param()
	Process {
		git status
	}
}

# - Git Add, Commit and Push.
Function Sam.Git-AddCommitPush {
	[CmdletBinding()]
	Param(
		[Parameter()]$CommitMessage = "Auto Git Update."
	)
	Begin {
		$WriteColour = @{
			ForegroundColor = 'Cyan'
		}
		$CurrentLocation = Get-ChildItem -Force | Where-Object { $_.FullName -like "*.git" -and $_.Mode -match 'h' }
	}
	Process {
		If ($null -eq $CurrentLocation) {
			Write-Host "[X] This is not a Git Repo" -ForegroundColor Red
		}
		Else {
			Write-Host "[-] Adding all changed files" @WriteColour
			git add .
			Write-Host "[-] Commiting files: $CommitMessage" @WriteColour
			git commit -m $CommitMessage
			Write-Host "[-] Pushing changes to repo" @WriteColour
			git push
		}
	}
}

Function Sam.Git-UpdateRepos {
	[CmdletBinding()]
	Param()
	Begin {
		$OriginalLocation = (Get-Location).Path
		$GitRepos = Get-ChildItem -Recurse -Force | Where-Object { $_.FullName -like "*.git" -and $_.Mode -match 'h' }
		Write-Host "[-] Searching for Git Repos" -ForegroundColor Cyan
	}
	Process {
		If ($null -eq $GitRepos) {
			Write-Host "[X] No Git Repos found in current location." -ForegroundColor Red
		}
		Else {
			ForEach ($Repo in $GitRepos) {
				$RepoPath = Split-Path -Path $Repo -Parent
				Set-Location -Path $RepoPath
				Write-Host "[+] Updating Repo: $($RepoPath)" -ForegroundColor Green
				git pull
			}
		}
	}
	End {
		Set-Location -Path $OriginalLocation
	}
}

#EndRegion GitHub.ps1