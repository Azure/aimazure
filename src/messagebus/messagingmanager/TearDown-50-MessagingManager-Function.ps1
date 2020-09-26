<#
.SYNOPSIS
Invokes the teardown of the Function resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-50-MessagingManager-Function.ps1
#>

& $PSScriptRoot\Remove-MessagingManager-Function.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -resourceName "func-aimmsgmgr-dev-001"