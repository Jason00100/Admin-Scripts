#Gets list of machines from specified OU
Function Get-CompList{
Get-ADObject -Filter { ObjectClass -eq "computer" } -SearchBase "OU=Workstations,OU=Resource,DC=domain,DC=LOCAL" `
| Select-Object -expandproperty Name |Sort
}


<#
Gets a list of local Admin accounts from each computers in OU from Get-Complist function, will ping machine 
to see if its alive and write error message if machine is unavalible
#>
Function Get-AdminGroups{

foreach($i in Get-CompList){
 if (-not (Test-Connection -computername $i -count 1 -Quiet -ErrorAction SilentlyContinue)) {
        write-host $i.toupper() "is Unavalible"  -foreground red
        "`r"
        }
 else {
Write-host "Added $i to list...."
$adsi = [ADSI]"WinNT://$i"

$Object = $adsi.Children | ? {$_.SchemaClassName -eq 'user'} | % {
$UserName = $_.Name -join '';
New-Object -TypeName PSCustomObject -Property @{
    ComputerName = $i.toupper() -join ''
    UserName = $UserName
    Groups = ($_.Groups()  |Foreach-Object {$_.GetType().InvokeMember("Name",'GetProperty', $null, $_, $null)}) -join ',' 
    Disabled = (Get-WmiObject -ComputerName $i -Class Win32_UserAccount -Filter "LocalAccount='$true' and name='$UserName'"`
    |Select-Object -expandproperty Disabled) -join ''
    }  
  } 

   $Object | Select-object ComputerName,UserName,Groups,Disabled |? {$_.Groups -match "Administrators*"}  
   "`r"
   }
  }
 }

$admins = Get-AdminGroups 


#built-in admin account not named "root" will be changed via group policy
 Function Remove-Admin{
  
 foreach($admin in $admins){
 #sets account password and disables all local accounts 

 if($admin.UserName -notlike "root"){
 $user = [ADSI]("WinNT://" + $($admin.computername) + "/" + $($admin.UserName))
 $user.UserFlags[0] = $User.UserFlags[0] -bor 0x2
 $user.SetInfo()
 Write-host "\\$($admin.computername)\$($admin.UserName) has been disabled `r"
 }

 

     }
    }   
   
Remove-Admin 
