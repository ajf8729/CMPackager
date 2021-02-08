function Get-CMPMsiProductCode {
    <#
    .SYNOPSIS
    Get product code from an MSI file
    
    .DESCRIPTION
    Get product code from an MSI file
    
    .PARAMETER Path
    Full path to MSI file
    
    .EXAMPLE
    Get-CMPMsiProductCode -Path "\\ad.domain.tld\Shares\Apps\7-Zip\19.00\x64\7z1900-x64.msi"
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    #http://www.scconfigmgr.com/2014/08/22/how-to-get-msi-file-information-with-powershell/
    $WiObject = New-Object -ComObject WindowsInstaller.Installer
    $MsiDatabase = $WiObject.GetType().InvokeMember("OpenDatabase","InvokeMethod",$null,$WiObject,@($Path,0))
    $Query = "SELECT Value FROM Property WHERE Property = 'ProductCode'"
    $View = $MsiDatabase.GetType().InvokeMember("OpenView","InvokeMethod",$null,$MsiDatabase,($Query))
    $View.GetType().InvokeMember("Execute", "InvokeMethod", $null, $View, $null)
    $Record = $View.GetType().InvokeMember("Fetch","InvokeMethod",$null,$View,$null)
    $MsiProductCode = $Record.GetType().InvokeMember("StringData","GetProperty",$null,$Record,1)
    
    return $MsiProductCode.Trim()
}
