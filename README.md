# PSInvestigator Objectifs
Outil d'investigation PowerShell (à voir par la suite pour la remédiation).
Auditer les systèmes Microsoft


# Acteurs

Opérateurs du SOC / Auditeurs / Commanditaire de l'audit / Client SOC / Responsable Commercial


# Systèmes

Windows Workstation & Windows Server



# Description de la ligne de commande

./PSInvestigator -Help --> Doit fournir l'aide pour l'utilisation du script

./PSInvestigator -All --> 

./PSInvestigator -Audit 'Services,Accounts' -Remote '192.168.1.1,10.2.6.1-10.2.7.76,test1.local,test2.local'

./PSInvestigator -All -Remote '192.168.1.1,10.2.6.1-10.2.7.76,test1.local,test2.local'


# Périmètre

Audit des évènements systèmes : Get-WinEvent & Get-EventLog (Attention aux différences)

Audit services : Get-service

Audit process : https://gist.github.com/atifaziz/9390344

Audit des comptes/groupes locaux :
(get-localgroup-> Tout sauf PrincipalSource/ObjectClass)
(get-localuser-> Tout sauf PrincipalSource/ObjectClass)


Audit système (config+réseau) :
https://github.com/SConstantinou/SysInfo
https://github.com/SConstantinou/SysInfo


Audit des droits sur les répertoires systèmes  : NTFS Security

Audit des vulnérabilités et exploits : Vulmap

Audit des applications (droits d'administration / FileSystem / Vulnérabilités)




# Liste d'outils utilisables / adaptables pour PSInvestigator

System Monitor: https://github.com/darkoperator/Posh-Sysmon

System Policies: https://github.com/dsccommunity/SecurityPolicyDsc

Vulnerability Checks: https://github.com/vulmon/Vulmap

FS Permissions: https://github.com/raandree/NTFSSecurity

Security Tools: https://github.com/darkoperator/Posh-SecMod

