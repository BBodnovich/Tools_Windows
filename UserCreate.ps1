# Use Case
# Create a new user account based on minimal prompts
# Create's Active Directory and Exchange Online account in Hybrid Exchange environment
# Sets all necessary details in both Active Directory and Exchange

# NOTE
# This script was trimmed down to only include 5 Organizatoinal Units
# The environment ran in had nearly 40 Organizational Units
# I trimmed the script down to make it easier to parse and see the fundamentals


# Script Functions
function Get-UserOrg {
    while ($true) {
        $orgPrompt = Read-Host -Prompt "`nType 'Help' for a list of Organization Units `nWhat is the user's organizational unit?      "

        if ($orgPrompt -eq "Help") {
            Write-Host "$userOrg"
        } 
        else {
            return $orgPrompt.ToUpper()
        }
    }
}


function GeneratePassword
{
    $letterLowerArray = @('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')
    $letterUpperArray = @('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
    $numberArray = @('1', '2', '3', '4', '5', '6', '7', '8','9','0', '!', '@', '#', '$', '%', '^', '&', '*')
    $specialArray = @('!', '@', '#', '$', '%', '^', '&', '*')
    $passwordArray = $($letterLowerArray; $letterUpperArray; $numberArray; $specialArray)
    
    for(($counter=0); $counter -lt 20; $counter++)
    {
        $randomCharacter = get-random -InputObject $passwordArray
        $randomString = $randomString + $randomCharacter
    }
return $randomString
}


# User Information Prompts
$userTarget = Read-Host -Prompt "What is the target user ID?                  "
$userFirstName = Read-Host -Prompt "What is the user's first name?               "
$userInitialM = Read-Host -Prompt "What is the user's middle initial?           "
$userLastName = Read-Host -Prompt "What is the user's last name?                "
$userInitialF = $userFirstName.Substring(0, [Math]::Min($userFirstName.Length, 1))
$userInitialL = $userLastName.Substring(0, [Math]::Min($userLastName.Length, 1))
$userFullName = "$userLastName, $userFirstName $userInitialM."


# Organizational Unit Data Variables
$orgNames = @{
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
}


# Set user Organization Unit Details
$orgDetails = @{
    "REDACTED_ORG_ID" = @{
        $userOrgName = "REDACTED_ORG_NAME"
        $userLogonScript = "REDACTED_SCRIPT.bat"
        $userOrgGID = "a15275b5-394e-4f95-a2ef-09e9daab1568"    # REDACTED_DISTINGUISHED_NAME
        $userGroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-00000'     # Security      REDACTED_GROUP_NAME
        )
    }
    "REDACTED_ORG_ID" = @{
        $userOrgName = "REDACTED_ORG_NAME"
        $userLogonScript = "REDACTED_SCRIPT.bat"
        $userOrgGID = "REDACTED_ORG_GID"                        # REDACTED_DISTINGUISHED_NAME
        $userGroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-00000',    # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000',     # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000'      # Distribution  REDACTED_GROUP_NAME
        )
    }
    "REDACTED_ORG_ID" = @{
        $userOrgName = "REDACTED_ORG_NAME"
        $userLogonScript = "REDACTED_SCRIPT.bat"
        $userOrgGID = "REDACTED_ORG_GID"                        # REDACTED_DISTINGUISHED_NAME
        $userGroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-0000',     # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000'      # Distribution  REDACTED_GROUP_NAME
        )
    }
    "REDACTED_ORG_ID" = @{
        $userOrgName = "REDACTED_ORG_NAME"
        $userLogonScript = "REDACTED_SCRIPT.bat"
        $userOrgGID = "REDACTED_ORG_GID"                        # REDACTED_DISTINGUISHED_NAME
        $userGroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-00000',    # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-00000',    # Security	    REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000',     # Security	    REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000'      # Distribution	REDACTED_GROUP_NAME
        )
    }
    "REDACTED_ORG_ID" = @{
        $userOrgName = "REDACTED_ORG_NAME"
        $userLogonScript = "REDACTED_SCRIPT.bat"
        $userOrgGID = "REDACTED_ORG_GID"                        # REDACTED_DISTINGUISHED_NAME
        $userGroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-00000',    # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000',     # Security	    REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000'      # Distribution	REDACTED_GROUP_NAME
        )
    }
}


