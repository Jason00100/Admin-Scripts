function check_exp
{
$today = get-date

foreach($user in (Get-ADuser -filter * -Properties AccountExpirationDate, enabled, DisplayName| ? {$_.AccountExpirationDate -ne $null -and $_.enabled -eq $true}))
{
  
  if (($user.AccountExpirationDate-$today).days -lt 8 -and ($user.AccountExpirationDate-$today).days -gt 0)
  {

    $logon=$user.SamAccountName
	$displayname=$user.displayname
	$mgrsam=(get-aduser (get-aduser $user.SamAccountName -ErrorAction SilentlyContinue -Properties manager).manager).samaccountName
    $mgr=(get-aduser (get-aduser $user.SamAccountName -ErrorAction SilentlyContinue -Properties manager).manager).Name 
	$mgremail=(get-aduser $mgrsam -Properties EmailAddress).EmailAddress
	$expiration=$user.AccountExpirationDate
	$expday=($user.AccountExpirationDate-$today).days



    if ($mgr -eq $null)
	{
	$mgr="None assigned"
	send_email_expiring $mgr $displayname $expiration $expday
	}
	else
	{
    
    send_email_expiring $mgr $displayname $expiration $expday
	send_email_expiring_mgr $mgremail $displayname $expiration $expday
	}
   }
   
elseif (($user.AccountExpirationDate-$today).hours -lt 0)
{
	$logon=$user.SamAccountName
	$displayname=$user.displayname
	$mgr=(get-aduser (get-aduser $user.SamAccountName -Properties manager).manager).samaccountName
	$mgremail=(get-aduser $mgr -Properties EmailAddress).EmailAddress
	$expiration=$user.AccountExpirationDate
	$exphour=[math]::round([math]::abs(($user.AccountExpirationDate-$today).TotalHours), 0)
	
	if ($mgr -eq $null)
	{
	$mgr="None assigned"
	$status="Account disabled"
	send_email_expired $displayname $exphour $mgr $status
	Disable-ADAccount $user.SamAccountName
	Set-ADUser $user.SamAccountName -AccountExpirationDate $null
	}
	else
	{
    
	$status="Account disabled and manager notified"
	send_email_expired $displayname $exphour $mgr $status
	send_email_expired_mgr $mgremail $displayname $exphour
	Disable-ADAccount $user.SamAccountName
	Set-ADUser $user.SamAccountName -AccountExpirationDate $null

	}

}}}


function send_email_expiring
{
param($m,$display,$exp,$day)
Send-MailMessage -From account.expiration.alert@domain.com `
-To hrteam@mdomain.com,systems@domain.com,helpdesk@domain.com,security1@domain.com `
-Subject "$display user account will be disabled in $day days" `
-Body "USER: $display`nMANAGER: $m`nDAYS TO EXPIRATION: $day`nACCOUNT EXPIRATION DATE: $exp" -SmtpServer ny1mail
}

function send_email_expired
{
param($display,$hour,$m,$note)
Send-MailMessage -From account.expiration.alert@marketaxess.com `
-To rteam@mdomain.com,systems@domain.com,helpdesk@domain.com,security1@domain.com `
-Subject "Final Warning, $display user account has been disabled" `
-Body "MANAGER: $m`nHOURS EXPIRED: $hour`nSTATUS: $note" -SmtpServer ny1mail
}

function send_email_expiring_mgr
{
param($mgr,$display,$exp,$day)
Send-MailMessage -From account.expiration.alert@domain.com `
-To $mgr -Subject "$display user account will be disabled in $day days" `
-Body "Please contact HR at HRTeam@domain.com if this account should be renewed or may be disabled in error. `
`nUSER: $display`nDAYS TO EXPIRATION: $day`nACCOUNT EXPIRATION DATE: $exp" -SmtpServer ny1mail
}

function send_email_expired_mgr
{
param($mgre,$display,$hour)
Send-MailMessage -From account.expiration.alert@domain.com `
-To $mgre -Subject "Final Warning, $display user account has been disabled" `
-Body "Please contact HR at HRTeam@domain.com if this account has been renewed or disabled in error. `
`nUSER: $display`nHOURS EXPIRED: $hour`nSTATUS: Account Disabled" -SmtpServer ny1mail
}

 

check_exp
