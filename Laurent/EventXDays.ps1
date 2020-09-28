Function EventXDays {

    Param (
        # Date range from today to retrieve Logs
        [Parameter(Mandatory=$True)][string]$Days,
        # Caution : Security Logs need Admin privileges to be retrieved
        [Parameter(Mandatory=$True)][ValidateSet("Application", "Security", "System")][string[]]$Events
    )
    
        $Date_Begin = (Get-Date) - (New-TimeSpan -Day $Days)
        $Categories = Get-WinEvent -FilterHashtable @{logname= $Events; StartTime=$Date_Begin} -EA silentlycontinue | Where-Object {$_.RecordCount -ne 0} 
        $Categories | Sort-Object -Property @{Expression = "Logname"; Descending = $False}, @{Expression = "TimeCreated"; Descending = $False} `
        | Export-csv -Path "$env:TEMP\EventXDays_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation
    
        Write-Host 'Fichier csv exporté vers' $env:TEMP\EventXDays_$(get-date -f dd-MM-yyyy).csv
                  
    }  


