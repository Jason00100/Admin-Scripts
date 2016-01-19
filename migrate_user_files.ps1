$users = Get-Content C:\Users\userlist_final1.txt

foreach($user in $users){

#checks if user has a home directory if not it creates one in crpabsdfs01
if((Test-Path -Path "\\10.2.29.194\f$\user\$user") -eq $false) {
#creates new path since one does not exist
$CreatePath = New-Item -Path "\\10.1.10.61\f$\UK_Users\$user" -itemtype directory
$CreatePath = "\\10.1.10.61\f$\UK_Users\$user"

#sets file permsion on new folder
$acl = Get-Acl $CreatePath
$permission = "domain\$user","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($accessRule)
$acl | Set-Acl $CreatePath

#adds new home directory to AD
$drive = "\\domain\dfs\Users UK\"
Set-ADUser $user -HomeDirectory ("$drive" + "$user") -HomeDrive H 

  }
  else
  {
#Copies data (only delta if file already exist)
Send-mailmessage -to "User Name <uname@marketaxess.com>" -From "User Name <uname@marketaxess.com>" -Subject "Started Copying $User" -SmtpServer "SMTPServer.domain.com"

robocopy \\10.2.29.194\f$\user\$user \\10.1.10.61\f$\UK_Users\$user /e /COPYALL /xo /Z /R:1000000 /W:1 /LOG+:C:\robocopy.log /tee
#Sets home drive in AD
$drive = "\\domain\dfs\Users UK\"
Set-ADUser $user -HomeDirectory ("$drive" + "$user") -HomeDrive H 

Send-mailmessage -to "User Name <uname@marketaxess.com>" -From "User Name <uname@marketaxess.com>" -Subject "$User has been moved" -SmtpServer "SMTPServer.domain.com"
  }
}
