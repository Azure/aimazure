<#
.SYNOPSIS
Invokes the teardown of the Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-90-FlatFileDecoder-LogicApp.ps1
#>

& $PSScriptRoot\Remove-FlatFileDecoder-LogicApp.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth-xxxxx" -workflowName "logic-aimflatfiledecoder-dev-xxxxx"