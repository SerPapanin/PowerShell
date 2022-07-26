$hashOfServID = @{}
Get-Service | ? {$_.Status -eq 'Running'}| % {
     $serviceName = $_.Name
     $procID = (Get-WmiObject win32_service | ? { $_.Name -eq $serviceName }).processID
    $hashOfServID.Add($procID,$_.DisplayName) 
}

