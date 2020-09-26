<#
.SYNOPSIS
Invokes the deployment of an API in API Management for the routing manager.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-60-RoutingManager-ApiManagement.ps1
#>

& $PSScriptRoot\New-RoutingManager-ApiManagement.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -apimServiceName "apim-aimmsgbussvc-dev" -apiName "aimroutingmanager" -templateFile "$PSScriptRoot\routingmanager.apim.json" -templateParameterFile "$PSScriptRoot\routingmanager.apim.dev.parameters.json" -deploymentName "routingmanager.apim.uksouth.xxxxx"
