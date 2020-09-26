<#
.SYNOPSIS
Invokes the deployment of an API in API Management for the routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-40-RoutingStore-ApiManagement.ps1
#>

& $PSScriptRoot\New-RoutingStore-ApiManagement.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -apimServiceName "apim-aimmsgbussvc-dev" -apiName "aimroutingstore" -templateFile "$PSScriptRoot\routingstore.apim.json" -templateParameterFile "$PSScriptRoot\routingstore.apim.dev.parameters.json" -deploymentName "routingstore.apim.uksouth.xxxxx"
