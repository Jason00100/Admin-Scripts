param(
    [Parameter(Position=0, ParameterSetName="Name",Mandatory=$True)]
    [string]
    $Name
    )

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
Get-DistributionGroup | ? {$_.ManagedBy -like "*$name*"} |fl Name, Managedby
