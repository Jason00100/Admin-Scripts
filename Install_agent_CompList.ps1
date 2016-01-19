$DriveLetter = 'c'
$path = 'Software'
$logpath = 'C:\Script_logs'

#creates folder on local machine to save logs to
   if(-not (Test-Path $logpath)){
      New-Item -Path $logpath -type directory -Force |Out-Null
    }

#begin main script
foreach ($computer in (gc C:\Users\\oneoff.txt)){

if($computer -like "10.*"){
  $Computer = [System.Net.Dns]::GetHostByAddress($computer)
  $Computer = $computer.HostName
  }

try{
    if(Test-Path \\$Computer\$DriveLetter$\$path -PathType Container -ea Stop){
        Write-Output "Trying to install application on $computer..."
        
    }

    else{
        Write-Output "Creating $logpath on $computer"
        New-Item -Path \\$Computer\$DriveLetter$\$Path -type directory -Force -ea Stop |Out-Null
    }
    Write-output "Copying files"
    Copy-Item -Path C:\Users\\vcmagent\* -Destination \\$Computer\$DriveLetter$\$Path -Force

  $args = “cmd /c c:\software\CMAgentInstall.exe /s INSTALLPATH=%Systemroot%\CMAgent PORT=26542 CERT=C:\Software\VMware_VCM_Enterprise_Certificate_E3542E5E-AA64-40C9-8519-9A5F8293F3AB.pem"
  $result = Invoke-WmiMethod -ComputerName $computer -Class Win32_Process -Name Create -ArgumentList $args
 if ($result.ReturnValue -ne 0)
        {
           $exception = New-Object System.ComponentModel.Win32Exception([int]$result.ReturnValue)
           $msg_failinstall = "Error launching installer on computer ${computer}: $($exception.Message)"
            Write-Warning $msg_install
            $msg_failinstall |Out-File $logpath\application_install_$(get-date -f MM-dd-yyyy).log -Append
           
        }
    else {
            $msg_successinstall = "Application has installed successfully on $computer"
            Write-Output $msg_successinstall
            $msg_successinstall |Out-File $logpath\application_install_$(get-date -f MM-dd-yyyy).log -Append

    }

}
    catch{
    $msg_connect = "Can't connect to $computer"
    Write-Warning $msg_connect
    $msg_connect |Out-File $logpath\connection_install_$(get-date -f MM-dd-yyyy).log -Append
    }
}
