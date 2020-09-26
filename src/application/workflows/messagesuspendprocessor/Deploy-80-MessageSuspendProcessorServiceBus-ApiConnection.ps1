<#
.SYNOPSIS
Invokes the deployment of a message response handler service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-80-MessageSuspendProcessorServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\New-MessageSuspendProcessorServiceBus-ApiConnection.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\messagesuspendprocessorservicebus.apiconnection.json" -templateParameterFile "$PSScriptRoot\messagesuspendprocessorservicebus.apiconnection.dev.parameters.json" -deploymentName "messagesuspendprocessorrsb.apiconnection.uksouth.xxxxx"