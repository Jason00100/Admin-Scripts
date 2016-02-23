$DCList = Get-Content C:\Users\j\inFile.txt

ForEach ($DC IN $DCList)

    {
        Invoke-Command -ComputerName $DC -ScriptBlock { Get-Service -Name netlogon }
    }
