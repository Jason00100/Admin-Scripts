$TimeSource = w32tm /query /status
$Source = $TimeSource | ? {$_ -match 'Source:'} | % { ($_ -split ":\s\b")[1] }
 if ($source) { 
  $Source = $Source.Split(" ")[0]
#  $Source = $Source.Replace(",0x1","")
  }
$Offset = w32tm /monitor /computers:$Source | FINDSTR NTP:
$OSF = $Offset.Substring(9,11)

Write-Host $OSF
