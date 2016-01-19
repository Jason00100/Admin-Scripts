$list = Get-Content c:\path\comp.TXT
foreach ($comp in $list)
{	
	invoke-Expression ".\psexec \\$comp net start NRPE_NT"
}
