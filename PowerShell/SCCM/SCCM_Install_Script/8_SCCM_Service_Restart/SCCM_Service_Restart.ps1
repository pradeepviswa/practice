﻿

###########################
#change here
$dir = Split-Path $Script:Myinvocation.Mycommand.path
Set-Location -Path $dir

$outpath = ".\Output.csv"

$servers = Get-Content ".\Servers.txt"

#decom servers store in variable
$decomServers = Get-Content "\\server1.mydomain.net\E$\AdminTools\PatchingMW\MW_Scripts\Input\DecomServers.txt"

###########################

#add output file
Remove-Item -Path $outpath -ErrorAction SilentlyContinue
New-Item -ItemTyp File -Path $outpath | Out-Null
Set-Content -Path $outpath -Value "Server,SCCM_Status,OS"

$count = $servers.Count
$x = 0

Write-Host "Checking SCCM Service. Total Servers: $count" -ForegroundColor Yellow
foreach($server in $servers){

    $server = $server.Trim()
    $percent = "{0:N2}" -f (($x/$count) * 100)
    Write-Progress -Activity "Checking SCCM Client Service" -Status "In Progress ($x of $count)...$percent%" -PercentComplete $percent -CurrentOperation $server

    if( Test-Connection $server -Count 1 -Quiet){
        
        try{
                    #$server = "server1.mydomain.net"
                    $service = Get-Service -Name "CcmExec" -ComputerName $server -ErrorAction SilentlyContinue


                
                if ($service.Name -eq "CcmExec"){
                    Add-Content -Path $outpath -Value "$server,Installed,$os"
                    #$service | Restart-Service
                    
                    #Get-Service -Name "CcmExec" -ComputerName $server | Restart-Service

                    Invoke-Command -ScriptBlock {
                        
                        Get-Service -Name "CcmExec" | Restart-Service
                    } -AsJob -Authentication Negotiate -ComputerName $server
                    
                }else{

                    Write-Host "$server : Missing `t $os" -ForegroundColor Red
                    Add-Content -Path $outpath -Value "$server,Missing,$os"
                }



        }catch{
            Write-Host "$server `t Unable to establish remote session." -ForegroundColor Red
            Add-Content -Path $outpath -Value "$server,Unable to establish remote session"
        }

        
    }else{
        if($decomServers -contains $server){
            Write-Host "$server `t Decom" -ForegroundColor Red
            Add-Content -Path $outpath -Value "$server,Decom"
        }else{
            Write-Host "$server `t Ping Failed" -ForegroundColor Red
            Add-Content -Path $outpath -Value "$server,Ping Failed"
        }
    }
    $x++
}

#Send-MailMessage -Attachments $outpath -To 'hs-sysadmin-windows-offshore@mydomain.net' -Cc 'HS-SysAdmin-Windows-Operations@mydomain.net' -From 'SCCM@mydomain.net' -Subject "SCCM Client Installation Report" -SmtpServer 'mail-2.mydomain.net'  -Body "PBA SCCM Client Instalaltion Report on domain"
#Send-MailMessage -Attachments $outpath -To 'pradeep.viswanathan@cognizant.com','hs-sysadmin-windows-offshore@mydomain.net' -From 'SCCM@mydomain.net' -Subject "SCCM Client Installation Report" -SmtpServer 'mail-2.mydomain.net'  -Body "PFA SCCM Client Instalaltion Report on domain. Address those servers where SCCM client is not installed"

<#
Receive-Job -id 2829
Get-Job -id 2829
#>
