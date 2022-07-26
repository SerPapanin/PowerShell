[CmdletBinding()]
Param (
    [Parameter (Mandatory=$true, Position=1)]
        [int]$a,
    [Parameter (Mandatory=$true, Position=2)]
        [int]$b,
    [switch] $type = $false,
    [Parameter (Mandatory=$false, Position=4)]
    [int]$N = 3
)
for ($i=$a;$i -lt $b; $i++) {
    switch ($type) {
        $false {if (!($i % $N)) {Write-Host $i}}
        $true {if ($i % $N) {Write-Host $i}}
    }
}