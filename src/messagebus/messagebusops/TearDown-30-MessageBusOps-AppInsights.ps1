<#
.SYNOPSIS
Invokes the teardown of the App Insights resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-30-MessageBusOps-AppInsights.ps1
#>

& $PSScriptRoot\Remove-MessageBusOps-AppInsights.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -resourceName "appi-aimmsgbusops-dev"