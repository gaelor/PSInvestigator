#  .ExternalHelp Posh-SysMon.psm1-Help.xml
function New-SysmonProcessTerminateFilter
{
    [CmdletBinding(DefaultParameterSetName = 'Path',
    HelpUri = 'https://github.com/darkoperator/Posh-Sysmon/blob/master/docs/New-SysmonProcessTerminateFilter.md')]
    Param (
        # Path to XML config file.
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            ParameterSetName='Path',
            Position=0)]
        [ValidateScript({Test-Path -Path $_})]
        $Path,

        # Path to XML config file.
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            ParameterSetName='LiteralPath',
            Position=0)]
        [ValidateScript({Test-Path -Path $_})]
        [Alias('PSPath')]
        $LiteralPath,

        # Event type on match action.
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=1)]
        [ValidateSet('include', 'exclude')]
        [string]
        $OnMatch,

        # Condition for filtering against and event field.
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=2)]
        [ValidateSet('Is', 'IsNot', 'Contains', 'Excludes', 'Image',
            'BeginWith', 'EndWith', 'LessThan', 'MoreThan')]
        [string]
        $Condition,

        # Event field to filter on.
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=3)]
        [ValidateSet('UtcTime', 'ProcessGuid', 'ProcessId')]
        [string]
        $EventField,

        # Value of Event Field to filter on.
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=4)]
        [string[]]
        $Value,

        # Rule Name for the filter.
        [Parameter(Mandatory=$false,
            ValueFromPipelineByPropertyName=$true)]
        [string]
        $RuleName
    )

    Begin {}
    Process
    {
        $FieldString = $MyInvocation.MyCommand.Module.PrivateData[$EventField]
        $cmdoptions = @{
            'EventType' =  'ProcessTerminate'
            'Condition' = $Condition
            'EventField' = $FieldString
            'Value' = $Value
            'OnMatch' = $OnMatch

        }

        if($RuleName) {
            $cmdoptions.Add('RuleName',$RuleName)
        }

        switch($psCmdlet.ParameterSetName)
        {
            'Path'
            {
                $cmdOptions.Add('Path',$Path)
                New-RuleFilter @cmdOptions
            }

            'LiteralPath'
            {
                $cmdOptions.Add('LiteralPath',$LiteralPath)
                New-RuleFilter @cmdOptions
            }
        }
    }
    End {}
}