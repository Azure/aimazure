<#
.SYNOPSIS
Invokes the teardown of a message response handlers service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-80-MessageResponseHandlerServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-MessageResponseHandlerServiceBus-ApiConnection.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -resourceName "apic-aimmessageresponsehandler-dev-xxxxx"