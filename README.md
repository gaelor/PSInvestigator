# PSInvestigator Objectifs
Outil d'investigation PowerShell (à voir par la suite pour la remédiation).
Auditer les systèmes Microsoft


#Acteurs

Opérateurs du SOC
Auditeurs
Commanditaire de l'audit
Client SOC
Responsable Commercial


#Systèmes

Windows Workstation & Windows Server

#Description de la ligne de commande

./PSInvestigator -Help
./PSInvestigator -All
./PSInvestigator -Audit 'Services,Accounts'

#Périmètre

Audit des évènements systèmes
$Date_Begin = (Get-Date) - (New-TimeSpan -Day 2)
$categories = Get-WinEvent -Listlog * -EA silentlycontinue | where {$_.RecordCount -ne 0}
Foreach ($element in $categories)
{
 Get-WinEvent -FilterHashtable @{LogName=$element.LogName; StartTime=$Date_Begin}
}

Audit services
(get-services-> Tout sauf MachineName)

Audit process
https://gist.github.com/atifaziz/9390344

Audit des comptes/groupes locaux 
(get-localgroup-> Tout sauf PrincipalSource/ObjectClass)
(get-localuser-> Tout sauf PrincipalSource/ObjectClass)

Audit système (config+réseau)
https://github.com/SConstantinou/SysInfo
https://github.com/SConstantinou/SysInfo

Audit des droits sur les répertoires systèmes (voir pour check intégrité)

Audit des vulnérabilités et exploits

Audit des applications ([config|interpreter]/droits d'administration/FileSystem/Vulnérabilités)



#Liste des outils utilises

System Monitor: https://github.com/darkoperator/Posh-Sysmon

System Policies: https://github.com/dsccommunity/SecurityPolicyDsc

Vulnerability Checks: https://github.com/vulmon/Vulmap

FS Permissions: https://github.com/raandree/NTFSSecurity

Security Tools: https://github.com/darkoperator/Posh-SecMod
