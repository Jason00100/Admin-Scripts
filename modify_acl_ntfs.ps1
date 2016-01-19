$folder = "C:\Program Files (x86)\ControlCenter"
$myGroup = "NT AUTHORITY\Authenticated Users" 
$acl = (Get-Item $folder).GetAccessControl('Access')
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
Set-Acl $folder $acl 
