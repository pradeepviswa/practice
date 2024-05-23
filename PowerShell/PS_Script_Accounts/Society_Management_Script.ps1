cls
$showReport = $false
$showReport = $true

#some important vlaues for HTML File
$yearEndDate = "31-Mar-21"
$financialYearRange = "01-Apr-2020 to 31-Mar-2021"

$table = "<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=711
 style='width:533.0pt;margin-left:-.65pt;border-collapse:collapse;mso-yfti-tbllook:1184;mso-padding-alt:0in 5.4pt 0in 5.4pt'>"
 
 
 $tr = "<tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:15.0pt'>"

 #include HTML Tag defition file
 . .\HTMLTagDefinition.ps1

 $commentHTMLOpen = "<span style='font-size:7.0pt;mso-bidi-font-size:
  11.0pt;mso-ascii-font-family:Calibri;mso-fareast-font-family:'Times New Roman';
  mso-hansi-font-family:Calibri;mso-bidi-font-family:Calibri;color:black'>"
  $commentHTMLClose = "</span>"
$dir = split-path ($Script:MyInvocation.Mycommand.Path)
Set-Location -Path $dir
$journals = Import-Csv -Path '.\Journal Entry.csv'
$masterCSV = Import-Csv -Path '.\Master\Master.csv'

Write-Host ""
$depreciationPercent = [double]$($masterCSV.Depreciation | where {$_ -ne ""}).toString()
####################### Addition Depreciation Account in Journal Entry #################
Write-Host "************* Adding Depreciation Account in Journal Entry *************" -ForegroundColor Yellow
$Fixed_Assets = $masterCSV.Fixed_Asset | where {$_ -ne ""}
$tempOutputFile = "C:\Temp\1.csv"
if(!(Test-Path C:\Temp)){New-Item -ItemType Directory -Path "C:\Temp" | Out-Null}
Remove-Item -Path $tempOutputFile -Force -ErrorAction SilentlyContinue
New-Item -ItemType File -Path $tempOutputFile  | Out-Null


foreach($Fixed_Asset in $Fixed_Assets){
    #$Fixed_Asset = 'Shed Work'
    $result = $journals | where {$_.Dr_Particular -match $Fixed_Asset}
    if($result -ne $null){
        foreach($r in $result){
            $depAmt = 0
            $Amuont = [double]$($r.Amuont)
            $depAmt = $([double]$Amuont) * $([double]$depreciationPercent)
            #$depAmt = "{0:N2}" -f $depAmt 
            $rowValue = ""
        
            $Comment= "$Fixed_Asset depreciated by $('{0:N2}' -f ($depreciationPercent * 100))%"
            $Comment = $Comment.Replace(",","")
            $rowValue = "$yearEndDate,Depreciation,$Fixed_Asset,$Comment,,,$depAmt"
            Set-Content -Path $tempOutputFile -Value "Date,Dr_Particular,Cr_Particular,Comment,Voucher_Type,Voucher_No,Amuont"
            Add-Content -Path $tempOutputFile -Value $rowValue
            Write-Host "Asset amount ($Fixed_Asset): $($r.Amuont) | Depreciation: $depAmt"
        
            $journals += Import-Csv -Path $tempOutputFile

            
            
        }#foreach
        
    }#if
}#foreach Fixed_Asset



 





$htmlFile = ""









#"************* SPECIAL LEDGER ACCOUNTS - MONTH BY MONTH DETAIL STARTS HERE *************"
Write-Host "`n`n************* SPECIAL LEDGER ACCOUNTS - MONTH BY MONTH DETAIL *************" -ForegroundColor Yellow
#initialize variables
$drSideTotal = 0
$crSideTotal = 0
$balanceFigure = 0
$totalFigure = 0
$ledgerAccounts = ""
$arr= @()
$arrDr = @()
$arrCr = @()

$htmlFile += "
<html>

<head>


</head>

<body>
<font face='Calibri'>
<div class=WordSection1>

<p class=MsoNormal align=center style='text-align:center'><b>Samruddhi
Nakshatra Co-Op. Housing Society Ltd.<br>
</b>Indra Collony, Vikasnagar, Kiwale<br>
<u>Tal- Haveli Dist- Pune</u><br>
<b>LEDGER ACCOUNTS</b><br>
$financialYearRange
</p>
</div>


"
$monthSequence = ("Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec","Jan","Feb","Mar")

