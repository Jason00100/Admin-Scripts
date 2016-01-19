write-host "Will find the AD location of a host"
$UN = Read-Host 'Enter host name'
dsquery computer "DC=DOMAIN,DC=LOCAL" -name $un
