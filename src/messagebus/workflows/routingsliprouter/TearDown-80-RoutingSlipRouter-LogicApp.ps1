<#
.SYNOPSIS
Invokes the teardown of the Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-80-RoutingSlipRouter-LogicApp.ps1
#>

& $PSScriptRoot\Remove-RoutingSlipRouter-LogicApp.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -workflowName "logic-aimroutingsliprouter-dev"