  function Get-InstalledApps{    
       param( [Parameter(Mandatory=$True)]
           $ComputerName
    )
 
    $array = @()
    foreach($basekey in ('SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall','SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall')){
 
    $remoteBaseKeyObject = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computername)
    $remoteBaseKey = $remoteBaseKeyObject.OpenSubKey($basekey)
    $subKeys = $remoteBaseKey.GetSubKeyNames()
        
    foreach($key in $subKeys){
        $thisKey=$basekey+'\'+$key         
        $thisSubKey=$remoteBaseKeyObject.OpenSubKey($thisKey)
        $psObject = New-Object PSObject
        $psObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $computername
        $psObject | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName")) -ea SilentlyContinue
        $psObject | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion")) 
        $psObject | Add-Member -MemberType NoteProperty -Name "InstallLocation" -Value $($thisSubKey.GetValue("InstallLocation")) -ea SilentlyContinue
        $psObject | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $($thisSubKey.GetValue("Publisher")) -ea SilentlyContinue
        $psObject | Add-Member -MemberType NoteProperty -Name "Uninstallstring" -Value $($thisSubKey.GetValue("UninstallString")) -ea SilentlyContinue
        $array += $psObject
    }          
    $array #| ? {$_.DisplayName -like "*Market*Axess*"}
     }
   
   }

   Get-InstalledApps
