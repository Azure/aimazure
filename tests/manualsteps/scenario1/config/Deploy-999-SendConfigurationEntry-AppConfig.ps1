<#
.SYNOPSIS
Invokes the deployment of the send configuration entry.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER uniqueDeploymentId
The unique deployment id used in the automated deployment.

.EXAMPLE
.\Deploy-999-SendConfigurationEntry-AppConfig.ps1 -uniqueDeploymentId 'xxxxx'
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $uniqueDeploymentId
)

$params = Get-Content -Path $PSScriptRoot\sendconfigurationentry.appcfg.dev.psparameters.json -Raw | ConvertFrom-Json

$configFileName = $params.configValueFileName

$routingConfig = (Get-Content -Path "$PSScriptRoot\$configFileName" -Raw).Replace("`r`n", "").Replace('"', '""')

$params.configStoreName = $params.configStoreName + $uniqueDeploymentId

& $PSScriptRoot\New-ConfigurationEntry-AppConfig.ps1 -configStoreName $params.configStoreName -key $params.configKey -value $routingConfig -type $params.configType -label $params.configLabel -tags $params.configTags