<#
.SYNOPSIS
Invokes the teardown of a resource group for a message bus.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
TearDown-10-MessageBusGroup.ps1
#>

& $PSScriptRoot\Remove-MessageBusGroup.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth"