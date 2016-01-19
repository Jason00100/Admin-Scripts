$ErrorActionPreference = "SilentlyContinue"
function get-fowarddnsresult{

    function forward{

            Function get-dnszoneinfo {
            Get-DnsServerZone -ComputerName DNSServer |
              ?{$_.zonetype -like 'Primary' -and $_.isreverselookupzone -like 'False' -and $_.zonename -notlike '_msdcs.domain.ROOT'-and $_.zonename -like 'domain.LOCAL' -or $_.zonename -like 'domain.ROOT' -or $_.zonename -like 'domain2.LOCAL' -or $_.zonename -like 'COM' -or $_.zonename -like 'domain3.LOCAL' -or $_.zonename -like 'mgm' -or $_.zonename -like 'domain4.LOCAL'} |
               select -ExpandProperty zonename
                                     }

    foreach($zone in get-dnszoneinfo){
    Get-DnsServerResourceRecord -ZoneName $zone -ComputerName "DNSServer" -RRType "A" | select -ExpandProperty HostName
                                      }
                    }

    $fowsort = forward |sort

    $fowsort -replace "\..+" | select -Unique
                             }


function get-reverseddnsresult{

    function reverse{

        Function get-dnsreversezoneinfo {
        Get-DnsServerZone -ComputerName DNSServer |
          ?{$_.zonetype -like 'Primary' -and $_.isreverselookupzone -like 'True'} |
           select -ExpandProperty zonename
          }

    foreach($zone in get-dnsreversezoneinfo){
    $list = Get-DnsServerResourceRecord -ZoneName $zone -ComputerName "DNSServer" -RRType "PTR" 
    $list.recorddata.PtrDomainName | ? {$_ -like "*domain.LOCAL." -or $_ -like "*Domain2.ROOT." -or $_ -like "*Domain3.LOCAL." -or $_ -like "*ex." -or $_ -like "*domain4.LOCAL." -or $_ -like "*mgm." -or $_ -like "*QATEST.LOCAL." -or $_.zonename -like '*mar.com.'}
  
      }
     }

    $revsort = reverse | sort


    $revsort  -replace "\..+" | select -Unique

}

$get_reverseddnsresult = get-reverseddnsresult
$get_fowarddnsresult = get-fowarddnsresult


#$compared = 
function DNS-Audit{
foreach($compare in (compare-object -referenceobject $get_fowarddnsresult -differenceobject  $get_reverseddnsresult)){

$slide = if ($compare.SideIndicator -eq "=>"){Write-Output "Record only in Reverse Zone"} else {Write-Output "Record only in Foward Zone"}
 $a = foreach($zone in  Get-DnsServerZone -ComputerName crpnycdcrt01 |select -ExpandProperty zonename){
   Get-DnsServerResourceRecord -ZoneName $zone -ComputerName "crpnycdcrt01" -Name $compare.InputObject -ErrorAction SilentlyContinue |select hostname, distinguishedname
    }

$a = $a.distinguishedname.split('=')[2].split(',')[0] 

New-Object PSObject -Property @{
 Record = $compare.InputObject
 SideIndicator = $slide  #make output more understandable 
 'Record Location' = $a
  }
 }
 }

DNS-Audit #| Out-File C:\path\dns_audit.csv -Append
