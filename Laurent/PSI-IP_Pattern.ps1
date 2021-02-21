Function PSI-IP_pattern {

    Param(
        [Parameter(Mandatory=$True)][String[]]$Options,
        [Parameter(Mandatory=$True)][string[]]$IPAddress
    )

    $Pattern = "^(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$"

    try {
        foreach ($IP in $IPAddresses) {
            if ($IP -match $Pattern){
                Write-Host "$Options , $IP"
                foreach ($option in $Options) {
                    Write-Host "$Option , $IP"
                }
        }
        else {
            Write-Host "[ERROR] - $IP is not a valid IP Address"
        }
            }
    }
 
catch {
    Write-Output "[INVALID IP] - $IPAddress regex treatment failed"
}

}



<#
"^\d{1,3}.{3}\d{1,3}"
"^(\d{1,3}.){3}\d{1,3}"
"^(\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b"
#>
<#
This as four part of ([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])
"^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"

That work like this :

[1-9]           # 1-9
[1-9][0-9]      # 10-99
1[0-9][0-9]     # 100-199
2[0-4][0-9]     # 200-249
25[0-5]         # 250-255
Leading 0 is not valid, so this does not give valid if there is leading 0

#>

<#
Accurate regex to check for an IP address, allowing leading zeros:

^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}↵
(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$
Regex options: None
Regex flavors: .NET, Java, JavaScript, PCRE, Perl, Python, Ruby
Accurate regex to check for an IP address, disallowing leading zeros:

^(?:(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}↵
(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$
#>