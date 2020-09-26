<#
.SYNOPSIS
Invokes the teardown of a Map from store.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
TearDown-120-Map.ps1
#>

& $PSScriptRoot\Remove-Map.ps1 -mapFile "\\?\$PSScriptRoot\TestApplication.TestMap.xslt" -resourceGroupName "rg-aimmsgbus-dev-uksouth" -integrationAccountName "intacc-aimartifactstore-dev-uksouth-dmg"