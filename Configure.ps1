#Region Configure.ps1

<#
.SYNOPSIS
    Configure.ps1
    Configures my custom PowerShell Environment.
.DESCRIPTION
    Once executed, this file will setup and configure the initial files required for my PowerShell Environment.

    - Dot Source my custom Profile.ps1 into $Profile.CurrentUserAllHosts
    - Setup my Git Repos

.EXAMPLE
    PS C:\> . C:\Home\GitHub\lib.ps\Configure.ps1
.NOTES

#>

#Parameters
$ErrorActionPreference = "Continue"

#Region ---- Dot Source Profile ----
$PowerShellProfile = $Profile.CurrentUserAllHosts

If (Test-Path $PowerShellProfile) {
    Try {
        $ConfigProfilePath = [System.IO.Path]::Combine($PSScriptRoot, "Profile", "Profile.ps1")
        $Pattern = ". `"$ConfigProfilePath`""
        $IsAlreadyReferenced = Get-Content $PowerShellProfile | Select-String -SimpleMatch $Pattern

        If (-Not($IsAlreadyReferenced)) {
            Try {
                Write-Host "[!] Amending $($PowerShellProfile) to .Config Profile" -ForegroundColor Yellow
                $Pattern | Out-File -FilePath $PowerShellProfile -Append -Force -Encoding ascii
            }
            Catch {
                Write-Error "[X] $($_.Exception.Message)"
            }
        }
    }
    Catch {
        Write-Error "[X] $($_.Exception.Message)"
    }
}
Else {
    Try {
        Write-Host "[-] Creating Profile at location: $($PowerShellProfile)" -ForegroundColor Cyan
        New-Item -Path $PowerShellProfile -ItemType File -Force | Out-Null
        $ConfigProfilePath = [System.IO.Path]::Combine($PSScriptRoot, "Profile", "Profile.ps1")
        $Pattern = ". `"$ConfigProfilePath`""
        $Pattern | Out-File -FilePath $PowerShellProfile -Force -Encoding ascii
    }
    Catch {
        Write-Error "[X] $($_.Exception.Message)"
    }
}
#EndRegion ---- Dot Source Profile ----

#Region ---- Setup Git Repos ----
$PSGitRepos = @(
    'SamParris/PS_SysAdmin'
    'SamParris/PS_VMWare'
)

Push-Location (Split-Path $PSScriptRoot -Parent)

ForEach ( $Repo in $PSGitRepos) {
    Try {
        git clone https://github.com/$Repo.git
    }
    Catch {
        Write-Error "[X] $($_.Exception.Message)"
    }

}

Pop-Location
#EndRegion ---- Setup Git Repos ----

#EndRegion Configure.ps1