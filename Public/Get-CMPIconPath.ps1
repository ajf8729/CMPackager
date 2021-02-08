function Get-CMPIconPath {
    <#
    .SYNOPSIS
    Get application icon file path
    
    .DESCRIPTION
    Get application icon file path
    
    .PARAMETER AppPath
    Path to application content location
    
    .EXAMPLE
    Get-CMPIconPath -AppPath "\\ad.domain.tld\Shares\Apps\7-Zip"
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$AppPath
    )
    
    if (Test-Path -Path "$AppPath\icon.png") {
        return "$AppPath\icon.png"
    }
    else {
        Write-Error -Message "Icon path not found"
        break
    }
}