$LedgerMonthly = $masterCSV | where {$_.LedgerMonthly -ne ""} | select -ExpandProperty LedgerMonthly
foreach($unique_Dr_Particular in $LedgerMonthly){
    


    #collect Dr side detail
    $unique_Dr_Particular
    $ledgerAccountsMain_Dr = $journals | Where-Object -FilterScript {
                                    $_.Dr_Particular -eq $unique_Dr_Particular
                                    }
    #collect Cr side detail
    $ledgerAccountsMain_Cr = $journals | Where-Object -FilterScript {
                                    $_.Cr_Particular -eq $unique_Dr_Particular
                                   }


    #update html file
    $htmlFile += "
    <div class=WordSection1>
        <p class=MsoNormal align=center style='text-align:center'><b>
        $unique_Dr_Particular <br></b>
        $financialYearRange</p>
        </div>
    <center>
    $table
    $tr
      $thLeftSideDate  Date $thClose
      $thParticulars Particulars $thClose
      $thVouch Vouch.No $thClose
      $thLeftSideAount Amount $thClose
      $thRightSidenDate Date $thClose
      $thParticulars Particulars $thClose
      $thVouch Vouch.No $thClose
      $thRightSideAmount Amount $thClose
    </tr>
    "
    #setting variable to add opening balance values to corresponsding sides 
    $balanceFigure = 0
    #this should be either Dr or Cr
    $OpeningBalanceSide = "" 
        
    #DR Side Calculation
    foreach($month in $monthSequence){
   
         
        #this array will contain temporary values of Dr side and Cr side
        $arr= @()
        $arrDr = @()
        $arrCr = @()
        $drSideTotal = 0
        $crSideTotal = 0
        
        $totalFigure = 0
        $ledgerAccounts = $ledgerAccountsMain_Dr | where {$_.date -match $month}
    
        if($OpeningBalanceSide -eq "Dr"){
            $drSideTotal = $balanceFigure
        }elseif($OpeningBalanceSide -eq "Cr"){
            $crSideTotal = $balanceFigure
        }
        

        
        
        $balanceFigure=0
        $OpeningBalanceSide = ""

    foreach($ledgerAccount in $ledgerAccounts){
        $jDate = $ledgerAccount.Date
        $Dr_Particular = $ledgerAccount.Dr_Particular
            $Dr_Particular = $Dr_Particular.Trim()
        $Cr_Particular = $ledgerAccount.Cr_Particular
            $Cr_Particular = $Cr_Particular.Replace("To","")
            $Cr_Particular = $Cr_Particular.Trim()
        $Comment = $ledgerAccount.Comment
        $Voucher_Type = $ledgerAccount.Voucher_Type
        $Voucher_No = $ledgerAccount.Voucher_No
        $Amuont = $ledgerAccount.Amuont
        $Comment = $ledgerAccount.Comment

        $arrDr += "DrSide|$jDate|$Cr_Particular|$Voucher_No|$Amuont|$Comment"
        #if($Amuont -eq "232.5"){Write-Host "hold";Start-Sleep 10}
    }#foreach $ledgerAccounts

        
        #CR side calculation

        $ledgerAccounts = $ledgerAccountsMain_Cr | where {$_.date -match $month}

        foreach($ledgerAccount in $ledgerAccounts){
            $jDate = $ledgerAccount.Date
            $Dr_Particular = $ledgerAccount.Dr_Particular
                $Dr_Particular = $Dr_Particular.Trim()
            $Cr_Particular = $ledgerAccount.Cr_Particular
                $Cr_Particular = $Cr_Particular.Replace("To","")
                $Cr_Particular = $Cr_Particular.Trim()
            $Comment = $ledgerAccount.Comment
            $Voucher_Type = $ledgerAccount.Voucher_Type
            $Voucher_No = $ledgerAccount.Voucher_No
            $Amuont = $ledgerAccount.Amuont
            $Comment = $ledgerAccount.Comment

            $arrCr += "CrSide|$jDate|$Dr_Particular|$Voucher_No|$Amuont|$Comment"
        
        }#foreach $ledgerAccounts
    
        $range = 0
        if($arrDr.Count -ge $arrCr.Count){
            $range = $arrDr.Count
        }else{
            $range = $arrCr.Count
        }#else

        for($i = 0; $i -lt $range; $i++){
            if($arrDr[$i] -eq $null){
                $arrDr_Splitted = ""
                $jDate_Dr = ""
                $Dr_Particular_Dr = ""
                $Voucher_No_Dr = ""
                $Amuont_Dr = ""
            }else{
                $arrDr_Splitted = $arrDr[$i].Split("|")
                $jDate_Dr = $arrDr_Splitted[1]
                $Dr_Particular_Dr = "To $($arrDr_Splitted[2])<br>$commentHTMLOpen ($($arrDr_Splitted[5])) $commentHTMLClose"
                $Voucher_No_Dr = $arrDr_Splitted[3]
                $Amuont_Dr = $arrDr_Splitted[4]
                $drSideTotal += $Amuont_Dr
            }

            if($arrCr[$i] -eq $null){
                $arrCr_Splitted = ""
                $jDate_Cr = ""
                $Dr_Particular_Cr = ""
                $Voucher_No_Cr = ""
                $Amuont_Cr = ""
            }else{
                $arrCr_Splitted = $arrCr[$i].Split("|")
                $jDate_Cr = $arrCr_Splitted[1]
                $Dr_Particular_Cr = "By $($arrCr_Splitted[2])<br>$commentHTMLOpen ($($arrCr_Splitted[5])) $commentHTMLClose"
                $Voucher_No_Cr = $arrCr_Splitted[3]
                $Amuont_Cr = $arrCr_Splitted[4]
                $crSideTotal += $Amuont_Cr
            }#else

            $htmlFile += "
            $tr
                $tdLeftSidenDate $jDate_Dr $tdClose
                $tdParticulars $Dr_Particular_Dr $tdClose
                $tdVouch $Voucher_No_Dr $tdClose
                $tdLeftSideAount $Amuont_Dr $tdClose
                $tdRightSidenDate $jDate_Cr $tdClose
                $tdParticulars $Dr_Particular_Cr $tdClose
                $tdVouch $Voucher_No_Cr $tdClose
                $tdRightSidenDate $Amuont_Cr $tdClose
            </tr>
            "
        }#for $i -lt $range

            #calculating closing balance date and opening balance date
            $indexOfCurrentMonth = $monthSequence.IndexOf($month)
            $closingBalanceDate = ""
            $openingBalanceDate = ""
            $indexOfNextMonth = 0

            if($indexOfCurrentMonth -ge $monthSequence.Count-1){
                $closingBalanceDate = $yearEndDate
            }else{
                #decide current year
                $yy = [Int]$yearEndDate.Split("-")[-1] -1
                if( ($($monthSequence[$indexOfCurrentMonth]) -eq "Dec") -or
                    ($($monthSequence[$indexOfCurrentMonth]) -eq "Jan") -or
                    ($($monthSequence[$indexOfCurrentMonth]) -eq "Feb") -or
                    ($($monthSequence[$indexOfCurrentMonth]) -eq "Mar")
                ){
                    $yy = [Int]$yearEndDate.Split("-")[-1]
                }
                $indexOfNextMonth = $indexOfCurrentMonth + 1
                $nextMonth = $monthSequence[$indexOfNextMonth]
                $rawDateString = "01-$nextMonth-$yy"
                $rawDate = Get-Date $rawDateString
                $closingBalanceDate = get-date $rawDate.Add(-1) -Format "dd-MMM-yy"
                $openingBalanceDate = get-date $rawDate -Format "dd-MMM-yy"
            }
            
            

            #closing balance calculation
            #default value of total figure. Will change based upont which side is higher
            $totalFigure = $drSideTotal
            if($drSideTotal -gt $crSideTotal){
                $balanceFigure = $drSideTotal - $crSideTotal
                $totalFigure = $drSideTotal
                $htmlFile += "
                $tr
                    $balanceLeftDate $tdClose
                    $balanceParticular $tdClose
                    $balanceVoucher $tdClose
                    $balanceLeftAmount $tdClose

                    $balanceRightDate $closingBalanceDate $tdClose
                    $balanceParticular By Closing Balance c/d $tdClose
                    $balanceVoucher $tdClose
                    $balanceRightAmount $('{0:N2}' -f $balanceFigure) $tdClose
                </tr>
                "
                #$trialBalanceRawData += "$unique_Dr_Particular|Dr|$balanceFigure"
                
                #Write-Host "$closingBalanceDate - By Closing Balance c/d - $('{0:N2}' -f $balanceFigure)"
            }elseif($crSideTotal -gt $drSideTotal){
                $balanceFigure = $crSideTotal - $drSideTotal
                $totalFigure = $crSideTotal
                $htmlFile += "
                $tr 
                
                
                 
                
                    $balanceLeftDate  $closingBalanceDate $tdClose
                    $balanceParticular To Closing Balance c/d $tdClose
                    $balanceVoucher $tdClose
                    $balanceLeftAmount  $('{0:N2}' -f $balanceFigure) $tdClose

                    $balanceRightDate $tdClose
                    $balanceParticular $tdClose
                    $balanceVoucher $tdClose
                    $balanceRightAmount $tdClose
                </tr>
                "
                }#else

                #total balance calculation
                $htmlFile += "
                $tr 
                    $totalLeftDate $tdClose
                    $totalParticular  $tdClose
                    $totalVoucher  $tdClose
                    $totalLeftAmount $('{0:N2}' -f $totalFigure) $tdClose
                    $totalRightDate $tdClose
                    $totalParticular $tdClose
                    $totalVoucher $tdClose
                    $totalRightAmount $('{0:N2}' -f $totalFigure) $tdClose
                </tr>
                "
 
 
 
 
            #opening balance calculation
            if($drSideTotal -gt $crSideTotal){
                $balanceFigure = $drSideTotal - $crSideTotal
                #$totalFigure = $drSideTotal
                $OpeningBalanceSide = "Dr"
                $htmlFile += "
                $tr
                    $balanceLeftDate $openingBalanceDate $tdClose
                    $balanceParticular To Opening Balance b/d $tdClose
                    $balanceVoucher $tdClose
                    $balanceLeftAmount $('{0:N2}' -f $balanceFigure) $tdClose


                    $balanceRightDate $tdClose
                    $balanceParticular $tdClose
                    $balanceVoucher $tdClose
                    $balanceRightAmount $tdClose


                </tr>
                "
                #$trialBalanceRawData += "$unique_Dr_Particular|Dr|$balanceFigure"
            }elseif($crSideTotal -gt $drSideTotal){
                $balanceFigure = $crSideTotal - $drSideTotal
                #$totalFigure = $crSideTotal
                $OpeningBalanceSide = "Cr"
                $htmlFile += "
                $tr 
   
                    $balanceLeftDate $tdClose
                    $balanceParticular $tdClose
                    $balanceVoucher $tdClose
                    $balanceLeftAmount $tdClose
   
                    $balanceRightDate  $openingBalanceDate $tdClose
                    $balanceParticular By Opening Balance b/d $tdClose
                    $balanceVoucher $tdClose
                    $balanceRightAmount  $('{0:N2}' -f $balanceFigure) $tdClose
                </tr>
                "
                }#else   
    }#foreach $month

    $htmlFile += "
    </table>
    </center>
    <br>
    
    "
    
    #Write-Host "----------Next--------"
}#foreach $unique_Dr_Particular


