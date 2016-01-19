$Destination_Group = "CN=team-group,OU=BU,OU=Groups,OU=Resources,DC=domain,DC=LOCAL" 
$Destination_OU = "OU=UK,OU=MTX,OU=Users,OU=Resources,DC=domain,DC=LOCAL"

foreach($user in (Get-ADUser –Filter * -Searchbase "OU=old_OU,OU=Users,OU=Resources,DC=domain,DC=LOCAL" |Select-Object -expand samaccountname)){
Add-ADGroupMember -Identity $Destination_Group -Members $user
Get-ADUser $user| Move-ADObject -TargetPath $Destination_OU
}
