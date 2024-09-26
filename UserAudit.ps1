# Use Case
# Searches for users who have not logged in within XX amount of days
# Useful for getting rid of old, stale accounts that have not be used in 90+ days

# NOTE
# This script was trimmed down to only include 5 Organizatoinal Units
# The environment ran in had nearly 40 Organizational Units
# I trimmed the script down to make it easier to parse and see the fundamentals


# User-Defined Variables for Time Period and Report Path
$CurrentDate = Get-Date
$Target_Time = $CurrentDate.AddDays(-90)
$directoryPath = "$env:USERPROFILE\Desktop\inactive_users.csv"


# Script Functions
function Show-HelpMenu {
    Write-Output "
    REDACTED_ORG_ID - REDACTED_ORG_DISPLAY_NAME
    REDACTED_ORG_ID - REDACTED_ORG_DISPLAY_NAME
    REDACTED_ORG_ID - REDACTED_ORG_DISPLAY_NAME
    REDACTED_ORG_ID - REDACTED_ORG_DISPLAY_NAME
    REDACTED_ORG_ID - REDACTED_ORG_DISPLAY_NAME
    "
    Return
}


# Organization Unit Hash Table - ID / Name Map
$OUMap = @{
    "AP"   = "REDACTED_ORG_DISTINGUISHED_NAME"
    "BI"   = "REDACTED_ORG_DISTINGUISHED_NAME"
    "CO"   = "REDACTED_ORG_DISTINGUISHED_NAME"
    "CR"   = "REDACTED_ORG_DISTINGUISHED_NAME"
    "CM"   = "REDACTED_ORG_DISTINGUISHED_NAME"
}


# Script Body
Import-Module ActiveDirectory

function Search-OU {
    $orgPrompt = Read-Host -Prompt "`nType 'Help' for a list of Organization Units `nWhat is the user's organizational unit?      "

    if ($orgPrompt -eq "Help") {
        Show-HelpMenu
        exit 1
    } elseif ($OUMap.ContainsKey($orgPrompt)) {
        $OU = $OUMap[$orgPrompt]
    } else {
        Write-Output "You did not input a correct entry."
        Search-OU
        return
    }

    # Run the report
    $Users = Get-ADUser -Filter * -SearchBase $OU -Properties LastLogonDate
    $InactiveUsers = $Users | Where-Object { $_.LastLogonDate -lt $Target_Time }
    $InactiveUsers | Select-Object Name, LastLogonDate | Sort-Object LastLogonDate
    $InactiveUsers | Export-Csv -Path $directoryPath -NoTypeInformation
}

Search-OU