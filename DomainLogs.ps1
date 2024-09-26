# Use Case:
# Pull logs for Microsoft / Absolute
# Places the logs onto your current desktop

$userName = 'redacted_username'
$remoteFilePath = '%windir%\debug\netlogon.log'
 
$remoteServers = @('redacted_server1', 'redacted_server2', 'redacted_server3', 'redacted_server4', 'redacted_server5')
 
$remoteServers | ForEach-Object {
    $remoteComputer = $_
    $session = New-PSSession -ComputerName $remoteComputer
    Invoke-Command -Session $session -ScriptBlock {
        Copy-Item -Path "C:\Windows\debug\netlogon.log" -Destination "\\redacted_path\$using:userName\$using:remoteComputer.log"
    }
    Remove-PSSession -Session $session
}
 
Copy-Item -Path "\\redacted_path\$userName\*" -Destination "C:\Users\$userName\Desktop\"
