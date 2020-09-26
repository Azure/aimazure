<#
.SYNOPSIS
Invokes the deployment of an App Service plan for Functions for the routing store, routing manager and messaging manager.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-30-MessageBusService-AppService.ps1
#>

& $PSScriptRoot\New-MessageBusService-AppService.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -templateFile "$PSScriptRoot\messagebusservice.plan.json" -templateParameterFile "$PSScriptRoot\messagebusservice.plan.dev.parameters.json" -deploymentName "messagebusservice.plan.uksouth.xxxxx"
