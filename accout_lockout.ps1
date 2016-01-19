$DomainControllers = Get-ADDomainController -Filter *

Foreach($DC in $DomainControllers)

 {
 Write-Host $dc
Get-ADUser -Identity user -Server $DC.Hostname -Properties AccountLockoutTime,LastBadPasswordAttempt,BadPwdCount,LockedOut

}
