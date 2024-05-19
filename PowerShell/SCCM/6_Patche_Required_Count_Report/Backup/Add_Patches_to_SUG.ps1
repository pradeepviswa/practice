Import-Module ConfigurationManager
Set-Location csn:

#output file settings
$outpath = "E:\AdminTools\SCCM_Script\6_Add_Patches_to_SUG\Output.csv"
Remove-Item -Path $outpath -ErrorAction SilentlyContinue
New-Item -ItemType File -Path $outpath | Out-Null
Set-Content -Path $outpath -Value "BulletinID,ArticleID,SUGName,Status"


#import values from csv file
$lines = Import-Csv -Path "E:\AdminTools\SCCM_Script\6_Add_Patches_to_SUG\Patches.csv"

#for loop to add each patch in SUG
Write-Host "In progress" -ForegroundColor Yellow
$count =0
if(!($lines.Count)){$count = 1}
else{$count = $lines.Count}
$x = 1
foreach($line in $lines){

    #variables
    $output = ""
    $patch = $line.patch
    $SUGName = $line.SUGName

    $percent = "{0:N2}" -f ($x/$count * 100)
    Write-Progress -Activity "Add patches to SUG" -Status "Progress ($x of $count)...$percent%" -PercentComplete $percent -CurrentOperation "$patch to $SUGName" 


    #remove KB string from patch
    if($patch -match "kb"){
        $patch = $patch.Replace("KB","")
        $patch = $patch.Replace("kb","")
    }

    #get patch software updaet ID
    $softwareUpdates = Get-CMSoftwareUpdate -Fast | where {($_.ArticleID -eq $patch) -or ($_.BulletinID -eq $patch)}

    #add each Software Update ID in SUG
    $req = 0
    foreach($softwareUpdate in $softwareUpdates){
            if( $softwareUpdate.nummissing -ne 0 ){
                #get software update ID
                $SoftwareUpdateId = $softwareUpdate.CI_ID


                #find software update gorup
                $sug = Get-CMSoftwareUpdateGroup -Name $SUGName
                if($sug.count -lt 1){
                    New-CMSoftwareUpdateGroup -Name $SUGName -Description "$SUGName Servers" | Out-Null
                    Write-Host "'$SUGName' SUG not found. Created It" -ForegroundColor Yellow
                }

                #Add patch to SUG
                Add-CMSoftwareUpdateToGroup `
                    -SoftwareUpdateGroupName $SUGName `
                    -SoftwareUpdateId $SoftwareUpdateId
        
                $BulletinID = $softwareUpdate.BulletinID
                $ArticleID = $softwareUpdate.ArticleID

                Write-Host "'$BulletinID' `t '$ArticleID' `t Added to '$SUGName'"
                $output = "$BulletinID,$ArticleID,$SUGName,Added"
                Add-Content -Path $outpath -Value $output

                $req++
            }#if
            
     
        }#foreach softwareUpdates
        
        if($softwareUpdates.count -lt 1){
                    Write-Host "$patch Not found" -ForegroundColor Red
                    $output = "$patch,Not Found"
                    Add-Content -Path $outpath -Value $output
    
        }elseif( $req -eq 0){
                    Write-Host "$patch Not Required. Adding all available patches now. Count is: $($softwareUpdates.Count)" -ForegroundColor Red
                    $output = "$patch,Not Required. Adding all available patches now:"
                    #Add-Content -Path $outpath -Value $output

                    
                    

                    foreach($softwareUpdate in $softwareUpdates){
                    
                            if(( $softwareUpdate.nummissing -ne 0 ) -or ( $softwareUpdate.nummissing -eq 0 )){
                                #get software update ID
                                $SoftwareUpdateId = $softwareUpdate.CI_ID


                                #find software update gorup
                                $sug = Get-CMSoftwareUpdateGroup -Name $SUGName
                                if($sug.count -lt 1){
                                    New-CMSoftwareUpdateGroup -Name $SUGName -Description "$SUGName Servers" | Out-Null
                                    Write-Host "'$SUGName' SUG not found. Created It" -ForegroundColor Yellow
                                }

                                #Add patch to SUG
                                Add-CMSoftwareUpdateToGroup `
                                    -SoftwareUpdateGroupName $SUGName `
                                    -SoftwareUpdateId $SoftwareUpdateId
        
                                $BulletinID = $softwareUpdate.BulletinID
                                $ArticleID = $softwareUpdate.ArticleID

                                Write-Host "'$BulletinID' `t '$ArticleID' `t Added to '$SUGName'"
                                $output = "$BulletinID,$ArticleID,$SUGName,Added"
                                Add-Content -Path $outpath -Value $output

                                
                            }#if
            
                        
                        }#foreach softwareUpdates
                        




        }

        $x++
}#foreach patches


 