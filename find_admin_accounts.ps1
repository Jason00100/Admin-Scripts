Function Find-Server{
foreach ($findserver in (Get-ADComputer -filter * -Properties operatingSystem | select OperatingSystem,Name)){

  if($findserver.operatingSystem  -match "Windows Server*"){
    $findserver.Name
   }
  }
 }

 $findserver = Find-Server

  foreach($server in  $findserver){
  if (-not (Test-Connection -computername $server -count 1 -Quiet -ErrorAction SilentlyContinue)) {
        Write-Warning "$server is not pingable"
    
        }
 else {

function get-localadministrators {
    param ([string]$computername=$server)

    $computername = $computername.toupper()
    try{
    $ADMINS = get-wmiobject -computername $computername -query "select * from win32_groupuser where GroupComponent=""Win32_Group.Domain='$computername',Name='administrators'""" -ErrorAction Stop| % {$_.partcomponent}
  

    foreach ($ADMIN in $ADMINS) {
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_UserAccount.Domain=","") # trims the results for a user
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_Group.Domain=","") # trims the results for a group
                $admin = $admin.replace('",Name="',"\")
                $admin = $admin.REPLACE("""","")#strips the last "

                $objOutput = New-Object PSObject -Property @{
                    Machinename = $computername
                    Fullname = ($admin)
                    DomainName  =$admin.split("\")[0]
                    UserName = $admin.split("\")[1]
                }#end object

    $objreport+=@($objoutput)
    }#end for

   return $objreport
   }

    catch{
    Write-Warning "Cannont connect to $computername over WMI"
    Write-Output "Cannont connect to $computername over WMI" | Out-File C:\Script_logs\server_local_admin_wmi_error$(get-date -f MM-dd-yyyy).log -Append
    }
}
 

$accounts = get-localadministrators
#$accounts.username 
   foreach($account in $accounts.username){
   if ((Get-Content C:\path\admin_accounts.txt | Select-String $account) -match $account){
   Write-Output "$account is on $server"
   Write-Output "$account is on $server" | Out-File C:\Script_logs\server_local_admin$(get-date -f MM-dd-yyyy).log -Append
   }
   else {
   #can add output here
    }
   }
    
     
}

}
