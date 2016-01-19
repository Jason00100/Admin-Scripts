Function DNS
{
$i = 1
Do 
{
Write-Output "------------------------------------" 
Get-Date
Invoke-Expression ".\ns_bench.exe 10.10.12.21 10.10.11.21 10.10.50.21"
Invoke-Expression "nslookup ServerName"
#Start-Sleep -Seconds 1
Write-Output $i
$i++
}

while ($i -lt 50)

}

DNS #| Tee-Object -FilePath c:\temp\out.txt
