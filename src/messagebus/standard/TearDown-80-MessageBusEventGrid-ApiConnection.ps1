<#
.SYNOPSIS
Invokes the teardown of a message bus event grid api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-80-MessageBusEventGrid-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-MessageBusEventGrid-ApiConnection.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth-aff" -resourceName "apic-messagebuseventgrid-dev-aff"