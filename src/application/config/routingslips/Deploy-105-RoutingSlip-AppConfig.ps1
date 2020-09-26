<#
.SYNOPSIS
Invokes the deployment of routing slip configuration into app config.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-105-RoutingSlip-AppConfig.ps1
#>

# PowerShell 5 and earlier can't natively handle file/directory names over 260 chars. 
# To work around this, a prefix can be added to the path.
$longDirectoryNamePrefix = ""
If ($PSVersionTable.PSVersion.Major -le 5) {
    $longDirectoryNamePrefix = "\\?\"
}

$params = Get-Content -Path "$longDirectoryNamePrefix$PSScriptRoot\routingslip.appcfg.dev.psparameters.json" -Raw | ConvertFrom-Json

$configFileName = $params.configValueFileName

$routingConfig = (Get-Content -Path "$longDirectoryNamePrefix$PSScriptRoot\$configFileName" -Raw).Replace("`r`n", "").Replace('"', '""')

& $PSScriptRoot\New-RoutingSlip-AppConfig.ps1 -configStoreName $params.configStoreName -key $params.configKey -value $routingConfig -type $params.configType -label $params.configLabel -tags $params.configTags