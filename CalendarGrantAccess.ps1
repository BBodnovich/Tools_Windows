# Use Case
# Add user to all departmental calendars in an Exchange environment
# Useful for new hires or department transfers

# User-Defined Variables
$calendars = @(
    "REDACTED_CALENDAR_1@domain.gov:\Calendar",
    "REDACTED_CALENDAR_2@domain.gov:\Calendar",
    "REDACTED_CALENDAR_3@domain.gov:\Calendar",
    "REDACTED_CALENDAR_4@domain.gov:\Calendar",
    "REDACTED_CALENDAR_5@domain.gov:\Calendar",
    "REDACTED_CALENDAR_6@domain.gov:\Calendar",
    "REDACTED_CALENDAR_7@domain.gov:\Calendar",
    "REDACTED_CALENDAR_8@domain.gov:\Calendar",
    "REDACTED_CALENDAR_9@domain.gov:\Calendar"
)

# Script Variables
$loginUserName = $Env:UserName
$loginEmailDomain = "@domain.gov"
$loginEmailAddress = $loginUserName + $loginEmailDomain

# Script Body
Enter-PSSession REDACTED_EXCHANGE_SERVER

Install-Module ExchangeOnlineManagement -Force
Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline -UserPrincipalName $loginEmailAddress -ShowBanner:$false

$scriptEmailVariable = Read-Host -Prompt "What is the user's email address?"

foreach ($calendar in $calendars) {
    try {
        Add-MailboxFolderPermission -Identity $calendar -User $scriptEmailVariable -AccessRights Author -ErrorAction Stop
        Write-Host "Added Author access for $scriptEmailVariable to $calendar"
    } catch {
        Write-Host "Failed to add access for $scriptEmailVariable to $calendar: $_"
    }
}