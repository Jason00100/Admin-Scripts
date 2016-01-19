Param(
[Parameter(Position=0,mandatory=$true)]
[string]$Username
)

Function Get-MyModule 
{ 
if(-not(Get-Module -name "ActiveDirectory")) {
try
{
Import-Module ActiveDirectory -ErrorAction Stop
}
catch{
Write-Output "Please install Windows Server Administrator tools"
  }
 }
}

Function Check-account{
get-aduser -Identity $Username
}

Function Check-GID{ 
$user = ("g_" + "$username")
get-adgroup -SearchBase "OU=UnixGroups,OU=Group,OU=Resource,DC=domain,DC=LOCAL" -filter 'Name -eq $user'
}

Function NextGid {
#gets the next avalible gid number to assign to the object
$number = (Get-ADObject -SearchBase "OU=UnixGroups,OU=Group,OU=Resource,DC=domain,DC=LOCAL" -filter {gidnumber -like "*"}  -Properties gidnumber | 
  select -ExpandProperty gidnumber | sort gidnumber) | sort
$gidnum = for($i=0; $i -lt $number.length; $i++) {if( $number[$i+1]-$number[$i] -gt 1) {$number[$i]+1; break} }


#skips GID 8000 
  if ($gidnum -eq 8000){
    $gidnum = 8001
    $gidnum
  }
  else{
    $gidnum 
 }
}

$nextid = NextGid

Function Create-Group{
$group_name = ("g_" + "$username")
#creates group
New-ADGroup -Path "OU=UnixGroups,OU=Group,OU=Resource,DC=domain,DC=LOCALL" -Name $group_name -GroupScope Global

#adds unix attributes to newly created group
Set-ADGroup -Identity $group_name -Add @{"gidNumber" = "$nextid"}
Set-ADGroup -Identity $group_name -Add @{"msSFU30NisDomain" = "domain"}
}

Function Check-user{
$check = get-aduser -Identity $Username -Properties * |select -expandproperty uidNumber 
if($check -ne $null){
    Write-Output "$Username already has a UID #$check"
}

else {

    Write-Output "Setting Unix Username"
    Set-ADUser -Identity $Username -add @{msSFU30Name = $Username}
    Write-Output "Setting NIS Domain"
    Set-ADUser -Identity $Username -Add @{msSFU30NisDomain = "domain"}
    Write-Output "Setting Login Shell"
    Set-ADUser -Identity $Username -add @{loginshell = '/bin/bash'}
    Write-Output "Setting Home Directory"
    Set-ADUser -Identity $Username -add @{unixHomeDirectory = "/home/$username"}
    Write-Output "Setting UID"
    Set-ADUser -Identity $Username -add @{uid = $Username}
    Write-Output "Setting GID"
    Set-ADUser -Identity $Username -add @{gidnumber = "$nextid"}
    Write-Output "Setting UID Number"
    Set-ADUser -Identity $Username -add @{uidnumber = "$nextid"}
    Write-Output "Setting Uninx User Password"
    Set-ADUser -Identity $Username -add @{unixUserPassword = "PASSWORD@"}

    Write-Output "Unix attributes added to $username"
  }
}


$check = Check-GID
$check_account = Check-account

if(($check -eq $null) -and ($check_account -ne $null)){
NextGid
Create-Group
Check-user
Write-Output "Created Group and updated $username Unix attributes"
}

else {
if ($check_account -ne $null){
Check-account
Check-user
 }
}
