#ConfigMgr Variables
$ContentRootPath            = "\\ad.ajf8729.com\Shares\Apps"
$InstallScriptFilename      = "CMPInstall.cmd"
$UserCollectionTest         = "Application - All"
$SiteCode                   = "AJF"
$UserLimitingCollectionId   = "SMS00002"
$DeviceLimitingCollectionId = "SMS00001"

#Import External Modules
if ((Test-Path -Path "$env:SMS_ADMIN_UI_PATH\..\..\bin\ConfigurationManager.psd1")) {
    Import-Module -FullyQualifiedName "$env:SMS_ADMIN_UI_PATH\..\..\bin\ConfigurationManager.psd1"
}
else {
    Write-Error -Message "ConfigMgr module path does not exist"
    break
}

#Dot-Source Internal Functions
$Public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -ErrorAction Ignore)
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction Ignore)

foreach ($File in @($Public + $Private)) {
    try {
        . $File.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($File.FullName): $_"
        break
    }
}

Export-ModuleMember -Function $Public.Basename
