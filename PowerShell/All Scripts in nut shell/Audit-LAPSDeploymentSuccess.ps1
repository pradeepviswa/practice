$Domains = Get-Content -Path "E:\AdminTools\Pradeep\laps\Domains.txt"
foreach ($Domain in $Domains){
    $EnabledComputers = (Get-ADComputer -Server $Domain -Filter {(Enabled -eq $true) -and (OperatingSystem -like "*Windows*")} -Properties *).count
    $DomainControllers = (Get-ADGroupMember -Identity "Domain Controllers" -Server $Domain).count
    $ComputersWithLAPSPassword = (Get-ADComputer -Server $Domain -Filter {(Enabled -eq $true) -and (OperatingSystem -like "*Windows*") -and (ms-Mcs-AdmPwd -ne "*")} -Properties *).count
    $EnabledLessDCs = $EnabledComputers - $DomainControllers
    Add-Content -Value "$EnabledLessDCs,$Domain,$ComputersWithLAPSPassword" -Path "\\server1.mydomain.net\admintools\Pradeep\laps\Audit-Output.txt"
}