#"************* SPECIAL LEDGER ACCOUNTS - MONTH BY MONTH DETAIL ENDS HERE *************"


















#****************** PREPARING LEDGER **********************
Write-Host "`n`n************* LEDGER ACCOUNTS *************" -ForegroundColor Yellow
#initialize variables
$drSideTotal = 0
$crSideTotal = 0
$balanceFigure = 0
$totalFigure = 0
$ledgerAccounts = ""
$arr= @()
$arrDr = @()
$arrCr = @()
$ledgerAccountCreated = @()
$trialBalanceRawData = @()

$htmlFile += "

<font face='Calibri'>
<div class=WordSection1>

<p class=MsoNormal align=center style='text-align:center'><b>Samruddhi
Nakshatra Co-Op. Housing Society Ltd.<br>
</b>Indra Collony, Vikasnagar, Kiwale<br>
<u>Tal- Haveli Dist- Pune</u><br>
<b>LEDGER ACCOUNTS</b><br>
$financialYearRange
</p>
</div>


"


#####################################################################
###################### DR side Journal Entry Verification ###########
#####################################################################
$unique_Dr_Particulars = $journals.Dr_Particular | Select-Object -Unique
foreach($unique_Dr_Particular in $unique_Dr_Particulars){
    
    #this array will contain temporary values of Dr side and Cr side
    $arr= @()
    $arrDr = @()
    $arrCr = @()
    $drSideTotal = 0
    $crSideTotal = 0
    $balanceFigure = 0
    $totalFigure = 0

    #collect Dr side detail
    $unique_Dr_Particular
    $ledgerAccounts = $journals | Where-Object -FilterScript {
                                    $_.Dr_Particular -eq $unique_Dr_Particular
                                    }
    #update html file
    $htmlFile += "
    <div class=WordSection1>
        <p class=MsoNormal align=center style='text-align:center'><b>
        $unique_Dr_Particular <br></b>
        $financialYearRange</p>
        </div>
    <center>
    $table
    $tr
      $thLeftSideDate  Date $thClose
      $thParticulars Particulars $thClose
      $thVouch Vouch.No $thClose
      $thLeftSideAount Amount $thClose
      $thRightSidenDate Date $thClose
      $thParticulars Particulars $thClose
      $thVouch Vouch.No $thClose
      $thRightSideAmount Amount $thClose
    </tr>
    "

    
    foreach($ledgerAccount in $ledgerAccounts){
        $jDate = $ledgerAccount.Date
        $Dr_Particular = $ledgerAccount.Dr_Particular
            $Dr_Particular = $Dr_Particular.Trim()
        $Cr_Particular = $ledgerAccount.Cr_Particular
            $Cr_Particular = $Cr_Particular.Replace("To","")
            $Cr_Particular = $Cr_Particular.Trim()
        $Comment = $ledgerAccount.Comment
        $Voucher_Type = $ledgerAccount.Voucher_Type
        $Voucher_No = $ledgerAccount.Voucher_No
        $Amuont = $ledgerAccount.Amuont
        $Comment = $ledgerAccount.Comment

        $arrDr += "DrSide|$jDate|$Cr_Particular|$Voucher_No|$Amuont|$Comment"
        #if($Amuont -eq "232.5"){Write-Host "hold";Start-Sleep 10}
    }#foreach $ledgerAccounts



    #collect Cr side detail
    $ledgerAccounts = $journals | Where-Object -FilterScript {
                                    $_.Cr_Particular -eq $unique_Dr_Particular
                                    }
    foreach($ledgerAccount in $ledgerAccounts){
        $jDate = $ledgerAccount.Date
        $Dr_Particular = $ledgerAccount.Dr_Particular
            $Dr_Particular = $Dr_Particular.Trim()
        $Cr_Particular = $ledgerAccount.Cr_Particular
            $Cr_Particular = $Cr_Particular.Replace("To","")
            $Cr_Particular = $Cr_Particular.Trim()
        $Comment = $ledgerAccount.Comment
        $Voucher_Type = $ledgerAccount.Voucher_Type
        $Voucher_No = $ledgerAccount.Voucher_No
        $Amuont = $ledgerAccount.Amuont
        $Comment = $ledgerAccount.Comment

        $arrCr += "CrSide|$jDate|$Dr_Particular|$Voucher_No|$Amuont|$Comment"
        
    }#foreach $ledgerAccounts
    
    $range = 0
    if($arrDr -ge $arrCr){
        $range = $arrDr.Count
    }else{
        $range = $arrCr.Count
    }#else

    for($i = 0; $i -lt $range; $i++){
        if($arrDr[$i] -eq $null){
            $arrDr_Splitted = ""
            $jDate_Dr = ""
            $Dr_Particular_Dr = ""
            $Voucher_No_Dr = ""
            $Amuont_Dr = ""
        }else{
            $arrDr_Splitted = $arrDr[$i].Split("|")
            $jDate_Dr = $arrDr_Splitted[1]
            $Dr_Particular_Dr = "To $($arrDr_Splitted[2])<br>$commentHTMLOpen ($($arrDr_Splitted[5])) $commentHTMLClose"
            $Voucher_No_Dr = $arrDr_Splitted[3]
            $Amuont_Dr = $arrDr_Splitted[4]
            $drSideTotal += $Amuont_Dr
        }

        if($arrCr[$i] -eq $null){
            $arrCr_Splitted = ""
            $jDate_Cr = ""
            $Dr_Particular_Cr = ""
            $Voucher_No_Cr = ""
            $Amuont_Cr = ""
        }else{
            $arrCr_Splitted = $arrCr[$i].Split("|")
            $jDate_Cr = $arrCr_Splitted[1]
            $Dr_Particular_Cr = "By $($arrCr_Splitted[2])<br>$commentHTMLOpen ($($arrCr_Splitted[5])) $commentHTMLClose"
            $Voucher_No_Cr = $arrCr_Splitted[3]
            $Amuont_Cr = $arrCr_Splitted[4]
            $crSideTotal += $Amuont_Cr
        }#else

        $htmlFile += "
        $tr
            $tdLeftSidenDate $jDate_Dr $tdClose
            $tdParticulars $Dr_Particular_Dr $tdClose
            $tdVouch $Voucher_No_Dr $tdClose
            $tdLeftSideAount $Amuont_Dr $tdClose
            $tdRightSidenDate $jDate_Cr $tdClose
            $tdParticulars $Dr_Particular_Cr $tdClose
            $tdVouch $Voucher_No_Cr $tdClose
            $tdRightSidenDate $Amuont_Cr $tdClose
        </tr>
        "
    }#for $i -lt $range

        #default value of total figure. Will change based upont which side is higher
        $totalFigure = $drSideTotal
        if($drSideTotal -gt $crSideTotal){
            $balanceFigure = $drSideTotal - $crSideTotal
            $totalFigure = $drSideTotal
            $htmlFile += "
            $tr
                $balanceLeftDate $tdClose
                $balanceParticular $tdClose
                $balanceVoucher $tdClose
                $balanceLeftAmount $tdClose

                $balanceRightDate $yearEndDate $tdClose
                $balanceParticular To Closing Balance c/d $tdClose
                $balanceVoucher $tdClose
                $balanceRightAmount $('{0:N2}' -f $balanceFigure) $tdClose
            </tr>
            "
            $trialBalanceRawData += "$unique_Dr_Particular|Dr|$balanceFigure"
        }elseif($crSideTotal -gt $drSideTotal){
            $balanceFigure = $crSideTotal - $drSideTotal
            $totalFigure = $crSideTotal
            $htmlFile += "
            $tr 
                
                
                 
                
                $balanceLeftDate  $yearEndDate $tdClose
                $balanceParticular By Closing Balance c/d $tdClose
                $balanceVoucher $tdClose
                $balanceLeftAmount  $('{0:N2}' -f $balanceFigure) $tdClose

                $balanceRightDate $tdClose
                $balanceParticular $tdClose
                $balanceVoucher $tdClose
                $balanceRightAmount $tdClose
            </tr>
            "
            $trialBalanceRawData += "$unique_Dr_Particular|Cr|$balanceFigure"
        }#else

            $htmlFile += "
            $tr 
                $totalLeftDate $tdClose
                $totalParticular  $tdClose
                $totalVoucher  $tdClose
                $totalLeftAmount $('{0:N2}' -f $totalFigure) $tdClose
                $totalRightDate $tdClose
                $totalParticular $tdClose
                $totalVoucher $tdClose
                $totalRightAmount $('{0:N2}' -f $totalFigure) $tdClose
            </tr>
            "
    
    

    $htmlFile += "
    </table>
    </center>
    <br>
    
    "
    $ledgerAccountCreated += $unique_Dr_Particular
    #Write-Host "----------Next--------"
}#foreach $unique_Dr_Particular



