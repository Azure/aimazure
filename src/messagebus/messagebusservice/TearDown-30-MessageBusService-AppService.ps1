<#
.SYNOPSIS
Invokes the teardown of the App Service resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-30-MessageBusService-AppService.ps1
#>

& $PSScriptRoot\Remove-MessageBusService-AppService.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -resourceName "plan-aimmsgbussvc-dev"