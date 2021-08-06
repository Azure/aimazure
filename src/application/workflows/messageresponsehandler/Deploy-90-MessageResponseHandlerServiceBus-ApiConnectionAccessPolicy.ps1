<#
.SYNOPSIS
Invokes the deployment of the messageresponsehandler service bus api connection access policy.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-90-MessageResponseHandlerServiceBus-ApiConnectionAccessPolicy.ps1
#>

& $PSScriptRoot\New-MessageResponseHandlerServiceBus-ApiConnectionAccessPolicy.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\messageresponsehandlerservicebus.apiconnectionaccesspolicy.json" -templateParameterFile "$PSScriptRoot\messageresponsehandlerservicebus.apiconnectionaccesspolicy.dev.parameters.json" -deploymentName "messageresponsehandlerservicebus.apicaccesspolicy.uksouth.xxxxx"