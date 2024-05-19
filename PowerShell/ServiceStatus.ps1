<#
SCRITP LOCATION
---------------
'C:\Lab\PowerShell Education\ServiceStatus.ps1'

SERVICE NAMES
-------------
BITS       Background Intelligent Transfer Service
wuauserv   Windows Update

PREFERRED OUTPUT FORMAT
-----------------------
127.0.0.1 | Background Intelligent Transfer Service | Stopped

#>
Param(
$serviceName = "bits",
$compuername = "127.0.0.1"
)
$output = Get-CimInstance -ClassName Win32_Service -ComputerName $compuername | 
    Where-Object -FilterScript {$_.Name -eq "$serviceName" -or $_.DisplayName -eq "$serviceName"}
$DisplayName = $output.DisplayName
$State = $output.State
Write-Host "$compuername | $DisplayName | $State"
