<#
.SYNOPSIS
Invokes the teardown of the Logic App.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-85-MessageResponseHandler-LogicApp.ps1
#>

& $PSScriptRoot\Remove-MessageResponseHandler-LogicApp.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -workflowName "logic-aimmessageresponsehandler-dev-xxxxx"