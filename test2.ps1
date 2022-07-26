Get-VM -ComputerName 192.168.153.52 | % { 
    $vm = $_ 
    switch ($vm.State) { 
        Running {Write-Host $vm.Name $vm.State -ForegroundColor Green } 
        Off {Write-Host $vm.Name $vm.State -ForegroundColor White} 
        Paused {Write-Host $vm.Name $vm.State -ForegroundColor Yellow} 
        Starting {Write-Host $vm.Name $vm.State -ForegroundColor Magenta} 
        Stopping {Write-Host $vm.Name $vm.State -ForegroundColor Red} 
        Reset {Write-Host $vm.Name $vm.State -ForegroundColor Blue -BackgroundColor Red} 
        default {Write-Host $vm.Name $vm.State -ForegroundColor Cyan -BackgroundColor Black} 
    } 
} 

Stop-VM -ComputerName 192.168.153.52 -Name VM1_PANIN
New-VM -ComputerName 192.168.153.52 -Name VM4_PANIN -MemoryStartupBytes 1024MB -NoVHD
New-VHD -Dynamic -Path D:\hyper-v\devops\lab8.vhd -SizeBytes 1024MB -ComputerName 192.168.153.52
Remove-VM -ComputerName 192.168.153.52 -Name VM4_PANIN -Force

Get-VM -ComputerName 192.168.153.52 | Select-Object State |FT -AutoSize

ConvertTo-Csv
$x=0
do {
    $x
    $x = $x + 1
} until ($x -gt 10)

function get-test ([int]$a)
{
    $a;
    for ($i=0;$i -lt $a;$i++){
        write-host $i
    };
    return $i
}