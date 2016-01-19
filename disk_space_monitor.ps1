$a =@{Expression={$_.caption};Label="Mount Point";width=17}, `
@{Expression={[math]::round(($_.freespace/1gb),2)};Label="Free Space (GB)";width=15}, `
@{Expression={[math]::round(($_.capacity/1gb),2)};Label="Total Size (GB)";width=15}, `
@{Expression={[math]::round(((($_.capacity-$_.freespace)/$_.capacity)*100),2)};Label="Consumed Space (%)";width=18}

function check_disk
{
$diskspace=Get-WmiObject win32_volume -ComputerName MAILBOX01|? {$_.label -notlike "System Reserved" -and $_.capacity -ne $null -and ($_.capacity-$_.freespace)/$_.capacity -gt .25}|ft $a|Out-String
if ($diskspace.length -ne 0)
{
send_email $diskspace 

}
}

function send_email 
{
param ($space)
Send-MailMessage -To systemsgroup@domain.com `
-from storagealert@domain.com -body $space -subject “Server low on space!  < 20% on Server" -smtpserver ny1mail -priority High
}

check_disk
