
param(
    [Parameter(Position=0, Mandatory=$True)]
    [string]
    $SamAccountName,

    [Parameter(Position=0, Mandatory=$True)]
    [string]
    $NewName
    )


$DN = Get-ADUser $SamAccountName | select -ExpandProperty DistinguishedName
Rename-ADObject -Identity $DN -NewName $NewName
