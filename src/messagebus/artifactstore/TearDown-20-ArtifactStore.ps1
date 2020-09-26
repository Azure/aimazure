<#
.SYNOPSIS
Invokes the teardown of an artifact store for a message bus.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
TearDown-20-ArtifactStore.ps1
#>

& $PSScriptRoot\Remove-ArtifactStore.ps1 -integrationAccountName "intacc-aimartifactstore-dev-uksouth" -resourceGroup "rg-aimmsgbus-dev-uksouth"