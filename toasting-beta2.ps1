<#
.SYNOPSIS
  
  This script is intended to display toasts to the logged in user. 
.DESCRIPTION
  
  

.PARAMETERS 
  
    ToastMessage - <required> Your custom toast message
    CompanyName - <required> Your company name
    LogoImage - <optional> base 64 representation or URL to your publicly available logo
    HeroImage - <optional> base 64 representation of URL to your publicly available other image
    

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

  ./toasting-beta2.ps1 -ToastMessage "Your Custom Message" -CompanyName "Your Company Name" -LogoImage "C:\path\to\your\logo.png"
  
.CHANGELOG

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
    Add Params for Message, Company, Logo, HeroImage

.ToDo
Functionality to buttons
Fix Hero Image / body not working
Auto-Update section not yet finished

FIRST Delete registry entry in: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\$CompanyName
^ Or change Enabled to 1
SECOND: Perform DELETE command as below
SQLite DB: C:\Users\%username%\AppData\Local\Microsoft\Windows\Notifications\wpndatabase.db

SELECT * from NotificationHandler
where (PrimaryId LIKE '%$CompanyName%')

DELETE from NotificationHandler
where PrimaryId LIKE '%$CompanyName%'

^ Confirmed working

.Credits
Inspiration from BurntToast: https://www.powershellgallery.com/packages/BurntToast/0.4/Content/New-BurntToastNotification.ps1


#>
param (
[Parameter( Mandatory=$true,
            HelpMessage="The message you'll send in the Toast Notification")]
[string]$ToastMessage,

[Parameter( Mandatory=$true,
            HelpMessage="Your company name helps users identify where this message is coming from.")]
[string]$CompanyName,

[Parameter( Mandatory=$false,
            HelpMessage="Your logo helps your brand image pop. Specify a filename.")]
[string]$LogoImage,

[Parameter( Mandatory=$false,
            HelpMessage="Your hero image. Specify a filename.")]
[string]$HeroImage





)


[decimal]$ScriptVersion = "1.01"
[string]$scriptName = $script:MyInvocation.MyCommand.Name
$scriptPath = [IO.Path]::GetDirectoryName($script:MyInvocation.MyCommand.Path)
$scriptFullName = (Join-Path $scriptPath $scriptName)
# [string]$CompanyName = "Your Company Name"

<# Skip signing check for now
if ((Get-AuthenticodeSignature -FilePath $scriptFullName).Status -eq "NotSigned") {
    Write-Warning "Script is not signed - skipping"
    return $false
}
#>
function VersionCheck {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory = $true)]
        $currentVersion
        )
$ScriptUrl = "https://raw.githubusercontent.com/immolate/ServingToast/main/ScriptVersions.csv"
$versionCheck = ((Invoke-WebRequest $scriptUrl -UseBasicParsing).Content) | ConvertFrom-Csv
if (($versionCheck | where { $_.Script -eq $scriptName }).version -gt $ScriptVersion) { 
$oldName = [IO.Path]::GetFileNameWithoutExtension($scriptName) + ".old"
$oldFullName = (Join-Path $scriptPath $oldName)
$tempFullName = (Join-Path $env:TEMP $scriptName)


write-host "Script Updated - Please re-run (line 81)"
return $false
 }
else { write-host "Up to date. Awesome." ; return $true}

}

if (!(VersionCheck($ScriptVersion))) { break }


