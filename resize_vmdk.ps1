Param(
[Parameter(Position=0,mandatory=$true)]
[string]$computername,
[Parameter(Position=1,mandatory=$true)]
[int]$newsize
)

$VMHDD = Get-HardDisk -vm $computername | ? {$_.Name -eq "hard disk 1"} 

#Set-HardDisk -harddisk $VMHDD -CapacityGB (([int]$vmhdd.CapacityGB) + ([int]$newsize)) -Confirm:$false

Invoke-Command -ComputerName $computername -ScriptBlock {"rescan","select volume 1","extend" | diskpart}

#"list volume" | diskpart |findstr Boot ### use this to find the boot disk 
