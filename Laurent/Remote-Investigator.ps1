#function Remote-Investigator {


<#    
.DESCRIPTION
Outil d'Investigation Powershell pour Windows Workstations & Servers, utilisé par le SOC.

.PARAMETER RemoteServer
Enter remote computer name to connect to.

.PARAMETER User
Enter Account name on remote server.

.PARAMETER Pass
Enter Account Password to connect to remote environment

.PARAMETER Days
Enter number of days for logs retriving

.EXAMPLE
PS> Get-WinEventXDays -Days 1

.EXAMPLE
PS> Get-ServiceDistant -RemoteServer servername -User username -Pass password

.EXAMPLE
PS> Get-ProcessDistant -RemoteServer servername -User username -Pass password

.EXAMPLE
PS> PS-WinEventXDays --> Récup WinEvent sur X jours
PS> PS-WinEventXDays -Serveur_Distant --> Récup WinEvent sur X jours du serveur distant

.LINK
https://github.com/gaelor/PSInvestigator
#>



<#
    Param (
           
           [Parameter(Mandatory=$true)] [string] $Days = "Nb de jours de Logs à récupérer",  #--> mandatory for PS-WinEventXDays mais pas pour les autres fonctions
           [Parameter(Mandatory=$true)] [string] $RemoteServer = "Enter Remote Server Name", #--> mandatory for PS-ServiceDistant & PSI-ProcessDistant mais pas pour les autres fonctions
           [Parameter(Mandatory=$true)] [string] $User = "Enter Username",                   #--> mandatory for PS-ServiceDistant & PSI-ProcessDistant mais pas pour les autres fonctions
           [Parameter(Mandatory=$true)] [Securestring] $Pass = "Enter Password"              #--> mandatory for PS-ServiceDistant & PSI-ProcessDistant mais pas pour les autres fonctions
                      
           )
           
#>

Function PS-WinEventXDays {
  Param (
          #  [Parameter(Mandatory=$true)] [string]$Days = "Nb de jours de Logs à récupérer", 
          [Parameter(Mandatory=$false)] [switch]$Serveur_Distant
        )

          if ($Serveur_Distant) {
                  # Set-PSDebug -Trace 2
                  $ServerName = Read-Host -prompt 'Nom du Serveur Distant'
                  # $Cred = New-Object System.Management.Automation.PSCredential (Get-Credential)

                  $Session = New-PSSession -Computername $ServerName -Credential (Get-Credential)
                  Enter-PSSession $Session
                  $Days = Read-Host -prompt 'Nb de jours de logs'
                  $Date_Begin = (Get-Date) - (New-TimeSpan -Day $Days)
                  $Categories = Get-WinEvent –FilterHashtable @{logname= 'Application', 'System'; StartTime=$Date_Begin} -EA silentlycontinue | Where-Object {$_.RecordCount -ne 0} 
                  $Categories | Sort-Object -Property @{Expression = "Logname"; Descending = $False}, @{Expression = "TimeCreated"; Descending = $False} `
                  | Export-csv -Path "$env:TEMP\PS-WinEventXDays_Distant_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

                  hostname
                  Write-Output 'Fichier csv exporté vers' $env:TEMP\PS-WinEventXDays-Distant_$(get-date -f dd-MM-yyyy).csv
                  Exit-PSSession

                  # Dans le fichier exporté le Hostname ne correspond pas au pc distant mais au poste local sur lequel est exécuté le script.
                  # Est-ce que le reste des infos correspond au pc local ou distant ?
            }


          else {
                  $Days = Read-Host -prompt 'Nb de jours de logs'
                  $Date_Begin = (Get-Date) - (New-TimeSpan -Day $Days)
                  $Categories = Get-WinEvent –FilterHashtable @{logname= 'Application', 'System'; StartTime=$Date_Begin} -EA silentlycontinue | Where-Object {$_.RecordCount -ne 0} 
                  $Categories | Sort-Object -Property @{Expression = "Logname"; Descending = $False}, @{Expression = "TimeCreated"; Descending = $False} `
                  | Export-csv -Path "$env:TEMP\PS-WinEventXDays_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

                  Write-Output 'Fichier csv exporté vers' $env:TEMP\PS-WinEventXDays_$(get-date -f dd-MM-yyyy).csv
           }

}  

