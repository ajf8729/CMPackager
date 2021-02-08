function Test-CMPPSAppDeployToolkit {
    <#
    .SYNOPSIS
    Checks to see if the PowerShell App Deployment Toolkit was used to wrap an application installation
    
    .DESCRIPTION
    Checks to see if the PowerShell App Deployment Toolkit was used to wrap an application installation
    
    .PARAMETER Path
    Application content path
    
    .EXAMPLE
    Test-CMPPSAppDeployToolkit -Path "\\ad.doman.tld\Shares\Apps\7-Zip\19.00\x64"
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    if (Test-Path -Path "$Path\AppDeployToolkit") {
        return $true
    }
    else {
        return $false
    }
}
