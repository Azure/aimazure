<#
.SYNOPSIS
Invokes the teardown of routing slip configuration from application configuration.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-RoutingSlip-AppConfig.ps1
#>

$params = Get-Content -Path $PSScriptRoot\routingslip.appcfg.dev.psparameters.json -Raw | ConvertFrom-Json

& $PSScriptRoot\Remove-RoutingSlip-AppConfig.ps1 -configStoreName $params.configStoreName -key $params.configKey -label $params.configLabel

