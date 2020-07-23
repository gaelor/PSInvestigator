Function Get-Discover-ChildItem
{
$path = Read-Host "Entrez le chemin du dossier à analyser"
$depth = Read-host "Entrez le niveau de profondeur de recherche (Nb de sous dossiers)"
Get-ChildItem -Path $path -Recurse -Depth $depth | Export-csv -Path "$env:TEMP\Get-Discover-ChildItem$(get-date -f dd-MM-yyyy).csv" -NoTypeInformation 
}

<# -Depth 2

L'option « -file » ou « -directory » permet de n'afficher que les fichiers ou que les dossiers.

Get-Childitem C:\test -Recurse -File
#>