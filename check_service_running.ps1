Foreach($computer in (Get-Content C:path\hostlist.txt)){

  if($computer -like "10.*"){
  $Computer = [System.Net.Dns]::GetHostByAddress($computer)
  $Computer = $computer.HostName
  }
  try{
$service = Get-WmiObject -ComputerName $computer -class Win32_Service -ea stop| ? {$_.Name -eq "CSI Socket Listener" -and $_.State -eq "Running"}
  if($service -eq $null){
  Write-Host "$computer does not have CM Socket Listener" -ForegroundColor Red
  $computer | Out-File C:\path\file.log -Append
  }
   else{
      Write-Output "$computer is good"
      }
}
catch{
Write-Host "Cannont RPC to $computer" -ForegroundColor Yellow
 }
}



Get-WmiObject -ComputerName server -class Win32_Service -ea stop 
