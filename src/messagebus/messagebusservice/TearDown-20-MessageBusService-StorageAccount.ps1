<#
.SYNOPSIS
Invokes the teardown of the Storage Account resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-20-MessageBusService-StorageAccount.ps1
#>

& $PSScriptRoot\Remove-MessageBusService-StorageAccount.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth" -resourceName "staimmsgbussvcdev001"