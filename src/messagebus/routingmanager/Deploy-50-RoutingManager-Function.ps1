<#
.SYNOPSIS
Invokes the deployment of a Function resource which implements the routing manager operations.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
./Deploy-50-RoutingManager-Function.ps1
#>

& $PSScriptRoot\New-RoutingManager-Function.ps1 -resourceGroupName "rg-aimmsgbus-dev-uksouth" -resourceName "func-aimroutemgr-dev-001" -templateFile "$PSScriptRoot\routingmanager.func.json" -templateParameterFile "$PSScriptRoot\routingmanager.func.dev.parameters.json" -deploymentName "routingmanager.func.uksouth.xxxxx" -zipFile "..\..\..\dist\functions\Microsoft.Azure.Aim.FunctionApp.RoutingManager.zip"
