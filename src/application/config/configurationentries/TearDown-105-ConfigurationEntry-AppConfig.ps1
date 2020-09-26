<#
.SYNOPSIS
Invokes the teardown of a configuration entry from application configuration.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-ConfigurationEntry-AppConfig.ps1
#>

$params = Get-Content -Path $PSScriptRoot\configurationEntry.appcfg.dev.psparameters.json -Raw | ConvertFrom-Json

& $PSScriptRoot\Remove-ConfigurationEntry-AppConfig.ps1 -configStoreName $params.configStoreName -key $params.configKey -label $params.configLabel