function New-RedactedUser {
    $userOrg = Get-UserOrg
    
    if ($orgDetails.ContainsKey($userOrg)) {
        $org = $orgDetails[$userOrg]
        $userOrgName = $org.OrgName
        $userLogonScript = $org.LogonScript
        $userOrgGID = $org.OrgUnitGID
        $userGroupsAD = $org.GroupsAD
    } else {
        Write-Output "You did not input a correct entry."
        exit 1
    }


    # User Informatoin Variables
    $userFirstName = Read-Host -Prompt "What is the user's first name?               "
    $userInitialM = Read-Host -Prompt "What is the user's middle initial?           "
    $userLastName = Read-Host -Prompt "What is the user's last name?                "
    $userInitialF = $userFirstName.Substring(0, [Math]::Min($userFirstName.Length, 1))
    $userInitialL = $userLastName.Substring(0, [Math]::Min($userLastName.Length, 1))
    $userFullName = "$userLastName, $userFirstName $userInitialM."
    $userEmailname = "$userInitialF$userInitialM$userLastName"

    $userID = $userOrg.ToUpper() + $userInitialF.ToUpper() + $userInitialM.ToUpper() + $userInitialL.ToUpper()
    $userEmailID = "$userID@hanover.gov"

    $userEmailSMTP = "$userEmailname@hanovercounty.gov"
    $userEmailExternal = "$userEmailname@hanoverva.mail.onmicrosoft.com"
    $userEmailTertiary = "$userEmailname@co.hanover.va.us"

    $userJobTitle = Read-host -Prompt "What is the user's job title?                "
    $userManager = Read-Host -Prompt "Who is the user's manager?                   "
    $userOffice = Read-Host -Prompt "What is the user's office?                   "

    $userPassword = GeneratePassword


    # User ID Validation
    $adSession = New-PSSession ADSRVFSMO
    Invoke-Command -Session $adSession -Scriptblock {Import-Module ActiveDirectory}

    function adValidation {Invoke-Command -Session $adSession -Scriptblock {(Get-ADUser $Using:userID).SamAccountName} 2> $null}
    $userIncrement = 2
    While (adValidation -eq "$userID"){
        $userID = $userOrg + $userInitialF + $userInitialM + $userInitialL + $userIncrement
        $userEmailID = $userOrg + $userInitialF + $userInitialM + $userInitialL + $userIncrement + "@hanover.gov"
        $userIncrement++
    }

    Remove-PSSession $adSession


    # User Email Validation
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

    function emailSMTPValidation {((Get-User -Filter 'WindowsEmailAddress -like $userEmailSMTP').WindowsEmailAddress).Address}
    $userIncrement = 2
    While (emailSMTPValidation -eq "$userEmailSMTP"){
        $userEmailSMTP = "$userEmailName$userIncrement@hanovercounty.gov"
        $userEmailExternal = "$userEmailName$userIncrement@hanoverva.mail.onmicrosoft.com"
        $userEmailTertiary = "$userEmailName$userIncrement@co.hanover.va.us"
        $userIncrement++
    }


    # Exchange Account Creation
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
    New-RemoteMailbox -Alias $userID `
    -FirstName $userFirstName `
    -Initials $userInitialM `
    -LastName $userLastName `
    -Name $userFullName `
    -DisplayName $userFullName `
    -UserPrincipalName $userEmailID `
    -OnPremisesOrganizationalUnit $userOrgUnitGID `
    -PrimarySmtpAddress $userEmailSMTP `
    -RemoteRoutingAddress $userEmailExternal `
    -Password (ConvertTo-SecureString -String $userPassword -AsPlainText -Force) `
    -ResetPasswordOnNextLogo $true | Out-Null
    Start-Sleep -Seconds 5
    Set-RemoteMailbox $userEmailID -EmailAddresses @{Add=$userEmailTertiary}

    Write-Output "`nUser Account Created: "
    Write-Output "User ID:       $userID "
    Write-Output "User Email:    $userEmailSMTP `n"


    # Synchronize Active Directory
    $adUpdateSession = New-PSSession -ComputerName INFRAAPP
    Invoke-Command $adUpdateSession -ScriptBlock {
        Import-Module ADSync
        Start-ADSyncSyncCycle Delta | Out-Null
    }
    Remove-PSSession $adUpdateSession


    # Set Active Directory Settings
    $adSession = New-PSSession ADSRVFSMO
    Invoke-Command -Session $adSession -Scriptblock { 
        Import-Module ActiveDirectory
        $userManager = $Using:userManager
        $userManagerQuery = Get-ADUser -Filter 'Name -like $userManager'
        $userDescription = "$Using:userFirstName $Using:userLastName in $Using:userOrgName"
        (Get-ADDomainController -Filter *).Name | Foreach-Object { repadmin /syncall $_ (Get-ADDomain).DistinguishedName /AdeP } | out-null
        Get-ADUser $Using:userID | Move-ADObject -TargetPath $Using:userOrgUnitGID
        Get-ADuser $Using:userID | Set-ADUser -Description $userDescription -Office $Using:userOffice -Manager $userManagerQuery -ScriptPath $Using:userLogonScript -Title $Using:userJobTitle -Department $Using:userOrgName -Company "Hanover County"
        foreach($userGroupAD in $Using:userGroupsAD){
            Add-ADGroupMember -Identity $userGroupAD -Members $Using:userID | Out-Null
        }
    } | Out-Null
    Remove-PSSession $adSession
}

New-HanoverUser
