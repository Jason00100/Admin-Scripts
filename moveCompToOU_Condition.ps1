#this script will move a machine to the proper OU based on OS
foreach($i in (Import-Csv C:\Users\user_machines.csv)){
$dn = Get-ADComputer $i.machine -Properties operatingsystem | select DistinguishedName,operatingSystem
foreach ($machines in $dn){
  if($machines.operatingSystem  -match "Windows 7 Professional"){
   Move-ADObject -Identity $machines.DistinguishedName -TargetPath "OU=WIN7,OU=Desktops,OU=MK,OU=Workstation,OU=Resource,DC=CORPORATE,DC=LOCAL"
   }
   elseif($machines.operatingSystem  -match "Windows 8*"){
   Move-ADObject -Identity $machines.DistinguishedName -TargetPath "OU=WIN8,OU=Desktops,OU=MK,OU=Workstation,OU=Resource,DC=CORPORATE,DC=LOCAL"
   }
   else{
   Write-Output "OS version cannot be located for $machines.DistinguishedName"
   }
  }
