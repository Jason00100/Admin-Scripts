<#
    .SYNOPSIS 
      Finds users who are logged into a remote machine by using IP or DNS nam
    .EXAMPLE
     Get-LoggedOn -Machine crpnycdc01
     This command finds all users logged into "server"
     .EXAMPLE
     Get-LoggedOn -Machine 10.5.10.221
     This command finds all users logged into "10.5.10.221"

  #>

function Get-LoggedOn {
param(
    [CmdletBinding()] 
    [Parameter(ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)]
    [string[]]$Machine = 'localhost'
)

process {
    foreach ($Computer in $Machine) {
     if($computer -like "10.*"){
        $Computer = ([System.Net.Dns]::GetHostByAddress($computer)).HostName
       }
        quser /server:$Computer | Select-Object -Skip 1 | ForEach-Object {
            $CurrentLine = $_.Trim() -Replace '\s+',' ' -Split '\s'
            $HashProps = @{
                UserName = $CurrentLine[0]
                ComputerName = $Computer
            }

            # If session is disconnected different fields will be selected
            if ($CurrentLine[2] -eq 'Disc') {
                    $HashProps.SessionName = $null
                    $HashProps.Id = $CurrentLine[1]
                    $HashProps.State = $CurrentLine[2]
                    $HashProps.IdleTime = $CurrentLine[3]
                    $HashProps.LogonTime = $CurrentLine[4..6] -join ' '
            } else {
                    $HashProps.SessionName = $CurrentLine[1]
                    $HashProps.Id = $CurrentLine[2]
                    $HashProps.State = $CurrentLine[3]a
                    $HashProps.IdleTime = $CurrentLine[4]
                    $HashProps.LogonTime = $CurrentLine[5..7] -join ' '
            }

            New-Object -TypeName PSCustomObject -Property $HashProps |
            Select-Object -Property UserName,ComputerName,SessionName,Id,State,IdleTime,LogonTime
        }
    }



# Start log off
$session  = Read-host 'Would you like to log off a session?  Enter No or enter Session ID '
 if($session -eq 'No' -or $session -eq 'N'){
 Write-output "Goodbye"
 }

 else{
 LOGOFF $session /server:$Machine
  }
 }
}
