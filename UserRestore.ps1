# Use Case
# Restore a user's mailbox after it has been removed from Exchange

# Script Variables
$userID = REDACTED_USER
$userEmailID = REDACTED_USER@domain.gov
$userEmailExternal = REDACTED_ALIAS@domain.mail.onmicrosoft.com

# Script Body
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

$exchangeGUID = Get-Mailbox user | Format-List ExchangeGuid

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
Enable-RemoteMailbox $userEmailID -RemoteRoutingAddress $userEmailExternal
Set-RemoteMailbox $userID -ExchangeGuid $exchangeGUID