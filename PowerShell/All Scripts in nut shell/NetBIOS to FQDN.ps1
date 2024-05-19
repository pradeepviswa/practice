$dir = Split-Path $Script:MyInvocation.MyCommand.path
Set-Location $dir
$servers = Get-Content ".\servers.txt"
$outFile = ".\output.txt"
$count = $servers.Count
$x = 1
$ServerFQDN = @()


foreach($server in $servers){

$x++
$percent = "{0:N2}" -f ($x/$count * 100)
Write-Progress -Activity "Get FQDN" -Status "$x of $count .. $percent%" -PercentComplete $percent -CurrentOperation $server

    # SET DOMAIN NAME OF THOSE WHOSE NAMING CONVENSION DO NOT MATCH THEIR DOMAIN NAME

    $customerName = "$($server.Split("-")[1])"  
    $domain = "$customerName.mydomain.net"
    if( ($customerName -match "SVC") ){
        $domain = "mydomain.net"
    }elseif( ($customerName -match "CES") ){
        $domain = "mydomain.net"
    }elseif( ($customerName -match "DMS") ){
        $domain = "mydomain.net"
    }elseif( ($customerName -match "TPC") ){
        $domain = "mydomain.net"
    }
        

    # COVERT INTO FQDN
    if(Test-Connection -ComputerName "$server.custhsp.mydomain.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.custhsp.mydomain.net"
    }elseif(Test-Connection -ComputerName "$server.mydomain.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.mydomain.net"
    }elseif(Test-Connection -ComputerName "$server.custft.mydomain.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.custft.mydomain.net"
    }elseif(Test-Connection -ComputerName "$server.saas.mydomain.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.saas.mydomain.net"
    }elseif(Test-Connection -ComputerName "$server.mydomain.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.mydomain.net"
    }elseif(Test-Connection -ComputerName "$server.cvs.tzghsp.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.cvs.tzghsp.net"
    }elseif(Test-Connection -ComputerName "$server.topaz.mydomain.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.topaz.mydomain.net"
    }elseif(Test-Connection -ComputerName "$server.mydomain.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.mydomain.net"
    }elseif(Test-Connection -ComputerName "$server.ode.mydomain.net" -Count 1 -Quiet){
        $ServerFQDN += "$server.mydomain.net"
    }elseif($server -notmatch "-"){
        $ServerFQDN += $server
    }else{
        $ServerFQDN += "$server.$domain"
    }

}


$ServerFQDN | Out-File $outFile
$ServerFQDN
notepad $outFile



