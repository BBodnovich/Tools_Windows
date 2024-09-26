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


# Organization Unit Hash Table - ID / Name Map
$orgNames = @{
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
    "REDACTED_ORG_ID" = "REDACTED_DISPLAY_NAME"
}


# Organizational Unit Hash Table - Data
$orgData = @{
    "REDACTED_ORG_ID" = @{
        Name = "REDACTED_ORG_NAME"
        LogonScript = "REDACTED_SCRIPT.bat"
        OrgUnitGID = "a15275b5-394e-4f95-a2ef-09e9daab1568"     # REDACTED_DISTINGUISHED_NAME
        GroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-00000'     # Security      REDACTED_GROUP_NAME
        )
    }
    "REDACTED_ORG_ID" = @{
        Name = "REDACTED_ORG_NAME"
        LogonScript = "REDACTED_SCRIPT.bat"
        OrgUnitGID = "REDACTED_ORG_GID"                         # REDACTED_DISTINGUISHED_NAME
        GroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-00000',    # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000',     # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000'      # Distribution  REDACTED_GROUP_NAME
        )
    }
    "REDACTED_ORG_ID" = @{
        Name = "REDACTED_ORG_NAME"
        LogonScript = "REDACTED_SCRIPT.bat"
        OrgUnitGID = "REDACTED_ORG_GID"                         # REDACTED_DISTINGUISHED_NAME
        GroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-0000',     # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000'      # Distribution  REDACTED_GROUP_NAME
        )
    }
    "REDACTED_ORG_ID" = @{
        Name = "REDACTED_ORG_NAME"
        LogonScript = "REDACTED_SCRIPT.bat"
        OrgUnitGID = "REDACTED_ORG_GID"                         # REDACTED_DISTINGUISHED_NAME
        GroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-00000',    # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-00000',    # Security	    REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000',     # Security	    REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000'      # Distribution	REDACTED_GROUP_NAME
        )
    }
    "REDACTED_ORG_ID" = @{
        Name = "REDACTED_ORG_NAME"
        LogonScript = "REDACTED_SCRIPT.bat"
        OrgUnitGID = "REDACTED_ORG_GID"                         # REDACTED_DISTINGUISHED_NAME
        GroupsAD = @(
            'S-1-0-00-0000000000-000000000-000000000-00000',    # Security      REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000',     # Security	    REDACTED_GROUP_NAME
            'S-1-0-00-0000000000-000000000-000000000-0000'      # Distribution	REDACTED_GROUP_NAME
        )
    }
}


# Script Main Body Function
function New-RedactedUser{
    $userOrg = Get-UserOrg

    if ($orgNames.ContainsKey($userOrg)) {
        $userOrgName = $orgNames[$userOrg]
    } else {
        Write-Output "You did not input a correct entry."
        exit 1
    }

    if ($orgData.ContainsKey($userOrg)) {
        $userOrgName = $orgData[$userOrg].Name
        $userLogonScript = $orgData[$userOrg].LogonScript
        $userOrgUnitGID = $orgData[$userOrg].OrgUnitGID
        $userGroupsAD = $orgData[$userOrg].GroupsAD
    } else {
        Write-Output "You did not input a correct entry."
        exit 1
    }


    # User Information Variables
    $userFirstName = Read-Host -Prompt "What is the user's first name?               "
    $userInitialM = Read-Host -Prompt "What is the user's middle initial?           "
    $userLastName = Read-Host -Prompt "What is the user's last name?                "

    $userInitialF = $userFirstName.Substring(0, [Math]::Min($userFirstName.Length, 1))
    $userInitialL = $userLastName.Substring(0, [Math]::Min($userLastName.Length, 1))
    $userFullName = "$userLastName, $userFirstName $userInitialM."
    $userEmailname = "$userInitialF$userInitialM$userLastName"

    $userID = $userOrg.ToUpper() + $userInitialF.ToUpper() + $userInitialM.ToUpper() + $userInitialL.ToUpper()
    $userEmailID = "$userID@REDACTED_DOMAIN.gov"

    $userEmailSMTP = "$userEmailname@REDACTED_DOMAIN_2.gov"
    $userEmailExternal = "$userEmailname@REDACTED_DOMAIN_3.com"
    $userEmailTertiary = "$userEmailname@REDACTED_DOMAIN_4.us"

    $userJobTitle = Read-host -Prompt "What is the user's job title?                "
    $userManager = Read-Host -Prompt "Who is the user's manager?                   "
    $userOffice = Read-Host -Prompt "What is the user's office?                   "

    $userPassword = GeneratePassword


    # User ID Validation
    $adSession = New-PSSession REDACTED_DOMAIN_SERVER
    Invoke-Command -Session $adSession -Scriptblock {Import-Module ActiveDirectory}

    function adValidation {
        Invoke-Command -Session $adSession -Scriptblock {
            (Get-ADUser $Using:userID).SamAccountName
        } 2> $null}

    $userIncrement = 2
    While (adValidation -eq "$userID"){
        $userID = $userOrg + $userInitialF + $userInitialM + $userInitialL + $userIncrement
        $userEmailID = $userOrg + $userInitialF + $userInitialM + $userInitialL + $userIncrement + "@REDACTED_DOMAIN.gov"
        $userIncrement++
    }

    Remove-PSSession $adSession


    # User Email Validation
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

    function emailSMTPValidation {
        ((Get-User -Filter 'WindowsEmailAddress -like $userEmailSMTP').WindowsEmailAddress).Address
    }

    $userIncrement = 2

    While (emailSMTPValidation -eq "$userEmailSMTP"){
        $userEmailSMTP = "$userEmailName$userIncrement@REDACTED_DOMAIN_2.gov"
        $userEmailExternal = "$userEmailName$userIncrement@REDACTED_DOMAIN_3.com"
        $userEmailTertiary = "$userEmailName$userIncrement@REDACTED_DOMAIN_4.us"
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
    $adUpdateSession = New-PSSession -ComputerName REDACTED_MANAGEMENT_SERVER

    Invoke-Command $adUpdateSession -ScriptBlock {
        Import-Module ADSync
        Start-ADSyncSyncCycle Delta | Out-Null
    }

    Remove-PSSession $adUpdateSession


    # Set Active Directory Settings
    $adSession = New-PSSession REDACTED_DOMAIN_SERVER
    Invoke-Command -Session $adSession -Scriptblock { 
        Import-Module ActiveDirectory

        $userManager = $Using:userManager
        $userManagerQuery = Get-ADUser -Filter 'Name -like $userManager'
        $userDescription = "$Using:userFirstName $Using:userLastName in $Using:userOrgName"

        (Get-ADDomainController -Filter *).Name | 
            ForEach-Object { 
                repadmin /syncall $_ (Get-ADDomain).DistinguishedName /AdeP 
            } | Out-Null

        Get-ADUser $Using:userID | 
            Move-ADObject -TargetPath $Using:userOrgUnitGID

        Get-ADUser $Using:userID | 
            Set-ADUser -Description $userDescription `
                    -Office $Using:userOffice `
                    -Manager $userManagerQuery `
                    -ScriptPath $Using:userLogonScript `
                    -Title $Using:userJobTitle `
                    -Department $Using:userOrgName `
                    -Company "REDACTED_NAME"

        foreach($userGroupAD in $Using:userGroupsAD){
            Add-ADGroupMember -Identity $userGroupAD -Members $Using:userID | Out-Null
        }
    } | Out-Null

    Remove-PSSession $adSession
}

New-RedactedUser