#####################################################################
###################### CR side Journal Entry Verification ###########
#####################################################################
$unique_Cr_Particulars = $journals.Cr_Particular | Select-Object -Unique
foreach($unique_Cr_Particular in $unique_Cr_Particulars){
    
    #this array will contain temporary values of Dr side and Cr side
    $arr= @()
    $arrDr = @()
    $arrCr = @()
    $drSideTotal = 0
    $crSideTotal = 0
    $balanceFigure = 0
    $totalFigure = 0

    #collect Dr side detail
    
    $ledgerAccounts = $journals | Where-Object -FilterScript {
                                    $_.Dr_Particular -eq $unique_Cr_Particular
                                    }
    if($ledgerAccountCreated -contains $unique_Cr_Particular){
        #Write-Host "$unique_Cr_Particular already created" -ForegroundColor Red
    }else{
        Write-Host "$unique_Cr_Particular"
        #Write-Host "$unique_Cr_Particular going to create now" -ForegroundColor Yellow

        #update html file
        $htmlFile += "
        <div class=WordSection1>
            <p class=MsoNormal align=center style='text-align:center'><b>
            $unique_Cr_Particular <br></b>
            $financialYearRange</p>
            </div>
        <center>
        $table
        $tr
            $thLeftSideDate Date $thClose
            $thParticulars Particulars $thClose
            $thVouch Vouch.No $thClose
            $thLeftSideAount Amount $thClose
            $thRightSidenDate Date $thClose
            $thParticulars Particulars $thClose
            $thVouch Vouch.No $thClose
            $thRightSideAmount Amount $thClose
        </tr>
        "

    
        foreach($ledgerAccount in $ledgerAccounts){
            $jDate = $ledgerAccount.Date
            $Dr_Particular = $ledgerAccount.Dr_Particular
            $Cr_Particular = $ledgerAccount.Cr_Particular
                $Cr_Particular = $Cr_Particular.Replace("To","")
                $Cr_Particular = $Cr_Particular.Trim()
            $Comment = $ledgerAccount.Comment
            $Voucher_Type = $ledgerAccount.Voucher_Type
            $Voucher_No = $ledgerAccount.Voucher_No
            $Amuont = $ledgerAccount.Amuont
            $Comment = $ledgerAccount.Comment

            $arrDr += "CrSide|$jDate|$Cr_Particular|$Voucher_No|$Amuont|$Comment"
        }#foreach $ledgerAccounts



        #collect Cr side detail
        $ledgerAccounts = $journals | Where-Object -FilterScript {
                                        $_.Cr_Particular -eq $unique_Cr_Particular
                                        }
        foreach($ledgerAccount in $ledgerAccounts){
            $jDate = $ledgerAccount.Date
            $Dr_Particular = $ledgerAccount.Dr_Particular
            $Cr_Particular = $ledgerAccount.Cr_Particular
                $Cr_Particular = $Cr_Particular.Replace("To","")
                $Cr_Particular = $Cr_Particular.Trim()
            $Comment = $ledgerAccount.Comment
            $Voucher_Type = $ledgerAccount.Voucher_Type
            $Voucher_No = $ledgerAccount.Voucher_No
            $Amuont = $ledgerAccount.Amuont
            $Comment = $ledgerAccount.Comment

            $arrCr += "CrSide|$jDate|$Dr_Particular|$Voucher_No|$Amuont|$Comment"
            
        }#foreach $ledgerAccounts
    
        $range = 0
        if($arrDr -ge $arrCr){
            $range = $arrDr.Count
        }else{
            $range = $arrCr.Count
        }#else

        for($i = 0; $i -lt $range; $i++){
            if($arrDr[$i] -eq $null){
                $arrDr_Splitted = ""
                $jDate_Dr = ""
                $Dr_Particular_Dr = ""
                $Voucher_No_Dr = ""
                $Amuont_Dr = ""
            }else{
                $arrDr_Splitted = $arrDr[$i].Split("|")
                $jDate_Dr = $arrDr_Splitted[1]
                $Dr_Particular_Dr = "To $($arrDr_Splitted[2])<br>$commentHTMLOpen ($($arrDr_Splitted[5])) $commentHTMLClose"
                $Voucher_No_Dr = $arrDr_Splitted[3]
                $Amuont_Dr = $arrDr_Splitted[4]
                $drSideTotal += $Amuont_Dr
            }

            if($arrCr[$i] -eq $null){
                $arrCr_Splitted = ""
                $jDate_Cr = ""
                $Dr_Particular_Cr = ""
                $Voucher_No_Cr = ""
                $Amuont_Cr = ""
            }else{
                $arrCr_Splitted = $arrCr[$i].Split("|")
                $jDate_Cr = $arrCr_Splitted[1]
                $Dr_Particular_Cr = "By $($arrCr_Splitted[2])<br>$commentHTMLOpen ($($arrCr_Splitted[5])</font>) $commentHTMLClose"
                $Voucher_No_Cr = $arrCr_Splitted[3]
                $Amuont_Cr = $arrCr_Splitted[4]
                $crSideTotal += $Amuont_Cr
            }#else

            $htmlFile += "
            $tr 
                $tdLeftSidenDate $jDate_Dr $tdClose
                $tdParticulars $Dr_Particular_Dr $tdClose
                $tdVouch $Voucher_No_Dr $tdClose
                $tdLeftSideAount $Amuont_Dr $tdClose
                $tdRightSidenDate $jDate_Cr $tdClose
                $tdParticulars $Dr_Particular_Cr $tdClose
                $tdVouch $Voucher_No_Cr $tdClose
                $tdRightSideAmount $Amuont_Cr $tdClose
            </tr>
            "
        }#for $i -lt $range

            #default value of total figure. Will change based upont which side is higher
            $totalFigure = $drSideTotal
            if($drSideTotal -gt $crSideTotal){
                $balanceFigure = $drSideTotal - $crSideTotal
                $totalFigure = $drSideTotal
                $htmlFile += "
                $tr 
                    $balanceLeftDate $tdClose
                    $balanceParticular $tdClose
                    $balanceVoucher $tdClose
                    $balanceLeftAmount $tdClose
                    $balanceRightDate $yearEndDate $tdClose
                    $balanceParticular To Closing Balance c/d $tdClose
                    $balanceVoucher $tdClose
                    $balanceRightAmount $('{0:N2}' -f $balanceFigure) $tdClose
                </tr>
                "
                $trialBalanceRawData += "$unique_Cr_Particular|Dr|$balanceFigure"
            }elseif($crSideTotal -gt $drSideTotal){
                $balanceFigure = $crSideTotal - $drSideTotal
                $totalFigure = $crSideTotal
                $htmlFile += "
                $tr 
                    $balanceLeftDate $yearEndDate $tdClose
                    $balanceParticular By Closing Balance c/d $tdClose
                    $balanceVoucher $tdClose
                    $balanceLeftAmount $('{0:N2}' -f $balanceFigure)</b> $tdClose
                    $balanceRightDate $tdClose
                    $balanceParticular $tdClose
                    $balanceVoucher $tdClose
                    $balanceRightAmount $tdClose
                </tr>
                "
                $trialBalanceRawData += "$unique_Cr_Particular|Cr|$balanceFigure"
            }#else

                $htmlFile += "
                $tr 
                    $totalLeftDate $tdClose
                    $totalParticular $tdClose
                    $totalVoucher $tdClose
                    $totalLeftAmount $('{0:N2}' -f $totalFigure)</th>
                    $totalRightDate $tdClose
                    $totalParticular $tdClose
                    $totalVoucher $tdClose
                    $totalRightAmount $('{0:N2}' -f $totalFigure) $tdClose
                </tr>
                "
    
    

        $htmlFile += "
        </table>
        </center>
        <br>
    
        "
        $ledgerAccountCreated += $unique_Cr_Particular
        #Write-Host "----------Next--------"

    }#else $ledgerAccountCreated

}#foreach $unique_Cr_Particular



