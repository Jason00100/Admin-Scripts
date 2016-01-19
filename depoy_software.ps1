Get-Content list.txt | ForEach-Object {
Copy-Item -Path "c:\SETUP_NetprobeNT.exe" -Destination "\\$_\c$\" 
Invoke-Command -ComputerName $_ -ScriptBlock { & cmd.exe /c "c:\SETUP_NetprobeNT.exe /netport=703 /silent" }
Remove-Item -path "\\$_\c$\SETUP_NetprobeNT.exe"
}
