#$servers = Get-ADComputer -Server emb.mydomain.net -Filter * | Where-Object {$_.Dnshostname -match "abn-"} | select -ExpandProperty dnshostname
$servers = @()

$servers += "server1.mydomain.net"


$count = $servers.Count
$x = 0
foreach($server in $servers){
    $x++
    $percent = "{0:N2}" -f ($x/$count * 100)
    Write-Progress -Activity "Registry Backup" -Status "$x of $count ... $percent%" -PercentComplete $percent -CurrentOperation $server
    
    $regPath = "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL"
    $copyDest = "\\server1.mydomain.net\C$\Temp\RegBackup"
    $copySource = "\\$server\c$\Temp\$server.reg"
    $cmd = "\\$server C:\Windows\System32\reg.exe export $regPath C:\Temp\$server.reg /y"
    #Start-Job -ScriptBlock{
        Start-Process -FilePath "C:\Windows\System32\PSExec.exe" -ArgumentList $cmd -Wait
        Copy-Item -Path $copySource -Destination $copyDest -Force
    #}
    
    
}
