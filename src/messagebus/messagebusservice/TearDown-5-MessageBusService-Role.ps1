<#
.SYNOPSIS
Invokes the teardown of the Role resource.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-5-MessageBusService-Role.ps1
#>

& $PSScriptRoot\Remove-MessageBusService-Role.ps1 -role "Get Logic App Callback Url xxxxx"