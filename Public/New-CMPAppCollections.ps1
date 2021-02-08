function New-CMPAppCollections {
    <#
    .SYNOPSIS
    Creates application collections in ConfigMgr
    
    .DESCRIPTION
    Creates application collections in ConfigMgr
    
    .PARAMETER AppName
    Application name
    
    .PARAMETER IsFreeApp
    Defines if the application should be available to all users
    
    .EXAMPLE
    New-CMPAppCollections -AppName "7-Zip" -IsFreeApp
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$AppName,
        [Parameter(Mandatory=$false)]
        [switch]$IsFreeApp
    )
    
    Set-Location -Path "$($SiteCode):"
    
    $UserCollectionName   = "$($AppName) - Available"
    $DeviceCollectionName = "$($AppName) - Required"
    $RefreshSchedule = New-CMSchedule -RecurInterval Hours -RecurCount 1
    
    if (-not $IsFreeApp) {
        $UserCollection = New-CMUserCollection -Name $UserCollectionName -LimitingCollectionId $UserLimitingCollectionId -RefreshSchedule $RefreshSchedule -RefreshType Periodic
        Move-CMObject -InputObject ($UserCollection) -FolderPath ".\UserCollection\Application"
    }
    
    $DeviceCollection = New-CMDeviceCollection -Name $DeviceCollectionName -LimitingCollectionId $DeviceLimitingCollectionId -RefreshSchedule $RefreshSchedule -RefreshType Periodic
    Move-CMObject -InputObject ($DeviceCollection) -FolderPath ".\DeviceCollection\Application"
    
    Set-Location -Path $env:SystemDrive
}
