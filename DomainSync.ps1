# Use Case
# Force a manual synchronization on domain controllers and Azure if necessary
# Useful for emergency events where an event needs replication immediately

# Synchronize Domain Controllers
$adSession = New-PSSession -Computername REDACTED_DOMAIN_SERVER
Invoke-Command -Session $adSession {
    Import-Module ActiveDirectory
    (Get-ADDomainController -Filter *).Name | Foreach-Object { repadmin /syncall $_ (Get-ADDomain).DistinguishedName /AdeP } | Out-Null
}
Remove-PSSession $adSession


# Perform Azure Delta Synchronization
$infraSession = New-PSSession -Computername REDACTED_MANAGEMENT_SERVER
Invoke-Command -Session $infraSession {
    Import-Module ADSync
    Start-ADSyncSyncCycle Delta
}
Remove-PSSession $infraSession