Write-Host ""
#**************************** TRILA BALANCE ************************************
Write-Host "************* TRILA BALANCE *************" -ForegroundColor Yellow
$htmlFile += "

<div class=WordSection1>

<p class=MsoNormal align=center style='text-align:center'><b>Samruddhi
Nakshatra Co-Op. Housing Society Ltd.<br>
</b>Indra Collony, Vikasnagar, Kiwale<br>
<u>Tal- Haveli Dist- Pune</u><br>
<b>TRIAL BALANCE</b><br>
$financialYearRange
</p>
</div>
<center>
    $table
    $tr
        $thTrialBalParticular Particulars $thClose
        $thTrialBalDrAmount Debit Amount $thClose
        $thTrialBalCrAmount Credit Amount $thClose
    </tr>
"
$drSideTotal=0
$crSideTotal=0
$balanceFigure=0
foreach($line in $trialBalanceRawData){
    $splitLine = $line.Split("|")
    $accountName=$splitLine[0]
    $DrOrCr=$splitLine[1]
    [double]$balanceFigure=$splitLine[2]
    
    $htmlFile += "
    $tr 
        $tdTrialBalParticular $accountName $tdClose
    "
    if($DrOrCr -eq 'Dr'){
        $htmlFile +="
        $tdTrialBalDrAmount $('{0:N2}' -f $balanceFigure) $tdClose
        $tdTrialBalCrAmount  $tdClose
        </tr>
        "
        $drSideTotal+=$balanceFigure
    }else{
        $htmlFile +="
        $tdTrialBalDrAmount  $tdClose
        $tdTrialBalCrAmount $('{0:N2}' -f $balanceFigure) $tdClose
        </tr>
        "
        $crSideTotal+=$balanceFigure
    }#else

    
}#foreach $line in $trialBalanceRawData
$htmlFile += "
    $tr
        $tdTrialBalTotalParticular $tdClose
        $tdTrialBalTotalDrAmount $('{0:N2}' -f $drSideTotal)</b> $tdClose
        $tdTrialBalTotalCrAmount $('{0:N2}' -f $crSideTotal)</b> $tdClose
    </tr>
