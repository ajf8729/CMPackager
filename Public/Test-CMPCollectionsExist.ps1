function Test-CMPCollectionsExist {
    <#
    .SYNOPSIS
    Checks if application collections already exist
    
    .DESCRIPTION
    Checks if application collections already exist
    
    .PARAMETER UserCollectionProd
    Name of production application user collection
    
    .PARAMETER DeviceCollectionProd
    Name of production application device collection
    
    .EXAMPLE
    Test-CMPCollectionsExist -UserCollectionProd "All Users" -DeviceCollectionProd "7-Zip - Required"
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$UserCollectionProd,
        [Parameter(Mandatory=$true)]
        [string]$DeviceCollectionProd
    )
    
    if ( (-Not (Get-CMCollection -Name $UserCollectionProd)) -and (-Not (Get-CMCollection -Name $DeviceCollectionProd))) {
        Write-Error -Message "Collection '$UserCollectionClientProd' or '$DeviceCollectionProd' does not exist"
        return $false
    }
    else {
        return $true
    }
}
