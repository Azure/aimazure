<#
.SYNOPSIS
Invokes the teardown of the App Service Plan for Logic Apps for the Message Bus.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./TearDown-30-MessageBusService-LogicAppPlan.ps1
#>

& $PSScriptRoot\Remove-MessageBusService-LogicAppPlan.ps1 -resourceGroup "rg-aimmsgbus-dev-uksouth-xxxxx" -resourceName "plan-logicapp-aimmsgbussvc-dev-xxxxx"