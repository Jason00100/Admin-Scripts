Get-WmiObject -Class Win32_IP4RouteTable  | ? { $_.destination -eq '0.0.0.0' -and $_.mask -eq '0.0.0.0'} | 
  Sort-Object metric1 | 
    select -expand nexthop
