#Test commit v1
Get-ChildItem 'C:\Program Files\' -Recurse -Attributes !Directory | ? { $_.Extension -eq '.dll' } |
Sort-Object -Descending -Property Name | ft FullName, Length, CreationTime


Get-EventLog -LogName System -After (Get-Date).AddDays(-7) -Before (Get-Date) | ConvertTo-Json | Out-File C:\Temp\SysLog.json

$myCred = Get-Credential
$comps = ("win10n1", "srv-sql2016")
Invoke-Command -ComputerName $comps -Credential $myCred -ScriptBlock {
    Get-NetAdapter
}

Get-WmiObject win32_Service -ComputerName win10n1 -Credential $myCred | ? { $_.State = "Stopped" }
Get-WmiObject Win32_Service -Filter "DHCP"


Get-WmiObject Win32_Service -ComputerName (get-content c:\temp\comps.txt)  | ? {
    (get-content c:\temp\services.txt) -Contains $_.Name
} | % { if ($_.State = "Running") { Write-Host -ForegroundColor Green $_.PSComputerName $_.State }
        if ($_.State = "Stopped") { Write-Host -ForegroundColor Red $_.PSComputerName $_.State }

}
Get-WmiObject Win32_Service -ComputerName (get-content c:\temp\comps.txt)

Import-Csv C:\temp\users.csv -Delimiter ";" | %{
    Write-Host $_.DefaultPassword.GetType() }

New-NetFirewallRule -DisplayName 'WWW Services port 85 (HTTP Traffic-In)' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 85
