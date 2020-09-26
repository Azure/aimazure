<#
.SYNOPSIS
Invokes the deployment of a Map to the store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
Deploy-120-Map.ps1
#>

& $PSScriptRoot\New-Map.ps1 -requestBodyFile "\\?\$PSScriptRoot\requestbody.dev.json" -mapFile "\\?\$PSScriptRoot\TestApplication.TestMap.xslt" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -integrationAccountName "intacc-aimartifactstore-dev-uksouth"
