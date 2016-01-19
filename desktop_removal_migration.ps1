#need to check if admin account already exists and if it does skip name change

#enable admin account
foreach($computer in Get-Content C:\Users\gf.txt){

#test if computer is alive (pingable)
if (-not (Test-Connection -computername $computer -count 1 -Quiet -ErrorAction SilentlyContinue)) {  
       Write-Warning "$computer is Unavalible" 
       $computer | Out-File C:\Users\\bad_gf_desktop.log -Append
        }

         else {
      Write-Output "Added $computer to working list...." 
      $computer |Out-File C:\Users\good_gf_desktop.log -Append
    
    #start timestamp
    $starttime = get-date
    Write-Output "Script started at $($starttime.ToShortTimeString())"

    #removes SEP
   

        Invoke-Command -ComputerName $computer -Verbose -ScriptBlock {
    
        #rename local admin account to Administrator
        Write-Output "Renaming Local Admin Account...."
        $newname = "Administrator"
        $user = Get-WMIObject Win32_UserAccount -Filter "Name='Root'"
        $user.Rename($newName) |Out-Null

        #resets local admin password
        Write-Output "Changing Local Password...."
        $newpassword = "CNewPass2014"
        $user = [ADSI]"WinNT://./$newName"
        $user.SetPassword("$newpassword")

   
 } -ErrorVariable tasks_error
 
        
    $endtime = get-date
    Write-Output "Script completed at $($endtime.ToShortTimeString())"
    $totaltime = New-TimeSpan -Start $starttime -End $endtime
    Write-Output "Script took $($totaltime.minutes) minutes $($totaltime.seconds) seconds"
 }
}

$removeapp_error | Out-File C:\Users\gf_desktop.log -Append
$tasks_error | Out-File C:\Users\gf_desktop.log -Append
