function New-CMPDetectionScript {
    <#
    .SYNOPSIS
    Creates a new application detection script
    
    .DESCRIPTION
    Creates a new application detection script
    
    .PARAMETER RegistryKey
    Name of registry key that represents the application under HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
    
    .PARAMETER Version
    Application version
    
    .PARAMETER Is64bit
    Defines if the application is 64-bit
    
    .EXAMPLE
    New-CMPDetectionScript -RegistryKey "Notepad++" -Version "7.9.2" -Is64Bit $true
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$RegistryKey,
        [Parameter(Mandatory=$true)]
        [string]$Version,
        [Parameter(Mandatory=$true)]
        [boolean]$Is64bit
    )
    
$DetectionScriptText64BitString = @"
if (Test-Path -Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$RegistryKey" -ErrorAction Ignore) {
`$AppVersion = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$RegistryKey' -Name DisplayVersion -ErrorAction Ignore | Select-Object -ExpandProperty DisplayVersion | Sort-Object -Property DisplayVersion | Select-Object -First 1
if (`$AppVersion -ge "$Version") {
Write-Host "Installed"
}
else {
}
}
else {
}
"@

$DetectionScriptText64BitVersion = @"
if (Test-Path -Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$RegistryKey" -ErrorAction Ignore) {
`$AppVersion = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$RegistryKey' -Name DisplayVersion -ErrorAction Ignore | Select-Object -ExpandProperty DisplayVersion | Sort-Object -Property DisplayVersion | Select-Object -First 1
if ([System.Version]`$AppVersion -ge [System.Version]"$Version") {
Write-Host "Installed"
}
else {
}
}
else {
}
"@

$DetectionScriptText32BitString = @"
if (Test-Path -Path "HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$RegistryKey" -ErrorAction Ignore) {
`$AppVersion = Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$RegistryKey' -Name DisplayVersion -ErrorAction Ignore | Select-Object -ExpandProperty DisplayVersion | Sort-Object -Property DisplayVersion | Select-Object -First 1
if (`$AppVersion -ge "$Version") {
Write-Host "Installed"
}
else {
}
}
else {
}
"@

$DetectionScriptText32BitVersion = @"
if (Test-Path -Path "HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$RegistryKey" -ErrorAction Ignore) {
`$AppVersion = Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$RegistryKey' -Name DisplayVersion -ErrorAction Ignore | Select-Object -ExpandProperty DisplayVersion | Sort-Object -Property DisplayVersion | Select-Object -First 1
if ([System.Version]`$AppVersion -ge [System.Version]"$Version") {
Write-Host "Installed"
}
else {
}
}
else {
}
"@
    
    if ($Version -like "*_*" -or $Version -like "*-*") {
        if ($Is64Bit) {
            return $DetectionScriptText64BitString
        }
        else {
            return $DetectionScriptText32BitString
        }
    }
    else {
        if ($Is64Bit) {
            return $DetectionScriptText64BitVersion
        }
        else {
            return $DetectionScriptText32BitVersion
        }
    }
}
