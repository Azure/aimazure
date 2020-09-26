<#
.SYNOPSIS
Invokes the teardown of a schema from store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
TearDown-100-Schema.ps1
#>

& $PSScriptRoot\Remove-Schema.ps1 -schemaFile "\\?\$PSScriptRoot\TestApplication.TestSchema.xsd" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -integrationAccountName "intacc-aimartifactstore-dev-uksouth"