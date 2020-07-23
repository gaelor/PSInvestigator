# Use Vulmap --> https://github.com/vulmon/Vulmap/blob/master/Vulmap-Windows/README.md
iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/vulmon/Vulmap/master/Vulmap-Windows/vulmap-windows.ps1')


# Collect Softwares Inventory and save it to json file --> Ne fonctionne pas avec $FilePath
Function SoftInventory
{
$FilePath = Read-Host "Enter destination folder for exportation, end with .json extension file"
Invoke-Vulmap -Mode CollectInventory -InventoryOutFile $FilePath
}