</table>
"
Write-Host "Dr Total = $drSideTotal | Cr Total = $crSideTotal"



################### convert $trialBalanceRawData data in objects ####################
Function f_TralBalanceConvertToObject{
    foreach($line in $trialBalanceRawData){
        $splitLine = $line.Split("|")
        $accountName=$splitLine[0].Trim()
        $DrOrCr=$splitLine[1]
        [double]$balanceFigure=$splitLine[2]
        #$accountName -match "\d\d\d. "
        $props = [ordered]@{
        'AccountName'=$accountName;
        'DrorCr'=$DrOrCr;
        'BalanceFigure'=$balanceFigure
        }
        New-Object -TypeName psobject -Property $props
    }#foreach

}#f_TralBalanceConvertToObject

$trialBalanceObjs = f_TralBalanceConvertToObject
########################################################################################
######################## Verifying all accounts of Trial Balance is present in Master Sheet
########################
Write-Host
Write-Host "******* Veryfying Trial Balance accoutns present in Master.csv file *******" -ForegroundColor Yellow

#storing all account names in single array
$MasterSingleList = @()
$allColumns = $masterCSV|gm|where {$_.MemberType -eq 'NoteProperty'}|select -ExpandProperty Name
foreach($col in $allColumns){
    $MasterSingleList += $masterCSV.$col | where {$_ -ne ""}
}#foreach $col		

#checking $trialBalanceObjs, if any accountname is missing in $MasterSingleList, same will be highlighted
$missingAccounts = @()
foreach($trialBalanceObj in $trialBalanceObjs){
    $accountName = $($trialBalanceObj.AccountName).Trim()
    $result = $MasterSingleList | where {$_ -eq $accountName}
    if($result -eq $null){
        $missingAccounts += $accountName
    }#if
    
}#foreach trialBalanceObj

if($missingAccounts.Count -gt 0){
    Write-Host "These accounts are missing in Master.csv file. Add them in appropriate section" -ForegroundColor Red
    $missingAccounts
}
###########################################################################################
Write-Host ""
#**************************** Income & Expenditure Statement************************************
Write-Host "************* INCOME & EXPENDITURE STATEMENT *************" -ForegroundColor Yellow
$htmlFile += "
<br>
<div class=WordSection1>

<p class=MsoNormal align=center style='text-align:center'><b>Samruddhi
Nakshatra Co-Op. Housing Society Ltd.<br>
</b>Indra Collony, Vikasnagar, Kiwale<br>
<u>Tal- Haveli Dist- Pune</u><br>
<b>Income & Expenditure Statement</b><br>
$financialYearRange
</p>
</div>
<center>
    $table
         $tr
        $thIncExpCol1 Expenditure $thClose
        $thIncExpCol2 Amount $thClose
        $thIncExpCol3 Income $thClose
        $thIncExpCol4 Amount $thClose
    </tr>
"
$Indirect_Expense = $masterCSV.Indirect_Expense | where {$_ -ne ""}

$totalExpenses=0
$incomeAndExpArr = @()

## Expenses side ####
$accountHeads = @()
$accountHeads += "Indirect_Expense"
$ExpenseArr = @()
foreach($accountHead in $accountHeads){
    $accountHeadItems = $masterCSV.$accountHead | where {$_ -ne ""}
    $title = $accountHead.Replace("_"," ")
    $ExpenseArr += "$title|"
    [double]$BalanceFigure = 0
    foreach($item in $accountHeadItems){
            $item = $item.trim()
            $temps = $trialBalanceObjs | where {$_.AccountName -eq $item}
            foreach($temp in $temps){
                $AccountName = $temp.AccountName
                $BalanceFigure = [double]$temp.BalanceFigure
                if($BalanceFigure -ne 0){
                    $ExpenseArr += "$accountName|$balanceFigure"
                }
            }#foreach temp

    }#foreach item

}#foreach accountHead


