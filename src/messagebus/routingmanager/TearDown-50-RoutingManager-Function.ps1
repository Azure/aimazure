<#
.SYNOPSIS
Invokes the teardown of the Function resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-50-RoutingManager-Function.ps1
#>

& $PSScriptRoot\Remove-RoutingManager-Function.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -resourceName "func-aimroutemgr-dev-001"