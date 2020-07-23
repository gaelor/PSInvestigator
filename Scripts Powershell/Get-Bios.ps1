Function Get-Bios
{
Get-WmiObject -Class Win32_Bios | Format-List -Property *
}