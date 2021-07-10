<#
.SYNOPSIS
Invokes the teardown of a message suspend processors service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-80-SystemApplicationServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-SystemApplicationServiceBus-ApiConnection.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -resourceName "apic-systemapplicationservicebus-dev-xxxxx"