<#
.SYNOPSIS
Invokes the deployment of a message response handler service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-80-MessageResponseHandlerServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\New-MessageResponseHandlerServiceBus-ApiConnection.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\messageresponsehandlerservicebus.apiconnection.json" -templateParameterFile "$PSScriptRoot\messageresponsehandlerservicebus.apiconnection.dev.parameters.json" -deploymentName "messageresponsehandlersb.apiconnection.uksouth.xxxxx"