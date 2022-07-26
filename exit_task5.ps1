
    [string]$mask = '255.255.0.0'
    [string]$ip1 = '191.168.2.1'
    [string]$ip2 = '191.168.1.250'

$result = $true
$ip1Array =$ip1.Split('.')
$ip2Array =$ip2.Split('.')
$maskArray = $mask.Split('.')
for ($i = 0; $i -lt 4; $i++){
       $result = $result -band (([int]$ip1Array[$i] -band [int]$maskArray[$i]) -eq ([int]$ip2Array[$i] -band [int]$maskArray[$i]))
} 
Write-Host $result