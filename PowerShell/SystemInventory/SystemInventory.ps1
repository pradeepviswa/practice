
param(
[String[]]$computernames = "$($env:COMPUTERNAME)"
)




try{
    
    foreach($computername in $computernames){
        $cs = Get-CimInstance -ClassName WIN32_computersystem -ComputerName $computername -ErrorAction Stop 
        $DNSHostName = $cs.DNSHostName
        $Domain = $cs.Domain
        $Manufacturer = $cs.Manufacturer
        $Model = $cs.Model
        $NumberOfLogicalProcessors = $cs.NumberOfLogicalProcessors
        $NumberOfProcessors = $cs.NumberOfProcessors
        $SystemType = $cs.SystemType

        $bios = Get-CimInstance -ClassName Win32_BIOS -ComputerName $computername -ErrorAction Stop 
        $SerialNumber = $bios.SerialNumber

        $os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computername -ErrorAction Stop 
        $OSArchitecture = $os.OSArchitecture
        $InstallDate = $os.InstallDate
        $Caption = $os.Caption
        $CSName = $os.CSName

        $props = [ordered]@{
            'DNSHostName' = $DNSHostName;
            'HostName' = $CSName;
            'Domain' = $Domain;
            'Manufacturer' = $Manufacturer;
            'Model' = $Model;
            'NumberOfLogicalProcessors' = $NumberOfLogicalProcessors;
            'NumberOfProcessors' = $NumberOfProcessors;
            'SystemType' = $SystemType;

            'SerialNumber' = $SerialNumber;

            'OSArchitecture' = $OSArchitecture;
            'OSInstallDate' = $InstallDate;
            'OSCaption' = $Caption


        }#props

        $obj = New-Object -TypeName psobject -Property $props
        Return $obj

    
    }#foreach

    
}catch{
    $er = $Error[0].Exception.Message
    Write-Host "Error: $er" -ForegroundColor Red
}

