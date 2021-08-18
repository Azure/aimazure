<#
.SYNOPSIS
Invokes the deployment of an App Service Plan for Logic Apps for the Message Bus.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-30-MessageBusService-LogicAppPlan.ps1
#>

& $PSScriptRoot\New-MessageBusService-LogicAppPlan.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\messagebusservice.logicapp.plan.json" -templateParameterFile "$PSScriptRoot\messagebusservice.logicapp.plan.dev.parameters.json" -deploymentName "messagebusservice.logicapp.plan.uksouth.xxxxx"
