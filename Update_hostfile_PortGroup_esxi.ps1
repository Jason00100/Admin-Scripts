foreach($server in (Get-VDPortgroup -Name VDI-124 |Get-VM | Select -ExpandProperty Name)){
 if($server -like "*.*"){
$server = $server.split(".")[0]
}
    $adminpath = Test-Path "\\$Server\admin$" 
    If ($adminpath -eq "True") 
        { 
         $hostfile = "\\$Server\c$\Windows\System32\drivers\etc\hosts" 
         Write-Host –NoNewLine "Updating $Server..." 
         "10.5.91.25`twgt-qa1.domain.com/webgmm" | Out-File $hostfile -encoding ASCII -append 
         "10.5.92.25`twgt-qa2.domain.com/webgmm" | Out-File $hostfile -encoding ASCII -append
         "10.5.93.25`twgt-qa3.domain.com/webgmm" | Out-File $hostfile -encoding ASCII -append
         Write-Host "Done!"  
          
            
        } 
    Else  
        { 
            Write-Host -Fore Red "Can't Access $Server" 
        } 
    
    }
