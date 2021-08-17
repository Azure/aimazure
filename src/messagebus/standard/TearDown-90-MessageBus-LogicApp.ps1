<#
.SYNOPSIS
Invokes the teardown of the Message Bus logic app.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\TearDown-90-MessageBus-LogicApp.ps1
#>

& $PSScriptRoot\Remove-MessageBus-LogicApp.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-aff" -logicAppName "logic-messagebus-dev-aff"