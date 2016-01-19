Param(
[Parameter(Position=0,mandatory=$true)]
[array]$Machines
)

foreach($machine in $machines){

Get-WmiObject Win32_OperatingSystem -computer $machine  | select caption | %{

New-Object -TypeName PSCustomObject -Property @{
    ComputerName = $machine -join ''
    "OS Version" = $_.caption -join ''
   }
    }  
  } 
