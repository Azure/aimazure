<#
.SYNOPSIS
Invokes the teardown of the event grid subscribe api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-80-EventGridSubscribe-ApiConnection.ps1
#>

& $PSScriptRoot\Remove-EventGridSubscribe-ApiConnection.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth-aff" -resourceName "apic-eventgridsubscribe-dev-aff"