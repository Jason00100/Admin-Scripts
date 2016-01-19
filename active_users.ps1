Get-ADUser -Filter {Enabled -eq $true} -Properties SamAccountName,GivenName,SurName,CanonicalName | Select SamAccountName,GivenName,SurName,CanonicalName | Export-CSV c:\corp.csv
