function Get-CMPAppVersion {
    <#
    .SYNOPSIS
    Get latest application version number from content location
    
    .DESCRIPTION
    Get latest application version number from content location
    
    .PARAMETER AppPath
    Path to application content location
    
    .EXAMPLE
    Get-CMPAppVersion -AppPath "\\ad.domain.tld\Shares\Apps\7-Zip"
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$AppPath
    )
    
    return (Get-ChildItem -Path "$AppPath" -Directory | Sort-Object -Descending Name | Select-Object -First 1 | Select-Object -ExpandProperty Name)
}
