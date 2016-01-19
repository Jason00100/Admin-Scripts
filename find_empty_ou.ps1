#This script finds empty sub OUs in the OU listed in the 4th line

function empty_OU{
Get-ADOrganizationalUnit -Filter * -SearchBase "OU=Resource,DC=domain, DC=local" `
| Where-Object {-not ( Get-ADObject -Filter * -SearchBase $_.Distinguishedname -SearchScope OneLevel -ResultSetSize 1 )}`
| Select-Object -ExpandProperty Distinguishedname
}

foreach($i in empty_OU){

#shows progress of script
Write-Output "Removing $i"

#removes accidental deletion of object
Set-ADObject $i -ProtectedFromAccidentalDeletion $false

#removes the object from AD
Remove-ADOrganizationalUnit -Identity $i -confirm:$false

}
