Function Get-IPXFrameType 
{
  <#
      .SYNOPSIS
      Code lookup table

      .DESCRIPTION
      Checks and converts codes to meaning full information

      .PARAMETER Code
      The code received the the system.

      .EXAMPLE
      Get-IPXFrameType -Code Value
      Converts code to the associated string value

      .LINK
      https://www.sconstantinou.com

      .INPUTS
      None

      .OUTPUTS
      System.String
  #>

  param ([Parameter][uint32[]]$Code)

  if ($Code.Count -ne 0)
  {
    switch ($Code){
      0 
      {
        'Ethernet II'
      }
      1 
      {
        'Ethernet 802.3'
      }
      2 
      {
        'Ethernet 802.2'
      }
      3 
      {
        'Ethernet SNAP'
      }
      255 
      {
        'Auto'
      }
      default 
      {
        'Invalid Code'
      }
    }
  }

  Return
}
