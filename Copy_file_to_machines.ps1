foreach($i in (Get-Content C:\path\copy.txt)){
Write-Output "Copying to $i"
Copy-Item C:\users\path\Downloads\NDP451-KB2858728-x86-x64-AllOS-ENU.exe -Destination ("\\" + $i + "\c$")

}
