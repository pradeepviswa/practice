 $servers="server1.mydomain.net","server1.mydomain.net"
 
  foreach($server in $servers){
  
 $a=Get-WmiObject -Class win32_computerSystem -ComputerName $server | select -Property name,model
 $name=$a.name
 $mode= $a.model
  Write-Host "$name  $model"
}
