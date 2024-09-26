# Use Case:
# Pull logs for Microsoft / Absolute
# Places the logs onto your current desktop

$userName = 'REDACTED_USERNAME'
$remoteFilePath = '%windir%\debug\netlogon.log'
 
$remoteServers = @('REDACTED_SERVER1', 'REDACTED_SERVER2', 'REDACTED_SERVER3', 'REDACTED_SERVER4', 'REDACTED_SERVER5')
 
$remoteServers | ForEach-Object {
    $remoteComputer = $_
    $session = New-PSSession -ComputerName $remoteComputer
    Invoke-Command -Session $session -ScriptBlock {
        Copy-Item -Path "C:\Windows\debug\netlogon.log" -Destination "\\redacted_path\$using:userName\$using:remoteComputer.log"
    }
    Remove-PSSession -Session $session
}
 
Copy-Item -Path "\\redacted_path\$userName\*" -Destination "C:\Users\$userName\Desktop\"
