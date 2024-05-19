$Servers = @() #initialize array
$Users = @() #initialize array

#save values in array vairbales
$Servers = Get-Content "C:\Temp\LivePcs.txt"
$Users = Get-Content "C:\Temp\Users.txt"

#get Group Name as input value from user
$Group = Read-Host "Enter Group Name of Remote Host"

#enable below lines if you want to set password of local-user
    #$Account = Read-Host "Enter Account/Group Name to ADD in Remote Computer Group"
    #$Password = Read-Host -AsSecureString

$row = 0
$count = $Servers.count
foreach ($Server in $Servers){
    $row++
    $percent = "{0:N2}" -f ($row / $count * 100)
    Write-Host "$row. Server: $Server in progress" -ForegroundColor Yellow
    
    $netBIOSName = Get-WmiObject -Class win32_Bios -ComputerName $Server | select -ExpandProperty __Server
    if($netBIOSName -eq $env:COMPUTERNAME){
        Write-Host "`t Error: Invoke command cannot be executed on same machine where script is saved. Do it manually in this server"
    }else{
        foreach ($User in $Users){
            Write-Progress -Activity "$Server add user $User" -Status "In Progress...$percent%" -PercentComplete $percent -CurrentOperation $User
            try{



                Invoke-Command -ErrorAction Stop -ComputerName $Server -InputObject $User,$Group -ScriptBlock{
                    Param(
                    [String]$User,
                    [String]$Group
                    )

                    $compname = $env:COMPUTERNAME
                    Function checkGroupMember{
                        $retValue = $true
                        try{
                            $present = Get-LocalGroupMember -ErrorAction Stop -Name $Group | Where-Object -FilterScript {$_.Name -eq "$compname\$User"}
                            if($present -eq $null){
                                $retValue = $false
                            }

                        }catch{
                            $er = $Error[0].Exception.Message
                            Write-Host "`t Error: $er" -ForegroundColor Red
                            $retValue = $false                                                     
                        }
                        Return $retValue
                    }#function checkGroupMember

                    Function addGroupMember{
                        $retValue = $false
                        try{
                            Add-LocalGroupMember -Group $Group -Member $User -ErrorAction Stop
                            $retValue = $true
                        }catch{
                            $retValue = $false
                        }

                        Return $retValue
                    }#function addGroupMember
    
                    $checkUser = Get-LocalUser -Name $User
                    if($checkUser -eq $null){
                        try{
                            #enabel this section if you want to set password whiel creating user
                            #New-LocalUser -Name $User -Password $Password -FullName $User -Description 'new user'

                            New-LocalUser -Name $User -Description "Newuser" -NoPassword -ErrorAction Stop
                            Write-Host "`t User Added - $User"
                            if(addGroupMember){
                                Write-Host "`t User $User successfully added to group $Group"
                            }else{
                                Write-Host "`t User $User failed to add to group $Group" -ForegroundColor Red
                            }#else

                        }catch{
                            Write-Host "`t Add user Failed - $User" -ForegroundColor Red
                        }


                    }else{
                        Write-Host "`t User $User already exists. Will try to add user in group $Group"
                        if(checkGroupMember){
                            Write-Host "`t User $User already member of group $Group"
                        }else{
                            if(addGroupMember){
                                Write-Host "`t User $User successfully added to group $Group"
                            }else{
                                Write-Host "`t User $User failed to add to group $Group" -ForegroundColor Red
                            }#else

                        }#else

                    }#else
            

       
                }#invoke command
            
                    
            }catch{
                $er = $Error[0].Exception.Message
                Write-Host "Error: $er" -ForegroundColor Red        
            }


        }#foreach user
    
    }


}#foreach server