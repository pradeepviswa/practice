<#
Agenda
------
Create a scipt to:
    Accept multiple server name via input file
    Modify given service
    Change StartType (Automatic/Manual/Disable)


Service Name: BITS

$serverListFilePath
$serviceName = "BITS"
$StartupType = "Disabled"

.\ServiceEnableDisable.ps1 -serverListFilePath .\servers.txt -serviceName bits -StartupType Disabled

#>
Param(
[String]$serverListFilePath,
[String]$serviceName,
[String]$StartupType
)

$servers = Get-Content -Path $serverListFilePath



foreach($server in $servers){

    $Status = Get-Service -Name $serviceName -ComputerName $server | select -ExpandProperty Status

    if($Status -eq "Running"){
        Get-Service -Name $serviceName -ComputerName $server | 
        Stop-Service
    }

    $Status = Get-Service -Name $serviceName -ComputerName $server | select -ExpandProperty Status
    if($Status -eq "stopped"){
        Set-Service -ComputerName $server -Name $serviceName -StartupType $StartupType
    }

    $StartType = Get-Service -Name $serviceName -ComputerName $server | select -ExpandProperty StartType
    Write-Host "$server :  $serviceName StartType is $StartType"

}#foreach
