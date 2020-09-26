<#
.SYNOPSIS
Invokes the teardown of the Key Vault resource for a routing store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-15-RoutingStore-KeyVault.ps1
#>

& $PSScriptRoot\Remove-RoutingStore-KeyVault.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -resourceName "kv-aimrstore-dev"