## Income side ####
$accountHeads = @()
$accountHeads += "Indirect_Income"
$accountHeads += "Member_Monthly"
$IncomeArr = @()
foreach($accountHead in $accountHeads){
    $accountHeadItems = $masterCSV.$accountHead | where {$_ -ne ""}
    $title = $accountHead.Replace("_"," ")
    $IncomeArr += "$title|"
    [double]$BalanceFigure = 0
    foreach($item in $accountHeadItems){
            $item = $item.trim()
            $temp = $trialBalanceObjs | where {$_.AccountName -eq $item}       
            $AccountName = $temp.AccountName
            $BalanceFigure = $temp.BalanceFigure
            if($BalanceFigure -ne 0){
                $IncomeArr += "$accountName|$balanceFigure"
            }

    }#foreach item

}#foreach accountHead


#creating different columns for Income and Expenditure sections
$range = $ExpenseArr.Count
if ($($IncomeArr.Count) -gt $($ExpenseArr.Count)){
    $range = $IncomeArr.Count
}#if
$leftSideSum = 0
$rightSideSum = 0
for($i = 0; $i -lt $range; $i++){
    
    [string]$accountName = ""
    $BalanceFigure = 0
    $temp = "$tr "
    if(($ExpenseArr[$i] -ne $null) -and ($ExpenseArr[$i] -ne "")){
        $splitLine = $ExpenseArr[$i].Split("|")
        $accountName = $splitLine[0]
        $BalanceFigure = $splitLine[1]
        if(($accountName -ne "") -and ($BalanceFigure -eq 0)){
            $temp += "$tdIncExpCol1<b>$accountName</b> $tdClose
                    $tdIncExpCol2 $tdClose"
        }elseif(($accountName -eq "") -and ($BalanceFigure -eq 0)){
            $temp += "$tdIncExpCol1 $tdClose
                    $tdIncExpCol2 $tdClose"
        }else{
            $temp += "$tdIncExpCol1 $accountName $tdClose
                    $tdIncExpCol2 $('{0:N2}' -f [double]$BalanceFigure) $tdClose"
            $leftSideSum += $BalanceFigure
        }
    }else{
        $temp += "$tdIncExpCol1 $tdClose
                $tdIncExpCol2 $tdClose"
    }#else

    if(($IncomeArr[$i] -ne $null) -and ($IncomeArr[$i] -ne "")){
        $splitLine = $IncomeArr[$i].Split("|")
        $accountName = $splitLine[0]
        $BalanceFigure = $splitLine[1]
        
        if(($accountName -ne "") -and ($BalanceFigure -eq 0)){
            $temp += "$tdIncExpCol3 <b>$accountName</b> $tdClose
                    $tdIncExpCol4 $tdClose"
        }elseif(($accountName -eq "") -and ($BalanceFigure -eq 0)){
            $temp += "$tdIncExpCol3 $tdClose
                    $tdIncExpCol4 $tdClose"
        }else{
            $temp += "$tdIncExpCol3 $accountName $tdClose
                    $tdIncExpCol4 $('{0:N2}' -f [double]$BalanceFigure) $tdClose"
                    $rightSideSum += $BalanceFigure
        }
    }else{
        $temp += "$tdIncExpCol3 $tdClose
                $tdIncExpCol4 $tdClose"
    }#else
    $temp += "</tr>"
    $htmlFile += $temp
}#for loop

#empty $temp variable again
$temp = ""

#decide surplus or deficit in Income and Expenduture Statement
$SurplusOrDeficit = 0
$totalFigure = $rightSideSum
$incomeAndExpAccountResult = ""
if($rightSideSum -gt $leftSideSum){
    $SurplusOrDeficit = $rightSideSum - $leftSideSum
    $incomeAndExpAccountResult = "Surplus"
    $totalFigure = $rightSideSum
    $temp += "
    $tr 
        $tdIncExpBalanceCol1 $incomeAndExpAccountResult $tdClose 
        $tdIncExpBalanceCol2 $('{0:N2}' -f [double]$SurplusOrDeficit) $tdClose
        $tdIncExpBalanceCol3 $tdClose 
        $tdIncExpBalanceCol4 $tdClose
    </tr>            
    "
}elseif($leftSideSum -gt $rightSideSum){
    $SurplusOrDeficit = $leftSideSum - $rightSideSum
    $incomeAndExpAccountResult = "Deficit"
    $totalFigure = $leftSideSum
    $temp += "
    $tr 
        $tdIncExpBalanceCol1 $tdClose 
        $tdIncExpBalanceCol2 $tdClose
        $tdIncExpBalanceCol3 $incomeAndExpAccountResult $tdClose 
        $tdIncExpBalanceCol4 $('{0:N2}' -f [double]$SurplusOrDeficit)</b> $tdClose
    </tr>            
    "
}
$htmlFile += $temp

#empty $temp variable again
$temp = ""

$htmlFile += "
$tr
    $tdIncExpTotalCol1 $tdClose
    $tdIncExpTotalCol2 $('{0:N2}' -f $totalFigure) $tdClose
    $tdIncExpTotalCol3 $tdClose
    $tdIncExpTotalCol4 $('{0:N2}' -f $totalFigure) $tdClose
</tr>
$tdBalanceSheetLastRowSingleLine
</table>
"
Write-Host "It's a $incomeAndExpAccountResult of Rs.$('{0:N2}' -f $SurplusOrDeficit)"
















Write-Host ""
#**************************** BALANCE SHEET ************************************
Write-Host "************* BALANCE SHEET *************" -ForegroundColor Yellow
$htmlFile += "
<br>
<div class=WordSection1>

<p class=MsoNormal align=center style='text-align:center'><b>Samruddhi
Nakshatra Co-Op. Housing Society Ltd.<br>
</b>Indra Collony, Vikasnagar, Kiwale<br>
<u>Tal- Haveli Dist- Pune</u><br>
<b>Balance Sheet</b><br>
$financialYearRange
</p>
</div>
<center>
    $table   
      $tr
        $thBalanceSheetCol1 Liabilities $thClose
        $thBalanceSheetCol2 Amount $thClose
        $thBalanceSheetCol3 Assets $thClose
        $thBalanceSheetCol4 Amount $thClose
    </tr>
"
## Libilities side ####
$accountHeads = @()
$accountHeads += "Capital_Account"
$accountHeads += "Current_Liabilities"
$accountHeads += "Reserve_Funds"
$accountHeads += "Other_Liabilities"	