<#     
Function Get-WinEventXDays
{
$Days = Read-Host "Nb de jours de Logs "
$Date_Begin = (Get-Date) - (New-TimeSpan -Day $Days)
$categories = Get-WinEvent –FilterHashtable @{logname= 'Application', 'System'; StartTime=$Date_Begin} -EA silentlycontinue | Where-Object {$_.RecordCount -ne 0} 
$categories | Sort-Object -Property @{Expression = "Logname"; Descending = $False}, @{Expression = "TimeCreated"; Descending = $False} | Export-csv -Path "$env:TEMP\Get-WinEventSortXDays_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation
}
#>








Function PS-ServiceDistant {
  Param (
  
      [Parameter(Mandatory=$true)] [string] $RemoteServer = "Enter Remote Server Name",
      [Parameter(Mandatory=$true)] [string] $User = "Enter Username",
      [Parameter(Mandatory=$true)] [Securestring] $Pass = "Enter Password" 

        )
     
      $Password = $Pass 
      $Cred = New-Object System.Management.Automation.PSCredential ($User, $Password)

      Invoke-Command -ComputerName $RemoteServer -Credential $Cred -ScriptBlock { Get-Service | Sort-Object status } `
      | Export-csv -Path "$env:TEMP\PS-ServiceDistant_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

      Write-Output 'Fichier csv exporté vers' $env:TEMP\PS-ServiceDistant_$(get-date -f dd-MM-yyyy).csv

}



Function PS-ProcessDistant {
  Param (
  
  [Parameter(Mandatory=$true)] [string] $RemoteServer = "Enter Remote Server Name",
  [Parameter(Mandatory=$true)] [string] $User = "Enter Username",
  [Parameter(Mandatory=$true)] [Securestring] $Pass = "Enter Password" 

    )

 # $PCName = Read-Host "Enter Server Name"
 # $user = Read-Host "Enter Username"
 # $pass = Read-Host "Enter Password" #-AsSecureString
 # $Password = ConvertTo-SecureString $Pass -AsPlainText -Force
  $Password = $Pass
  $Cred = New-Object System.Management.Automation.PSCredential ($User, $Password)

  Invoke-Command -ComputerName $RemoteServer -Credential $Cred -ScriptBlock { Get-Process | Sort-Object status } `
  | Export-csv -Path "$env:TEMP\PS-ProcessDistant_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

  Write-Output 'Fichier csv exporté vers' $env:TEMP\PS-ProcessDistant_$(get-date -f dd-MM-yyyy).csv

}



Function PS-LocalUser {

      Get-LocalUser | Select -ExcludeProperty PrincipalSource, ObjectClass `
      | Export-csv -Path "$env:TEMP\PS-LocalUser_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

      Write-Output 'Fichier csv exporté vers' $env:TEMP\PS-LocalUser_$(get-date -f dd-MM-yyyy).csv

                }


Function PS-AzADUser {

      Get-AzADUser | Select -ExcludeProperty PrincipalSource, ObjectClass `
      | Export-csv -Path "$env:TEMP\PS-AzADUser_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

      Write-Output 'Fichier csv exporté vers' $env:TEMP\PS-AzADUser_$(get-date -f dd-MM-yyyy).csv

                }


Function PS-LocalGroup {

      Get-LocalGroup | Select -ExcludeProperty PrincipalSource, ObjectClass `
      | Export-csv -Path "$env:TEMP\PS-LocalGroup_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation
     # Get-LocalGroup | Select Name, Description, SID | Export-csv -Path "$env:TEMP\PS-LocalGroup_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

      Write-Output 'Fichier csv exporté vers' $env:TEMP\PS-LocalGroup_$(get-date -f dd-MM-yyyy).csv

                }


Function PS-AzADGroup {

      Get-AzADGroup | Select -ExcludeProperty PrincipalSource, ObjectClass `
      | Export-csv -Path "$env:TEMP\PS-AzADGroup_$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation

      Write-Output 'Fichier csv exporté vers' $env:TEMP\PS-AzADGroup_$(get-date -f dd-MM-yyyy).csv

                }





#}
