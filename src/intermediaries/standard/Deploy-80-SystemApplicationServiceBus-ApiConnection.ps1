<#
.SYNOPSIS
Invokes the deployment of the system application service bus api connection.

.DESCRIPTION
Prior to running this script ensure you are authenticated against Azure and have the desired subscription set.

.EXAMPLE
.\Deploy-80-SystemApplicationServiceBus-ApiConnection.ps1
#>

& $PSScriptRoot\New-SystemApplicationServiceBus-ApiConnection.ps1 -resourceGroupName "rg-aimapp-systemapplication-dev-uksouth-xxxxx" -templateFile "$PSScriptRoot\systemapplicationservicebus.apiconnection.json" -templateParameterFile "$PSScriptRoot\systemapplicationservicebus.apiconnection.dev.parameters.json" -deploymentName "systemapplicationsb.apiconnection.uksouth.xxxxx"