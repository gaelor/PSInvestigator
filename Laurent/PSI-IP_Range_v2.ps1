Param(
    [Parameter(Mandatory=$True)][String[]]$Options,
    [Parameter(Mandatory=$True)][String[]]$IPAddresses
)
 
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
 
$Pattern = "^(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$"
try {
    foreach ($IP in $IPAddresses) {

        if ($IP -match '/([1-32]\d)$') {
            $pos = $IP.IndexOf("/")
            $leftPart = $IP.Substring(0, $pos)
            $rightPart = $IP.Substring($pos+1)
            $IPRange = (Get-IPrange -ip $leftPart -cidr $rightPart)
            foreach ($ip in $IPRange) {
                foreach ($option in $options) {
                    Write-Host "$option , $IP" "if IP match 1-32"
                }                    
            }
        }
    
        elseif ($IP -match $Pattern) {
            Write-Host "$options , $IP" "elsif Pattern"
            foreach ($option in $options)
            {
                Write-Host "$option , $IP" "Pattern"
            }
        }
        elseif ($IP -match '^([a-z])$') {
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



# ---------------------- V2 - NOT WORKING AS EXPECTED ---------------------- #
<#
Function PSInvestigator {


    Param(
        [Parameter(Mandatory=$True)][String[]]$Options,
        [Parameter(Mandatory=$True)][IPAddress[]]$IP

    )

    # Ce if n'est pas du tout productif
    if (($IP.GetAddressBytes()[0] -lt 255) -and ($IP.GetAddressBytes()[1] -lt 169) -and ($IP.GetAddressBytes()[2] -lt 4) -and ($IP.GetAddressBytes()[3] -lt 120)) {

        if ($Options.Length -match $IP.Length) {
            For($i=0;$i -lt $Options.Length; $i++) {
                Write-Host "$($Options[$i]) , $($IP[$i])"
            }
        }
        else {
            Write-Host "[ERROR] - Parameters count doesn't match"
        }
    }
    else{
        Write-Host "[ERROR] - Invalid IP Address"
    }
}
#>
# ---------------------- FIN V2 ---------------------- #


# ---------------------- V3 - $Pattern ---------------------- #
<#
Function PSIpattern {

    Param(
        [Parameter(Mandatory=$True)][String[]]$Options,
        [Parameter(Mandatory=$True)][String[]]$IPAddress
    )

    $Pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

    try {
        if ($IPAddress -match $Pattern) {
            For($i=0;$i -lt $IPAddress.count; $i++) {
                Write-Host "$($Options[$i]) , $($IPAddress[$i])"
            }
        }
        else {
            Write-Host "[ERROR] - $IPAddress is not a valid IP Address"
        }
    }
    
    catch {
            Write-Output "[INVALID IP] - $IPAddress is not a valid IP Address"
    }
}
#>
# ---------------------- FIN V3---------------------- #


# ---------------------- Split-IPRange ---------------------- #
<#
function Split-IPRange ($start, $end) {

 $ip1 = ([System.Net.IPAddress]$start).GetAddressBytes()
 [Array]::Reverse($ip1)
 $ip1 = ([System.Net.IPAddress]($ip1 -join '.')).Address
 $ip2 = ([System.Net.IPAddress]$end).GetAddressBytes()
 [Array]::Reverse($ip2)
 $ip2 = ([System.Net.IPAddress]($ip2 -join '.')).Address

 for ($x=$ip1; $x -le $ip2; $x++) {
 $ip = ([System.Net.IPAddress]$x).GetAddressBytes()
 [Array]::Reverse($ip)
 $ip -join '.'
 }
}

#>
# ---------------------- FIN ---------------------- #









