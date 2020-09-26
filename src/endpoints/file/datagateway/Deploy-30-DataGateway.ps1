<#
.SYNOPSIS
Invokes the deployment of an on-premise data gateway.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-30-DataGateway.ps1
#>

$params = Get-Content -Path $PSScriptRoot\datagateway.onpremisedatagateway.dev.psparameters.json -Raw | ConvertFrom-Json
& $PSScriptRoot\New-DataGateway.ps1 -resourceGroupName $params.resourceGroupName  -subscriptionId "<azure-subs-id>" $params.connectionGatewayInstallationDisplayName -connectionGatewayInstallationLocation $params.connectionGatewayInstallationLocation -templateFile "$PSScriptRoot\datagateway.onpremisedatagateway.json" -templateParameterFile "$PSScriptRoot\datagateway.onpremisedatagateway.dev.parameters.json" -deploymentName "datagateway.uksouth.xxxxx"