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

$Load = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
$Load = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
            
#[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
#[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
#[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
$app_ID = 'ae02226e-fb1e-40e4-bb01-17ff41a39ad5'
$LogoImage = ""
$HeroImage = ""
$CompanyName = ""

<#
binding templates: ToastImageAndText01-4
ToastText01-04
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