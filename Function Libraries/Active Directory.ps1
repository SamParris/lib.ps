#Region Active Directory.ps1

<#
.SYNOPSIS
    Active Directory.ps1
.DESCRIPTION
    This file holds all of my custom Active Directory functions.
    This is imported into the PowerShell session when Profile.ps1 runs.
.NOTES

#>

## - Initial Startup Commands.
# - PSScriptAnalyzer - Ignore use of Unapproved Verbs for the contents of this file.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param()

# - Copy Group Members From One Group To Another.
Function Sam.AD-CopyGroupMember {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0)]$SourceGroup,

        [Parameter(Mandatory = $true,
            Position = 1)]$DestinationGroup
    )
    Begin {
        $Credentials = Get-Credential
    }
    Process {
        $SourceMembers = Get-ADGroupMember -Identity $SourceGroup

        ForEach ($Member in $SourceMembers) {
            Try {
                Add-ADGroupMember -Identity $DestinationGroup -Members $Member.SamAccountName -Credential $Credentials
                Write-Host "[-] Adding $($Member.SamAccountName) to $DestinationGroup" -ForegroundColor Cyan
            }
            Catch {
                Write-Error "[X] $($_.Exception.Message)"
            }
        }
    }
}

# - Get Members Of An AD Group.
Function Sam.AD-GetGroupMembers {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 1)]$ADGroup
    )
    Process {
        Get-ADGroupMember -Identity $ADGroup | Select-Object Name, SamAccountName | Sort-Object Name
    }
}

# - Get Users AD Groups.
Function Sam.AD-GetGroupMembership {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0)]$UserName
    )
    Process {
        Get-ADPrincipalGroupMembership -Identity $UserName | Select-Object Name | Sort-Object Name
    }
}

# - Create New AD Security Group.
Function Sam.AD-NewSecurityGroup {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            Position = 0)]$Name,

        [Parameter(Mandatory = $false,
            Position = 1)]$Description
    )
    Begin {
        $Credentials = Get-Credential
    }
    Process {
        $GroupParams = @{
            Name           = $Name
            SamAccountName = $Name
            Description    = $Description
            GroupCategory  = 'Security'
            GroupScope     = 'Global'
            Path           = "OU=Generic-Security Groups,OU=ORG,DC=invotec-uk,DC=com"
            Credential     = $Credentials

        }

        Try {
            New-ADGroup @GroupParams
        }
        Catch {
            Write-Error "[X] $($_.Exception.Message)"
        }
    }
}
#EndRegion Active Directory.ps1