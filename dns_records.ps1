$domainnames =  Get-DnsServerZone -ComputerName DNSServer | ? {($_.IsReverseLookupzone -like "false") -and ($_.ZoneType -like "Primary") } |select -ExpandProperty ZoneName

foreach ($domainname in $domainnames){
function list{

get-wmiobject -ComputerName DNSServer -Namespace root\microsoftDNS -Class MicrosoftDNS_ResourceRecord -Filter "domainname='$domainname'" |
 select IPAddress, ownername |
  ? {($_.IPAddress -like '10.x.*') -or ($_.IPAddress -like '10.x.*') -and ($_.IPAddress -notlike $null)} |
  Sort IPAddress #|
  #export-csv C:\Upath\$domainname.csv  -NoTypeInformation
  }


ForEach($ip in list){
$ipnew = $ip.ownername -replace "\..+"
#Remove-DnsServerResourceRecord -ZoneName "corporate.local" -RRType "A" -Name $($ip.ownername) -RecordData $($ip.IPAddress)
dnscmd DNSServer /RecordDelete $domainname $ipnew A $ip.IPAddress /f
Write-output "$ipnew $($ip.IPAddress) has been removed from DNS" 
}
 }
