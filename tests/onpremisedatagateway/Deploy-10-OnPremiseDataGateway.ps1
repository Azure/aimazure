<#
.SYNOPSIS
Deploys the on premise data gateway and configures a local cluster.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.PARAMETER uniqueDeploymentId
The unique deployment id used in the automated deployment.

.EXAMPLE
.\Deploy-10-OnPremiseDataGateway.ps1 -uniqueDeploymentId "xxxxxx"
#>

[CmdletBinding()]
Param(
    [parameter(Mandatory = $true)]    
    [string] $uniqueDeploymentId  
)

$params = Get-Content -Path $PSScriptRoot\filegateway.opdg.dev.psparameters.json -Raw | ConvertFrom-Json

& $PSScriptRoot\New-OnPremiseDataGateway.ps1 -uniqueDeploymentId $uniqueDeploymentId -gatewayClusterNamePrefix $params.gatewayClusterNamePrefix -location $params.location