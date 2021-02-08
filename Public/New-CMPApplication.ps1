function New-CMPApplication {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'EXE',
            'MSI'
        )]
        [string]$Type,
        [Parameter(Mandatory=$true)]
        [string]$Publisher,
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'x64',
            'x86'
        )]
        [string]$Architecture,
        [Parameter(Mandatory=$false)]
        [string]$RegKeyName,
        [Parameter(Mandatory=$false)]
        [switch]$RegKeyContainsVersion,
        [Parameter(Mandatory=$false)]
        [boolean]$Is64bit,
        [Parameter(Mandatory=$true)]
        [int]$EstimatedRuntimeMins,
        [Parameter(Mandatory=$true)]
        [int]$MaximumRuntimeMins,
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'ALL'
        )]
        [string]$DPGroup,
        [Parameter(Mandatory=$true)]
        [ValidateSet(
            'PROD',
            'TEST'
        )]
        [string]$Environment,
        [Parameter(Mandatory=$false)]
        [switch]$IsFreeApp
    )
    
    if ($IsFreeApp) {
        $UserCollectionProd   = "All Users"
    }
    else {
        $UserCollectionProd   = "$($Name) - Available"
    }
    $DeviceCollectionProd = "$($Name) - Required"
    
    $AppPath = "$ContentRootPath\$Name"
    $IconPath = Get-CMPIconPath -AppPath $AppPath
    $Version = Get-CMPAppVersion -AppPath $AppPath
    $AppName = "$Name $Version"
    $ContentLocation = "$AppPath\$Version\$Architecture"
    $DeploymentTypeName = "$Name $Version $Architecture"
    
    switch ($Type) {
        "EXE" {
            if ($RegItemContainsVersion) {
                $DetectionScriptText = New-CMPDetectionScript -RegistryKey "$RegKeyName $Version" -Version $Version -Is64bit $Is64bit
            }
            else {
                $DetectionScriptText = New-CMPDetectionScript -RegistryKey $RegKeyName -Version $Version -Is64bit $Is64bit
            }
        }
        "MSI" {
            $MsiFilename = Get-CMPMsiFilename -AppPath $AppPath -Version $Version -Architecture $Architecture
            
            if (Test-CMPPSAppDeployToolkit -Path $ContentLocation) {
                [string]$MsiProductCode = Get-CMPMsiProductCode -Path "$ContentLocation\Files\$MsiFilename"
            }
            else {
                [string]$MsiProductCode = Get-CMPMsiProductCode -Path "$ContentLocation\$MsiFilename"
            }
        }
    }
    
    Set-Location -Path "$($SiteCode):"
    
    if (Get-CMApplication -Name $AppName) {
        Write-Error -Message "Application '$AppName' already exists"
        Set-Location -Path $env:SystemDrive
        break
    }
    
    $CollectionExists = Test-CMPCollectionsExist -UserCollectionProd $UserCollectionProd -DeviceCollectionProd $DeviceCollectionProd
    
    if (-not $CollectionExists) {
        Set-Location -Path $env:SystemDrive
        break
    }
    
    New-CMApplication -Name $AppName -LocalizedName $Name -SoftwareVersion $Version -IconLocationFile $IconPath -ReleaseDate (Get-Date -Format yyyy-MM-dd) | Out-Null
    Set-CMApplication -Name $AppName -SoftwareVersion $Version -Publisher $Publisher | Out-Null
    
    switch ($Type) {
        "EXE" {
            switch ($Environment) {
                "PROD" {
                    Add-CMScriptDeploymentType -ApplicationName $AppName -DeploymentTypeName $DeploymentTypeName -InstallCommand $InstallScriptFilename -ScriptLanguage PowerShell -ScriptText $DetectionScriptText -ContentLocation $ContentLocation -EstimatedRuntimeMins $EstimatedRuntimeMins -MaximumRuntimeMins $MaximumRuntimeMins -LogonRequirementType WhetherOrNotUserLoggedOn -UserInteractionMode Hidden -InstallationBehaviorType InstallForSystem -ContentFallback -SlowNetworkDeploymentMode Download | Out-Null
                    New-CMApplicationDeployment -Name $AppName -CollectionName $UserCollectionProd -DeployAction Install -DeployPurpose Available -DistributeContent -DistributionPointGroupName $DPGroup | Out-Null
                    New-CMApplicationDeployment -Name $AppName -CollectionName $DeviceCollectionProd -DeployAction Install -DeployPurpose Required -OverrideServiceWindow $false -RebootOutsideServiceWindow $false -UserNotification DisplaySoftwareCenterOnly | Out-Null
                }
                "TEST" {
                    Add-CMScriptDeploymentType -ApplicationName $AppName -DeploymentTypeName $DeploymentTypeName -InstallCommand $InstallScriptFilename -ScriptLanguage PowerShell -ScriptText $DetectionScriptText -ContentLocation $ContentLocation -EstimatedRuntimeMins $EstimatedRuntimeMins -MaximumRuntimeMins $MaximumRuntimeMins -LogonRequirementType WhetherOrNotUserLoggedOn -UserInteractionMode Hidden -InstallationBehaviorType InstallForSystem -ContentFallback -SlowNetworkDeploymentMode Download | Out-Null
                    New-CMApplicationDeployment -Name $AppName -CollectionName $UserCollectionTest -DeployAction Install -DeployPurpose Available -DistributeContent -DistributionPointGroupName $DPGroup | Out-Null
                }
            }
        }
        "MSI" {
            switch ($Environment) {
                "PROD" {
                    Add-CMScriptDeploymentType -ApplicationName $AppName -DeploymentTypeName $DeploymentTypeName -InstallCommand $InstallScriptFilename -ProductCode $MsiProductCode.Trim() -ContentLocation $ContentLocation -EstimatedRuntimeMins $EstimatedRuntimeMins -MaximumRuntimeMins $MaximumRuntimeMins -LogonRequirementType WhetherOrNotUserLoggedOn -UserInteractionMode Hidden -InstallationBehaviorType InstallForSystem -ContentFallback -SlowNetworkDeploymentMode Download | Out-Null
                    New-CMApplicationDeployment -Name $AppName -CollectionName $UserCollectionProd -DeployAction Install -DeployPurpose Available -DistributeContent -DistributionPointGroupName $DPGroup | Out-Null
                    New-CMApplicationDeployment -Name $AppName -CollectionName $DeviceCollectionProd -DeployAction Install -DeployPurpose Required -OverrideServiceWindow $false -RebootOutsideServiceWindow $false -UserNotification DisplaySoftwareCenterOnly | Out-Null
                }
                "TEST" {
                    Add-CMScriptDeploymentType -ApplicationName $AppName -DeploymentTypeName $DeploymentTypeName -InstallCommand $InstallScriptFilename -ProductCode $MsiProductCode.Trim() -ContentLocation $ContentLocation -EstimatedRuntimeMins $EstimatedRuntimeMins -MaximumRuntimeMins $MaximumRuntimeMins -LogonRequirementType WhetherOrNotUserLoggedOn -UserInteractionMode Hidden -InstallationBehaviorType InstallForSystem -ContentFallback -SlowNetworkDeploymentMode Download | Out-Null
                    New-CMApplicationDeployment -Name $AppName -CollectionName $UserCollectionTest -DeployAction Install -DeployPurpose Available -DistributeContent -DistributionPointGroupName $DPGroup | Out-Null
                }
            }
        }
    }
    
    Set-Location -Path $env:SystemDrive
}
