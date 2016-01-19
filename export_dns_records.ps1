Function Get-CorpDNS{
foreach($dns in (Get-Content C:\users\jorodriguez\Desktop\dns.txt)){
Write-Output `n
Write-output "DNS Server"
Write-Output $dns
 $line = "-" * $dns.Length 
Write-Output $line
   foreach($zone in (Get-DnsServerZone -ComputerName $dns)){
    Write-Output `n
    Write-Output "Zone"
    Write-Output $zone.zonename
     $zone_line = "-" * $zone.zonename.Length 
    Write-Output $zone_line

  Get-DnsServerResourceRecord -ComputerName $dns -ZoneName $zone.zonename | 
    Where-Object  {$_.RecordData.IPv4Address -like '10.1*' -or $_.RecordData.IPv4Address -like '192.*'}
 } 
}
}
Get-CorpDNS |Out-File C:\Users\corp_dns_records.txt

(Get-WmiObject -ComputerName comp -Class Win32_NetworkAdapterConfiguration).DNSServerSearchOrder
