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


#Périmètre

Audit des évènements systèmes (Get-EventLog -LogName * |ForEach-Object {$LogName = $_.Log;Get-EventLog -LogName $LogName -ErrorAction SilentlyContinue})

Audit services
(get-services-> Tout sauf MachineName)

Audit process
https://gist.github.com/atifaziz/9390344

Audit des comptes/groupes locaux 
(get-localgroup-> Tout sauf PrincipalSource/ObjectClass)
(get-localuser-> Tout sauf PrincipalSource/ObjectClass)

Audit système (config+réseau)

Audit des droits sur les répertoires systèmes (voir pour check intégrité)

Audit des vulnérabilités et exploits

Audit des applications ([config|interpreter]/droits d'administration/FileSystem/Vulnérabilités)



#Liste des outils utilises

System Monitor: https://github.com/darkoperator/Posh-Sysmon

System Policies: https://github.com/dsccommunity/SecurityPolicyDsc

Vulnerability Checks: https://github.com/vulmon/Vulmap

FS Permissions: https://github.com/raandree/NTFSSecurity

Security Tools: https://github.com/darkoperator/Posh-SecMod
