<#
.SYNOPSIS
Invokes the teardown of the API Management resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-30-MessageBusService-ApiManagement.ps1
#>

& $PSScriptRoot\Remove-MessageBusService-ApiManagement.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -resourceName "apim-aimmsgbussvc-dev"