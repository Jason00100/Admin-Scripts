$list = Get-Content "c:\Users\user\list.txt"
ForEach ($comp in $list)
{Get-ADComputer $comp | Move-ADObject -TargetPath 'ou=Workstations,ou=Resources,dc=domain,dc=local'
}
