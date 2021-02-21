
Param(
  [Parameter(Mandatory=$False)][String[]]$Options,
  [Parameter(Mandatory=$False)][String[]]$IPAddresses,
  [Parameter(Mandatory=$False)][switch]$jsonfile
)


# Get-IPRange
function Get-IPrange
{
<# 
.SYNOPSIS  
  Get the IP addresses in a range 
.EXAMPLE 
 Get-IPrange -start 192.168.8.2 -end 192.168.8.20 
.EXAMPLE 
 Get-IPrange -ip 192.168.8.2 -mask 255.255.255.0 
.EXAMPLE 
 Get-IPrange -ip 192.168.8.3 -cidr 24 
.EXAMPLE 
 .\PSInvestigator.ps1 -Options "Option 1", "Option 2", "Option 3" -IPAddresses "192.168.1.0", "192.168.2.0", "192.168.3.1/24"
#>

param 
( 
[string]$start, 
[string]$end, 
[string]$ip, 
[string]$mask, 
[int]$cidr 
) 



function IP-toINT64 () { 
param ($ip) 

$octets = $ip.split(".") 
return [int64]([int64]$octets[0]*16777216 +[int64]$octets[1]*65536 +[int64]$octets[2]*256 +[int64]$octets[3]) 
} 

function INT64-toIP() { 
param ([int64]$int) 

return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )
} 

if ($ip) {$ipaddr = [Net.IPAddress]::Parse($ip)} 
if ($cidr) {$maskaddr = [Net.IPAddress]::Parse((INT64-toIP -int ([convert]::ToInt64(("1"*$cidr+"0"*(32-$cidr)),2)))) } 
if ($mask) {$maskaddr = [Net.IPAddress]::Parse($mask)} 
if ($ip) {$networkaddr = new-object net.ipaddress ($maskaddr.address -band $ipaddr.address)} 
if ($ip) {$broadcastaddr = new-object net.ipaddress (([system.net.ipaddress]::parse("255.255.255.255").address -bxor $maskaddr.address -bor $networkaddr.address))} 

if ($ip) { 
$startaddr = IP-toINT64 -ip $networkaddr.ipaddresstostring 
$endaddr = IP-toINT64 -ip $broadcastaddr.ipaddresstostring 
} else { 
$startaddr = IP-toINT64 -ip $start 
$endaddr = IP-toINT64 -ip $end 
} 


for ($i = $startaddr; $i -le $endaddr; $i++) 
{ 
INT64-toIP -int $i 
}

}


# If json parameter is present, ask for json file path
if ($jsonfile) {
  $jsonpath = Read-Host "Enter .json full file path." " No quotes needed, use space if path has space"
  $json = Get-Content $jsonpath | ConvertFrom-Json
  $Options = $json.options
  $IPAddresses = $json.IPAddresses
  Write-Host "Procédure Json"
}
else {
  Write-Host "Json file not found"
}



# Définition du modèle $pattern pour comparer l'input à une Adresse IP
$Pattern = "^(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$"

try {
foreach ($IP in $IPAddresses) {
    # Si la variable $IP est un range d'IP --> Les afficher toutes
    if ($IP -match '/([1-32]\d)$') {
        $pos = $IP.IndexOf("/")
        $leftPart = $IP.Substring(0, $pos)
        $rightPart = $IP.Substring($pos+1)
        $IPRange = (Get-IPrange -ip $leftPart -cidr $rightPart)
        foreach ($ip in $IPRange) {
            foreach ($option in $options) {
                Write-Host "$option , $IP" "if IP is in IP-Range"
            }                    
        }
    }
    # Sinon si la variable match le pattern IP --> afficher l'IP 
    elseif ($IP -match $Pattern) {
        Write-Host "$options , $IP" "elsif Pattern"
        foreach ($option in $options)
        {
            Write-Host "$option , $IP" "Pattern"
        }
    }
    # Sinon si la variable $IP correspond à une adresse web --> résoudre le nom et afficher l'IP
    elseif ($IP -match '([a-z])$') {
        Write-Host "elsif hostname"
        $IPhostname = Resolve-DnsName -Name $IP | Select-Object IPAddress
        foreach ($Ihostname in $IPhostname) {
            Write-Host "$option , $Ihostname" "iHost"
        }
    }
    else {
        Write-Host "[INVALID IP] - $IP is not a valid IP Address"
    }
}
}

catch {
Write-Output "[ERROR] - $IPAddresses regex treatment failed"
}