[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
            
$app_ID = 'ae02226e-fb1e-40e4-bb01-17ff41a39ad5'
if (!($LogoImage)) {$LogoImage = ""}
if (!($HeroImage)) {$HeroImage = ""}

<#
binding templates: ToastImageAndText01-4
ToastText01-04
Desire ToastGeneric - not working yet
#>
[xml]$template = @"
<toast scenario="reminder">
    <visual>
    <binding template="ToastImageAndText02">
        <image id="2" placement="hero" src="$heroimage"/>
        <image id="1" placement="appLogoOverride" hint-crop="circle" src="$logoimage"/>
        <text placement="attribution">$ToastMessage</text>
        <text placement="body">"Whateve444"</text>
        <text name="HeaderText">Whatever2</text>
        <text name="Title">Whatever again</text>
        <group>
            <subgroup>
                <text hint-style="title" hint-wrap="true">whatever text</text>
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
        <input id="RebootTime" type="selection" defaultInput="Today">
            <selection id="Today" content="6pm Today" />
            <selection id="Tomorrow" content="6pm Tomorrow" />
            <selection id="Friday" content="6pm Friday" />
        </input>
        <action activationType="system" arguments="snooze" hint-inputId="RebootTime" content="Schedule Reboot" />
        <action activationType="system" arguments="dismiss" content="Reboot Now"/>
        
    </actions>
</toast>
"@

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($template.OuterXml)
$toast = New-Object Windows.UI.Notifications.ToastNotification $xml
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("$CompanyName").Show($toast)



# SIG # Begin signature block
# MIISbQYJKoZIhvcNAQcCoIISXjCCEloCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU46KCPLFn1504MpY2PtwUTQRR
# /b2ggg29MIIDgjCCAmqgAwIBAgIQKu9/pzeTgbdFrij/JdFeqzANBgkqhkiG9w0B
# AQsFADAxMS8wLQYDVQQDDCZQb3dlcnNoZWxsLlNtYXJ0RG9scGhpbnMuQ29tIFJv
# b3QgQ2VydDAeFw0yMTExMDcxNzMwMTFaFw0yMzExMDcxNzM5NTdaMC4xLDAqBgNV
# BAMMI0RhdmlkIEhhbWlsdG9uIFBvd2Vyc2hlbGwgU2lnbmF0dXJlMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxqrOhg5apc2+Q5Gvb4TMD6PGQf8/+FEK
# +jhi7S/fQ1Z6qDZI2dHfEDZzWJ7jlS0IWKGu/urReh0WfkL0ssAnhEg9ksI2C4e3
# p5c4cwvDLLyz+dzwLDU/loMFxtcYbd8L8xQ53PMK+TB934v6zZLZd9C75FU6ff4T
# HN5L4vWB7SPTJPvF4VDX5IT4nnNW6ygKz7PJDG6xw8QgxqfLmtLx/no9drgHKf8J
# Pj5J92LUnwjUptIchs0f0NlpDBjh9BYrevjvnwdzXXdJXUv1mu1BrqRKIAbN0Ovl
# NMpIRvsufA0jH7kCYkYJeGUbWCBftN2sXVhC4sCvvg/6bLzIgNfbqQIDAQABo4GY
# MIGVMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAuBgNVHREE
# JzAlgiNEYXZpZCBIYW1pbHRvbiBQb3dlcnNoZWxsIFNpZ25hdHVyZTAfBgNVHSME
# GDAWgBS3VSXS97jPsa0dx5mZ156TvVJ8YzAdBgNVHQ4EFgQUdGEaev6onCbgcI6S
# Xu/qaW25jpIwDQYJKoZIhvcNAQELBQADggEBAG5zDDdS+joAIRK2O+4Q5c2+JTMK
# eMraxyUprtaTyrzbISHm5EN4XgO793IDkzFZOoTLQ3UbylYak9LdkJBjzHrCzBlz
# k3NoXJOrsAPzBlSqeKiVvN6i8iZGUxw0Rn8H4EqofCBfPDJiAgRCzIddivO6PuB4
# 09ZBkVpwBfe/aGA85s9nB79eDuFiL++LLlkIPFhfei2DIQXlPAmGZUxhdAW3xVOd
# UZVTvemQ443vPs2HVqBUlm72g3FbCojhvmVo1PoKfLyhVF4Pm5/GtSwJmCbUCQTU
# CGvka78m5ryqbJVl2s/jaqW6lxYk4W+IlLu0oZJSLll6o0zBHr3pmUASSSwwggT+
# MIID5qADAgECAhANQkrgvjqI/2BAIc4UAPDdMA0GCSqGSIb3DQEBCwUAMHIxCzAJ
# BgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5k
# aWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBU
# aW1lc3RhbXBpbmcgQ0EwHhcNMjEwMTAxMDAwMDAwWhcNMzEwMTA2MDAwMDAwWjBI
# MQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xIDAeBgNVBAMT
# F0RpZ2lDZXJ0IFRpbWVzdGFtcCAyMDIxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
# MIIBCgKCAQEAwuZhhGfFivUNCKRFymNrUdc6EUK9CnV1TZS0DFC1JhD+HchvkWsM
# lucaXEjvROW/m2HNFZFiWrj/ZwucY/02aoH6KfjdK3CF3gIY83htvH35x20JPb5q
# dofpir34hF0edsnkxnZ2OlPR0dNaNo/Go+EvGzq3YdZz7E5tM4p8XUUtS7FQ5kE6
# N1aG3JMjjfdQJehk5t3Tjy9XtYcg6w6OLNUj2vRNeEbjA4MxKUpcDDGKSoyIxfcw
# WvkUrxVfbENJCf0mI1P2jWPoGqtbsR0wwptpgrTb/FZUvB+hh6u+elsKIC9LCcmV
# p42y+tZji06lchzun3oBc/gZ1v4NSYS9AQIDAQABo4IBuDCCAbQwDgYDVR0PAQH/
# BAQDAgeAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwQQYD
# VR0gBDowODA2BglghkgBhv1sBwEwKTAnBggrBgEFBQcCARYbaHR0cDovL3d3dy5k
# aWdpY2VydC5jb20vQ1BTMB8GA1UdIwQYMBaAFPS24SAd/imu0uRhpbKiJbLIFzVu
# MB0GA1UdDgQWBBQ2RIaOpLqwZr68KC0dRDbd42p6vDBxBgNVHR8EajBoMDKgMKAu
# hixodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vc2hhMi1hc3N1cmVkLXRzLmNybDAy
# oDCgLoYsaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC10cy5j
# cmwwgYUGCCsGAQUFBwEBBHkwdzAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGln
# aWNlcnQuY29tME8GCCsGAQUFBzAChkNodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRTSEEyQXNzdXJlZElEVGltZXN0YW1waW5nQ0EuY3J0MA0GCSqG
# SIb3DQEBCwUAA4IBAQBIHNy16ZojvOca5yAOjmdG/UJyUXQKI0ejq5LSJcRwWb4U
# oOUngaVNFBUZB3nw0QTDhtk7vf5EAmZN7WmkD/a4cM9i6PVRSnh5Nnont/PnUp+T
# p+1DnnvntN1BIon7h6JGA0789P63ZHdjXyNSaYOC+hpT7ZDMjaEXcw3082U5cEvz
# nNZ6e9oMvD0y0BvL9WH8dQgAdryBDvjA4VzPxBFy5xtkSdgimnUVQvUtMjiB2vRg
# orq0Uvtc4GEkJU+y38kpqHNDUdq9Y9YfW5v3LhtPEx33Sg1xfpe39D+E68Hjo0mh
# +s6nv1bPull2YYlffqe0jmd4+TaY4cso2luHpoovMIIFMTCCBBmgAwIBAgIQCqEl
# 1tYyG35B5AXaNpfCFTANBgkqhkiG9w0BAQsFADBlMQswCQYDVQQGEwJVUzEVMBMG
# A1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQw
# IgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMTYwMTA3MTIw
# MDAwWhcNMzEwMTA3MTIwMDAwWjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhE
# aWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvdAy7kvNj3/dqbqCmcU5VChXtiNKxA4H
# RTNREH3Q+X1NaH7ntqD0jbOI5Je/YyGQmL8TvFfTw+F+CNZqFAA49y4eO+7MpvYy
# Wf5fZT/gm+vjRkcGGlV+Cyd+wKL1oODeIj8O/36V+/OjuiI+GKwR5PCZA207hXwJ
# 0+5dyJoLVOOoCXFr4M8iEA91z3FyTgqt30A6XLdR4aF5FMZNJCMwXbzsPGBqrC8H
# zP3w6kfZiFBe/WZuVmEnKYmEUeaC50ZQ/ZQqLKfkdT66mA+Ef58xFNat1fJky3se
# BdCEGXIX8RcG7z3N1k3vBkL9olMqT4UdxB08r8/arBD13ays6Vb/kwIDAQABo4IB
# zjCCAcowHQYDVR0OBBYEFPS24SAd/imu0uRhpbKiJbLIFzVuMB8GA1UdIwQYMBaA
# FEXroq/0ksuCMS1Ri6enIZ3zbcgPMBIGA1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0P
# AQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMIMHkGCCsGAQUFBwEBBG0wazAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAC
# hjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
# b290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2Vy
# dC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8v
# Y3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMFAG
# A1UdIARJMEcwOAYKYIZIAYb9bAACBDAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3
# dy5kaWdpY2VydC5jb20vQ1BTMAsGCWCGSAGG/WwHATANBgkqhkiG9w0BAQsFAAOC
# AQEAcZUS6VGHVmnN793afKpjerN4zwY3QITvS4S/ys8DAv3Fp8MOIEIsr3fzKx8M
# IVoqtwU0HWqumfgnoma/Capg33akOpMP+LLR2HwZYuhegiUexLoceywh4tZbLBQ1
# QwRostt1AuByx5jWPGTlH0gQGF+JOGFNYkYkh2OMkVIsrymJ5Xgf1gsUpYDXEkdw
# s3XVk4WTfraSZ/tTYYmo9WuWwPRYaQ18yAGxuSh1t5ljhSKMYcp5lH5Z/IwP42+1
# ASa2bKXuh1Eh5Fhgm7oMLSttosR+u8QlK0cCCHxJrhO24XxCQijGGFbPQTS2Zl22
# dHv1VjMiLyI2skuiSpXY9aaOUjGCBBowggQWAgEBMEUwMTEvMC0GA1UEAwwmUG93
# ZXJzaGVsbC5TbWFydERvbHBoaW5zLkNvbSBSb290IENlcnQCECrvf6c3k4G3Ra4o
# /yXRXqswCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFPsJWRWmCdSoQRRKGWhpD8rGf0xsMA0GCSqG
# SIb3DQEBAQUABIIBAGJTAnDJ9tG093nCbITVYqVvQkEZp/MQiBscgXVR9Ti0MMGS
# CcWwwe9wVdLJB9LYstUKrGnV05XAIquVmtpItYBofgX6u1qlllzLpA/VuWgS92EQ
# ztMkUGKSe37LE1QD9F6tqJNsdxOUNYT1LVLsgve5EZlCFTJPfrirEj8GJUE66RdN
# 2wBoiBlLO5xYQgS+Qix3Yssf1Ubj9YQ6Dt6hJFrY+udxgS6jZDKPL67TlcpNtc/f
# pY7Ur0VT/J8m8rOrB70vlhqQp1uyMkzKIzzOyYjxvzQgVHoWUCMwQeWsM4OfKtcF
# VGYMOqpa7FfYKWuRQhJLoyhesx7ss+UENRN2MuKhggIwMIICLAYJKoZIhvcNAQkG
# MYICHTCCAhkCAQEwgYYwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0
# IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNl
# cnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQQIQDUJK4L46iP9gQCHO
# FADw3TANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
# HAYJKoZIhvcNAQkFMQ8XDTIyMDIyMTE0MDAzMlowLwYJKoZIhvcNAQkEMSIEIGJh
# /xsyIQLI2sv8dksslk1t5lS09AkROkR0EAemSHvTMA0GCSqGSIb3DQEBAQUABIIB
# AJ7lxEa2Vxp+qcVJIITVGEfFUO8aWAH6L40vmGPsTVWLpXqel59xZ1M32ew8UwWc
# Lwsw6wmWxqnDP3Id6arFyh2Vl6LrhstqmCuXEvUJzXLOAsHUgGBq/wAIL5CLTU1e
# f4NCXyKXTZ3GwIhYCIPSpR0zk74lbeQYMOZ7p5kq3i/SO4EoP+rCWQL8PAsvV2K0
# 2Z0zqrKJcRR+kRMb5l6L1artRygh2WxDneR0qClF1wewNzOSUFrPVTbUFn3T1yGy
# vWroUU0Q8tmzbg+fYxV2uRCqePH7F2QZpuWdM5vQP7Z6nYkeqvptSDc9sC+iRdcZ
# 2pKVUUt8sLH5uK87qdo33X4=
# SIG # End signature block
