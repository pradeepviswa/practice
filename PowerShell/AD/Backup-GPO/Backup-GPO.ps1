#Enter Policy name here
$gpoName1 = "TZC WSUS Policy - ABN"
$gpoName2 = "TZC WSUS Policy - ABN"

#get domiin names
$domains = Get-Content "E:\AdminTools\Pradeep\Backup-GPO\Domains.txt"

#variable where failed domain names will be saved
$failed_Domains = @()

#start looping all domains
foreach($domain in $domains){
    #create folder to store backup
    $Path = "E:\AdminTools\Pradeep\Backup-GPO\GPO"
    New-Item -ItemType Directory -Path $Path -ErrorAction SilentlyContinue | Out-Null
    $backup_path = "$Path\$domain"
    New-Item -ItemType Directory -Path $backup_path -ErrorAction SilentlyContinue | Out-Null


    try{
        Backup-GPO -Name $gpoName1 -Path $backup_path -Domain $domain -ErrorAction Stop
    }catch{
        try{
            Backup-GPO -Name $gpoName2 -Path $backup_path -Domain $domain -ErrorAction Stop
        }catch{
            Write-Host "$domain failed" -ForegroundColor Red
            $failed_Domains += $domain
        }
        
    }
}

$failed_Domains | Out-File "E:\AdminTools\Pradeep\Backup-GPO\Failed_Domains.txt"
Write-Host "Done" -ForegroundColor Yellow


