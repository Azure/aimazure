<#
.SYNOPSIS
Invokes the teardown of the App Config resource for a routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-20-RoutingStore-AppConfig.ps1
#>

& $PSScriptRoot\Remove-RoutingStore-AppConfig.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -resourceName "appcfg-aimrstore-dev"