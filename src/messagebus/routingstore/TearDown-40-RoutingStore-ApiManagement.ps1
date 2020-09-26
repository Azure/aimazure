<#
.SYNOPSIS
Invokes the teardown of the API resource in API Management for a routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-40-RoutingStore-ApiManagement.ps1
#>

& $PSScriptRoot\Remove-RoutingStore-ApiManagement.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -serviceName "apim-aimmsgbussvc-dev" -apiName "aimroutingstore"
