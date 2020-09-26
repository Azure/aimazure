<#
.SYNOPSIS
Invokes the teardown of the process manager logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-105-ProcessManager-LogicApp.ps1
#>

& $PSScriptRoot\Remove-ProcessManager-LogicApp.ps1 -resourceGroup "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -workflowName "logic-aimprocessmanager-processmanager-dev-xxxxx"