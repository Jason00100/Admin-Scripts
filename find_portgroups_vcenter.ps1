Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer nycvcenter01

$info = @()
foreach($dvPortgroup in (Get-VirtualPortgroup -Datacenter Va | Sort Name)){
    $dvPortgroupInfo = New-Object PSObject -Property @{            
        Name = $dvPortgroup.Name
        Key = $dvPortgroup.Key
        VlanId = $dvPortgroup.ExtensionData.Config.DefaultPortConfig.Vlan.VlanId
        Portbinding = $dvPortgroup.Portbinding
        NumPorts = $dvPortgroup.NumPorts
        PortsFree = ($dvPortgroup.ExtensionData.PortKeys.count - $dvPortgroup.ExtensionData.vm.count)
    }  
    $info += $dvPortgroupInfo
}
$info |sort vlanid | Export-Csv -UseCulture -NoTypeInformation C:\path\dvportgroup_info_ash.csv
