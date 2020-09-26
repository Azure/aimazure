<#
.SYNOPSIS
Invokes the deployment of an schema to the store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-100-Schema.ps1
#>

& $PSScriptRoot\New-Schema.ps1 -requestBodyFile "\\?\$PSScriptRoot\requestbody.dev.json" -schemaFile "\\?\$PSScriptRoot\TestApplication.TestSchema.xsd" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -integrationAccountName "intacc-aimartifactstore-dev-uksouth"
