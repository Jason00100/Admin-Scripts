FUNCTION SCCM-GetComputerByLastLoggedOnUser {

Param([parameter(Mandatory = $true)]$SamAccountName,

    $SiteName="pri",

    $SCCMServer="sccm01.domain.local")

    $SCCMNameSpace="root\sms\site_$SiteName"

    Get-WmiObject -namespace $SCCMNameSpace -computer $SCCMServer -query "select Name from sms_r_system where LastLogonUserName='$SamAccountName'" | select Name

}

SCCM-GetComputerByLastLoggedOnUser
