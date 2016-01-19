$user = GC c:\Users\jpeckis\Desktop\scripts\users.txt


    ForEach ($U in $User)
    {   $UN = Get-ADUser $U -Properties MemberOf
        $Groups = ForEach ($Group in ($UN.MemberOf))
        {   (Get-ADGroup $Group).Name
        }
        $Groups = $Groups | Sort
        ForEach ($Group in $Groups)
        {   New-Object PSObject -Property @{
                Name = $UN.Name
                Group = $Group
            }
        }
    }