$liabArr = @()
foreach($accountHead in $accountHeads){
    $accountHeadItems = $masterCSV.$accountHead | where {$_ -ne ""}
    $title = $accountHead.Replace("_"," ")
    $liabArr += "$title|"
    [double]$BalanceFigure = 0
    foreach($item in $accountHeadItems){
            $item = $item.trim()
            $temps = $trialBalanceObjs | where {$_.AccountName -eq $item}       
            foreach($temp in $temps){
                $AccountName = $temp.AccountName
                $BalanceFigure = $temp.BalanceFigure
                if($BalanceFigure -ne 0){
                    $liabArr += "$accountName|$balanceFigure"
                }
            }#foreach

    }#foreach item

}#foreach accountHead

## Assets side ####
$accountHeads = @()
$accountHeads += "Liquid_Asset"
$accountHeads += "Fixed_Asset"
$AssetArr = @()
foreach($accountHead in $accountHeads){
    $accountHeadItems = $masterCSV.$accountHead | where {$_ -ne ""}
    $title = $accountHead.Replace("_"," ")
    $AssetArr += "$title|"
    [double]$BalanceFigure = 0
    foreach($item in $accountHeadItems){
            $item = $item.trim()
            $temps = $trialBalanceObjs | where {$_.AccountName -eq $item} 
            foreach($temp in $temps){
                $AccountName = $temp.AccountName
                $BalanceFigure = $temp.BalanceFigure
                if($BalanceFigure -ne 0){
                    $AssetArr += "$accountName|$balanceFigure"
                }#if
            }#foreach      

    }#foreach item

}#foreach accountHead


#creating different columns for Liabilities and Assets sections
$range = $AssetArr.Count
if ($($liabArr.Count) -gt $($AssetArr.Count)){
    $range = $liabArr.Count
}#if
$leftSideSum = 0
$rightSideSum = 0
for($i = 0; $i -lt $range; $i++){
    
    [string]$accountName = ""
    $BalanceFigure = 0
    $temp = "$tr "
    if(($liabArr[$i] -ne $null) -and ($liabArr[$i] -ne "")){
        $splitLine = $liabArr[$i].Split("|")
        $accountName = $splitLine[0]
        $BalanceFigure = $splitLine[1]
        if(($accountName -ne "") -and ($BalanceFigure -eq 0)){
            $temp += "$tdBalanceSheetCol1<b>$accountName $tdClose
                    $tdBalanceSheetCol2 $tdClose"
        }elseif(($accountName -eq "") -and ($BalanceFigure -eq 0)){
            $temp += "$tdBalanceSheetCol1 $tdClose
                    $tdBalanceSheetCol2 $tdClose"
        }else{
            $temp += "$tdBalanceSheetCol1 $accountName $tdClose
                    $tdBalanceSheetCol2 $('{0:N2}' -f [double]$BalanceFigure) $tdClose"
            $leftSideSum += $BalanceFigure
        }
    }else{
        $temp += "$tdBalanceSheetCol1 $tdClose
                $tdBalanceSheetCol2 $tdClose"
    }#else
    if(($AssetArr[$i] -ne $null) -and ($AssetArr[$i] -ne "")){
        $splitLine = $AssetArr[$i].Split("|")
        $accountName = $splitLine[0]
        $BalanceFigure = $splitLine[1]
        if(($accountName -ne "") -and ($BalanceFigure -eq 0)){
            $temp += "$tdBalanceSheetCol3 <b>$accountName $tdClose
                    $tdBalanceSheetCol4 $tdClose"
        }elseif(($accountName -eq "") -and ($BalanceFigure -eq 0)){
            $temp += "$tdBalanceSheetCol3 $tdClose
                    $tdBalanceSheetCol4 $tdClose"
        }else{
            $temp += "$tdBalanceSheetCol3 $accountName $tdClose
                    $tdBalanceSheetCol4 $('{0:N2}' -f [double]$BalanceFigure) $tdClose"
                    $rightSideSum += $BalanceFigure
        }
    }else{
        $temp += "$tdBalanceSheetCol3 $tdClose
                $tdBalanceSheetCol4 $tdClose"
    }#else
    $temp += "</tr>"
    $htmlFile += $temp
}#for loop


#empty $temp variable again
$temp = ""

#adjust surplus or deficit from Income and Expenduture Statement
##if surplus shot it in Liabilities side, if Deficit then show it in Assets side
#variables
#$SurplusOrDeficit
#$incomeAndExpAccountResult
if($incomeAndExpAccountResult -eq "Surplus"){
    $leftSideSum += $SurplusOrDeficit
    $temp += "
    $tr 
        $tdBalanceSheetCol1 <b>$incomeAndExpAccountResult from Inc. & Exp. Statement</b> $tdClose 
        $tdBalanceSheetCol2 <b>$('{0:N2}' -f [double]$SurplusOrDeficit)</b> $tdClose
        $tdBalanceSheetCol3 $tdClose 
        $tdBalanceSheetCol4 $tdClose
    </tr>            
    "
}elseif($incomeAndExpAccountResult -eq "Deficit"){
    $rightSideSum += $SurplusOrDeficit
    $temp += "
    $tr 
        $tdBalanceSheetCol1 $tdClose 
        $tdBalanceSheetCol2 $tdClose
        $tdBalanceSheetCol3 <b>$incomeAndExpAccountResult from Inc. & Exp. Statement</b> $tdClose 
        $tdBalanceSheetCol4 <b>$('{0:N2}' -f [double]$SurplusOrDeficit)</b> $tdClose
    </tr>            
    "
}
$htmlFile += $temp

#empty $temp variable again
$temp = ""

$htmlFile += "
$tr
    $tdBalanceSheetTotalCol1 $tdClose
    $tdBalanceSheetTotalCol2 $('{0:N2}' -f $leftSideSum)</b> $tdClose
    $tdBalanceSheetTotalCol3 $tdClose
    $tdBalanceSheetTotalCol4 $('{0:N2}' -f $rightSideSum)</b> $tdClose
</tr>
$tdBalanceSheetLastRowSingleLine
</table>
"
Write-Host "Total Liabilities = $leftSideSum| Total Assets = $rightSideSum"







############################################################################
################## DON'T MAKE AND CHANGE BELOW #############################
############################################################################
$htmlFile += "
</font>
</body>
</html>
"

$htmlFile | Out-File -FilePath .\Ledger.Html
if($showReport){
    Start-Process -FilePath .\Ledger.Html
}#if
