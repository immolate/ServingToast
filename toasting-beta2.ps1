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

    $BuildVersion = "1.00"


$Load = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
$Load = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
            
#[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
#[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
#[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
$app_ID = 'ae02226e-fb1e-40e4-bb01-17ff41a39ad5'
$LogoImage = "C:\users\david.hamilton\downloads\sd-logo.png"
$HeroImage = "$env:TEMP\ToastHeroImage.jpg"

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

<#
$template = @"
<toast>
    <visual>
        <binding template="ToastText02">
        <image placement="hero" src="$HeroImageTemp"/>
        <image id="3" placement="appLogoOverride" hint-crop="circle" src="$LogoImageTemp"/>
        
            <text id="1">"Testing"</text>
            <text id="2">$(Get-Date -Format 'HH:mm:ss')</text>
        
        
        <group>
            <subgroup>
                <text hint-style="title" hint-wrap="true">What1</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true">What2</text>
            </subgroup>
        </group>
        <group>
            <subgroup>     
                <text hint-style="body" hint-wrap="true">What3</text>
            </subgroup>
        </group>
        </binding>
    </visual>
    <actions>
        <action activationType="protocol" arguments="Test1pre" content="Test1" />
        <action activationType="system" arguments="dismiss" content="Test2"/>
    </actions>


</toast>
"@
#>

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($template.OuterXml)
$toast = New-Object Windows.UI.Notifications.ToastNotification $xml
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Smart Dolphins IT Solutions").Show($toast)


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
# SIG # Begin signature block
# MIISbQYJKoZIhvcNAQcCoIISXjCCEloCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfUwgm2cpVUHOwlMhb5L2nf4e
# Fruggg29MIIDgjCCAmqgAwIBAgIQKu9/pzeTgbdFrij/JdFeqzANBgkqhkiG9w0B
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
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFKwiXhmSHHHB3/iS8IVl0otiCm9LMA0GCSqG
# SIb3DQEBAQUABIIBAEaS64mSQ2kH5mUihuw+9n3g3XZipapuPWi9sWrL5C9wYYa6
# eifrf/OLqjMzREUrmLxSGxNaC5oS6wkep9WHaKG0sv/fJjGa6NX9kHU1K0mlpm5c
# 3fZ4CwDipzgFMK8OASivNEdrub64EIxAR1wc1UeqhzsxrMxw7ob91J3px+8uNQya
# Mq2VVaIvW4Nj/O7Znag4XYKAYAl8+/087FbVLv8xGQeya0UyKgDV//26JvhMbA2Q
# D8dlLIFE6VUWwGusRT4soBDYcCvuLlVyLktcYN5tN+LvbMnk0pTzSWVXpVx/lunB
# vJRWxMgn0mGNAU6sdLY/i84hk4EoAvtQj/aq6OChggIwMIICLAYJKoZIhvcNAQkG
# MYICHTCCAhkCAQEwgYYwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0
# IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNl
# cnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQQIQDUJK4L46iP9gQCHO
# FADw3TANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
# HAYJKoZIhvcNAQkFMQ8XDTIyMDEwMTE5MjkxOFowLwYJKoZIhvcNAQkEMSIEIF9o
# QSyQAzn5S8vKOYaW/2z8qpMh49XbsFF4XYZi4aIUMA0GCSqGSIb3DQEBAQUABIIB
# ABADad7yBW+2NsKIi95uH3vyMjGmQW29NeGmx/kXkQ1wdNy01DW3LC0MGifTT+WT
# jr1FsvxvXqylnNJwWamV/yFn8DKJdiLVXpgAVi9CQXKyyhcxtNdTXF0l91CZWvAQ
# 1yQZ+ckTs03Hi1sMaJ1xY3F6a3yUXHVMliD5bOlr6irO8VTDu0Z3yqWfYmYoKQfK
# Up1wqXTp4GE2DfGR/CZk027QFtLd5HFSDHWQm44dLZQkNSkxCHoNOyXjwdHRpJGk
# DZfds0tezGgG6yafr3k3Z7z5wkUDb7zgUdUvcnzP/3Fn/ZqkvE7OvvgM1rUD06ud
# TPClQObYWPATyjYV9MF1Knc=
# SIG # End signature block
