Function Get-WinEventXDays
{
$Days = Read-Host "Nb de jours de Logs "
$Date_Begin = (Get-Date) - (New-TimeSpan -Day $Days)
$categories = Get-WinEvent –FilterHashtable @{logname= 'Application', 'System'; StartTime=$Date_Begin} -EA silentlycontinue | Where-Object {$_.RecordCount -ne 0} 
$categories | Sort-Object -Property @{Expression = "Logname"; Descending = $False}, @{Expression = "TimeCreated"; Descending = $False} | Export-csv -Path "$env:TEMP\Get-WinEventSortXDays_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation
}

