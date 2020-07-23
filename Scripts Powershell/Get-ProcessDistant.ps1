﻿Function Get-ProcessDistant
{

$PCName = Read-Host "Enter Server Name"
$user = Read-Host "Enter Username"
$pass = Read-Host "Enter Password"
$password = ConvertTo-SecureString $pass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $password)

Invoke-Command -ComputerName $PCName -Credential $cred -ScriptBlock { Get-Process | Sort-Object status } 

}


# Export-csv -Path "$env:TEMP\Get-ProcessDistant$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation 