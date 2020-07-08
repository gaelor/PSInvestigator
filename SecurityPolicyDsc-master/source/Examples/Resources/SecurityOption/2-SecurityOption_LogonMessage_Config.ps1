<#PSScriptInfo
.VERSION 1.0.1
.GUID 328394fd-c39f-437f-be77-2c13f41e981f
.AUTHOR DSC Community
.COMPANYNAME DSC Community
.COPYRIGHT DSC Community contributors. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/dsccommunity/SecurityPolicyDsc/blob/master/LICENSE
.PROJECTURI https://github.com/dsccommunity/SecurityPolicyDsc
.ICONURI https://dsccommunity.org/images/DSC_Logo_300p.png
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
Updated author, copyright notice, and URLs.
.PRIVATEDATA
#> 

#Requires -Module SecurityPolicyDsc

<#
    .DESCRIPTION
        This configuration will manage the interactive logon message.
        In a scenario in which a multi-line message is used a new line is
        represented with a comma. If commas are used in the message and a
        new line is not intended they must be surrounded by double quotes.

        This example will result in the following logon message:

        Line 1 - Message for line 1.
        Line 2 - Message for line 2, words, separated, with, commas.
        Line 3 - Message for line 3.
#>
configuration SecurityOption_LogonMessage_Config
{
    Import-DscResource -ModuleName SecurityPolicyDsc

    $message = 'Line 1 - Message for line 1.,Line 2 - Message for line 2"," words"," separated"," with"," commas.,Line 3 - Message for line 3.'

    node localhost
    {
        SecurityOption LogonMessage
        {
            Name                                                          = "Message Test"
            Interactive_logon_Message_text_for_users_attempting_to_log_on = $message
        }
    }
}
