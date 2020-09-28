# Use (Mandatory=$True) for $Options & $IPAddresses when [switch]$jsonfile is not configured
Param (
  [Parameter(Mandatory=$False)][String[]]$Options,
  [Parameter(Mandatory=$False)][String[]]$IPAddresses,
  [Parameter(Mandatory=$False)][switch]$jsonfile
)


# Get-IPRange function was here. 
# Currently stored in C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Get-IPRange.psm1

Import-Module -Name Get-IPRange -Force


# If json parameter is present, ask for json file path, otherwise continue with manual -Options & -IPAddresses parameters
if ($jsonfile) {
  Do { 
    $jsonpath = Read-Host "Please provide full .json file path "
  }
  Until ((Test-Path $jsonpath) -and $jsonpath -match '.json')
  $json = Get-Content $jsonpath | ConvertFrom-Json
  $Options = $json.options
  $IPAddresses = $json.IPAddresses
  Write-Host "Procédure Json"
}
else {
  Write-Warning "Json file not found, Proceeding with manual options"
}



# Pattern to check $IPAddresses is a valid IP Address
$Pattern = "^(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$"

try {
  foreach ($IP in $IPAddresses) {
      # If $IP is part of a range --> Show all ip in this range
      if ($IP -match '/([1-32]\d)$') {
          $pos = $IP.IndexOf("/")
          $leftPart = $IP.Substring(0, $pos)
          $rightPart = $IP.Substring($pos+1)
          $IPRange = (Get-IPrange -ip $leftPart -cidr $rightPart)
          foreach ($ip in $IPRange) {
              foreach ($Option in $Options) {
                  Write-Host "$option , $IP" "IP is part of IP-Range"
              }                    
          }
      }
      # If $IP match $Pattern --> Show IP 
      elseif ($IP -match $Pattern) {
        foreach ($Option in $Options)
        {
            Write-Host "$option , $IP" "IP match Pattern"
        }
    }
      # If $IP match hostname --> Resolve Hostname & Show associated IP
      elseif ($IP -match '([a-z])$') {
          $IPhostname = [System.Net.Dns]::GetHostAddresses($IP)
          foreach ($Ihostname in $IPhostname) {
              Write-Host "$Option , $Ihostname" "Hostname to IP"
          }
      }
      else {
          Write-Warning "[INVALID IP] - $IP is not a valid IP Address"
      }
  }
}

catch {
  Write-Error "[ERROR] - $IPAddresses regex treatment failed"
}

