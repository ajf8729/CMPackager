function Get-CMPMsiFilename {
    <#
    .SYNOPSIS
    Get application MSI filename
    
    .DESCRIPTION
    Get application MSI filename
    
    .PARAMETER AppPath
    Path to application content location
    
    .PARAMETER Version
    Application version number
    
    .PARAMETER Architecture
    Application architecture
    
    .EXAMPLE
    Get-CMPMsiFilename -AppPath "\\ad.domain.tld\Shares\Apps\7-Zip" -Version "19.00" -Architecture x64
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$AppPath,
        [Parameter(Mandatory=$true)]
        [string]$Version,
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'x64',
            'x86'
        )]
        [string]$Architecture
    )
    
    $MsiPath = "$AppPath\$Version\$Architecture"
    
    if (Test-CMPPSAppDeployToolkit -Path $MsiPath) {
        return (Get-ChildItem -Path "$MsiPath\Files\*.msi" | Sort-Object -Descending Name | Select-Object -First 1 | Select-Object -ExpandProperty Name)
    }
    else {
        return (Get-ChildItem -Path "$MsiPath\*.msi" | Sort-Object -Descending Name | Select-Object -First 1 | Select-Object -ExpandProperty Name)
    }
}
