<#
.SYNOPSIS
Invokes the deployment of a App Config resource for the routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-20-RoutingStore-AppConfig.ps1
#>

& $PSScriptRoot\New-RoutingStore-AppConfig.ps1 -subscriptionId "<azure-subs-id>" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -appConfigName "appcfg-aimrstore-dev" -keyVaultName "kv-aimrstore-dev" -templateFile "$PSScriptRoot\routingstore.appcfg.json" -templateParameterFile "$PSScriptRoot\routingstore.appcfg.dev.parameters.json" -deploymentName "routingstore.appcfg.uksouth.xxxxx"
