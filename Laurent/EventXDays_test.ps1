Function EventXDays {

<#
Param (
    [Parameter(Mandatory=$True)][string]$Days 
)
#>
    $Days = Read-Host "Nombre de jours de logs à récupérer"

    [string[]]$EventList = @()
    Do {
        $Events = (Read-Host "Choix des événements Windows")
        if ($Events -ne '') {$EventList +=$Events}
    }
    Until ($Events = 'end')

    $Date_Begin = (Get-Date) - (New-TimeSpan -Day $Days)
    $Categories = Get-WinEvent –FilterHashtable @{logname= $Events; StartTime=$Date_Begin} -EA silentlycontinue | Where-Object {$_.RecordCount -ne 0} 
    $Categories | Sort-Object -Property @{Expression = "Logname"; Descending = $False}, @{Expression = "TimeCreated"; Descending = $False} `
    | Export-csv -Path "$env:TEMP\EventXDays_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

    Write-Host 'Fichier csv exporté vers' $env:TEMP\EventXDays_$(get-date -f dd-MM-yyyy).csv
              
}  



