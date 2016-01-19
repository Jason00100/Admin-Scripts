
$changeDate = New-Object DateTime(2014, 03, 11, 01, 00, 02)
Get-ADObject -Filter 'whenChanged -gt $changeDate' -SearchBase "OU=Business,OU=Group,OU=Resource,DC=DOMAIN,DC=LOCAL" -Properties *|select CN, Modified |sort Modified |Export-Csv C:\path\Busunit.csv

