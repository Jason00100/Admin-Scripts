$Outlook       = New-Object -com Outlook.Application 
$Namespace     = $outlook.GetNamespace("MAPI")
$PublicFolder  = $Namespace.Folders.Item("Public Folders - user@domain.com") 
$PublicFolders = $PublicFolder.Folders.Item("All Public Folders")
$AddressBook   = $PublicFolders.Folders.Item("Employee Contact")
$Contacts      = $AddressBook.Items
$Contacts | select *
