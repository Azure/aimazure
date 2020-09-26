<#
.SYNOPSIS
Invokes the teardown of send configuration entry configuration from application configuration.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER uniqueDeploymentId
The unique deployment id used in the automated deployment.

.EXAMPLE
.\TearDown-999-SendConfigurationEntry-AppConfig.ps1 -uniqueDeploymentId 'xxxxx'
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $uniqueDeploymentId
)

$params = Get-Content -Path $PSScriptRoot\sendconfigurationentry.appcfg.dev.psparameters.json -Raw | ConvertFrom-Json

$params.configStoreName = $params.configStoreName + $uniqueDeploymentId

& $PSScriptRoot\Remove-ConfigurationEntry-AppConfig.ps1 -configStoreName $params.configStoreName -key $params.configKey -label $params.configLabel

