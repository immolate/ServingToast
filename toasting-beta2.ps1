<#
.SYNOPSIS
  
  This script is intended to display toasts to the logged in user. 
.DESCRIPTION
  
  

.PARAMETER <Parameter_Name>
  
    CompanyName - Your company name
    LogoImage - <required> base 64 representation or URL to your publicly available logo
    HeroImage - <optional> base 64 representation of URL to your publicly available other image
    Title/other - TBD

.INPUTS

  None

.OUTPUTS

  A toast. Cheers. 

.NOTES
  Version:        1.01
  Author:         David Hamilton
  Creation Date:  December 31, 2021
  Purpose/Change: Initial script development
  
.EXAMPLE

  ./toasting-beta2.ps1 -whatever whatever -whatever2 whatever2
  
.Changelog

2021-12-31 - Research - :
    Version 1.00
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------
    https://docs.microsoft.com/en-us/windows/apps/design/shell/tiles-and-notifications/toast-progress-bar?tabs=builder-syntax#using-data-binding-to-update-a-toast
    https://docs.microsoft.com/en-us/uwp/api/windows.ui.notifications.toasttemplatetype?view=winrt-22000
    https://docs.microsoft.com/et-ee/uwp/api/windows.ui.notifications?view=winrt-19041
    Check existing scripts. Some cool ideas - but WAY too extensive/overboard with code. I plan to make this simple and effective. While it's working already at less than 
    100 lines of code - I plan to add at least a few hundred other lines for advanced functionality. 
    Borrowed some basic MS code to automatically update script version from github if it's not compliant. 

2022-01-01

    Version 1.01
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Generalize code
    Add version file
    Add licensing



#>
$scriptName = $script:MyInvocation.MyCommand.Name
$scriptPath = [IO.Path]::GetDirectoryName($script:MyInvocation.MyCommand.Path)
$scriptFullName = (Join-Path $scriptPath $scriptName)

if ((Get-AuthenticodeSignature -FilePath $scriptFullName).Status -eq "NotSigned") {
    Write-Warning "Script is not signed - skipping"
    return $false
}

$oldName = [IO.Path]::GetFileNameWithoutExtension($scriptName) + ".old"
$oldFullName = (Join-Path $scriptPath $oldName)
$tempFullName = (Join-Path $env:TEMP $scriptName)
$ScriptVersion = "1.01"
$ScriptUrl = "https://github.com/immolate/ServingToast/ScriptVersions.csv"

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
            
$app_ID = 'ae02226e-fb1e-40e4-bb01-17ff41a39ad5'
<#
TODO
LogoImage, HeroImage, CompanyName, Title/other messages generalized to be Params instead of set directly

#>
$LogoImage = ""
$HeroImage = ""
$CompanyName = ""

<#
binding templates: ToastImageAndText01-4
ToastText01-04
Desire ToastGeneric - not working yet
#>
[xml]$template = @"
<toast scenario="reminder">
    <visual>
    <binding template="ToastImageAndText02">
        <image placement="hero" src='$heroimage'/>
        <image id="1" placement="appLogoOverride" hint-crop="circle" src="$logoimage"/>
        <text placement="attribution">Your system requires a reboot</text>
        <text placement="body">Whateve444</text>
        <text name="HeaderText">Fuck off</text>
        <text name="Title">Whatever again</text>
        <group>
            <subgroup>
                <text hint-style="title" hint-wrap="true">bullshit text</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true">body1 text</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true">body2 text</text>
            </subgroup>
        </group>
    </binding>
    </visual>
    <actions>
        <action activationType="protocol" arguments="dismiss" content="Reboot NOW" />
        <action activationType="system" arguments="dismiss" content="Reboot in 8 hours"/>
    </actions>
</toast>
"@


$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($template.OuterXml)
$toast = New-Object Windows.UI.Notifications.ToastNotification $xml
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("$CompanyName").Show($toast)


<#
Not mine - reference maybe


[xml]$Toast = @"
<toast scenario="$Scenario">
    <visual>
    <binding template="ToastGeneric">
        <image placement="hero" src="$HeroImage"/>
        <image id="1" placement="appLogoOverride" hint-crop="circle" src="$LogoImage"/>
        <text placement="attribution">$AttributionText</text>
        <text>$HeaderText</text>
        <group>
            <subgroup>
                <text hint-style="title" hint-wrap="true">$TitleText</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true">$BodyText1</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true">$BodyText2</text>
            </subgroup>
        </group>
    </binding>
    </visual>
    <actions>
        <action activationType="protocol" arguments="$Action1" content="$ActionButton1Content" />
        <action activationType="system" arguments="dismiss" content="$DismissButtonContent"/>
    </actions>
</toast>
"@
}

#>