# Use Case
# Changes a user's name after a name update, OU change, or similar

# Script Functions
function Get-UserOrg {
    while ($true) {
        $orgPrompt = Read-Host -Prompt "`nType 'Help' for a list of Organization Units `nWhat is the user's organizational unit?      "

        if ($userOrg -eq "Help") {
            Write-Host "$userOrg"
        } elseif ($orgNames.ContainsKey($userOrg)) {
            $userOrgName = $orgNames[$userOrg]
        } else {
            Write-Output "You did not input a correct entry."
            return
        }
    }
}


# User Information Prompts
$userTarget = Read-Host -Prompt "What is the target user ID?                  "
$userFirstName = Read-Host -Prompt "What is the user's first name?               "
$userInitialM = Read-Host -Prompt "What is the user's middle initial?           "
$userLastName = Read-Host -Prompt "What is the user's last name?                "
$userInitialF = $userFirstName.Substring(0, [Math]::Min($userFirstName.Length, 1))
$userInitialL = $userLastName.Substring(0, [Math]::Min($userLastName.Length, 1))
$userFullName = "$userLastName, $userFirstName $userInitialM."


# Set user Organization Unit
$orgNames = @{
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
    "OU_ID" = "REDACTED_DISPLAY_NAME"
}

$userOrg = Get-UserOrg


# Additional User Variables, Requires use of function Get-UserOrg
$userID = $userOrg + $userInitialF + $userInitialM + $userInitialL
$userDescription = "$userFirstName $userLastName in $userOrgName"
$userEmailName = "$userInitialF$userInitialM$userLastName"
$userEmailID = "$userID@REDACTED_DOMAIN_1.gov"
$userEmailSMTP = "$userEmailName@REDACTED_DOMAIN_2.gov"
$userEmailExternal = "$userEmailname@REDACTED_DOMAIN_3.com"
$userEmailTertiary = "$userEmailname@REDACTED_DOMAIN_4.us"
$userMailNickname = @{MailNickname="$userID"}


# User ID Validation
$adSession = New-PSSession REDACTED_DOMAIN_SERVER
Invoke-Command -Session $adSession -Scriptblock {Import-Module ActiveDirectory}

function adValidation {Invoke-Command -Session $adSession -Scriptblock {(Get-ADUser $Using:userID).SamAccountName} 2> $null}

$userIncrement = 2
While (adValidation -eq "$userID"){
    $userID = $userOrg + $userInitialF + $userInitialM + $userInitialL + $userIncrement
    $userEmailID = $userOrg + $userInitialF + $userInitialM + $userInitialL + $userIncrement + "@REDACTED_DOMAIN_1.gov"
    $userIncrement++
}

Remove-PSSession $adSession


# User Email Validation
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

function emailSMTPValidation {((Get-User -Filter 'WindowsEmailAddress -like $userEmailSMTP').WindowsEmailAddress).Address}
$userIncrement = 2
While (emailSMTPValidation -eq "$userEmailSMTP"){
    $userEmailSMTP = "$userEmailName$userIncrement@hREDACTED_DOMAIN_1.gov"
    $userEmailExternal = "$userEmailName$userIncrement@REDACTED_DOMAIN_3.com"
    $userEmailTertiary = "$userEmailName$userIncrement@REDACTED_DOMAIN_4.us"
    $userIncrement++
}


# Script Body - Active Directory Changes
Import-Module ActiveDirectory

$userParameters = @{
    Identity        = $userTarget
    GivenName       = $userFirstName        # First Name
    Surname         = $userLastName         # Last Name
    Initials        = $userInitialM         # Middle Initial
    DisplayName     = $userFullName         # Full name
    SamAccountName  = $userID               # User Logon Name
    Description     = $userDescription      # Description Field
    EmailAddress    = $userEmailSMTP        # Email Address         BTBodnovich@hanovercounty.gov
    UserPrincipal   = $userEmailID          # User Principal Name   ITBTB@hanover.gov
    Replace         = $userMailNickname     # mailNickname
}

Set-ADUser @userParameters
(Get-ADUser $userID).DistinguishedName | Rename-ADObject -NewName $userFullName


# Script Body - Microsoft Exchange Changes
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
Get-user $userTarget | Set-RemoteMailbox -Alias $userID `
-Name $userFullName `
-DisplayName $userFullName `
-UserPrincipalName $userEmailID `
-PrimarySmtpAddress $userEmailSMTP `
-RemoteRoutingAddress $userEmailExternal
Start-Sleep -Seconds 5
Set-RemoteMailbox $userEmailID -EmailAddresses @{Add=$userEmailTertiary}

Write-Output "
User Account Created:
User ID:            $userID
User Email:         $userEmailSMTP

User Email ID:      $userEmailID
User Description:   $userDescription
User Email Ext:     $userEmailExternal"


# Synchronize Domain Controllers
$adSession = New-PSSession -Computername REDACTED_DOMAIN_SERVER
Invoke-Command -Session $adSession {
    Import-Module ActiveDirectory
    (Get-ADDomainController -Filter *).Name | Foreach-Object { repadmin /syncall $_ (Get-ADDomain).DistinguishedName /AdeP } | Out-Null
}
Remove-PSSession $adSession


# Synchronize Azure (Delta Sync)
$infraSession = New-PSSession -Computername REDACTED_MANAGEMENT_SERVER
Invoke-Command -Session $infraSession {
    Import-Module ADSync
    Start-ADSyncSyncCycle Delta
}
Remove-PSSession $infraSession