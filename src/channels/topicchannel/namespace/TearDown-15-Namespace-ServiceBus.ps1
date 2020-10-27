<#
.SYNOPSIS
Invokes the teardown of the namespace resource.
.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.
.EXAMPLE
.\TearDown-20-Namespace-ServiceBus.ps1
#>

$params = Get-Content -Path $PSScriptRoot\namespace.sb.dev.psparameters.json -Raw | ConvertFrom-Json

& $PSScriptRoot\Remove-Namespace-ServiceBus.ps1 -resourceGroupName $params.resourceGroupName -namespace $params.namespace