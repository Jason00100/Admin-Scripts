foreach($computername in (Get-Content C:\Users\set_perms.txt)){
Write-Output "Working on $computername"
$session = New-PSSession -ComputerName $ComputerName

    foreach($folder in (Invoke-Command -session $Session {ls 'C:\Program Files (x86)' | ?{$_.name -like 'Precision*Arc*'}})){
    #Write-Output $folder.FullName
    Invoke-Command -session $Session {

    $myGroup = "NT AUTHORITY\Authenticated Users"
    $acl = Get-Acl $args
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "Write", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "Read", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "ListDirectory", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$myGroup", "Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl $args $acl 
      } -ArgumentList $($folder.FullName)
     }
 }
