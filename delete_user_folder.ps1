$computers = GC C:\path\Desktop\list.txt

foreach ($computer in $computers){
    
     Invoke-Command -ComputerName $computer {
    $folders = Get-ChildItem C:\Users |select -expand name
      foreach ($folder in $folders){
      if(($folder -notlike "root") -and ($folder -notlike "administrator")){
         Write-Output "removing $folder"
         cmd.exe /c del  "c:\Users\$folder" /f/s/q/a
         cmd.exe /c rmdir  "c:\Users\$folder" /s/q}
    }
  }
}
