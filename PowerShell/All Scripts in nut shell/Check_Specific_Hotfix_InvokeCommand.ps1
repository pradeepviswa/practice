﻿$hint = 1
$servers = Get-Content "E:\AdminTools\Pradeep\Check_Specific_Hotfix\$hint\servers.txt"
$outFile = "E:\AdminTools\Pradeep\Check_Specific_Hotfix\$hint\Output-$hint.csv"
Remove-Item -Path $outFile -Force -ErrorAction SilentlyContinue
New-Item -ItemType File -Path $outFile | Out-Null
Set-Content -Path $outFile -Value "ServerName,OS,Patch"

######
#store credential
$TmpFile = "\\server1.mydomain.net\E$\AdminTools\Secure_Password_DO_NOT-DELETE\Infra.Service_SecurePassword.txt"
$username = "SERVICES\infra.service"
$password = Get-Content $TmpFile | ConvertTo-SecureString
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password
###########################

$count = $servers.Count
$x = 0

foreach($server in $servers){

    $percent = "{0:N2}" -f ($x/$count * 100)
    Write-Progress -Activity "Folder $hint" -Status "Progress ($x of $count)...$percent%" -PercentComplete $percent -CurrentOperation "Checking $server"

    try{
        #open pssession before activity start. this will be used with invoke-command
        $session = New-PSSession -ComputerName $server -Credential $cred -ErrorAction stop

        $os = Invoke-Command -SessionName $session -ScriptBlock {
             Get-WmiObject -Class win32_operatingsystem | select *
        }

        $osname = $os.caption
        $osname = $osname.Replace(","," ")
        $bit = $os.OSArchitecture

        if($osname -match "2003"){
            $hotfixID = "KB4012598"
            $hotfix = Invoke-Command -SessionName $session -ScriptBlock {
                param($hotfixID)
                Get-HotFix | where {$_.HotFixID -match $hotfixID}
            } -ArgumentList $hotfixID

            if($hotfix.HotFixID -eq $hotfixID){
                Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Installed"
                Write-Host "$server `t $hotfixID Installed `t $osname"
            }else{
                Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Missing"
                Write-Host "$server `t $hotfixID Missing `t $osname" -ForegroundColor yellow
            }
        }#check 2003



        if($osname -match "2008"){
            if($osname -notmatch "R2"){
                $hotfixID = "KB4018466"
                $hotfix = Invoke-Command -SessionName $session -ScriptBlock {
                    param($hotfixID)
                    Get-HotFix | where {$_.HotFixID -match $hotfixID}
                } -ArgumentList $hotfixID

                if($hotfix.HotFixID -eq $hotfixID){
                    Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Installed"
                    Write-Host "$server `t $hotfixID Installed `t $osname"
                }else{
                    Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Missing"
                    Write-Host "$server `t $hotfixID Missing `t $osname" -ForegroundColor yellow
                }
            }


            $hotfixID = "KB4012212"
            $hotfix = Invoke-Command -SessionName $session -ScriptBlock {
                param($hotfixID)
                Get-HotFix | where {$_.HotFixID -match $hotfixID}
            } -ArgumentList $hotfixID
            if($hotfix.HotFixID -eq $hotfixID){
                Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Installed"
                Write-Host "$server `t $hotfixID Installed `t $osname"
            }else{
                Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Missing"
                Write-Host "$server `t $hotfixID Missing `t $osname" -ForegroundColor yellow
            }

            $hotfixID = "KB4012215"
            $hotfix = Invoke-Command -SessionName $session -ScriptBlock {
                param($hotfixID)
                Get-HotFix | where {$_.HotFixID -match $hotfixID}
            } -ArgumentList $hotfixID
            if($hotfix.HotFixID -eq $hotfixID){
                Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Installed"
                Write-Host "$server `t $hotfixID Installed `t $osname"
            }else{
                Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Missing"
                Write-Host "$server `t $hotfixID Missing `t $osname" -ForegroundColor yellow
            }


            $hotfixID = "KB4019264"
            $hotfix = Invoke-Command -SessionName $session -ScriptBlock {
                param($hotfixID)
                Get-HotFix | where {$_.HotFixID -match $hotfixID}
            } -ArgumentList $hotfixID
            if($hotfix.HotFixID -eq $hotfixID){
                Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Installed"
                Write-Host "$server `t $hotfixID Installed `t $osname"
            }else{
                Add-Content -Path $outFile -Value "$server,$osname $bit,$hotfixID Missing"
                Write-Host "$server `t $hotfixID Missing `t $osname" -ForegroundColor yellow
            }

        }#check 2008


        #check  MS17-006 on Microsoft Windows Server 2012 R2 Standard 64-bit
        if($osname -match "2012"){

            $hotfixID = "KB4012213"
            $hotfix = Invoke-Command -SessionName $session -ScriptBlock {
                param($hotfixID)
                Get-HotFix | where {$_.HotFixID -match $hotfixID}
            } -ArgumentList $hotfixID
            if($hotfix.HotFixID -eq $hotfixID){
                Add-Content -Path $outFile -Value "$server,$osname,$hotfixID Installed"
                Write-Host "$server `t $hotfixID Installed `t $osname"
            }else{
                Add-Content -Path $outFile -Value "$server,$osname,$hotfixID Missing"
                Write-Host "$server `t $hotfixID Missing `t $osname" -ForegroundColor yellow
            }


            $hotfixID = "KB4012216"
            $hotfix = Invoke-Command -SessionName $session -ScriptBlock {
                param($hotfixID)
                Get-HotFix | where {$_.HotFixID -match $hotfixID}
            } -ArgumentList $hotfixID
            if($hotfix.HotFixID -eq $hotfixID){
                Add-Content -Path $outFile -Value "$server,$osname,$hotfixID Installed"
                Write-Host "$server `t $hotfixID Installed `t $osname"
            }else{
                Add-Content -Path $outFile -Value "$server,$osname,$hotfixID Missing"
                Write-Host "$server `t $hotfixID Missing `t $osname" -ForegroundColor yellow
            }


            $hotfixID = "KB4019215"
            $hotfix = Invoke-Command -SessionName $session -ScriptBlock {
                param($hotfixID)
                Get-HotFix | where {$_.HotFixID -match $hotfixID}
            } -ArgumentList $hotfixID
            if($hotfix.HotFixID -eq $hotfixID){
                Add-Content -Path $outFile -Value "$server,$osname,$hotfixID Installed"
                Write-Host "$server `t $hotfixID Installed `t $osname"
            }else{
                Add-Content -Path $outFile -Value "$server,$osname,$hotfixID Missing"
                Write-Host "$server `t $hotfixID Missing `t $osname" -ForegroundColor yellow
            }


        }#check 2012



    
    }catch{
                Add-Content -Path $outFile -Value "$server,Connection Error"
                Write-Host "$server `t Connection Error" -ForegroundColor red
    
    }
    $x++
}



