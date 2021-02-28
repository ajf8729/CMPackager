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
    
    $UserCollectionName   = "$($AppName) - Available"
    $DeviceCollectionName = "$($AppName) - Required"
    $RefreshSchedule = New-CMSchedule -RecurInterval Hours -RecurCount 1
    
    if (-not $IsFreeApp) {
        if (-not (Get-CMCollection -CollectionType User -Name $UserCollectionName)) {
            $UserCollection = New-CMCollection -CollectionType User -Name $UserCollectionName -LimitingCollectionId $UserLimitingCollectionId -RefreshSchedule $RefreshSchedule -RefreshType Periodic
        }
        else {
            Write-Error -Message "User collection ""$UserCollectionName"" already exists"
            break
        }
        
        if (-not (Test-Path -Path ".\UserCollection\Application")) {
            New-Item -Path ".\UserCollection\" -Name "Application" -ItemType Folder
        }
        
        if ($null -ne $UserCollection) {
            Move-CMObject -InputObject ($UserCollection) -FolderPath ".\UserCollection\Application"
        }
    }
    
    if (-not (Get-CMCollection -CollectionType Device -Name $DeviceCollectionName)) {
        $DeviceCollection = New-CMCollection -CollectionType Device -Name $DeviceCollectionName -LimitingCollectionId $DeviceLimitingCollectionId -RefreshSchedule $RefreshSchedule -RefreshType Periodic
    }
    else {
        Write-Error -Message "Device collection ""$DeviceCollectionName"" already exists"
        break
    }
    
    if (-not (Test-Path -Path ".\DeviceCollection\Application")) {
        New-Item -Path ".\DeviceCollection\" -Name "Application" -ItemType Folder
    }
    
    if ($null -ne $DeviceCollection) {
        Move-CMObject -InputObject ($DeviceCollection) -FolderPath ".\DeviceCollection\Application"
    }
}
