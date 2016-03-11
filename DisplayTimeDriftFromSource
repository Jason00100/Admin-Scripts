$DefaultGateway = (Get-wmiObject Win32_networkAdapterConfiguration | ?{$_.IPEnabled}).DefaultIPGateway
$OffSet = w32tm /monitor /computers:$DefaultGateway | FINDSTR NTP:
$OffsetFormated = $Offset.Substring(9,11)

Write-Host $OffsetFormated
