cls
$list = Import-Csv C:\temp\list.csv
foreach($i in $list){
Get-ADComputer $i -Property * | Select-Object Name,OperatingSystemn

}
