  #function to create alternating color rows 
   Function Set-AlternatingRows {
    [CmdletBinding()]
   	Param(
       	[Parameter(Mandatory,ValueFromPipeline)]
        [string]$Line,
       
   	    [Parameter(Mandatory)]
       	[string]$CSSEvenClass,
       
        [Parameter(Mandatory)]
   	    [string]$CSSOddClass
   	)
	Begin {
		$ClassName = $CSSEvenClass
	}
	Process {
		If ($Line.Contains("<tr><td>"))
		{	$Line = $Line.Replace("<tr>","<tr class=""$ClassName"">")
			If ($ClassName -eq $CSSEvenClass)
			{	$ClassName = $CSSOddClass
			}
			Else
			{	$ClassName = $CSSEvenClass
			}
		}
		Return $Line
	}

}

#sets css 
$Head = @" 
		<style>
		TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
		TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
		TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
		.odd  { background-color:#ffffff; }
		.even { background-color:#dddddd; }
		</style> 
"@

$header = "<H1>Objects in /Computers OU</H1>" 
$title = "Objects in /Computers OU" 


#gets data
$data = Get-ADObject -SearchBase "CN=Computers,DC=domain,DC=LOCAl" -Filter 'objectclass -eq "computer"' -Properties * |
   select Name,WhenCreated,OperatingSystem |sort -Descending whenCreated |ConvertTo-Html  -Title $title -head $Head |Set-AlternatingRows -CSSEvenClass even -CSSOddClass odd |Out-String

#sends email

Send-MailMessage -To  user@domain.com `
-from adalert@domain.com -body $data -BodyAsHtml -subject “Objects in Computers OU (domain.local)" -smtpserver SMTPServer 

   
