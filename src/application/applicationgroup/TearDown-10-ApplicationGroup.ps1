<#
.SYNOPSIS
Invokes the teardown of a resource group for an application.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
TearDown-10-ApplicationGroup.ps1
#>

& $PSScriptRoot\Remove-ApplicationGroup.ps1 -resourceGroup "rg-aimapp-app1-dev"