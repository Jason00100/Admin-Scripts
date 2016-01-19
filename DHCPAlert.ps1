<#
This script sends an alert if the DHCP service fails. Attempts to start the service, then send status.
#>

function CheckService{
 $Service = Get-Service DHCPServer
 if (Service.Status -ne "Running"){
 Start-Service DHCPServer
 Write-Host "DHCP is still down. Check server CorpDHCPServer"
 }
 if ($Service.Status -eq "running"){ 
 Send-MailMessage -to "user <user@email.com>" -From "DHCPAlerts <dhcpalerts@email.com>" -Subject "DHCP Service is started" -SmtpServer relay.email.com
  }
 }

Send-MailMessage -to "user <user@email.com>" -From "DHCPAlerts <dhcpalerts@email.com>" -Subject "DHCP is down on CorpDHCPServer, attempting to start.." -SmtpServer relay.email.com
Start-Service dhcpserver
CheckService
